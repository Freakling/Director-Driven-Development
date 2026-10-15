#!/usr/bin/env bash
# Docs site selftest. Run from the repository root: bash selftest.sh
#
#   1. No en or em dashes in the site sources.
#   2. Docs coverage: every command a framework ships in its latest release is mentioned on its
#      framework page, or on the skill page that covers it (see skill_page below). A page that
#      describes a command only main ships gets a warning: the docs follow releases, not main.
#   3. The site builds in strict mode, which fails on broken internal links and anchors.
#
# The framework repos are kept as copies under .app-director/state/frameworks (gitignored), each
# at its latest release tag (v<version>). Online, each run moves the copies to the latest release.
# Offline, the cached copy is used with a notice; with no cache and no network, the run fails.
# CI has no cache, so it clones the latest releases fresh.
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

# refresh_framework <repo> <dest>: 0 when <dest> holds the latest release of <repo>, or its cached copy.
# <dest> is a work tree at the release tag. Its git metadata sits beside it in <dest>.git, not in
# <dest>/.git: a nested repo makes `git ls-files -o` list the whole clone, which trips the pre-commit
# hook. The metadata also holds the default branch (refs/remotes/github/main) for the main-only check.
# Online, the latest release is fetched and checked out. If GitHub can't be reached, or the cache has
# local changes, the cached copy is kept and a notice is printed.
refresh_framework() {
  local repo="$1" dest="$2" gd="$2.git" tmp="$2.partial" url latest at
  url="$remote_base/$repo.git"
  latest=$(timed 15 ls-remote --tags --refs "$url" 2>/dev/null | sed 's|.*refs/tags/||' | latest_tag)
  if [ -d "$gd" ] && [ -d "$dest" ]; then
    if [ -n "$latest" ] \
       && timed 120 --git-dir="$gd" fetch -q --depth 1 "$url" \
            "+HEAD:refs/remotes/github/main" "+refs/tags/$latest:refs/tags/$latest" 2>/dev/null \
       && git --git-dir="$gd" --work-tree="$dest" checkout -q --detach "refs/tags/$latest" 2>/dev/null; then
      echo "ok: $repo at its latest release $latest ($(git --git-dir="$gd" log -1 --format='%h %cs' "$latest"))"
    else
      at=$(release_at "$gd")
      echo "notice: could not move $repo to its latest release (offline, or local changes in the cache);" \
        "using the cached copy at ${at:-an untagged commit}"
    fi
    return 0
  fi
  # No cache yet: clone the latest release.
  [ -n "$latest" ] || return 1
  rm -rf "$tmp" "$tmp.git"; mkdir -p "$tmp"
  if git --git-dir="$tmp.git" init -q \
     && timed 120 --git-dir="$tmp.git" fetch -q --depth 1 "$url" \
          "+HEAD:refs/remotes/github/main" "+refs/tags/$latest:refs/tags/$latest" \
     && git --git-dir="$tmp.git" --work-tree="$tmp" checkout -q --detach "refs/tags/$latest"; then
    rm -rf "$dest" "$gd"; mv "$tmp" "$dest"; mv "$tmp.git" "$gd"
    echo "ok: $repo cloned from GitHub into the cache, at $latest"
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
      || err "could not get $repo's latest release: no network and no cached copy in $src/$repo (run once online)"
  done
fi

field() { sed -n "s/^$1:[[:space:]]*['\"]\{0,1\}\([^'\"]*\).*/\1/p" "$2" | head -1; }

# commands_of <folder>: one "<kind> <name>" line per command or skill a framework folder ships.
# kind is "slash" for a /name command installed into projects, "skill" for an installer or
# standalone skill. Deprecated slash commands are left out.
commands_of() {
  local f
  for f in "$1"/framework/.claude/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    case "$(field description "$f")" in Deprecated*) continue ;; esac
    echo "slash $(field name "$f")"
  done
  for f in "$1"/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    echo "skill $(field name "$f")"
  done
}

# skill_page <repo> <skill>: the skill page that covers a skill under another name, if there is one.
# Godot-Director's /function-check is the acceptance check, so docs/skills/acceptance.md covers it.
skill_page() {
  case "$1:$2" in
    Godot-Director:function-check) echo docs/skills/acceptance.md ;;
  esac
}

# The default branch of each repo, unpacked for the main-only check below.
main_tmp=$(mktemp -d 2>/dev/null) || main_tmp=""
trap 'rm -rf "$main_tmp"' EXIT

# main_copy <repo> <folder>: unpacks the default branch of <repo> from its cache into <folder>.
# Fails when the cache doesn't hold it, as with a cache made before releases were followed.
main_copy() {
  local gd="$src/$1.git"
  [ -d "$gd" ] && git --git-dir="$gd" rev-parse -q --verify refs/remotes/github/main >/dev/null || return 1
  mkdir -p "$2" && git --git-dir="$gd" archive refs/remotes/github/main | tar -x -C "$2"
}

for pair in $repos; do
  repo="${pair%%:*}"; page="docs/frameworks/${pair##*:}.md"
  [ -d "$src/$repo" ] || { err "$repo not found in $src"; continue; }
  [ -f "$page" ] || { err "$page is missing"; continue; }
  missing=""; count=0
  while read -r kind name; do
    count=$((count + 1))
    if [ "$kind" = slash ]; then
      grep -qF "\`/$name" "$page" && continue
      cover=$(skill_page "$repo" "$name")
      if [ -n "$cover" ] && [ -f "$cover" ] && grep -qF "\`/$name" "$cover"; then
        echo "ok: /$name of $repo is covered by $cover"
        continue
      fi
      missing="$missing /$name"
    else
      grep -qF "$name" "$page" || missing="$missing $name"
    fi
  done < <(commands_of "$src/$repo")
  if [ -n "$missing" ]; then err "$page doesn't mention:$missing"
  else echo "ok: $page covers all $count commands and skills of $repo"; fi

  # A command that only main ships, named on a docs page: a warning, not a failure.
  if [ -n "$main_tmp" ] && main_copy "$repo" "$main_tmp/$repo"; then
    release_names=$(commands_of "$src/$repo" | cut -d' ' -f2)
    while read -r kind name; do
      printf '%s\n' "$release_names" | grep -qxF "$name" && continue
      label="$name"; [ "$kind" = slash ] && label="/$name"
      grep -rlE "\`/?$name([^a-z0-9-]|\$)" docs --include='*.md' 2>/dev/null | while IFS= read -r hit; do
        echo "warning: $hit describes $label, which the latest release of $repo doesn't ship (main does)"
      done
    done < <(commands_of "$main_tmp/$repo")
  fi
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
  # A Markdown link inside raw HTML without the markdown attribute is printed as text, and
  # the strict build can't see it. Fail on any [text](page.md) left in the built pages.
  raw=$(grep -rlE '\]\([^) ]*\.md(#[^)]*)?\)' site --include='*.html' 2>/dev/null)
  if [ -n "$raw" ]; then err "unrendered Markdown links (add the markdown attribute to the HTML block):"
    echo "$raw" | sed 's/^/  /'
  else echo "ok: no unrendered Markdown links"; fi
else
  err "mkdocs not installed (pip install -r requirements.txt)"
fi

[ "$fail" -eq 0 ] && echo "selftest passed" || echo "selftest FAILED"
exit "$fail"
