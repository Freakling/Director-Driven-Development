#!/usr/bin/env bash
# tools/work-publish.sh -- Publish a framework repo's bundle: push it and open or update its pull request.
#
# A framework repo's items are built in its clone under work/ (tools/work-clones.sh), on one
# bundle branch (ddd/bundle-YYYY-MM-DD, AGENTS.md › Project rules › Framework work), with one
# commit per item. This script takes the last step: it pushes that branch to the framework repo
# and opens the bundle's pull request the first time, or updates the open one, so the changes
# reach the repo only through a review.
#
# MERGE IS HUMAN-OWNED (product/decisions.md, 2026-10-12), AND THE PULL REQUEST IS THE GATE
# (2026-10-15, Q13). This script only pushes the bundle branch and opens its pull request, or
# leaves an open one to show the new commits. It never merges one, never enables auto-merge and
# never pushes to main or to the remote's default branch. It never force-pushes: the push is a
# plain `git push -u origin <branch>`, with no -f, no force-with-lease and no +refspec (the guard
# hook blocks those anyway). The director reviews the pull request on GitHub and merges it.
#
# Pushing is the one step that leaves this machine, so it is the only place the settings let
# a script through without a prompt: .claude/settings.json allows `bash tools/work-publish.sh*`
# and no `git push` rule, so every other push still asks.
#
# Refused with exit 2 and a message, before anything is pushed:
#   - the path is not one of the three clones: work/App-Director, work/Godot-Director or
#     work/SaaSAllTheThings (or its origin is not Freakling/<repo>)
#   - the clone is on main, on the remote's default branch, or on a detached HEAD
#   - the working tree has uncommitted changes (untracked files count)
#   - the branch has no commits ahead of origin/main
#
# The first time, the pull request is opened from the branch's first commit ahead of origin/main:
# that commit's subject line and the rest of its message become the title and body, and the body
# ends with the Claude Code attribution line. This session then runs `gh pr edit` so the title
# names every item the bundle carries and the body lists them, one line each with its source,
# until the release notes replace the body. If an open pull request already exists for the branch
# (a re-run, or more item commits pushed to the bundle), the push updates it, its URL is printed,
# and no second one is opened.
#
# Usage:  bash tools/work-publish.sh work/<repo>              push, and open or update its pull request
#         bash tools/work-publish.sh work/<repo> --dry-run    run the checks, print the push and
#                                                             gh commands, run neither
# The path is relative to the repository root, or absolute. The branch is pushed as it is
# checked out in the clone; this script does not create, switch or reset branches.
# Exit 0: pull request opened or already open, or dry run done. Exit 2: refused or bad use.
# Exit 1: the push or a gh call failed (a pushed branch stays pushed; re-run to continue).

set -u
cd "$(dirname "$0")/.." || exit 2

GH_OWNER="Freakling"
REPOS="App-Director Godot-Director SaaSAllTheThings"
BASE_BRANCH="main"
# Every pull request body ends with this line.
ATTRIBUTION="🤖 Generated with [Claude Code](https://claude.com/claude-code)"
# Fail instead of waiting for a password in a terminal nobody is watching.
export GIT_TERMINAL_PROMPT=0

usage() {
  echo "usage: bash tools/work-publish.sh work/<repo> [--dry-run]   (repo: $REPOS)" >&2
  exit 2
}
refuse() {
  echo "work-publish: refused: $*" >&2
  exit 2
}

# 1. Arguments.
path=""
dry=0
for a in "$@"; do
  case "$a" in
    --dry-run) dry=1 ;;
    -*) usage ;;
    *) [ -z "$path" ] || usage; path="$a" ;;
  esac
done
[ -n "$path" ] || usage

# 2. The path must be one of the three clones.
resolve() { (cd "$1" 2>/dev/null && pwd -P); }
target="$(resolve "$path")"
repo=""
if [ -n "$target" ]; then
  for r in $REPOS; do
    want="$(resolve "work/$r")"
    if [ -n "$want" ] && [ "$want" = "$target" ]; then repo="$r"; fi
  done
fi
[ -n "$repo" ] || refuse "'$path' is not one of the framework clones (work/App-Director, work/Godot-Director, work/SaaSAllTheThings); bash tools/work-clones.sh makes them"
dir="work/$repo"
slug="$GH_OWNER/$repo"
[ -e "$dir/.git" ] || refuse "$dir is not a git clone; run: bash tools/work-clones.sh $repo"
g() { git -C "$dir" "$@"; }

origin="$(g config --get remote.origin.url 2>/dev/null)"
case "$origin" in
  *[:/]"$slug"|*[:/]"$slug.git") ;;
  *) refuse "$dir has origin '$origin', not $slug" ;;
esac

# 3. The branch must be an item branch, with work on it and nothing left uncommitted.
branch="$(g symbolic-ref -q --short HEAD 2>/dev/null)" \
  || refuse "$dir is on a detached HEAD; check out the item's branch first"
case "$branch" in
  -*|+*) refuse "the branch name '$branch' starts with '-' or '+'" ;;
esac
default="$(g symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null)"
default="${default#origin/}"
if [ "$branch" = "$BASE_BRANCH" ] || { [ -n "$default" ] && [ "$branch" = "$default" ]; }; then
  refuse "$dir is on '$branch', the default branch; publish an item branch, never the default branch"
fi
changes="$(g status --porcelain 2>/dev/null)"
if [ -n "$changes" ]; then
  echo "$changes" | sed 's/^/  /' >&2
  refuse "$dir has uncommitted changes (listed above); commit them to the item's commit first"
fi
g rev-parse -q --verify "refs/remotes/origin/$BASE_BRANCH" >/dev/null 2>&1 \
  || refuse "$dir has no origin/$BASE_BRANCH; run: bash tools/work-clones.sh $repo"
ahead="$(g rev-list --count "origin/$BASE_BRANCH..HEAD" 2>/dev/null)"
[ "${ahead:-0}" -gt 0 ] \
  || refuse "branch '$branch' has no commits ahead of origin/$BASE_BRANCH; there is nothing to publish"

# 4. Title and body: the first commit ahead of origin/main is the bundle's first item commit.
first="$(g rev-list --reverse "origin/$BASE_BRANCH..HEAD" | head -1)"
title="$(g log -1 --format=%s "$first")"
body="$(g log -1 --format=%b "$first")"

if [ "$dry" -eq 1 ]; then
  echo "work-publish: DRY RUN for $slug (branch $branch, $ahead commit(s) ahead of origin/$BASE_BRANCH); nothing is pushed or opened"
  echo "title: $title"
  if [ -n "$body" ]; then
    echo "body:"
    echo "$body" | sed 's/^/    /'
  else
    echo "body: (empty)"
  fi
  echo "    (then: $ATTRIBUTION)"
  echo "commands (not run):"
  echo "    git -C $dir push -u origin $branch"
  echo "    gh pr list --repo $slug --head $branch --state open   # when one is open, its URL is printed and no second one is created"
  echo "    gh pr create --repo $slug --base $BASE_BRANCH --head $branch --title \"$title\" --body-file <body>"
  exit 0
fi

# 5. Push, then open the pull request unless one is already open for this branch.
command -v gh >/dev/null 2>&1 \
  || { echo "work-publish: gh (the GitHub CLI) is not installed or not on PATH; nothing was pushed" >&2; exit 1; }
echo "work-publish: pushing $branch of $slug ($ahead commit(s) ahead of origin/$BASE_BRANCH)"
g push -u origin "$branch" || { echo "work-publish: the push failed; no pull request was opened" >&2; exit 1; }

existing="$(gh pr list --repo "$slug" --head "$branch" --state open --json url --jq '.[0].url // empty' 2>/dev/null)" \
  || { echo "work-publish: pushed, but could not list pull requests for $slug; run this again once gh works" >&2; exit 1; }
if [ -n "$existing" ]; then
  echo "pull request already open: $existing"
  exit 0
fi

bodyfile="$(mktemp "${TMPDIR:-/tmp}/work-publish.XXXXXX")" || exit 1
trap 'rm -f "$bodyfile"' EXIT
{
  if [ -n "$body" ]; then printf '%s\n\n' "$body"; fi
  printf '%s\n' "$ATTRIBUTION"
} > "$bodyfile"
# Open only. Merge is human-owned: no merge and no auto-merge, ever.
out="$(gh pr create --repo "$slug" --base "$BASE_BRANCH" --head "$branch" --title "$title" --body-file "$bodyfile")" \
  || { echo "work-publish: pushed, but the pull request was not opened; run this again once gh works" >&2; exit 1; }
echo "pull request: $(printf '%s\n' "$out" | tail -1)"
exit 0
