# Tasks archive

Done items, moved here unchanged. IDs are never reused.

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

### T17 · The Records in files concept page · done · S · agent
- Depends on: T15
- Touches: docs/concept/records.md (new), mkdocs.yml
- Done when: the page explains the records, one home per fact, and why clearing a session loses nothing, and the pages that touched it link here instead of repeating it (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T18 · The Code shaped for agents and Ownership concept pages · done · S · agent
- Depends on: T15
- Touches: docs/concept/code-shape.md (new), docs/concept/ownership.md (new), docs/concept/index.md, mkdocs.yml
- Done when: both concepts move from the overview to their own pages (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T6 · Skills section, and the /next-task page · done · M · agent
- Depends on: T15, T16, T17, T18
- Touches: docs/skills/index.md (new), docs/skills/next-task.md (new), mkdocs.yml, selftest.sh, validation/TEMPLATE.md, docs/frameworks/index.md
- Done when: a Skills section lists the six common skills, and the /next-task page describes the skill in all three frameworks with a "Unique per repo" section for each (demo) · the selftest fails when a skill all three frameworks ship has no page under docs/skills/ (check) · the acceptance template has a "Look up a skill" section (check)
- Brief: Scope › Common skills, Core Flows › Look up a skill

### T7 · The /design skill page · done · S · agent
- Depends on: T6
- Touches: docs/skills/design.md (new), mkdocs.yml
- Done when: the page describes /design in all three frameworks, with what is unique per repo (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T8 · The /align skill page · done · S · agent
- Depends on: T6
- Touches: docs/skills/align.md (new), mkdocs.yml, docs/concept/drift.md
- Done when: the page describes /align in all three frameworks, with what is unique per repo, and the concept page links to it instead of repeating it (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T9 · The /drift-reset skill page · done · S · agent
- Depends on: T6
- Touches: docs/skills/drift-reset.md (new), mkdocs.yml, docs/concept/drift.md
- Done when: the page describes /drift-reset and its postmortem in all three frameworks, with what is unique per repo, and the concept page links to it instead of repeating it (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T10 · The /prune skill page · done · S · agent
- Depends on: T6
- Touches: docs/skills/prune.md (new), mkdocs.yml
- Done when: the page describes /prune in all three frameworks, with what is unique per repo (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T11 · The /refresh-model-sizing skill page · done · S · agent
- Depends on: T6
- Touches: docs/skills/refresh-model-sizing.md (new), mkdocs.yml, docs/concept/sizing.md
- Done when: the page describes /refresh-model-sizing in all three frameworks, with what is unique per repo, and the sizing concept page links to it (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T20 · The Acceptance check skill page · done · S · agent
- Depends on: T6
- Touches: docs/skills/acceptance.md (new), mkdocs.yml, selftest.sh
- Done when: one page covers /acceptance in App-Director and SaaSAllTheThings and /function-check in Godot-Director, with /playtest and /feedback under unique per repo (demo) · the selftest's coverage accepts /function-check as covered by this page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T21 · Review the agent's call on Q6 · done · - · human
- Depends on: -
- Touches: product/brief.md › Scope › Common skills
- Done when: the director confirms or changes the Acceptance check and Release lines marked "agent's call, review later" (demo)
- Brief: Scope › Common skills

### T12 · Go-ahead for the orchestrator · done · - · human
- Depends on: -
- Touches: -
- Done when: the director says the docs side is good enough to start the orchestrator (demo)
- Brief: Scope › Later: orchestrator for the three frameworks

### T13 · Audit: the three repos match the skill anchors · done · M · agent
- Depends on: T12, T6, T7, T8, T9, T10, T11
- Touches: tools/audit.sh (new), AGENTS.md
- Done when: an audit compares each common skill in the three framework repos with its skill page and lists every difference that the page doesn't record as unique to that repo (check) · the audit's report names the repo, the skill and the difference (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T22 · The Signal mark as logo and favicon · done · XS · agent
- Depends on: -
- Touches: docs/assets/images/logo.svg, docs/assets/images/favicon.svg
- Done when: the header and the browser tab show the Signal mark in the amber accent instead of the three D's (demo) · `bash tools/check.sh` passes (check)
- Brief: Scope › Identity

### T1 · The check passes on a clean clone · done · S · agent
- Depends on: -
- Touches: tools/check.cfg, tools/check.local.sh (new)
- Done when: `bash tools/check.sh` exits 0 (check)
- Brief: -

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

### T46 · The upgrade-file check ignores nested clones, in all three frameworks · done · S · agent
- PRs: Godot-Director #2 (merged), App-Director #2 (merged), SaaSAllTheThings #2 (merged)
- Depends on: B2
- Touches: work/App-Director, work/Godot-Director, work/SaaSAllTheThings (one pull request per repo; the director merges)
- Done when: each framework's pre-commit hook, `/align` procedure and onboarding keep only paths that end in its upgrade suffix (`.adir-new`, `.gdir-new`, `.satt-new`), so a nested clone in an ignored folder no longer blocks a commit while a real upgrade file still does, with one merged pull request per repo, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T47 · App-Director's selftest works with gitleaks 8.30 · done · S · agent
- PRs: App-Director #4 (merged)
- Depends on: -
- Touches: work/App-Director: selftest.sh, framework/tools/check.sh (one pull request; the director merges)
- Done when: App-Director's selftest checks "names the file with the secret" and "allowlisted fingerprint passes" pass with gitleaks 8.30.1, which they fail on main today, and still pass with the version they were written for, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T49 · App-Director's pre-commit hook names the file with a secret · done · S · agent
- PRs: App-Director #5 (merged)
- Depends on: -
- Touches: work/App-Director: framework/.githooks/pre-commit, selftest.sh (one pull request; the director merges)
- Done when: when the pre-commit hook blocks a commit because gitleaks found a secret in the staged changes, it names the file, as `tools/check.sh` does after App-Director #4, without printing the secret, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T50 · App-Director's secrets check treats gitleaks 8.19.0 as unable to scan · done · S · agent
- PRs: App-Director #6 (merged)
- Depends on: -
- Touches: work/App-Director: framework/tools/check.sh, selftest.sh (one pull request; the director merges)
- Done when: with gitleaks 8.19.0, which fails every scan command, `tools/check.sh` says it couldn't scan (exit 3, with a hint to upgrade gitleaks) instead of reporting credentials found, its comment about 8.19.0 says so, and the selftest's real-gitleaks checks skip 8.19.0; the minimum version stays 8.18.0, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T52 · App-Director's setup and README name gitleaks 8.19.0 as unusable · done · XS · agent
- PRs: App-Director #7 (merged)
- Depends on: -
- Touches: work/App-Director: framework/tools/setup-clone.sh, README.md (one pull request; the director merges)
- Done when: `setup-clone.sh` no longer accepts gitleaks 8.19.0 as at least 8.18.0, and says to upgrade it, and the README's requirement names 8.19.0 as the exception, matching `tools/check.sh` after App-Director #6, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T53 · App-Director's fast check notices a changed gitleaks · done · S · agent
- PRs: App-Director #8 (merged)
- Depends on: -
- Touches: work/App-Director: framework/tools/check.sh, selftest.sh (one pull request; the director merges)
- Done when: `tools/check.sh --if-changed` doesn't reuse a cached pass when gitleaks was removed or its version changed since that pass, so the secrets step runs again, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T57 · App-Director's selftest expects setup to refuse gitleaks 8.19.0 · done · XS · agent
- PRs: App-Director #10 (merged)
- Depends on: T52
- Touches: work/App-Director: selftest.sh (one pull request; the director merges)
- Done when: with gitleaks 8.19.0, the selftest's "setup-clone installs the pre-commit hook" check expects setup-clone's refusal (App-Director #7) instead of failing, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T48 · SaaSAllTheThings' selftest skips .NET without the SDK · done · S · agent
- PRs: SaaSAllTheThings #4 (merged)
- Depends on: -
- Touches: work/SaaSAllTheThings: selftest.sh (one pull request; the director merges)
- Done when: SaaSAllTheThings' selftest skips its .NET part on a machine with the .NET host but no SDK, where three checks fail on main today, and still runs it where an SDK is installed, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Later: orchestrator for the three frameworks

### T51 · Framework releases when a change is complete · done · M · agent
- Depends on: T40
- Touches: tools/work-release.sh (new), Claude Code settings, AGENTS.md, product/framework-workflow.md
- Done when: AGENTS.md › Project rules › Framework work says when a release is proposed (an item done, for each repo it touched, covering everything merged since that repo's last release), that the proposal is a release pull request following that repo's `CLAUDE.md` (version bump, CHANGELOG heading, release notes), and that the director decides every release (check) · `tools/work-release.sh work/<repo>` tags the merged release commit `v<version>` from VERSION and publishes the GitHub release with the notes from the CHANGELOG; it refuses when the release pull request isn't merged, the tag already exists or the version files disagree, and it never force-pushes or moves a tag; the settings let it run without a prompt (check) · after a release, an item here moves the docs links to the new tag and updates the pages for what the release ships (check) · the internal workflow page shows the release step (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### B3 · The release notes would carry the commit's Co-Authored-By line · done · XS · agent · med
- Depends on: -
- Touches: tools/work-release.sh
- Repro: a release commit ends with its Co-Authored-By trailer, so the release pull request's description does too; run `tools/work-release.sh` → expected: the published notes end with the release content / actual: they end with "Co-Authored-By: ...", since only the "Generated with Claude Code" line was dropped
- Found in: T54
- Brief: Scope › Planned framework changes

### T54 · Release Godot-Director 3.6.0 · done · S · agent
- PRs: Godot-Director #4 (merged); released as v3.6.0
- Depends on: T51
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T46 and T35, is merged, and `tools/work-release.sh` has tagged `v3.6.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.6.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T55 · Release SaaSAllTheThings 0.7.0 · done · S · agent
- PRs: SaaSAllTheThings #5 (merged); released as v0.7.0
- Depends on: T51
- Touches: work/SaaSAllTheThings: VERSION, .claude-plugin/plugin.json, skills/*/SKILL.md, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T46, T35 and T48, is merged, and `tools/work-release.sh` has tagged `v0.7.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v0.7.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### B4 · The release step couldn't hand gh its notes on Windows · done · XS · agent · high
- Depends on: -
- Touches: tools/work-release.sh
- Repro: on Git Bash for Windows, run `tools/work-release.sh` for a merged release pull request → expected: the tag is pushed and the release published / actual: the tag is pushed, then `gh release create` fails with "open /tmp/work-release.XXXXXX: The system cannot find the path specified", because the script turns Git Bash's path translation off for its `git show` arguments, so the Windows gh got a /tmp path
- Found in: T55 (v0.7.0 was published by hand with the kept notes)
- Brief: Scope › Planned framework changes

### T58 · Docs follow SaaSAllTheThings 0.7.0 · done · S · agent
- Depends on: T55
- Touches: docs/frameworks/saasallthethings.md, docs/skills/*.md, docs/concept/agent-flow.md
- Done when: every link into SaaSAllTheThings points at v0.7.0 (check) · the pages describe what 0.7.0 changed for SaaSAllTheThings, such as its run mode, where they state its old behaviour; the shared rewrite stays with T37 (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T59 · Docs follow Godot-Director 3.6.0 · done · S · agent
- Depends on: T54
- Touches: docs/frameworks/godot-director.md, docs/skills/*.md
- Done when: every link into Godot-Director points at v3.6.0 (check) · the pages describe what 3.6.0 changed for Godot-Director, such as its commit model, where they state its old behaviour; the shared rewrite stays with T37 (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T56 · Release App-Director 1.4.0 · done · S · agent
- PRs: App-Director #9 (merged; its notes gained T53's entry, which merged just before it); released as v1.4.0
- Depends on: T51, T52
- Touches: work/App-Director: VERSION, .claude-plugin/plugin.json, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T46, T35, T47, T49, T50 and T52, and the 1.3.1 entry that was never tagged, is merged, and `tools/work-release.sh` has tagged `v1.4.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v1.4.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T60 · Docs follow App-Director 1.4.0 · done · S · agent
- Depends on: T56
- Touches: docs/frameworks/app-director.md, docs/skills/*.md
- Done when: every link into App-Director points at v1.4.0 (check) · the pages describe what 1.4.0 changed for App-Director where they state its old behaviour, apart from the commit model, which T37 rewrites for all three (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T41 · The internal framework workflow page · done · S · agent
- Depends on: T40
- Touches: product/framework-workflow.md (new), docs/index.md
- Done when: `product/framework-workflow.md` explains how framework work runs here, with a flowchart and a sequence diagram in Mermaid that GitHub renders, matching AGENTS.md › Project rules (check) · it isn't part of the Pages build (check) · the home page's Built with App-Director section links to it on GitHub (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Built with App-Director

### T35 · The shared commit model in the framework repos · done · M · agent
- PRs: Godot-Director #3 (merged), SaaSAllTheThings #3 (merged), App-Director #3 (merged)
- Depends on: T40
- Touches: work/Godot-Director and work/SaaSAllTheThings: framework/.<godot-director|satt>/procedures/next-task.md, framework/.claude/settings.json, framework/.<godot-director|satt>/rules.md, framework/.claude/skills/next-task/SKILL.md, README.md, examples/scenarios.md (SaaSAllTheThings also skills/saas-design-session/references/rules.md, from bundle.sh); work/App-Director: framework/.app-director/procedures/next-task.md, framework/.claude/skills/next-task/SKILL.md, README.md, examples/scenarios.md (one pull request per repo; the director merges)
- Done when: Godot-Director and SaaSAllTheThings each have a merged pull request that adopts the commit model in the brief (procedure step 7, run triggers including "grab tasks until you're blocked", `git commit` allowed in settings, push still asking), and App-Director one that adds that trigger phrase, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T37 · Docs follow the shared commit model · done · XS · agent
- Depends on: T35
- Touches: docs/skills/next-task.md, docs/concept/agent-flow.md
- Done when: once all three frameworks have released the shared commit model, the /next-task page describes it once for all three and drops the per-repo differences, and Agent development flow matches (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T32 · The shared research core as the anchor · done · M · agent
- Depends on: -
- Touches: product/anchors/research.md (new)
- Done when: the anchor holds the shared research procedure adapted from the director's portable research skill (`init/research/research-skill.md`) with the agreed adaptations: the researcher subagent, `/research`, R items with `Question:` and `Informs:`, the dated research note, sizing, and what each framework's domain file covers (check) · it uses "requirements", "control framework" or "security framework", never "policy" (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### T42 · Godot-Director: the research assistant · done · M · agent
- PRs: Godot-Director #5 (merged)
- Depends on: T32, T40
- Touches: work/Godot-Director: framework/.godot-director/{procedures/research.md (new), research-domain.md (new), tasks.md, rules.md, procedures/next-task.md, procedures/design.md, procedures/align.md}, framework/.claude/{agents/researcher.md (new), skills/research/SKILL.md (new), settings.json}, project/TASKS.md, project/design/research/README.md (new), README.md, ONBOARDING.md, selftest.sh, examples/ (one pull request; the director merges)
- Done when: Godot-Director has a merged pull request that builds the research assistant from `product/anchors/research.md`, with its domain file (the Godot docs and engine version, asset licences and store requirements), an `R<n>` counter on its `Next IDs` line, and the new files in its README, install script, skills folder and selftest, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T43 · SaaSAllTheThings: the research assistant · done · M · agent
- PRs: SaaSAllTheThings #6 (merged)
- Depends on: T32, T40
- Touches: work/SaaSAllTheThings (one pull request; the director merges)
- Done when: SaaSAllTheThings has a merged pull request that builds the research assistant from `product/anchors/research.md`, with its domain file (Azure and the customer's security framework), an `R<n>` counter on its `Next IDs` line, and the new files in its README, install and bundle scripts, skills folder and selftest, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T61 · Release Godot-Director 3.7.0 · done · S · agent
- PRs: Godot-Director #6 (merged); released as v3.7.0
- Depends on: T51
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T42 (the research assistant), is merged, and `tools/work-release.sh` has tagged `v3.7.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.7.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T62 · Release App-Director 1.5.0 · done · S · agent
- PRs: App-Director #13 (merged); released as v1.5.0
- Depends on: T51, T64, T65
- Touches: work/App-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T57, T39 and T65, is merged, and `tools/work-release.sh` has tagged `v1.5.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v1.5.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T67 · Release Godot-Director 3.8.0 · done · S · agent
- PRs: Godot-Director #9 (merged); released as v3.8.0
- Depends on: T51, T64, T65
- Touches: work/Godot-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T39 and T65, is merged, and `tools/work-release.sh` has tagged `v3.8.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.8.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T66 · Docs follow Godot-Director 3.7.0 · done · S · agent
- Depends on: T61
- Touches: docs/frameworks/godot-director.md, docs/skills/*.md
- Done when: every link into Godot-Director points at v3.7.0 (check) · the Godot-Director page lists `/research` among what's unique to it, linking to the procedure, until T34 gives it a skill page once all three ship it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T68 · SaaSAllTheThings' manual install takes the latest release · done · XS · agent
- PRs: SaaSAllTheThings #8 (merged)
- Depends on: T39
- Touches: work/SaaSAllTheThings: README.md (one pull request; the director merges)
- Done when: the manual install option in SaaSAllTheThings' README clones the latest release tag instead of main, worded as App-Director #12 and Godot-Director #8 do, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T63 · Release SaaSAllTheThings 0.8.0 · done · S · agent
- PRs: SaaSAllTheThings #9 (merged); released as v0.8.0
- Depends on: T51, T39, T64, T68
- Touches: work/SaaSAllTheThings: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/*/SKILL.md, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T43 (the research assistant), T39 and T68, is merged, and `tools/work-release.sh` has tagged `v0.8.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v0.8.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T64 · The release step checks every file that carries the version · done · S · agent
- Depends on: T39
- Touches: tools/work-release.sh
- Done when: for each framework, `tools/work-release.sh` checks every file its release rule lists as carrying the version (after T39: App-Director's package.json, both SKILL.md files with their --branch, the fetch script's tag and the marketplace ref; Godot-Director's skill version and --branch and the marketplace ref; SaaSAllTheThings' marketplace ref), and refuses a release where one disagrees (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### T65 · Manual installs clone the latest release · done · XS · agent
- PRs: App-Director #12 (merged), Godot-Director #8 (merged)
- Depends on: T39
- Touches: work/App-Director: README.md; work/Godot-Director: README.md (one pull request per repo; the director merges)
- Done when: the manual install option in App-Director's and Godot-Director's READMEs clones the latest release tag instead of main, as SaaSAllTheThings' does if it does, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T39 · The framework repos install the latest release · done · M · agent
- PRs: App-Director #11 (merged), Godot-Director #7 (merged), SaaSAllTheThings #7 (merged)
- Depends on: T40
- Touches: work/App-Director: SKILL.md, skills/app-director/SKILL.md, package.json, scripts/fetch-app-director.sh, .claude-plugin/marketplace.json, CLAUDE.md, README.md, selftest.sh; work/Godot-Director: skills/godot-director/SKILL.md, .claude-plugin/marketplace.json, CLAUDE.md, README.md, selftest.sh; work/SaaSAllTheThings: .claude-plugin/marketplace.json (one pull request per repo; the director merges)
- Done when: App-Director and Godot-Director each have a merged pull request that makes the skill, the fetch script and, where the marketplace can pin a ref, the plugin install the latest release tag, and that tags every release `v<version>`, with Godot-Director's `skills/godot-director/SKILL.md` `metadata.version` (3.3.0) and App-Director's root `SKILL.md` and `package.json` versions (1.0.0) kept in step with VERSION, following AGENTS.md › Project rules for framework work (check) · SaaSAllTheThings' plugin follows the release tag, with a pull request if it needs a change (check)
- Brief: Scope › Planned framework changes

### T69 · Docs follow App-Director 1.5.0, Godot-Director 3.8.0 and SaaSAllTheThings 0.8.0 · done · S · agent
- Depends on: T62, T67, T63
- Touches: docs/frameworks/*.md, docs/skills/*.md, docs/index.md
- Done when: every link into the three frameworks points at its latest release (check) · the pages describe what these releases changed where they state the old behaviour: the skills, plugins and manual installs take the latest release, and SaaSAllTheThings' page lists `/research` until T34 gives it a skill page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T33 · App-Director: the research assistant · done · M · agent
- PRs: App-Director #14 (merged)
- Depends on: T32, T40
- Touches: work/App-Director (one pull request; the director merges)
- Done when: App-Director has a merged pull request that builds the research assistant from `product/anchors/research.md`, with its domain file (stacks, libraries and app-store requirements), an `R<n>` counter on its `Next IDs` line, and the new files in its README, install script, skills folder and selftest, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T70 · Release App-Director 1.6.0 · done · S · agent
- PRs: App-Director #15 (merged); released as v1.6.0
- Depends on: T51, T33
- Touches: work/App-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T33 (the research assistant), is merged, and `tools/work-release.sh` has tagged `v1.6.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v1.6.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T72 · Docs follow App-Director 1.6.0 · done · S · agent
- Depends on: T70
- Touches: docs/frameworks/app-director.md, docs/skills/*.md
- Done when: every link into App-Director points at v1.6.0 (check) · App-Director's page lists `/research` as the other two do, and the design and /next-task pages say how its design sessions and R items use the researcher (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T71 · Release Godot-Director 3.9.0 · done · S · agent
- PRs: Godot-Director #11 (merged); released as v3.9.0
- Depends on: T51, T19
- Touches: work/Godot-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T19 (export onboarding and /export), is merged, and `tools/work-release.sh` has tagged `v3.9.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.9.0` and documents export onboarding and /export on the Godot-Director page (check)
- Brief: Scope › Planned framework changes

### T34 · The Research skill page · done · S · agent
- Depends on: T33, T42, T43
- Touches: docs/skills/research.md (new), docs/skills/index.md, mkdocs.yml, docs/concept/design-calls.md
- Done when: once all three frameworks have released the research assistant, the page describes the shared behaviour and what is unique per repo, matching the released procedures (check) · Design calls links to it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T73 · The /design page links to /research · done · XS · agent
- Depends on: T34
- Touches: docs/skills/design.md
- Done when: where the /design page mentions the researcher, it links to the /research page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T74 · The frameworks overview lists the research assistant · done · XS · agent
- Depends on: T34
- Touches: docs/frameworks/index.md
- Done when: "Shared by all three" on the frameworks overview names `/research`, linking its skill page, and the researcher next to the builder and reviewer subagents, and its install line matches the framework pages (each install path takes the latest release) (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T75 · Docs follow Godot-Director 3.9.0 · done · S · agent
- Depends on: T71
- Touches: docs/frameworks/godot-director.md, docs/skills/*.md
- Done when: every link into Godot-Director points at v3.9.0 (check) · the Godot-Director page documents export onboarding (with its skip path) and `/export`, accurate to v3.9.0, which also completes T19's docs outcome (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### T19 · Godot-Director: export onboarding and /export · done · M · agent
- PRs: Godot-Director #10 (merged)
- Depends on: T40
- Touches: work/Godot-Director (one pull request; the director merges); docs/frameworks/godot-director.md once released
- Done when: Godot-Director has a merged pull request whose onboarding asks for missing export settings (target platforms) and where exports run (local, a build container, or hosted CI such as GitHub Actions); when the step is skipped, onboarding adds a GDD open question on both and a setup item that depends on it, so `/design Q<n>` runs the step later and `/next-task` builds it; and that adds an `/export` skill, following AGENTS.md › Project rules for framework work (check) · once released there, the Godot-Director page documents them (check)
- Brief: Scope › Planned framework changes

### T76 · Concept pages cover the research assistant · done · S · agent
- Depends on: T34
- Touches: docs/concept/roles.md, docs/concept/agent-flow.md, docs/concept/records.md, docs/concept/sizing.md, docs/concept/cost-built-in.md, docs/concept/index.md
- Done when: the concept pages explain the research assistant where their idea covers it, framework-neutral and linking to the /research page for the commands: the researcher among the roles (it informs, the director decides), research items in the agent flow, research notes as records, research items sized like tasks, research in a fresh context as a cost saving, and the overview (check) · nothing repeats the /research page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T77 · The home page shows the researcher among the roles · done · XS · agent
- Depends on: T76
- Touches: docs/index.md
- Done when: the home page's role cards include the researcher, matching the roles page (it informs, the director decides) and linking to it (check) · `bash tools/check.sh` passes (check)
- Brief: Pitch

### T31 · Godot-Director: CI export and CD release · done · M · agent
- PRs: Godot-Director #12 (merged)
- Depends on: T19
- Touches: work/Godot-Director (one pull request; the director merges); docs/frameworks/godot-director.md and a /release skill page once released
- Done when: Godot-Director has a merged pull request with CI that runs the export on every change, and CD that releases builds to a platform's UAT branch with optional promotion to production, following AGENTS.md › Project rules for framework work (check) · once released there, the Godot-Director page documents them and /release gets its own skill page (check)
- Brief: Scope › Planned framework changes

### T78 · Release Godot-Director 3.10.0 · done · S · agent
- PRs: Godot-Director #13 (merged); released as v3.10.0
- Depends on: T51, T31
- Touches: work/Godot-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T31 (CI export and /release), is merged, and `tools/work-release.sh` has tagged `v3.10.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.10.0`, documents /release on the Godot-Director page, and gives /release its own skill page now that all three ship it (check)
- Brief: Scope › Planned framework changes

### T79 · Docs follow Godot-Director 3.10.0, and the /release skill page · done · S · agent
- Depends on: T78
- Touches: docs/skills/release.md (new), docs/skills/index.md, mkdocs.yml, docs/frameworks/*.md, docs/skills/*.md, product/brief.md
- Done when: every link into Godot-Director points at v3.10.0 (check) · /release has its own skill page now that all three ship it: the shared behaviour and what's unique per repo, matching the released procedures, in the skills index and nav, and the framework pages link to it instead of describing it alone (check) · the Godot-Director page documents /release and CI export (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T80 · The /ui-design anchor · done · M · agent
- Depends on: -
- Touches: product/anchors/ui-design.md (new)
- Done when: the anchor holds the shared /ui-design core adapted from the director's spec (`init/ui-design-skill-spec.md`) to Godot-Director's current release: the drawing conventions, `drawing.json`, the screen spec, the capture, process and verify workflow, and the hooks into build, review, the acceptance check (function check in Godot-Director) and align, with placeholders per framework as the research anchor has (check) · it defines the capture and lint adapter's contract (what capture must output: PNG, element map, map image, lint file) and describes the two adapters: Godot (from the spec) and Playwright for web apps (check) · it records the spec's settled questions (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### T81 · Godot-Director: UI capture, catalog and lint · done · L · agent
- PRs: Godot-Director #14 (merged; one pull request for T81 to T83, the director's request)
- Depends on: T80
- Touches: work/Godot-Director: tools/ui_capture.sh, ui_capture.gd, ui_catalog.gd, ui_lint.gd, ui_overlay.gd (new), project tools/ui_screens.gd and ui_capture.cfg seeds, procedures/ui-design.md (new, list and capture), the /ui-design skill, rules.md, install.sh, selftest.sh (one pull request; the director merges)
- Done when: Godot-Director has a merged pull request where `/ui-design list` and `capture` work as the anchor's Godot adapter says, with the spec's acceptance criteria 1 and 5 met in its own test project, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T82 · Godot-Director: drawings and screen specs · done · M · agent
- PRs: Godot-Director #14 (merged)
- Depends on: T81
- Touches: work/Godot-Director: tools/ui_drawing.gd (new), the starter drawing in capture, procedures/ui-design.md (process), design/ui/README.md seed, tasks.md (`UI:` field), design.md, selftest.sh (one pull request; the director merges)
- Done when: Godot-Director has a merged pull request where capture writes a starter drawing and `/ui-design process` reads a drawing through `drawing.json`, confirms its reading, settles open points and records the screen spec and items, as the anchor says, with the spec's acceptance criteria 2, 3 and 4 met, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T83 · Godot-Director: verify and the workflow hooks · done · M · agent
- PRs: Godot-Director #14 (merged)
- Depends on: T82
- Touches: work/Godot-Director: procedures/ui-design.md (verify), build.md, review.md, function-check.md, align.md, tools/check.sh and check.gd (optional lint), the AGENTS.md template, install.sh, README.md, ONBOARDING.md, selftest.sh (one pull request; the director merges)
- Done when: Godot-Director has a merged pull request where `/ui-design verify` writes compare images and lists deviations, and the build, review, function check, align and the optional check lint use the screen spec, as the anchor says, with the spec's acceptance criteria 6 to 9 met, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T97 · Release Godot-Director 3.11.0 · done · S · agent
- PRs: Godot-Director #15 (merged); released as v3.11.0
- Depends on: T51, T83
- Touches: work/Godot-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T81 to T83 (/ui-design), is merged, and `tools/work-release.sh` has tagged `v3.11.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.11.0` and documents /ui-design on the Godot-Director page (check)
- Brief: Scope › Planned framework changes

### T99 · Docs follow Godot-Director 3.11.0 · done · S · agent
- Depends on: T97
- Touches: docs/frameworks/godot-director.md, docs/skills/*.md
- Done when: every link into Godot-Director points at v3.11.0 (check) · the Godot-Director page lists `/ui-design` and says in a few lines what it lets the director do, accurate to v3.11.0, until T86 gives it a skill page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### T104 · The How-to section and the /ui-design guide · done · S · agent
- Depends on: -
- Touches: docs/how-to/index.md (new), docs/how-to/ui-design.md (new), mkdocs.yml, docs/index.md, product/brief.md (Screens page count)
- Done when: the nav has a How-to section after Skills with an overview page (check) · the /ui-design guide walks a first-time user through it as Godot-Director ships it: what to know (what it's for, that nothing needs installing, where drawings and specs go), what to do (set up the catalog, capture, draw and save in Excalidraw, process, build, verify, with what the agent asks at each step), and the caveats (sizes, overlays for an autoload's HUD, untested platforms, privacy), linking to the procedure at the latest release (check) · the brief's Screens table gives the section's real page count (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T108 · Release Godot-Director 3.12.0 · done · S · agent
- PRs: Godot-Director #19 (merged); released as v3.12.0
- Depends on: T51
- Touches: work/Godot-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director squash-merges)
- Done when: the release pull request, which covers the .gitignore (T100), the protected-space fix (T101) and the Excalidraw instructions (T103), is merged, and `tools/work-release.sh` has tagged `v3.12.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.12.0` (check)
- Brief: Scope › Framework features

### T105 · How-to guides for the common skills · done · M · agent
- Depends on: T104
- Touches: docs/how-to/*.md (new), docs/how-to/index.md, mkdocs.yml, product/brief.md (Screens page count)
- Done when: each common skill and the acceptance check has a guide in the same three parts as the /ui-design guide, accurate to the latest releases (check) · the overview lists them (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T106 · Pages link to their How-to guides · done · S · agent
- Depends on: T104
- Touches: docs/skills/*.md, docs/frameworks/*.md, docs/concept/*.md, selftest.sh
- Done when: every skill page with a guide has a "How to use this skill" link to it near the top, and the framework pages link the guides for their skills (today, the Godot-Director page links the /ui-design guide) (check) · concept pages link a guide where a reader would want the practical steps (check) · the selftest fails when a skill page has a guide in docs/how-to/ but doesn't link it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T107 · How to review and merge the framework pull requests · done · S · agent
- Depends on: T104
- Touches: docs/how-to/merging.md (new), docs/how-to/index.md, mkdocs.yml, product/brief.md (Screens page count)
- Done when: a guide for the director covers reviewing a framework pull request, merging with "Squash and merge" (and why: the plugin directory's scanner), what "Merging is blocked" and conflicts mean and that the agent brings an open branch up to date after each merge, what happens after a merge (the item is done, a release is proposed, the release pull request, the docs follow), and that the agent never merges, describing only what's in place (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T114 · Docs follow Godot-Director 3.12.0 · done · XS · agent
- Depends on: T108
- Touches: docs/frameworks/godot-director.md, docs/skills/*.md, docs/how-to/*.md
- Done when: every link into Godot-Director points at v3.12.0 (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features

### T109 · The How-to section becomes a FAQ: structure and the day-to-day questions · done · M · agent
- Depends on: T107
- Touches: docs/how-to/*.md, docs/how-to/index.md, mkdocs.yml, docs/skills/*.md, docs/frameworks/*.md, docs/concept/*.md, selftest.sh, product/framework-workflow.md, product/brief.md (Screens page count)
- Done when: the nav has the three groups (Start here, Day to day, When things go wrong) with question titles and short stable addresses, the overview lists the questions by group, and the merging guide is moved into `product/framework-workflow.md` and off the site (check) · the six Day to day questions are written to the brief's page model (short answer, two ways with when to use which, steps with what the agent asks, caveats, ties), replacing the skill-named pages, accurate to the latest releases (check) · skill, framework and concept pages link the question that answers them, and the selftest checks that every skill page links a How-to page (check) · placeholders stand in for the Start here and When things go wrong pages until T110 and T111 land, or the groups are added by those items; either way `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T110 · Start here: Where do I start, for Godot-Director · done · M · agent
- Depends on: T109
- Touches: docs/how-to/ (the Start here pages), docs/how-to/index.md, mkdocs.yml, product/brief.md (Screens page count)
- Done when: "Where do I start?" walks a new director through building a game with Godot-Director: what to have installed, installing the framework, onboarding and every question it asks with how to answer, the first task, and where to go next, accurate to the latest release (check) · "I already have a project. Can I use this?" covers onboarding an existing game, accurate to the latest release (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T111 · When things go wrong: the four questions · done · M · agent
- Depends on: T109
- Touches: docs/how-to/ (the When things go wrong pages), docs/how-to/index.md, mkdocs.yml, product/brief.md (Screens page count)
- Done when: "The system was not built as I intended" explains the drift reset step by step with a worked example drawn from a framework's example project, and says when `/align` is enough (check) · the records and the code disagreeing, a long task list, and cost each have their question page to the brief's page model, accurate to the latest releases (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T115 · Troubleshooting: Something isn't there, or doesn't work · done · S · agent
- Depends on: T111
- Touches: docs/how-to/trouble.md (new), docs/how-to/*.md, docs/how-to/index.md, mkdocs.yml, selftest.sh, product/brief.md (Screens page count)
- Done when: a When things go wrong page "Something isn't there, or doesn't work" says to make sure you're on the latest release, with the upgrade command for each install path of each framework and the restart of Claude Code, then the common causes a new director hits (a skill missing, the check failing, a clone without setup-clone.sh, no display for capture), accurate to the latest releases (check) · no How-to or other page tells the reader to upgrade or restart inside a guide, or names a framework version number in prose; pages that need it link the troubleshooting page instead (check) · the selftest fails when a docs page names a framework version number outside a link to a release tag (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T116 · The UI How-to offers editing it yourself · done · XS · agent
- Depends on: T115
- Touches: docs/how-to/ui.md
- Done when: "How do I work with UI changes?" has a third way, editing the screen yourself in Godot (or your editor for an app): commit through the normal flow so the check runs, tell the agent what changed so the screen spec and catalog follow, and when this path is the right one, accurate to the released rules on ownership and the check (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T117 · Which file is it in? · done · S · agent
- Depends on: T111
- Touches: docs/how-to/where.md (new), docs/how-to/index.md, mkdocs.yml, docs/concept/records.md, product/brief.md (Screens page count)
- Done when: a Day to day page "I want to change something. Which file is it in?" has a row per thing a director may want to change, with the file in each framework and whether to edit it yourself or ask (and which question or skill), drawn from each framework's "Each fact lives in one place" table at the latest release, including that the decision log is append-only and changes through a design session (check) · Records in files links it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T118 · App-Director's README says how to update the plugin · done · XS · agent
- PRs: App-Director #18 (merged)
- Depends on: -
- Touches: work/App-Director: README.md (one pull request; the director merges)
- Done when: App-Director's README gives the plugin update commands (`/plugin marketplace update` and `/plugin update`, and the restart), as Godot-Director's and SaaSAllTheThings' do, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T119 · The framework repos' own queues carry an R counter · done · XS · agent
- PRs: App-Director #18, Godot-Director #21 and #23, SaaSAllTheThings #11 and #13 (all merged)
- Depends on: -
- Touches: work/App-Director: TASKS.md; work/Godot-Director: TASKS.md; work/SaaSAllTheThings: TASKS.md (one pull request per repo; the director merges)
- Done when: each framework's root TASKS.md `Next IDs` line carries the `R<n>` counter its own align procedure asks for, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T112 · Where do I start, for App-Director · done · S · agent
- Depends on: T110
- Touches: docs/how-to/ (the Start here pages), mkdocs.yml, product/brief.md (Screens page count)
- Done when: the Start here walkthrough has an App-Director version (building an app), accurate to the latest release, reached from the overview and the App-Director page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T113 · Where do I start, for SaaSAllTheThings · done · S · agent
- Depends on: T110
- Touches: docs/how-to/ (the Start here pages), mkdocs.yml, product/brief.md (Screens page count)
- Done when: the Start here walkthrough has a SaaSAllTheThings version (building a SaaS, including the assessment of an existing app), accurate to the latest release, reached from the overview and the SaaSAllTheThings page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T120 · The home page and the Godot-Director page link the start pages · done · XS · agent
- Depends on: T113
- Touches: docs/index.md, docs/frameworks/godot-director.md
- Done when: the home page's "where do I start?" link leads to the How-to overview or names the three start pages, and the Godot-Director page's Install section links "Where do I start with a game?" as the other two framework pages link theirs (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T126 · App-Director first in the How-to section · done · S · agent
- Depends on: T125
- Touches: docs/how-to/start.md, docs/how-to/start-app.md, docs/how-to/start-game.md (new name), docs/how-to/index.md, docs/how-to/*.md, docs/index.md, mkdocs.yml, docs/frameworks/*.md, selftest.sh
- Done when: "Where do I start?" (docs/how-to/start.md, the section's stable address) is the App-Director walkthrough, the game walkthrough moves to its own address, and the nav, the overview, the home page and the framework pages list and link the three in the order app, game, SaaS (check) · How-to pages that use one framework as their example use App-Director unless the skill is only in another, and the existing-project page's sections follow the same order (check) · no link to the old addresses is left, and the selftest's How-to link checks still pass (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T127 · Godot-Director: the play log base and the logging rules · done 2026-10-17 · L · agent
- Note: built, reviewed (nine findings fixed) and committed on ddd/autoplay; published with the other stages as one pull request (T131).
- PRs: Godot-Director #25 (merged)
- Depends on: -
- Touches: work/Godot-Director: framework/tools/play_log_base.gd (new), project/tools/play_log.gd (new), framework/.godot-director/rules.md, framework/tools/check.sh, check.gd, setup-clone.sh and ui_capture.sh (the minimum Godot 4.5), framework/.godot-director/procedures/ui-design.md, framework/.godot-director/templates/release-workflow.yml, install.sh, skills/godot-director/SKILL.md, README.md, ONBOARDING.md, PRIVACY.md, CLAUDE.md, examples/market-day/*, selftest.sh
- Done when: the play log base writes the per-run text log and its JSONL twin with stable event ids, the session header, startup buffering, flush per line, the engine Logger (Godot 4.5), the tail, start_capture() for tests, scrubbing, and nothing under the check, with the project hooks the spec names (spec section 3.1) (check) · rules.md has the logging, drivability, agent-visible state, seeded randomness and privacy rules (spec section 4) (check) · the minimum Godot is 4.5 everywhere it's stated and checked, and the check loads every script and scene under the screen dirs (spec section 3.5, last point) (check) · following AGENTS.md › Project rules for framework work; built on the branch `ddd/autoplay`, published with the other stages as one pull request (check)
- Brief: Scope › Planned framework changes

### T128 · Godot-Director: autoplay drives the real game · done 2026-10-17 · L · agent
- Note: built, reviewed (nine findings fixed) and committed on ddd/autoplay; published with the other stages as one pull request (T131).
- PRs: Godot-Director #25 (merged)
- Depends on: T127
- Touches: work/Godot-Director: framework/tools/autoplay.sh, autoplay.gd, autoplay_adapter_base.gd, autoplay_catalog.gd (new), framework/tools/ui_lint.gd and ui_capture.gd (the shared element-map writer), project/tools/autoplay_adapter.gd, autoplay_scenarios.gd, autoplay_invariants.gd (new seeds), install.sh (.gitignore and .gitattributes lines), examples/market-day/*, selftest.sh, CHANGELOG.md
- Done when: `bash tools/autoplay.sh <scenario|--all>` launches the real game through the main scene with the autoplay meta, drives it through the adapter by real input and API calls from scripted and strategy (random, greedy, end-the-turn) scenarios, requires a smoke scenario, writes screenshots and element maps at the spec's moments into `playtesting/autoplay/<run>/`, checks the framework invariants and the project's, writes a replayable repro on every failure, replays with `--replay`, and is deterministic from a seed (spec section 3.2); the spec's three planted bugs are found with a signature-ready finding line, step, screenshot and repro (spec section 6; signatures come with T129) (check) · following AGENTS.md › Project rules for framework work; built on the branch `ddd/autoplay`, published with the other stages as one pull request (check)
- Brief: Scope › Planned framework changes

### T129 · Godot-Director: log review with stable signatures · done 2026-10-17 · M · agent
- Note: built and committed on ddd/autoplay; published with the other stages as one pull request (T131).
- PRs: Godot-Director #25 (merged)
- Depends on: T128
- Touches: work/Godot-Director: tools/log_review.sh and log_review.gd (new), the playtesting/signatures.tsv seed, selftest.sh
- Done when: `bash tools/log_review.sh [<run>|--latest|--player]` writes review.md and findings.json with the timeline, the findings by signature (the normalisation from the spec, with a fixture carrying signatures.py's cases), coverage and the delta against the previous run, and `--check sig-xxxx` confirms a fix from signatures.tsv (spec section 3.3) (check) · following AGENTS.md › Project rules for framework work; built on the branch `ddd/autoplay`, published with the other stages as one pull request (check)
- Brief: Scope › Planned framework changes

### T130 · Godot-Director: the dev menu base and its onboarding step · done 2026-10-17 · M · agent
- Note: built and committed on ddd/autoplay; published with the other stages as one pull request (T131). The flag enables the F12 key in any build; a game that answers setting or flag keeps the two dev menu files in release exports.
- PRs: Godot-Director #25 (merged)
- Depends on: T127
- Touches: work/Godot-Director: the dev menu base (new), the project seed, ONBOARDING.md, rules.md, selftest.sh
- Done when: a framework-owned dev menu base (one tab per system through public APIs and debug hooks, an inspector for hidden values, a Log tab from the play log's tail, debug builds only) ships with a project seed, and onboarding asks whether the director wants a dev menu in the game and how to enable it (a setting, in game, or a command-line flag at start), recording the answer in the project's rules (check) · following AGENTS.md › Project rules for framework work; built on the branch `ddd/autoplay`, published with the other stages as one pull request (check)
- Brief: Scope › Planned framework changes

### T131 · Godot-Director: /autoplay and the workflow hooks · done 2026-10-17 · M · agent
- PRs: Godot-Director #25 (merged)
- Note: the fifth stage on ddd/autoplay; #25 carries all five, each a commit. Its title and body describe the whole feature, set after work-publish.sh opened it from the first commit.
- Depends on: T128, T129, T130
- Touches: work/Godot-Director: procedures/autoplay.md and the /autoplay skill (new), rules.md (the request table: "check the logs"), next-task.md and build.md (the (autoplay) tag, smoke before reporting), review.md, function-check.md, playtest.md, align.md, tools/check.cfg ([autoplay]), check.sh, install.sh and the manifest (the .gitignore lines are T128's), the hooks' allowed commands, README.md, CHANGELOG.md, selftest.sh
- Done when: the procedure and skill run, review and replay as spec section 3.4 says, every named procedure uses autoplay as the spec says, the check runs smoke headless under `[autoplay] check_in_check` with `enforce` (on for new projects, off on upgrade, missing keys read as off), a new project gets everything wired so that `bash tools/autoplay.sh smoke` exits 0 in a fresh project made by the skill (a seed that drives the main scene, or a clean skip that names the adapter to wire; the PLACEHOLDER seeds alone exit 1 today) and an upgrade gets the seeds plus a TASKS item (spec section 5), and the docs say what is framework-owned and what is project-owned and how an assistant without image viewing reviews from element maps (spec section 6) (check) · the play log names the current view when a run starts without a view change, so a run's log and review always carry its first view (found by T128 and T129) (check) · the whole feature is one open pull request, each stage one commit, with the selftest passing (check) · following AGENTS.md › Project rules for framework work; built on the branch `ddd/autoplay`, published with the other stages as one pull request (check)
- Brief: Scope › Planned framework changes

### T137 · Release Godot-Director 4.0.0 · done 2026-10-17 · S · agent
- PRs: Godot-Director #26 (merged); v4.0.0 tagged and published
- Depends on: -
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, CHANGELOG.md
- Done when: the release pull request bumps the version files, turns Unreleased into the 4.0.0 heading, passes the selftest and carries the release notes (How to install with Godot 4.5 or newer, What's changed, the upgrade steps) as its description (check) · once merged, `bash tools/work-release.sh work/Godot-Director <pr>` tags v4.0.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T139 · Release Godot-Director 4.1.0 · done 2026-10-17 · S · agent
- PRs: Godot-Director #28 (merged); v4.1.0 tagged and published
- Depends on: T138
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/godot-director/SKILL.md, CHANGELOG.md
- Done when: the release pull request bumps the version files, turns Unreleased into the 4.1.0 heading, passes the selftest and carries the release notes (How to install, What's changed, the upgrade steps) as its description (check) · once merged, `bash tools/work-release.sh work/Godot-Director <pr>` tags v4.1.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T140 · Release Godot-Director 4.1.1 · done 2026-10-17 · S · agent
- Depends on: T136
- PRs: Godot-Director #30 (merged); v4.1.1 tagged and published
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/godot-director/SKILL.md, CHANGELOG.md
- Done when: the release pull request moves T136's changelog bullet out of the 4.1.0 section (where the merge of #29 after #28 put it; v4.1.0 doesn't ship it) under a 4.1.1 heading, bumps the version files, passes the selftest and carries the release notes as its description (check) · once merged, `bash tools/work-release.sh work/Godot-Director <pr>` tags v4.1.1 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T141 · Docs links follow Godot-Director 4.1.0 · done 2026-10-17 · XS · agent
- Depends on: T139
- Touches: docs/**/*.md (links into Freakling/Godot-Director)
- Done when: every link into Godot-Director points at v4.1.0, and no page text changes, since the release adds an adapter hook the pages don't describe (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features

### T142 · Docs links follow Godot-Director 4.1.1 · done 2026-10-17 · XS · agent
- Depends on: T140
- Touches: docs/**/*.md (links into Freakling/Godot-Director)
- Done when: every link into Godot-Director points at v4.1.1, and no page text changes, since the release changes the installer's manifest, which the pages don't describe (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features

### T134 · App-Director: an install from a non-release source marks itself unreleased · done 2026-10-18 · S · agent
- PRs: App-Director #22 (merged)
- Depends on: -
- Touches: work/App-Director: install.sh (the manifest's version line and the closing message), selftest.sh
- Done when: the manifest records the source commit, and when the source CHANGELOG.md has an Unreleased section with entries the version reads `<version> + unreleased (<commit>)` and the install's closing lines say so; an install from a release records the plain version (test) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T135 · SaaSAllTheThings: an install from a non-release source marks itself unreleased · done 2026-10-18 · S · agent
- PRs: SaaSAllTheThings #15 (merged)
- Depends on: -
- Touches: work/SaaSAllTheThings: install.sh (the manifest's version line and the closing message), selftest.sh
- Done when: the manifest records the source commit, and when the source CHANGELOG.md has an Unreleased section with entries the version reads `<version> + unreleased (<commit>)` and the install's closing lines say so; an install from a release records the plain version (test) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T136 · Godot-Director: an install from a non-release source marks itself unreleased · done 2026-10-17 · S · agent
- Depends on: T137
- PRs: Godot-Director #29 (merged)
- Touches: work/Godot-Director: install.sh (the manifest's version line and the closing message), selftest.sh
- Done when: the manifest records the source commit, and when the source CHANGELOG.md has an Unreleased section with entries the version reads `<version> + unreleased (<commit>)` and the install's closing lines say so; an install from a release records the plain version (test) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T138 · Godot-Director: autoplay's no-focus invariant looks under the adapter's focus roots · done 2026-10-17 · M · agent
- PRs: Godot-Director #27 (merged)
- Depends on: -
- Touches: work/Godot-Director: framework/tools/autoplay_adapter_base.gd, framework/tools/autoplay.gd, project/tools/autoplay_adapter.gd, project/tools/autoplay_scenarios.gd, examples/market-day/tools/autoplay_adapter.gd, framework/.godot-director/procedures/autoplay.md, framework/.godot-director/rules.md, README.md, selftest.sh
- Done when: `focus_roots()` on the adapter base returns the view node by default, the no-focus invariant accepts a focus owner under any root, counts a SubViewport root's own focus owner, finds focusable controls under any root, skips the check on an empty list, and names the roots in its finding; `_pick` with every weight 0 picks nothing and smoke carries on to the progress action; the seeds and the example carry the hook and the weight-0 note; the procedure, rules.md and README describe it; the selftest covers the five cases in the spec (`init/godot-director-focus-root-prompt.md`) with the existing no-focus case still passing (check) · following AGENTS.md › Project rules for framework work; VERSION untouched, since versions move only in release pull requests (check)
- Brief: Scope › Planned framework changes

### T132 · Docs follow Godot-Director's auto-playtesting · done 2026-10-17 · S · agent
- Depends on: T131, T137
- Touches: docs/frameworks/godot-director.md, docs/how-to/*.md, docs/skills/*.md
- Done when: once released, the Godot-Director page lists /autoplay and the play log, the How-to question on checking what was built covers autoplay as a way, and the pages state the new minimum Godot (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### T133 · The Examples section, with PKSEI as the Godot-Director example · done 2026-10-17 · M · agent
- Depends on: -
- Touches: docs/examples/index.md (new), docs/examples/pksei.md (new), mkdocs.yml (nav), docs/index.md (the Built with section), docs/frameworks/godot-director.md, docs/frameworks/app-director.md, docs/frameworks/saasallthethings.md, docs/how-to/start-game.md, docs/how-to/start.md, docs/how-to/start-saas.md, docs/assets/stylesheets/ddd.css (if the widget needs a rule), selftest.sh (Examples in the Screens check if needed)
- Done when: the nav has Examples after Frameworks with an overview whose cards name PKSEI (Godot-Director), this site (App-Director) and the Azure SaaS post (SaaSAllTheThings), each with where to play or see it and where its records are (check) · the PKSEI page follows the brief's example page model, with the itch.io widget, every statement checked against Freakling/PKSEI and its devlog, and the numbers attributed to the devlog (check) · the home page's Built with section names the three examples and links the overview and the framework workflow page, and each framework page and Start here walkthrough links its example (check) · `bash tools/check.sh` passes, including the Screens page counts (check)
- Brief: Scope › Examples

### T143 · Release App-Director 1.7.1 · done 2026-10-18 · S · agent
- Depends on: T134
- PRs: App-Director #23 (merged); v1.7.1 tagged and published
- Touches: work/App-Director: VERSION, .claude-plugin/plugin.json, CHANGELOG.md, the other version files its CLAUDE.md lists
- Done when: the release pull request bumps the version files, turns Unreleased into the 1.7.1 heading, passes the selftest and carries the release notes as its description (check) · once merged, `bash tools/work-release.sh work/App-Director <pr>` tags v1.7.1 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T144 · Release SaaSAllTheThings 0.9.1 · done 2026-10-18 · S · agent
- Depends on: T135
- PRs: SaaSAllTheThings #16 (merged); v0.9.1 tagged and published
- Touches: work/SaaSAllTheThings: VERSION, .claude-plugin/plugin.json, every skill's version and `--branch` line, CHANGELOG.md
- Done when: the release pull request bumps the version files, turns Unreleased into the 0.9.1 heading, passes the selftest and carries the release notes (How to install, What's new, How to upgrade) as its description (check) · once merged, `bash tools/work-release.sh work/SaaSAllTheThings <pr>` tags v0.9.1 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T145 · Docs links follow App-Director 1.7.1 and SaaSAllTheThings 0.9.1 · done 2026-10-18 · XS · agent
- Depends on: T143, T144
- Touches: docs/**/*.md (links into Freakling/App-Director and Freakling/SaaSAllTheThings)
- Done when: every link into App-Director points at v1.7.1 and every link into SaaSAllTheThings at v0.9.1, and no page text changes, since both releases change the installer's manifest, which the pages don't describe (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features

### T91 · The selftest checks the brief's own claims · done · S · agent
- Depends on: -
- Touches: selftest.sh
- Done when: the selftest fails when a page count in the brief's Screens table differs from that section in `mkdocs.yml`'s nav (check) · it fails when a `Brief:` value in TASKS.md, or a brief heading named in `tools/`, isn't a heading in the brief (check) · it fails when a brief section whose heading starts with "Later" or "Planned" names an item that is done in TASKS.md or the archive (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Examples

### T92 · The align anchor: brief against reality · done · S · agent
- Depends on: -
- Touches: product/anchors/align.md (new)
- Done when: the anchor describes a "Brief against reality" step as `product/anchors/align.md` says: read the whole design doc, check every statement of state against the built product, done items and latest releases, and check every decision since the last `docs: align` commit instead of a spot check, with placeholders for each framework's design records (brief; PRD and ADRs; GDD) and where each looks for done items and releases (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T93 · App-Director: align checks the brief against reality · done · S · agent
- PRs: App-Director #17 (merged)
- Depends on: T92
- Touches: work/App-Director: framework/.app-director/procedures/align.md (one pull request; the director merges)
- Done when: App-Director has a merged pull request whose align procedure adds a "Brief against reality" step as `product/anchors/align.md` says: read the whole design doc, check every statement of state against the built product, done items and latest releases, and check every decision since the last `docs: align` commit instead of a spot check, adapted to the brief, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Common skills

### T94 · Godot-Director: align checks the GDD against reality · done · S · agent
- PRs: Godot-Director #20 (merged)
- Depends on: T92
- Touches: work/Godot-Director: framework/.godot-director/procedures/align.md (one pull request; the director merges)
- Done when: Godot-Director has a merged pull request whose align procedure adds a "Brief against reality" step as `product/anchors/align.md` says: read the whole design doc, check every statement of state against the built product, done items and latest releases, and check every decision since the last `docs: align` commit instead of a spot check, adapted to the GDD, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Common skills

### T95 · SaaSAllTheThings: align checks the PRD and ADRs against reality · done · S · agent
- PRs: SaaSAllTheThings #10 (merged)
- Depends on: T92
- Touches: work/SaaSAllTheThings: framework/.satt/procedures/align.md (one pull request; the director merges)
- Done when: SaaSAllTheThings has a merged pull request whose align procedure adds a "Brief against reality" step as `product/anchors/align.md` says: read the whole design doc, check every statement of state against the built product, done items and latest releases, and check every decision since the last `docs: align` commit instead of a spot check, adapted to the PRD and the ADRs, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Common skills

### T96 · The /align page describes the reality step · done · XS · agent
- Depends on: T93, T94, T95
- Touches: docs/skills/align.md
- Done when: once all three have released it, the /align page describes the brief-against-reality step (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T101 · The protected-space hook blocks absolute paths · done · S · agent · high
- PRs: Godot-Director #17 (merged), App-Director #16 (merged)
- Depends on: -
- Touches: work/Godot-Director: framework/.claude/hooks/guard-protected.sh, selftest.sh; work/App-Director: framework/.claude/hooks/guard-protected.sh, selftest.sh (one pull request per repo; the director squash-merges)
- Done when: in Godot-Director and App-Director, the hook blocks a write to `director/` whether Claude Code sends a relative path or an absolute one (Windows `C:\\...\\director\\x`, forward-slash and POSIX forms), resolved against the project root, and still allows paths that merely contain "director" elsewhere, with selftest cases for each, following AGENTS.md › Project rules for framework work (check)
- Note: found while building T85: the hook compares the raw path with `director/...`, and Claude Code sends absolute paths, so the protected space wasn't enforced. SaaSAllTheThings' new guard (T85) handles it.
- Brief: Scope › Orchestrator for the three frameworks

### T87 · App-Director: the human-written product brief · done · S · agent
- PRs: App-Director #19 (merged)
- Depends on: -
- Touches: work/App-Director: a project seed for the template, ONBOARDING.md, README.md (one pull request; the director merges)
- Done when: App-Director has a merged pull request with the director's product brief template (`product/anchors/templates/product_brief_template.md`) shipped into every project as a template for the human to fill in, presented in onboarding as an alternative or addition to the chat interview with a word on why it helps (value and context for later development), and scanned by onboarding for new and existing projects to build the initial assessment and design records, with what it inferred marked, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T88 · Godot-Director: the human-written GDD · done · S · agent
- PRs: Godot-Director #22 (merged)
- Depends on: -
- Touches: work/Godot-Director: a project seed for the template, ONBOARDING.md, README.md (one pull request; the director merges)
- Done when: Godot-Director has a merged pull request with the director's GDD template (`product/anchors/templates/godot_gdd_template.md`) shipped into every project as a template for the human to fill in, presented in onboarding as an alternative or addition to the chat interview with a word on why it helps (value and context for later development), and scanned by onboarding for new and existing projects to build the initial assessment and design records, with what it inferred marked, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T89 · SaaSAllTheThings: the human-written SaaS brief · done · M · agent
- PRs: SaaSAllTheThings #12 (merged)
- Depends on: -
- Touches: work/SaaSAllTheThings: a project seed for the template, ONBOARDING.md, the assessment procedure, README.md (one pull request; the director merges)
- Done when: SaaSAllTheThings has a merged pull request with a SaaS variant of the director's product brief template that also asks about enterprise architecture, requirements, security requirements and the control frameworks the customer must meet, worded for the human to answer and anchored in the customer's security framework, shipped into every project as a template for the human to fill in, presented in onboarding as an alternative or addition to the chat interview with a word on why it helps (value and context for later development), and scanned by onboarding for new and existing projects to build the initial assessment and design records, with what it inferred marked, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T121 · App-Director's README says "an agreed placeholder" · done · XS · agent
- PRs: App-Director #20 (merged)
- Note: `framework/.app-director/rules.md` line 27 says "the placeholder policy in AGENTS.md › Ownership" in the same sense, and the example's AGENTS.md has a "Placeholder policy" column header; both are framework files outside this item, left for the director to decide.
- Depends on: T87
- Touches: work/App-Director: README.md (one pull request; the director merges)
- Done when: the README's ownership line says human-owned areas get an agreed placeholder instead of generated content, in place of "a documented placeholder policy", following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T122 · Release Godot-Director 3.13.0 · done · S · agent
- PRs: Godot-Director #24 (merged); released as v3.13.0
- Depends on: T51
- Touches: work/Godot-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director squash-merges)
- Done when: the release pull request, which covers the align reality step (T94), the R counter (T119) and the human-written GDD (T88), is merged, and `tools/work-release.sh` has tagged `v3.13.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.13.0` and updates the pages for what it ships (check)
- Brief: Scope › Framework features

### T123 · Release SaaSAllTheThings 0.9.0 · done · S · agent
- PRs: SaaSAllTheThings #14 (merged); released as v0.9.0
- Depends on: T51
- Touches: work/SaaSAllTheThings: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director squash-merges)
- Done when: the release pull request, which covers the align reality step (T95), the R counter (T119) and the human-written SaaS brief (T89), is merged, and `tools/work-release.sh` has tagged `v0.9.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v0.9.0` and updates the pages for what it ships (check)
- Brief: Scope › Framework features

### T124 · Release App-Director 1.7.0 · done · S · agent
- PRs: App-Director #21 (merged); released as v1.7.0
- Depends on: T51, T121
- Touches: work/App-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director squash-merges)
- Done when: the release pull request, which covers the protected-space fix (T101), the .gitignore (T100), the align reality step (T93), the R counter and plugin update note (T119, T118), the human-written product brief (T87) and the README wording (T121), is merged, and `tools/work-release.sh` has tagged `v1.7.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v1.7.0` and updates the pages for what it ships (check)
- Brief: Scope › Framework features

### T125 · Docs follow App-Director 1.7.0, Godot-Director 3.13.0 and SaaSAllTheThings 0.9.0 · done · S · agent
- Depends on: T122, T123, T124
- Touches: docs/frameworks/*.md, docs/skills/*.md, docs/how-to/*.md
- Done when: every link into the three frameworks points at its latest release (check) · pages that describe onboarding or the protected space say what these releases changed, where they stated the old behaviour (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features

### T90 · The docs describe the starting document · done · XS · agent
- Depends on: T87, T88, T89
- Touches: docs/frameworks/*.md
- Done when: once all three have released it, each framework page says onboarding offers the human-written starting document and why it helps (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes
