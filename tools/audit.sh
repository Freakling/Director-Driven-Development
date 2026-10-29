#!/usr/bin/env bash
# tools/audit.sh -- Compare framework skill files against docs/skills/*.md pages.
#
# For each common skill in the three framework repos, checks whether the procedure
# file contains details not captured in the skill page (either the shared section
# or the "Unique per repo" section for that framework). Flags differences rather
# than silencing them.
#
# Compares each framework's pinned release (frameworks.lock): the copy that selftest.sh keeps in
# the cache (.app-director/state/frameworks, or FRAMEWORKS_CACHE). Reads the cache only, no network
# access. A cache that isn't at its pin is refused, so audit never compares against main or a
# release the docs don't describe yet; run bash selftest.sh while online to move the cache to the pins.

# Usage:  bash tools/audit.sh
# Exit 0: no undocumented differences found
# Exit 1: differences found (informational; not a blocker)
# Exit 2: the cache isn't at each framework's pinned release, or no temp folder could be made, so nothing was compared

set -u
cd "$(dirname "$0")/.." || exit 1

FRAMEWORKS_DIR="${FRAMEWORKS_CACHE:-.app-director/state/frameworks}"
SKILLS_DIR="docs/skills"
differences=0
TMPDIR_AUDIT="$(mktemp -d "${TMPDIR:-/tmp}/audit.XXXXXX")" || { echo "audit: could not make a temp folder in ${TMPDIR:-/tmp}; nothing compared" >&2; exit 2; }
cleanup() { rm -rf "$TMPDIR_AUDIT"; }
trap cleanup EXIT

# pin_of <repo>: the tag frameworks.lock pins <repo> to.
pin_of() { grep -v '^[[:space:]]*#' frameworks.lock 2>/dev/null | awk -v r="$1" '$1 == r { print $2; exit }'; }

# Each cached copy must be at its pinned release tag.
releases=""
for repo in App-Director Godot-Director SaaSAllTheThings; do
  gd="$FRAMEWORKS_DIR/$repo.git"
  pin=$(pin_of "$repo")
  if [ -z "$pin" ]; then
    echo "audit: frameworks.lock has no pin for $repo"
    exit 2
  fi
  if [ ! -d "$gd" ]; then
    echo "audit: no cached copy of $repo in $FRAMEWORKS_DIR; run bash selftest.sh while online"
    exit 2
  fi
  if ! git --git-dir="$gd" tag --points-at HEAD 2>/dev/null | grep -qxF "$pin"; then
    echo "audit: $repo's cached copy is not at its pin $pin"
    echo "       run bash selftest.sh while online to move the cache to the pinned releases"
    exit 2
  fi
  releases="${releases}${releases:+, }$repo $pin"
done
echo "audit: comparing against the pinned releases (frameworks.lock): $releases"
echo ""

# report <repo> <skill> <message>
report() {
  printf '%s / %s: %s\n' "$1" "$2" "$3"
  differences=1
}

# build_docs_text <docs_page> <repo_heading> <outfile>
# Writes the relevant docs text (shared + unique for repo) to outfile.
build_docs_text() {
  local page="$1" heading="$2" outfile="$3"
  # Shared section (everything before "## Unique per repo")
  awk '/^## Unique per repo/{exit} {print}' "$page" > "$outfile"
  # Unique section for this repo heading
  awk -v h="$heading" '
    /^## Unique per repo/ { in_unique=1; next }
    in_unique && /^### / { in_repo = ($0 ~ h) ? 1 : 0; next }
    in_unique && in_repo { print }
  ' "$page" >> "$outfile"
}

# check_proc <repo> <skill> <docs_page> <proc_file> <repo_heading>
check_proc() {
  local repo="$1" skill="$2" docs_page="$3" proc_file="$4" repo_heading="$5"

  if [ ! -f "$proc_file" ]; then
    report "$repo" "$skill" "procedure file missing: $proc_file"
    return
  fi
  if [ ! -f "$docs_page" ]; then
    report "$repo" "$skill" "docs page missing: $docs_page"
    return
  fi

  # Build the relevant docs text into a temp file for fast grep.
  local docs_tmp="$TMPDIR_AUDIT/${repo}-${skill}-docs.txt"
  build_docs_text "$docs_page" "$repo_heading" "$docs_tmp"

  # Read the procedure file line by line.
  while IFS= read -r line; do
    # Only examine bullet point lines.
    trimmed="${line#"${line%%[! ]*}"}"
    case "$trimmed" in "- "*) ;; *) continue ;; esac

    # Extract backtick-quoted terms from the line into a temp file.
    terms_tmp="$TMPDIR_AUDIT/terms-$$.txt"
    printf '%s' "$line" | grep -oE '`[^`]+`' | tr -d '`' > "$terms_tmp"
    [ -s "$terms_tmp" ] || continue

    # For each term that looks distinctive, check if it appears in the docs text.
    flagged=0
    while IFS= read -r term; do
      [ -z "$term" ] && continue
      # Only check terms that look like file paths, flags, or dotfiles.
      case "$term" in
        *"/"*|"--"*|"."*|*".md"|*".sh"|*".yml"|*".cfg"|*".gd"|*".tres"|*".json")
          : ;;  # distinctive -- check it
        *)
          continue ;;  # generic word -- skip
      esac
      # Check if the term (or its basename) appears in the docs.
      if grep -qF "$term" "$docs_tmp" 2>/dev/null; then
        continue  # found -- OK
      fi
      base="${term##*/}"
      if [ -n "$base" ] && [ "$base" != "$term" ] && grep -qF "$base" "$docs_tmp" 2>/dev/null; then
        continue  # basename found -- OK
      fi
      # Not found: flag this bullet.
      flagged=1
      break
    done < "$terms_tmp"
    rm -f "$terms_tmp"

    if [ "$flagged" -eq 1 ]; then
      report "$repo" "$skill" "has detail not on skill page: $trimmed"
    fi
  done < "$proc_file"
}

# skill_file <repo_dir> <skill>
skill_file() {
  local repo_dir="$1" skill="$2"
  case "$repo_dir" in
    *"App-Director"*)
      printf '%s/framework/.app-director/procedures/%s.md' "$repo_dir" "$skill" ;;
    *"Godot-Director"*)
      if [ "$skill" = "acceptance" ]; then
        printf '%s/framework/.godot-director/procedures/function-check.md' "$repo_dir"
      else
        printf '%s/framework/.godot-director/procedures/%s.md' "$repo_dir" "$skill"
      fi ;;
    *"SaaSAllTheThings"*)
      printf '%s/framework/.satt/procedures/%s.md' "$repo_dir" "$skill" ;;
  esac
}

# repo_heading <repo>
repo_heading() {
  case "$1" in
    "App-Director") printf 'App-Director' ;;
    "Godot-Director") printf 'Godot-Director' ;;
    "SaaSAllTheThings") printf 'SaaSAllTheThings' ;;
  esac
}

echo "audit: checking six common skills plus acceptance/function-check"
echo ""

for skill_entry in \
    "next-task:next-task.md" \
    "design:design.md" \
    "align:align.md" \
    "drift-reset:drift-reset.md" \
    "prune:prune.md" \
    "refresh-model-sizing:refresh-model-sizing.md" \
    "acceptance:acceptance.md"
do
  skill="${skill_entry%%:*}"
  docs_file="${skill_entry##*:}"
  docs_page="$SKILLS_DIR/$docs_file"

  for repo in App-Director Godot-Director SaaSAllTheThings; do
    repo_dir="$FRAMEWORKS_DIR/$repo"
    proc_file="$(skill_file "$repo_dir" "$skill")"
    heading="$(repo_heading "$repo")"
    check_proc "$repo" "$skill" "$docs_page" "$proc_file" "$heading"
  done
done

echo ""
if [ "$differences" -eq 0 ]; then
  echo "audit: PASS -- no undocumented differences found"
  exit 0
else
  echo "audit: differences found (see above) -- review whether the skill pages need updating"
  exit 1
fi
