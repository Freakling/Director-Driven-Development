#!/usr/bin/env bash
# Docs site selftest. Run from the repository root: bash selftest.sh
#
#   1. No en or em dashes in the site sources.
#   2. Docs coverage: every command a framework ships in its pinned release is mentioned on its
#      framework page, or on the skill page that covers it (see skill_page below). A page that
#      describes a command only main ships gets a warning: the docs follow releases, not main.
#   3. Framework links: a docs link into a framework repo names that repo's pinned release tag (in
#      frameworks.lock), not main or another release, and the path it names exists at that release.
#   4. Skills nav: every skill page listed in the nav exists.
#   5. How-to links: every skill page links some page under docs/how-to/, so a reader of the skill
#      page finds the question that answers it; every page the How-to nav lists exists.
#   6. The brief's own claims (product/brief.md): the page counts in its Screens table match the nav
#      sections in mkdocs.yml; every Brief: value in TASKS.md, and every brief heading named in
#      tools/*.sh, is a heading in the brief; no Later or Planned section names a done item.
#   7. Version numbers: a docs page names no three-part version number in prose, because every page
#      assumes the latest release. Links to a release tag are left out, and so are lines about
#      the Godot engine, .NET, Node and gitleaks, which have versions of their own.
#   8. Agent permissions: .claude/settings.json allows no generic code runner (npm, npx, python,
#      node, bash...) with a wildcard, since that runs any code without a prompt. Each allow rule
#      names the exact commands the repo runs. Where it allows a wildcard git rule, it also denies
#      the git flags that write a file, read outside the repository or run a configured command,
#      and a `bash tools/` rule also denies a `..` in the path. The guard hook blocks those flags
#      and a script path with `..` (fed the PreToolUse JSON) and passes the plain forms. The Read
#      tool denies the gh CLI's, git's and ~/.ssh credential stores, and the guard hook blocks
#      reading them and the commands that print a credential (B15). The Read tool also denies the
#      .env files that hold values (.env.local and the other .env.<suffix> files), and the guard
#      hook blocks shell reads of them, while the committed templates stay readable (B21). The hook
#      tests every argument of a read, so the file may follow an option or another file (B22). A git
#      command on a later line, after a newline or a tab, is blocked as it is on its own line (B23).
#      A backslash line continuation joins the lines the guard reads, and a tab is a space, so a
#      git flag or a credential read split that way is blocked as the plain form is (B25).
#      A git commit whose -n or --no-verify is quoted or split (B26) is blocked as the plain flag is.
#      The PowerShell tool (B24) is wired the same way: the guard's matcher names it, each Bash deny
#      rule has a PowerShell twin, the hook blocks the same commands in a PowerShell payload, and the
#      allow list names no PowerShell command, so PowerShell runs nothing without a prompt.
#      The hook also blocks the PowerShell readers of a credential file (Get-Content and gc, type,
#      Select-String and sls, [IO.File]::ReadAll...), in any case, as it blocks cat (B27).
#      A PowerShell backtick at a line's end continues the line, so a flag or read it splits is
#      blocked; a Bash backtick, or an escaped one, doesn't continue a line (B28).
#      A PowerShell backtick inside a word is an escape that leaves the character, so a reader or a name it splits
#      is read as PowerShell reads it, and a quoted or path-qualified reader, or a StreamReader, is blocked too (B30).
#      The common file readers (grep, sed, awk, sort, base64, xxd and the rest) are blocked on a credential file, a
#      reader or a name split by quotes is read as the shell runs it, and [IO.File]::OpenText, OpenRead and Open are
#      readers too; a pattern is an argument as well, so grep "\.env" is blocked (B36).
#      In Bash a backslash that escapes an ordinary character is removed as the shell removes it, so c\at .env.local and
#      .en\v.local are blocked as cat is; Windows paths, the templates and PowerShell's backslash (not an escape) pass (B44).
#      A Bash comment that ends in a backslash holds no continuation (B31): the line after it is a command of its
#      own, and a continued command after such a comment is still read. The hang check reads a heredoc header
#      joined to its delimiter line (B29). A PowerShell comment that ends in a backtick is read the same way (B35).
#      A command substitution in a git command's words, or as its name, is blocked when it can print a flag or run
#      a command the guard can't read; a quoted value after fixed text, a commit's -m value and a read pass (B32).
#      In Bash a comment holds no substitution and opens no quoted string, so a backtick or $( in one passes (B43).
#      A destructive git rule (a force push, a +refspec, reset --hard, clean -f, checkout or switch -f, stash drop,
#      branch -D) reads the decoded words, so a quoted flag or refspec is blocked, and its flag ends at ; & | ) or a
#      line break; a heredoc body a shell runs is read too, and a quoted message that names a rule passes (B33).
#      A quoted script given to bash -c, sh -c, zsh -c, eval, powershell -Command, pwsh -c or cmd /c is read as a
#      command of its own, to four levels, and a command whose quoting the guard can't close is blocked (B34). A wait
#      loop (until or while) with sleep in such a script is blocked too, unless a timeout of 280 seconds or less bounds it (B42).
#      A variable in a git command's words is read as its value when the command assigns it once to a plain value
#      (FLAG=--force; git push $FLAG). Any other unquoted variable there, or a quoted one a flag or a path could be, is
#      blocked, and so is a variable as the subcommand or as a shell's name followed by -c; the everyday forms pass (B37).
#      A git -c key, or --config-env, that names a program git runs (an alias, the pager, the ssh command, a diff or a credential
#      helper) or a key a variable holds is blocked; the keys that run nothing pass. A flag that names a program for a remote
#      (--upload-pack, --receive-pack, --exec, clone's -u) is blocked, abbreviations too, and so is a GIT_CONFIG_*, GIT_PAGER or
#      EDITOR variable set on a git command (B38).
#      A quoted git name (and a quoted gh or credential subcommand) is read as the shell reads it; a heredoc body a shell runs
#      is read by the file-writing flag rules, a backtick ends a flag in it, and a commit's or tag's message is not (B39).
#      git branch with --delete and --force, git push --mirror, --delete, -d and a :ref refspec are blocked (B39).
#      A heredoc body no shell runs is text: a commit's or tag's message, and a cat or tee body that nothing in the command
#      runs (no shell, interpreter, ssh, chmod, make, ./ path, dot-source or .git folder). The destructive and file-writing rules
#      skip it, and a body written to a file and run in the same command (cat > x.sh, then bash x.sh) is still read (B40).
#      A variable as a command's name is read as the value the command assigns it (G=git; $G push --force is git push
#      --force); an unresolved one is blocked when the command sets that name another way or a git subcommand follows it,
#      and the everyday forms pass. A shell's script, eval's argument or -Command that holds a variable the caller expands is
#      blocked, and so is a bash script path under tools/ with a variable in it (B45).
#      A git command name is matched in any case, so GIT and Git are git (PowerShell finds a command case-insensitively, B46);
#      git's subcommands and flags stay case-sensitive.
#   9. The site builds in strict mode, which fails on broken internal links and anchors.
#  10. The Content-Security-Policy in overrides/main.html allows every inline script the built site
#      runs (its sha256 is in script-src), and no script runs before the policy's meta tag.
#
# frameworks.lock pins each framework to the release the docs describe. A new release therefore
# never turns the run red by itself: online, a release past the pin prints a WARN, and the docs
# follow-up item bumps the pin with the links. A pin naming a tag the remote lacks fails.
#
# The framework repos are kept as copies under .app-director/state/frameworks (gitignored), each
# at its pinned release tag (v<version>). Online, each run fetches exactly that tag. Offline, a
# cached copy at the pin is used with a notice; with no such cache and no network, the run fails.
# CI has no cache, so it clones the pinned releases fresh.
#
# FRAMEWORKS_DIR=<folder>      uses existing clones of the three framework repos instead
#                              (each as <folder>/<repo name>); no cache, no network.
# FRAMEWORKS_CACHE=<folder>    cache folder (default .app-director/state/frameworks).
# FRAMEWORKS_REMOTE_BASE=<url> GitHub owner URL (default https://github.com/Freakling).

set -u
cd "$(dirname "$0")"
fail=0
err() { echo "FAIL: $*"; fail=1; }

# 1. Dashes ---------------------------------------------------------------------------------
en=$(printf '\xe2\x80\x93'); em=$(printf '\xe2\x80\x94')
hits=$(grep -rnF -e "$en" -e "$em" docs mkdocs.yml README.md selftest.sh .github 2>/dev/null \
  | grep -v '^docs/assets/fonts/' || true)
if [ -n "$hits" ]; then err "en or em dashes found:"; echo "$hits" | sed 's/^/  /'; else echo "ok: no en or em dashes"; fi

# 2. Docs coverage --------------------------------------------------------------------------
repos="Godot-Director:godot-director App-Director:app-director SaaSAllTheThings:saasallthethings"
remote_base="${FRAMEWORKS_REMOTE_BASE:-https://github.com/Freakling}"
cache="${FRAMEWORKS_CACHE:-.app-director/state/frameworks}"
export GIT_TERMINAL_PROMPT=0 GIT_HTTP_LOW_SPEED_LIMIT=1000 GIT_HTTP_LOW_SPEED_TIME=20

# timed <seconds> <git args>: git with a time limit, so an offline run fails fast instead of hanging.
timed() {
  local secs="$1"; shift
  if [ -x /usr/bin/timeout ]; then /usr/bin/timeout "$secs" git "$@"; else git "$@"; fi
}

# latest_tag: the highest release tag (v<version>) on stdin. Versions compare by number: v1.10.0 > v1.9.0.
latest_tag() { grep -E '^v[0-9]+(\.[0-9]+)*$' | sort -V | tail -1; }

# release_at <gitdir>: the release tag the cached copy is at, or nothing when it is at no tag.
release_at() { git --git-dir="$1" tag --points-at HEAD 2>/dev/null | latest_tag; }

# pin_of <repo>: the tag frameworks.lock pins <repo> to.
pin_of() { grep -v '^[[:space:]]*#' frameworks.lock 2>/dev/null | awk -v r="$1" '$1 == r { print $2; exit }'; }

# refresh_framework <repo> <dest>: 0 when <dest> holds the pinned release of <repo>, or its cached copy.
# <dest> is a work tree at the release tag. Its git metadata sits beside it in <dest>.git, not in
# <dest>/.git: a nested repo makes `git ls-files -o` list the whole clone, which trips the pre-commit
# hook. The metadata also holds the default branch (refs/remotes/github/main) for the main-only check.
# Online, the pinned tag is fetched and checked out, and a newer release prints a WARN. A pin that
# the remote doesn't have fails. If GitHub can't be reached, or the cache has local changes, a cached
# copy at the pin is kept with a notice; a cache at another tag fails.
refresh_framework() {
  local repo="$1" dest="$2" gd="$2.git" tmp="$2.partial" url pin tags newest at
  url="$remote_base/$repo.git"
  pin=$(pin_of "$repo")
  if [ -z "$pin" ]; then err "frameworks.lock has no pin for $repo"; return 0; fi
  tags=$(timed 15 ls-remote --tags --refs "$url" 2>/dev/null | sed 's|.*refs/tags/||')
  newest=$(latest_tag <<< "$tags")
  if [ -n "$tags" ]; then
    if ! grep -qxF "$pin" <<< "$tags"; then
      err "frameworks.lock pins $repo to $pin, which $repo doesn't have on GitHub"; return 0
    fi
    if [ -n "$newest" ] && [ "$newest" != "$pin" ] && [ "$(printf '%s\n%s\n' "$pin" "$newest" | sort -V | tail -1)" = "$newest" ]; then
      echo "WARN: $repo $newest is released; the docs are pinned to $pin: bump frameworks.lock with the links in the docs follow-up"
    fi
  else
    echo "notice: could not check whether $repo has a release past its pin $pin (offline)"
  fi
  if [ -d "$gd" ] && [ -d "$dest" ]; then
    if [ -n "$tags" ] \
       && timed 120 --git-dir="$gd" fetch -q --depth 1 "$url" \
            "+HEAD:refs/remotes/github/main" "+refs/tags/$pin:refs/tags/$pin" 2>/dev/null \
       && git --git-dir="$gd" --work-tree="$dest" checkout -q --detach "refs/tags/$pin" 2>/dev/null; then
      echo "ok: $repo at its pinned release $pin ($(git --git-dir="$gd" log -1 --format='%h %cs' "$pin"))"
    else
      at=$(release_at "$gd")
      if [ "$at" = "$pin" ]; then
        echo "notice: could not move $repo to its pin (offline, or local changes in the cache); using the cached copy at $pin"
      else
        err "$repo's cached copy is at ${at:-an untagged commit}, not its pin $pin, and it can't be moved (offline, or local changes)"
      fi
    fi
    return 0
  fi
  # No cache yet: clone the pinned release.
  [ -n "$tags" ] || return 1
  rm -rf "$tmp" "$tmp.git"; mkdir -p "$tmp"
  if git --git-dir="$tmp.git" init -q \
     && timed 120 --git-dir="$tmp.git" fetch -q --depth 1 "$url" \
          "+HEAD:refs/remotes/github/main" "+refs/tags/$pin:refs/tags/$pin" \
     && git --git-dir="$tmp.git" --work-tree="$tmp" checkout -q --detach "refs/tags/$pin"; then
    rm -rf "$dest" "$gd"; mv "$tmp" "$dest"; mv "$tmp.git" "$gd"
    echo "ok: $repo cloned from GitHub into the cache, at its pin $pin"
    return 0
  fi
  rm -rf "$tmp" "$tmp.git"
  return 1
}

if [ -n "${FRAMEWORKS_DIR:-}" ]; then
  src="$FRAMEWORKS_DIR"
else
  src="$cache"; mkdir -p "$src" || { err "can't create cache folder $src"; src=""; }
  for pair in $repos; do
    repo="${pair%%:*}"
    [ -n "$src" ] || break
    refresh_framework "$repo" "$src/$repo" \
      || err "could not get $repo's pinned release: no network and no cached copy in $src/$repo (run once online)"
  done
fi

# field <key> <file>: sets FIELD to the value on the first "<key>:" line of <file>. The value is read as the sed it
# replaced read it: optional spaces, one optional quote, then the text up to the next quote. Bash reads the file, so
# a folder of skills costs no process per file (B41).
field() {
  local line rest
  FIELD=""
  while IFS= read -r line || [ -n "$line" ]; do
    case $line in
      "$1:"*)
        rest="${line#"$1:"}"; rest="${rest#"${rest%%[![:space:]]*}"}"
        case $rest in \'*|\"*) rest="${rest:1}" ;; esac
        FIELD="${rest%%[\'\"]*}"
        return 0 ;;
    esac
  done < "$2"
  return 1
}

# commands_of <folder>: one "<kind> <name>" line per command or skill a framework folder ships.
# kind is "slash" for a /name command installed into projects, "skill" for an installer or
# standalone skill. Deprecated slash commands are left out.
commands_of() {
  local f
  for f in "$1"/framework/.claude/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    field description "$f"
    case "$FIELD" in Deprecated*) continue ;; esac
    field name "$f"
    echo "slash $FIELD"
  done
  for f in "$1"/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    field name "$f"
    echo "skill $FIELD"
  done
}

# skill_page <repo> <skill>: the skill page that covers a skill under another name, if there is one.
# Godot-Director's /function-check is the acceptance check, so docs/skills/acceptance.md covers it.
skill_page() {
  case "$1:$2" in
    Godot-Director:function-check) echo docs/skills/acceptance.md ;;
  esac
}

# The default branch of each repo, unpacked for the main-only check below, and the folder the guard cases run from (B41).
main_tmp=$(mktemp -d 2>/dev/null) || main_tmp=""
guard_dir=$(mktemp -d 2>/dev/null) || guard_dir=".app-director/state/guard-cases-$$"
mkdir -p "$guard_dir"
trap 'rm -rf "$main_tmp" "$guard_dir"' EXIT

# main_copy <repo> <folder>: unpacks the default branch of <repo> from its cache into <folder>.
# Fails when the cache doesn't hold it, as with a cache made before releases were followed.
main_copy() {
  local gd="$src/$1.git" dirs
  [ -d "$gd" ] && git --git-dir="$gd" rev-parse -q --verify refs/remotes/github/main >/dev/null || return 1
  # Only the skill folders are unpacked, since commands_of reads nothing else (B41: a whole tree takes seconds on Windows).
  dirs=$(git --git-dir="$gd" ls-tree -d --name-only refs/remotes/github/main framework/.claude/skills skills)
  mkdir -p "$2" || return 1
  [ -z "$dirs" ] || git --git-dir="$gd" archive refs/remotes/github/main -- $dirs | tar -x -C "$2"
}

for pair in $repos; do
  repo="${pair%%:*}"; page="docs/frameworks/${pair##*:}.md"
  [ -d "$src/$repo" ] || { err "$repo not found in $src"; continue; }
  [ -f "$page" ] || { err "$page is missing"; continue; }
  missing=""; count=0
  page_text=$(cat "$page")   # read once: the names are matched in bash, not by a grep per name (B41)
  while read -r kind name; do
    count=$((count + 1))
    if [ "$kind" = slash ]; then
      case $page_text in *"\`/$name"*) continue ;; esac
      cover=$(skill_page "$repo" "$name")
      if [ -n "$cover" ] && [ -f "$cover" ] && grep -qF "\`/$name" "$cover"; then
        echo "ok: /$name of $repo is covered by $cover"
        continue
      fi
      missing="$missing /$name"
    else
      case $page_text in *"$name"*) ;; *) missing="$missing $name" ;; esac
    fi
  done < <(commands_of "$src/$repo")
  if [ -n "$missing" ]; then err "$page doesn't mention:$missing"
  else echo "ok: $page covers all $count commands and skills of $repo"; fi

  # A command that only main ships, named on a docs page: a warning, not a failure.
  if [ -n "$main_tmp" ] && main_copy "$repo" "$main_tmp/$repo"; then
    release_names=$(commands_of "$src/$repo" | cut -d' ' -f2)
    while read -r kind name; do
      case $'\n'"$release_names"$'\n' in *$'\n'"$name"$'\n'*) continue ;; esac
      label="$name"; [ "$kind" = slash ] && label="/$name"
      grep -rlE "\`/?$name([^a-z0-9-]|\$)" docs --include='*.md' 2>/dev/null | while IFS= read -r hit; do
        echo "warning: $hit describes $label, which the pinned release of $repo doesn't ship (main does)"
      done
    done < <(commands_of "$main_tmp/$repo")
  fi
done

# 3. Framework links ------------------------------------------------------------------------
# A docs link into a framework repo names that repo's pinned release tag (frameworks.lock). A link
# to main or to another release fails, naming the page and the link, and so does a path the
# release doesn't have. Links to a repo's root (no tree or blob path) are left alone.
link_re='github\.com/Freakling/(Godot-Director|App-Director|SaaSAllTheThings)/(tree|blob)/[^ )"]*'
links=$(grep -rnoE --include='*.md' "$link_re" docs 2>/dev/null || true)
ok_links=0
for pair in $repos; do
  repo="${pair%%:*}"
  [ -d "$src/$repo" ] || continue
  mine=$(grep -F "github.com/Freakling/$repo/" <<< "$links" || true)
  [ -n "$mine" ] || continue
  gd="$src/$repo.git"; [ -n "${FRAMEWORKS_DIR:-}" ] && gd="$src/$repo/.git"
  rel=$(pin_of "$repo")
  if [ -z "$rel" ] || ! git --git-dir="$gd" tag --points-at HEAD 2>/dev/null | grep -qxF "$rel"; then
    err "$repo's copy isn't at its pin ${rel:-(none)}, so the links into it can't be checked; check out that tag"
    continue
  fi
  # Each link is judged in its order (B41). A link to the pin names its path to one cat-file --batch-check, which
  # answers "missing" for a path the pin lacks, one answer per path and in the same order, rather than a process per link.
  kinds=(); msg_of=(); path_of=(); batch=""
  while IFS= read -r hit; do
    where=${hit%%:*}; rest=${hit#*:}; lineno=${rest%%:*}; link=${rest#*:}
    [[ $link =~ ^github\.com/Freakling/[^/]+/(tree|blob)/([^/]+)/(.*)$ ]] || continue
    ref=${BASH_REMATCH[2]}; path=${BASH_REMATCH[3]}
    if [ "$ref" != "$rel" ]; then
      kinds+=(ref); msg_of+=("$where:$lineno links to $repo at $ref, not its pinned release $rel: $link"); path_of+=("")
    else
      kinds+=(path); msg_of+=("$where:$lineno"); path_of+=("$path")
      batch="$batch$rel:$path"$'\n'
    fi
  done <<< "$mine"
  answers=""
  [ -z "$batch" ] || answers=$(printf '%s' "$batch" | git --git-dir="$gd" cat-file --batch-check 2>/dev/null)
  IFS=$'\n' read -r -d '' -a answer <<< "$answers" || true
  a=0
  for ((i = 0; i < ${#kinds[@]}; i++)); do
    if [ "${kinds[i]}" = ref ]; then
      err "${msg_of[i]}"
      continue
    fi
    case ${answer[a]:-missing} in
      *" missing") err "${msg_of[i]} links to ${path_of[i]}, which $repo's pinned release $rel doesn't have" ;;
      *) ok_links=$((ok_links + 1)) ;;
    esac
    a=$((a + 1))
  done
done
[ "$ok_links" -gt 0 ] && echo "ok: $ok_links links into the framework repos point at their pinned release"

# 4. Skills nav -----------------------------------------------------------------------------
# Every skill page listed in the nav under Skills must exist on disk.
# This catches gaps as more skill pages are added: list a skill in mkdocs.yml without
# creating the file, and the build would warn; this check makes it a hard failure.
skills_nav=$(sed -n '/^  - Skills:/,/^  - [A-Z]/p' mkdocs.yml | grep '\.md' | sed "s|.*skills/||;s|\.md.*||")
skills_fail=0
for skill in $skills_nav; do
  f="docs/skills/$skill.md"
  if [ -f "$f" ]; then
    echo "ok: $f exists"
  else
    err "$f is listed in the Skills nav but does not exist on disk"
    skills_fail=1
  fi
done
[ "$skills_fail" -eq 0 ] && [ -n "$skills_nav" ] && echo "ok: all Skills nav entries have pages on disk"

# 5. How-to links ---------------------------------------------------------------------------
# Every skill page links some page under docs/how-to/, so a reader of the skill finds the question
# that answers it. Every page the How-to nav lists exists on disk.
howto_fail=0; howto_n=0
for skill in docs/skills/*.md; do
  [ -f "$skill" ] || continue
  [ "$(basename "$skill" .md)" = index ] && continue
  howto_n=$((howto_n + 1))
  if ! grep -qE "\]\(\.\./how-to/[a-z0-9-]+\.md[)#]" "$skill"; then
    err "$skill doesn't link a page under docs/how-to/ (add a link to the question that answers it)"
    howto_fail=1
  fi
done
[ "$howto_fail" -eq 0 ] && [ "$howto_n" -gt 0 ] && echo "ok: all $howto_n skill pages link a How-to page"
howto_nav=$(sed -n '/^  - How-to:/,/^  - [A-Z]/p' mkdocs.yml | grep -o 'how-to/[a-z0-9-]*\.md')
nav_fail=0
for page in $howto_nav; do
  if [ ! -f "docs/$page" ]; then err "docs/$page is listed in the How-to nav but does not exist on disk"; nav_fail=1; fi
done
[ "$nav_fail" -eq 0 ] && [ -n "$howto_nav" ] && echo "ok: all How-to nav entries have pages on disk"

# 6. The brief's claims ---------------------------------------------------------------------
# The brief is checked against the rest of the repo. TASKS-archive.md is read only for the done
# items below: archived items stay unchanged by rule, so their Brief: values (which may name old
# headings) are not checked.
brief="product/brief.md"
if [ ! -f "$brief" ] || [ ! -f TASKS.md ]; then
  err "product/brief.md or TASKS.md is missing, so the brief's claims can't be checked"
else
  brief_heads=$(grep -E '^#+ ' "$brief" | sed -E 's/^#+ +//; s/[[:space:]]+$//')

  # Screens: a row "| Concepts (13 pages) | ... |" must match its nav section's page count. The
  # section matches by name, ignoring case and a plural s ("Concepts" is the nav's "Concept").
  # One awk run reads mkdocs.yml (the nav) and then the brief (the Screens rows).
  screens=$(awk '
    function norm(s) { s = tolower(s); sub(/s$/, "", s); return s }
    function flush() { if (title != "") { nav[norm(title)] = count; navname[norm(title)] = title }; title = "" }
    FILENAME == ARGV[1] {
      if ($0 ~ /^nav:/) { innav = 1; next }
      if ($0 ~ /^[^ #]/) { if (innav) flush(); innav = 0; next }
      if (!innav) next
      if ($0 ~ /^  - [^ ]/) { flush(); title = $0; sub(/^  - /, "", title); sub(/:.*$/, "", title); count = 0; next }
      if ($0 ~ /^ +- .*\.md/) count++
      next
    }
    FNR == 1 { flush() }
    /^## / { insc = ($0 ~ /^## Screens[ \t]*$/); next }
    insc && /^\|/ {
      cell = $0; sub(/^\|/, "", cell); sub(/\|.*$/, "", cell)
      sub(/^[ \t]+/, "", cell); sub(/[ \t]+$/, "", cell)
      if (match(cell, /\([0-9]+ pages\)/)) {
        label = substr(cell, 1, RSTART - 1); sub(/[ \t]+$/, "", label)
        want = substr(cell, RSTART, RLENGTH); gsub(/[^0-9]/, "", want)
        k = norm(label)
        if (k in nav) print label "|" want "|" navname[k] "|" nav[k]
        else print label "|" want "|" "|"
      }
    }
  ' mkdocs.yml "$brief")
  screens_fail=0; screens_n=0
  while IFS='|' read -r label want title have; do
    [ -n "$label" ] || continue
    screens_n=$((screens_n + 1))
    if [ -z "$title" ]; then
      err "product/brief.md Screens: \"$label\" has no matching section in mkdocs.yml's nav"; screens_fail=1
    elif [ "$want" != "$have" ]; then
      err "product/brief.md Screens: \"$label\" says $want pages, but the nav section \"$title\" in mkdocs.yml has $have"
      screens_fail=1
    fi
  done <<< "$screens"
  if [ "$screens_n" -eq 0 ]; then err "product/brief.md has no Screens rows with a page count"
  elif [ "$screens_fail" -eq 0 ]; then echo "ok: brief Screens page counts match mkdocs.yml's nav ($screens_n sections)"; fi

  # missing_part <value>: sets bad to the first part of a "Section › Sub" value that isn't a heading of the brief, and
  # fails. A value is one or more parts, split on " › "; each part must be a heading (text only). Bash splits and
  # matches the parts, so a value costs no process (B41).
  missing_part() {
    local rest="$1" part
    bad=""
    while [ -n "$rest" ]; do
      if [[ $rest == *" › "* ]]; then part="${rest%% › *}"; rest="${rest#*" › "}"; else part="$rest"; rest=""; fi
      [ -n "$part" ] || continue
      case $'\n'"$brief_heads"$'\n' in *$'\n'"$part"$'\n'*) ;; *) bad="$part"; return 1 ;; esac
    done
    return 0
  }

  # Brief: values in TASKS.md (the open queue; "-" means none), and the brief headings named in
  # tools/*.sh as BRIEF="..." assignments (push-alignment.sh files its items under one).
  heads_fail=0
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    lineno=${hit%%:*}; val=${hit#*:- Brief: }
    val="${val%"${val##*[![:space:]]}"}"
    [ "$val" = "-" ] && continue
    missing_part "$val" || { err "TASKS.md:$lineno has Brief: \"$val\", and \"$bad\" isn't a heading in product/brief.md"; heads_fail=1; }
  done <<< "$(grep -n '^- Brief: ' TASKS.md)"
  for f in tools/*.sh; do
    [ -f "$f" ] || continue
    while IFS= read -r hit; do
      [ -n "$hit" ] || continue
      lineno=${hit%%:*}; val=${hit#*BRIEF=\"}; val=${val%%\"*}
      missing_part "$val" || { err "$f:$lineno names brief heading \"$val\", and \"$bad\" isn't a heading in product/brief.md"; heads_fail=1; }
    done <<< "$(grep -nE '^[[:space:]]*BRIEF="[^"]*"' "$f")"
  done
  [ "$heads_fail" -eq 0 ] && echo "ok: brief headings named in TASKS.md and tools/ are headings in product/brief.md"

  # Later and Planned sections: the item IDs they name (T<n>, B<n>, R<n>), against the items that are
  # done in TASKS.md or TASKS-archive.md. A section is a ## or ### heading; its text runs to the next
  # heading of the same or a higher level.
  done_list=$(awk -F' · ' -v OFS='\t' '/^### (T|B|R)[0-9]+ · / { id = $1; sub(/^### /, "", id); if ($3 ~ /^done/) print id, FILENAME }' \
    TASKS.md $([ -f TASKS-archive.md ] && echo TASKS-archive.md) 2>/dev/null)
  later=$(awk '
    /^#+ / {
      lvl = $0; sub(/[^#].*$/, "", lvl); lvl = length(lvl)
      title = $0; sub(/^#+ +/, "", title); sub(/[ \t]+$/, "", title)
      if (insec && lvl <= curlvl) insec = 0
      if (lvl >= 2 && lvl <= 3 && title ~ /^(Later|Planned)/) { insec = 1; curlvl = lvl; sec = title }
      next
    }
    insec {
      s = " " $0 " "
      while (match(s, /[^A-Za-z0-9][TBR][0-9]+[^0-9]/)) {
        id = substr(s, RSTART, RLENGTH); gsub(/[^TBR0-9]/, "", id)
        print sec "\t" id
        s = substr(s, RSTART + RLENGTH - 1)
      }
    }
  ' "$brief" | sort -u)
  later_fail=0
  while IFS=$'\t' read -r sec id; do
    [ -n "$sec" ] || continue
    where=$(awk -F'\t' -v id="$id" '$1 == id { print $2; exit }' <<< "$done_list")
    if [ -n "$where" ]; then err "product/brief.md: \"$sec\" names $id, which is done in $where"; later_fail=1; fi
  done <<< "$later"
  [ "$later_fail" -eq 0 ] && echo "ok: Later and Planned brief sections name no done items"
fi

# 7. Version numbers ------------------------------------------------------------------------
# Every page assumes the latest release, so no page names a framework version number in prose.
# A three-part number (1.2.3) fails, naming the page and the line. A link to a release tag
# (/tree/v..., /blob/v..., /releases/tag/v...) is stripped first, and a line that names the Godot
# engine, .NET, Node or gitleaks is skipped: their versions are not the frameworks'. "Godot Director"
# (the framework) is not the engine.
# One awk judges every hit (B41; a process per hit cost seconds): it strips the release-tag links and the framework's name
# as the sed did, then keeps a line with a three-part number that isn't about the engine, .NET, Node or gitleaks. The
# lines it keeps are the failures, printed as grep printed them.
ver_fail=0
ver_bad=$(grep -rnE --include='*.md' '[0-9]+\.[0-9]+\.[0-9]+' docs 2>/dev/null | awk '
  index($0, "docs/assets/") == 1 { next }
  {
    where = $0; sub(/:.*$/, "", where)
    rest = substr($0, length(where) + 2)
    lineno = rest; sub(/:.*$/, "", lineno)
    plain = substr(rest, length(lineno) + 2)
    gsub(/[^ (]*\/(tree|blob)\/v[0-9][^ )"]*/, "", plain)
    gsub(/[^ (]*\/releases\/tag\/v[0-9][^ )"]*/, "", plain)
    gsub(/Godot[ -]Director/, "", plain)
    if (plain !~ /(^|[^0-9.])[0-9]+\.[0-9]+\.[0-9]+([^0-9.]|$)/) next
    if (plain ~ /(^|[^A-Za-z-])(Godot|\.NET|Node|gitleaks)([^-A-Za-z]|$)/) next
    print
  }')
while IFS= read -r hit; do
  [ -n "$hit" ] || continue
  where=${hit%%:*}; rest=${hit#*:}; lineno=${rest%%:*}; text=${rest#*:}
  err "$where:$lineno names a version number in prose (link a release tag instead, or drop it): $(printf '%s' "$text" | cut -c1-100)"
  ver_fail=1
done <<< "$ver_bad"
[ "$ver_fail" -eq 0 ] && echo "ok: no docs page names a version number in prose"

# 8. Agent permissions ----------------------------------------------------------------------
# .claude/settings.json lets the agent run its Bash commands without a prompt. A generic runner
# (npm, npx, python, node, bash...) with any arguments runs any code, so each allow rule names only
# a command this repo runs (product/security/2026-10-26.md, F1). A runner followed by a wildcard
# fails: `npm *`, `npm run *`, `python -m *`, `node*`. A rule naming a script passes:
# `bash tools/check.sh*`, `node tools/ui/capture.mjs *`.
perm_runners='npm|npx|pnpm|yarn|flutter|python3?|pip3?|node|bash'
if [ ! -f .claude/settings.json ]; then
  err ".claude/settings.json is missing, so the agent's permissions can't be checked"
else
  perm_hits=$(grep -nE "\"Bash\(($perm_runners)( [a-z-]+)?([ :]\*|\*)\)\"" .claude/settings.json || true)
  if [ -n "$perm_hits" ]; then
    err ".claude/settings.json allows a generic code runner without a prompt (allow the exact commands instead):"
    echo "$perm_hits" | sed 's/^/  /'
  else echo "ok: .claude/settings.json allows no generic code runner without a prompt"; fi

  # The wildcard git rules take any flag, and some git flags write a file (--output), read a file
  # outside the repository (--no-index, commit and tag -F) or run a configured command (--ext-diff,
  # grep -O), none of which should run without the human (product/security/2026-10-29.md, F1; B14).
  # A * in `bash tools/stacks/*.sh*` matches `..` too, so a script path can leave tools/. Two layers:
  # deny rules the harness enforces, and the guard hook, which also covers commit and tag -F (a rule
  # can't tell -F <path> from -F -), grep's short, combined and abbreviated pager flags and a script
  # path with `..`. A wildcard rule with a deny rule missing fails; the hook is fed the PreToolUse
  # JSON and must exit 2 on each flag, quoted, escaped, attached or combined, and 0 on the plain
  # forms the procedures use.
  git_fail=""
  perm_allow=$(sed -n '/"allow": *\[/,/\]/p' .claude/settings.json)
  perm_deny=$(sed -n '/"deny": *\[/,/\]/p' .claude/settings.json)
  deny_needs() { # deny_needs <allow rule pattern> <deny rule>...
    printf '%s\n' "$perm_allow" | grep -qE "$1" || return 0
    shift
    local rule
    for rule in "$@"; do
      printf '%s\n' "$perm_deny" | grep -qF "\"$rule\"" \
        || git_fail="$git_fail"$'\n'"  settings.json allows a wildcard rule but doesn't deny $rule"
    done
  }
  deny_needs '"Bash\(git (diff|log|show|stash|commit) \*\)"' \
    'Bash(git *--output*)' 'Bash(git *--no-index*)' 'Bash(git *--ext-diff*)' 'Bash(git commit *--file*)'
  deny_needs '"Bash\(git grep \*\)"' 'Bash(git grep *--open*)' 'Bash(git grep *-O*)'
  deny_needs '"Bash\(git tag \*\)"' 'Bash(git tag *--file*)'
  deny_needs '"Bash\(bash tools/[^"]*\*' 'Bash(bash tools/*..*)'
  # json_str <text>: sets JSON_STR to the text as the inside of a JSON string, with \, ", a line break, a tab and a return escaped. (A ${//}
  # replacement left a backslash single and turned a line break into n, so a newline case reached the guard as a joined word.)
  json_str() {
    local s="$1" out="" i c
    for ((i = 0; i < ${#s}; i++)); do
      c="${s:i:1}"
      case $c in
        '\') out+='\\' ;;
        '"') out+='\"' ;;
        $'\n') out+='\n' ;;
        $'\t') out+='\t' ;;
        $'\r') out+='\r' ;;
        *) out+="$c" ;;
      esac
    done
    JSON_STR="$out"
  }
  # The guard cases (B41). guard queues a case: its JSON payload goes to a file, and its expected exit code, tool and text
  # are kept. guard_run runs the queued cases, guard_jobs at a time, each as its own run of the hook with its own payload,
  # then checks every exit code against that case's expected one, in the order the cases were queued, so a failure names
  # its case and why exactly as before. Each block ends with guard_run, before it checks git_fail.
  guard_jobs=$(nproc 2>/dev/null || echo 4); [ "$guard_jobs" -le 8 ] || guard_jobs=8
  guard_cmds=(); guard_exps=(); guard_tools=()
  guard() { # guard <expected-exit> <command> [tool name: Bash by default, or PowerShell]
    local n=${#guard_cmds[@]} tool="${3:-Bash}"
    json_str "$2"
    printf '{"session_id":"s","tool_name":"%s","tool_input":{"command":"%s","description":"run"}}' "$tool" "$JSON_STR" > "$guard_dir/$n.json"
    guard_cmds+=("$2"); guard_exps+=("$1"); guard_tools+=("$tool")
  }
  guard_run() {
    local n=${#guard_cmds[@]} first i k
    local -a pid=() rc=()
    for ((first = 0; first < n; first += guard_jobs)); do
      for ((k = 0; k < guard_jobs && first + k < n; k++)); do
        bash .claude/hooks/guard-commands.sh < "$guard_dir/$((first + k)).json" >/dev/null 2>&1 &
        pid[k]=$!
      done
      for ((k = 0; k < guard_jobs && first + k < n; k++)); do
        wait "${pid[k]}"; rc[first + k]=$?
      done
    done
    for ((i = 0; i < n; i++)); do
      [ "${rc[i]}" -eq "${guard_exps[i]}" ] || git_fail="$git_fail"$'\n'"  guard exited ${rc[i]}, expected ${guard_exps[i]} (${guard_tools[i]}): ${guard_cmds[i]//$'\n'/ NL }"
    done
    guard_cmds=(); guard_exps=(); guard_tools=()
    rm -f "$guard_dir"/*.json
  }
  if [ ! -f .claude/hooks/guard-commands.sh ]; then
    git_fail="$git_fail"$'\n'"  .claude/hooks/guard-commands.sh is missing"
  else
    for cmd in \
        'git log -1 --format=probe --output=/tmp/probe.txt' \
        'git log --output /tmp/probe.txt' \
        'git show --output /tmp/probe.txt HEAD' \
        'git diff --output=probe.txt' \
        'git stash show --output=/tmp/probe.txt' \
        "git log '--output=/tmp/probe.txt'" \
        'git log "--no-index"' \
        'git log --out\put=/tmp/probe.txt' \
        'git log --output="/tmp/my probe.txt"' \
        'git diff --no-index a b' \
        'git diff --no-index /dev/null /etc/hosts' \
        'git log -p --ext-diff' \
        'git diff --ext-diff' \
        'git diff /etc/hosts README.md' \
        'git diff ../other.txt README.md' \
        'git commit -F /tmp/msg.txt' \
        'git commit -F/tmp/msg.txt' \
        'git commit -aF /tmp/msg.txt' \
        'git commit -F "/tmp/my msg.txt"' \
        'git commit --file /tmp/msg.txt' \
        'git commit --file=/tmp/msg.txt' \
        'git commit -F - -F /tmp/msg.txt' \
        'git add -A && git commit -F /tmp/msg.txt' \
        'git -C work/App-Director log --output=/tmp/probe.txt' \
        $'git commit -q -F - <<\'EOF\'\nmsg\nEOF\ngit log --output=/tmp/probe.txt' \
        'git grep -O foo' \
        'git grep -Oecho foo' \
        'git grep -n -Ovim foo' \
        'git grep -iO foo' \
        'git grep -nOvim foo' \
        'git grep -e foo -Oecho' \
        'git grep -A 1 -Oecho foo' \
        'git grep --open-files-in-pager foo' \
        'git grep --open-files-in-pager=echo foo' \
        'git grep --open=echo foo' \
        'git grep --op foo' \
        'git grep "-Obj"' \
        "git grep '-Oecho' foo" \
        'git grep -nO"echo hi" foo' \
        'git grep --"open-files-in-pager"=echo foo' \
        'git -C work/App-Director grep -Oecho foo' \
        'git add . && git grep -Oecho foo' \
        'git tag -F /tmp/msg.txt v1' \
        'git tag -aF /tmp/msg.txt v1' \
        'git tag -a v1 -F/tmp/msg.txt' \
        'git tag -a v1 --file=/tmp/msg.txt' \
        'git tag --file /tmp/msg.txt v1' \
        'git tag --fi=/tmp/msg.txt v1' \
        'bash tools/stacks/../../x.sh' \
        'bash -x tools/stacks/../x.sh' \
        'bash tools/stacks/.\./x.sh' \
        'bash tools/stacks/".."/x.sh' \
        'sh ./tools/../x.sh' \
        '/bin/bash tools/stacks/../x.sh' \
        'cat ~/.ssh/id_ed25519' \
        'head "$HOME/.git-credentials"' \
        'cat ~/.config/gh/hosts.yml' \
        'less "/c/Users/V/AppData/Roaming/GitHub CLI/hosts.yml"' \
        'cat "C:\Users\V\.ssh\id_rsa"' \
        'cat "certs/server.pem"' \
        "head '.env'" \
        'cat .env.local' \
        'head ./.env.production' \
        'cat "config/.env.staging"' \
        'less .env.development.local' \
        "tail '.env.test'" \
        'tail -n 20 .env.local' \
        'cat .env.example; cat .env.local' \
        'cat README.md .env.local' \
        'tail -n 20 .env' \
        'head -5 certs/server.pem' \
        'cat docs/a.md "deploy.key"' \
        'less -R .env.production' \
        'gh auth token' \
        'gh auth status -t' \
        "printf 'protocol=https\\nhost=github.com\\n' | git credential fill" \
        "printf 'protocol=https\\nhost=github.com\\n' | git credential get" \
        $'cd x\ngit branch -D y' \
        $'cd x\ngit commit --no-verify -m x' \
        $'cd x\n\tgit log --output=/tmp/x' \
        $'echo a\ngit push --force' \
        $'cd x\ngit commit -F /tmp/msg.txt' \
        $'cd x\ngit credential fill' \
        $'echo x\nbash tools/stacks/../x.sh' \
        "git commit '-n' -m x" \
        'git commit "-n" -m x' \
        'git commit -""n -m x' \
        "git commit --no-ve''rify -m x" \
        "git commit -m -- '-n'" \
        $'git commit \\\n-n -m x' \
        $'git push \\\n--force' \
        $'git push origin \\\n+main' \
        $'git reset \\\n--hard' \
        $'git credential \\\nfill' \
        $'git log \\\n--output=/tmp/probe.txt' \
        $'cat \\\n.env.local' \
        $'cat README.md \\\n.env.local' \
        $'cat\t.env.local' \
        $'head\t-n\t20\t.env' \
        $'git\tpush --force' \
        $'git\tcommit -n -m x' \
        $'git\tlog --output=/tmp/probe.txt' \
        $'echo a\\\\\ngit push --force' \
        $'echo a\\\\\ngit commit -F /tmp/msg.txt' \
        $'sleep \\\n300'; do
      guard 2 "$cmd"
    done
    for cmd in \
        'git log --oneline -5' \
        'git diff HEAD' \
        'git diff --cached --stat' \
        'git diff origin/main..HEAD -- docs/index.md' \
        'git show HEAD:README.md' \
        'git commit -m "fix the --output handling"' \
        'git commit -m x -- docs/index.md' \
        "git commit -m x -- '-n'" \
        'git commit -F -' \
        'git commit --file=-' \
        $'git commit -q -F - <<\'EOF\'\nfix the --output and --no-index handling, not -F /tmp/x\nEOF' \
        'git stash list' \
        'git worktree list' \
        'git grep -n foo' \
        "git grep -i -e x -- '*.md'" \
        'git grep -ie -O' \
        'git grep -e -Oecho' \
        'git grep -n "an -Obj pattern"' \
        'git grep -c --no-open-files-in-pager foo' \
        'git grep --only-matching foo' \
        'git log --grep -O' \
        'git tag -a v1 -m x' \
        'git tag -a v1 -m "see --file and -F"' \
        'git tag -n' \
        'git tag -a v1 -F -' \
        'git tag --file=- -a v1' \
        'bash tools/check.sh' \
        'bash tools/work-publish.sh work/App-Director' \
        'bash tools/stacks/godot.sh --since HEAD~3..HEAD' \
        'bash tools/check.sh && git log origin/main..HEAD' \
        'bash ../x.sh' \
        'cd tools && bash ../x.sh' \
        'cat README.md' \
        'cat docs/how-to/where.md' \
        'cat .env.example' \
        'cat config/.env.sample' \
        'head .env.template' \
        'cat .env.dist' \
        'cat README.md docs/x.md' \
        'tail -n 20 .env.example' \
        'head -5 notes.txt' \
        'cat .env.example .env.sample' \
        'grep -n ssh docs/how-to/trouble.md' \
        'git log --oneline -3' \
        'ls ~/.ssh' \
        'gh auth status' \
        $'git status\ngit log --oneline -3' \
        $'git status\ngit commit -q -F - <<\'EOF\'\nfix the --output and --no-index handling, not -F /tmp/x\nEOF' \
        $'git commit -q -F - <<\'EOF\'\nfix the -n flag, not a flag\nEOF' \
        'echo x\\ngit branch -D y' \
        $'git log \\\n--oneline -3' \
        $'git status \\\n-s' \
        $'git diff \\\nHEAD' \
        $'echo a\\\\\nls' \
        $'cat README.md \\\ndocs/x.md' \
        $'cat\tREADME.md' \
        $'git\tstatus'; do
      guard 0 "$cmd"
    done
    # PowerShell (B24): its input carries the command as tool_input.command, like Bash's, so the hook must
    # exit the same way on a PowerShell payload. These are the git flags the deny rules and the guard block.
    for cmd in \
        'git push --force' \
        'git commit --no-verify -m x' \
        'git reset --hard HEAD~1' \
        'git log --output=/tmp/probe.txt' \
        'git diff --no-index a b' \
        'git commit -F /tmp/msg.txt' \
        'git grep -Oecho foo' \
        'git tag -F /tmp/msg.txt v1' \
        'bash tools/stacks/../../x.sh' \
        'cat .env.local'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in 'git status' 'git log --oneline -5' 'git diff HEAD'; do
      guard 0 "$cmd" PowerShell
    done
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "git's file-writing, file-reading and external-command flags, and script paths outside tools/, are not all blocked:"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the wildcard rules deny, and the guard hook blocks, git's file-writing, file-reading and external-command flags and script paths outside tools/"; fi

  # The PowerShell readers of credential files (B27): Get-Content and its aliases gc and type, Select-String
  # and sls, and [IO.File]::ReadAll... block a credential file in any case, as cat does, and so does a reader
  # inside a -Command or -c string. The same readers of ordinary files pass, and the checks run for the Bash
  # tool too, since the hook reads every tool's command the same way.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for reader in 'Get-Content' 'gc' 'type' 'GET-CONTENT' 'Select-String -Pattern x' 'sls x' \
        'Get-Content -Path' 'Get-Content -LiteralPath'; do
      for target in '.env.local' '.env' '.env*' 'certs/server.pem' '~/.ssh/id_ed25519' \
          '$HOME\.ssh\id_rsa' '~/.config/gh/hosts.yml' '"$env:APPDATA\GitHub CLI\hosts.yml"'; do
        guard 2 "$reader $target" PowerShell
      done
    done
    for cmd in \
        "[IO.File]::ReadAllText('.env.local')" \
        '[System.IO.File]::ReadAllLines(".env")' \
        '[io.file]::readallbytes("certs/server.pem")' \
        '[IO.File]::ReadLines("$HOME\.ssh\id_rsa")' \
        'Get-Content .env.example; Get-Content .env.local' \
        'powershell -NoProfile -Command "Get-Content .env.local"' \
        'powershell -c "gc .env"' \
        'cmd /c "type .env.local"' \
        "bash -c 'cat .env.local'" \
        'bash -c "cat .env.local"' \
        'cat .env*' \
        '\cat .env.local' \
        'echo `cat .env.local`' \
        'type .env.local' \
        'gc .env.local'; do
      guard 2 "$cmd"
    done
    for cmd in \
        'Get-Content README.md' \
        'gc docs/index.md' \
        'Get-Content -Path docs/index.md' \
        'Get-Content -LiteralPath README.md' \
        'Select-String -Path docs/index.md -Pattern title' \
        'Get-Content .env.example' \
        'gc config/.env.sample' \
        '[IO.File]::ReadAllText("docs/index.md")' \
        'Get-ChildItem ~/.ssh' \
        'powershell -NoProfile -Command "Get-Content README.md"' \
        'type git'; do
      guard 0 "$cmd" PowerShell
    done
    guard 0 'type git'
    guard 0 'type README.md'
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook doesn't block every read of a credential file, or blocks a read of an ordinary file (B27):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks the PowerShell and Bash readers of credential files, in any case, and passes the readers of ordinary files and templates"; fi

  # PowerShell's backtick (B28): a backtick that ends a line continues it, so a flag or a read it splits is
  # blocked as the plain form is, and a benign continuation passes. An escaped backtick (``) and a backtick
  # followed by spaces don't continue. In Bash a backtick is command substitution, so the same text passes
  # there. A comment that ends in a backtick still shows the next line, which the joined text would hide.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        $'git push `\n--force' \
        $'git commit `\n-n -m x' \
        $'cat `\n.env.local' \
        $'cat README.md `\n.env.local' \
        $'git push `\r\n--force' \
        $'git push `\r--force' \
        $'git log `\n--output=/tmp/probe.txt' \
        $'git pu`\nsh --force' \
        $'cat .en`\nv.local' \
        $'# note`\ngit push --force'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in \
        $'git log `\n--oneline -3' \
        $'git status `\n-s' \
        $'cat ``\n.env.local' \
        $'git push ``\n--force' \
        $'git push ` \n--force'; do
      guard 0 "$cmd" PowerShell
    done
    guard 0 $'cat README.md `\n.env.local'
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook doesn't treat a PowerShell backtick at a line's end as a continuation, or treats a Bash or an escaped one as one (B28):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks a flag or a read that a PowerShell backtick continuation splits, and passes the benign continuations and the escaped and Bash backticks (B28)"; fi

  # A Bash comment that ends in a backslash (B31): Bash ends the comment at the line break, so the line after it is a
  # command of its own, and the guard reads it as written. A continued command after such a comment is read from its
  # own line on. A # inside a word (a#b) is no comment, so its continuation is joined, as Bash joins it. The hang
  # check reads a heredoc header joined to its delimiter (B29): python3 with - <<'EOF' on the next line and EOF after.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        $'# note\\\ngit push --force' \
        $'# note\\\ngit commit --no-verify -m x' \
        $'git status # note\\\ngit push --force' \
        $'# a\\\ngit commit \\\n-F /tmp/msg.txt' \
        $'# a\\\ngit push \\\n--force' \
        $'# a\\\n# b\\\ngit push \\\n--force' \
        $'git push origin main#\\\n  --force' \
        $'python3 \\\n- <<\'EOF\'\nEOF'; do
      guard 2 "$cmd"
    done
    for cmd in \
        $'# note\\\ngit status' \
        $'git status # note\\\n-s' \
        $'echo a#b\\\n--force' \
        $'python3 \\\n- <<\'EOF\'\nprint(1)\nEOF'; do
      guard 0 "$cmd"
    done
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook reads a command after a Bash comment that ends in a backslash as hidden, or blocks a benign one (B31, B29):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook reads the line after a Bash comment that ends in a backslash, and the command continued after it, as Bash does (B31, B29)"; fi

  # A PowerShell comment that ends in a backtick (B35): PowerShell ends the comment at the line break too, so the line after it
  # is a command of its own, and a continued command after it is read from its own line on, as for a Bash comment (B31). A CRLF
  # break is the same. A comment that ends in a backtick, followed by a plain command, passes.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        $'# note`\ngit commit `\n-F x' \
        $'# note`\r\ngit commit `\r\n-F x'; do
      guard 2 "$cmd" PowerShell
    done
    guard 0 $'# note`\ngit status' PowerShell
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook doesn't read a command after a PowerShell comment that ends in a backtick, or blocks a plain one (B35):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook reads the command after a PowerShell comment that ends in a backtick, and the command continued after it, as PowerShell does (B35)"; fi

  # A quoted or path-qualified reader, a backtick inside a word and a StreamReader (B30): the call operator with a
  # quoted name (& 'Get-Content' .env.local), a reader by its path (/bin/cat, cat.exe, the Management module's
  # Get-Content), a backtick escape that leaves a letter or a dot in a reader or a name (Get-Con`tent, .en`v.local),
  # and the StreamReader constructors are read as the plain forms are. A reader in a string with a backtick-escaped
  # quote, a template and an ordinary file pass. In PowerShell the escape also reaches the git flag rules (--fo`rce).
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        "& 'Get-Content' .env.local" \
        '& "gc" .env.local' \
        ". 'type' .env.local" \
        "& 'Get-Content' -Path '.env.local'" \
        "Get-Content '.env.local'" \
        'Get-Con`tent .env.local' \
        'gc .en`v.local' \
        'type `.env.local' \
        'C:\Git\usr\bin\cat.exe .env.local' \
        'Microsoft.PowerShell.Management\Get-Content .env.local' \
        '[System.IO.StreamReader]::new(".env.local")' \
        "[IO.StreamReader]::new('.env')" \
        "New-Object System.IO.StreamReader('.env.local')" \
        'New-Object -TypeName System.IO.StreamReader -ArgumentList .env.local' \
        'git push --fo`rce' \
        'Write-Output x; & "gc" .env'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in \
        '/bin/cat .env.local' \
        '/usr/bin/head -n 5 .env' \
        "'/bin/cat' .env.local" \
        '/usr/bin/tail -n 20 .env.production'; do
      guard 2 "$cmd"
    done
    for cmd in \
        "& 'Get-Content' README.md" \
        "& 'Get-Content' '.env.example'" \
        'Write-Output "say `"hi`" now"' \
        'Write-Output "run `"gc README.md`" next"' \
        "[System.IO.StreamReader]::new('docs/index.md')" \
        "New-Object System.IO.StreamReader('README.md')" \
        'Get-Con`tent README.md' \
        'cat.exe README.md'; do
      guard 0 "$cmd" PowerShell
    done
    for cmd in \
        '/bin/cat README.md' \
        '/usr/bin/head -n 5 .env.example' \
        "'/bin/cat' README.md"; do
      guard 0 "$cmd"
    done
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook misses a quoted or path-qualified reader, a backtick inside a word or a StreamReader of a credential file (B30):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks a quoted or path-qualified reader, a backtick-escaped word and a StreamReader of a credential file, and passes the same readers of ordinary files (B30)"; fi

  # The common file readers (B36): grep, sed, awk, sort, base64, xxd and the rest of the list in the hook print a
  # credential file as cat does, in Bash and in a PowerShell payload; a reader or a name split by quotes (ca''t, c"a"t)
  # is read as the shell runs it; [IO.File]::OpenText, OpenRead and Open read one. A pattern is an argument as well
  # (B27), so grep "\.env" and git grep .env are blocked, and the templates and ordinary files pass. A commit message
  # that names a reader, with no credential file after it, passes.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        'grep x .env.local' \
        'awk 1 .env' \
        'sed -n p .env.local' \
        'base64 .env.local' \
        'xxd .env.local' \
        'egrep x .env' \
        'fgrep -i x .env.production' \
        'rg x .env.local' \
        'gawk "{print}" .env.staging' \
        'sort .env.local' \
        'uniq .env' \
        'cut -d= -f2 .env.local' \
        'nl .env' \
        'tac .env.local' \
        'rev .env' \
        'od -c .env' \
        'hexdump -C .env.local' \
        'diff .env.local .env.example' \
        'cmp .env .env.example' \
        '/usr/bin/grep x .env.local' \
        'grep -rn "\.env" docs/' \
        'git grep .env' \
        "ca''t .env.local" \
        'c"a"t .env.local' \
        "'ca'\"t\" .env" \
        'g""rep x .env' \
        'ba"se"64 .env.local' \
        'cat .en'"''"'v.local' \
        'c'"'"'a'"'"'t .env.local'; do
      guard 2 "$cmd"
    done
    for cmd in \
        "[System.IO.File]::OpenText('.env.local')" \
        '[IO.File]::OpenRead(".env")' \
        "[System.IO.File]::Open('.env.local', 'Open', 'Read')" \
        '[io.file]::opentext("certs/server.pem")' \
        '[IO.File]::OpenRead("$HOME\.ssh\id_rsa")' \
        '& "Get-Content" .env.local' \
        'Select-String -Path .env -Pattern x'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in \
        'grep x .env.example' \
        'sed -n p .env.sample' \
        'awk 1 .env.template' \
        'base64 .env.dist' \
        'xxd .env.example' \
        'ca""t .env.example' \
        'c"a"t config/.env.sample' \
        'grep -n "DATABASE_URL" src/' \
        'sed -n 1,5p docs/index.md' \
        'awk 1 docs/index.md' \
        'sort README.md' \
        'cut -c1-3 README.md' \
        'diff README.md docs/index.md' \
        'git grep TODO' \
        'git diff README.md' \
        'git commit -m "fix: sort the docs and grep notes"' \
        'git commit -m "docs: sed, awk and diff notes" -- docs/index.md' \
        'rev-parse --show-toplevel'; do
      guard 0 "$cmd"
    done
    for cmd in \
        "[System.IO.File]::OpenText('docs/index.md')" \
        '[IO.File]::OpenRead("README.md")' \
        "[System.IO.File]::Open('docs/index.md', 'Open')" \
        "[IO.File]::OpenText('.env.example')"; do
      guard 0 "$cmd" PowerShell
    done
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook misses a common file reader, a reader or a name split by quotes, or an IO.File Open method of a credential file, or blocks an ordinary read (B36):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks grep, sed, awk, sort, base64, xxd and the other common readers, a reader or name split by quotes, and [IO.File]::OpenText, OpenRead and Open of a credential file, and passes the same readers of templates and ordinary files (B36)"; fi

  # A backslash that escapes an ordinary character in a Bash command is removed by the shell (B44): c\at is cat, and .en\v.local
  # is .env.local, so the reader and the name are read as the shell runs them. An escaped backslash (\\) is one backslash, and a
  # backslash before a space stays, as the shell keeps the name one word. Windows paths and the templates pass, and PowerShell's
  # escape is the backtick (B30), so a backslash in a PowerShell payload is a path separator, not an escape.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        'c\at .env.local' \
        'he\ad .env' \
        'cat .en\v.local' \
        'cat .env\.local' \
        'cat .e\nv.local' \
        'c\a\t .env.local' \
        'ca\t .en\v.local' \
        'sed -n p .en\v.local' \
        'C\AT .env.local' \
        'c\at "config/.en\v.local"' \
        'cat ~/.s\sh/id_rsa' \
        'cat C:\Users\V\.env' \
        'cat .\pem'; do
      guard 2 "$cmd"
    done
    for cmd in \
        'c\\at .env.local' \
        'cat .en\\v.local' \
        'cat .en\v.example' \
        'cat .en\v.sample' \
        'cat .env\ .example' \
        'c\at README.md' \
        'cat C:\Users\V\README.md' \
        'cat C:\Users\V\docs\index.md' \
        'cat C:\repo\.env.example' \
        'git commit -m "docs: c\at notes"'; do
      guard 0 "$cmd"
    done
    guard 0 'c\at .env.local' PowerShell
    guard 0 "bash -c 'c\at README.md'" PowerShell
    guard 0 "powershell -c \"c\at .env.local\"" PowerShell
    guard 2 "bash -c 'c\at .env.local'" PowerShell
    guard 2 'bash -c "cat .en\v.local"' PowerShell
    guard 2 'type C:\x\.env' PowerShell
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook misses a backslash that escapes a character in a Bash credential read, or blocks an ordinary read or a PowerShell backslash (B44):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks a Bash credential read whose reader or name has a backslash that escapes a character (c\\at, .en\\v.local), and passes the templates, Windows paths and a PowerShell backslash (B44)"; fi

  # A command substitution in a git command's words (B32): what it prints can be a flag, and the text it runs is a command
  # the guard can't see. The repro (git push $(echo --force) and its backtick form) is blocked as the plain flag is, in Bash
  # and PowerShell, and so is a substitution as the command name, or one that runs a non-reading command. A double-quoted
  # value that starts with fixed text, a commit's or tag's -m value and a read (git, date, cat, echo, printf) pass, as the
  # procedures use them. The text of a substitution is judged as a command of its own.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        'git push $(echo --force)' \
        'git push `echo --force`' \
        'git push "$(echo --force)"' \
        'git log $(echo --output=/tmp/x)' \
        'git log "$(echo --output=/tmp/x)"' \
        'git log "--output=$(echo /tmp/x)"' \
        'git log "--since=$(rm -rf x)"' \
        'git log -1 "$(date +%F)"' \
        'git log "x$(git push --force)"' \
        'git push $(git push --force)' \
        'git status && echo $(git push --force)' \
        'echo "$(git push --force)"' \
        'git log > >(git push --force)' \
        '$(echo git) push --force' \
        'git log $(echo git) push' \
        'git commit -m x "$(cat x)"' \
        'git commit -m "$(echo $(rm -rf x))"' \
        $'git commit -c -m "$(cat <<\'EOF\'\n--file=/tmp/x\nEOF\n)"' \
        $'git commit -m -m "$(cat <<\'EOF\'\n--file=/tmp/x\nEOF\n)"' \
        $'git commit -m "$(cat <<EOF\n$(git push --force)\nEOF\n)"' \
        $'git commit -m "$(cat x; git push --force)"' \
        $'git log \\\n$(echo --output=/tmp/x)' \
        'git push "--force"$(echo x)'; do
      guard 2 "$cmd"
    done
    for cmd in \
        'git push $(echo --force)' \
        'git push `echo --force`' \
        'git push "$(echo --force)"' \
        'git push (echo --force)' \
        'git push @(echo --force)' \
        '$(echo git) push --force' \
        'git log -- $(echo --output=/tmp/x)' \
        'git log "$(git push --force)"'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in \
        $'git commit -m "$(cat <<\'EOF\'\nfix the --output handling, and -F /tmp/x\nEOF\n)"' \
        $'git commit -a -m "$(cat <<\'EOF\'\nmsg one\n\nBody with `ticks` and $(vars) text\nEOF\n)" -- docs/index.md' \
        $'git commit -m "$(cat <<\'EOF\'\nmsg `git push --force` in a quoted heredoc\nEOF\n)" -- x' \
        $'git commit -m "$(cat <<EOF\nplain body\nEOF\n)"' \
        'git commit -m "$(git log -1 --format=%s)"' \
        'git commit -m "$(echo --file=/tmp/x)"' \
        'git tag -a "v$(cat VERSION)" -m "release"' \
        'git checkout -q -b "ddd/bundle-$(date +%F)" origin/main' \
        'git ls-remote --heads origin "ddd/bundle-$(date +%F)*"' \
        "git log --since=\"\$(date -d '7 days ago' +%F)\" --oneline" \
        'git log --format=%h -n 1 -- "docs/$(echo index).md"' \
        'test -z "$(git status --porcelain)"' \
        'echo "$r $(git -C work/$r describe --tags)"' \
        'for f in $(git diff --name-only); do echo "$f"; done' \
        'K=$(git rev-parse HEAD); echo $K' \
        'cd "$(git rev-parse --show-toplevel)" && git status' \
        'git status; echo $(date)' \
        'git log -1 --format=%h \$(echo --output)' \
        'echo `date`'; do
      guard 0 "$cmd"
    done
    guard 0 'Write-Output "$(git status)"' PowerShell
    guard 0 $'git commit -m "$(cat <<\'EOF\'\nmsg\nEOF\n)" && git push origin main' PowerShell
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook reads a command substitution in a git command's words, or as its name, as harmless, or blocks a plain read (B32):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks a command substitution that can print a git flag or run a command the guard can't read, in git's words or as a command name, and passes the quoted values, messages and reads the procedures use (B32)"; fi

  # A Bash comment holds no substitution and opens no quoted string (B43): a backtick, $( or quote in it is text, so the
  # command after the comment is read as Bash reads it. A substitution after a comment, a tab, ; or & is still read, and so is
  # one after a # inside a word (a#b) or after an escaped blank, since neither starts a comment. A ) in a comment doesn't close a
  # substitution, so its text runs to the next line and is blocked. A blank before a # inside ${...} is part of the expansion,
  # not a comment. An unquoted heredoc body's substitutions are read whole, as the shell expands them, so a comment in one is
  # read too; a quoted body is text.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        $'git push # x\n`echo --force`' \
        $'git push # x\ngit push `echo --force`' \
        $'git status # note\ngit push $(echo --force)' \
        $'# it\'s\ngit push `echo --force`' \
        $'git status a#b `echo --force`' \
        $'git status a\\ #`echo --force`' \
        $'git status ${x:- #a} $(echo --force)' \
        $'git push origin ":${y:- #}$(echo main)"' \
        $'git push `# x`' \
        $'git push `echo --force` # x' \
        $'git push $(echo --force) # `' \
        $'git status $(echo a # `)' \
        $'git log "--format=$(echo a # )\nprintf x)"' \
        $'git commit -q -F - <<EOF\n# note `\nmsg\nEOF' \
        $'git log <<EOF\n# $(git push --force)\nEOF' \
        $'git status <<EOF\n# `git push --force`\nEOF' \
        $'# note `\\\ngit push `echo --force`'; do
      guard 2 "$cmd"
    done
    for cmd in \
        $'# note `\ngit status' \
        $'# note `echo --force`\ngit status' \
        $'# note $(echo --force)\ngit status' \
        $'git status\t# note `\ngit log -1' \
        $'git status;# note `\ngit log -1' \
        $'# it\'s\ngit status' \
        $'git status # $(echo --force)' \
        $'git status # `echo --force`' \
        $'git status ${x:-y} # $(echo --force)' \
        $'# note `\\\ngit status' \
        $'git commit -q -F - <<\'EOF\'\n# note `echo --force`\nmsg\nEOF'; do
      guard 0 "$cmd"
    done
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook reads a backtick, \$( or quote in a Bash comment as a substitution or a string, or misses a substitution after one (B43):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook reads a Bash comment as text, so a backtick, \$( or quote in it starts no substitution or string, and a substitution after a comment, an escaped blank or a # in a word is still read (B43)"; fi

  # A destructive git rule (B33) reads the words as the shell hands them over: a quoted flag, refspec or path is seen, a flag
  # ends at ; & | ) or a line break as it does at a space, and a heredoc body a shell runs is read too. The rules are a force
  # push, a +refspec, reset --hard, clean -f, checkout or switch -f, checkout or restore of ".", stash drop or clear, and
  # branch -D. A quoted message that names one passes, and so does a quoted word that isn't a flag.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
      $'git push --force\necho done' \
      'git push --force;echo done' \
      'git push --force&&echo done' \
      'git push --force|cat' \
      '(git push --force)' \
      'git push "--force"' \
      "git push '--force'" \
      'git push "--force-with-lease=origin/main"' \
      'git push --fo"rce"' \
      'git push -f;echo done' \
      'git push origin "+main"' \
      "git push origin '+main'" \
      'git pu"sh" --force' \
      'git status && git push --force' \
      $'git status\ngit push "--force"' \
      'git checkout "."' \
      'git checkout -- "."' \
      'git restore "."' \
      'git checkout .;echo done' \
      'git checkout -f;echo done' \
      'git checkout "-f" main' \
      'git checkout -qf main' \
      'git switch "--discard-changes" main' \
      'git reset "--hard"' \
      'git reset --hard;echo done' \
      'git clean "-f"' \
      'git stash "drop"' \
      'git stash drop;echo done' \
      'git branch "-D" x' \
      'git branch -D x;echo done' \
      'git branch -vD x' \
      'git commit -n;echo done' \
      'git commit -m "-x;y" -F /tmp/msg.txt' \
      'git diff "/etc/passwd"' \
      'bash "tools/../x.sh"' \
      $'bash <<\'EOF\'\ngit push --force\nEOF' \
      $'bash <<\'EOF\'\ngit push "--force"\nEOF' \
      $'bash <<\'EOF\'\ngit push origin "+main"\nEOF' \
      $'bash <<\'EOF\'\ngit checkout "."\nEOF' \
      $'bash <<\'EOF\'\ngit commit -n -m x\nEOF' \
      $'sh <<EOF\ngit reset --hard\nEOF'; do
      guard 2 "$cmd"
    done
    for cmd in \
      'git push origin main' \
      'git push origin "HEAD:refs/heads/main"' \
      'git push "origin" main' \
      'git push origin main;git status' \
      'git push -u origin "ddd/bundle-$(date +%F)"' \
      'git commit -m "stop git push --force;"' \
      'git commit -m "reset --hard" -m "checkout ."' \
      'git commit -m "stash drop"' \
      'git commit -m "-x" -F -' \
      'git checkout -b "feature/x"' \
      'git checkout "main"' \
      'git branch -d x' \
      'git branch -vv' \
      'git log --grep "push --force"' \
      'git log --oneline "--grep=push"' \
      'git stash show "drop"' \
      'git tag -a v1 -m "push --force note"' \
      'echo "git push --force"' \
      'git status && echo "reset --hard"' \
      $'git status\ngit log --oneline -3' \
      $'git commit -q -F - <<\'EOF\'\nStop "git push --force" in the hook, and "git reset --hard".\nEOF' \
      $'git commit -q -F - <<\'EOF\'\nfix the --output and --no-index handling, not -F /tmp/x\nEOF'; do
      guard 0 "$cmd"
    done
    for cmd in 'git push "--force"' 'git push origin "+main"' 'git checkout "."' 'git push --force;echo done' 'git reset "--hard"'; do
      guard 2 "$cmd" PowerShell
    done
    guard 0 'Write-Output "git push --force"' PowerShell
    guard 0 'git push origin "HEAD:main"' PowerShell
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook doesn't read a destructive git rule's flag, refspec or path as the shell does, or blocks a message that names one (B33):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks a force push, a +refspec, reset, clean, checkout, stash drop and branch -D that a quote, a line break, ; & | ) or a heredoc body hides, and passes the quoted messages (B33)"; fi

  # A script a shell or an interpreter runs is a command of its own (B34): a quoted string given to bash -c, sh -c or
  # zsh -c (with options before -c), eval, powershell -Command, pwsh -c or cmd /c is read by the same rules, to four levels
  # of nesting, whatever the name is quoted or prefixed with. A comment, a heredoc body or a message in quotes that names
  # one is text, and a read or a benign script passes. A command whose quoting the guard can't close, and PowerShell's
  # -EncodedCommand, whose text is hidden, are blocked.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        "bash -c 'git push --force'" \
        'sh -c "git commit --no-verify -m x"' \
        "eval 'git log --output=x'" \
        'sh -c "git push $(echo --force)"' \
        "sh -c 'git commit -n -m x'" \
        "zsh -c 'git branch -D x'" \
        "bash -lc 'git reset --hard'" \
        "bash -o pipefail -c 'git push --force'" \
        'eval "git push" --force' \
        "bash -c \"git push '--force'\"" \
        "timeout 240 bash -c 'git push --force'" \
        "bash -c 'bash -c \"git push --force\"'" \
        'sh -c "git commit -m \"x\" -n"' \
        'powershell -NoProfile -Command "git push --force"' \
        'cmd /c "git push --force"' \
        '"bash" -c "git push --force"' \
        "ba''sh -c 'git push --force'" \
        "nice -n 5 bash -c 'git push --force'" \
        "sudo sh -c 'git push --force'" \
        "eval 'bash -c \"git push --force\"'" \
        "bash -c \"\$(echo git push --force)\"" \
        "bash -c 'git checkout .'" \
        'bash -c "git push origin +main"' \
        "/bin/bash -c 'git push --force'" \
        "bash -c \$'git push --force'" \
        "bash -c 'git commit -F /tmp/msg.txt'" \
        "bash -c 'bash tools/stacks/../x.sh'" \
        "bash -c 'sleep 300'" \
        'sh -c "git status' \
        'powershell -EncodedCommand ZwBpAHQAIABwAHUAcwBoAA==' \
        $'# don\'t\nbash -c \'git push --force\'' \
        $'cat <<\'EOF\'\nit\'s\nEOF\nbash -c \'git push --force\'' \
        $'bash -c \'echo hi\' ; sh -c "git status\nbash -c \'git push --force\'"'; do
      guard 2 "$cmd"
    done
    # Four wrappers nested (bash -c inside sh -c inside zsh -c inside bash -c) reach the git inside; a fifth is blocked.
    wrap_esc() { local s="$1"; s="${s//\\/\\\\}"; s="${s//\"/\\\"}"; printf '%s' "$s"; }
    nest="bash -c 'git push --force'"
    for _ in 1 2 3; do nest="sh -c \"$(wrap_esc "$nest")\""; done
    guard 2 "$nest"
    nest="bash -c 'echo hi'"
    for _ in 1 2 3; do nest="sh -c \"$(wrap_esc "$nest")\""; done
    guard 0 "$nest"
    nest="sh -c \"$(wrap_esc "$nest")\""
    guard 2 "$nest"
    for cmd in \
        "bash -c 'git status'" \
        'sh -c "echo hi"' \
        "bash -c 'git log --oneline -3'" \
        "sh -c \"git commit -m 'fix the --output handling'\"" \
        'echo "bash -c '"'"'git push --force'"'"'"' \
        'git commit -m "fix: sh -c '"'"'git push --force'"'"' now blocked"' \
        $'git commit -q -F - <<\'EOF\'\nthe sh -c \'git push --force\' guard\nEOF' \
        "timeout 240 bash -c 'until test -f x; do sleep 5; done'" \
        '(timeout 4m bash -c "while true; do sleep 1; done")' \
        'bash -c "echo $(date)"' \
        'powershell -NoProfile -Command "Write-Output '"'"'hi'"'"'"' \
        "bash -c 'cat README.md'" \
        'eval "echo hi"' \
        'git log --grep "bash -c git push --force"' \
        "bash -c 'echo hi' git status" \
        'echo sh -c' \
        'git commit -m "run cmd /c later"' \
        $'bash -c "git commit -F - <<\'EOF\'\nmsg\nEOF"' \
        $'git commit -m "$(cat <<\'EOF\'\nmsg with sh -c \'git push --force\'\nEOF\n)"' \
        'bash tools/check.sh'; do
      guard 0 "$cmd"
    done
    # PowerShell (B34): the same wrappers in the PowerShell tool's payload, and a backtick that joins a flag.
    for cmd in \
        "pwsh -c 'git reset --hard'" \
        'powershell -Command "git push --force"' \
        'bash -c "git push --force"' \
        'cmd /c "git push --force"' \
        'powershell -EncodedCommand ZwBpAHQAIABwAHUAcwBoAA==' \
        'powershell -c "git push --fo`rce"'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in \
        "pwsh -c 'git status'" \
        'powershell -NoProfile -Command "Write-Output '"'"'hi'"'"'"' \
        'cmd /c "echo hi"' \
        'powershell -File tools/x.ps1 "git push --force"' \
        'pwsh -c "Get-ChildItem | Select-Object Name"'; do
      guard 0 "$cmd" PowerShell
    done
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook doesn't read a script a shell or an interpreter runs as a command of its own, or blocks a message that names one (B34):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook reads a script given to bash -c, sh -c, zsh -c, eval, powershell -Command, pwsh -c or cmd /c as a command, to four levels, and passes the messages, heredocs and reads that name one (B34)"; fi

  # A wait loop in a script a shell or an interpreter runs (B42): the hang check reads each such script as it reads the command,
  # so an until, while true or while : loop with sleep is blocked under eval, bash -c, sh -c, powershell -Command and cmd /c.
  # A timeout of 280 seconds or less above the wrapper bounds the whole script, as it bounds a loop the command runs itself,
  # and a loop with no sleep, or in a message that names one, passes.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        "eval 'until false; do sleep 1; done'" \
        "eval 'while true; do sleep 1; done'" \
        "eval 'while :; do sleep 1; done'" \
        "sh -c 'until false; do sleep 1; done'" \
        "eval \"until false; do sleep 1; done\"" \
        "eval 'bash -c \"until false; do sleep 1; done\"'" \
        "eval 'eval \"while true; do sleep 1; done\"'" \
        "sh -c \"eval 'while : ; do sleep 1; done'\"" \
        "timeout 9999 eval 'until false; do sleep 1; done'" \
        "timeout 0 eval 'until false; do sleep 1; done'" \
        "timeout 5m eval 'until false; do sleep 1; done'" \
        'cmd /c "until false; do sleep 1; done"' \
        'cmd /c "while true; do sleep 1; done"' \
        'powershell -Command "while ($true) { Start-Sleep 1 }"' \
        'powershell -NoProfile -Command "while ($true) { sleep 1 }"'; do
      guard 2 "$cmd"
    done
    for cmd in \
        'while ($true) { Start-Sleep 1 }' \
        'While ($true) { Start-Sleep -Seconds 5 }' \
        'WHILE ($true) { start-sleep 2 }'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in \
        "timeout 60 eval 'until false; do sleep 1; done'" \
        "timeout 4m eval 'until false; do sleep 1; done'" \
        "timeout 240s eval 'until false; do sleep 1; done'" \
        'timeout 60 cmd /c "until false; do sleep 1; done"' \
        "timeout 60 bash -c \"eval 'until false; do sleep 1; done'\"" \
        "sh -c \"timeout 60 eval 'until false; do sleep 1; done'\"" \
        "eval 'timeout 60 bash -c \"until false; do sleep 1; done\"'" \
        "eval 'until false; do echo hi; done'" \
        "eval 'sleep 1'" \
        "eval 'git commit -m \"until false; do sleep 1; done\"'" \
        'cmd /c "echo until"' \
        'powershell -Command "Write-Output (Get-Date)"'; do
      guard 0 "$cmd"
    done
    for cmd in \
        'while ($true) { Get-Date }' \
        'timeout 60 powershell -Command "while ($true) { Start-Sleep 1 }"'; do
      guard 0 "$cmd" PowerShell
    done
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook doesn't block a wait loop in a script a shell or an interpreter runs, or blocks one a timeout bounds (B42):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks an until or while loop with sleep in a script given to eval, bash -c, sh -c, powershell -Command or cmd /c, and passes one under a timeout of 280 seconds or less (B42)"; fi

  # A variable in a git command's words (B37): the guard can't read what it holds. A variable that the command assigns once,
  # to a plain value, is read as that value, so FLAG=--force; git push $FLAG is the force push it is. Any other unquoted
  # variable in the words of a git subcommand the rules read is blocked, and so is a quoted one that a flag or a path could
  # be, a fixed text that starts a flag (--$X), a variable as the subcommand, and a variable as a command's name followed by
  # -c or -Command. The everyday forms pass: a quoted variable as the value of -m, -e, -b or -C, after --, after fixed text
  # that doesn't start a flag, as a push's branch after its remote, and in a subcommand the rules don't read (git status).
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        'FLAG=--force; git push $FLAG' \
        'FLAG=-f; git push ${FLAG} origin' \
        'export ST=-f && git push $ST origin' \
        'FLAG=--force; git push "$FLAG"' \
        'FLAG=ok; FLAG=--force; git push $FLAG' \
        'FLAG=ok; read FLAG; git push $FLAG' \
        'NV=--no-verify; git commit $NV -m x' \
        'git commit $NV -m x' \
        "git commit \"\$NV\" -m x" \
        'git push $FLAG' \
        'git push "$FLAG"' \
        'git push origin $BR' \
        'git push --$X' \
        'git push "--$X"' \
        'git push -$F origin' \
        'git log $X' \
        'git log --output="$X"' \
        'git diff "$f"' \
        'git -C $d log' \
        'git $CMD --force' \
        'git commit -nm"$x" -- a' \
        'git commit -m$msg' \
        'git checkout -b $name' \
        'git reset --hard $REF' \
        'git branch -D "$b"' \
        'git grep "$p"' \
        $'bash <<\'EOF\'\ngit push $FLAG\nEOF' \
        $'git commit -F - <<\'EOF\'\nfix git push $X handling\nEOF' \
        "\$X -c 'git push --force'" \
        '"$SHELL" -c "git push --force"' \
        'sudo "$X" -c "git push --force"' \
        'env FOO=1 $X -c x' \
        'timeout 240 "$X" -c x' \
        'echo ok && $X -c x' \
        '"$EDITOR" -c x'; do
      guard 2 "$cmd"
    done
    for cmd in 'git commit $NV -m x' 'git push "$FLAG"' 'git push -u origin $BR' '$X -c "git push --force"' \
        '& $X -c "git push --force"'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in \
        'for r in A B C; do git -C work/$r status --short; done' \
        'git -C "work/$r" log --oneline -1' \
        'git -C "$repo" fetch' \
        'git -C $d status' \
        'git status $X' \
        'git add $FILE' \
        'git log --since="$since"' \
        'git commit -m "$msg" -- a' \
        'git commit -m"$msg" -- a' \
        'git commit -am "$msg"' \
        'git commit -C "$c"' \
        'git push -u origin "$branch"' \
        'git push origin "$a" "$b"' \
        'git checkout -b "ddd/bundle-$day"' \
        'git checkout -b "ddd/bundle-$day" origin/main' \
        'git switch -c "$b"' \
        'git grep -e "$p"' \
        'git tag -a "v$VER" -m "release"' \
        'git log --format="%h $X"' \
        'git log -- $X' \
        'git commit -m "$msg" -- $X' \
        'git log > "$out"' \
        'git log >"$out" --oneline' \
        'FLAG=ok; git push $FLAG' \
        'FLAG=--force; echo $FLAG' \
        'MSG=--force; git commit -m "$MSG"' \
        'a=1; git push $a' \
        'echo $X -c x' \
        'echo -n $X -c x' \
        'echo "$X -c y"' \
        '"$EDITOR" notes.txt' \
        'git commit -m "& $X -c y" -- a' \
        $'git commit -q -F - <<\'EOF\'\nfix the $X handling\nEOF'; do
      guard 0 "$cmd"
    done
    guard 0 'git push -u origin "$branch"' PowerShell
    guard 0 'git commit -m "$msg" -- a' PowerShell
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook reads a variable in a git command's words as a value it can't see, or blocks a plain form (B37):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook reads a variable a git command assigns once as its value, blocks an unquoted or flag-capable variable in a git command's words, a variable as a subcommand or as a shell's name followed by -c, and passes the everyday forms (B37)"; fi

  # A variable as a command's name, and a variable a shell's script or a script path holds (B45): the name a command assigns is
  # the name it runs (G=git; $G push --force is git), and an unresolved name that the command sets another way, or that a git
  # subcommand or a destructive flag follows, is blocked. A variable a shell's script (bash -c, eval, -Command) holds, or that a
  # script path under tools/ holds, is blocked too. The everyday forms pass: "$PY" -I script.py, a loop that runs "$PY" "$f", a
  # variable as an argument, and a single-quoted script's own variable (its shell reads it, and it can't name a command here).
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        'G=git; $G push --force' \
        '$G push --force' \
        '"$G" push --force' \
        'G=git; ${G} push --force' \
        'G=git; "$G" push --force' \
        '$G --force' \
        'if true; then $G push --force; fi' \
        'for f in x; do $G push --force; done' \
        '{ $G push --force; }' \
        'xargs $G push --force' \
        'find . -exec $G push --force \;' \
        'if true; then "$X" -c x; fi' \
        'CMD="git push --force"; $CMD' \
        'read CMD <<< "git push --force"; $CMD' \
        'FOO=$(echo git); $FOO push --force' \
        'X=../../evil.sh; bash tools/stacks/$X' \
        'bash tools/stacks/$X.sh' \
        'bash "tools/$X"' \
        'bash -c "$CMD"' \
        'eval "$CMD"' \
        'eval $CMD' \
        "bash -c '\$CMD'" \
        'CMD="git push --force" bash -c '"'"'$CMD'"'"'' \
        'sh -c "echo $HOME"' \
        $'G=git; bash <<\'EOF\'\n$G push --force\nEOF' \
        $'bash <<\'EOF\'\n$G push --force\nEOF' \
        $'CMD="git push --force" bash <<\'EOF\'\n$CMD\nEOF'; do
      guard 2 "$cmd"
    done
    for cmd in "\$G = 'git'; & \$G push --force" '& $G push --force'; do
      guard 2 "$cmd" PowerShell
    done
    guard 2 'powershell -Command "$P"' PowerShell
    for cmd in \
        'G=git; $G status' \
        'G=ls; $G push --force' \
        'echo $G push --force' \
        '"$PY" -I script.py' \
        'PY=python3; "$PY" -I script.py' \
        'FOO="a b" "$PY" -I x.py' \
        'for f in tools/*.py; do "$PY" "$f"; done' \
        'for f in a b; do echo "$f"; done' \
        'if true; then "$PY" -I x.py; fi' \
        'find . -name x -exec "$PY" -I y {} \;' \
        'xargs -I{} echo {}' \
        '"$PY" tools/usage.py status' \
        'bash "$script"' \
        'bash tools/check.sh "$X"' \
        'cd "$dir" && git status' \
        'bash -c "echo \$HOME"' \
        "bash -c 'echo \$HOME'" \
        $'git commit -q -F - <<\'EOF\'\n$G push --force\nEOF'; do
      guard 0 "$cmd"
    done
    guard 0 "powershell -Command 'Get-ChildItem | % { \$_.Name }'" PowerShell
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook doesn't read a variable as a command's name, or a script or script path that a variable holds, or blocks an everyday form (B45):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook reads a variable as a command's name as the value it assigns, blocks an unresolved one that the command sets another way or a git subcommand follows, blocks a shell's script, eval or -Command that a variable holds and a tools/ script path with a variable, and passes the everyday forms (B45)"; fi

  # A git command name in another case (B46): PowerShell finds a command case-insensitively, and Windows finds GIT too, so GIT and
  # Git are git in every git rule. Only the name is matched so: git's subcommands and flags stay case-sensitive, as git reads them.
  # The git rules, the credential prints, a substitution in the words and a shell body that runs GIT block as their lowercase
  # forms do, and the everyday forms and a quoted or heredoc message that names git in another case pass.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        'GIT push --force origin main' \
        'Git commit --no-verify -m x' \
        'GIT reset --hard HEAD~1' \
        'GIT log --output=/tmp/probe.txt' \
        'Git diff --no-index a b' \
        'GIT commit -F /tmp/msg.txt' \
        'GIT grep -Oecho foo' \
        'GIT push origin :main' \
        'GIT branch -D x' \
        'GIT credential fill' \
        'Git credential get' \
        'GIT -c core.pager=calc log' \
        'Git push "$(echo --force)" origin main' \
        $'bash <<\'EOF\'\nGIT push --force\nEOF'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in 'GIT push --force origin main' 'Git commit --no-verify -m x'; do
      guard 2 "$cmd"
    done
    for cmd in \
        'GIT status' \
        'Git log --oneline -5' \
        'GIT diff HEAD' \
        'GIT grep -n foo' \
        'GIT tag -a v1 -m "see --force and -F"' \
        'echo "Git push --force is blocked"' \
        'echo "Git credential fill is blocked"' \
        $'Git commit -q -F - <<\'EOF\'\nfix the --output and --no-index handling, not -F /tmp/x\nEOF'; do
      guard 0 "$cmd" PowerShell
    done
    guard 0 'GIT status'
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook passes a git command name in another case, or blocks a message that names git in another case (B46):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks a git command name in any case (GIT, Git) as it blocks git, and passes the everyday forms and the messages that name git in another case (B46)"; fi

  # Git's configuration keys and program flags (B38). A -c key, or --config-env, that names a program git runs (an alias that
  # starts with !, the pager, the editor, the ssh command, a diff or credential helper, an include) is blocked, and so is a key a
  # variable holds; the keys that run nothing pass (core.quotepath, color.*, advice.*, log.*, user.name, pager.<cmd>=false). The
  # flags that name a program for a remote (--upload-pack, --receive-pack, --exec, and clone's -u), abbreviations included, are
  # blocked on fetch, pull, push, clone, ls-remote and archive, and a plain fetch, push -u and clone -b pass. A variable that names
  # a program git runs (GIT_CONFIG_*, GIT_SSH_COMMAND, GIT_PAGER, GIT_EDITOR, EDITOR) set on a git command is blocked too.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        'git -c alias.x="!echo hi" x' \
        "git -c 'alias.x=!echo hi' x" \
        'git -c "alias.x=!echo hi" x' \
        'git -c core.pager="sh -c x" log' \
        'git -c core.sshCommand=x fetch' \
        'git -c diff.external=x diff' \
        'git -c "$k=v" log' \
        'git -c Alias.X=y x' \
        'git -c core.quotepath=false -c alias.x=y x' \
        'git -c color.ui=always -c core.pager=x log' \
        'git -c sequence.editor=x rebase -i HEAD~2' \
        "git -c credential.helper='!x' fetch origin" \
        'git -c protocol.ext.allow=always fetch origin' \
        'git -c include.path=/tmp/x log' \
        'git -c "core.$(echo pager)=x" log' \
        'git -c pager.log=less log' \
        'git --config-env=core.pager=PAGER_VAR log' \
        'git --git-dir .git -c alias.x=y x' \
        "git -c \$'alias.x=!echo hi' x" \
        "git -c 'alias.x=y' x" \
        'git -c "alias.x" x' \
        'git -c "a""lias.x=!echo" x' \
        'git -c "core.pager"=sh x' \
        'k=core.pager; git -c "$k=sh" log' \
        $'git \\\n-c core.pager=x log' \
        'git clone -c core.sshCommand=x https://example.com/r.git d' \
        'git clone --config=alias.x=y https://example.com/r.git d' \
        'git clone --config alias.x=y https://example.com/r.git d' \
        'git clone -c alias.x=y https://example.com/r.git d' \
        'git clone -u "sh -c x" https://example.com/r.git d' \
        'git clone --upload-pack="sh -c x" https://example.com/r.git d' \
        'git clone -qu "sh -c x" https://example.com/r.git d' \
        'git fetch --upload-pack x origin' \
        'git fetch --upl=x origin' \
        'git fetch --upload-pack="$(echo x)" origin' \
        'git fetch "--$(echo upload-pack)=x" origin' \
        'git pull --upload-pack=x' \
        'git push --receive-pack=x origin main' \
        'git push --receive-pack x origin main' \
        'git push --exec=x origin main' \
        'git push origin main --receive=x' \
        'git ls-remote --upload-pack=x origin' \
        'git archive --remote=origin --exec=x HEAD' \
        'GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.pager GIT_CONFIG_VALUE_0=x git log' \
        'GIT_SSH_COMMAND=x git fetch' \
        'GIT_PAGER=x git log' \
        'GIT_EXTERNAL_DIFF=x git log -p' \
        'env GIT_EDITOR=x git commit' \
        'export GIT_PAGER=x; git log' \
        'EDITOR=x git commit -a'; do
      guard 2 "$cmd"
    done
    for cmd in 'git -c core.pager=x log' 'git -c "$k=v" log' 'git fetch --upload-pack=x' 'git -c alias.x=!echo x' \
        '$env:GIT_PAGER="x"; git log'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in \
        'git -c core.quotePath=false status --porcelain --untracked-files=all' \
        'git -c core.quotepath=off log --oneline -3' \
        'git -c color.ui=never log --oneline' \
        'git -c user.name=selftest -c user.email=selftest@localhost commit -m x' \
        "git -c 'user.name=A B' commit -m x" \
        'git -c advice.detachedHead=false checkout HEAD~1' \
        'git -c log.showSignature=false log -1' \
        'git -c pager.log=false log --oneline' \
        'git -c "color.ui=always" diff --stat' \
        'k=color.ui; git -c "$k=always" log --oneline' \
        'git -C work/App-Director fetch' \
        'git -c core.quotepath=false -C work/App-Director status' \
        'git clone -b main https://example.com/r.git d' \
        'git clone -q --depth 1 https://example.com/r.git d' \
        'git clone -c core.quotepath=false https://example.com/r.git d' \
        'git fetch origin' \
        'git fetch --unshallow origin' \
        'git push -u origin "$branch"' \
        'git push origin main' \
        'git push --recurse-submodules=check origin main' \
        'git ls-remote origin' \
        'git archive --format=tar HEAD' \
        'git pull --rebase origin main' \
        'git log -c' \
        'git commit -c HEAD' \
        'git commit -m "--upload-pack=x fix"' \
        'git commit -m "alias.x=!echo hi"' \
        'git tag -a v1 -m "-c alias.x=y"' \
        'git commit -m "set EDITOR=vim and GIT_PAGER=x"' \
        'GIT_AUTHOR_NAME=x git commit -m y' \
        'FOO=1 git status' \
        'EDITORCONFIG=x git status' \
        $'git commit -q -F - <<\'EOF\'\nGIT_PAGER=x and EDITOR=vim in a message\nEOF' \
        $'git \\\n-c core.quotepath=false status'; do
      guard 0 "$cmd"
    done
    guard 0 'git -c user.email=a@b.c commit -m x' PowerShell
    guard 0 'git -c color.ui=always status' PowerShell
    guard 0 'git push -u origin main' PowerShell
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook passes a git -c key or a program flag that runs a command, or a variable that names one, or blocks a plain form (B38):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks a git -c key that names a program (an alias, the pager, the ssh command, a diff or credential helper), a key a variable holds, a program flag for a remote (--upload-pack, --receive-pack, --exec, clone's -u), and a GIT_CONFIG_*, GIT_PAGER or EDITOR variable on a git command; the keys that run nothing and the plain forms pass (B38)"; fi

  # A quoted git name, a heredoc body a shell runs, the long forms and a credential subcommand in quotes (B39). The git name is
  # read as the shell reads it, quotes removed, so "git", 'git' and g"it" are git. A heredoc body a shell runs (any body but a
  # commit's or tag's message) is read by the file-writing flag rules, and a backtick ends a flag in it. git branch with --delete
  # and --force (-d -f, -df, --del --forc), git push --mirror, --delete and -d (abbreviations too) and a :ref refspec are blocked,
  # as their plain forms are, and the credential-print rules read the decoded words. A message that names them, and a read that
  # names none, pass: a commit's or tag's message is text no shell runs.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        '"git" push --force' \
        "'git' push --force" \
        'g"it" push --force' \
        '"git" log --output=/tmp/x' \
        $'bash <<\'EOF\'\ngit log --output=/tmp/x\nEOF' \
        $'sh <<EOF\ngit diff --no-index a b\nEOF' \
        $'bash <<\'EOF\'\ngit commit -F /tmp/msg.txt\nEOF' \
        $'bash <<\'EOF\'\ngit grep -Oecho foo\nEOF' \
        $'cat <<\'EOF\' | bash\ngit log --output=/tmp/x\nEOF' \
        $'bash <<\'EOF\'\ngit branch --delete --force x\nEOF' \
        $'bash <<\'EOF\'\ngit push --mirror\nEOF' \
        $'bash <<\'EOF\'\ngit credential "fill"\nEOF' \
        $'bash <<\'EOF\'\ngit push `echo --force`\nEOF' \
        $'bash <<\'EOF\'\ngit push --force`echo x`\nEOF' \
        $'ssh host <<\'EOF\'\ngit push `echo --force`\nEOF' \
        $'git status && bash <<\'EOF\'\ngit push `echo --force`\nEOF' \
        $'"bash" <<\'EOF\'\ngit push --mirror\nEOF' \
        $'git commit -m "$(source /dev/stdin <<\'EOF\'\ngit push `echo --force`\nEOF\n)"' \
        'sh -c "git push --mirror"' \
        'git branch --delete --force x' \
        'git branch --delete -f x' \
        'git branch -d -f x' \
        'git branch -df x' \
        'git branch -fd x' \
        'git branch --del --forc x' \
        'git push --mirror' \
        'git push --mirror origin' \
        'git push --mi origin' \
        'git push --delete origin x' \
        'git push --de origin x' \
        'git push -d origin x' \
        'git push -fd origin x' \
        'git push origin :x' \
        'git push origin ":x"' \
        'git push origin :refs/heads/x' \
        'git credential "fill"' \
        "git credential 'get'" \
        'git credential fi"ll"' \
        'gh "auth" "token"' \
        'g"h" auth token'; do
      guard 2 "$cmd"
    done
    for cmd in \
        'git branch -d x' \
        'git branch -vv' \
        'git branch -m old new' \
        'git branch --list "*f*"' \
        'git push origin main:main' \
        'git push origin HEAD:refs/heads/x' \
        'git push --dry-run origin main' \
        'git push --set-upstream origin x' \
        'echo "git push --mirror"' \
        'echo "git credential fill"' \
        'git log --grep "push --mirror"' \
        'git status && echo "git credential fill"' \
        $'git commit -q -F - <<\'EOF\'\nfix: git push --mirror and git branch -d x\nEOF' \
        $'git commit -q -F - <<\'EOF\'\nfix: git log --output=x in the docs\nEOF' \
        $'git commit -q -F - <<\'EOF\'\nmsg with `git push --force` in it\nEOF' \
        $'git tag -a v1 -F - <<\'EOF\'\nfix: git push --delete origin x\nEOF' \
        $'git commit -q -F - <<\'EOF\'\nfix the --mirror and --delete flags, not -d\nEOF' \
        $'bash <<\'EOF\'\necho hi\nEOF' \
        $'bash <<\'EOF\'\ngit status\nEOF' \
        $'bash <<\'EOF\'\ngit branch -d x\nEOF' \
        $'git status && bash <<\'EOF\'\necho x\nEOF'; do
      guard 0 "$cmd"
    done
    for cmd in '"git" push --force' 'git branch --delete --force x' 'git push --mirror' 'git push origin :x' \
        'git credential "fill"' 'gh "auth" "token"'; do
      guard 2 "$cmd" PowerShell
    done
    for cmd in 'git branch -d x' 'git push origin main'; do
      guard 0 "$cmd" PowerShell
    done
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook doesn't read a quoted git name, a heredoc body a shell runs, a long-form branch or push flag, a push refspec that deletes, or a quoted credential subcommand as the shell does, or blocks a message that names a plain form (B39):"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook blocks a quoted git name, a heredoc body a shell runs with a file-writing flag, a backtick flag or a destructive command, git branch --delete --force, git push --mirror, --delete or a :ref refspec, and a quoted credential subcommand, and passes the messages and reads that name them (B39)"; fi

  # A heredoc body no shell runs is text (B40): a commit's or tag's message, and a cat or tee body that the command doesn't run (no
  # shell, interpreter, ssh, chmod, make, a ./ path, a dot-source or the .git folder). The destructive rules and the file-writing flag
  # rules skip such a body, so a message or a written file that names a destructive git command passes, and its substitutions are
  # still read. A body written to a file and run in the same command (cat > x.sh, then bash x.sh, ./x.sh or . x.sh) is a script a
  # shell runs, and is read as before. The guard reads command text, so a file written by an earlier command isn't judged.
  git_fail=""
  if [ -f .claude/hooks/guard-commands.sh ]; then
    for cmd in \
        $'git commit -q -F - <<\'EOF\'\nfix: git push --force; done\nEOF' \
        $'git tag -a v1 -F - <<\'EOF\'\nfix: git push --delete origin x\nEOF' \
        $'git commit -q -F - <<\'EOF\'\nmsg with `git push --force` in it\nEOF' \
        $'git commit -m "$(cat <<\'EOF\'\nfix: git reset --hard\nEOF\n)"' \
        $'git commit -q -F - <<\'EOF\'\nfix: git log --output=x in the docs\nEOF\nbash x.sh' \
        $'cat > notes.md <<\'EOF\'\nsee git log --output=x\nEOF' \
        $'cat > notes.md <<\'EOF\'\na backticked `git push --force` here\nEOF' \
        $'tee notes.md <<\'EOF\'\ngit push --mirror\nEOF' \
        $'cat <<\'EOF\' > notes.md\ngit reset --hard\nEOF' \
        $'cat >> notes.md <<\'EOF\'\ngit branch -D x\nEOF' \
        $'cat > notes.md <<\'EOF\'\ngit push --force\nEOF\ngit add notes.md && git status' \
        $'cat > ./notes.md <<\'EOF\'\ngit grep -Oecho foo\nEOF' \
        $'cat > notes.md <<\'EOF\'\nbash -c \'git push --force\'\nEOF' \
        $'cat > notes.md <<EOF\nplain text, no git here\nEOF' \
        $'cat > notes.md <<\'EOF\'\ngit push --force\nEOF\necho "run bash later"' \
        $'cat > notes.md <<\'EOF\'\ngit push --force\nEOF\ngit commit -q -F - <<\'EOF2\'\nfix: git push --force\nEOF2'; do
      guard 0 "$cmd"
    done
    for cmd in \
        $'cat > x.sh <<EOF\ngit push --force\nEOF\nbash x.sh' \
        $'cat > x.sh <<\'EOF\'\ngit push --force\nEOF\nbash x.sh' \
        $'cat > x.sh <<\'EOF\'\ngit push --force\nEOF\nchmod +x x.sh && ./x.sh' \
        $'cat > x.sh <<\'EOF\'\ngit reset --hard\nEOF && sh x.sh' \
        $'cat > x.sh <<\'EOF\'\ngit log --output=/tmp/x\nEOF\nbash x.sh' \
        $'cat > x.sh <<\'EOF\'\ngit push --force\nEOF\nsource x.sh' \
        $'tee x.sh <<\'EOF\'\ngit push --force\nEOF\n. ./x.sh' \
        $'cat > x.sh <<\'EOF\'\ngit push --force\nEOF\n"bash" x.sh' \
        $'cat > x.sh <<\'EOF\'\ngit push --force\nEOF\npython3 x.sh' \
        $'cat > x.sh <<\'EOF\'\ngit push --force\nEOF\nenv bash x.sh' \
        $'cat > Makefile <<\'EOF\'\npush:\n\tgit push --force\nEOF\nmake push' \
        $'cat > .git/hooks/pre-commit <<\'EOF\'\ngit push --force\nEOF\ngit commit -q -m x' \
        $'cat > notes.md <<EOF\n$(git push --force)\nEOF' \
        $'cat > notes.md <<EOF\n`git push --force`\nEOF' \
        $'git commit -q -F - <<EOF\nfix `git push --force`\nEOF' \
        $'cat <<\'EOF\' | bash\ngit push --force\nEOF' \
        $'bash <<\'EOF\'\ngit push --force\nEOF'; do
      guard 2 "$cmd"
    done
    guard 2 $'cat > x.ps1 <<\'EOF\'\ngit push --force\nEOF\n& ./x.ps1' PowerShell
  fi
  guard_run
  if [ -n "$git_fail" ]; then
    err "the guard hook reads a commit's or tag's message, or a cat or tee body that nothing in the command runs, as a script (B40), or passes a body a shell runs:"
    printf '%s\n' "${git_fail#$'\n'}"
  else echo "ok: the guard hook passes a commit's or tag's message and a cat or tee body that the command doesn't run, and blocks a body written to a file and run in the same command (B40)"; fi

  # The credential stores (B15): the Read tool may not open the gh CLI's token file, git's credentials or
  # ~/.ssh. The .env files with values (B21): .env.local and the other .env.<suffix> files the guard hook
  # blocks, each in its plain and **/ form. Each of these Read rules must be in the deny list, named exactly.
  read_fail=""
  for rule in 'Read(~/.ssh/**)' 'Read(~/.git-credentials)' 'Read(~/.config/git/credentials)' \
      'Read(~/.config/gh/**)' 'Read(~/AppData/Roaming/GitHub CLI/**)' \
      'Read(.env.local)' 'Read(**/.env.local)' 'Read(.env.*.local)' 'Read(**/.env.*.local)' \
      'Read(.env.development)' 'Read(**/.env.development)' 'Read(.env.production)' 'Read(**/.env.production)' \
      'Read(.env.staging)' 'Read(**/.env.staging)' 'Read(.env.test)' 'Read(**/.env.test)'; do
    printf '%s\n' "$perm_deny" | grep -qF "\"$rule\"" \
      || read_fail="$read_fail"$'\n'"  settings.json doesn't deny $rule"
  done
  if [ -n "$read_fail" ]; then
    err "the Read tool can open the credential stores (the gh CLI's, git's credentials, ~/.ssh) or the .env files with values:"
    printf '%s\n' "${read_fail#$'\n'}"
  else echo "ok: settings.json denies the Read tool the gh CLI's, git's and SSH credential stores and the .env files with values"; fi

  # The PowerShell tool (B24) has its own name. The guard runs for it only when the hook's matcher names it,
  # and a Bash(...) deny or ask rule stops the same command in PowerShell only through its PowerShell(...)
  # twin, in the same list. The allow list names no PowerShell command, so nothing PowerShell runs is allowed
  # without a prompt. Read(...) rules are the Read tool's; PowerShell's own file reads are not covered here.
  ps_fail=""
  guard_matcher=$(awk -F'"' '/"matcher"/ { m = $4 } /guard-commands\.sh/ { print m; exit }' .claude/settings.json)
  for tool in Bash Monitor PowerShell; do
    case "|$guard_matcher|" in
      *"|$tool|"*) ;;
      *) ps_fail="$ps_fail"$'\n'"  the guard hook's matcher \"$guard_matcher\" doesn't name $tool" ;;
    esac
  done
  for list in deny ask; do
    arr=$(sed -n "/\"$list\": *\[/,/\]/p" .claude/settings.json)
    while IFS= read -r rule; do
      [ -n "$rule" ] || continue
      twin="PowerShell(${rule#Bash(}"
      printf '%s\n' "$arr" | grep -qF "\"$twin\"" \
        || ps_fail="$ps_fail"$'\n'"  settings.json's $list rules have $rule but no $twin"
    done <<< "$(printf '%s\n' "$arr" | grep -oE '"Bash\([^"]*\)"' | tr -d '"')"
  done
  printf '%s\n' "$perm_allow" | grep -q 'PowerShell(' \
    && ps_fail="$ps_fail"$'\n'"  settings.json's allow list names a PowerShell command, so PowerShell would run it without a prompt"
  if [ -n "$ps_fail" ]; then
    err "the PowerShell tool isn't wired to the guard and the deny rules (B24):"
    printf '%s\n' "${ps_fail#$'\n'}"
  else echo "ok: the guard hook's matcher names PowerShell, every Bash deny rule has a PowerShell twin, and the allow list names no PowerShell command"; fi
fi

# 9. Build and links ------------------------------------------------------------------------
mkdocs=""
if command -v mkdocs >/dev/null 2>&1; then mkdocs="mkdocs"
else
  for py in python3 python; do
    "$py" -m mkdocs --version >/dev/null 2>&1 && { mkdocs="$py -m mkdocs"; break; }
  done
fi
if [ -n "$mkdocs" ]; then
  if out=$($mkdocs build --strict --clean 2>&1); then echo "ok: site builds, no broken links"
  else err "mkdocs build --strict:"; echo "$out" | grep -E 'WARNING|ERROR|Aborted' | sed 's/^/  /'; fi
  # A Markdown link inside raw HTML without the markdown attribute is printed as text, and
  # the strict build can't see it. Fail on any [text](page.md) left in the built pages.
  raw=$(grep -rlE '\]\([^) ]*\.md(#[^)]*)?\)' site --include='*.html' 2>/dev/null)
  if [ -n "$raw" ]; then err "unrendered Markdown links (add the markdown attribute to the HTML block):"
    echo "$raw" | sed 's/^/  /'
  else echo "ok: no unrendered Markdown links"; fi
else
  err "mkdocs not installed (pip install -r requirements.txt)"
fi

# 10. Content-Security-Policy ---------------------------------------------------------------
# GitHub Pages sends no response headers, so overrides/main.html sets the policy as a meta tag. A meta
# CSP governs only what comes after it, so it sits first in the head, and its script-src lists the
# sha256 of every inline script the built site runs (Material's; one per page depth). The check reads
# each built page: an inline script whose hash isn't in script-src fails, naming the page and the
# hash, and so does a script that runs before the tag. A Material upgrade that changes a script fails
# here until the hash in overrides/main.html is updated.
csp_py=""
for py in python3 python; do "$py" -c 'import hashlib' >/dev/null 2>&1 && { csp_py="$py"; break; }; done
if [ ! -d site ]; then err "site/ isn't built, so the Content-Security-Policy can't be checked"
elif [ -z "$csp_py" ]; then err "python not found, so the Content-Security-Policy can't be checked (install Python 3)"
else
  csp_out=$("$csp_py" -I - overrides/main.html site 2>&1 <<'PY'
import base64, glob, hashlib, os, re, sys

policy_file, site = sys.argv[1], sys.argv[2]
meta_re = re.compile(r"<meta\b[^>]*Content-Security-Policy[^>]*>", re.I)
policy_tag = meta_re.search(open(policy_file, encoding="utf-8").read())
policy = re.search(r'content="([^"]*)"', policy_tag.group(0)) if policy_tag else None
if not policy:
    print(f"{policy_file} has no Content-Security-Policy meta tag")
    sys.exit(1)
directives = {}
for part in policy.group(1).split(";"):
    words = part.split()
    if words:
        directives[words[0].lower()] = words[1:]
allowed = [w.strip("'") for w in directives.get("script-src", directives.get("default-src", []))]

# Scripts that run have no type, or a JavaScript one; data blocks such as __config (application/json) don't.
run_types = {"", "text/javascript", "application/javascript", "module"}
script_re = re.compile(r"<script\b([^>]*)>(.*?)</script\s*>", re.S | re.I)
attr_re = re.compile(r"""([\w-]+)\s*=\s*(?:"([^"]*)"|'([^']*)')""")
problems, pages, inline = [], 0, 0
for page in sorted(glob.glob(os.path.join(site, "**", "*.html"), recursive=True)):
    name = os.path.relpath(page, site).replace(os.sep, "/")
    html = open(page, encoding="utf-8").read()  # text mode: CRLF become LF, as the browser's parser sees them
    pages += 1
    tag = meta_re.search(html)
    if not tag:
        problems.append(f"{name}: has no Content-Security-Policy meta tag")
        continue
    for m in script_re.finditer(html):
        attrs = {k.lower(): (a or b) for k, a, b in attr_re.findall(m.group(1))}
        if attrs.get("type", "").strip().lower() not in run_types:
            continue
        if m.start() < tag.start():
            problems.append(f"{name}: a script runs before the Content-Security-Policy meta tag, which doesn't govern it")
        if "src" in attrs:
            continue
        inline += 1
        digest = "sha256-" + base64.b64encode(hashlib.sha256(m.group(2).encode("utf-8")).digest()).decode()
        if digest not in allowed:
            problems.append(f"{name}: inline script {digest} isn't in script-src of {policy_file}")
if problems:
    print("\n".join(problems))
    sys.exit(1)
print(f"ok: the Content-Security-Policy in {policy_file} allows all {inline} inline scripts on {pages} built pages, and no script runs before it")
PY
)
  csp_rc=$?
  if [ "$csp_rc" -eq 0 ]; then echo "$csp_out"
  else err "the Content-Security-Policy in overrides/main.html doesn't allow everything the built site runs:"; echo "$csp_out" | sed 's/^/  /'; fi
fi

[ "$fail" -eq 0 ] && echo "selftest passed" || echo "selftest FAILED"
exit "$fail"
