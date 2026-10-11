#!/usr/bin/env bash
# Docs site selftest. Run from the repository root: bash selftest.sh
#
#   1. No en or em dashes in the site sources.
#   2. Docs coverage: every command a framework ships is mentioned on its framework page.
#   3. The site builds in strict mode, which fails on broken internal links and anchors.
#
# The framework repos are kept as clones under .app-director/state/frameworks (gitignored).
# Online, each run refreshes them from GitHub. Offline, the cached copy is used with a notice;
# with no cache and no network, the run fails. CI has no cache, so it clones fresh.
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

# refresh_framework <repo> <dest>: 0 when <dest> holds a current or cached copy of <repo>.
# Clones when there is no cache. Otherwise fetches the remote's default branch (HEAD) and
# resets to it; if that fails, the cached copy is kept and a notice is printed.
# The git metadata sits beside the work tree in <dest>.git, not in <dest>/.git: a nested repo
# makes `git ls-files -o` list the whole clone, which trips the pre-commit hook.
refresh_framework() {
  local repo="$1" dest="$2" gd="$2.git" tmp="$2.partial"
  if [ -d "$gd" ] && [ -d "$dest" ]; then
    if timed 15 --git-dir="$gd" fetch -q --depth 1 "$remote_base/$repo.git" HEAD 2>/dev/null \
       && git --git-dir="$gd" --work-tree="$dest" reset -q --hard FETCH_HEAD; then
      echo "ok: $repo refreshed from GitHub ($(git --git-dir="$gd" log -1 --format='%h %cs'))"
    else
      echo "notice: could not refresh $repo from GitHub (offline?); using the cached copy" \
        "($(git --git-dir="$gd" log -1 --format='%h %cs' 2>/dev/null || echo unknown))"
    fi
    return 0
  fi
  rm -rf "$tmp" "$tmp.git"
  if timed 120 clone -q --depth 1 --separate-git-dir="$tmp.git" "$remote_base/$repo.git" "$tmp" 2>/dev/null; then
    rm -f "$tmp/.git"; rm -rf "$dest" "$gd"; mv "$tmp" "$dest"; mv "$tmp.git" "$gd"
    echo "ok: $repo cloned from GitHub into the cache"
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
      || err "could not clone $repo: no network and no cached copy in $src/$repo (run once online)"
  done
fi

field() { sed -n "s/^$1:[[:space:]]*['\"]\{0,1\}\([^'\"]*\).*/\1/p" "$2" | head -1; }

for pair in $repos; do
  repo="${pair%%:*}"; page="docs/frameworks/${pair##*:}.md"
  [ -d "$src/$repo" ] || { err "$repo not found in $src"; continue; }
  [ -f "$page" ] || { err "$page is missing"; continue; }
  missing=""; count=0
  # Slash commands installed into projects.
  for f in "$src/$repo"/framework/.claude/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    name=$(field name "$f"); desc=$(field description "$f")
    case "$desc" in Deprecated*) continue ;; esac
    count=$((count + 1))
    grep -qF "\`/$name" "$page" || missing="$missing /$name"
  done
  # Installer and standalone skills.
  for f in "$src/$repo"/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    name=$(field name "$f"); count=$((count + 1))
    grep -qF "$name" "$page" || missing="$missing $name"
  done
  if [ -n "$missing" ]; then err "$page doesn't mention:$missing"
  else echo "ok: $page covers all $count commands and skills of $repo"; fi
done

# 3. Skills coverage ------------------------------------------------------------------------
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

# 4. Build and links ------------------------------------------------------------------------
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
else
  err "mkdocs not installed (pip install -r requirements.txt)"
fi

[ "$fail" -eq 0 ] && echo "selftest passed" || echo "selftest FAILED"
exit "$fail"
