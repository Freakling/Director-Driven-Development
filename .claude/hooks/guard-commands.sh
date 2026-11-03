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
# or tag's -m value) passes, and only when its text is a plain read. See the section "Substitutions" below.

IFS= read -r -d '' input || true
re='"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)"'
[[ $input =~ $re ]] || exit 0
raw="${BASH_REMATCH[1]}"

# The tool's name (B28): only PowerShell reads a backtick at a line's end as a continuation, so the join
# below is for it alone. The name is a JSON string, matched as the command is.
tre='"tool_name"[[:space:]]*:[[:space:]]*"([^"]*)"'
tool=""; [[ $input =~ $tre ]] && tool="${BASH_REMATCH[1]}"

# PowerShell (B28): a backtick that ends a line continues it, as a backslash does in Bash (B25). PowerShell's
# parser agrees when the backtick isn't escaped: an odd run of backticks before the line break joins it, so
# `` (an escaped backtick) keeps the break, and a backtick followed by spaces doesn't continue. In Bash a
# backtick is command substitution, so the text stays. The rules read the command as written, then as joined,
# with ; between the two. Where PowerShell ends a comment at the line break (# note`), the join would glue
# the next line onto the comment's last word and hide it; the text as written still shows it.
bt='`'; jcr='\r'; jlf='\n'; x3=$'\x03'
if [[ $tool == PowerShell ]]; then
  joined="${raw//"$bt$bt"/$x3}"
  joined="${joined//"$bt$jcr$jlf"/}"; joined="${joined//"$bt$jcr"/}"; joined="${joined//"$bt$jlf"/}"
  # A backtick before a letter, digit or name punctuation is an escape that leaves that character (B30): Get-Con`tent
  # is Get-Content, and .en`v.local names .env.local, so the reader and the name are read as PowerShell reads them. A
  # backtick before a quote, a $, a space or a separator stays, since it escapes only that character and joins no name.
  if [[ $joined == *"$bt"* ]]; then
    for c in {a..z} {A..Z} {0..9} . _ / '\' : '*' '?' '~' % @ + = , '#' -; do
      joined="${joined//"$bt$c"/"$c"}"
    done
  fi
  joined="${joined%"$bt"}"   # a backtick at the very end escapes nothing, so `git push `echo --force` reads as git push echo --force (B32)
  joined="${joined//$x3/$bt$bt}"
  [[ $joined != "$raw" ]] && raw="$raw;$joined"
fi

# The readings of the command (B31). A backslash at a line's end continues the command in Bash (B25), but a comment
# holds its backslash: Bash ends a comment at the line break, so `# note\` is a comment and the next line is a command
# of its own. Joining that line onto the comment would hide it. So each rule reads every reading in turn, and no
# reading joins two lines that Bash keeps apart:
#   as written: every line break kept, so a command after a comment shows on its own line;
#   as joined: every continuation joined, as Bash reads a command that holds no comment;
#   from each line after one that holds a comment marker and ends in a continuation: joined from that line on, since
#     the comment may have ended that line (the joined reading glues `git` onto a comment's last word: `# a`, `git`).
# A # inside a word (a#b) is no comment, so its continuation is joined in the joined reading, as Bash joins it.
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

# sub_end <text> <start>: sub_e is the index of the ) that closes a substitution whose text starts at <start>. Quoted strings
# and escapes are skipped, so a ) inside them doesn't count. Returns 1 when it doesn't close, or when a double-quoted string
# in it holds a substitution or a backtick.
sub_end() {
  local s="$1" j=$2 L=${#s} depth=1 c k
  while ((j < L)); do
    c="${s:j:1}"
    if [[ $c == "$sesc" ]]; then ((j += 2)); continue; fi
    case $c in
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
# Returns 1 when a substitution can't be read (see MSG_UNREAD).
subst_cut() {
  local s="$1" i=0 L ch nx t st e txt kind start wsf lit before pwd dqkind="" indq=0 dqpos=0
  if [[ $tool == PowerShell ]]; then sesc='`'; else sesc='\'; fi
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
    fi
    st=0
    if [[ $ch == '$' && $nx == '(' ]]; then st=$((i + 2))
    elif ((!indq)) && [[ $tool == PowerShell && $ch == '(' ]]; then st=$((i + 1))
    elif ((!indq)) && [[ $tool != PowerShell && ( $ch == '<' || $ch == '>' ) && $nx == '(' ]]; then st=$((i + 2))
    fi
    if ((st > 0)); then
      sub_end "$s" "$st" || return 1
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

# A comment starts at a # that begins a word: after a blank, a line start or a metacharacter, as Bash reads it.
cmt_re='(^|[[:blank:]|&;()<>])#'
views=("$raw")
if [[ $tool != PowerShell ]]; then
  pl="${raw//\\\\/$x1}"; pl="${pl//$x1$x1/$x2}"; pl="${pl//$x1\\n/$x4$nl}"; pl="${pl//\\n/$nl}"
  if [[ $pl == *"$x4"* ]]; then
    phys=(); rest="$pl"
    while [[ $rest == *"$nl"* ]]; do phys+=("${rest%%"$nl"*}"); rest="${rest#*"$nl"}"; done
    phys+=("$rest"); nphys=${#phys[@]}
    view_of 0 0; views=("$view")
    view_of 0 1; views+=("$view")
    for ((k = 1; k < nphys; k++)); do
      [[ ${phys[k-1]} == *"$x4" && ${phys[k-1]} =~ $cmt_re ]] || continue
      # Each such line costs a pass of the rules, so a command with very many can't run past the hook's time limit.
      if ((${#views[@]} >= 64)); then
        echo "App Director: blocked: the command has more lines that end in a backslash after a comment marker than the guard can read in time. If it's really needed, ask the human to run it." >&2
        exit 2
      fi
      view_of "$k" 1; views+=("$view")
    done
  fi
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

# --- Credential file reads ------------------------------------------------------------------------
# Block direct shell reads of .env and .env.<suffix> (not the templates .env.example, .env.sample,
# .env.template and .env.dist), of *.pem and *.key, and of the credential stores: ~/.ssh (any key,
# known_hosts too), git's credentials files, and the gh CLI's hosts.yml (.config/gh, or AppData's
# GitHub CLI). A path is blocked when it is one of those or sits inside one, however it is written:
# ~/, $HOME/, ${HOME}/, /c/Users/<name>/, C:\Users\<name>\ or relative. The commands that print a
# stored credential are blocked as well (gh auth token, gh auth status -t, git credential fill or get).
# These files may hold live credentials. Any credential read in a conversation context must be
# considered compromised and rotated. This is a best-effort check on the command text; indirect
# reads are not detected. The readers are Bash's (cat, head, tail, less, more, strings) and PowerShell's
# (Get-Content, its aliases gc and type, Select-String and its alias sls, and [IO.File]::ReadAllText and
# its siblings), matched in any case (B27), by a path (/bin/cat), quoted (& 'Get-Content'), with .exe, or with a
# backtick escape inside a word (Get-Con`tent, B30); [IO.StreamReader]::new and New-Object System.IO.StreamReader
# are readers too (B30). The check runs for every tool the hook is wired to.
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
  local readers='(cat|head|tail|less|more|strings|type|gc|get-content|select-string|sls)'
  local name_quote="['\"]*"
  local read_re='(^|[[:space:]|;&("'"'"'`\\/])'"$readers"'(\.exe)?'"$name_quote"'[[:space:]]+([^;&|]*)'
  # [IO.File]::ReadAllText(...), and its ReadAllLines, ReadAllBytes and ReadLines: the arguments run to the next ; & or |.
  local file_re='(^|[^[:alnum:]_.-])\[(system\.)?io\.file\]::read(all)?(text|lines|bytes)[[:space:]]*\(([^;&|]*)'
  # [IO.StreamReader]::new(...) and New-Object System.IO.StreamReader (-TypeName ... -ArgumentList ...), whose
  # arguments run to the next ; & or | as well (B30).
  local stream_re='(^|[^[:alnum:]_.-])(\[(system\.)?io\.streamreader\]::new|new-object[[:space:]]+(-typename[[:space:]]+)?(system\.)?io\.streamreader)([^;&|]*)'
  local rest="$cmd" args
  while [[ $rest =~ $read_re ]]; do
    args="${BASH_REMATCH[4]}"
    rest="${rest#*"${BASH_REMATCH[0]}"}"
    cred_args "$args" && return 0
  done
  rest="$cmd"
  while [[ $rest =~ $file_re ]]; do
    args="${BASH_REMATCH[5]}"
    rest="${rest#*"${BASH_REMATCH[0]}"}"
    cred_args "$args" && return 0
  done
  rest="$cmd"
  while [[ $rest =~ $stream_re ]]; do
    args="${BASH_REMATCH[6]}"
    rest="${rest#*"${BASH_REMATCH[0]}"}"
    cred_args "$args" && return 0
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
# gh auth token, gh auth status -t and git credential fill or get print a stored credential. Matched on
# code (the command with its quoted text blanked), so a commit message that names them isn't blocked.
gh_print_re='(^|[^[:alnum:]_./-])gh[[:space:]]+auth[[:space:]]+(token([[:space:]]|$|[;&|)])|status[^;&|]*[[:space:]](-[[:alpha:]]*t[[:alpha:]]*|--show-token)([[:space:]]|$|[;&|)]))'
git_print_re='(^|[^[:alnum:]_./-])git[[:space:]]+([^;&|]*[[:space:]])?credential[[:space:]]+(fill|get)([[:space:]]|$|[;&|)])'
[[ $code =~ $gh_print_re ]] && block "gh auth token and gh auth status -t print the gh CLI's stored token"
[[ $code =~ $git_print_re ]] && block "git credential fill and get print a credential from git's credential store"

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
scan="$code"
[[ $code =~ (bash|sh|zsh)[[:space:]]+-[a-z]*c[[:space:]] ]] && scan="$raw"
scan="${scan//\\n/$nl}"
loop_re='(^|[^[:alnum:]_./-])(until|while)[[:space:]]'
timeout_re="(^|[^[:alnum:]_./-])timeout[[:space:]]+(-[-[:alnum:]=]+[[:space:]]+)*([0-9]+)([sm]?)[[:space:]]+[^;&|$nl]*\$"
rest="$scan"; before=""
while [[ $rest =~ $loop_re ]]; do
  before="$before${rest%%"${BASH_REMATCH[0]}"*}${BASH_REMATCH[1]}"
  rest="${rest#*"${BASH_REMATCH[0]}"}"
  loop="${rest%%[;[:space:]]done[;[:space:])\'\"]*}"
  [[ $loop =~ (^|[^[:alnum:]_./-])sleep[[:space:]] ]] || continue
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

# --- git-specific rules --------------------------------------------------------------------------
# A substitution's brackets are read as blanks, so $(echo git) counts as a git command (B32).
isgit=0; [[ ${detect//$brackets/ } =~ (^|[^[:alnum:]_./-])git([[:space:]]|$) ]] && isgit=1
isbash=0; [[ $detect =~ (^|[^[:alnum:]_.-])(ba)?sh([[:space:]]|$) ]] && isbash=1
((isgit || isbash)) || continue

seg='[^;&|]*'
if ((isgit)); then
  shopt -s nocasematch
  [[ $raw =~ core\.hookspath ]] && block "changing core.hooksPath switches the pre-commit hook off"
  shopt -u nocasematch

  [[ $raw =~ --no-veri ]] && block "--no-verify skips the project check"
  [[ $code =~ commit${seg}[[:space:]]-[a-mo-zA-Z]*n[a-zA-Z]*([[:space:]]|$) ]] && block "git commit -n skips the project check"
  [[ $code =~ push${seg}[[:space:]](--force|--force-with-lease|--force-if-includes|-[a-zA-Z]*f[a-zA-Z]*)([[:space:]=]|$) ]] && block "force-push rewrites shared history"
  [[ $code =~ push${seg}[[:space:]]\+[^[:space:]] ]] && block "a +refspec force-pushes"
  [[ $code =~ reset${seg}[[:space:]]--ha ]] && block "git reset --hard discards uncommitted work"
  [[ $code =~ clean${seg}[[:space:]](-[a-zA-Z]*f|--force) ]] && block "git clean -f deletes untracked files"
  [[ $code =~ (checkout|switch)${seg}[[:space:]](-f|--force|--discard-changes)([[:space:]]|$) ]] && block "this discards uncommitted changes"
  [[ $code =~ (checkout|restore)${seg}[[:space:]](--[[:space:]]+)?\.([[:space:]]|$) ]] && block "this discards every uncommitted change"
  [[ $code =~ stash[[:space:]]+(drop|clear) ]] && block "this deletes stashed work"
  [[ $code =~ branch${seg}[[:space:]]-D([[:space:]]|$) ]] && block "git branch -D deletes unmerged work"
fi

# --- git: flags that write a file, read outside the repository or run a configured command --------
# settings.json allows `git diff *`, `git log *`, `git show *`, `git commit *` and `git stash *` without
# a prompt, so every flag after them runs without one too. These turn them into a file write
# (--output), a read of any file on the machine (--no-index; a `git diff` of a path outside the
# repository, which git treats as --no-index; commit -F and --file) or the run of a configured command
# (--ext-diff). The command is read as the shell hands it to git: '--output=x', "--output"=x and
# --out\put=x are the flag, while a flag named inside a quoted message or a heredoc body is not.
# Variables and $(...) outside quotes are not expanded, so this is a text match like the rest.
sq1="'"

# Cut out the heredoc bodies (git commit -F - <<'EOF' ...). A quoted delimiter makes the body plain
# text; an unquoted one expands $(...) and backticks, so a body with those stays.
hre='(^|[^<])<<-?[[:space:]]*(\\?["'"'"']?)([A-Za-z_][A-Za-z0-9_]*)'
gtext=""; delim=""; hquote=""; body=""
while IFS= read -r line || [ -n "$line" ]; do
  if [ -n "$delim" ]; then
    if [ "${line#"${line%%[![:space:]]*}"}" = "$delim" ]; then
      delim=""
      [[ -n $hquote || ( $body != *'$('* && $body != *'`'* ) ]] || gtext+="${body//[\'\"]/_}"   # an unquoted body's quotes are text (B32)
      body=""
    else body+="$line$nl"; fi
    continue
  fi
  gtext+="$line$nl"
  [[ $line =~ $hre ]] && { delim="${BASH_REMATCH[3]}"; hquote="${BASH_REMATCH[2]}"; }
done <<<"$real"
gtext+="$body"   # a heredoc that never closes keeps its text: a false block beats a miss

# B32: the substitutions are read out of the command first (subst_cut), so the quote reading below sees placeholders, not
# their text: a quote or a ) inside a substitution can't end a quoted string or the substitution early. Outside git's
# reading (no git in the command) an unreadable substitution is left as it is.
subc=(); subk=(); sn=0
subst_cut "$gtext" || { ((isgit)) && block "$MSG_UNREAD"; cut_out="$gtext"; subc=(); subk=(); sn=0; }

# Walk the quoted strings from the left. One that is a flag by itself ('--output=x') or sits inside
# a word (--out"put"=x) is unquoted so the flag shows; any other is message text and is blanked. A "..." holding a
# substitution keeps its text, which has the placeholder, so the substitution's word is judged (see subst_cut).
qre='^(([^"'$sq1'\\]|\\.)*)("(([^"\\]|\\.)*)"|'$sq1'([^'$sq1']*)'$sq1')'
glued='^[^[:space:];&|<>)]'
gcode=""; rest="$cut_out"
while [[ $rest =~ $qre ]]; do
  pre="${BASH_REMATCH[1]}"; quoted="${BASH_REMATCH[3]}"; rest="${rest:${#BASH_REMATCH[0]}}"
  inner="${quoted:1:${#quoted}-2}"
  if [[ $pre == *'$' && $pre != *'\$' ]]; then   # $'...' and $"...": drop the $
    pre="${pre%?}"
    [[ $quoted == "'"* && $inner =~ \\[xuU0-7] ]] && block "ANSI-C quoting with a numeric escape (\$'\\055') can spell any flag past this check"
  fi
  pre="${pre//\\/}"        # outside quotes a backslash only escapes the next character (a joined line is already one line)
  gcode+="$pre"
  if [[ $inner == *$'\x1a'* ]]; then gcode+="${inner//\\/}"; continue; fi   # a double-quoted substitution (B32)
  word="${gcode##*[[:space:];&|]}"               # the word so far
  if [[ $inner =~ ^--?[A-Za-z] ]]; then gcode+="$inner"
  elif [[ $inner != *[[:space:]]* && ( -n $word || $rest =~ $glued ) ]]; then gcode+="$inner"
  elif [[ -n $word && $word =~ ^--[^=]*$ ]]; then gcode+="$inner"
  else gcode+=" Q "; fi
done
rest="${rest//\\/}"; gcode+="${rest//[\"$sq1]/}"   # a quote left over never closes
gcode="${gcode//$nl/;}"; gcode="${gcode//>&/> }"; gcode="${gcode//&>/> }"
# B32: each substitution's text is read as a command of its own (a view), so git's rules judge the git inside it.
if ((isgit)); then
  for ((vn = 0; vn < ${#subc[@]}; vn++)); do
    ((${#views[@]} < 64)) || block "the command has more command substitutions than the guard reads in time"
    c="${subc[vn]}"; c="${c#"${c%%[![:space:]]*}"}"; c="${c%"${c##*[![:space:];]}"}"
    views+=("$c")
  done
fi

gitre='(^|[^[:alnum:]_./-])git[[:space:]]'
gitflag() { [[ $gcode =~ $gitre($seg[[:space:]])?$1 ]]; }
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
IFS=';&|' read -r -d '' -a gsegs <<<"$gcode" || true
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
  esac
done
done

exit 0
