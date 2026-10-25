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
#   8. The site builds in strict mode, which fails on broken internal links and anchors.
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
  while IFS= read -r hit; do
    where=${hit%%:*}; rest=${hit#*:}; lineno=${rest%%:*}; link=${rest#*:}
    [[ $link =~ ^github\.com/Freakling/[^/]+/(tree|blob)/([^/]+)/(.*)$ ]] || continue
    ref=${BASH_REMATCH[2]}; path=${BASH_REMATCH[3]}
    if [ "$ref" != "$rel" ]; then
      err "$where:$lineno links to $repo at $ref, not its pinned release $rel: $link"
    elif git --git-dir="$gd" cat-file -e "$rel:$path" 2>/dev/null; then
      ok_links=$((ok_links + 1))
    else
      err "$where:$lineno links to $path, which $repo's pinned release $rel doesn't have"
    fi
  done <<< "$mine"
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

  # missing_part <value>: prints the first part of a "Section › Sub" value that isn't a heading of
  # the brief, and fails. A value is one or more parts; each part must be a heading (text only).
  missing_part() {
    local part
    while IFS= read -r part; do
      [ -n "$part" ] || continue
      grep -qxF -- "$part" <<< "$brief_heads" || { printf '%s' "$part"; return 1; }
    done <<< "$(awk -v s="$1" 'BEGIN { n = split(s, a, " › "); for (i = 1; i <= n; i++) print a[i] }')"
    return 0
  }

  # Brief: values in TASKS.md (the open queue; "-" means none), and the brief headings named in
  # tools/*.sh as BRIEF="..." assignments (push-alignment.sh files its items under one).
  heads_fail=0
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    lineno=${hit%%:*}; val=${hit#*:- Brief: }
    val=$(printf '%s' "$val" | sed 's/[[:space:]]*$//')
    [ "$val" = "-" ] && continue
    bad=$(missing_part "$val") || { err "TASKS.md:$lineno has Brief: \"$val\", and \"$bad\" isn't a heading in product/brief.md"; heads_fail=1; }
  done <<< "$(grep -n '^- Brief: ' TASKS.md)"
  for f in tools/*.sh; do
    [ -f "$f" ] || continue
    while IFS= read -r hit; do
      [ -n "$hit" ] || continue
      lineno=${hit%%:*}; val=${hit#*BRIEF=\"}; val=${val%%\"*}
      bad=$(missing_part "$val") || { err "$f:$lineno names brief heading \"$val\", and \"$bad\" isn't a heading in product/brief.md"; heads_fail=1; }
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
ver_fail=0
while IFS= read -r hit; do
  [ -n "$hit" ] || continue
  where=${hit%%:*}; rest=${hit#*:}; lineno=${rest%%:*}; text=${rest#*:}
  plain=$(printf '%s' "$text" \
    | sed -E 's#[^ (]*/(tree|blob)/v[0-9][^ )"]*##g; s#[^ (]*/releases/tag/v[0-9][^ )"]*##g; s#Godot[ -]Director##g')
  printf '%s' "$plain" | grep -qE '(^|[^0-9.])[0-9]+\.[0-9]+\.[0-9]+([^0-9.]|$)' || continue
  printf '%s' "$plain" | grep -qE '(^|[^A-Za-z-])(Godot|\.NET|Node|gitleaks)([^-A-Za-z]|$)' && continue
  err "$where:$lineno names a version number in prose (link a release tag instead, or drop it): $(printf '%s' "$text" | cut -c1-100)"
  ver_fail=1
done <<< "$(grep -rnE --include='*.md' '[0-9]+\.[0-9]+\.[0-9]+' docs 2>/dev/null | grep -v '^docs/assets/' || true)"
[ "$ver_fail" -eq 0 ] && echo "ok: no docs page names a version number in prose"

# 8. Build and links ------------------------------------------------------------------------
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
