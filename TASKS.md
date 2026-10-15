# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T49 · B3

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

### T29 · Each framework repo gets its own root task queue · done · M · agent
- Depends on: T28
- Touches: a pull request to each framework repo adding a root TASKS.md (the director merges); tools/push-alignment.sh
- Done when: Godot-Director, App-Director and SaaSAllTheThings each have an open pull request that adds a root TASKS.md in the App Director item format, separate from `project/TASKS.md` (check) · push-alignment.sh skips a repo with no root TASKS.md instead of creating one (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T36 · The /next-task page states Godot-Director's commit prompt accurately · done · XS · agent
- Depends on: -
- Touches: docs/skills/next-task.md
- Done when: the Godot-Director section says that its procedure doesn't pause for approval but its settings ask before every commit, matching the current release (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T38 · The selftest checks the docs against each framework's latest release · done · S · agent
- Depends on: -
- Touches: selftest.sh, tools/audit.sh, README.md, AGENTS.md
- Done when: the selftest keeps each cached framework clone at that framework's latest release tag (`v<version>`), refreshed when online and reused offline (check) · `tools/audit.sh` compares against the same release (check) · AGENTS.md › Architecture and the README say the docs follow releases (check) · `bash tools/check.sh` passes, and any page that describes something only on `main` is reported (check)
- Brief: Scope › Planned framework changes

### T44 · Framework and skill pages link to the latest release · done · S · agent
- Depends on: T38
- Touches: docs/frameworks/*.md, docs/skills/*.md, selftest.sh
- Done when: the buttons on the framework pages and the procedure links on the skill pages point at each framework's latest release tag, not `main` (check) · the selftest reports a link into a framework repo that points at `main` or an older release (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### B2 · The pre-commit hook takes the framework clones for upgrade files · done · XS · agent · high
- Depends on: -
- Touches: .githooks/pre-commit, .app-director/procedures/align.md
- Repro: with the framework clones in `work/`, run `git commit` → expected: the commit goes ahead / actual: "unmerged App Director upgrade files (*.adir-new) exist", listing `work/App-Director/` and the other clones, because `git ls-files` lists a nested repository in an ignored folder as a directory
- Found in: T40
- Brief: Scope › Later: orchestrator for the three frameworks

### T40 · A workspace for framework work: clones of the three repos · done · M · agent
- Depends on: -
- Touches: .gitignore, tools/work-clones.sh (new), tools/work-publish.sh (new), Claude Code settings, AGENTS.md
- Done when: `work/` is gitignored, and `tools/work-clones.sh` clones the three framework repos there or fetches an existing clone (check) · `tools/work-publish.sh` pushes a clone's item branch and opens its pull request, refuses `main` and never merges, and the settings let it run without a prompt while every other push keeps asking (check) · AGENTS.md › Project rules says how a framework item is built: in its clone on a branch, following that repo's `CLAUDE.md`, gated by its `selftest.sh`, the item added done to that repo's root TASKS.md with a CHANGELOG entry, then committed and published without pausing, as one pull request the director merges (check) · AGENTS.md › Layout lists `work/`, and the Orchestrator row in Architecture matches (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T45 · Alignment items wait in this repo's queue · done · S · agent
- Depends on: T40
- Touches: tools/push-alignment.sh, AGENTS.md
- Done when: a difference the audit finds in a framework's procedure becomes a framework item in this repo's TASKS.md whose `Touches` names that framework's clone under `work/`, instead of a pull request that only adds an item (check) · the script opens no pull requests (check) · AGENTS.md › Architecture describes it in one row, with the stale Alignment row merged into Orchestrator (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T46 · The upgrade-file check ignores nested clones, in all three frameworks · in-progress 2026-10-15 · S · agent
- PRs: Godot-Director #2 (open), App-Director #2 (merged), SaaSAllTheThings #2 (merged)
- Depends on: B2
- Touches: work/App-Director, work/Godot-Director, work/SaaSAllTheThings (one pull request per repo; the director merges)
- Done when: each framework's pre-commit hook, `/align` procedure and onboarding keep only paths that end in its upgrade suffix (`.adir-new`, `.gdir-new`, `.satt-new`), so a nested clone in an ignored folder no longer blocks a commit while a real upgrade file still does, with one merged pull request per repo, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T47 · App-Director's selftest works with gitleaks 8.30 · todo · S · agent
- Depends on: -
- Touches: work/App-Director: selftest.sh (one pull request; the director merges)
- Done when: App-Director's selftest checks "names the file with the secret" and "allowlisted fingerprint passes" pass with gitleaks 8.30.1, which they fail on main today, and still pass with the version they were written for, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T48 · SaaSAllTheThings' selftest skips .NET without the SDK · todo · S · agent
- Depends on: -
- Touches: work/SaaSAllTheThings: selftest.sh (one pull request; the director merges)
- Done when: SaaSAllTheThings' selftest skips its .NET part on a machine with the .NET host but no SDK, where three checks fail on main today, and still runs it where an SDK is installed, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T41 · The internal framework workflow page · done · S · agent
- Depends on: T40
- Touches: product/framework-workflow.md (new), docs/index.md
- Done when: `product/framework-workflow.md` explains how framework work runs here, with a flowchart and a sequence diagram in Mermaid that GitHub renders, matching AGENTS.md › Project rules (check) · it isn't part of the Pages build (check) · the home page's Built with App-Director section links to it on GitHub (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Built with App-Director

### T39 · The framework repos install the latest release · todo · M · agent
- Depends on: T40
- Touches: work/App-Director: SKILL.md, skills/app-director/SKILL.md, scripts/fetch-app-director.sh, .claude-plugin/marketplace.json, CLAUDE.md, README.md, selftest.sh; work/Godot-Director: skills/godot-director/SKILL.md, .claude-plugin/marketplace.json, CLAUDE.md, README.md, selftest.sh; work/SaaSAllTheThings: .claude-plugin/marketplace.json (one pull request per repo; the director merges)
- Done when: App-Director and Godot-Director each have a merged pull request that makes the skill, the fetch script and, where the marketplace can pin a ref, the plugin install the latest release tag, and that tags every release `v<version>`, following AGENTS.md › Project rules for framework work (check) · SaaSAllTheThings' plugin follows the release tag, with a pull request if it needs a change (check)
- Brief: Scope › Planned framework changes

### T35 · The shared commit model in the framework repos · in-progress 2026-10-15 · M · agent
- PRs: Godot-Director #3 (open), SaaSAllTheThings #3 (open), App-Director #3 (open)
- Depends on: T40
- Touches: work/Godot-Director and work/SaaSAllTheThings: framework/.<godot-director|satt>/procedures/next-task.md, framework/.claude/settings.json, framework/.<godot-director|satt>/rules.md, framework/.claude/skills/next-task/SKILL.md, README.md, examples/scenarios.md (SaaSAllTheThings also skills/saas-design-session/references/rules.md, from bundle.sh); work/App-Director: framework/.app-director/procedures/next-task.md, framework/.claude/skills/next-task/SKILL.md, README.md, examples/scenarios.md (one pull request per repo; the director merges)
- Done when: Godot-Director and SaaSAllTheThings each have a merged pull request that adopts the commit model in the brief (procedure step 7, run triggers including "grab tasks until you're blocked", `git commit` allowed in settings, push still asking), and App-Director one that adds that trigger phrase, following AGENTS.md › Project rules for framework work (check)
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

### T33 · App-Director: the research assistant · todo · M · agent
- Depends on: T32, T40
- Touches: work/App-Director (one pull request; the director merges)
- Done when: App-Director has a merged pull request that builds the research assistant from `product/anchors/research.md`, with its domain file (stacks, libraries and app-store requirements), an `R<n>` counter on its `Next IDs` line, and the new files in its README, install script, skills folder and selftest, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T42 · Godot-Director: the research assistant · todo · M · agent
- Depends on: T32, T40
- Touches: work/Godot-Director (one pull request; the director merges)
- Done when: Godot-Director has a merged pull request that builds the research assistant from `product/anchors/research.md`, with its domain file (the Godot docs and engine version, asset licences and store requirements), an `R<n>` counter on its `Next IDs` line, and the new files in its README, install script, skills folder and selftest, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T43 · SaaSAllTheThings: the research assistant · todo · M · agent
- Depends on: T32, T40
- Touches: work/SaaSAllTheThings (one pull request; the director merges)
- Done when: SaaSAllTheThings has a merged pull request that builds the research assistant from `product/anchors/research.md`, with its domain file (Azure and the customer's security framework), an `R<n>` counter on its `Next IDs` line, and the new files in its README, install and bundle scripts, skills folder and selftest, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T34 · The Research skill page · todo · S · agent
- Depends on: T33, T42, T43
- Touches: docs/skills/research.md (new), docs/skills/index.md, mkdocs.yml, docs/concept/design-calls.md
- Done when: once all three frameworks have released the research assistant, the page describes the shared behaviour and what is unique per repo, matching the released procedures (check) · Design calls links to it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T19 · Godot-Director: export onboarding and /export · todo · M · agent
- Depends on: T40
- Touches: work/Godot-Director (one pull request; the director merges); docs/frameworks/godot-director.md once released
- Done when: Godot-Director has a merged pull request whose onboarding asks for missing export settings (target platforms) and where exports run (local, a build container, or hosted CI such as GitHub Actions); when the step is skipped, onboarding adds a GDD open question on both and a setup item that depends on it, so `/design Q<n>` runs the step later and `/next-task` builds it; and that adds an `/export` skill, following AGENTS.md › Project rules for framework work (check) · once released there, the Godot-Director page documents them (check)
- Brief: Scope › Planned framework changes

### T31 · Godot-Director: CI export and CD release · todo · M · agent
- Depends on: T19
- Touches: work/Godot-Director (one pull request; the director merges); docs/frameworks/godot-director.md and a /release skill page once released
- Done when: Godot-Director has a merged pull request with CI that runs the export on every change, and CD that releases builds to a platform's UAT branch with optional promotion to production, following AGENTS.md › Project rules for framework work (check) · once released there, the Godot-Director page documents them and /release gets its own skill page (check)
- Brief: Scope › Planned framework changes

## Notes
- T46 waits on the merge of Godot-Director #2. T39 changes Godot-Director's selftest.sh, so it waits on Godot-Director #2 too.
- T35 waits on the merge of Godot-Director #3, SaaSAllTheThings #3 and App-Director #3; T37 follows T35 and the releases.
- T33, T42 and T43 change next-task.md (open in the T35 pull requests) and selftest.sh (open in the T46 pull requests), so they wait on both. T19 changes Godot-Director's ONBOARDING.md (open in Godot-Director #2). T31 follows T19.
- T29's pull requests are merged, so all three framework repos have their root queue. T37 waits on the releases; T34 waits until all three frameworks have released the research assistant.
