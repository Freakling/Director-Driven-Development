# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T22 · B1

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

### T2 · Turn on GitHub Pages and re-run the deploy · done · - · human
- Depends on: -
- Touches: repository Settings › Pages
- Done when: Settings › Pages › Source is "GitHub Actions", the latest Docs run's deploy job succeeds, and https://freakling.github.io/Director-Driven-Development/ loads (demo)
- Brief: -

### T3 · The check runs without network after one online run · done · S · agent
- Depends on: -
- Touches: selftest.sh, .gitleaks.toml
- Done when: the selftest reuses framework clones kept under `.app-director/state/` and refreshes them when online (check) · `bash tools/check.sh` passes with the network off after one online run (check)
- Brief: -

### T4 · Logo and favicon in the graphical profile · done · S · agent
- Depends on: -
- Touches: docs/assets/images/logo.svg (new), docs/assets/images/favicon.svg (new), mkdocs.yml
- Done when: the header and the browser tab show a DDD mark in the amber accent on the dark background instead of the Material defaults (demo) · `bash tools/check.sh` passes (check)
- Brief: Pitch

### T5 · MIT licence, as in the framework repos · done · XS · agent
- Depends on: -
- Touches: LICENSE (new), README.md, mkdocs.yml
- Done when: LICENSE holds the MIT licence with "© 2026 Vikingur Saemundsson", the same text as the framework repos (check) · the README and the site footer name MIT (check)
- Brief: Scope › Licence

### T15 · Concepts section, overview and the two cost pages · done · M · agent
- Depends on: -
- Touches: mkdocs.yml, docs/concept/index.md, docs/token-cost.md, docs/concept/cost-built-in.md (new), docs/concept/cost-tuning.md (new), docs/index.md, docs/concept/sizing.md, docs/concept/reviews.md
- Done when: the navigation has a Concepts section that opens on a short overview linking every concept page (demo) · "Built-in cost savings" and "Cost tuning for developers" replace the top-level Token cost page, and no link points to the old page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T16 · Split The loop into Design calls, Agent development flow and The check · done · M · agent
- Depends on: T15
- Touches: docs/concept/loop.md, docs/concept/design-calls.md (new), docs/concept/agent-flow.md (new), docs/concept/check.md (new), mkdocs.yml, docs/index.md
- Done when: each of the three concepts has its own page, framework-neutral, with per-framework detail only where it explains the idea (demo) · nothing from The loop is lost or repeated across the three pages (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T17 · The Records in files concept page · todo · S · agent
- Depends on: T15
- Touches: docs/concept/records.md (new), mkdocs.yml
- Done when: the page explains the records, one home per fact, and why clearing a session loses nothing, and the pages that touched it link here instead of repeating it (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T18 · The Code shaped for agents and Ownership concept pages · todo · S · agent
- Depends on: T15
- Touches: docs/concept/code-shape.md (new), docs/concept/ownership.md (new), docs/concept/index.md, mkdocs.yml
- Done when: both concepts move from the overview to their own pages (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T6 · Skills section, and the /next-task page · todo · M · agent
- Depends on: T15, T16, T17, T18
- Touches: docs/skills/index.md (new), docs/skills/next-task.md (new), mkdocs.yml, selftest.sh, validation/TEMPLATE.md, docs/frameworks/index.md
- Done when: a Skills section lists the six common skills, and the /next-task page describes the skill in all three frameworks with a "Unique per repo" section for each (demo) · the selftest fails when a skill all three frameworks ship has no page under docs/skills/ (check) · the acceptance template has a "Look up a skill" section (check)
- Brief: Scope › Common skills, Core Flows › Look up a skill

### T7 · The /design skill page · todo · S · agent
- Depends on: T6
- Touches: docs/skills/design.md (new), mkdocs.yml
- Done when: the page describes /design in all three frameworks, with what is unique per repo (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T8 · The /align skill page · todo · S · agent
- Depends on: T6
- Touches: docs/skills/align.md (new), mkdocs.yml, docs/concept/drift.md
- Done when: the page describes /align in all three frameworks, with what is unique per repo, and the concept page links to it instead of repeating it (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T9 · The /drift-reset skill page · todo · S · agent
- Depends on: T6
- Touches: docs/skills/drift-reset.md (new), mkdocs.yml, docs/concept/drift.md
- Done when: the page describes /drift-reset and its postmortem in all three frameworks, with what is unique per repo, and the concept page links to it instead of repeating it (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T10 · The /prune skill page · todo · S · agent
- Depends on: T6
- Touches: docs/skills/prune.md (new), mkdocs.yml
- Done when: the page describes /prune in all three frameworks, with what is unique per repo (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T11 · The /refresh-model-sizing skill page · todo · S · agent
- Depends on: T6
- Touches: docs/skills/refresh-model-sizing.md (new), mkdocs.yml, docs/concept/sizing.md
- Done when: the page describes /refresh-model-sizing in all three frameworks, with what is unique per repo, and the sizing concept page links to it (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T20 · The Acceptance check skill page · todo · S · agent
- Depends on: T6
- Touches: docs/skills/acceptance.md (new), mkdocs.yml, selftest.sh
- Done when: one page covers /acceptance in App-Director and SaaSAllTheThings and /function-check in Godot-Director, with /playtest and /feedback under unique per repo (demo) · the selftest's coverage accepts /function-check as covered by this page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T21 · Review the agent's call on Q6 · todo · - · human
- Depends on: -
- Touches: product/brief.md › Scope › Common skills
- Done when: the director confirms or changes the Acceptance check and Release lines marked "agent's call, review later" (demo)
- Brief: Scope › Common skills

### T12 · Go-ahead for the orchestrator · todo · - · human
- Depends on: -
- Touches: -
- Done when: the director says the docs side is good enough to start the orchestrator (demo)
- Brief: Scope › Later: orchestrator for the three frameworks

### T13 · Audit: the three repos match the skill anchors · todo · M · agent
- Depends on: T12, T6, T7, T8, T9, T10, T11
- Touches: tools/audit.sh (new), AGENTS.md
- Done when: an audit compares each common skill in the three framework repos with its skill page and lists every difference that the page doesn't record as unique to that repo (check) · the audit's report names the repo, the skill and the difference (check)
- Brief: Scope › Later: orchestrator for the three frameworks

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

### T1 · The check passes on a clean clone · done · S · agent
- Depends on: -
- Touches: tools/check.cfg, tools/check.local.sh (new)
- Done when: `bash tools/check.sh` exits 0 (check)
- Brief: -

## Notes
- T2 needs the director's GitHub login.
- The orchestrator items (T13, T14, T19) wait for the director's go-ahead in T12, and T14 also waits on Q7.
- Concepts come before skills: T6 waits on T15 to T18. T16, T17 and T18 are independent once T15 is done; T7 to T11 are independent once T6 is done.
- The selftest clones the three framework repos on every run, so the check needs network until T3 is done.
