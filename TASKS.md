# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T29 · B1

## Milestones
| Milestone | Status |
|---|---|
| Foundation: site builds, selftest and check passing, CI running | ✅ |
| Live: the site is published on GitHub Pages | ✅ |
| Acceptance: all core flows verified on the live site | ⬜ |
| Concepts: one page per core concept | ✅ |
| Skills: one page per common skill | ✅ |
| Polish: identity, licence and offline-safe check | ✅ |
| Orchestrator: anchors, tasks pushed to the framework repos, audit (blocked by the director, T12) | ⬜ |

✅ done · 🟨 in progress · ⬜ not started

## Queue

### T14 · Push alignment tasks to the framework repos · done · M · agent
- Depends on: T12, T13
- Touches: tools/push-alignment.sh (new), AGENTS.md, TASKS.md
- Done when: a difference found by the audit becomes an item in TASKS.md for updating the relevant skill page (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T23 · Align /next-task skill page with framework procedures · done · S · agent
- Depends on: T14
- Touches: docs/skills/next-task.md
- Done when: the page covers the "other tools" fallback, mid-build design decision recording, the commit-behaviour difference between Godot-Director (immediate commit, no pause) and App-Director and SaaSAllTheThings (pause for approval), and the post-commit /clear note, and `bash tools/audit.sh` reports no differences for next-task (check)
- Brief: Skills

### T24 · Align /design skill page with framework procedures · done · S · agent
- Depends on: T14
- Touches: docs/skills/design.md
- Done when: the page covers the commit format (`docs: <summary>` with decision body, design sessions never edit code) and the post-commit /clear prompt, and `bash tools/audit.sh` reports no differences for design (check)
- Brief: Skills

### T25 · Align /align skill page with framework procedures · done · S · agent
- Depends on: T14
- Touches: docs/skills/align.md
- Done when: the page covers the framework file checks (AGENTS.md pointer, CLAUDE.md import, task format file, `bash tools/check.sh` pass, .gitignore/.gitattributes from install.sh), and `bash tools/audit.sh` reports no differences for align (check)
- Brief: Skills

### T26 · Align /drift-reset skill page with framework procedures · done · S · agent
- Depends on: T14
- Touches: docs/skills/drift-reset.md
- Done when: the page covers the missing details per repo (App-Director: destructive-commands ban and contradictory definition; Godot-Director: reset folder path, human-owned areas, git commit format; SaaSAllTheThings: tenancy and identity as security finding, as-built.md format, ADR compliance gate, security findings priority, split L+ items, /clear before rebuild), and `bash tools/audit.sh` reports no differences for drift-reset (check)
- Brief: Skills

### T27 · Align /acceptance skill page with framework procedures · done · S · agent
- Depends on: T14
- Touches: docs/skills/acceptance.md
- Done when: the page covers the design-question escalation path (when the rule itself should change, offer options or add an Open Question), and `bash tools/audit.sh` reports no differences for acceptance (check)
- Brief: Skills

### T28 · Build push-alignment.sh: push skill page changes to framework repos · todo · M · agent
- Depends on: T14
- Touches: tools/push-alignment.sh (new)
- Done when: when a skill page anchor changes, the script detects which framework procedures differ from the updated page and opens a pull request to each affected framework repo's TASKS.md with an item to align its procedure (check) · the script does not merge any PR (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T19 · Godot-Director: build and release skills · todo · M · agent
- Depends on: T12, T14
- Touches: an item in Godot-Director's task queue, pushed by the orchestrator; docs/frameworks/godot-director.md once released
- Done when: Godot-Director has an item for a skill that exports binaries per platform and one that triggers the build pipelines that push builds to the platforms, as Q8 and Q9 settle (check) · once released there, the Godot-Director page documents them and /release gets its own skill page (check)
- Brief: Scope › Planned framework changes

## Notes
- T23-T27 are independent once T14 is done. T19 waits on T14, Q8 and Q9.
