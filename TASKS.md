# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T38 · B2

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

### T28 · Build push-alignment.sh: push skill page changes to framework repos · done · M · agent
- Depends on: T14
- Touches: tools/push-alignment.sh (new)
- Done when: when a skill page anchor changes, the script detects which framework procedures differ from the updated page and opens a pull request to each affected framework repo's TASKS.md with an item to align its procedure (check) · the script does not merge any PR (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T30 · A builder stops and asks when a task meets a design question · done · XS · agent
- Depends on: -
- Touches: docs/concept/design-calls.md, docs/concept/agent-flow.md
- Done when: Design calls has a "During a build" section on the blocked report, matching `next-task.md` › Report `blocked` in all three frameworks (check) · Agent development flow links to it from the build step (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T29 · Each framework repo gets its own root task queue · todo · M · agent
- Depends on: T28
- Touches: a pull request to each framework repo adding a root TASKS.md (the director merges); tools/push-alignment.sh
- Done when: Godot-Director, App-Director and SaaSAllTheThings each have an open pull request that adds a root TASKS.md in the App Director item format, separate from `project/TASKS.md` (check) · push-alignment.sh skips a repo with no root TASKS.md instead of creating one (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T36 · The /next-task page states Godot-Director's commit prompt accurately · done · XS · agent
- Depends on: -
- Touches: docs/skills/next-task.md
- Done when: the Godot-Director section says that its procedure doesn't pause for approval but its settings ask before every commit, matching the current release (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T35 · Push the shared commit model to the framework repos · todo · S · agent
- Depends on: T29
- Touches: a pull request to each framework repo adding an item (the director merges)
- Done when: Godot-Director and SaaSAllTheThings each have an open pull request adding an item to adopt the commit model in the brief (procedure step 7, run triggers including "grab tasks until you're blocked", `git commit` allowed in settings, push still asking), and App-Director one to add that trigger phrase (check)
- Brief: Scope › Planned framework changes

### T37 · Docs follow the shared commit model · todo · XS · agent
- Depends on: T35
- Touches: docs/skills/next-task.md, docs/concept/agent-flow.md
- Done when: once all three frameworks have released the shared commit model, the /next-task page describes it once for all three and drops the per-repo differences, and Agent development flow matches (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T32 · The shared research core as the anchor · done · M · agent
- Depends on: -
- Touches: product/anchors/research.md (new)
- Done when: the anchor holds the shared research procedure adapted from the director's portable research skill (`init/research/research-skill.md`) with the agreed adaptations: the researcher subagent, `/research`, R items with `Question:` and `Informs:`, the dated research note, sizing, and what each framework's domain file covers (check) · it uses "requirements", "control framework" or "security framework", never "policy" (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### T33 · Push the research assistant to the framework repos · todo · S · agent
- Depends on: T29, T32
- Touches: a pull request to each framework repo adding an item (the director merges)
- Done when: Godot-Director, App-Director and SaaSAllTheThings each have an open pull request adding an item to build the research assistant from `product/anchors/research.md`, with that framework's domain file, an `R<n>` counter on its `Next IDs` line, and the new files in its README, install and bundle scripts, skills folder and selftest (check)
- Brief: Scope › Planned framework changes

### T34 · The Research skill page · todo · S · agent
- Depends on: T33
- Touches: docs/skills/research.md (new), docs/skills/index.md, mkdocs.yml, docs/concept/design-calls.md
- Done when: once all three frameworks have released the research assistant, the page describes the shared behaviour and what is unique per repo, matching the released procedures (check) · Design calls links to it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T19 · Godot-Director: export onboarding and /export · todo · M · agent
- Depends on: T12, T14, T29
- Touches: an item in Godot-Director's task queue, pushed by the orchestrator; docs/frameworks/godot-director.md once released
- Done when: Godot-Director has an item for onboarding that asks for missing export settings (target platforms) and where exports run (local, a build container, or hosted CI such as GitHub Actions), can be skipped, and can be rerun as Q10 settles, plus an `/export` skill (check) · once released there, the Godot-Director page documents them (check)
- Brief: Scope › Planned framework changes

### T31 · Godot-Director: CI export and CD release · todo · M · agent
- Depends on: T19
- Touches: an item in Godot-Director's task queue, pushed by the orchestrator; docs/frameworks/godot-director.md and a /release skill page once released
- Done when: Godot-Director has an item for CI that runs the export on every change, and CD that releases builds to a platform's UAT branch with optional promotion to production (check) · once released there, the Godot-Director page documents them and /release gets its own skill page (check)
- Brief: Scope › Planned framework changes

## Notes
- T19 waits on T29 (root queues in the framework repos) and Q10. T31 follows T19.
- T35 waits on T29, and T37 on the releases.
- T33 waits on T29; T34 waits until all three frameworks have released the research assistant.
