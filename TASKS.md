# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T197 · B5 · R7

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

### T149 · App-Director: a builder always gets its model passed explicitly · done 2026-10-21 · S · agent
- PRs: App-Director #27 (merged)
- Depends on: -
- Touches: work/App-Director: framework/.app-director/procedures/next-task.md, framework/.app-director/rules.md, selftest.sh
- Done when: next-task.md says the orchestrator passes the builder's, reviewer's and researcher's model explicitly from the sizing table on every launch and never lets a subagent inherit the session's model, with the session model only when the table has no entry for the size; the selftest checks the wording (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: -

### T150 · Godot-Director: a builder always gets its model passed explicitly · done 2026-10-21 · S · agent
- PRs: Godot-Director #34 (merged)
- Depends on: -
- Touches: work/Godot-Director: framework/.godot-director/procedures/next-task.md, framework/.godot-director/rules.md, selftest.sh
- Done when: the same rule as T149 in Godot-Director's next-task procedure and rules, checked by its selftest; PKSEI's build ran 48 of 89 subagents on the session's Fable model, nearly 40 percent of its cost, because the model wasn't passed (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: -

### T151 · SaaSAllTheThings: a builder always gets its model passed explicitly · done 2026-10-21 · S · agent
- PRs: SaaSAllTheThings #20 (merged)
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
- Note: the release commit's gate, the selftest without Godot, was run by the director's other session after the merge: 152 passed, 0 failed.
- Depends on: T157
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/godot-director/SKILL.md, README.md and project/design/director-gdd.md (the template links), CHANGELOG.md
- Done when: the release pull request bumps every version file and the template links together, turns Unreleased into the 4.2.0 heading, passes the selftest and carries the release notes as its description (check) · once merged, `bash tools/work-release.sh work/Godot-Director <pr>` tags v4.2.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T163 · Godot-Director: the Bash guard blocks hangs: empty Python heredocs, unbounded waits and Godot runs without a time limit · done 2026-10-25 · M · agent
- Depends on: -
- PRs: Godot-Director #39 (merged)
- Note: selftest 718 passed, 0 failed on a quiet machine; a first run while two other framework selftests used the machine failed two capture and autoplay cases this item doesn't touch.
- Touches: work/Godot-Director: framework/.claude/hooks/guard-git.sh, framework/.claude/settings.json, framework/.godot-director/rules.md, selftest.sh
- Done when: the Bash guard (also run for Monitor) blocks, each with a message that says why and gives the form that works: (1) Python, `python3`, `py` or their `.exe` reading `-` from a heredoc whose body is empty, the "is Python here?" probe, which on Windows waits for console input and never returns (the message: test with `python3 --version`); (2) an `until` or `while` loop with `sleep` that isn't under `timeout N` with N of 280 or less, and a loop that reads a background command's `tasks/<id>.output` without waiting for the `[exited with code N]` or `[killed]` line Claude Code appends when the command ends; (3) a direct Godot run (the binary named by `$GODOT_BIN`, `tools/godot_bin.local` or `godot`, with `--headless`, `--script` or `--import`) that isn't under `timeout N` with N of 280 or less, since a scratch script that fails to compile keeps Godot running until it is killed (the framework's own `tools/check.sh`, `tools/autoplay.sh` and `tools/ui_capture.sh` cap their runs and are allowed); (4) a lone `sleep` over 280 seconds; the 280-second limit keeps a wait inside the five-minute prompt cache, so the turn after it doesn't rewrite the whole context; the selftest proves each block and passes the forms that work (a non-empty Python heredoc, a loop under `timeout 240`, the exit-marker loop, a short sleep) (check) · `rules.md` says in one place: give every command that may run long a time limit under five minutes, start a long check with `run_in_background` and keep working until its completion notice instead of polling, and never probe for a tool with an empty heredoc (check) · the guard still starts no other processes (check) · a CHANGELOG entry under Unreleased (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T164 · App-Director: the Bash guard blocks hangs, and the check limits its test runs · done 2026-10-25 · M · agent
- Depends on: -
- PRs: App-Director #32 (merged)
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, framework/.app-director/rules.md, framework/tools/check.sh, project/tools/check.cfg, selftest.sh
- Done when: the Bash guard (also run for Monitor) blocks, each with a message that says why and gives the form that works: (1) Python, `python3`, `py` or their `.exe` reading `-` from a heredoc whose body is empty, the "is Python here?" probe, which on Windows waits for console input and never returns (the message: test with `python3 --version`); (2) an `until` or `while` loop with `sleep` that isn't under `timeout N` with N of 280 or less, and a loop that reads a background command's `tasks/<id>.output` without waiting for the `[exited with code N]` or `[killed]` line Claude Code appends when the command ends; (3) a lone `sleep` over 280 seconds; the 280-second limit keeps a wait inside the five-minute prompt cache, so the turn after it doesn't rewrite the whole context; the selftest proves each block and passes the forms that work (a non-empty Python heredoc, a loop under `timeout 240`, the exit-marker loop, a short sleep) (check) · `rules.md` says in one place: give every command that may run long a time limit under five minutes, start a long check with `run_in_background` and keep working until its completion notice instead of polling, and never probe for a tool with an empty heredoc (check) · the guard still starts no other processes (check) · a CHANGELOG entry under Unreleased (check) · following AGENTS.md › Project rules for framework work (check) · `tools/check.sh` limits each test command it runs with `timeout` when GNU timeout is available ([tests] timeout in `tools/check.cfg`, default 600, an upgrade keeps existing settings), and a run that hits the limit exits 3 and says so instead of reading as a pass or a test failure, as Godot-Director's check does (check)
- Brief: Scope › Framework features

### T165 · SaaSAllTheThings: the Bash guard blocks hangs, and the check limits its test runs · done 2026-10-25 · M · agent
- Depends on: -
- PRs: SaaSAllTheThings #26 (merged)
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, framework/.satt/rules.md, framework/tools/check.sh, project/tools/check.cfg, selftest.sh
- Done when: the Bash guard (also run for Monitor) blocks, each with a message that says why and gives the form that works: (1) Python, `python3`, `py` or their `.exe` reading `-` from a heredoc whose body is empty, the "is Python here?" probe, which on Windows waits for console input and never returns (the message: test with `python3 --version`); (2) an `until` or `while` loop with `sleep` that isn't under `timeout N` with N of 280 or less, and a loop that reads a background command's `tasks/<id>.output` without waiting for the `[exited with code N]` or `[killed]` line Claude Code appends when the command ends; (3) a lone `sleep` over 280 seconds; the 280-second limit keeps a wait inside the five-minute prompt cache, so the turn after it doesn't rewrite the whole context; the selftest proves each block and passes the forms that work (a non-empty Python heredoc, a loop under `timeout 240`, the exit-marker loop, a short sleep) (check) · `rules.md` says in one place: give every command that may run long a time limit under five minutes, start a long check with `run_in_background` and keep working until its completion notice instead of polling, and never probe for a tool with an empty heredoc (check) · the guard still starts no other processes (check) · a CHANGELOG entry under Unreleased (check) · following AGENTS.md › Project rules for framework work (check) · `tools/check.sh` limits each test command it runs with `timeout` when GNU timeout is available ([tests] timeout in `tools/check.cfg`, default 600, an upgrade keeps existing settings), and a run that hits the limit exits 3 and says so instead of reading as a pass or a test failure, as Godot-Director's check does (check)
- Brief: Scope › Framework features

### T166 · Docs follow Godot-Director 4.2.0 · done 2026-10-21 · S · agent
- Depends on: T162
- Touches: docs/frameworks/godot-director.md, docs/how-to/*.md, docs/skills/*.md, docs/concept/check.md
- Done when: every link into Godot-Director points at v4.2.0; the Godot-Director page and the How-to pages that describe the check say it times every test file, ends with the slowest files, runs the suite in parallel with `--jobs` (auto from the CPU count, settable in check.cfg) with a per-process timeout that reads as "couldn't run", and that test files must isolate their autoload and user:// state; the game walkthrough says to write the design document first from the template at the new tag (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features

### T174 · Release App-Director 1.8.0 · done 2026-10-24 · S · agent
- PRs: App-Director #28 (merged); v1.8.0 tagged and published
- Depends on: T149
- Touches: work/App-Director: VERSION, .claude-plugin/plugin.json, package.json, .claude-plugin/marketplace.json, SKILL.md, skills/app-director/SKILL.md, scripts/fetch-app-director.sh, README.md, project/product/director-brief.md and the example's copy (the template links), CHANGELOG.md, selftest.sh (the snapshot tests' versions)
- Done when: the release pull request bumps every version file and the template links together, turns Unreleased into the 1.8.0 heading, passes the selftest and carries the release notes as its description (check) · once merged, `bash tools/work-release.sh work/App-Director <pr>` tags v1.8.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T175 · Release SaaSAllTheThings 0.10.0 · done 2026-10-24 · S · agent
- PRs: SaaSAllTheThings #22 (merged); v0.10.0 tagged and published
- Depends on: T151, T100
- Touches: work/SaaSAllTheThings: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, every skill's SKILL.md (version and `--branch`), README.md and the brief template links, CHANGELOG.md
- Done when: the release pull request bumps every version file and the template links together, turns Unreleased into the 0.10.0 heading, passes the selftest and carries the release notes as its description (check) · once merged, `bash tools/work-release.sh work/SaaSAllTheThings <pr>` tags v0.10.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T176 · Release Godot-Director 4.2.1 · done 2026-10-24 · S · agent
- PRs: Godot-Director #35 (merged); v4.2.1 tagged and published
- Depends on: T150
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/godot-director/SKILL.md, README.md, project/design/director-gdd.md and examples/market-day/design/director-gdd.md (the template links), CHANGELOG.md
- Done when: the release pull request bumps every version file and the template links together, turns Unreleased into the 4.2.1 heading, passes the selftest and carries the release notes as its description (check) · once merged, `bash tools/work-release.sh work/Godot-Director <pr>` tags v4.2.1 and publishes the release (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T178 · Docs follow App-Director 1.8.0, SaaSAllTheThings 0.10.0 and Godot-Director 4.2.1 · done 2026-10-24 · M · agent
- Depends on: T174, T175, T176
- Touches: docs/frameworks/*.md, docs/how-to/*.md, docs/skills/*.md, docs/concept/*.md, product/brief.md
- Done when: every link into the three repos points at its latest release (check) · the App-Director and SaaSAllTheThings pages and the How-to pages describe what their releases ship: `/ui-design` for web clients (with SaaSAllTheThings' dev-environment capture), the README's start-here step with the brief template, one git worktree per building session, and every subagent launch passing its model explicitly; the Godot-Director page says the same of the model rule; each statement checked against the release (check) · the brief moves `/ui-design` from Planned framework changes to Framework features, now that all three ship it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features

### T179 · SaaSAllTheThings: the README says a claim protects only its own worktree · done 2026-10-25 · XS · agent
- Depends on: -
- PRs: SaaSAllTheThings #27 (merged)
- Touches: work/SaaSAllTheThings: README.md
- Done when: the README's sentence that an `in-progress` claim stops two sessions touching the same item says what `rules.md` says instead: a claim protects only its own worktree, and sessions that build at the same time each take a git worktree (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Framework features

### T167 · SaaSAllTheThings: its TASKS.md has one queue and unique IDs · in-progress 2026-10-25 · XS · agent
- Depends on: T151, T100
- PRs: SaaSAllTheThings #28 (open)
- Touches: work/SaaSAllTheThings: TASKS.md
- Done when: the root TASKS.md has one `## Queue` heading (today three, at about lines 9, 35 and 49), the two items numbered T9 ("The README starts with writing your own product brief" and "/ui-design with Playwright capture") have distinct IDs with references to them updated, and T10's Done when names its own repo's item rather than the docs repo's T160 (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Orchestrator for the three frameworks

### T168 · The SaaSAllTheThings page says what its records show for production and compliance · done 2026-10-25 · S · agent
- Depends on: -
- Touches: docs/frameworks/saasallthethings.md
- Done when: a short section in the brief's wording: the check fails the build on broken architecture and security requirements, with exceptions only through an ADR the director accepts; the requirements and the customer's control framework live in the repository and every architecture session reads them; every decision and change leaves a record a reviewer can read; the running system provides the operating evidence; each statement checked against SaaSAllTheThings' latest release (check) · no page says production-ready, compliant, more secure than others, a full supply-chain view or cannot exfiltrate (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › What the site claims for production and compliance

### T169 · SaaSAllTheThings: the check fails public network access and local authentication in Bicep · in-progress 2026-10-25 · M · agent
- Depends on: -
- PRs: SaaSAllTheThings #29 (open)
- Review: existing references were failed and a resource's text ran past its closing brace (fixed, with selftest cases); block comments, strings and whole-word true/false tidied.
- Touches: work/SaaSAllTheThings: framework/.satt/reference/network.md (new), framework/.satt/reference/README.md, framework/.satt/reference/cost.md, framework/tools/archcheck.awk, project/tools/check.cfg, ONBOARDING.md, skills/saas-design-session/references/ (bundle), selftest.sh
- Done when: a new rule, named in reference/README.md › What the check enforces, archcheck.awk and selftest.sh, fails a Bicep resource that leaves public network access enabled or local authentication on, for the resource types the reference architecture uses where Azure offers the setting, and an accepted ADR with an exception for the rule and path excuses it (check) · the network topic gives the default posture, and cost.md says private-only needs Service Bus Premium, so an ADR with a `cost-sku` exception (check) · the rule is on for new apps and off on upgrade until the app turns it on in check.cfg, as the CHANGELOG's upgrade steps say (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T170 · SaaSAllTheThings: a shipped CI workflow keeps the check's output as evidence · todo · M · agent
- Depends on: -
- Touches: work/SaaSAllTheThings: framework/.satt/templates/check-workflow.yml (new), ONBOARDING.md, framework/.satt/procedures/release.md, selftest.sh
- Done when: a GitHub Actions workflow template runs `bash tools/check.sh` on every pull request and push to main and uploads its output and logs as an artifact, with how long it's kept left to the app's setting; onboarding offers to install it for new and existing apps; the selftest checks the template's steps (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T171 · SaaSAllTheThings: a compliance mapping table that review and align read · todo · M · agent
- Depends on: -
- Touches: work/SaaSAllTheThings: project/compliance/mapping.md (new), framework/.satt/procedures/architect.md, framework/.satt/procedures/review.md, framework/.satt/procedures/align.md, ONBOARDING.md, skills/saas-design-session/references/ (bundle), selftest.sh
- Done when: a seeded table with control id, requirement, met by (rule, ADR or test), label (direct, partial, interpretive or unverified) and evidence location; architecture sessions add or update rows as ADRs are accepted, review flags a change to a mapped rule, ADR or test that leaves its row stale, and align reports rows whose rule, ADR or test no longer exists; nothing marks a control met from a framework's name (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T172 · SaaSAllTheThings: dependency review and an SBOM in the shipped workflow · todo · S · agent
- Depends on: T170
- Touches: work/SaaSAllTheThings: framework/.satt/templates/check-workflow.yml, framework/.satt/reference/infra.md, selftest.sh
- Done when: the shipped workflow reviews dependency changes on pull requests and exports an SPDX SBOM from GitHub's dependency graph as an artifact, and the reference says what that covers and that vulnerability response stays the customer's process (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T177 · Godot-Director: the screen-design README is organised by feature · done 2026-10-24 · M · agent
- Depends on: -
- PRs: Godot-Director #36 (merged)
- Touches: work/Godot-Director: project/design/ui/README.md, examples/market-day/design/ui/README.md
- Done when: `project/design/ui/README.md` (installed as `design/ui/README.md`; the market-day copy identical) is rewritten with one section per feature, each saying what it is for and how to use it: what the folder holds; the workflow in four short steps (capture, draw, save, process); what a capture gives you (the starter file, the map image, the numbered grey reference boxes, the legend); boxes and their keys; the colour code; containment, arrows and notes; patch and replace modes; other states and sizes; re-arranging a screen (a blue box named after the element where it should now sit; the grey boxes are a locked reference the agent does not read); verify; Excalidraw itself (open, save, where the file lives, privacy) as a reference section near the end; a closing table of the files and who owns each · nothing the current README says is lost and nothing is added that the tools don't do, checked against `framework/tools/ui_drawing.gd` and `procedures/ui-design.md` · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T180 · Godot-Director: re-arrange a screen by dragging its existing boxes · done 2026-10-25 · M · agent
- Depends on: T177
- PRs: Godot-Director #37 (merged)
- Review: stale starters would have read as moves (fixed: the box is compared with the rectangle the starter stored on it); the fixture had a moved box and a red X on one element (fixed, and a note per element claimed twice); out-of-frame, missing map entry and hidden or deleted boxes covered.
- Touches: work/Godot-Director: framework/tools/ui_drawing.gd, project/design/ui/README.md, examples/market-day/design/ui/README.md, tests/ui-drawing/*, selftest.sh
- Done when: the starter drawing's grey numbered boxes of the current elements are no longer locked, and the reader treats one that the human moved or resized as a blue "keep, move or resize" of that element (its name from the map, the new rectangle, any keys typed into it), while an untouched one is still skipped; a deleted or hidden one changes nothing; the fixture drawing and its expected output cover a moved, a resized and an untouched box; `design/ui/README.md` › Re-arranging a screen says you can drag the grey box to where the element should sit, and the Colours section says blue is still how you draw a move with a new box; the starter in `tests/ui-drawing/starter.expected.excalidraw` matches (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T181 · App-Director: the screen-design README is organised by feature · done 2026-10-25 · S · agent
- Depends on: T177
- PRs: App-Director #29 (merged)
- Touches: work/App-Director: project/product/ui/README.md
- Done when: `project/product/ui/README.md` (installed as `product/ui/README.md`) has the section order and wording of Godot-Director #36's `design/ui/README.md`, with the app framework's paths, commands and setup (Node, Playwright, the catalog in `tools/ui/screens.mjs`, `product/ui/<screen>.md`) in place of the game's, checked against `framework/tools/ui/drawing.mjs` and `procedures/ui-design.md` so nothing is claimed that the tools don't do; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T182 · SaaSAllTheThings: the screen-design README is organised by feature · done 2026-10-25 · S · agent
- Depends on: T177
- PRs: SaaSAllTheThings #23 (merged)
- Touches: work/SaaSAllTheThings: project/product/ui/README.md, examples/order-desk/product/ui/README.md
- Done when: as T181, for SaaSAllTheThings, with the order-desk copy identical; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T183 · App-Director and SaaSAllTheThings: re-arrange a screen by dragging its existing boxes · done 2026-10-25 · M · agent
- Depends on: T180, T181, T182
- PRs: App-Director #30 (merged), SaaSAllTheThings #24 (merged)
- Note: the two Node readers are byte-identical ports apart from one comment; Godot's reader was run on the shared fixtures with Godot 4.7.2 and its output matches both. App-Director #30 also repairs the separators of its T17 heading, which #29 had written in Latin-1.
- Touches: work/App-Director, work/SaaSAllTheThings: framework/tools/ui/drawing.mjs, project/product/ui/README.md (and examples/order-desk/product/ui/README.md in SaaSAllTheThings), the drawing fixtures under tests/, selftest.sh
- Done when: the starter drawing's grey numbered boxes of the current elements are no longer locked, and the reader treats one that the human moved or resized as a blue "keep, move or resize" of that element (its name from the map, the new rectangle, any keys typed into it), while an untouched one is still skipped; a deleted or hidden one changes nothing; the fixture drawing and its expected output cover a moved, a resized and an untouched box; `design/ui/README.md` › Re-arranging a screen says you can drag the grey box to where the element should sit, and the Colours section says blue is still how you draw a move with a new box in both repos, one pull request each (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T184 · Release Godot-Director 4.3.0 · done 2026-10-25 · S · agent
- Depends on: T180
- PRs: Godot-Director #38 (merged); v4.3.0 tagged and published
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/godot-director/SKILL.md, README.md, project/design/director-gdd.md, examples/market-day/design/director-gdd.md, CHANGELOG.md, selftest.sh
- Done when: the release pull request bumps every version file and the template links together, turns Unreleased into the 4.3.0 heading (the README by feature and drag-to-rearrange), passes the selftest without Godot, and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v4.3.0 and publishes the release (check) · the selftest's stale-Godot check no longer mistakes a Godot Director 4.3.x version for Godot 4.3 (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T185 · Docs follow Godot-Director 4.3.0 · done 2026-10-25 · S · agent
- Depends on: T184
- Touches: docs/how-to/ui.md, docs/**/*.md (the Godot-Director links)
- Done when: every link into Godot-Director points at v4.3.0 and the release cache follows; the /ui-design skill page says a screen is re-arranged by dragging the grey boxes in the starter drawing (Godot-Director), while App-Director and SaaSAllTheThings still take a blue box, until T183 ships; the selftest passes (check)
- Brief: Scope › Framework features

### T186 · Release App-Director 1.9.0 · done 2026-10-25 · S · agent
- Depends on: T183
- PRs: App-Director #31 (merged); v1.9.0 tagged and published
- Touches: work/App-Director: VERSION, package.json, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, SKILL.md, skills/app-director/SKILL.md, scripts/fetch-app-director.sh, README.md, project/product/director-brief.md, examples/todo-web/product/director-brief.md, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and the template links together, adds the drag-to-rearrange entry that #30 left out of CHANGELOG.md and turns Unreleased into the 1.9.0 heading, passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v1.9.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T187 · Release SaaSAllTheThings 0.11.0 · done 2026-10-25 · S · agent
- Depends on: T183
- PRs: SaaSAllTheThings #25 (merged); v0.11.0 tagged and published
- Touches: work/SaaSAllTheThings: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/*/SKILL.md, README.md, project/product/director-brief.md, examples/order-desk/product/director-brief.md, CHANGELOG.md
- Done when: the release pull request bumps every version carrier, every skill's version and clone branch, and the template links together, turns Unreleased into the 0.11.0 heading, passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v0.11.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T188 · Docs follow App-Director 1.9.0 and SaaSAllTheThings 0.11.0 · done 2026-10-25 · S · agent
- Depends on: T186, T187
- Touches: docs/how-to/ui.md, docs/**/*.md (the App-Director and SaaSAllTheThings links)
- Done when: every link into App-Director points at v1.9.0 and into SaaSAllTheThings at v0.11.0, and the release cache follows; the ui how-to says a screen is re-arranged by dragging the grey boxes in all three frameworks, with the blue box as the other way; the selftest passes (check)
- Brief: Scope › Framework features

### T189 · Godot-Director: the check balances its jobs by last run's timings and splits a slow test file by test method · todo · L · agent
- Depends on: T163
- Touches: work/Godot-Director: framework/tools/check.sh, framework/tools/check.gd, project/tools/check.cfg, selftest.sh
- Done when: the parallel run hands out test files longest first, using each file's time from the last run (kept under .godot/godot-director/, unknown files first), instead of file order; a file whose last time is over `[tests] split_over` seconds (default 60) is run as several shards of its test methods across the jobs, each shard in its own process, the file's results merged as one; a file that can't be split (its tests share state across methods, marked by a project setting or a header line the docs name) runs whole; on The Guildkeeper's scratch copy the full run's wall time and its slowest job are recorded before and after (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T190 · Godot-Director: the check plays its autoplay scenarios alongside the tests · todo · M · agent
- Depends on: T189
- Touches: work/Godot-Director: framework/tools/check.sh, framework/tools/autoplay.sh, selftest.sh
- Done when: with `[autoplay] check_in_check` on, the enforced scenarios start as soon as the import and load pass are done, in their own process beside the test jobs (one fewer test job, so the CPU count isn't exceeded), and their result joins the check's report with exit codes unchanged; measured on The Guildkeeper's scratch copy (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T191 · Godot-Director: the check skips the import pass when no imported file changed · in-progress 2026-10-25 · S · agent
- Depends on: -
- Touches: work/Godot-Director: framework/tools/check.sh, framework/tools/autoplay.sh, framework/tools/ui_capture.sh, selftest.sh
- Done when: the check, autoplay and capture record a fingerprint of the files Godot imports (everything but scripts, scenes and resources it reads directly, and the .godot folder) after a passing import, and skip the next import pass when it is unchanged and `.godot/imported` exists, saying so in one line; a changed or new asset, a fresh clone, or `--import` forces the pass (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T192 · The Guildkeeper: a prompt for its session to make the three quest map test files fast · done 2026-10-25 · S · agent
- Depends on: -
- Touches: init/guildkeeper-map-tests-prompt.md
- Done when: a prompt for the game's own session, in `init/`, gives the measurements (the three map test files are half of all test time and the floor of the parallel check; each Godot process spends about 12 s starting the game's autoloads, 4 s of it the content loader) and asks it to share built maps across tests in those files, or split them, and to make the content loader lazy if tests don't need all content, verified by the check's slowest-files summary (check)
- Brief: -

### T193 · Release Godot-Director 4.4.0 · todo · S · agent
- Depends on: T163
- Touches: work/Godot-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and template link together, turns Unreleased into the 4.4.0 heading (the Bash guard against hangs), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v4.4.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T194 · Release App-Director 1.10.0 · todo · S · agent
- Depends on: T164
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and template link together, turns Unreleased into the 1.10.0 heading (the Bash guard against hangs and the check's time limit), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v1.10.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T195 · Release SaaSAllTheThings 0.12.0 · todo · S · agent
- Depends on: T165
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and template link together, turns Unreleased into the 0.12.0 heading (the Bash guard against hangs and the check's time limit), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v0.12.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T196 · Docs follow Godot-Director 4.4.0, App-Director 1.10.0 and SaaSAllTheThings 0.12.0 · todo · S · agent
- Depends on: T193, T194, T195
- Touches: docs/**/*.md (the framework links), docs/how-to/check.md, docs/how-to/trouble.md
- Done when: every framework link points at the new tags; the check how-to says the check limits each test run (`[tests] timeout`, exit 3) in all three frameworks, and the troubleshooting page says what the Bash guard blocks and the form that works for each (an empty Python heredoc, an unbounded wait, a Godot run without a time limit); the selftest passes (check)
- Brief: Scope › Framework features

### T173 · The director pilots SaaSAllTheThings' example app in an Azure sandbox · todo · - · human
- Depends on: T169
- Touches: -
- Done when: the example app runs in an Azure sandbox subscription with Azure Policy Deny assignments for public network access and local authentication and Defender for Cloud on, it is tested from outside, and the results are written down in `product/research/` for a later claims decision (demo)
- Brief: Scope › What the site claims for production and compliance

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

### T86 · The /ui-design skill page · done 2026-10-25 · S · agent
- Depends on: T84, T85
- Touches: docs/skills/ui-design.md (new), docs/skills/index.md, mkdocs.yml, docs/frameworks/*.md, docs/concept/ownership.md
- Done when: once all three frameworks have released /ui-design, the page describes the shared behaviour and what is unique per repo, matching the released procedures, in the skills index and nav (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T100 · The framework repos ignore OS metadata files · done 2026-10-21 · XS · agent
- PRs: Godot-Director #16 (merged). App-Director: ba91b84 on main (a one-off test push). SaaSAllTheThings #21 (merged)
- Depends on: -
- Touches: work/Godot-Director: .gitignore; work/App-Director: .gitignore; work/SaaSAllTheThings: .gitignore (one pull request per repo; the director squash-merges)
- Done when: each framework's own `.gitignore` ignores `.DS_Store`, `Thumbs.db`, `desktop.ini` and `__MACOSX/`, as the plugin directory's scanner asks, in a pull request the director squash-merges to test whether single-parent commits pass the scan, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Orchestrator for the three frameworks

### T102 · The secrets scan doesn't flag drawings · in-progress 2026-10-25 · S · agent
- Depends on: T84, T85
- PRs: App-Director #33 (merged); the SaaSAllTheThings half waits for SaaSAllTheThings #29, which touches the same selftest
- Touches: work/App-Director and work/SaaSAllTheThings: the secrets step of framework/tools/check.sh or the gitleaks config seed (one pull request per repo; the director squash-merges)
- Done when: a committed drawing in `director/ui/*.excalidraw`, whose embedded base64 screenshot can match a key pattern, doesn't fail the check, while a real key in any other file still does, following AGENTS.md › Project rules for framework work (check)
- Note: found while building T85. Ships with /ui-design, so it waits for T84 and T85.
- Brief: Scope › Planned framework changes

## Notes
