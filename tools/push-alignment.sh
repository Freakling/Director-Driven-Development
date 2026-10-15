#!/usr/bin/env bash
# tools/push-alignment.sh -- File the framework procedure differences as items in this repo's TASKS.md.
#
# Detection is tools/audit.sh (run as is): it reports, per framework repo and skill, the procedure
# details that the docs/skills/*.md page does not capture, against each framework's latest release.
# For each repo with differences, this script prepares one item for this repo's TASKS.md. The item
# waits here until it is built in that repo's clone under work/ (tools/work-clones.sh), and then
# reaches the framework with its change, as one pull request (product/decisions.md, 2026-10-15, Q12).
# Nothing is cloned, pushed or opened: no network, no git and no gh.
#
# A skill that already has an open (todo or in-progress) alignment item for the same repo is left
# out, so a re-run adds nothing twice; a repo whose differences are all covered is skipped. A done
# item doesn't count: a difference that the latest release still shows is filed again.
#
# Usage:  bash tools/push-alignment.sh          dry run: prints the items it would add, writes nothing
#         bash tools/push-alignment.sh --add    adds them to the end of the Queue section of TASKS.md
# PUSH_ALIGNMENT_TASKS=<file> works on that file instead of TASKS.md (for tests on a scratch copy).
# Exit 0: nothing to add, dry run done, or items added. Exit 2: bad use, the audit couldn't compare
# the releases, or TASKS.md has no Next IDs line.

set -u
cd "$(dirname "$0")/.." || exit 2

REPOS="App-Director Godot-Director SaaSAllTheThings"
TASKS_FILE="${PUSH_ALIGNMENT_TASKS:-TASKS.md}"
BRIEF="Scope › Later: orchestrator for the three frameworks"
TMP_ROOT="${TMPDIR:-/tmp}/push-alignment-$$"
trap 'rm -rf "$TMP_ROOT"' EXIT

usage() {
  echo "usage: bash tools/push-alignment.sh [--add]" >&2
  exit 2
}
add=0
if [ $# -gt 1 ]; then usage; fi
case "${1:-}" in
  "") ;;
  --add) add=1 ;;
  *) usage ;;
esac
[ -f "$TASKS_FILE" ] || { echo "push-alignment: no $TASKS_FILE" >&2; exit 2; }

# next_id <tasks file>: the T id on its "Next IDs" line, empty when there is none.
next_id() {
  sed -n 's/^\*\*Next IDs:\*\*[[:space:]]*\(T[0-9][0-9]*\).*/\1/p' "$1" | head -1
}

# open_skills <tasks file> <repo>: the skills that the open (todo or in-progress) alignment items
# for <repo> name in their titles, one per line.
open_skills() {
  grep -E "^### T[0-9]+ · Align $2 procedures with the DDD skill pages \(" "$1" \
    | grep -E ' · (todo|in-progress)( [0-9-]+)? · ' \
    | sed 's/^[^(]*(\([^)]*\)).*/\1/' | tr ',' '\n' | sed 's/^ *//; s/ *$//'
}

# difference_label <message>: the bold term that starts an audit bullet, else its first six words.
difference_label() {
  local label
  label="$(printf '%s' "$1" | sed -n 's/^[^*]*\*\*\([^*]*\)\*\*.*/\1/p')"
  [ -n "$label" ] || label="$(printf '%s' "$1" | cut -d' ' -f1-6)"
  printf '%s' "$label"
}

# add_item <tasks file> <item file> <id>: inserts the item at the end of the Queue section (before
# "## Notes", or at the end of the file) and bumps the T number on the Next IDs line past <id>.
add_item() {
  local f="$1" item="$2" id="$3" num nextid
  num="${id#T}"; nextid="T$((num + 1))"
  awk -v itemfile="$item" -v nextid="$nextid" '
    /^\*\*Next IDs:\*\*/ && !bumped { sub(/T[0-9]+/, nextid); bumped = 1 }
    /^## Notes/ && !added { if (prev != "") print ""; while ((getline l < itemfile) > 0) print l; print ""; added = 1 }
    { print; prev = $0 }
    END { if (!added) { print ""; while ((getline l < itemfile) > 0) print l } }
  ' "$f" > "$f.new" && mv "$f.new" "$f"
}

# 1. Detect, with the audit. Its lines look like: "<Repo> / <skill>: <message>"
mkdir -p "$TMP_ROOT" || exit 2
bash tools/audit.sh > "$TMP_ROOT/audit.txt" 2>&1
audit_status=$?
if [ "$audit_status" -gt 1 ]; then
  cat "$TMP_ROOT/audit.txt"
  echo "push-alignment: the audit could not compare the latest releases; nothing added" >&2
  exit 2
fi
grep '^audit: comparing' "$TMP_ROOT/audit.txt" || true
grep -E '^(App-Director|Godot-Director|SaaSAllTheThings) / [a-z-]+: ' "$TMP_ROOT/audit.txt" > "$TMP_ROOT/diffs.txt" || true
if [ ! -s "$TMP_ROOT/diffs.txt" ]; then
  echo "push-alignment: no framework procedure differs from the skill pages; nothing to add"
  exit 0
fi
if [ "$add" -eq 1 ]; then
  echo "push-alignment: ADD (--add): the items go to $TASKS_FILE"
else
  echo "push-alignment: DRY RUN: nothing is written (run with --add to write the items to $TASKS_FILE)"
fi

# 2. One item per repo, built on a copy of TASKS.md. The dry run and --add make the same items; only
#    --add writes them back, once, at the end.
work_tasks="$TMP_ROOT/TASKS.md"
cp "$TASKS_FILE" "$work_tasks" || exit 2
added=0
for repo in $REPOS; do
  grep "^$repo / " "$TMP_ROOT/diffs.txt" > "$TMP_ROOT/$repo.txt" || continue
  sed -n "s|^$repo / \([a-z-]*\): .*|\1|p" "$TMP_ROOT/$repo.txt" | sort -u > "$TMP_ROOT/$repo.skills"
  open_skills "$work_tasks" "$repo" > "$TMP_ROOT/$repo.open"
  : > "$TMP_ROOT/$repo.new"
  while IFS= read -r skill; do
    grep -Fxq "$skill" "$TMP_ROOT/$repo.open" || printf '%s\n' "$skill" >> "$TMP_ROOT/$repo.new"
  done < "$TMP_ROOT/$repo.skills"

  echo ""
  echo "== $repo"
  if [ ! -s "$TMP_ROOT/$repo.new" ]; then
    echo "skip: every difference already has an open alignment item"
    continue
  fi

  # The skills to file, and the differences the audit names for them.
  names=""; pages=""; diffs=""
  while IFS= read -r skill; do
    names="${names:+$names, }$skill"
    pages="${pages:+$pages, }docs/skills/$skill.md"
  done < "$TMP_ROOT/$repo.new"
  while IFS= read -r line; do
    rest="${line#"$repo / "}"
    skill="${rest%%: *}"
    grep -Fxq "$skill" "$TMP_ROOT/$repo.new" || continue
    msg="${rest#*: }"; msg="${msg#has detail not on skill page: }"; msg="${msg#- }"
    diffs="${diffs:+$diffs; }$skill: $(difference_label "$msg")"
  done < "$TMP_ROOT/$repo.txt"

  id="$(next_id "$work_tasks")"
  [ -n "$id" ] || { echo "push-alignment: $TASKS_FILE has no Next IDs line" >&2; exit 2; }
  printf '%s\n' \
    "### $id · Align $repo procedures with the DDD skill pages ($names) · todo · S · agent" \
    "- Depends on: T40" \
    "- Touches: work/$repo (one pull request; the director merges)" \
    "- Done when: $repo has an open pull request that aligns its procedures for $names with $pages, closing the differences the audit lists ($diffs), following AGENTS.md › Project rules for framework work (check)" \
    "- Brief: $BRIEF" > "$TMP_ROOT/$repo.item"
  add_item "$work_tasks" "$TMP_ROOT/$repo.item" "$id" || exit 2
  added=$((added + 1))

  echo "item for $TASKS_FILE:"
  sed 's/^/    /' "$TMP_ROOT/$repo.item"
done

echo ""
if [ "$added" -eq 0 ]; then
  echo "push-alignment: nothing to add; every difference already has an open alignment item"
  exit 0
fi
if [ "$add" -eq 1 ]; then
  cat "$work_tasks" > "$TASKS_FILE" || exit 2
  echo "push-alignment: added $added item(s) to $TASKS_FILE"
else
  echo "push-alignment: $added item(s) would be added; nothing written (run with --add to add them)"
fi
exit 0
