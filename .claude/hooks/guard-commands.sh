#!/usr/bin/env bash
# App Director command guard · Claude Code PreToolUse hook on Bash · framework-owned: replaced on upgrade.
#
# Permission rules match how a command starts, so `git commit -m x --no-verify` or
# `git push origin main --force` would slip past them. This hook looks at the whole command and
# blocks what rules.md › Git reserves for the human: rewriting history, discarding work, and
# skipping the check. It pattern-matches the text, so it's a strong safety net, not a guarantee.
# It starts no other processes (it runs on every Bash call).
#
# It also blocks the git flags that write a file, read a file outside the repository or run a
# configured command (--output, --no-index, --ext-diff, commit and tag -F and --file, grep -O and
# --open-files-in-pager), because the allow rules in settings.json let `git diff *`, `git log *`,
# `git show *`, `git commit *`, `git tag *`, `git grep *` and `git stash *` run with any flag. See the
# section "git: flags that write a file" below. And a `bash` or `sh` command whose script path under
# tools/ leaves it with `..`, because `bash tools/stacks/*.sh*` would match `tools/stacks/../../x.sh`.
#
# Also blocks shell commands, Bash or PowerShell, that read credential files directly (.env and .env.<suffix>,
# *.pem, *.key, ~/.ssh, git's credentials files, the gh CLI's hosts.yml) and the commands that print a stored
# credential (gh auth token, gh auth status -t, git credential fill or get). This is a guardrail, not a
# guarantee: complex pipelines or indirect reads are not detected. The Read-tool deny rules in settings.json
# cover the most common path.
#
# A command substitution ($(...), `...`, <(...), >(...); PowerShell's $(...), @(...) and (...)) runs a command the
# guard can't see, and what it prints is text the rules can't read (B32). In a git command's words it can be a flag, and
# as a command's name it can be git. So the substitutions are read out of the command, each one's text is read as a
# command of its own, and in a git command's words only a double-quoted one that starts with fixed text (or a commit's
# or tag's -m value) passes, and only when its text is a plain read. In Bash a comment holds no substitution, and its quotes
# open no string (B43). See the section "Substitutions" below.
#
# A quoted script given to a shell or an interpreter (bash -c, sh -c, zsh -c, eval, powershell -Command, pwsh -c, cmd /c)
# is a command of its own: each is read as one, and a script nested in one to four levels too (B34). See the section
# "Shell wrappers" below. A wait loop in such a script is judged too, and a script under timeout 280 or less is bounded (B42).
#
# A variable in a git command's words holds a value the guard can't read (B37). A variable that the command assigns once,
# to a plain value, is read as that value (FLAG=--force; git push $FLAG is git push --force). Any other variable in the words
# of a git subcommand whose flags the rules read is blocked when it's unquoted, or quoted where a flag or a path could be; a
# variable as the subcommand, and a variable as a command's name followed by -c or -Command, are blocked too. See the
# section "Variables" below.
#
# A git -c key, or --config-env, that names a program git runs (an alias that starts with !, core.pager, core.sshCommand,
# diff.external, a credential helper) runs a command of the caller's choice, so the keys are an allow list: only the keys that
# run nothing pass, and a key a variable holds is blocked (B38). The flags that name a program for a remote (--upload-pack,
# --receive-pack, --exec, and clone's -u) are blocked on fetch, pull, push, clone, ls-remote and archive, abbreviations too. A
# variable that names a program git runs (GIT_CONFIG_*, GIT_SSH_COMMAND, GIT_PAGER, EDITOR and the like) set on a git command is
# blocked. See the section "Git configuration and program flags" below.
#
# The git name is read as the shell reads it, quotes removed, so "git", 'git' and g"it" are git (B39). A heredoc body a shell
# runs (any body but a commit's or tag's message) takes a backtick as the end of a flag, and its words and the file-writing flags
# are read there too; git branch with a delete and a force flag, git push --mirror, --delete and -d, and a :ref refspec are
# blocked, and the credential-print rules read the decoded words (B39, where the git rules below read the bodies and the words).
# A heredoc body that no shell runs is text (B40): a commit's or tag's message, and a cat or tee body that the command doesn't
# run (no shell, interpreter, ssh, chmod, make or npm, call operator, ./ path, dot-source or .git folder names it). The destructive rules and
# the file-writing flag rules skip such a body; the substitutions in it are still read (B32).

IFS= read -r -d '' input || true
re='"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)"'
[[ $input =~ $re ]] || exit 0
raw="${BASH_REMATCH[1]}"

# The tool's name (B28): only PowerShell reads a backtick at a line's end as a continuation, and the readings below
# depend on it. The name is a JSON string, matched as the command is.
tre='"tool_name"[[:space:]]*:[[:space:]]*"([^"]*)"'
tool=""; [[ $input =~ $tre ]] && tool="${BASH_REMATCH[1]}"

# PowerShell (B28, B35): a backtick that ends a line continues it, as a backslash does in Bash (B25). PowerShell's
# parser agrees when the backtick isn't escaped: an odd run of backticks before the line break joins it, so
# `` (an escaped backtick) keeps the break, and a backtick followed by spaces doesn't continue. In Bash a
# backtick is command substitution, so the text stays. Its readings are made below with Bash's (B31).
bt='`'; x3=$'\x03'

# The readings of the command (B31, B35). A backslash at a line's end continues the command in Bash (B25), but a comment
# holds its backslash: Bash ends a comment at the line break, so `# note\` is a comment and the next line is a command
# of its own. Joining that line onto the comment would hide it. PowerShell's backtick does the same (B28, B35), since it
# ends its comment at the line break too. So each rule reads every reading in turn, and no reading joins two lines that
# the shell keeps apart:
#   as written: every line break kept, so a command after a comment shows on its own line;
#   as joined: every continuation joined, as the shell reads a command that holds no comment (PowerShell's escapes too);
#   from each line after one that holds a comment marker and ends in a continuation: joined from that line on, since
#     the comment may have ended that line (the joined reading glues `git` onto a comment's last word: `# a`, `git`).
# A # inside a word (a#b) is no comment, so its continuation is joined in the joined reading, as the shell joins it.
# x1 is a command backslash, x2 an escaped pair (two backslashes) and x4 a continuation's mark before a line break.
bs='\'; x1=$'\x01'; x2=$'\x02'; x4=$'\x04'; nl=$'\n'
view_of() {
  local s="" k line jb=$'\x5c\x5c' jb4=$'\x5c\x5c\x5c\x5c' bsl=$'\x5c'
  for ((k = $1; k < nphys; k++)); do
    line="${phys[k]}"
    if [[ $line == *"$x4" ]]; then
      line="${line%"$x4"}"
      if (($2)); then s+="$line"; continue; fi
    fi
    s+="$line"
    if ((k < nphys - 1)); then s+="$nl"; fi
  done
  s="${s//$x2/"$jb4"}"; s="${s//$x1/"$jb"}"; s="${s//$nl/"$bsl"n}"
  view="$s"
}

# ps_clean <view>: sets joined to a joined view as PowerShell reads it (B28, B30): a backtick before a letter, digit or name
# punctuation is an escape that leaves that character, so Get-Con`tent is Get-Content, and .en`v.local names .env.local. A
# backtick before a quote, a $, a space or a separator stays, since it escapes only that character and joins no name.
# A doubled backtick is an escaped one, so it's set aside first.
ps_clean() {
  local c t="$1"
  t="${t//"$bt$bt"/$x3}"
  if [[ $t == *"$bt"* ]]; then
    for c in {a..z} {A..Z} {0..9} . _ / '\' : '*' '?' '~' % @ + = , '#' -; do
      t="${t//"$bt$c"/"$c"}"
    done
  fi
  t="${t%"$bt"}"   # a backtick at the very end escapes nothing, so `git push `echo --force` reads as git push echo --force (B32)
  joined="${t//$x3/$bt$bt}"
}

# reading_of <k> <join>: sets view to the reading view_of makes from line k (0 for the whole command), joined when <join>
# is 1. A joined reading of PowerShell is read with its escapes removed as PowerShell reads them (ps_clean).
reading_of() {
  view_of "$1" "$2"
  if (($2)) && [[ $tool == PowerShell ]]; then ps_clean "$view"; view="$joined"; fi
}

# --- Substitutions (B32) -------------------------------------------------------------------------
# A command substitution runs a command the guard can't see, and what it prints is text the rules can't read. In a git
# command's words it can be a flag (git push "$(echo --force)"), and as a command's name it can be git ($(echo git) push).
# subst_cut reads every substitution out of the command, before the quote reading below: each becomes a placeholder
# \x1a<n>\x1b in cut_out, its text goes to subc[n] (the quoted strings inside it are skipped as the shell skips them, so
# its end is the shell's), and its kind to subk[n]: u when unquoted, or, inside double quotes, the kind of its word: d
# when the word starts with fixed text that isn't a dash (or the word is --name=<value>), m when -m or --message is the
# word before it, x otherwise. Each text is also read as a command of its own (a view), so git's rules judge the git in it.
brackets='[(){}`]'
MSG_CMD="a command substitution is the command name, so the guard can't tell which command runs"
MSG_POS="a command substitution in a git command's words prints text the guard can't read, and that text can be a flag; write the value out, or put it in double quotes after fixed text, such as ddd/bundle-\$(date +%F)"
MSG_MSG="a command substitution is a commit's or tag's message only as the value of -m, with no option before -m that takes a value"
MSG_READ="a command substitution in a git command's words runs a command the guard can't judge; only git, date, cat, echo and printf are read there"
MSG_UNREAD="the guard can't read a command substitution here: it's unclosed, or it holds a backtick, or a double-quoted string with a substitution"

# cmt_start <text> <i>: 0 when the # at <i> starts a Bash comment (B43). It starts a word, which a # does at the text's start,
# or after a blank, a line break, or ; & | ( that isn't escaped. A # after a ) joins its word (the ) that closes a
# substitution ends none), and a # inside a word (a#b, ${#x}, $#) starts no comment. Nor does one inside ${...} (x:- #a),
# which the readers track (pbr, pb): a blank there is part of the expansion.
cmt_start() {
  local s="$1" i=$2 k b=0
  ((i == 0)) && return 0
  case ${s:i-1:1} in ' ' | $'\t' | "$nl" | ';' | '&' | '|' | '(') ;; *) return 1 ;; esac
  k=$((i - 2))
  while ((k >= 0)) && [[ ${s:k:1} == '\' ]]; do b=$((b + 1)); k=$((k - 1)); done
  ((b % 2 == 0))
}

# sub_end <text> <start> [1]: sub_e is the index of the ) that closes a substitution whose text starts at <start>. Quoted strings
# and escapes are skipped, so a ) inside them doesn't count. Returns 1 when it doesn't close, or when a double-quoted string
# in it holds a substitution or a backtick. With a third argument of 1 (Bash, B43) a comment inside the substitution runs to its
# line break, so a ) or a backtick in it closes nothing and starts nothing.
sub_end() {
  local s="$1" j=$2 L=${#s} depth=1 c k cm=${3:-0} pb=0
  while ((j < L)); do
    c="${s:j:1}"
    if [[ $c == "$sesc" ]]; then ((j += 2)); continue; fi
    if ((cm && pb == 0)) && [[ $c == '#' ]] && cmt_start "$s" "$j"; then
      k="${s:j}"; k="${k%%"$nl"*}"; ((j += ${#k})); continue
    fi
    case $c in
      '$')
        if [[ ${s:j+1:1} == '{' ]]; then ((pb++, j += 2)); continue; fi ;;
      '}') ((pb > 0)) && ((pb--)) ;;
      "'")
        k="${s:j+1}"; [[ $k == *"'"* ]] || return 1
        k="${k%%"'"*}"; ((j += ${#k} + 2)); continue ;;
      '"')
        k=$((j + 1))
        while ((k < L)) && [[ ${s:k:1} != '"' ]]; do
          if [[ ${s:k:1} == "$sesc" ]]; then ((k++))
          elif [[ ${s:k:1} == '`' || ${s:k:2} == '$(' ]]; then return 1; fi
          ((k++))
        done
        ((k < L)) || return 1
        j=$((k + 1)); continue ;;
      '`') return 1 ;;
      '(') ((depth++)) ;;
      ')')
        ((depth--))
        if ((depth == 0)); then sub_e=$j; return 0; fi ;;
    esac
    ((j++))
  done
  return 1
}

# subst_cut <text>: cut_out is the text with each substitution as a placeholder, and subc and subk are set (above). A
# single quote starts a quoted string outside double quotes and is skipped whole, so a substitution inside it isn't one.
# Returns 1 when a substitution can't be read (see MSG_UNREAD). In Bash a comment is copied as text (B43): a backtick, a
# $( or a quote in it starts nothing. A heredoc body with a substitution is read whole, as the shell expands it, so the
# comment reading is off for a command with one (hsubb, set where the bodies are collected).
subst_cut() {
  local s="$1" i=0 L ch nx t st e txt kind start wsf lit before pwd dqkind="" indq=0 dqpos=0 cmtc=0 pbr=0
  if [[ $tool == PowerShell ]]; then sesc='`'; else sesc='\'; fi
  if [[ $tool != PowerShell ]] && ((${hsubb:-0} == 0)); then cmtc=1; fi
  L=${#s}; cut_out=""; sn=0; subc=(); subk=()
  while ((i < L)); do
    ch="${s:i:1}"; nx="${s:i+1:1}"
    if [[ $ch == "$sesc" ]]; then cut_out+="${s:i:2}"; ((i += 2)); continue; fi
    if ((indq)); then
      if [[ $ch == '"' ]]; then indq=0; cut_out+='"'; ((i++)); continue; fi
    elif [[ $ch == "'" ]]; then
      t="${s:i+1}"; [[ $t == *"'"* ]] || { cut_out+="${s:i}"; break; }
      t="${t%%"'"*}"; cut_out+="'$t'"; ((i += ${#t} + 2)); continue
    elif [[ $ch == '"' ]]; then
      indq=1; dqpos=${#cut_out}; dqkind=""; cut_out+='"'; ((i++)); continue
    elif [[ $ch == '$' && $nx == '{' ]]; then pbr=$((pbr + 1)); cut_out+='${'; ((i += 2)); continue
    elif ((pbr > 0)) && [[ $ch == '}' ]]; then pbr=$((pbr - 1)); cut_out+='}'; ((i++)); continue
    elif ((cmtc && pbr == 0)) && [[ $ch == '#' ]] && cmt_start "$s" "$i"; then
      t="${s:i}"; t="${t%%"$nl"*}"; cut_out+="$t"; ((i += ${#t})); continue
    fi
    st=0
    if [[ $ch == '$' && $nx == '(' ]]; then st=$((i + 2))
    elif ((!indq)) && [[ $tool == PowerShell && $ch == '(' ]]; then st=$((i + 1))
    elif ((!indq)) && [[ $tool != PowerShell && ( $ch == '<' || $ch == '>' ) && $nx == '(' ]]; then st=$((i + 2))
    fi
    if ((st > 0)); then
      sub_end "$s" "$st" "$cmtc" || return 1
      e=$sub_e; txt="${s:st:e-st}"
    elif [[ $ch == '`' && $tool != PowerShell ]]; then
      t="${s:i+1}"; [[ $t == *'`'* ]] || return 1
      txt="${t%%\`*}"; e=$((i + ${#txt} + 1))
    else
      cut_out+="$ch"; ((i++)); continue
    fi
    kind=u
    if ((indq)); then
      if [[ -z $dqkind ]]; then
        before="${cut_out:0:dqpos}"; lit="${cut_out:dqpos+1}"; lit="${lit//\\/}"
        wsf="${before##*[[:space:];&|]}"
        start="$wsf$lit"; start="${start%%$'\x1a'*}"
        t="${before%"${before##*[![:space:]]}"}"; pwd="${t##*[[:space:];&|]}"
        if [[ $wsf == *[\'\"\\]* ]]; then dqkind=x
        elif [[ -n $start && ( $start != -* || $start == --*=* ) ]]; then dqkind=d
        elif [[ $before == *[[:space:]] && ( $pwd =~ ^-[[:alpha:]]*m$ || $pwd == --message ) ]]; then dqkind=m
        else dqkind=x; fi
      fi
      kind=$dqkind
    fi
    subc[sn]="$txt"; subk[sn]=$kind
    cut_out+=$'\x1a'"$sn"$'\x1b'; ((sn++))
    i=$((e + 1))
  done
  return 0
}

# subst_read <text>: the text a substitution runs is a read the guard judges: git (as a command of its own, in a view),
# date, cat, echo or printf, with no separator, no redirect and no nested substitution.
subst_read() {
  local c="$1" c2
  c="${c#"${c%%[![:space:]]*}"}"; c="${c%"${c##*[![:space:];]}"}"
  [[ $c =~ ^(git|date|cat|echo|printf)([[:space:]]|$) ]] || return 1
  c2="${c//<</}"
  [[ $c2 == *'$('* || $c2 == *'`'* || $c2 == *[\;\&\|\<\>\(\)$nl]* ]] && return 1
  return 0
}

# walk_msg <j>: word j is a placeholder that's the value of a commit's or tag's -m. -m must be the word before it, and
# every option between the subcommand and -m must take no value, since one that does would take -m as its value.
walk_msg() {
  local j=$1 i
  case $bsub in commit | tag) ;; *) return 1 ;; esac
  ((j - 1 > bsk)) || return 1
  [[ ${w[j - 1]} =~ ^-[aqsvefiSo]*m$ || ${w[j - 1]} == --message ]] || return 1
  for ((i = bsk + 1; i < j - 1; i++)); do
    case ${w[i]} in
      --amend | --all | --quiet | --verbose | --signoff | --no-edit | --edit | --allow-empty | --include | --only) continue ;;
      -*) [[ ${w[i]} =~ ^-[aqsvefiSo]+$ ]] || return 1 ;;
    esac
  done
  return 0
}

# subst_segment: the substitutions among one segment's words (w, n). A command name can't be one. In a git command's
# words (bsk is its subcommand's index, bsub the subcommand) only a d or m value passes, and only when its text is a read.
subst_segment() {
  local cw=0 gi=-1 j rest idx
  while ((cw < n)) && [[ ${w[cw]} =~ ^(([A-Za-z_][A-Za-z0-9_]*=.*)|\$|env|time|nohup|exec|command|sudo|if|then|else|elif|do|while|until|!)$ ]]; do ((cw++)); done
  [[ ${w[cw]:-} == *$'\x1a'* ]] && block "$MSG_CMD"
  for ((j = 0; j < n; j++)); do [[ ${w[j]} == git ]] && { gi=$j; break; }; done
  ((gi < 0)) && return 0
  bsk=$((gi + 1))
  while ((bsk < n)); do case ${w[bsk]} in -C | -c) ((bsk += 2)) ;; -*) ((bsk++)) ;; *) break ;; esac; done
  bsub="${w[bsk]:-}"
  for ((j = gi + 1; j < n; j++)); do
    rest="${w[j]}"
    while [[ $rest == *$'\x1a'* ]]; do
      idx="${rest#*$'\x1a'}"; idx="${idx%%$'\x1b'*}"; rest="${rest#*$'\x1b'}"
      case ${subk[idx]} in
        d) subst_read "${subc[idx]}" || block "$MSG_READ" ;;
        m) walk_msg "$j" || block "$MSG_MSG"; subst_read "${subc[idx]}" || block "$MSG_READ" ;;
        *) block "$MSG_POS" ;;
      esac
    done
  done
}

# --- Variables (B37) ----------------------------------------------------------------------------
# A variable in a git command's words holds a value the guard can't read, and that value can be a flag (git push $FLAG
# with FLAG=--force) or a path outside the repository. var_resolve first replaces each variable the command assigns once,
# to a plain value (letters, digits and - _ . / : = + @ % , ~), with that value wherever it's used, as the shell expands
# it, so the rules above judge what git gets. A name set another way (read, for, +=), set twice, or to any other value
# stays a variable. var_judge then judges each variable left in a git command's words, and in a body a shell runs: an
# unquoted one is blocked, since the shell splits it into several words, and a quoted one is blocked where its value could
# be a flag or a path. It passes as the value of an option that takes the next word whole (-m, -e, -b, -C and the like),
# after -- (paths), as a push's branch after its remote, and after fixed text that doesn't start a flag ("ddd/bundle-$day",
# "--since=$since"). A variable as the subcommand is blocked. Only the subcommands in vb_scope are judged: those whose flags a
# rule reads (--output, -F, -O, -D and the like). A variable in another subcommand's words, such as git status or git add,
# passes, since no rule reads the flags they take.
vb_scope=" archive commit diff format-patch grep log show tag stash branch checkout switch restore reset clean push "
MSG_VAR="a variable in a git command's words holds a value the guard can't read, and it can be a flag or a path: write the value out, quote it as the value of -m, -e or -b, or put it after --"
MSG_SUB="a variable as a git command's subcommand holds a value the guard can't read"
MSG_SHVAR="a variable as a command's name, followed by -c or -Command, runs a shell or an interpreter the guard can't tell apart"
vsh_pre_re='\$[^[:space:]]*[[:space:]]+-[a-zA-Z]*[cC]'
vsh_prefix_re='^([A-Za-z_][A-Za-z0-9_]*=.*|env|exec|command|sudo|nohup|time|timeout|nice|ionice|stdbuf|-.*|[0-9.]+[smhd]?)$'
vsh_opt_re='^-[a-zA-Z]*[cC]'

# var_sub <text>: sets vbout to the text with each reference to a name in kn replaced by its value in kv (the other
# references stay as they are).
var_sub() {
  local s="$1" nm orig k
  vbout=""
  while [[ $s == *'$'* ]]; do
    vbout+="${s%%\$*}"; s="${s#*\$}"
    if [[ $s =~ ^\{([A-Za-z_][A-Za-z0-9_]*)\} ]]; then orig="${BASH_REMATCH[0]}"; nm="${BASH_REMATCH[1]}"
    elif [[ $s =~ ^([A-Za-z_][A-Za-z0-9_]*) ]]; then orig="${BASH_REMATCH[1]}"; nm="$orig"
    else vbout+='$'; continue; fi
    for ((k = 0; k < ${#kn[@]}; k++)); do [[ ${kn[k]} == "$nm" ]] && break; done
    if ((k < ${#kn[@]})); then vbout+="${kv[k]}"; else vbout+="\$$orig"; fi
    s="${s:${#orig}}"
  done
  vbout+="$s"
}

# var_resolve: a name the command assigns once, with a plain value, is replaced by that value in cut_out and hall (the
# bodies a shell runs). The name must occur once as a word that isn't a reference, and that occurrence must be the
# assignment NAME=value at a word's start, with its value ending at a space or a separator. kn and kv get the names.
var_resolve() {
  local all="$cut_out"$'\n'"$hall"$'\n'"${subc[*]}" rest n w t re cnt seen=" " cand_re
  local -a cand=()
  cand_re='(^|[[:space:];&|()])([A-Za-z_][A-Za-z0-9_]*)\+?='
  rest="$all"
  while [[ $rest =~ $cand_re ]]; do
    cand+=("${BASH_REMATCH[2]}")
    rest="${rest#*"${BASH_REMATCH[0]}"}"
  done
  kn=(); kv=()
  for n in "${cand[@]}"; do
    [[ $seen == *" $n "* ]] && continue
    seen+="$n "
    t="${all//"\${$n}"/ }"; t="${t//"\$$n"/ }"; t="${t//[^[:alnum:]_]/ }"
    cnt=0
    for w in $t; do [[ $w == "$n" ]] && cnt=$((cnt + 1)); done
    ((cnt == 1)) || continue
    re="(^|[[:space:];&|()])${n}=([-A-Za-z0-9_./:=+@%,~]*)([[:space:];&|()<>]|\$)"
    [[ $all =~ $re ]] || continue
    kn+=("$n"); kv+=("${BASH_REMATCH[2]}")
  done
  ((${#kn[@]})) || return 0
  if [[ $cut_out == *'$'* ]]; then var_sub "$cut_out"; cut_out="$vbout"; fi
  if [[ $hall == *'$'* ]]; then var_sub "$hall"; hall="$vbout"; fi
  if [[ $hdc == *'$'* ]]; then var_sub "$hdc"; hdc="$vbout"; fi
  if [[ $hnm == *'$'* ]]; then var_sub "$hnm"; hnm="$vbout"; fi
  return 0
}

# vend, vref and var_walk: var_walk reads the words of a text as the shell does (quotes removed, and a line break or ; & |
# ( ) ends a segment). Each variable reference is \x07 in its word. vbs, vbw and vbu get each word's segment, its text and
# whether a reference in it is unquoted (a double-quoted one is only a marker). A redirect's target is no word here. vend,
# vref and var_walk share their locals, which is how vend and vref see the word being read (bash's dynamic scope).
vend() {
  if ((st)); then
    if ((skipnext)); then skipnext=0
    else vbs+=("$seg"); vbw+=("$w"); vbu+=("$uq"); fi
  fi
  st=0; w=""; uq=0
}
vref() { # at a $ (s[i]): a variable reference adds \x07 to the word and moves past itself; returns 1 when there is none
  local rest="${s:i}"
  if [[ $rest =~ ^\$\{[^}]*\} || $rest =~ ^\$[A-Za-z_][A-Za-z0-9_]* || $rest =~ ^\$[0-9@*#?!$-] ]]; then
    i=$((i + ${#BASH_REMATCH[0]})); w+=$'\x07'; st=1
    ((inq)) || uq=1
    return 0
  fi
  return 1
}
var_walk() {
  local s="$1" L=${#1} i=0 c n ch k content w="" uq=0 st=0 seg=0 skipnext=0 inq=0
  local sesc='\'
  [[ $tool == PowerShell ]] && sesc='`'
  vbs=(); vbw=(); vbu=()
  while ((i < L)); do
    c="${s:i:1}"; n="${s:i+1:1}"
    if ((inq)); then
      if [[ $c == '"' ]]; then
        if [[ $tool == PowerShell && $n == '"' ]]; then w+='"'; ((i += 2)); continue; fi
        inq=0; ((i++)); continue
      fi
      if [[ $c == "$sesc" ]]; then
        if [[ $tool == PowerShell ]]; then
          [[ -n $n && $n != "$nl" ]] && w+="$n"; ((i += 2)); continue
        fi
        case $n in
          '$' | '"' | "$sesc" | '`') w+="$n"; ((i += 2)); continue ;;
          "$nl") ((i += 2)); continue ;;
        esac
      fi
      if [[ $c == '$' ]] && vref; then continue; fi
      w+="$c"; ((i++)); continue
    fi
    case $c in
      ' ' | $'\t') vend; ((i++)) ;;
      "$nl" | ';' | '&' | '|' | '(' | ')') vend; skipnext=0; ((seg++)); ((i++)) ;;
      '<' | '>') vend; skipnext=1; ((i++)) ;;
      '#')
        if ((st)); then w+='#'; ((i++))
        else k="${s:i}"; k="${k%%"$nl"*}"; ((i += ${#k})); fi ;;
      "$sesc")
        if [[ -z $n ]]; then ((i++))
        elif [[ $n == "$nl" ]]; then ((i += 2))
        else w+="$n"; st=1; ((i += 2)); fi ;;
      "'")
        k=$((i + 1)); content=""
        while ((k < L)); do
          ch="${s:k:1}"
          if [[ $ch == "'" ]]; then
            if [[ $tool == PowerShell && ${s:k+1:1} == "'" ]]; then content+="'"; ((k += 2)); continue; fi
            break
          fi
          content+="$ch"; ((k++))
        done
        w+="$content"; st=1; i=$((k + 1)) ;;
      '"') inq=1; st=1; ((i++)) ;;
      '$')
        if [[ $tool != PowerShell && ( $n == "'" || $n == '"' ) ]]; then ((i++))   # $'...' and $"...": the quote follows
        elif vref; then :
        else w+='$'; st=1; ((i++)); fi ;;
      *) w+="$c"; st=1; ((i++)) ;;
    esac
  done
  vend
}

# vtaker <subcommand> <word>: the word is an option that takes its value from the next word, or attached to it.
vtaker() {
  case $1 in
    commit) [[ $2 =~ ^-[aqsvefiSo]*[mCc]$ || $2 == --message ]] ;;
    tag) [[ $2 =~ ^-[aqsvefiSo]*m$ || $2 == --message ]] ;;
    checkout | switch) [[ $2 =~ ^-[a-zA-Z]*[bBcC]$ ]] ;;
    grep) [[ $2 =~ ^-[a-zA-Z]*e$ ]] ;;
    *) false ;;
  esac
}

# var_segment <first word> <last word>: the git command in one segment, if it has one, and its subcommand. In its words a
# variable is blocked when it is unquoted, a subcommand, or a quoted one that a flag or a path could be: a quoted variable
# alone, a fixed text that starts a flag without =, or no text before it. A quoted variable passes as a value taken by the
# option before it, after --, or as a push's branch after the remote (npos counts the words before it after the subcommand).
var_segment() {
  local a=$1 b=$2 gi=-1 j sub si=-1 npos=0 prev="" w p
  for ((j = a; j <= b; j++)); do [[ ${vbw[j]} == git ]] && { gi=$j; break; }; done
  ((gi < 0)) && return 0
  j=$((gi + 1))
  while ((j <= b)); do
    case ${vbw[j]} in
      -C | -c) j=$((j + 2)) ;;
      -*) j=$((j + 1)) ;;
      *) break ;;
    esac
  done
  ((j <= b)) || return 0
  si=$j; sub="${vbw[j]}"
  [[ $sub == *$'\x07'* ]] && block "$MSG_SUB"
  [[ " $vb_scope " == *" $sub "* ]] || return 0
  for ((j = gi + 1; j <= b; j++)); do
    w="${vbw[j]}"
    [[ $w == -- ]] && break
    if ((j < si)) && [[ $prev == -[Cc] ]]; then   # the value of -C or -c, before the subcommand
      ((vbu[j])) && block "$MSG_VAR"
      prev="$w"; continue
    fi
    if ((j == si)); then prev="$w"; continue; fi
    if [[ $w == *$'\x07'* ]]; then
      ((vbu[j])) && block "$MSG_VAR"
      p="${w%%$'\x07'*}"
      if vtaker "$sub" "$prev" || vtaker "$sub" "$p"; then :
      elif [[ $w == $'\x07' ]]; then
        [[ $sub == push ]] && ((npos >= 1)) || block "$MSG_VAR"
      elif [[ -z $p || ( $p == -* && $p != *=* ) ]]; then block "$MSG_VAR"
      fi
    fi
    if ((j > si)) && [[ $w != -* ]] && ! vtaker "$sub" "$prev"; then npos=$((npos + 1)); fi
    prev="$w"
  done
}

# var_judge <text> [1]: each segment of the text, judged by var_segment. With a second argument of 1 each segment is also read by
# cfg_segment (B38), so only the git command's own words are, not a heredoc body. Redirections are read as the shell reads them
# (>& and &> are a redirection, not a separator), so a target such as git log > "$f" is no word of git's.
var_judge() {
  local s="${1//>&/> }" a=0 b n
  s="${s//&>/> }"
  var_walk "$s"
  n=${#vbw[@]}
  while ((a < n)); do
    b=$a
    while ((b + 1 < n && vbs[b + 1] == vbs[a])); do ((b++)); done
    var_segment "$a" "$b"
    ((${2:-0})) && cfg_segment "$a" "$b"
    a=$((b + 1))
  done
}

# --- Git configuration and program flags (B38) ----------------------------------------------------
# git -c <key>=<value> sets a configuration key for one command, and a key can name a program git runs: an alias that starts
# with !, the pager, the editor, the ssh command, a diff, merge or credential helper, a filter, an include. --config-env sets a
# key from an environment variable, and clone takes -c and --config after its subcommand too. So a key passes only when it runs
# nothing (cfg_ok), and a key that a variable or a substitution holds is blocked, since the guard can't read it (cfg_check). The
# flags that name a program for a remote, --upload-pack, --receive-pack and --exec (clone's -u as well), are blocked on fetch,
# pull, push, clone, ls-remote and archive, and so is a prefix of their names, which git accepts (cfg_segment). The variables
# that name a program git runs are blocked on a git command's line (env_run_re, read in the git rules below).
MSG_CFGVAR="a variable as a git -c or --config-env key holds a name the guard can't read, and that name can be a program git runs: write the key out"
MSG_CFGSUB="a command substitution as a git -c or --config-env key prints a name the guard can't read: write the key out"
MSG_ENVRUN="a variable that names a program git runs (GIT_PAGER, GIT_EDITOR, GIT_SSH_COMMAND, GIT_CONFIG_*, EDITOR, PAGER and the like) is set on a git command, and the guard can't see which program runs"
# cfg_pre: the words name a git command's global option (git -c, git -C) or a remote subcommand, where cfg_segment reads.
cfg_pre='git[[:space:]]+-|(^|[^[:alnum:]_.-])(fetch|pull|push|clone|ls-remote|archive)([^[:alnum:]_.-]|$)'
# The names above as they're set on a command's line: before git, after export or env, or as PowerShell's $env:NAME = value.
env_run_re='(^|[^[:alnum:]_.-])(\$env:)?(GIT_(CONFIG|SSH|PAGER|EDITOR|SEQUENCE_EDITOR|EXTERNAL_DIFF|ASKPASS|PROXY_COMMAND|EXEC_PATH|ALLOW_PROTOCOL)[[:alnum:]_]*|EDITOR|VISUAL|PAGER)[[:space:]]*='

# cfg_ok <key> <value>: 0 when the key runs nothing, with the names read as git reads them (case-insensitive). pager.<cmd>
# passes only as false, which turns the pager off.
cfg_ok() {
  local ok=1
  shopt -s nocasematch
  case $1 in
    core.quotepath | core.autocrlf | core.safecrlf | core.eol | core.longpaths | core.symlinks | core.ignorecase | core.filemode \
      | core.precomposeunicode | core.abbrev | color.* | advice.* | log.* | status.* | i18n.* | user.name | user.email) ok=0 ;;
    pager.*) [[ $2 == false ]] && ok=0 ;;
  esac
  shopt -u nocasematch
  return $ok
}

# cfg_check <word>: <word> is a git -c argument, key=value, or a --config-env argument, where the value is the name of an
# environment variable. A variable or a substitution in the key is blocked, and so is a key that cfg_ok doesn't pass.
cfg_check() {
  local key="${1%%=*}" val=""
  [[ $1 == *=* ]] && val="${1#*=}"
  [[ $key == *$'\x07'* ]] && block "$MSG_CFGVAR"
  [[ $key == *$'\x1a'* ]] && block "$MSG_CFGSUB"
  cfg_ok "$key" "$val" && return 0
  block "git sets the config key $key, which can run a program or change which one git runs (an alias that starts with !, the pager, the editor, the ssh command, a diff, merge or credential helper); the keys that run nothing pass: core.quotepath, core.autocrlf, color.*, advice.*, log.*, status.*, i18n.*, user.name, user.email and pager.<cmd>=false"
}

# cfg_segment <first word> <last word>: the git command in one segment, found as var_segment finds it. Before its subcommand,
# -c and --config-env give a key, and -C, --git-dir, --work-tree, --namespace and --super-prefix take a value (so that value
# isn't taken for the subcommand). After a remote subcommand, its options before -- are read: a program flag is blocked, and
# clone also takes -c and --config (checked as keys) and the short -u, which is its upload-pack.
cfg_segment() {
  local a=$1 b=$2 gi=-1 j sub w name nxt cl c rest q
  for ((j = a; j <= b; j++)); do [[ ${vbw[j]} == git ]] && { gi=$j; break; }; done
  ((gi < 0)) && return 0
  j=$((gi + 1))
  while ((j <= b)); do
    w="${vbw[j]}"
    case $w in
      -c | --config-env)
        nxt=""; ((j + 1 <= b)) && nxt="${vbw[j + 1]}"
        cfg_check "$nxt"; j=$((j + 2)) ;;
      --config-env=*) cfg_check "${w#--config-env=}"; j=$((j + 1)) ;;
      -C | --git-dir | --work-tree | --namespace | --super-prefix) j=$((j + 2)) ;;
      -*) j=$((j + 1)) ;;
      *) break ;;
    esac
  done
  ((j <= b)) || return 0
  sub="${vbw[j]}"
  case $sub in fetch | pull | push | clone | ls-remote | archive) ;; *) return 0 ;; esac
  for ((j = j + 1; j <= b; j++)); do
    w="${vbw[j]}"
    [[ $w == -- ]] && break
    if [[ $w == --* ]]; then
      name="${w%%=*}"; name="${name#--}"
      [[ -n $name ]] || continue
      shopt -s nocasematch
      if [[ upload-pack == "$name"* || receive-pack == "$name"* || exec == "$name"* ]]; then
        block "git $sub --$name names a program that git runs, and the guard can't judge which one"
      fi
      if [[ $sub == clone && config == "$name"* ]]; then
        shopt -u nocasematch
        if [[ $w == *=* ]]; then cfg_check "${w#*=}"
        else nxt=""; ((j + 1 <= b)) && nxt="${vbw[j + 1]}"; cfg_check "$nxt"; j=$((j + 1)); fi
        continue
      fi
      shopt -u nocasematch
    elif [[ $sub == clone && $w == -?* ]]; then
      cl="${w#-}"
      for ((q = 0; q < ${#cl}; q++)); do
        c="${cl:q:1}"; rest="${cl:q + 1}"
        case $c in
          u) block "git clone -u names a program that git runs on the remote end, and the guard can't judge which one" ;;
          c)
            if [[ -n $rest ]]; then cfg_check "$rest"
            else nxt=""; ((j + 1 <= b)) && nxt="${vbw[j + 1]}"; cfg_check "$nxt"; j=$((j + 1)); fi
            break ;;
          b | o | j) [[ -n $rest ]] || j=$((j + 1)); break ;;
        esac
      done
    fi
  done
}

# --- Shell wrappers (B34) -----------------------------------------------------------------------
# A quoted string given to a shell or an interpreter is a script it runs: bash -c, sh -c and zsh -c (with any options before
# -c), eval, powershell or pwsh -Command (or with no -File, the text itself) and cmd /c. Each such script is a view, read as a
# command of its own, so the rules judge the git in it. A script nested in one is a view a level deeper, up to WRAP_MAX
# levels; vdep holds each view's depth (0 for the command and its readings). wrap_read reads the command's words as the shell
# does (quotes, escapes, substitutions, comments, and the heredoc bodies gtext leaves out), so a quoted name (ba''sh) or a
# shell behind a prefix (nice -n 5 bash -c) is found too. A command whose quoting it can't close is blocked, and so is
# PowerShell's -EncodedCommand, whose text is hidden from every rule.
WRAP_MAX=4
hre='(^|[^<])<<-?[[:space:]]*(\\?["'"'"']?)([A-Za-z_][A-Za-z0-9_]*)'
wrap_gate='(^|[^[:alnum:]_-])((ba|z|da|k)?sh|eval|powershell|pwsh|cmd)(\.exe)?([[:space:];&|()<>]|$)'
# B39: a heredoc whose header (the text before <<, after its last ; & |) feeds a commit's or tag's message, and whose line
# names no shell, is text no shell runs. A header that names a shell (bash, sh, eval, source...) feeds a script a shell runs.
hmsg_re='(^|[^[:alnum:]_./-])git[[:space:]]+([^;&|]*[[:space:]])?(commit|tag)([[:space:]]|$)'
hshell_re='(^|[^[:alnum:]_./-])((ba|z|da|k)?sh|eval|source|exec)(\.exe)?([[:space:];&|()<>]|$)'
# B40: a cat or tee body (hcat_re is the header's command) is text unless the command names something that runs it (hrun_re): a
# shell or an interpreter, ssh, chmod, iex, a build tool that runs the file it reads (make, npm and its family), a call operator
# (&), a ./, ../ or .\ path, a dot-source, or the .git folder (git runs its hooks from there). A quoted name is read with its
# quotes removed (see the cat or tee rule below).
hcat_re='^[[:space:]]*(cat|tee)([[:space:]]|$)'
hrun_re='(^|[^[:alnum:]_./-])((ba|z|da|k)?sh|eval|source|exec|pwsh|powershell|cmd|python3?|py|perl|ruby|node|ssh|chmod|iex|invoke-expression|make|npm|npx|yarn|pnpm)(\.exe)?([[:space:];&|()<>]|$)'
hrun_re+="|(^|[[:space:];&|()])\\.\\.?[/\\\\]|(^|[[:space:];|()])&[[:space:]]|(^|[;&|()$nl][[:space:]]*)\\.[[:space:]]|\\.git[/\\\\]"
tab=$'\t'; cr=$'\r'
MSG_WRAP="the guard can't read the quoting of this command, which may hold a script a shell or PowerShell runs (or an encoded PowerShell command)"
MSG_DEEP="shell wrappers nest deeper than the guard reads (four levels, such as bash -c inside sh -c)"
MSG_VIEWS="the command runs more scripts in shells than the guard reads in time"

# jesc <text>: sets je to the text as the inside of a JSON string, the form a view is read in.
jesc() {
  je="$1"
  je="${je//\\/\\\\}"; je="${je//\"/\\\"}"; je="${je//$nl/\\n}"; je="${je//$tab/\\t}"; je="${je//$cr/\\r}"
}

# wrap_word: the word of s at i (s, L, i, wv and sesc belong to wrap_read). Sets wv to its value, the quotes and escapes
# removed and each substitution kept as text, and moves i past it. Returns 1 when a quote, a substitution or an ANSI-C
# string doesn't close, or an ANSI-C string has a numeric escape, which can spell any character.
wrap_word() {
  local c n k
  wv=""
  while ((i < L)); do
    c="${s:i:1}"
    case $c in ' ' | $'\t' | "$nl" | ';' | '&' | '|' | '(' | ')') return 0 ;; esac
    if [[ $c == "$sesc" ]]; then
      n="${s:i+1:1}"; i=$((i + 2))
      [[ $n == "$nl" || -z $n ]] || wv+="$n"   # an escaped line break continues the word
      continue
    fi
    case $c in
      "'")
        k="${s:i+1}"; [[ $k == *"'"* ]] || return 1
        k="${k%%"'"*}"; wv+="$k"; i=$((i + ${#k} + 2)) ;;
      '"') wrap_dq || return 1 ;;
      '`')
        k="${s:i+1}"; [[ $k == *'`'* ]] || return 1
        k="${k%%'`'*}"; wv+="\`$k\`"; i=$((i + ${#k} + 2)) ;;
      '$')
        n="${s:i+1:1}"
        if [[ $n == '(' ]]; then
          sub_end "$s" $((i + 2)) || return 1
          wv+="${s:i:sub_e - i + 1}"; i=$((sub_e + 1))
        elif [[ $n == "'" && $tool != PowerShell ]]; then
          wrap_ansi || return 1
        else wv+='$'; ((i++)); fi ;;
      '<' | '>')
        if [[ ${s:i+1:1} == '(' && $tool != PowerShell ]]; then
          sub_end "$s" $((i + 2)) || return 1
          wv+="${s:i:sub_e - i + 1}"; i=$((sub_e + 1))
        else wv+="$c"; ((i++)); fi ;;
      *) if [[ ${s:i} =~ $wrun_word ]]; then k="${BASH_REMATCH[0]}"; wv+="$k"; i=$((i + ${#k}))
         else wv+="$c"; ((i++)); fi ;;
    esac
  done
  return 0
}

# wrap_dq: the double-quoted string at i, read as the shell reads it (PowerShell's backtick and doubled quote too). Sets wv
# and moves i past it. Returns 1 when it doesn't close, or a backtick or substitution inside it doesn't.
wrap_dq() {
  local c n k
  i=$((i + 1))
  while :; do
    ((i < L)) || return 1
    c="${s:i:1}"; n="${s:i+1:1}"
    if [[ $c == '"' ]]; then
      if [[ $tool == PowerShell && $n == '"' ]]; then wv+='"'; i=$((i + 2)); continue; fi
      i=$((i + 1)); return 0
    fi
    if [[ $c == "$sesc" ]]; then
      if [[ $tool == PowerShell ]]; then
        [[ $n == "$nl" ]] || wv+="$n"; i=$((i + 2))
      else
        case $n in
          '$' | '`' | '"' | "$sesc") wv+="$n"; i=$((i + 2)) ;;
          "$nl") i=$((i + 2)) ;;
          *) wv+="$c"; i=$((i + 1)) ;;
        esac
      fi
      continue
    fi
    if [[ $c == '$' && $n == '(' ]]; then
      sub_end "$s" $((i + 2)) || return 1
      wv+="${s:i:sub_e - i + 1}"; i=$((sub_e + 1))
    elif [[ $c == '`' ]]; then
      k="${s:i+1}"; [[ $k == *'`'* ]] || return 1
      k="${k%%'`'*}"; wv+="\`$k\`"; i=$((i + ${#k} + 2))
    elif [[ ${s:i} =~ $wrun_dq ]]; then
      k="${BASH_REMATCH[0]}"; wv+="$k"; i=$((i + ${#k}))
    else
      wv+="$c"; i=$((i + 1))
    fi
  done
}

# wrap_ansi: the $'...' string at i (its $). Sets wv to its text, escapes kept, and moves i past it.
wrap_ansi() {
  local j=$((i + 2)) c k
  while ((j < L)); do
    c="${s:j:1}"
    if [[ $c == "$sesc" ]]; then ((j += 2)); continue; fi
    [[ $c == "'" ]] && break
    ((j++))
  done
  ((j < L)) || return 1
  k="${s:i+2:j-i-2}"
  [[ $k == *\\[xuU0-7]* ]] && return 1
  wv+="$k"; i=$((j + 1))
}

# wrap_push <script>: a non-empty script goes to wscripts, and wtc (1 when its wrapper runs it under a timeout, B42) to wscov.
# wpx is 1 when the wrapper is a POSIX shell or eval, whose script is Bash text (B44), and wsposix gets it with each script.
wrap_push() { [[ -n $1 ]] && { wscripts+=("$1"); wscov+=("$wtc"); wsposix+=("$wpx"); }; return 0; }

# wrap_rest <from>: sc is the words of wcmd from <from> on, joined by spaces, which is the text the command runs.
wrap_rest() {
  local x
  sc=""
  for ((x = $1; x < n; x++)); do sc+="${wcmd[x]} "; done
  sc="${sc% }"
}

# tcov_before <m>: 0 when a timeout of 280 seconds or less comes before word <m> of wcmd, the word of a shell, an interpreter or
# cmd that runs a script, so the whole script is bounded (B42). It's read as the hang check reads timeout N (options before the
# number, s or m). A timeout of 0 is no limit in GNU timeout, so it doesn't count.
tcov_before() {
  local m=$1 j k secs
  for ((j = 0; j < m; j++)); do
    [[ ${wcmd[j]} == timeout || ${wcmd[j]} == timeout.exe ]] || continue
    k=$((j + 1))
    while ((k < m)) && [[ ${wcmd[k]} =~ ^-[-[:alnum:]=]+$ ]]; do ((k++)); done
    ((k < m)) && [[ ${wcmd[k]} =~ ^([0-9]+)([sm]?)$ ]] || continue
    secs=$((10#${BASH_REMATCH[1]})); [[ ${BASH_REMATCH[2]} == m ]] && secs=$((secs * 60))
    ((secs >= 1 && secs <= limit_s)) && return 0
  done
  return 1
}

# wrap_cmd: the words of one command (wcmd). A word that names a shell, eval, PowerShell or cmd takes the script its
# arguments give it. Returns 1 for PowerShell's -EncodedCommand, whose text is hidden.
wrap_cmd() {
  local m j n=${#wcmd[@]} w base p sc
  for ((m = 0; m < n; m++)); do
    w="${wcmd[m]}"; base="${w##*/}"; base="${base##*\\}"
    wtc=0; tcov_before "$m" && wtc=1
    wpx=0; [[ $base =~ ^((ba|z|da|k)?sh)(\.exe)?$ || $base == eval ]] && wpx=1
    if [[ $base =~ ^((ba|z|da|k)?sh)(\.exe)?$ ]]; then
      for ((j = m + 1; j < n; j++)); do
        case ${wcmd[j]} in
          --) break ;;
          --rcfile | --init-file | -o | +o | -O | +O) ((j++)) ;;
          --*) ;;
          [-+]*c*) ((j + 1 < n)) && wrap_push "${wcmd[j + 1]}"; break ;;
          [-+]*) ;;
          *) break ;;
        esac
      done
    elif [[ $base == eval ]]; then
      wrap_rest $((m + 1)); wrap_push "$sc"
    elif [[ $base =~ ^(powershell|pwsh)(\.exe)?$ ]]; then
      for ((j = m + 1; j < n; j++)); do
        w="${wcmd[j]}"; p="${w#[-/]}"
        if [[ $w == [-/]* && -n $p ]]; then
          [[ command == "$p"* ]] && { wrap_rest $((j + 1)); wrap_push "$sc"; break; }
          [[ file == "$p"* ]] && break
          [[ encodedcommand == "$p"* ]] && return 1
          continue
        fi
        [[ $w == *.ps1 ]] && break
        wrap_rest "$j"; wrap_push "$sc"; break
      done
    elif [[ $base =~ ^cmd(\.exe)?$ ]]; then
      for ((j = m + 1; j < n; j++)); do
        if [[ ${wcmd[j]} =~ ^/[ck]$ ]]; then wrap_rest $((j + 1)); wrap_push "$sc"; break; fi
      done
    fi
  done
  return 0
}

# wrap_read <text>: the commands of the text, each one's words read as the shell reads them. wscripts gets the scripts the
# shells run. Returns 1 when a quote or a substitution doesn't close, or a PowerShell command is encoded.
wrap_read() {
  local s="$1" L=${#1} i=0 c k wv="" wcmd=()
  # The runs of ordinary characters (no quote, escape, substitution or separator) a word or a double-quoted string takes whole.
  if [[ $tool == PowerShell ]]; then
    sesc='`'; wrun_word='^[^[:space:];&|()<>$`'"'"'"]+'; wrun_dq='^[^"`$]+'
  else
    sesc='\'; wrun_word='^[^[:space:];&|()<>$`'"'"'"\\]+'; wrun_dq='^[^"\\$`]+'
  fi
  wscripts=(); wscov=(); wsposix=()
  while ((i < L)); do
    c="${s:i:1}"
    case $c in
      ' ' | $'\t') ((i++)) ;;
      "$nl" | ';' | '&' | '|' | '(' | ')') wrap_cmd || return 1; wcmd=(); ((i++)) ;;
      '#') k="${s:i}"; k="${k%%"$nl"*}"; ((i += ${#k})) ;;
      *) wrap_word || return 1; wcmd+=("$wv") ;;
    esac
  done
  wrap_cmd
}

# A comment starts at a # that begins a word: after a blank, a line start or a metacharacter, as Bash reads it. PowerShell's
# comment starts the same way and ends at the line break (B35).
cmt_re='(^|[[:blank:]|&;()<>])#'
views=("$raw")
if [[ $tool == PowerShell ]]; then
  # PowerShell's line breaks are CR LF, CR and LF (B35). A backtick before a line break continues the line unless it's
  # escaped (``), which keeps the break; each continuation is marked x4 as a Bash backslash is below.
  pl="${raw//\\\\/$x1}"; pl="${pl//$x1$x1/$x2}"; pl="${pl//\\r\\n/$nl}"; pl="${pl//\\r/$nl}"; pl="${pl//\\n/$nl}"
  pl="${pl//"$bt$bt"/$x3}"; pl="${pl//"$bt$nl"/$x4$nl}"; pl="${pl//$x3/$bt$bt}"
else
  pl="${raw//\\\\/$x1}"; pl="${pl//$x1$x1/$x2}"; pl="${pl//$x1\\n/$x4$nl}"; pl="${pl//\\n/$nl}"
fi
# The readings: as written, as joined, and joined from each line after one that holds a comment marker and ends in a
# continuation (B31). A command with no continuation (and no PowerShell escape to read) has one reading.
if [[ $tool == PowerShell || $pl == *"$x4"* ]]; then
  phys=(); rest="$pl"
  while [[ $rest == *"$nl"* ]]; do phys+=("${rest%%"$nl"*}"); rest="${rest#*"$nl"}"; done
  phys+=("$rest"); nphys=${#phys[@]}
  view_of 0 0; views=("$view")
  reading_of 0 1; [[ $view == "${views[0]}" ]] || views+=("$view")
  for ((k = 1; k < nphys; k++)); do
    [[ ${phys[k-1]} == *"$x4" && ${phys[k-1]} =~ $cmt_re ]] || continue
    # Each such line costs a pass of the rules, so a command with very many can't run past the hook's time limit.
    if ((${#views[@]} >= 64)); then
      echo "App Director: blocked: the command has more lines that end in a continuation (a backslash, or a backtick in PowerShell) after a comment marker than the guard can read in time. If it's really needed, ask the human to run it." >&2
      exit 2
    fi
    reading_of "$k" 1; views+=("$view")
  done
fi

# Each reading goes through the rules below, one at a time, so a heredoc's state in one reading can't carry
# into another. A command with no continuation has one reading, the command itself.
for ((vi = 0; vi < ${#views[@]}; vi++)); do
raw="${views[vi]}"

# The command as the shell reads its line breaks and tabs: a JSON \n ends a command, as ; does, and \t
# is a space. A real backslash (the pair \\) stays as it is, so \\n is text, not a line break. The early
# tests read this text, so a git command on any line is seen (B23). A backslash at the end of a line
# continues the command on the next line, as the shell does, so `git push \` with `--force` below is one
# command (B25). Expansions only, so no process starts. x1 is one shell backslash, x2 an escaped pair (\\).
detect="${raw//\\\\/$x1}"; detect="${detect//$x1$x1/$x2}"; detect="${detect//$x1\\n/}"
detect="${detect//\\n/;}"; detect="${detect//\\t/ }"; detect="${detect//$x2/$x1$x1}"
detect="${detect//$x1/$bs$bs}"

# The same command with its quotes decoded, for the rules that read words: the git flags below and the
# reads of credential files. A line break that ends a command stays a newline; a continued line (B25) has
# none. A pair of backslashes is an escaped backslash, so a newline after it still ends the command.
# Expansions only.
real="${raw//\\\\/$x1}"; real="${real//\\\"/\"}"; real="${real//$x1$x1/$x2}"; real="${real//$x1\\n/}"
real="${real//\\n/$nl}"; real="${real//\\t/ }"; real="${real//\\r/}"; real="${real//$x2/$x1$x1}"
real="${real//$x1/$bs}"

# Blank quoted strings so a commit message or filename can't trip flag tests.
code="$detect"
dq='\\"([^\\]|\\[^"])*\\"'
while [[ $code =~ $dq ]]; do code="${code/"${BASH_REMATCH[0]}"/ Q }"; done
sq="'[^']*'"
while [[ $code =~ $sq ]]; do code="${code/"${BASH_REMATCH[0]}"/ Q }"; done

block() {
  echo "App Director: blocked: $1. If it's really needed, ask the human to run it." >&2
  exit 2
}

# B37: a variable as a command's name, followed by -c or -Command, runs a shell or an interpreter the guard can't tell apart.
# The words are read as the shell reads them (a quoted "& $X -c" is text, a quoted "$SHELL" is a name), and a precheck
# keeps the common command from the walk. Only the words before the name may be assignments or wrappers (env, sudo, ...).
if [[ $real == *'$'* && $real =~ $vsh_pre_re ]]; then
  var_walk "$real"
  for ((vk = 0; vk + 1 < ${#vbw[@]}; vk++)); do
    [[ ${vbw[vk]} == *$'\x07'* ]] || continue
    vq=$vk; vok=1
    while ((vq > 0 && vbs[vq - 1] == vbs[vk])); do
      ((vq--)); [[ ${vbw[vq]} =~ $vsh_prefix_re ]] || { vok=0; break; }
    done
    ((vok && vbs[vk + 1] == vbs[vk])) && [[ ${vbw[vk + 1]} =~ $vsh_opt_re ]] && block "$MSG_SHVAR"
  done
fi

# --- Credential file reads ------------------------------------------------------------------------
# Block direct shell reads of .env and .env.<suffix> (not the templates .env.example, .env.sample,
# .env.template and .env.dist), of *.pem and *.key, and of the credential stores: ~/.ssh (any key,
# known_hosts too), git's credentials files, and the gh CLI's hosts.yml (.config/gh, or AppData's
# GitHub CLI). A path is blocked when it is one of those or sits inside one, however it is written:
# ~/, $HOME/, ${HOME}/, /c/Users/<name>/, C:\Users\<name>\ or relative. The commands that print a
# stored credential are blocked as well (gh auth token, gh auth status -t, git credential fill or get).
# These files may hold live credentials. Any credential read in a conversation context must be
# considered compromised and rotated. This is a best-effort check on the command text; indirect
# reads are not detected. The readers are Bash's (cat, head, tail, less, more, strings, and the common file readers:
# grep, egrep, fgrep, rg, sed, awk, gawk, sort, uniq, cut, nl, tac, rev, od, xxd, hexdump, base64, diff and cmp, B36)
# and PowerShell's (Get-Content, its aliases gc and type, Select-String and its alias sls, and [IO.File]::ReadAllText
# and its siblings, OpenText, OpenRead and Open, B36), matched in any case (B27), by a path (/bin/cat), quoted
# (& 'Get-Content'), with .exe, or with a backtick escape inside a word (Get-Con`tent, B30); quotes inside a reader's
# or a name's word are removed as the shell removes them (ca''t, c"a"t, B36), and in Bash a backslash that escapes an ordinary
# character is removed the same way (c\at, .en\v.local, B44); [IO.StreamReader]::new and New-Object
# System.IO.StreamReader are readers too (B30). The check runs for every tool the hook is wired to.
cred_end="([[:space:]\"';&|)]|\$)"
cred_store_re='\.ssh([/\\]|'"$cred_end"')|\.git-credentials|\.config[/\\]git[/\\]credentials|\.config[/\\]gh([/\\]|'"$cred_end"')|GitHub CLI([/\\]|'"$cred_end"')'
# A name in a read's arguments is a whole word: .env, or .pem or .key ending a word, after a character that
# isn't part of a name, so x.env doesn't match. A quote, a folder, a redirect or a wildcard (.env*) beside the
# name counts, as in "certs/server.pem", config/.env or >.env. Options and their values are arguments too.
name_end="([[:space:]\"';&|()<>*?]|\$)"
dot_env_re='(^|[^[:alnum:]_.-])\.env'"$name_end"
pem_key_re='\.(pem|key)'"$name_end"
env_re='(^|[^[:alnum:]_.-])\.env\.([^[:space:]"'"'"';&|<>()/]+)'
store_arg_re='(^|[^[:alnum:]_.-])('"$cred_store_re"')'
# Whether the arguments of a read name a credential file (0 if they do). A .env.<suffix> file (.env.local,
# ./.env.production, "config/.env.staging") is one, except the committed templates .env.example, .env.sample,
# .env.template and .env.dist: they hold no values, so they stay readable. Bash regexes have no negative
# lookahead, so each .env.<suffix> match is tested and the search goes on after it.
cred_args() {
  local args="$1"
  [[ $args =~ $dot_env_re || $args =~ $pem_key_re || $args =~ $store_arg_re ]] && return 0
  while [[ $args =~ $env_re ]]; do
    case ${BASH_REMATCH[2]} in example|sample|template|dist) ;; *) return 0 ;; esac
    args="${args#*"${BASH_REMATCH[0]}"}"
  done
  return 1
}
# bs_unescape <text>: sets bsout to the text with each backslash that escapes an ordinary character removed, as Bash removes it
# outside quotes (B44): c\at is cat, and .en\v.local is .env.local. A pair (\\) is one backslash, as the shell reads it, and a
# backslash before a space, a separator or a quote stays. nocasematch is off for the substitutions, since it would match \A
# against \a in the list below.
bs_unescape() {
  local t="$1" c ncm=0
  shopt -q nocasematch && ncm=1
  shopt -u nocasematch
  t="${t//\\\\/$x1}"
  for c in {a..z} {A..Z} {0..9} . _ / : '~' = , + @ % '*' '?' '#' -; do
    t="${t//"\\$c"/"$c"}"
  done
  bsout="${t//$x1/$bs}"
  ((ncm)) && shopt -s nocasematch
  return 0
}
reads_cred_file() {
  # The command as the shell reads it (real, above, with the line breaks that end a command as ;), so
  # C:\Users\V works, a tab is a space and a backslash-joined line is one line (B25).
  local cmd="${real//$nl/;}"
  # A reader is its command word after a space, a separator, an opening bracket, a quote (a -Command or -c
  # string: powershell -Command "gc .env"), a backslash, a slash or a backtick, then its arguments up to the next ; & or |.
  # Every argument is tested, so the file may follow an option (tail -n 20 .env) or another file (cat README.md
  # .env.local), and a PowerShell -Path or -LiteralPath value is one too. type is a Bash builtin as well
  # (type git), so only a credential name after it is blocked, as for cat. The name may be a path (/bin/cat, or
  # Microsoft.PowerShell.Management\Get-Content), carry .exe (cat.exe), or be quoted (& 'Get-Content' .env.local, B30).
  # The common file readers (B36) print a file's content too: search (grep, egrep, fgrep, rg, sed, awk, gawk), sort,
  # uniq, cut, nl, tac and rev, dump (od, xxd, hexdump, base64) and compare (diff, cmp). A pattern is an argument
  # as well, so grep "\.env" is blocked as Select-String's pattern is (B27): the arguments can't tell a pattern from a
  # path. cp, mv and scp copy a file without printing it, and wc prints only counts, so none of them is in the list.
  local readers='(cat|head|tail|less|more|strings|type|gc|get-content|select-string|sls|grep|egrep|fgrep|rg|sed|awk|gawk|sort|uniq|cut|nl|tac|rev|od|xxd|hexdump|base64|diff|cmp)'
  local name_quote="['\"]*"
  local read_re='(^|[[:space:]|;&("'"'"'`\\/])'"$readers"'(\.exe)?'"$name_quote"'[[:space:]]+([^;&|]*)'
  # [IO.File]::ReadAllText(...), and its ReadAllLines, ReadAllBytes and ReadLines: the arguments run to the next ; & or |.
  # OpenText, OpenRead and Open open a file to read it (B36).
  local file_re='(^|[^[:alnum:]_.-])\[(system\.)?io\.file\]::(readtext|readlines|readbytes|readalltext|readalllines|readallbytes|opentext|openread|open)[[:space:]]*\(([^;&|]*)'
  # [IO.StreamReader]::new(...) and New-Object System.IO.StreamReader (-TypeName ... -ArgumentList ...), whose
  # arguments run to the next ; & or | as well (B30).
  local stream_re='(^|[^[:alnum:]_.-])(\[(system\.)?io\.streamreader\]::new|new-object[[:space:]]+(-typename[[:space:]]+)?(system\.)?io\.streamreader)([^;&|]*)'
  # A name or a reader split by quotes (ca''t, c"a"t, .en''v.local) is read as the shell runs it: the quotes are removed,
  # and the same tests run on that text too (B36). A command with no quote is tested once.
  local -a texts=("$cmd")
  [[ $cmd == *[\"\']* ]] && texts+=("${cmd//[\"\']/}")
  # B44: in Bash an unquoted backslash that escapes an ordinary character is removed by the shell, so each text is read again with
  # those removed (c\at is cat). PowerShell's escape is the backtick (B30), so a PowerShell command's text is read as it is; a
  # script that a POSIX shell runs inside it (vpx, set in the wrapper reading) is Bash text.
  if [[ ( $tool != PowerShell || ${vpx[vi]:-0} == 1 ) && $cmd == *\\* ]]; then
    local nt=${#texts[@]} k
    for ((k = 0; k < nt; k++)); do
      bs_unescape "${texts[k]}"
      [[ $bsout == "${texts[k]}" ]] || texts+=("$bsout")
    done
  fi
  local t rest args
  for t in "${texts[@]}"; do
    rest="$t"
    while [[ $rest =~ $read_re ]]; do
      args="${BASH_REMATCH[4]}"
      rest="${rest#*"${BASH_REMATCH[0]}"}"
      cred_args "$args" && return 0
    done
    rest="$t"
    while [[ $rest =~ $file_re ]]; do
      args="${BASH_REMATCH[4]}"
      rest="${rest#*"${BASH_REMATCH[0]}"}"
      cred_args "$args" && return 0
    done
    rest="$t"
    while [[ $rest =~ $stream_re ]]; do
      args="${BASH_REMATCH[6]}"
      rest="${rest#*"${BASH_REMATCH[0]}"}"
      cred_args "$args" && return 0
    done
  done
  return 1
}
# PowerShell's names are case-insensitive (GET-CONTENT, Gc), so the matches above are too (B27).
shopt -s nocasematch
if reads_cred_file; then
  echo "App Director: blocked: reading credential files exposes secrets to the AI context." >&2
  echo "              Use .env.example for documentation; real credentials stay out of AI context." >&2
  echo "              Any credential read in a conversation must be treated as compromised and rotated." >&2
  exit 2
fi
shopt -u nocasematch
# gh auth token, gh auth status -t and git credential fill or get print a stored credential. Matched on the decoded words
# (B39, rdec, below), so a quoted subcommand is seen; a commit message that names them has its quoted text blanked, so it isn't.
gh_print_re='(^|[^[:alnum:]_./-])gh[[:space:]]+auth[[:space:]]+(token([[:space:]]|$|[;&|)])|status[^;&|]*[[:space:]](-[[:alpha:]]*t[[:alpha:]]*|--show-token)([[:space:]]|$|[;&|)]))'
git_print_re='(^|[^[:alnum:]_./-])git[[:space:]]+([^;&|]*[[:space:]])?credential[[:space:]]+(fill|get)([[:space:]]|$|[;&|)])'

# --- Hangs ---------------------------------------------------------------------------------------
# A command that never returns, or runs past five minutes, lets the prompt cache expire, and the next
# turn rewrites the whole context. So: no empty-heredoc probes, no unbounded wait loops, no long sleeps.
# Text matching only: a loop built another way isn't seen. The guard is also wired to Monitor.
hang() {
  echo "App Director: blocked: $1" >&2
  echo "              $2" >&2
  exit 2
}
limit_s=280

# 1. `python - <<'EOF'` whose body is empty: Python waits for console input and never returns on
#    Windows. Typically the "is Python here?" probe.
text="${raw//\\r/}"; text="${text//\\n/$nl}"
heredoc_re='(^|[^[:alnum:]_./-])(python3?|py)(\.exe)?[[:space:]]+-[[:space:]]*<<-?[[:space:]]*\\?["'"'"']?([A-Za-z_][A-Za-z0-9_]*)'
IFS=$'\n' read -r -d '' -a lines <<<"$text" || true
for ((i = 0; i + 1 < ${#lines[@]}; i++)); do
  if [[ ${lines[i]} =~ $heredoc_re ]]; then
    delim="${BASH_REMATCH[4]}"; next="${lines[i + 1]//[[:space:]]/}"
    [ "$next" = "$delim" ] && hang "python reading an empty heredoc waits for console input and never returns (on Windows)." \
      "To test whether Python is there, run: python3 --version"
  fi
done

# 3. A lone sleep over 280 seconds.
sleep_re='(^|[^[:alnum:]_./-])sleep[[:space:]]+([0-9]+)([smhd]?)([[:space:]]|$|[;&|)])'
rest="$code"
while [[ $rest =~ $sleep_re ]]; do
  n="${BASH_REMATCH[2]}"; unit="${BASH_REMATCH[3]}"; secs=$((10#$n))
  case "$unit" in m) secs=$((secs * 60)) ;; h) secs=$((secs * 3600)) ;; d) secs=$((secs * 86400)) ;; esac
  [ "$secs" -gt "$limit_s" ] && hang "sleep $n$unit is longer than $limit_s seconds, and a wait past five minutes lets the prompt cache expire." \
    "Start the work with run_in_background and keep working until its completion notice, or wait in steps of $limit_s seconds or less."
  rest="${rest#*"${BASH_REMATCH[0]}"}"
done

# 2. until/while loops that sleep: under `timeout N` (N <= 280), or ended by the exit line Claude Code
#    appends to a background command's output. A loop quoted into `bash -c '...'` is read from the raw text.
#    B42: a script a shell or an interpreter runs (eval, -Command, cmd /c, a nested bash -c) is a view of its own, and its
#    loops are read in its text as the sleep rule reads it. A view whose wrapper is under a timeout of 280 or less (vcov)
#    is bounded whole, so its loops are not read. PowerShell's while and Start-Sleep are read in any case.
scan="$code"
[[ $code =~ (bash|sh|zsh)[[:space:]]+-[a-z]*c[[:space:]] ]] && scan="$raw"
scan="${scan//\\n/$nl}"
loop_re='(^|[^[:alnum:]_./-])(until|while)[[:space:]]'
sleep_loop_re='(^|[^[:alnum:]_./-])((start-)?sleep)[[:space:]]'
timeout_re="(^|[^[:alnum:]_./-])timeout[[:space:]]+(-[-[:alnum:]=]+[[:space:]]+)*([0-9]+)([sm]?)[[:space:]]+[^;&|$nl]*\$"
rest="$scan"; before=""
((${vcov[vi]:-0} == 0)) || rest=""   # under a timeout of 280 seconds or less: bounded whole (B42)
shopt -s nocasematch
while [[ $rest =~ $loop_re ]]; do
  before="$before${rest%%"${BASH_REMATCH[0]}"*}${BASH_REMATCH[1]}"
  rest="${rest#*"${BASH_REMATCH[0]}"}"
  loop="${rest%%[;[:space:]]done[;[:space:])\'\"]*}"
  [[ $loop =~ $sleep_loop_re ]] || continue
  [[ $raw == *"exited with code"* || $raw == *"[killed]"* ]] && continue
  covered=0
  if [[ $before =~ $timeout_re ]]; then
    secs=$((10#${BASH_REMATCH[3]})); [ "${BASH_REMATCH[4]}" = m ] && secs=$((secs * 60))
    [ "$secs" -le "$limit_s" ] && covered=1
  fi
  [ "$covered" -eq 1 ] && continue
  [[ $loop == *tasks/*.output* ]] && hang "this loop reads a background command's output without waiting for the line Claude Code appends when it ends, so it can wait forever." \
    "Wait for \"exited with code\" or \"[killed]\" in the output file, or wrap the loop in: timeout 240 bash -c '...'"
  hang "an until or while loop with sleep and no time limit can run for ever, and a wait past five minutes lets the prompt cache expire." \
    "Put a limit on it: timeout 240 bash -c 'until ...; do sleep 5; done' (N of $limit_s or less), or start the work with run_in_background."
done
shopt -u nocasematch

# B34: the scripts that the shells and interpreters in this text run become views, each a level deeper than this one. The
# text is read only when a shell's name shows in it with its quotes removed, so a command that names none goes no further.
wscripts=()
shl="${raw//\\\\/$x1}"; shl="${shl//\\\"/\"}"; shl="${shl//\\n/$nl}"; shl="${shl//\\t/ }"; shl="${shl//\\r/}"; shl="${shl//$x1/$bs}"
shopt -s nocasematch
bare="${shl//[\"\'\\]/}"
if [[ $bare =~ $wrap_gate ]]; then
  # The heredoc bodies gtext leaves out (below) are left out here too, so a message that names a shell isn't read as a script.
  wtext=""; wdelim=""; wq=""; wbody=""
  while IFS= read -r line || [ -n "$line" ]; do
    if [ -n "$wdelim" ]; then
      if [ "${line#"${line%%[![:space:]]*}"}" = "$wdelim" ]; then
        wdelim=""
        [[ -n $wq || ( $wbody != *'$('* && $wbody != *'`'* ) ]] || wtext+="${wbody//[\'\"]/_}"
        wbody=""
      else wbody+="$line$nl"; fi
      continue
    fi
    wtext+="$line$nl"
    [[ $line =~ $hre ]] && { wdelim="${BASH_REMATCH[3]}"; wq="${BASH_REMATCH[2]}"; }
  done <<<"$shl"
  wtext+="$wbody"
  bare="${wtext//[\"\'\\]/}"
  if [[ $bare =~ $wrap_gate ]]; then
    wrap_read "$wtext" || block "$MSG_WRAP"
    for ((wk = 0; wk < ${#wscripts[@]}; wk++)); do
      ((${vdep[vi]:-0} < WRAP_MAX)) || block "$MSG_DEEP"
      ((${#views[@]} < 64)) || block "$MSG_VIEWS"
      jesc "${wscripts[wk]}"; vdep[${#views[@]}]=$((${vdep[vi]:-0} + 1))
      vcov[${#views[@]}]=$((${vcov[vi]:-0} | ${wscov[wk]:-0}))   # bounded by a timeout above it, or by its own (B42)
      vpx[${#views[@]}]=${wsposix[wk]:-0}                       # a script a POSIX shell runs is Bash text (B44)
      views+=("$je")
    done
  fi
fi
shopt -u nocasematch

# --- git-specific rules --------------------------------------------------------------------------
# A substitution's brackets are read as blanks, so $(echo git) counts as a git command (B32).
# The git name is read as the shell reads it, quotes removed, so "git", 'git' and g"it" are git (B39).
bare_g="${detect//$brackets/ }"; bare_g="${bare_g//[\"\'\\]/}"
isgit=0; [[ $bare_g =~ (^|[^[:alnum:]_./-])git([[:space:]]|$) ]] && isgit=1
isbash=0; [[ $detect =~ (^|[^[:alnum:]_.-])(ba)?sh([[:space:]]|$) ]] && isbash=1
# A gh command (quotes removed, as the shell reads it) is read for the gh auth token rule too (B39).
gh_pre=0; [[ ${real//[\"\'\\]/} =~ (^|[^[:alnum:]_.-])gh[[:space:]] ]] && gh_pre=1
((isgit || isbash || gh_pre)) || continue

seg='[^;&|]*'   # the destructive git rules are below the decoding of the command (B33)

# --- git: flags that write a file, read outside the repository or run a configured command --------
# settings.json allows `git diff *`, `git log *`, `git show *`, `git commit *` and `git stash *` without
# a prompt, so every flag after them runs without one too. These turn them into a file write
# (--output), a read of any file on the machine (--no-index; a `git diff` of a path outside the
# repository, which git treats as --no-index; commit -F and --file) or the run of a configured command
# (--ext-diff). The command is read as the shell hands it to git: '--output=x', "--output"=x and
# --out\put=x are the flag, while a flag named inside a quoted message or a heredoc body is not.
# Variables and $(...) outside quotes are not expanded, so this is a text match like the rest.
sq1="'"

# Cut out the heredoc bodies (git commit -F - <<'EOF' ...; hre, the header's pattern, is set above). A quoted delimiter makes
# the body plain text; an unquoted one expands $(...) and backticks, so a body with those stays.
# B40: a body is in hdc (the destructive rules' bodies) and hnm (the file-writing flag rules') only when a shell runs it. A commit's
# or tag's message (hmsg) is text no shell runs, and so is a cat or tee body (hwr, collected in hwb) unless the command names a
# runner (hrun_re, after the loop). Every body is in hall for the variable rules (B37), and an unquoted body's substitutions are
# in gtext (B32). A shell body is collected in hsh.
gtext=""; delim=""; hquote=""; body=""; hall=""; hsh=""; hwb=""; hdc=""; hnm=""; hmsg=0; hwr=0; hpre=""; hsubb=0
while IFS= read -r line || [ -n "$line" ]; do
  if [ -n "$delim" ]; then
    if [ "${line#"${line%%[![:space:]]*}"}" = "$delim" ]; then
      delim=""
      [[ -n $hquote || ( $body != *'$('* && $body != *'`'* ) ]] || { gtext+="${body//[\'\"]/_}"; hsubb=1; }   # an unquoted body's quotes are text (B32), and its substitutions are read whole (B43)
      hall+="$body"
      if ((hmsg)); then :
      elif ((hwr)); then hwb+="$body"
      else hsh+="$body"; fi
      body=""
    else body+="$line$nl"; fi
    continue
  fi
  gtext+="$line$nl"
  if [[ $line =~ $hre ]]; then
    delim="${BASH_REMATCH[3]}"; hquote="${BASH_REMATCH[2]}"
    # hmsg: the header's command, up to the << (after its last ; & |), is a commit's or tag's, and the line names no shell.
    # A substitution in that command runs one, so only $(cat, which prints the message, keeps the body a message.
    hpre="${line%%<<*}"; hpre="${hpre##*[;&|]}"; hsub="${hpre//'$(cat'/}"
    hmsg=0
    [[ $hpre =~ $hmsg_re && $hsub != *'$('* && $hsub != *'<('* && $hsub != *'>('* && $hsub != *"$bt"* && ! $line =~ $hshell_re ]] && hmsg=1
    hwr=0; if ((!hmsg)) && [[ $hpre =~ $hcat_re ]]; then hwr=1; fi
  fi
done <<<"$real"
gtext+="$body"   # a heredoc that never closes keeps its text: a false block beats a miss
[[ -n $body ]] && hsubb=1   # its text is read whole too, so the comment reading (B43) is off for it
hall+="$body"    # every body, for the variable rules (B37): a body may be a script a shell runs
hsh+="$body"
# B40: a cat or tee body is read as a shell body when the command names a runner. The text is read with its quotes removed, so
# "bash" x.sh names bash, and quoted text with a space in it is blanked, as decode_words blanks it, so a message that names bash
# doesn't. A redirect's target (> ./x) is no run, so the space after > goes.
if [[ -n $hwb ]]; then
  rt="$gtext"
  while [[ $rt == *'> '* ]]; do rt="${rt//'> '/'>'}"; done
  while [[ $rt =~ \"[^\"]*[[:space:]][^\"]*\" ]]; do rt="${rt/"${BASH_REMATCH[0]}"/ Q }"; done
  while [[ $rt =~ \'[^\']*[[:space:]][^\']*\' ]]; do rt="${rt/"${BASH_REMATCH[0]}"/ Q }"; done
  rt="${rt//[\"\']/}"
  [[ $rt =~ $hrun_re ]] && hsh+="$hwb"
fi
# B39: a backtick ends a flag in a body a shell runs, so hdc and hnm hold each backtick of such a body as a space. A backtick in a
# message is read by B32 in gtext, where an unquoted body's substitutions are.
hdc="${hsh//"$bt"/ }"; hnm="$hdc"

# B32: the substitutions are read out of the command first (subst_cut), so the quote reading below sees placeholders, not
# their text: a quote or a ) inside a substitution can't end a quoted string or the substitution early. Outside git's
# reading (no git in the command) an unreadable substitution is left as it is.
subc=(); subk=(); sn=0
subst_cut "$gtext" || { ((isgit)) && block "$MSG_UNREAD"; cut_out="$gtext"; subc=(); subk=(); sn=0; }
# B37: a variable the command assigns once, to a plain value, is read as that value before the rules below (var_resolve).
((isgit)) && [[ $cut_out$hall == *'$'* ]] && var_resolve

# decode_words <text>: sets dec to the words the shell hands a command, as the rules read them (B26, B33). The quoted strings
# are walked from the left. One with a space in it is message text, so it's blanked. One without a space is kept as a
# word: a flag ("--force", '-D'), a refspec ("+main"), a path (".") or a subcommand ("drop") reads as it does to the
# shell. A quoted string that is a flag by itself, or sits inside a word (--out"put"=x), keeps its spaces too. Inside a
# kept string, ; & | < > ( ) and a line break are text, not separators: each is marked \x05, which no rule matches.
# A "..." holding a substitution keeps its text, which has the placeholder, so the substitution's word is judged (B32).
x5=$'\x05'
qre='^(([^"'$sq1'\\]|\\.)*)("(([^"\\]|\\.)*)"|'$sq1'([^'$sq1']*)'$sq1')'
decode_words() {
  local rest="$1" pre quoted inner word keep
  dec=""
  while [[ $rest =~ $qre ]]; do
    pre="${BASH_REMATCH[1]}"; quoted="${BASH_REMATCH[3]}"; rest="${rest:${#BASH_REMATCH[0]}}"
    inner="${quoted:1:${#quoted}-2}"
    if [[ $pre == *'$' && $pre != *'\$' ]]; then   # $'...' and $"...": drop the $
      pre="${pre%?}"
      [[ $quoted == "'"* && $inner =~ \\[xuU0-7] ]] && block "ANSI-C quoting with a numeric escape (\$'\\055') can spell any flag past this check"
    fi
    pre="${pre//\\/}"        # outside quotes a backslash only escapes the next character (a joined line is already one line)
    dec+="$pre"
    if [[ $inner == *$'\x1a'* ]]; then dec+="${inner//\\/}"; continue; fi   # a double-quoted substitution (B32)
    word="${dec##*[[:space:];&|]}"               # the word so far
    keep=0
    if [[ $inner =~ ^--?[A-Za-z] ]]; then keep=1
    elif [[ $inner != *[[:space:]]* ]]; then keep=1
    elif [[ -n $word && $word =~ ^--[^=]*$ ]]; then keep=1; fi
    if ((keep)); then
      inner="${inner//[;&|<>()]/$x5}"; inner="${inner//$nl/$x5}"
      dec+="$inner"
    else dec+=" Q "; fi
  done
  rest="${rest//\\/}"; dec+="${rest//[\"$sq1]/}"   # a quote left over never closes
  dec="${dec//$nl/;}"; dec="${dec//>&/> }"; dec="${dec//&>/> }"
}
decode_words "$cut_out"; gcode="$dec"

# bdecode <bodies>: sets dec to the bodies as decode_words reads them (B33). A body over 4 KB keeps every word a quote or a
# backslash hid, which costs one pass over the text rather than one per quote (a 300-line body with a quote on each line took
# seconds); exposing a word can't hide a flag.
bdecode() {
  if ((${#1} <= 4096)); then decode_words "$1"
  else
    dec="${1//[\"\'\\]/}"; dec="${dec//$nl/;}"; dec="${dec//>&/> }"; dec="${dec//&>/> }"
  fi
}
# B33, B39: the heredoc bodies the destructive rules read (dcode): each body that names one of their subcommands, decoded as the
# command is. A body without one of those subcommands can't match a rule, so only a body with one is read (the test runs with
# the quotes and backslashes removed, so pu"sh" is still found). A body is a script a shell runs, or a message that names a
# rule (B40 covers the over-block of a message).
bcode=""
if [[ ${hdc//[\"\'\\]/} =~ push|reset|clean|checkout|switch|restore|stash|branch|commit ]]; then bdecode "$hdc"; bcode="$dec"; fi
dcode="$gcode;$bcode"
# B39: the bodies a shell runs (hnm: any heredoc but a commit's or tag's message) that name git are read by the file-writing,
# file-reading and program flags and by the words of a git command (fcode). A message isn't, so it passes as it did.
ncode=""
if [[ ${hnm//[\"\'\\]/} =~ git ]]; then bdecode "$hnm"; ncode="$dec"; fi
fcode="$gcode;$ncode"
# B39: the credential-print rules read the command's decoded words, bodies included, with the quotes removed as the shell removes them.
# The decode runs only when gh or credential is named in the quote-free text (it's the costly part for a long message).
rdec=""
if [[ ${real//[\"\'\\]/} =~ (^|[^[:alnum:]_.-])(gh|credential)[[:space:]] ]]; then decode_words "$real"; rdec="$dec"; fi
[[ $rdec =~ $gh_print_re ]] && block "gh auth token and gh auth status -t print the gh CLI's stored token"
[[ $rdec =~ $git_print_re ]] && block "git credential fill and get print a credential from git's credential store"
# B32: each substitution's text is read as a command of its own (a view), so git's rules judge the git inside it.
if ((isgit)); then
  for ((vn = 0; vn < ${#subc[@]}; vn++)); do
    ((${#views[@]} < 64)) || block "the command has more command substitutions than the guard reads in time"
    c="${subc[vn]}"; c="${c#"${c%%[![:space:]]*}"}"; c="${c%"${c##*[![:space:];]}"}"
    vdep[${#views[@]}]=${vdep[vi]:-0}; vcov[${#views[@]}]=${vcov[vi]:-0}; vpx[${#views[@]}]=${vpx[vi]:-0}; views+=("$c")
  done
  # B37: a variable left in a git command's words, or in a body a shell runs, is judged where it stands (var_judge). B38: the
  # command's own words are also read for their configuration keys and program flags (cfg_segment), never a heredoc body. That
  # read is about 0.2 s for a 3 KB message, so it runs only when cfg_pre finds a git option or a remote subcommand in the words
  # (quotes and $ removed, so "git" -c and $'-c' are found too) or a variable is there for B37 to judge.
  cbare="${cut_out//[\"\'\\\$]/}"
  if [[ $cut_out == *'$'* || $cbare =~ $cfg_pre ]]; then var_judge "$cut_out" 1; fi
  [[ $hall == *'$'* ]] && var_judge "$hall"
  # B38: a variable that names a program git runs, set on the command's line. gcode has the quotes decoded, so a quoted message
  # doesn't count, and a heredoc body isn't in it.
  shopt -s nocasematch
  [[ $gcode =~ $env_run_re ]] && block "$MSG_ENVRUN"
  shopt -u nocasematch
fi

# --- git: destructive rules (B33) ------------------------------------------------------------------
# These read dcode: the words as gcode decodes them (decode_words, B26), so a quoted flag or refspec is seen and a quoted
# message is not, plus the heredoc bodies that name one of the subcommands below. A body is text a shell may run
# (bash <<'EOF' with a force push in it), so the cut that keeps a message body out of the flag rules doesn't apply here.
# A flag ends at a space, a separator, a bracket, a redirect or =, or at the end of the command (flag_end), so one
# followed by ; & | ) or a line break is found too.
flag_end='([[:space:];&|()<>=]|$)'
if ((isgit)); then
  # dcode and bcode (the bodies, decoded) are set above, where the bodies are read (B33, B39).
  shopt -s nocasematch
  [[ $raw =~ core\.hookspath ]] && block "changing core.hooksPath switches the pre-commit hook off"
  shopt -u nocasematch

  [[ $raw =~ --no-veri ]] && block "--no-verify skips the project check"
  # git commit -n in a body: the flags of a commit are read from its words below (B26), where -- ends the options.
  [[ $bcode =~ commit${seg}[[:space:]]-[a-mo-zA-Z]*n[a-zA-Z]*$flag_end ]] && block "git commit -n skips the project check"
  [[ $dcode =~ push${seg}[[:space:]](--force|--force-with-lease|--force-if-includes|-[a-zA-Z]*f[a-zA-Z]*)$flag_end ]] && block "force-push rewrites shared history"
  [[ $dcode =~ push${seg}[[:space:]]\+[^[:space:]] ]] && block "a +refspec force-pushes"
  [[ $dcode =~ reset${seg}[[:space:]]--ha ]] && block "git reset --hard discards uncommitted work"
  [[ $dcode =~ clean${seg}[[:space:]](-[a-zA-Z]*f|--force) ]] && block "git clean -f deletes untracked files"
  [[ $dcode =~ (checkout|switch)${seg}[[:space:]](-[a-zA-Z]*f[a-zA-Z]*|--force|--discard-changes)$flag_end ]] && block "this discards uncommitted changes"
  [[ $dcode =~ (checkout|restore)${seg}[[:space:]](--[[:space:]]+)?\.$flag_end ]] && block "this discards every uncommitted change"
  [[ $dcode =~ stash[[:space:]]+(drop|clear) ]] && block "this deletes stashed work"
  [[ $dcode =~ branch${seg}[[:space:]]-[a-zA-Z]*D[a-zA-Z]*$flag_end ]] && block "git branch -D deletes unmerged work"
fi

gitre='(^|[^[:alnum:]_./-])git[[:space:]]'
gitflag() { [[ $fcode =~ $gitre($seg[[:space:]])?$1 ]]; }
gitflag '--output([[:space:]=;&|]|$)' && block "--output writes a file to any path, such as one a later command runs"
gitflag '--no-index([[:space:]=;&|]|$)' && block "--no-index reads any file on the machine"
gitflag '--ext' && block "--ext-diff runs a configured external command"

# Per command: git commit and git tag -F and --file read any file (the message may come from stdin:
# -F -; `git tag -n` prints a tag's message), a git diff of a path outside the repository reads it too,
# and git grep -O and --open-files-in-pager run a command as the pager. The subcommand is the first word
# after git that isn't an option, so `git log --grep commit -F` is not a commit.
#
# And bash or sh: a script path under tools/, the first word that isn't an option, must not leave it
# with a .. segment. `Bash(bash tools/stacks/*.sh*)` matches `bash tools/stacks/../../x.sh`, and a * in
# a permission rule matches any characters, so the rule alone doesn't keep a script inside tools/. A
# path outside tools/ matches no allow rule, so it asks the human anyway.
outre='^(/|~|[A-Za-z]:|\$[A-Za-z_{])|(^|/)\.\.(/|$)'
dotsre='(^|/)\.\.(/|$)'
IFS=';&|' read -r -d '' -a gsegs <<<"$fcode" || true
for gs in "${gsegs[@]}"; do
  gs="${gs//$brackets/ }"
  read -ra w <<<"$gs"
  n=${#w[@]}; k=0
  ((isgit)) && subst_segment
  # bash or sh as the command word (after VAR=x, env, time, nohup, exec, command and sudo)
  while ((k < n)) && [[ ${w[k]} =~ ^([A-Za-z_][A-Za-z0-9_]*=.*|\$|env|time|nohup|exec|command|sudo)$ ]]; do ((k++)); done
  if ((k < n)) && [[ ${w[k]} =~ (^|/)(ba)?sh$ ]]; then
    for ((k++; k < n; k++)); do
      case ${w[k]} in -o|-O|+o|+O|--rcfile|--init-file) ((k++)); continue ;; -*|+*) continue ;; esac
      [[ ${w[k]} =~ ^(\./)?tools/ && ${w[k]} =~ $dotsre ]] && block "a bash script path with a .. segment can run a script outside the allowed ones"
      break
    done
  fi
  k=0
  while ((k < n)) && [[ ${w[k]} != git ]]; do ((k++)); done
  ((k++))
  while ((k < n)); do
    case ${w[k]} in -C|-c) ((k += 2)) ;; -*) ((k++)) ;; *) break ;; esac
  done
  case ${w[k]:-} in
    commit|tag)
      sub="${w[k]}"
      if [[ $sub == commit ]]; then
        # git commit -n and --no-verify in any spelling the shell reads as the flag (B26): a short cluster
        # holding n, or --no-veri*. A -- ends the options, so a path after it isn't checked; a -- right after
        # a word that starts with - is that option's value (git commit -m -- '-n' takes -- as the message).
        prev=""
        for ((j = k + 1; j < n; j++)); do
          a="${w[j]}"
          [[ $a == -- && $prev != -* ]] && break
          [[ $a =~ ^-[a-mo-zA-Z]*n[a-zA-Z]*$ || $a == --no-veri* ]] &&
            block "git commit -n and --no-verify skip the project check, however the flag is quoted or split"
          prev="$a"
        done
      fi
      for ((k++; k < n; k++)); do
        a="${w[k]}"
        if [[ $a =~ ^-[adefilnopqsvz]*F(.*)$ ]]; then v="${BASH_REMATCH[1]:-${w[k+1]:-}}"
        elif [[ $a =~ ^--fi(l|le)?(=(.*))?$ ]]; then
          if [[ -n ${BASH_REMATCH[2]} ]]; then v="${BASH_REMATCH[3]}"; else v="${w[k+1]:-}"; fi
        else continue; fi
        [[ $v == - ]] || block "git $sub -F and --file read any file on the machine; give the message on stdin: git $sub -F - <<'EOF'"
      done ;;
    diff)
      for ((k++; k < n; k++)); do
        [[ ${w[k]} == -* ]] && continue
        [[ ${w[k]} =~ $outre ]] && block "git diff of a path outside the repository reads any file on the machine"
      done ;;
    grep)
      # -O takes its command attached (-Ovim; -O alone runs the configured pager), and git reads it inside a
      # cluster too (-iO, -nOvim). -e -f -A -B -C -m take the rest of the word, or the next word, as their
      # value, so a -O after them is a value (-eO is the pattern O). After -- come paths. --open-files-in-pager
      # may be shortened to any prefix git accepts, --op and longer.
      for ((k++; k < n; k++)); do
        a="${w[k]}"
        [[ $a == -- ]] && break
        if [[ $a == --* ]]; then
          name="${a%%=*}"
          [[ $name == --op* && --open-files-in-pager == "$name"* ]] && block "git grep --open-files-in-pager runs a command as the pager"
        elif [[ $a == -* ]]; then
          cl="${a#-}"
          while [[ -n $cl ]]; do
            c="${cl:0:1}"; cl="${cl:1}"
            case $c in
              O) block "git grep -O runs a command as the pager" ;;
              [efABCm]) [[ -n $cl ]] || ((k++)); break ;;
            esac
          done
        fi
      done ;;
    push)
      # B39: --mirror and --delete, and any prefix of them that git accepts (--mi, --de), -d (and a cluster holding d, such as -fd)
      # and a :ref refspec, which deletes the ref it names. A word that starts with : is a refspec, so the rule is conservative.
      for ((k++; k < n; k++)); do
        a="${w[k]}"
        [[ $a == -- ]] && break
        if [[ $a == --* ]]; then
          name="${a%%=*}"; name="${name#--}"
          [[ -n $name && mirror == "$name"* ]] && block "git push --mirror overwrites every ref on the remote"
          [[ -n $name && delete == "$name"* ]] && block "git push --delete deletes a branch or tag on the remote"
        elif [[ $a == -?* ]]; then
          [[ ${a#-} == *d* ]] && block "git push -d deletes a branch or tag on the remote"
        elif [[ $a == :* ]]; then
          block "a push refspec that starts with : deletes the remote ref it names"
        fi
      done ;;
    branch)
      # B39: a delete flag (--delete, -d, -D) and a force flag (--force, -f), in either order or in one cluster (-df), deletes a
      # branch whether or not it's merged. Their long forms are read as git reads an unambiguous prefix (--del, --forc).
      del=0; frc=0
      for ((k++; k < n; k++)); do
        a="${w[k]}"
        [[ $a == -- ]] && break
        if [[ $a == --* ]]; then
          name="${a%%=*}"; name="${name#--}"
          [[ -n $name && delete == "$name"* ]] && del=1
          [[ -n $name && force == "$name"* ]] && frc=1
        elif [[ $a == -?* ]]; then
          cl="${a#-}"
          [[ $cl == *[dD]* ]] && del=1
          [[ $cl == *f* ]] && frc=1
        fi
      done
      ((del && frc)) && block "git branch with --delete and --force deletes a branch whether or not it's merged" ;;
  esac
done
done

exit 0
