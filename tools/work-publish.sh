#!/usr/bin/env bash
# tools/work-publish.sh -- Publish a framework repo's bundle: push it and open or update its pull request.
#
# A framework repo's items are built in its clone under work/ (tools/work-clones.sh), on one
# bundle branch (ddd/bundle-YYYY-MM-DD, AGENTS.md › Project rules › Framework work), with one
# commit per item. This script takes the last step: it pushes that branch to the framework repo
# and opens the bundle's pull request the first time, or updates the open one, so the changes
# reach the repo only through a review. Before it pushes, it scans the commits the push would send
# for credentials with gitleaks, the same rules the check applies to the working tree, under
# origin/main's allowlist: the clone's own .gitleaks.toml and .gitleaksignore are never read.
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
#     work/SaaSAllTheThings
#   - origin does not fetch from and push only to the GitHub repo Freakling/<repo>, in an accepted
#     form (origin_problem: git's own URLs, so insteadOf, pushInsteadOf and remote.origin.pushurl count)
#   - the clone is on main, on the remote's default branch, or on a detached HEAD
#   - the working tree has uncommitted changes (untracked files count)
#   - the branch has no commits ahead of origin/main
#   - gitleaks finds a credential in the commits ahead of origin/main (the file names are printed,
#     the values stay redacted)
#   - gitleaks is not installed, or it can't scan those commits
#
# Not refused: a change to .gitleaks.toml or .gitleaksignore in those commits. The scan uses
# origin/main's allowlist, never the push's, and the push prints that change for the director to
# review in the pull request.
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
#         bash tools/work-publish.sh work/<repo> --dry-run    run the checks (the secrets scan too),
#                                                             print the push and gh commands, run neither
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

# origin_problem <clone> <owner/repo>: prints the first URL of origin that is not the GitHub repo, and
# returns 1. Prints nothing and returns 0 when origin fetches from the repo and pushes to exactly one
# URL, which is the repo too. The URLs are git's own (insteadOf, pushInsteadOf and remote.origin.pushurl
# are applied), so a rewrite or a push elsewhere shows up here. Accepted: the https://github.com/,
# git@github.com: and ssh://git@github.com/ forms of the repo, each with or without .git.
origin_problem() {
  local clone="$1" want="$2" kind url pushes=0
  while IFS=' ' read -r kind url; do
    case "$url" in
      "https://github.com/$want" | "https://github.com/$want.git" \
      | "git@github.com:$want" | "git@github.com:$want.git" \
      | "ssh://git@github.com/$want" | "ssh://git@github.com/$want.git") ;;
      *) echo "origin $kind URL '$url' is not the GitHub repo $want"; return 1 ;;
    esac
    if [ "$kind" = push ]; then
      pushes=$((pushes + 1))
      [ "$pushes" -eq 1 ] || { echo "origin has a second push URL, '$url'"; return 1; }
    fi
  done <<EOF
fetch $(git -C "$clone" remote get-url origin 2>/dev/null)
$(git -C "$clone" remote get-url --push --all origin 2>/dev/null | sed 's/^/push /')
EOF
  [ "$pushes" -eq 1 ] || { echo "origin has no push URL"; return 1; }
  return 0
}

bad="$(origin_problem "$dir" "$slug")" \
  || refuse "$dir: $bad; accepted: https://github.com/$slug, git@github.com:$slug and ssh://git@github.com/$slug, each with or without .git; nothing was pushed"

# 3. The branch must be an item branch, with work on it and nothing left uncommitted.
branch="$(g symbolic-ref -q --short HEAD 2>/dev/null)" \
  || refuse "$dir is on a detached HEAD; check out the repo's bundle branch first"
case "$branch" in
  -*|+*) refuse "the branch name '$branch' starts with '-' or '+'" ;;
esac
default="$(g symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null)"
default="${default#origin/}"
if [ "$branch" = "$BASE_BRANCH" ] || { [ -n "$default" ] && [ "$branch" = "$default" ]; }; then
  refuse "$dir is on '$branch', the default branch; publish the repo's bundle branch, never the default branch"
fi
changes="$(g status --porcelain 2>/dev/null)"
if [ -n "$changes" ]; then
  echo "$changes" | sed 's/^/  /' >&2
  refuse "$dir has uncommitted changes (listed above); commit them on the bundle branch first"
fi
g rev-parse -q --verify "refs/remotes/origin/$BASE_BRANCH" >/dev/null 2>&1 \
  || refuse "$dir has no origin/$BASE_BRANCH; run: bash tools/work-clones.sh $repo"
ahead="$(g rev-list --count "origin/$BASE_BRANCH..HEAD" 2>/dev/null)"
[ "${ahead:-0}" -gt 0 ] \
  || refuse "branch '$branch' has no commits ahead of origin/$BASE_BRANCH; there is nothing to publish"

# 4. Secrets scan: no credential in the commits the push would send. The check scans the working tree
# and the pre-commit hook scans staged changes; this scans the commits themselves, so a commit made
# outside the hook, or a clone's item commit, is caught before it reaches a public repository
# (OWASP Authentication Failures). The allowlist is origin/main's, never the push's: gitleaks would
# otherwise read the clone's own .gitleaks.toml and .gitleaksignore, so a commit could allowlist its
# own credential. Both files are read from origin/main into a private temp folder and passed on the
# command line every time; where origin/main has none, the scan gets the default rules only, and no
# ignores. A `gitleaks:allow` comment in the pushed commits doesn't count either
# (--ignore-gitleaks-allow). The source is the clone's .git folder, not its working tree, because
# gitleaks reads a .gitleaksignore from its source folder even when --gitleaks-ignore-path names
# another file. The report goes under the state folder by a relative path, holds redacted values
# only, and is removed after the scan; its File entries name the files.
command -v gitleaks >/dev/null 2>&1 \
  || refuse "gitleaks is not installed or not on PATH, so the commits of $dir can't be scanned for credentials; nothing was pushed"
scratch="$(mktemp -d "${TMPDIR:-/tmp}/work-publish-scan.XXXXXX")" \
  || refuse "could not make a private temp folder for the scan; nothing was pushed"
trap 'rm -rf "$scratch"' EXIT
# origin_file <path> <dest>: writes origin/main's <path> to <dest> and returns 0, or returns 1 when
# origin/main has no such file. It lists the blob with ls-tree, not a rev:path argument, because Git
# Bash rewrites that argument into a Windows path list. A failed listing or read refuses, so the scan
# never falls back to defaults on an error.
origin_file() {
  local listed sha
  listed="$(g ls-tree "origin/$BASE_BRANCH" -- "$1")" \
    || refuse "could not list $1 on origin/$BASE_BRANCH; nothing was pushed"
  [ -n "$listed" ] || return 1
  sha="$(printf '%s\n' "$listed" | awk '{ print $3 }')"
  g cat-file blob "$sha" > "$2" \
    || refuse "could not read $1 on origin/$BASE_BRANCH; nothing was pushed"
}
scan_cfg="$scratch/gitleaks.toml"
scan_ignore="$scratch/gitleaksignore"
origin_file .gitleaks.toml "$scan_cfg" || printf '[extend]\nuseDefault = true\n' > "$scan_cfg"
origin_file .gitleaksignore "$scan_ignore" || : > "$scan_ignore"
mkdir -p .app-director/state || refuse "could not create .app-director/state for the scan report; nothing was pushed"
scan_report=".app-director/state/work-publish-scan.json"
rm -f "$scan_report"
scan_out="$(gitleaks git --redact --ignore-gitleaks-allow --config="$scan_cfg" --gitleaks-ignore-path="$scan_ignore" --report-path="$scan_report" --log-opts="origin/$BASE_BRANCH..HEAD" "$dir/.git" 2>&1)"
scan_rc=$?
if [ "$scan_rc" -ne 0 ]; then
  # A report with a File entry is a finding; a failure with none means the scan couldn't run.
  files=""
  if grep -qs '"File"' "$scan_report"; then
    files="$(sed -n 's/.*"File"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' "$scan_report" | sed 's/\\\\/\\/g' | awk '!seen[$0]++')"
  fi
  rm -f "$scan_report"
  if [ -n "$files" ]; then
    echo "work-publish: refused: gitleaks found a credential in the commits ahead of origin/$BASE_BRANCH on $branch; nothing was pushed" >&2
    printf '%s\n' "$files" | sed 's/^/  found in: /' >&2
    echo "  Take it out of the commit that adds it, then run this again. A credential that was ever committed is compromised: the director rotates it." >&2
    exit 2
  fi
  last="$(printf '%s\n' "$scan_out" | sed 's/\x1b\[[0-9;]*m//g' | tr -d '\r' | grep -v '^[[:space:]]*$' | tail -n 1)"
  [ -n "$last" ] && echo "  gitleaks: $last" >&2
  refuse "gitleaks couldn't scan the commits ahead of origin/$BASE_BRANCH on $branch; nothing was pushed"
fi
rm -f "$scan_report"
if [ -n "$(g diff --name-only "origin/$BASE_BRANCH...HEAD" -- .gitleaks.toml .gitleaksignore)" ]; then
  echo "work-publish: the scan used origin/$BASE_BRANCH's allowlist; this push changes .gitleaks.toml or .gitleaksignore, which the director reviews in the pull request"
fi

# 5. Title and body: the first commit ahead of origin/main is the bundle's first item commit.
first="$(g rev-list --reverse "origin/$BASE_BRANCH..HEAD" | head -1)"
title="$(g log -1 --format=%s "$first")"
body="$(g log -1 --format=%b "$first")"

if [ "$dry" -eq 1 ]; then
  echo "work-publish: DRY RUN for $slug (branch $branch, $ahead commit(s) ahead of origin/$BASE_BRANCH); nothing is pushed or opened"
  echo "checked: the branch is not the default branch; the working tree is clean; the branch is ahead of origin/$BASE_BRANCH; gitleaks finds no credential in those commits"
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

# 6. Push, then open the pull request unless one is already open for this branch.
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
trap 'rm -f "$bodyfile"; rm -rf "$scratch"' EXIT
{
  if [ -n "$body" ]; then printf '%s\n\n' "$body"; fi
  printf '%s\n' "$ATTRIBUTION"
} > "$bodyfile"
# Open only. Merge is human-owned: no merge and no auto-merge, ever.
out="$(gh pr create --repo "$slug" --base "$BASE_BRANCH" --head "$branch" --title "$title" --body-file "$bodyfile")" \
  || { echo "work-publish: pushed, but the pull request was not opened; run this again once gh works" >&2; exit 1; }
echo "pull request: $(printf '%s\n' "$out" | tail -1)"
exit 0
