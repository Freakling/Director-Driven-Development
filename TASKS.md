# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T6 · B1

## Milestones
| Milestone | Status |
|---|---|
| Foundation: site builds, selftest and check passing, CI running | ✅ |
| Live: the site is published on GitHub Pages | 🟨 in progress |
| Acceptance: all core flows verified on the live site | ⬜ |
| Polish: identity, licence and offline-safe check | ⬜ |

✅ done · 🟨 in progress · ⬜ not started

## Queue

### T2 · Turn on GitHub Pages and re-run the deploy · todo · - · human
- Depends on: -
- Touches: repository Settings › Pages
- Done when: Settings › Pages › Source is "GitHub Actions", the latest Docs run's deploy job succeeds, and https://freakling.github.io/Director-Driven-Development/ loads (demo)
- Brief: -
- Note: the agent can do this with `gh api` once `gh auth status` shows a login in the session's environment.

### T3 · The check runs without network after one online run · todo · S · agent
- Depends on: -
- Touches: selftest.sh, tools/check.local.sh
- Done when: the selftest reuses framework clones kept under `.app-director/state/` and refreshes them when online (check) · `bash tools/check.sh` passes with the network off after one online run (check)
- Brief: -

### T4 · Logo and favicon in the graphical profile · todo · S · agent
- Depends on: -
- Touches: docs/assets/images/logo.svg (new), docs/assets/images/favicon.svg (new), mkdocs.yml
- Done when: the header and the browser tab show a DDD mark in the amber accent on the dark background instead of the Material defaults (demo) · `bash tools/check.sh` passes (check)
- Brief: Pitch

### T5 · Licence for the site's content · todo · XS · agent
- Depends on: -
- Touches: LICENSE (new), README.md, mkdocs.yml
- Done when: the licence chosen in Q1 is in LICENSE and named in the README and the site footer (check)
- Brief: Open Questions

### T1 · The check passes on a clean clone · done · S · agent
- Depends on: -
- Touches: tools/check.cfg, tools/check.local.sh (new)
- Done when: `bash tools/check.sh` exits 0 (check)
- Brief: -

## Notes
- T5 waits on Q1. T2 needs the director's GitHub login.
- The selftest clones the three framework repos on every run, so the check needs network until T3 is done.
