#!/usr/bin/env bash
# tools/work-release.sh -- Release one framework repo: tag the merged release commit and publish the GitHub release.
#
# A framework release is proposed as a release pull request (product/decisions.md, 2026-10-15): the
# agent opens it from a clone under work/ with the version bump, the CHANGELOG heading and the
# release notes, following that repo's own CLAUDE.md, through tools/work-publish.sh. The director
# decides every release, and the merge of that pull request is the approval. This script takes the
# step after the merge: it tags the merged commit `v<version>` and publishes the GitHub release, so
# the release exists only because the director merged it.
#
# MERGE IS HUMAN-OWNED (product/decisions.md, 2026-10-12). This script never merges a pull request,
# never enables auto-merge and never pushes a branch. The one thing it pushes is the new tag, as
# `git push --no-follow-tags origin refs/tags/v<version>:refs/tags/v<version>`, which names both ends
# and sends no other tag, even with push.followTags on. There is no -f, no force-with-lease and no
# +refspec (the guard hook blocks those anyway). It never deletes or moves a tag; a tag that exists
# is a refusal.
#
# Creating and pushing a tag and publishing a release are the steps that leave this machine, so this
# is the only script the settings let through without a prompt for them: .claude/settings.json
# allows `bash tools/work-release.sh*` and no `git push` or `gh release` rule, so every other push
# and release still asks.
#
# Refused with exit 2 and a message, before anything is tagged, pushed or published:
#   - the path is not one of the three clones: work/App-Director, work/Godot-Director or
#     work/SaaSAllTheThings
#   - origin does not fetch from and push only to the GitHub repo Freakling/<repo>, in an accepted
#     form (origin_problem: git's own URLs, so insteadOf, pushInsteadOf and remote.origin.pushurl count)
#   - the clone sets remote.origin.push (git config --get-all), a push mapping: refused rather than
#     left to git's rules, since a plain push follows it and a `+` in it forces the push
#   - the pull request is not merged, or was not merged into main, or its merge commit is not on
#     origin/main
#   - VERSION at the merge commit is missing or not <major>.<minor>.<patch>
#   - a version file at the merge commit is missing, or carries another version. The files are the
#     ones each repo's CLAUDE.md lists for a release (`For a release` in CLAUDE.md, or
#     .claude/CLAUDE.md in SaaSAllTheThings), which its selftest checks too:
#         App-Director:       VERSION, .claude-plugin/plugin.json ("version"), package.json
#                             ("version"), SKILL.md and skills/app-director/SKILL.md (metadata.version
#                             and the --branch v<version> of their clone line), scripts/fetch-app-director.sh
#                             (tag=v<version>), .claude-plugin/marketplace.json ("ref": "v<version>")
#         Godot-Director:     VERSION, .claude-plugin/plugin.json, skills/godot-director/SKILL.md
#                             (metadata.version and --branch), .claude-plugin/marketplace.json ("ref")
#         SaaSAllTheThings:   VERSION, .claude-plugin/plugin.json, every skills/*/SKILL.md
#                             (metadata.version and --branch where it clones), .claude-plugin/marketplace.json ("ref")
#   - CHANGELOG.md at the merge commit has no heading for that version, or has an `## Unreleased`
#     heading above it that still holds entries
#   - the pull request description (the release notes) is empty or has no "How to install" section,
#     which each repo's CLAUDE.md requires of a release body
#   - the tag v<version> exists locally or on origin, or a GitHub release for it exists
#
# The release notes are the merged pull request's description, which the director reviewed when
# merging it, without the closing "Generated with Claude Code" line and the commit's
# Co-Authored-By trailer. The tag is annotated and points
# at the merge commit, even when main has moved on since.
#
# Usage:  bash tools/work-release.sh work/<repo> <release-pr-number>             tag and publish
#         bash tools/work-release.sh work/<repo> <release-pr-number> --dry-run   run every check,
#                                                              print the tag, the notes and the
#                                                              commands, run none of them
# The path is relative to the repository root, or absolute. Only `git fetch origin main` runs in the
# clone beforehand (it updates origin/main and nothing else); the working tree is never touched.
# Exit 0: released, or dry run done. Exit 2: refused or bad use.
# Exit 1: gh, a fetch, the tag or the push failed. Whatever failed is named, with the command to
# finish by hand; a tag that was pushed stays pushed.

set -u
cd "$(dirname "$0")/.." || exit 2

GH_OWNER="Freakling"
REPOS="App-Director Godot-Director SaaSAllTheThings"
BASE_BRANCH="main"
# Git Bash would turn `<commit>:<path>` and `refs/tags/...` arguments into Windows paths.
export MSYS2_ARG_CONV_EXCL='*'
# Fail instead of waiting for a password in a terminal nobody is watching.
export GIT_TERMINAL_PROMPT=0

usage() {
  echo "usage: bash tools/work-release.sh work/<repo> <release-pr-number> [--dry-run]   (repo: $REPOS)" >&2
  exit 2
}
refuse() {
  echo "work-release: refused: $*" >&2
  exit 2
}
fail() {
  echo "work-release: $*" >&2
  exit 1
}

# 1. Arguments: the clone, the pull request number, and --dry-run, in any order.
path=""
number=""
dry=0
for a in "$@"; do
  case "$a" in
    --dry-run) dry=1 ;;
    -*) usage ;;
    *[!0-9]*)
      [ -z "$path" ] || usage
      path="$a" ;;
    *)
      [ -z "$number" ] || usage
      number="$a" ;;
  esac
done
[ -n "$path" ] && [ -n "$number" ] || usage

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
  || refuse "$dir: $bad; accepted: https://github.com/$slug, git@github.com:$slug and ssh://git@github.com/$slug, each with or without .git; nothing was tagged, pushed or published"
# A push mapping (remote.origin.push) is refused rather than relied on, as in work-publish.sh. The tag
# push names its refspec, so git sends it to the named tag whatever a mapping says; a clone with a
# mapping is still not one this script releases from.
push_map="$(g config --get-all remote.origin.push 2>/dev/null)"
[ -z "$push_map" ] \
  || refuse "$dir sets remote.origin.push, a push mapping; remove it from git's config (git config --unset-all remote.origin.push) and run this again; nothing was tagged, pushed or published"

command -v gh >/dev/null 2>&1 \
  || fail "gh (the GitHub CLI) is not installed or not on PATH; nothing was tagged, pushed or published"

# 3. The release pull request must be merged into main.
view="$(gh pr view "$number" -R "$slug" --json state,mergeCommit,baseRefName \
  --jq '[.state, .baseRefName, (.mergeCommit.oid // "")] | join(" ")' 2>/dev/null)" \
  || fail "gh could not read pull request #$number of $slug (does it exist, and is gh signed in?); nothing was tagged, pushed or published"
set -- $view
pr_state="${1:-}"; pr_base="${2:-}"; merge="${3:-}"
[ "$pr_state" = "MERGED" ] \
  || refuse "pull request #$number of $slug is ${pr_state:-in an unknown state}, not merged; the director's merge is the approval, so merge it first"
[ "$pr_base" = "$BASE_BRANCH" ] \
  || refuse "pull request #$number was merged into '$pr_base', not $BASE_BRANCH; a release is tagged on $BASE_BRANCH"
case "$merge" in
  ""|*[!0-9a-f]*) refuse "pull request #$number has no usable merge commit ('$merge')" ;;
esac

# The merge commit has to be in the clone, and on origin/main.
g fetch -q origin "$BASE_BRANCH" \
  || fail "git fetch origin $BASE_BRANCH failed in $dir; nothing was tagged, pushed or published"
g cat-file -e "$merge^{commit}" 2>/dev/null \
  || refuse "the merge commit $merge of pull request #$number is not in $dir after a fetch"
g merge-base --is-ancestor "$merge" "origin/$BASE_BRANCH" 2>/dev/null \
  || refuse "the merge commit $merge of pull request #$number is not on origin/$BASE_BRANCH"
short="$(g rev-parse --short "$merge")"

# show <path>: the file as it is in the merge commit (nothing, and a failure, when it is missing).
show() { g cat-file blob "$merge:$1" 2>/dev/null; }

# 4. The version, and every file that carries it.
version_raw="$(show VERSION)" || refuse "VERSION is missing at the merge commit $short"
version="$(printf '%s' "$version_raw" | tr -d '\r\n')"
printf '%s\n' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' \
  || refuse "VERSION at the merge commit $short is '$version', not <major>.<minor>.<patch>"
tag="v$version"

# checked: one line per file that agrees, printed by --dry-run.
checked="    VERSION (version '$version')
"
# load <path>: the file as it is at the merge commit, with CRs removed, in $text. Refuses when missing.
load() {
  raw="$(show "$1")"
  [ -n "$raw" ] || refuse "$1 is missing at the merge commit $short; VERSION says $version"
  text="$(printf '%s\n' "$raw" | tr -d '\r')"
}
# agrees <path> <found> <expected> <what>: refuses unless the file carries the expected value.
agrees() {
  [ -n "$2" ] || refuse "the version files disagree: $1 has no $4 (VERSION says $version)"
  [ "$2" = "$3" ] || refuse "the version files disagree: $1 has $4 '$2', VERSION says $version"
  checked="$checked    $1 ($4 '$2')
"
}
# json_version: the first "version" value in $text (plugin.json, package.json).
json_version() { printf '%s\n' "$text" | sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1; }
# ref_value: the first "ref" value in $text (marketplace.json).
ref_value() { printf '%s\n' "$text" | sed -n 's/.*"ref"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1; }

# skill_check <path>: a SKILL.md carries metadata.version, and a skill that clones the framework pins
# its release with --branch v<version>.
skill_check() {
  load "$1"
  # metadata.version is the version: line inside the frontmatter (between the first two --- lines).
  skill_version="$(printf '%s\n' "$text" | awk '/^---[ \t]*$/ { n++; next } n == 1 && /^[ \t]*version:/ { sub(/^[ \t]*version:[ \t]*/, ""); print; exit }' | tr -d "\"'")"
  agrees "$1" "$skill_version" "$version" "metadata.version"
  branches="$(printf '%s\n' "$text" | sed -n 's/.*--branch[[:space:]][[:space:]]*\(v[0-9][0-9.]*\).*/\1/p')"
  clones="$(printf '%s\n' "$text" | grep -Ec 'git.*[[:space:]]clone[[:space:]]')"
  if [ "${clones:-0}" -gt 0 ] && [ -z "$branches" ]; then
    refuse "the version files disagree: $1 clones the framework without --branch v$version"
  fi
  for b in $branches; do agrees "$1" "$b" "v$version" "--branch"; done
}

# The files each repo's CLAUDE.md lists for a release (see the header).
load .claude-plugin/plugin.json
agrees .claude-plugin/plugin.json "$(json_version)" "$version" '"version"'

case "$repo" in
  App-Director)
    load package.json
    agrees package.json "$(json_version)" "$version" '"version"'
    skill_check SKILL.md
    skill_check skills/app-director/SKILL.md
    load scripts/fetch-app-director.sh
    fetch_tag="$(printf '%s\n' "$text" | sed -n 's/^tag=\(.*\)$/\1/p' | head -1)"
    agrees scripts/fetch-app-director.sh "$fetch_tag" "v$version" "tag"
    load .claude-plugin/marketplace.json
    agrees .claude-plugin/marketplace.json "$(ref_value)" "v$version" '"ref"'
    ;;
  Godot-Director)
    skill_check skills/godot-director/SKILL.md
    load .claude-plugin/marketplace.json
    agrees .claude-plugin/marketplace.json "$(ref_value)" "v$version" '"ref"'
    ;;
  SaaSAllTheThings)
    skills="$(g ls-tree -r --name-only "$merge" -- skills 2>/dev/null | grep -E '^skills/[^/]+/SKILL\.md$')"
    [ -n "$skills" ] || refuse "the merge commit $short has no skills/*/SKILL.md; VERSION says $version"
    count=0
    while IFS= read -r skill; do
      [ -n "$skill" ] || continue
      count=$((count + 1))
      skill_check "$skill"
    done <<EOF
$skills
EOF
    load .claude-plugin/marketplace.json
    agrees .claude-plugin/marketplace.json "$(ref_value)" "v$version" '"ref"'
    ;;
esac

# 5. CHANGELOG.md: a heading for the version, and no Unreleased entries above it.
changelog_raw="$(show CHANGELOG.md)" || refuse "CHANGELOG.md is missing at the merge commit $short"
changelog="$(printf '%s\n' "$changelog_raw" | tr -d '\r')"
result="$(printf '%s\n' "$changelog" | awk -v ver="$version" '
  /^##[ \t]/ {
    h = $0; sub(/^##[ \t]+/, "", h); sub(/^\[/, "", h); sub(/^v/, "", h)
    in_unreleased = 0
    if (tolower(substr(h, 1, 10)) == "unreleased") { if (!found) { unreleased = 1; in_unreleased = 1 } ; next }
    n = length(ver)
    if (!found && substr(h, 1, n) == ver && (length(h) == n || index(" ([]", substr(h, n + 1, 1)) > 0)) found = 1
    next
  }
  in_unreleased && /[^ \t]/ { entries++ }
  END { printf "%d %d\n", found + 0, entries + 0 }')"
set -- $result
have_heading="${1:-0}"; unreleased_entries="${2:-0}"
[ "$have_heading" -eq 1 ] \
  || refuse "CHANGELOG.md at the merge commit $short has no '## $version' heading"
[ "$unreleased_entries" -eq 0 ] \
  || refuse "CHANGELOG.md at the merge commit $short still has $unreleased_entries line(s) under '## Unreleased', above '## $version'; move them under the release heading"

# 6. The release notes: the pull request description, without the closing attribution line and
# commit trailers.
body="$(gh pr view "$number" -R "$slug" --json body --jq .body 2>/dev/null)" \
  || fail "gh could not read the description of pull request #$number of $slug; nothing was tagged, pushed or published"
notes="$(mktemp "${TMPDIR:-/tmp}/work-release.XXXXXX")" || exit 1
keep=0
cleanup() { if [ "$keep" -eq 0 ]; then rm -f "$notes"; fi; }
trap cleanup EXIT
printf '%s\n' "$body" | tr -d '\r' | awk '
  { lines[NR] = $0 }
  END {
    n = NR
    while (n > 0 && lines[n] !~ /[^ \t]/) n--
    if (n > 0 && lines[n] ~ /Generated with.*Claude Code/) { n--; while (n > 0 && lines[n] !~ /[^ \t]/) n-- }
    # The release commit ends with commit trailers (Co-Authored-By), which belong to the commit, not the notes.
    while (n > 0 && lines[n] ~ /^Co-Authored-By: /) { n--; while (n > 0 && lines[n] !~ /[^ \t]/) n-- }
    for (i = 1; i <= n; i++) print lines[i]
  }' > "$notes"
[ -s "$notes" ] || refuse "pull request #$number has no description; the release notes come from it"
grep -Eiq '^[[:space:]]*(#+[[:space:]]*)?[*_]*how to install' "$notes" \
  || refuse "the description of pull request #$number has no 'How to install' section, which $repo's CLAUDE.md requires of a release body"

# 7. The tag and the release must not exist yet.
if g rev-parse -q --verify "refs/tags/$tag" >/dev/null 2>&1; then
  refuse "the tag $tag already exists in $dir; a tag is never moved or deleted"
fi
remote_tag="$(g ls-remote --tags origin "refs/tags/$tag")" \
  || fail "git ls-remote failed in $dir; nothing was tagged, pushed or published"
[ -z "$remote_tag" ] || refuse "the tag $tag already exists on origin; a tag is never moved or deleted"
releases="$(gh release list --repo "$slug" --limit 1000 --json tagName --jq '.[].tagName' 2>/dev/null)" \
  || fail "gh could not list the releases of $slug; nothing was tagged, pushed or published"
if printf '%s\n' "$releases" | grep -Fxq "$tag"; then
  refuse "a GitHub release for $tag already exists in $slug"
fi

# 8. Dry run: print what would happen.
if [ "$dry" -eq 1 ]; then
  echo "work-release: DRY RUN for $slug, release pull request #$number merged as $short; nothing is tagged, pushed or published"
  echo "version: $version (the version files checked at $short, all agree):"
printf '%s' "$checked"
  echo "tag: $tag (annotated) on $merge"
  echo "notes (the description of pull request #$number):"
  sed 's/^/    /' "$notes"
  echo "commands (not run):"
  echo "    git -C $dir tag -a $tag -m \"Release $tag\" $merge"
  echo "    git -C $dir push --no-follow-tags origin refs/tags/$tag:refs/tags/$tag"
  echo "    gh release create $tag --repo $slug --title $tag --notes-file <notes> --verify-tag"
  exit 0
fi

# 9. Tag, push only the tag, publish. Merge is human-owned: no merge and no branch push, ever.
echo "work-release: tagging $tag on $short of $slug (pull request #$number)"
g tag -a "$tag" -m "Release $tag" "$merge" \
  || fail "could not create the tag $tag in $dir (is git user.name and user.email set?); nothing was pushed or published"
g push --no-follow-tags origin "refs/tags/$tag:refs/tags/$tag" \
  || fail "pushing the tag failed; the tag $tag exists in $dir only. Push it with: git -C $dir push --no-follow-tags origin refs/tags/$tag:refs/tags/$tag"
keep=1
# Path translation is off (MSYS2_ARG_CONV_EXCL above), so hand a Windows gh a Windows path.
notes_arg="$notes"
if command -v cygpath >/dev/null 2>&1; then notes_arg="$(cygpath -w "$notes")"; fi
out="$(gh release create "$tag" --repo "$slug" --title "$tag" --notes-file "$notes_arg" --verify-tag)" \
  || fail "the tag $tag is pushed, but the release was not published. Publish it with: gh release create $tag --repo $slug --title $tag --notes-file \"$notes_arg\" --verify-tag"
keep=0
echo "release: $(printf '%s\n' "$out" | tail -1)"
exit 0
