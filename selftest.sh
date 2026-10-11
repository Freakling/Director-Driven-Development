#!/usr/bin/env bash
# Docs site selftest. Run from the repository root: bash selftest.sh
#
#   1. No en or em dashes in the site sources.
#   2. Docs coverage: every command a framework ships is mentioned on its framework page.
#   3. The site builds in strict mode, which fails on broken internal links and anchors.
#
# FRAMEWORKS_DIR=<folder> uses existing clones of the three framework repos instead of
# cloning them (each as <folder>/<repo name>).

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
if [ -n "${FRAMEWORKS_DIR:-}" ]; then
  src="$FRAMEWORKS_DIR"
else
  src="$(mktemp -d)"; trap 'rm -rf "$src"' EXIT
  for pair in $repos; do
    repo="${pair%%:*}"
    git clone -q --depth 1 "https://github.com/Freakling/$repo.git" "$src/$repo" \
      || { err "could not clone $repo"; }
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

# 3. Build and links ------------------------------------------------------------------------
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
