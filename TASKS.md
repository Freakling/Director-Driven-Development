# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T23 · B1

## Milestones
| Milestone | Status |
|---|---|
| Foundation: site builds, selftest and check passing, CI running | ✅ |
| Live: the site is published on GitHub Pages | ✅ |
| Acceptance: all core flows verified on the live site | ⬜ |
| Concepts: one page per core concept | ⬜ |
| Skills: one page per common skill | ⬜ |
| Polish: identity, licence and offline-safe check | ⬜ |
| Orchestrator: anchors, tasks pushed to the framework repos, audit (blocked by the director, T12) | ⬜ |

✅ done · 🟨 in progress · ⬜ not started

## Queue

### T14 · Push alignment tasks to the framework repos · todo · M · agent
- Depends on: T12, T13
- Touches: tools/ (new script), AGENTS.md
- Done when: a difference found by the audit becomes an item in the target repo's TASKS.md, in that repo's item format, by the route Q7 settles (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T19 · Godot-Director: build and release skills · todo · M · agent
- Depends on: T12, T14
- Touches: an item in Godot-Director's task queue, pushed by the orchestrator; docs/frameworks/godot-director.md once released
- Done when: Godot-Director has an item for a skill that exports binaries per platform and one that triggers the build pipelines that push builds to the platforms, as Q8 and Q9 settle (check) · once released there, the Godot-Director page documents them and /release gets its own skill page (check)
- Brief: Scope › Planned framework changes

## Notes
- T14 waits on Q7; T19 waits on T14, Q8 and Q9.
