# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T148 · B5 · R4

## Milestones
| Milestone | Status |
|---|---|
| Foundation: site builds, selftest and check passing, CI running | ✅ |
| Live: the site is published on GitHub Pages | ✅ |
| Acceptance: all core flows verified on the live site | ⬜ |
| Concepts: one page per core concept | ✅ |
| Skills: one page per common skill | ✅ |
| Polish: identity, licence and offline-safe check | ✅ |
| Orchestrator: anchors, framework items built here and published as pull requests, releases, audit | 🟨 |

✅ done · 🟨 in progress · ⬜ not started

## Queue

### T146 · The Examples entries say what kind of thing each is · done 2026-10-19 · XS · agent
- Depends on: T133
- Touches: mkdocs.yml (nav), docs/examples/index.md, docs/examples/pksei.md
- Done when: the nav and the overview read "Game: PKSEI", and the other two cards name their kind the same way (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Examples

### R1 · What this way of working costs, measured across three projects · done 2026-10-19 · M · agent
- Depends on: -
- Question: What does Director-Driven Development cost in tokens and money across three real projects, measured from the Claude Code transcripts and priced at API rates, what do the subscriptions turn that into, and which claims hold without over-claiming?
- Informs: -
- Brief: -
- Note: product/research/2026-10-19-cost-of-working-this-way.md

### R2 · What large studies say AI-assisted coding produces, and per what unit · done 2026-10-19 · M · agent
- Depends on: -
- Note: product/research/2026-10-19-external-numbers-ai-coding-output.md
- Question: What do the large studies of AI-assisted software development (randomised trials, industry surveys, vendor telemetry, benchmark cost tables) measure as output and productivity, in what units (per developer-hour, per task, per pull request, per million tokens, per dollar), and what do they find, so that R1's figures ($2 to $3 API-equivalent per completed task, $10 to $20 per attended hour, 96 percent cache reads) can be put beside external numbers without over-claiming? Scope: public studies and datasets from 2023 to 2026; exclude vendor marketing without method.
- Informs: -
- Brief: -

### T147 · The PKSEI pages call it a comedy rage game · done 2026-10-19 · XS · agent
- Depends on: T133
- Touches: docs/examples/index.md, docs/examples/pksei.md
- Done when: the overview card and the page describe PKSEI as a comedy rage game about four friends, with no "drunk guys" wording, as the director asked (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Examples

### R3 · What AI coding agents cost per unit of work in enterprises without a workflow · done 2026-10-19 · M · agent
- Depends on: -
- Note: product/research/2026-10-19-ai-coding-cost-per-unit-of-work.md
- Question: For enterprises and teams using AI coding agents freeform (Claude Code, Cursor, Copilot agent mode, Codex and the like, with no structured workflow), what published figures join spend (dollars or tokens) to output (merged changes, tasks, features, pull requests) per developer or per unit of work, from case studies, vendor customer stories, engineering blogs, FinOps reports, telemetry vendors' full reports and academic work, 2024 to 2026; and does any source separate structured workflows from freeform use? Scope: real projects, not benchmarks; R2 already covers the productivity trials, the benchmark cost tables, Anthropic's $13 per active day and the Insight single-feature experiment, so build on those rather than repeat them.
- Informs: -
- Brief: -

### T98 · The director tests /ui-design in a game · todo · - · human
- Depends on: T97
- Touches: a Godot game of the director's, with Godot-Director 3.11.0
- Done when: the director has captured, drawn, processed and verified at least one screen with the released /ui-design, and said whether App-Director and SaaSAllTheThings should follow as the anchor says or after changes (demo)
- Brief: Scope › Planned framework changes

### T103 · /ui-design tells the director how to use Excalidraw · in-progress 2026-10-16 · S · agent
- PRs: Godot-Director #18 (merged); App-Director and SaaSAllTheThings committed on their local /ui-design branches, published after T98
- Depends on: T83
- Touches: product/anchors/ui-design.md; work/Godot-Director: framework/.godot-director/procedures/ui-design.md, project/design/ui/README.md, examples/market-day/design/ui/README.md (one pull request; the director squash-merges); work/App-Director and work/SaaSAllTheThings: the same files on the local branches ddd/T84 and ddd/T85 (no push until T98)
- Done when: whenever /ui-design hands the director a starter drawing, it says plainly that nothing needs installing (excalidraw.com in the browser, no account, Excalidraw+ not needed), how to open the starter (the menu's Open, or drag the file in), how to save it to `director/ui/<screen>.excalidraw` (Save to… or Ctrl+S; Chrome and Edge let you pick the folder, other browsers save to Downloads, so move and rename it), and that the drawing stays on the machine unless Live collaboration or a shareable link is used (check) · the anchor and the drawing guide each project gets say the same (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T84 · App-Director: /ui-design with Playwright capture · in-progress 2026-10-16 · L · agent
- Depends on: T83
- Touches: work/App-Director (one pull request; the director merges)
- Note: built, reviewed (nine findings fixed) and committed locally on ddd/T84 (a637da3); no push and no pull request until T98 (the director's UAT) is done, then update from the anchor and publish. Before publishing, fix the selftest's two off-machine note checks, whose `^` anchors match only when that note comes first (found in T85).
- Done when: once Godot-Director has released /ui-design, App-Director has a merged pull request that builds it from the anchor with the Playwright adapter for web apps, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T85 · SaaSAllTheThings: /ui-design with Playwright capture · in-progress 2026-10-16 · L · agent
- Depends on: T83
- Touches: work/SaaSAllTheThings (one pull request; the director merges)
- Note: built, reviewed (findings fixed, dev environment added) and committed locally on ddd/T85; no push and no pull request until T98 (the director's UAT) is done, then update from the anchor and publish.
- Done when: once Godot-Director has released /ui-design, SaaSAllTheThings has a merged pull request that builds it from the anchor with the Playwright adapter, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T86 · The /ui-design skill page · todo · S · agent
- Depends on: T84, T85
- Touches: docs/skills/ui-design.md (new), docs/skills/index.md, mkdocs.yml, docs/frameworks/*.md, docs/concept/ownership.md
- Done when: once all three frameworks have released /ui-design, the page describes the shared behaviour and what is unique per repo, matching the released procedures, in the skills index and nav (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T100 · The framework repos ignore OS metadata files · in-progress 2026-10-16 · XS · agent
- PRs: Godot-Director #16 (merged). App-Director: ba91b84 on main (a one-off test push). SaaSAllTheThings: the .gitignore wasn't the cause, so its copy is optional (see the note).
- Note: the plugin directory's scanner accepts a commit it detects as a tagged release (v1.2.3, v1.3.0, v1.3.1 and, on 2026-10-16, Godot-Director v3.13.0, a GitHub squash merge) and reports every bare commit as "files the scanner won't accept", including release commits tagged after the scheduled check first saw them. Neither the files nor GitHub-made commits were the cause. The rule that follows: tag a release right after its merge, which tools/work-release.sh does.
- Depends on: -
- Touches: work/Godot-Director: .gitignore; work/App-Director: .gitignore; work/SaaSAllTheThings: .gitignore (one pull request per repo; the director squash-merges)
- Done when: each framework's own `.gitignore` ignores `.DS_Store`, `Thumbs.db`, `desktop.ini` and `__MACOSX/`, as the plugin directory's scanner asks, in a pull request the director squash-merges to test whether single-parent commits pass the scan, following AGENTS.md › Project rules for framework work (check)
- Note: Godot-Director first, as a test: if the squash-merged commit passes the plugin scanner, the same change goes to App-Director and SaaSAllTheThings once their clones' local /ui-design builds are committed.
- Brief: Scope › Orchestrator for the three frameworks

### T102 · The secrets scan doesn't flag drawings · todo · S · agent
- Depends on: T84, T85
- Touches: work/App-Director and work/SaaSAllTheThings: the secrets step of framework/tools/check.sh or the gitleaks config seed (one pull request per repo; the director squash-merges)
- Done when: a committed drawing in `director/ui/*.excalidraw`, whose embedded base64 screenshot can match a key pattern, doesn't fail the check, while a real key in any other file still does, following AGENTS.md › Project rules for framework work (check)
- Note: found while building T85. Ships with /ui-design, so it waits for T84 and T85.
- Brief: Scope › Planned framework changes

## Notes
