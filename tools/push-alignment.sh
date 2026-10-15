#!/usr/bin/env bash
# tools/push-alignment.sh -- Push skill page changes to the framework repos as pull requests.
#
# Detection is tools/audit.sh (run as is): it reports, per framework repo and skill, the
# procedure details that the docs/skills/*.md page does not capture. For each repo with
# differences, this script prepares one TASKS.md item that asks the repo's build agents to
# align the procedure with the skill page, and opens it as a pull request.
#
# MERGE IS HUMAN-OWNED (product/decisions.md, 2026-10-12). This script only opens pull
# requests. It never merges one, never enables auto-merge and never pushes to a default
# branch: tasks reach a framework repo through a pull request that the director merges.
#
# Default is a DRY RUN: nothing is cloned, pushed or opened; it prints, per affected repo,
# the branch, the item and the exact gh/git commands. A live run needs --open-prs. The live
# path works in a temporary clone, never in the cache, and skips a repo that already has an
# open pull request from the same branch (safe to re-run). It also skips a repo whose default
# branch has no root TASKS.md ("no root TASKS.md; merge the root queue PR first"): it adds
# items to an existing queue and never creates the file. The dry run checks the cached clone.
#
# Usage:  bash tools/push-alignment.sh              dry run (no network, no changes)
#         bash tools/push-alignment.sh --open-prs   open the pull requests
# Exit 0: nothing to push, dry run done, or pull requests opened/skipped. Exit 2: bad use or failure.

set -u
cd "$(dirname "$0")/.." || exit 1

FRAMEWORKS_DIR=".app-director/state/frameworks"
GH_OWNER="Freakling"
# Each framework repo keeps its own work queue in a root TASKS.md (product/decisions.md,
# 2026-10-13). project/TASKS.md is the template that ships to adopters and never receives these
# items. This script never creates the root file: a repo without one is skipped until its root
# queue pull request is merged.
TASKS_PATH="TASKS.md"
NO_QUEUE_MSG="skip: no root $TASKS_PATH; merge the root queue PR first"
BASE_BRANCH="main"
TMP_ROOT="${TMPDIR:-/tmp}/push-alignment-$$"
trap 'rm -rf "$TMP_ROOT"' EXIT

live=0
case "${1:-}" in
  "") ;;
  --open-prs) live=1 ;;
  *) echo "usage: bash tools/push-alignment.sh [--open-prs]" >&2; exit 2 ;;
esac

proc_path() { # <repo> <skill>
  case "$1:$2" in
    Godot-Director:acceptance) echo "framework/.godot-director/procedures/function-check.md" ;;
    Godot-Director:*) echo "framework/.godot-director/procedures/$2.md" ;;
    App-Director:*) echo "framework/.app-director/procedures/$2.md" ;;
    SaaSAllTheThings:*) echo "framework/.satt/procedures/$2.md" ;;
  esac
}

# 1. Detect, with the audit. Lines look like: "<Repo> / <skill>: <message>"
mkdir -p "$TMP_ROOT"
bash tools/audit.sh > "$TMP_ROOT/audit.txt" 2>&1
grep -E '^(App-Director|Godot-Director|SaaSAllTheThings) / [a-z-]+: ' "$TMP_ROOT/audit.txt" > "$TMP_ROOT/diffs.txt" || true
if [ ! -s "$TMP_ROOT/diffs.txt" ]; then
  echo "push-alignment: no framework procedure differs from the skill pages; nothing to push"
  exit 0
fi
if [ "$live" -eq 1 ]; then
  echo "push-alignment: LIVE (--open-prs)"
else
  echo "push-alignment: DRY RUN (no clone, no branch, no pull request; add --open-prs to open them)"
fi

# next_id <tasks file>: the next T id from its "Next IDs" line, T1 when there is none.
next_id() {
  local id=""
  [ -f "$1" ] && id="$(sed -n 's/^\*\*Next IDs:\*\*[[:space:]]*\(T[0-9]*\).*/\1/p' "$1" | head -1)"
  echo "${id:-T1}"
}

# make_item <id> <repo> <skills...>: prints the TASKS.md item to stdout.
make_item() {
  local id="$1" repo="$2"; shift 2
  local touches="" s size="S" n=0 first=1
  for s in "$@"; do
    [ "$first" -eq 1 ] || touches="$touches, "; first=0
    touches="$touches$(proc_path "$repo" "$s")"; n=$((n + 1))
  done
  [ "$n" -gt 2 ] && size="M"
  echo "### $id · Align procedures with the Director-Driven Development skill pages ($*) · todo · $size · agent"
  echo "- Depends on: -"
  echo "- Touches: $touches"
  echo "- Done when: each listed procedure matches its skill page at https://freakling.github.io/Director-Driven-Development/skills/ , or the page is corrected by a pull request to Freakling/Director-Driven-Development (check) · \`bash tools/check.sh\` exits 0 (check)"
  echo "- Brief: -"
  echo "- Note: raised by tools/push-alignment.sh from the DDD audit; the procedure details the skill page does not yet capture are listed in the pull request description."
}

# add_item <tasks file> <item file> <id>: adds the item before "## Notes" and bumps Next IDs.
# The file must exist: the callers skip a repo that has no root TASKS.md.
add_item() {
  local f="$1" item="$2" id="$3" num next
  num="${id#T}"; next="T$((num + 1))"
  awk -v itemfile="$item" -v next="$next" '
    /^\*\*Next IDs:\*\*/ { sub(/T[0-9]+/, next) }
    /^## Notes/ && !done { while ((getline l < itemfile) > 0) print l; print ""; done=1 }
    { print }
    END { if (!done) { print ""; while ((getline l < itemfile) > 0) print l } }
  ' "$f" > "$f.new" && mv "$f.new" "$f"
}

for repo in App-Director Godot-Director SaaSAllTheThings; do
  grep "^$repo / " "$TMP_ROOT/diffs.txt" > "$TMP_ROOT/$repo.txt" || continue
  skills="$(sed -n "s|^$repo / \([a-z-]*\): .*|\1|p" "$TMP_ROOT/$repo.txt" | sort -u | tr '\n' ' ')"
  # shellcheck disable=SC2086
  set -- $skills
  branch="ddd-align/$(echo "$*" | tr ' ' '+')"
  slug="$GH_OWNER/$repo"
  if [ "$live" -eq 0 ] && [ ! -f "$FRAMEWORKS_DIR/$repo/$TASKS_PATH" ]; then
    # Dry run: no network, so look at the cached shallow clone of the default branch.
    echo ""
    echo "== $slug"
    echo "$NO_QUEUE_MSG (checked in the cached clone; nothing would be created)"
    continue
  fi
  id="$(next_id "$FRAMEWORKS_DIR/$repo/$TASKS_PATH")"
  make_item "$id" "$repo" "$@" > "$TMP_ROOT/$repo.item"
  title="Align procedures with the DDD skill pages: $*"
  {
    echo "The Director-Driven Development audit found procedure details that the skill pages do not capture."
    echo
    echo "Differences:"
    sed 's/^[^:]*: /- /' "$TMP_ROOT/$repo.txt"
    echo
    echo "This pull request only adds a task. Merging is left to a human."
  } > "$TMP_ROOT/$repo.body"

  echo ""
  echo "== $slug"
  echo "branch: $branch"
  echo "item for $TASKS_PATH (Next IDs bumped after $id):"
  sed 's/^/    /' "$TMP_ROOT/$repo.item"
  if [ "$live" -eq 0 ]; then
    echo "commands (not run):"
    echo "    gh pr list --repo $slug --head $branch --state open   # skip the repo when one exists"
    echo "    gh repo clone $slug <tmp-clone> -- --depth 1"
    echo "    git -C <tmp-clone> checkout -b $branch"
    echo "    (add the item to $TASKS_PATH, bump Next IDs)"
    echo "    git -C <tmp-clone> commit -am \"tasks: $title\""
    echo "    git -C <tmp-clone> push --set-upstream origin $branch"
    echo "    gh pr create --repo $slug --base $BASE_BRANCH --head $branch --title \"$title\" --body-file <body>"
    continue
  fi

  existing="$(gh pr list --repo "$slug" --head "$branch" --state open --json number --jq length 2>/dev/null)" \
    || { echo "error: could not list pull requests for $slug" >&2; exit 2; }
  if [ "${existing:-0}" -gt 0 ]; then
    echo "skip: an open pull request from $branch already exists"
    continue
  fi
  clone="$TMP_ROOT/clone-$repo"
  gh repo clone "$slug" "$clone" -- --depth 1 -q || { echo "error: clone of $slug failed" >&2; exit 2; }
  if [ ! -f "$clone/$TASKS_PATH" ]; then
    # The default branch has no root queue yet: never create it here.
    echo "$NO_QUEUE_MSG"
    continue
  fi
  id="$(next_id "$clone/$TASKS_PATH")"
  make_item "$id" "$repo" "$@" > "$TMP_ROOT/$repo.item"
  git -C "$clone" checkout -q -b "$branch" || exit 2
  add_item "$clone/$TASKS_PATH" "$TMP_ROOT/$repo.item" "$id"
  git -C "$clone" add "$TASKS_PATH"
  git -C "$clone" commit -q -m "tasks: $title" || exit 2
  git -C "$clone" push -q --set-upstream origin "$branch" || exit 2
  # Open only. Merge is human-owned: no merge and no auto-merge, ever.
  gh pr create --repo "$slug" --base "$BASE_BRANCH" --head "$branch" \
    --title "$title" --body-file "$TMP_ROOT/$repo.body" || exit 2
done
exit 0
