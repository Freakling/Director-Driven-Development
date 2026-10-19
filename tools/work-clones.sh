#!/usr/bin/env bash
# tools/work-clones.sh -- Keep working clones of the three framework repos in work/.
#
# Framework items are built here, in a clone of the framework repo (product/decisions.md,
# 2026-10-15), and reach the repo as a pull request. work/ is gitignored: the clones are never
# committed to this repo. They are full clones, not shallow ones, because item branches are
# pushed from them (tools/work-publish.sh). The selftest cache in .app-director/state/frameworks
# is a different thing: release copies for checking the docs, never worked in.
#
# For each repo (App-Director, Godot-Director, SaaSAllTheThings) this clones
# https://github.com/Freakling/<repo>.git into work/<repo> when it is missing, or runs
# `git fetch origin` in an existing clone. It then says which branch the clone is on, whether
# it is clean, and how far the branch is from origin/main.
#
# An existing clone is never reset, never switched to another branch and never cleaned: a fetch
# only updates the origin/* refs, so work in progress stays as it is. A folder in work/ that
# is not a clone of the right repo is left alone and reported.
#
# Usage:  bash tools/work-clones.sh              all three repos
#         bash tools/work-clones.sh <repo>       one repo, by name (any letter case)
# Offline: a fetch that fails is reported per repo, and the run carries on with what is there.
# Exit 0: done (offline fetches included). Exit 1: a clone failed or a folder is in the way.
# Exit 2: bad use.

set -u
cd "$(dirname "$0")/.." || exit 2

WORK_DIR="work"
GH_OWNER="Freakling"
REPOS="App-Director Godot-Director SaaSAllTheThings"
# Fail fast instead of hanging when GitHub cannot be reached or asks for a password.
export GIT_TERMINAL_PROMPT=0 GIT_HTTP_LOW_SPEED_LIMIT=1000 GIT_HTTP_LOW_SPEED_TIME=20

lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

# 1. Which repos: all, or the one named.
only=""
case $# in
  0) ;;
  1)
    case "$1" in -*) echo "usage: bash tools/work-clones.sh [App-Director|Godot-Director|SaaSAllTheThings]" >&2; exit 2 ;; esac
    for r in $REPOS; do
      [ "$(lower "$r")" = "$(lower "$1")" ] && only="$r"
    done
    if [ -z "$only" ]; then
      echo "work-clones: unknown repo '$1'; use one of: $REPOS" >&2
      exit 2
    fi
    ;;
  *) echo "usage: bash tools/work-clones.sh [App-Director|Godot-Director|SaaSAllTheThings]" >&2; exit 2 ;;
esac

# report <dir>: the state of a clone, in a line of its own.
report() {
  local dir="$1" branch changes ahead behind counts line
  if branch="$(git -C "$dir" symbolic-ref -q --short HEAD 2>/dev/null)"; then
    line="branch $branch"
  else
    line="detached at $(git -C "$dir" rev-parse --short HEAD 2>/dev/null)"
  fi
  changes="$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  if [ "${changes:-0}" -eq 0 ]; then line="$line, clean"; else line="$line, $changes uncommitted change(s)"; fi
  if counts="$(git -C "$dir" rev-list --left-right --count origin/main...HEAD 2>/dev/null)"; then
    behind="${counts%%[[:space:]]*}"; ahead="${counts##*[[:space:]]}"
    line="$line, $ahead ahead and $behind behind origin/main"
  fi
  echo "  $line"
}

# sync_repo <repo>: 0 when the clone is there afterwards (fetched or not), 1 when it is not.
sync_repo() {
  local repo="$1" dir="$WORK_DIR/$1" url origin out
  url="https://github.com/$GH_OWNER/$repo.git"
  if [ -e "$dir/.git" ]; then
    origin="$(git -C "$dir" config --get remote.origin.url 2>/dev/null)"
    case "$origin" in
      *[:/]"$GH_OWNER/$repo"|*[:/]"$GH_OWNER/$repo.git") ;;
      *)
        echo "$repo: $dir has origin '$origin', not $GH_OWNER/$repo; left alone"
        return 1 ;;
    esac
    if out="$(git -C "$dir" fetch origin 2>&1)"; then
      echo "$repo: fetched origin in $dir"
    else
      echo "$repo: could not fetch (offline?); using what is in $dir"
      echo "$out" | head -1 | sed 's/^/  /'
    fi
    report "$dir"
    return 0
  fi
  if [ -e "$dir" ]; then
    echo "$repo: $dir exists but is not a git clone; left alone"
    return 1
  fi
  mkdir -p "$WORK_DIR" || return 1
  if out="$(git clone -q "$url" "$dir" 2>&1)"; then
    echo "$repo: cloned to $dir"
    report "$dir"
    return 0
  fi
  echo "$repo: clone of $url failed (offline?)"
  echo "$out" | head -1 | sed 's/^/  /'
  return 1
}

# 2. Sync each, and carry on after a failure so one repo does not hide the others.
status=0
for repo in $REPOS; do
  if [ -n "$only" ] && [ "$repo" != "$only" ]; then continue; fi
  sync_repo "$repo" || status=1
done
exit "$status"
