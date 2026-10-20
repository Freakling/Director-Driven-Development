# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T168 · B5 · R7

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

### T148 · tools/usage.py measures what a project's Claude Code sessions cost · done 2026-10-19 · S · agent
- Depends on: -
- Touches: tools/usage.py (new), AGENTS.md (Architecture)
- Done when: `python tools/usage.py [<project>]` prints, per project under ~/.claude/projects, the API-equivalent total at the dated prices, the cost share by token kind, the orchestrating session's share, the director's keyboard hours and the agent's own hours, and the no-cache, all-Opus and all-Sonnet counterfactuals, taking one usage entry per message (the largest value per field); `--weekly` prints the per-week total across projects (check) · its PKSEI total matches the research note R1 (check)
- Brief: -

### T149 · App-Director: a builder always gets its model passed explicitly · in-progress 2026-10-21 · S · agent
- PRs: App-Director #27 (open)
- Depends on: -
- Touches: work/App-Director: framework/.app-director/procedures/next-task.md, framework/.app-director/rules.md, selftest.sh
- Done when: next-task.md says the orchestrator passes the builder's, reviewer's and researcher's model explicitly from the sizing table on every launch and never lets a subagent inherit the session's model, with the session model only when the table has no entry for the size; the selftest checks the wording (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: -

### T150 · Godot-Director: a builder always gets its model passed explicitly · in-progress 2026-10-21 · S · agent
- PRs: Godot-Director #34 (open)
- Depends on: -
- Touches: work/Godot-Director: framework/.godot-director/procedures/next-task.md, framework/.godot-director/rules.md, selftest.sh
- Done when: the same rule as T149 in Godot-Director's next-task procedure and rules, checked by its selftest; PKSEI's build ran 48 of 89 subagents on the session's Fable model, nearly 40 percent of its cost, because the model wasn't passed (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: -

### T151 · SaaSAllTheThings: a builder always gets its model passed explicitly · in-progress 2026-10-21 · S · agent
- PRs: SaaSAllTheThings #20 (open)
- Depends on: -
- Touches: work/SaaSAllTheThings: framework/.satt/procedures/next-task.md, framework/.satt/rules.md, selftest.sh
- Done when: the same rule as T149 in SaaSAllTheThings' next-task procedure and rules, checked by its selftest (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: -

### T152 · The docs reference the cost post · done 2026-10-19 · S · agent
- Depends on: -
- Touches: docs/concept/cost-built-in.md, docs/concept/cost-tuning.md, docs/how-to/cost.md, docs/index.md, docs/examples/pksei.md
- Done when: the two cost concept pages, the How-to cost question, the home page's Read more and the PKSEI example link the blog post "What directing AI agents costs: three projects, measured" as the measured reference, quoting only its headline figures with the post as the source (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Concepts

### T153 · Where do I start begins with writing it down · done 2026-10-20 · S · agent
- Depends on: -
- Touches: docs/how-to/start.md, docs/how-to/start-game.md, docs/how-to/start-saas.md, docs/how-to/index.md
- Done when: each Start here walkthrough has a step before Install: write what you want in your own words, with the framework's template linked at its latest release and what onboarding does with it; the How-to overview's first answer says the same in one line (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › How-to guides

### T154 · Godot-Director: the README starts with writing your own game design document · done 2026-10-20 · S · agent
- Depends on: -
- PRs: Godot-Director #31 (merged)
- Touches: work/Godot-Director: README.md, project/design/director-gdd.md, selftest.sh
- Done when: the README's how-to-use section opens with a Start here step before the install: write your game design document in your own words first, with a link to the template at the latest release tag, fill in what you know and leave the rest, then install and onboarding reads it and asks only what you left open; the template's header carries the same link so a copied file explains itself; the selftest checks both (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T155 · App-Director: the README starts with writing your own product brief · done 2026-10-20 · S · agent
- Depends on: -
- PRs: App-Director #24 (merged)
- Touches: work/App-Director: README.md, project/product/director-brief.md, selftest.sh
- Done when: the README's how-to-use section opens with a Start here step before the install: write your product brief in your own words first, with a link to the template at the latest release tag, fill in what you know and leave the rest, then install and onboarding reads it and asks only what you left open; the template's header carries the same link so a copied file explains itself; the selftest checks both (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T156 · SaaSAllTheThings: the README starts with writing your own product brief · done 2026-10-20 · S · agent
- Depends on: -
- PRs: SaaSAllTheThings #17 (merged)
- Touches: work/SaaSAllTheThings: README.md, project/product/director-brief.md, selftest.sh
- Done when: the README's how-to-use section opens with a Start here step before the install: write your product brief in your own words first, with a link to the template at the latest release tag, fill in what you know and leave the rest, then install and onboarding reads it and asks only what you left open; the template's header carries the same link so a copied file explains itself; the selftest checks both (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### R4 · How Director-Driven Development compares with other AI coding assistants and workflows · done 2026-10-20 · M · agent
- Depends on: -
- Note: product/research/2026-10-20-ddd-compared-with-other-ai-coding-workflows.md
- Question: On the dimensions DDD is built around (who decides vs who builds, context kept small per task, a check that defines done, records in files with a decision log, task sizing and model choice, independent review, drift handling, ownership and protected areas, cost), what do the main alternatives ship or prescribe, as of 2026: plain agent use (Claude Code, Cursor, Copilot agent mode, Codex, Gemini CLI), spec-driven workflows (Kiro, GitHub spec-kit, BMAD, other published methods), agent harnesses (OpenHands, Aider, Cline, Roo), autonomous agents (Devin, Codex cloud, Jules), and the vendors' own best-practice guides; where does DDD overlap, where is it alone, and where do others do more?
- Informs: -
- Brief: -

### R5 · Do other AI coding tools and workflows address production readiness, or stop at working · done 2026-10-20 · M · agent
- Depends on: R4
- Note: product/research/2026-10-20-production-readiness-of-ai-coding-tools.md
- Question: The director's framing: others help you make something that works; DDD aims at enterprise-ready, structured, automatically tested software you can prove is stable, testable and compliant. Is that distinction real? For the alternatives in R4, what do they ship or prescribe for production readiness: tests that gate (not just suggested), security and compliance checks, architecture rules, audit trails of decisions, operations and release, and evidence a reviewer or auditor can use; what do their vendors claim about enterprise use; and what independent evidence exists on AI-built code reaching production (defect, security and rework findings)? Where does DDD hold up, and where is the claim too strong?
- Informs: -
- Brief: -

### T157 · Godot-Director: the check times every test file and runs the suite in parallel · done 2026-10-21 · L · agent
- PRs: Godot-Director #32 (merged)
- Note: measured on The Guildkeeper: serial 955 s and 1,016 s, 12 jobs 341 s, identical counts, no parallel-only failures; the two 200 s map test files set the floor. Reviewed; three findings fixed.
- Depends on: -
- Touches: work/Godot-Director: framework/tools/check.gd, framework/tools/check.sh, project/tools/check.cfg, README.md, framework/.godot-director/rules.md, selftest.sh
- Done when: every run logs each test file's time and ends with a slowest-files summary; `--jobs N` (default from the CPU count, settable in check.cfg) splits the test files across N headless Godot processes, each in file order with its own log and its own timeout, and merges the results into one report with exit codes 0/1/3 unchanged; `--if-changed` and `--fingerprint` keep working; a run that hits the timeout says so instead of reading as a test failure; new check.cfg keys have defaults and an upgrade keeps existing settings; the docs say tests must isolate their autoload and user:// state and recommend one git worktree per parallel building session; CHANGELOG carries the upgrade notes (check) · measured on a scratch copy of The Guildkeeper (git archive of HEAD into a temp folder): the serial time, the parallel time, and the slowest-files summary, recorded in the item (check) · following AGENTS.md › Project rules for framework work; built on the branch `ddd/check-tiers`, one pull request (check)
- Brief: Scope › Framework features

### T158 · Godot-Director: a quick non-gating test mode for the builder, if the full run stays slow · todo · L · agent
- Depends on: T157
- Touches: work/Godot-Director: framework/tools/check.gd, framework/tools/check.sh, procedures/build.md, selftest.sh
- Done when: decided on T157's numbers: if the parallel full run on The Guildkeeper is over about three minutes, the builder gets a `--quick` mode that selects the tests relevant to the changed files (one step out through class_name, autoload name or res:// path, widening to everything when shared plumbing changes) and says which it chose and why, used while iterating and never as the gate; the full parallel run stays what Done means (check) · if the full run is fast enough, this item is dropped with a note (check) · following AGENTS.md › Project rules for framework work; built on the branch `ddd/check-tiers`, one pull request (check)
- Brief: Scope › Framework features

### T159 · Godot-Director: two gated tiers with a full-run cadence, as a project opt-in · todo · L · agent
- Depends on: T158
- Touches: work/Godot-Director: framework/tools/check.sh, framework/.godot-director/rules.md, procedures/*.md, framework/.claude/hooks/*, framework/.githooks/pre-commit, selftest.sh
- Done when: only if T158's quick mode is still too slow as a gate: a check.cfg opt-in, off by default, makes the quick mode the per-item gate with the item's autoplay scenarios, a full run every N commits and before a function check from a state file under .godot/godot-director/, and a full-run failure filed as a bug naming the commits since the last green run, with rules.md saying what Done means under the opt-in (the director's original spec, `init/godot-director-check-tiers-prompt.md`) (check) · following AGENTS.md › Project rules for framework work; built on the branch `ddd/check-tiers`, one pull request (check)
- Brief: Scope › Framework features

### T160 · App-Director: one git worktree per parallel building session · done 2026-10-20 · XS · agent
- PRs: App-Director #26 (merged)
- Depends on: -
- Touches: work/App-Director: framework/.app-director/rules.md, README.md, selftest.sh
- Done when: rules.md says that sessions building at the same time each use their own git worktree, since a shared checkout lets one session's unfinished files fail another's check and hook, with the command to make one and run tools/setup-clone.sh in it; the README's day-to-day section points to it; the selftest checks the rule exists (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T161 · SaaSAllTheThings: one git worktree per parallel building session · done 2026-10-20 · XS · agent
- PRs: SaaSAllTheThings #19 (merged)
- Depends on: -
- Touches: work/SaaSAllTheThings: framework/.satt/rules.md, README.md, selftest.sh
- Done when: the same rule as T160 in SaaSAllTheThings' rules and README, checked by its selftest (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### R6 · From proof of concept to production in an enterprise: the operating envelope, where people and process fail, and what SaaSAllTheThings brings · done 2026-10-21 · M · agent
- Depends on: R5
- Note: product/research/2026-10-21-production-readiness-operating-envelope-and-saasallthethings.md
- Question: What does production readiness mean for a business-critical system in an enterprise, beyond the code: infrastructure, monitoring and operations, compliance audits and the evidence they need, PII handling, access control to sensitive data and production environments, business continuity and disaster recovery, and cloud networking that can't exfiltrate through public endpoints; what do the main breach and incident reports (Verizon DBIR, IBM Cost of a Data Breach, Microsoft Digital Defense Report, Mandiant M-Trends, CSA top threats) say about how people, process and infrastructure hygiene fail, as against code vulnerabilities, with samples and editions; what the AI coding tools' security features cover at those layers (from R5, extended: CodeQL, secret scanning, Bugbot, Devin Review, Codex Security) and what enterprises use instead (Azure Policy, Defender for Cloud, IaC scanners) and where in the pipeline; and what SaaSAllTheThings does with an uploaded control framework such as the ISF Standard of Good Practice, from its own repository at the latest release: the assessment, the workshops (vision, tenancy and identity, integrations, operations, planning), the requirements and control framework in the repository, the architecture rules enforced in the check, the ADR exception path, and the records a compliance reviewer can read; which of "a full supply-chain view, more security and easier compliance proof than others" holds on those records, and which needs a deployment or an audit?
- Informs: -
- Brief: -

### T162 · Release Godot-Director 4.2.0 · done 2026-10-21 · S · agent
- PRs: Godot-Director #33 (merged); v4.2.0 tagged and published
- Depends on: T157
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/godot-director/SKILL.md, README.md and project/design/director-gdd.md (the template links), CHANGELOG.md
- Done when: the release pull request bumps every version file and the template links together, turns Unreleased into the 4.2.0 heading, passes the selftest and carries the release notes as its description (check) · once merged, `bash tools/work-release.sh work/Godot-Director <pr>` tags v4.2.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T163 · Godot-Director: the Bash guard blocks guessed waits on a background command · todo · S · agent
- Depends on: -
- Touches: work/Godot-Director: framework/.claude/hooks/guard-git.sh, framework/.claude/settings.json, selftest.sh
- Done when: the Bash guard, also run for Monitor, blocks an `until` or `while` loop with `sleep` that reads a background command's `tasks/<id>.output` without waiting for the `[exited with code N]` or `[killed]` line Claude Code appends when the command ends, and its message gives the loop that waits for that line; the selftest checks that it blocks a guessed-pattern loop and passes the marker loop and a loop on a file the command writes itself (check) · the guard still starts no other processes (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T164 · App-Director: the Bash guard blocks guessed waits on a background command · todo · S · agent
- Depends on: -
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, selftest.sh
- Done when: the same guard as T163 in App-Director's Bash guard, checked by its selftest (check) · the guard still starts no other processes (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T165 · SaaSAllTheThings: the Bash guard blocks guessed waits on a background command · todo · S · agent
- Depends on: -
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, selftest.sh
- Done when: the same guard as T163 in SaaSAllTheThings' Bash guard, checked by its selftest (check) · the guard still starts no other processes (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T166 · Docs follow Godot-Director 4.2.0 · done 2026-10-21 · S · agent
- Depends on: T162
- Touches: docs/frameworks/godot-director.md, docs/how-to/*.md, docs/skills/*.md, docs/concept/check.md
- Done when: every link into Godot-Director points at v4.2.0; the Godot-Director page and the How-to pages that describe the check say it times every test file, ends with the slowest files, runs the suite in parallel with `--jobs` (auto from the CPU count, settable in check.cfg) with a per-process timeout that reads as "couldn't run", and that test files must isolate their autoload and user:// state; the game walkthrough says to write the design document first from the template at the new tag (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features

### T167 · SaaSAllTheThings: its TASKS.md has one queue and unique IDs · todo · XS · agent
- Depends on: T151, T100
- Touches: work/SaaSAllTheThings: TASKS.md
- Done when: the root TASKS.md has one `## Queue` heading (today three, at about lines 9, 35 and 49), the two items numbered T9 ("The README starts with writing your own product brief" and "/ui-design with Playwright capture") have distinct IDs with references to them updated, and T10's Done when names its own repo's item rather than the docs repo's T160 (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Orchestrator for the three frameworks

### T98 · The director tests /ui-design in a game · todo · - · human
- Depends on: T97
- Touches: a Godot game of the director's, with Godot-Director 3.11.0
- Done when: the director has captured, drawn, processed and verified at least one screen with the released /ui-design, and said whether App-Director and SaaSAllTheThings should follow as the anchor says or after changes (demo)
- Brief: Scope › Planned framework changes

### T103 · /ui-design tells the director how to use Excalidraw · done 2026-10-20 · S · agent
- PRs: Godot-Director #18 (merged), App-Director #25 (merged), SaaSAllTheThings #18 (merged)
- Depends on: T83
- Touches: product/anchors/ui-design.md; work/Godot-Director: framework/.godot-director/procedures/ui-design.md, project/design/ui/README.md, examples/market-day/design/ui/README.md (one pull request; the director squash-merges); work/App-Director and work/SaaSAllTheThings: the same files on the local branches ddd/T84 and ddd/T85 (no push until T98)
- Done when: whenever /ui-design hands the director a starter drawing, it says plainly that nothing needs installing (excalidraw.com in the browser, no account, Excalidraw+ not needed), how to open the starter (the menu's Open, or drag the file in), how to save it to `director/ui/<screen>.excalidraw` (Save to… or Ctrl+S; Chrome and Edge let you pick the folder, other browsers save to Downloads, so move and rename it), and that the drawing stays on the machine unless Live collaboration or a shareable link is used (check) · the anchor and the drawing guide each project gets say the same (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T84 · App-Director: /ui-design with Playwright capture · done 2026-10-20 · L · agent
- PRs: App-Director #25 (merged); the UAT hold lifted by the director on 2026-10-20
- Depends on: T83
- Touches: work/App-Director (one pull request; the director merges)
- Note: built, reviewed (nine findings fixed) and committed locally on ddd/T84 (a637da3); no push and no pull request until T98 (the director's UAT) is done, then update from the anchor and publish. Before publishing, fix the selftest's two off-machine note checks, whose `^` anchors match only when that note comes first (found in T85).
- Done when: once Godot-Director has released /ui-design, App-Director has a merged pull request that builds it from the anchor with the Playwright adapter for web apps, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T85 · SaaSAllTheThings: /ui-design with Playwright capture · done 2026-10-20 · L · agent
- PRs: SaaSAllTheThings #18 (merged); the UAT hold lifted by the director on 2026-10-20
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
- PRs: Godot-Director #16 (merged). App-Director: ba91b84 on main (a one-off test push). SaaSAllTheThings #21 (open)
- Note: the plugin directory's scanner accepts a commit it detects as a tagged release (v1.2.3, v1.3.0, v1.3.1 and, on 2026-10-16, Godot-Director v3.13.0, a GitHub squash merge) and reports every bare commit as "files the scanner won't accept", including release commits tagged after the scheduled check first saw them. Neither the files nor GitHub-made commits were the cause. The rule that follows: tag a release right after its merge, which tools/work-release.sh does.
- Depends on: -
- Touches: work/Godot-Director: .gitignore; work/App-Director: .gitignore; work/SaaSAllTheThings: .gitignore (one pull request per repo; the director squash-merges)
- Done when: each framework's own `.gitignore` ignores `.DS_Store`, `Thumbs.db`, `desktop.ini` and `__MACOSX/`, as the plugin directory's scanner asks, in a pull request the director squash-merges to test whether single-parent commits pass the scan, following AGENTS.md › Project rules for framework work (check)
- Note: Godot-Director and App-Director carry it; SaaSAllTheThings' copy is #21, and the item is done when it merges.
- Brief: Scope › Orchestrator for the three frameworks

### T102 · The secrets scan doesn't flag drawings · todo · S · agent
- Depends on: T84, T85
- Touches: work/App-Director and work/SaaSAllTheThings: the secrets step of framework/tools/check.sh or the gitleaks config seed (one pull request per repo; the director squash-merges)
- Done when: a committed drawing in `director/ui/*.excalidraw`, whose embedded base64 screenshot can match a key pattern, doesn't fail the check, while a real key in any other file still does, following AGENTS.md › Project rules for framework work (check)
- Note: found while building T85. Ships with /ui-design, so it waits for T84 and T85.
- Brief: Scope › Planned framework changes

## Notes
