# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T290 · B63 · R7

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

### B5 · The Claude Code allow-list lets the agent run any code without a prompt (A01:2025 Broken Access Control) · done 2026-10-29 · S · agent · med
- Touches: .claude/settings.json, selftest.sh
- Repro: 1. Read `.claude/settings.json` allow rules: `Bash(npm *)`, `Bash(npx *)`, `Bash(pnpm *)`, `Bash(yarn *)`, `Bash(flutter *)`, `Bash(python *)`, `Bash(pip *)`, `WebSearch`, `WebFetch`; the deny list covers only `.env`, `*.pem`, `*.key`. 2. Expected: only what this repo runs is allowed without a prompt. Actual: `python -c`, `npx <package>` or `pip install <package>` run arbitrary code unprompted, which can push or read credential stores, so the "other pushes still prompt" boundary in `tools/work-publish.sh:15-17` and `tools/work-release.sh:16-19` doesn't hold; prompt injection from a fetched page or a framework repo is the trigger. The rules come from the App Director template, so an upgrade would restore them: file the template change as an App-Director item too.
- Found in: product/security/2026-10-26.md › F1
- Brief: -

### T212 · The framework workflow page describes one bundle pull request per repo · done 2026-10-29 · S · agent
- Depends on: -
- Touches: product/framework-workflow.md
- Done when: the flowchart, the sequence diagram and the sections on done, after a merge and releases describe AGENTS.md › Project rules › Framework work as it now stands: one open bundle pull request per framework repo, each item one commit on it, an open bundle blocking nothing, the release commit ending the bundle with its notes as the description, and `work-release.sh` tagging after the merge; nothing still describes a branch or pull request per item (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Orchestrator for the three frameworks

### T213 · App-Director: the settings template allows no generic code runner · done 2026-10-29 · S · agent
- PRs: App-Director #40 (merged)
- Depends on: B5
- Touches: work/App-Director: framework/.claude/settings.json, selftest.sh
- Done when: the template's allow list drops `Bash(npm *)`, `Bash(npx *)`, `Bash(pnpm *)`, `Bash(yarn *)`, `Bash(flutter *)`, `Bash(python *)` and `Bash(pip *)`, keeping the named `bash tools/...` and `node tools/ui/...` commands, and the selftest fails when the template allows a generic code runner with a wildcard; the CHANGELOG entry says apps get the narrower list on upgrade and that a stack command not named there now asks first (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: -

### T214 · tools/work-publish.sh describes publishing a bundle · done 2026-10-29 · XS · agent
- Depends on: -
- Touches: tools/work-publish.sh
- Done when: the script's header says it pushes a repo's bundle branch and opens its pull request the first time or updates it, and that `gh pr edit` then keeps the title and body naming every item it carries, as AGENTS.md › Framework work says, instead of describing one item per pull request; its behaviour is unchanged (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Orchestrator for the three frameworks

### T215 · App-Director: the installer gitignores .claude/settings.local.json, as the README says · done 2026-10-29 · S · agent
- PRs: App-Director #40 (merged)
- Depends on: -
- Touches: work/App-Director: install.sh, selftest.sh
- Done when: an install or upgrade leaves `.claude/settings.local.json` ignored by git (today the installer's `*.local` line doesn't match that name, while the README says it's gitignored), checked with `git check-ignore` in the selftest's install fixture; the README's sentence stays true (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: -

### T216 · work-publish.sh's messages speak of the bundle branch · done 2026-10-29 · XS · agent
- Depends on: T214
- Touches: tools/work-publish.sh
- Done when: the refusal messages that say "check out the item's branch first", "publish an item branch" and "commit them to the item's commit first" name the repo's bundle branch instead, with behaviour unchanged (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Orchestrator for the three frameworks

### T217 · App-Director: an upgrade adds gitignore lines under the existing App Director heading · done 2026-10-29 · XS · agent
- PRs: App-Director #40 (merged)
- Depends on: -
- Touches: work/App-Director: install.sh, selftest.sh
- Done when: an upgrade that adds a missing `.gitignore` line puts it under the app's existing `# App Director` heading instead of writing a second heading at the end, and the selftest's upgrade fixture finds one heading (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: -

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

### T167 · SaaSAllTheThings: its TASKS.md has one queue and unique IDs · done 2026-10-25 · XS · agent
- Depends on: T151, T100
- PRs: SaaSAllTheThings #28 (merged)
- Touches: work/SaaSAllTheThings: TASKS.md
- Done when: the root TASKS.md has one `## Queue` heading (today three, at about lines 9, 35 and 49), the two items numbered T9 ("The README starts with writing your own product brief" and "/ui-design with Playwright capture") have distinct IDs with references to them updated, and T10's Done when names its own repo's item rather than the docs repo's T160 (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Orchestrator for the three frameworks

### T168 · The SaaSAllTheThings page says what its records show for production and compliance · done 2026-10-25 · S · agent
- Depends on: -
- Touches: docs/frameworks/saasallthethings.md
- Done when: a short section in the brief's wording: the check fails the build on broken architecture and security requirements, with exceptions only through an ADR the director accepts; the requirements and the customer's control framework live in the repository and every architecture session reads them; every decision and change leaves a record a reviewer can read; the running system provides the operating evidence; each statement checked against SaaSAllTheThings' latest release (check) · no page says production-ready, compliant, more secure than others, a full supply-chain view or cannot exfiltrate (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › What the site claims for production and compliance

### T169 · SaaSAllTheThings: the check fails public network access and local authentication in Bicep · done 2026-10-25 · M · agent
- Depends on: -
- PRs: SaaSAllTheThings #29 (merged)
- Review: existing references were failed and a resource's text ran past its closing brace (fixed, with selftest cases); block comments, strings and whole-word true/false tidied.
- Touches: work/SaaSAllTheThings: framework/.satt/reference/network.md (new), framework/.satt/reference/README.md, framework/.satt/reference/cost.md, framework/tools/archcheck.awk, project/tools/check.cfg, ONBOARDING.md, skills/saas-design-session/references/ (bundle), selftest.sh
- Done when: a new rule, named in reference/README.md › What the check enforces, archcheck.awk and selftest.sh, fails a Bicep resource that leaves public network access enabled or local authentication on, for the resource types the reference architecture uses where Azure offers the setting, and an accepted ADR with an exception for the rule and path excuses it (check) · the network topic gives the default posture, and cost.md says private-only needs Service Bus Premium, so an ADR with a `cost-sku` exception (check) · the rule is on for new apps and off on upgrade until the app turns it on in check.cfg, as the CHANGELOG's upgrade steps say (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T170 · SaaSAllTheThings: a shipped CI workflow keeps the check's output as evidence · done 2026-10-25 · M · agent
- Depends on: -
- PRs: SaaSAllTheThings #30 (merged)
- Touches: work/SaaSAllTheThings: framework/.satt/templates/check-workflow.yml (new), ONBOARDING.md, framework/.satt/procedures/release.md, selftest.sh
- Done when: a GitHub Actions workflow template runs `bash tools/check.sh` on every pull request and push to main and uploads its output and logs as an artifact, with how long it's kept left to the app's setting; onboarding offers to install it for new and existing apps; the selftest checks the template's steps (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T171 · SaaSAllTheThings: a compliance mapping table that review and align read · done 2026-10-25 · M · agent
- Depends on: -
- PRs: SaaSAllTheThings #31 (merged)
- Touches: work/SaaSAllTheThings: project/compliance/mapping.md (new), framework/.satt/procedures/architect.md, framework/.satt/procedures/review.md, framework/.satt/procedures/align.md, ONBOARDING.md, skills/saas-design-session/references/ (bundle), selftest.sh
- Done when: a seeded table with control id, requirement, met by (rule, ADR or test), label (direct, partial, interpretive or unverified) and evidence location; architecture sessions add or update rows as ADRs are accepted, review flags a change to a mapped rule, ADR or test that leaves its row stale, and align reports rows whose rule, ADR or test no longer exists; nothing marks a control met from a framework's name (check) · following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T172 · SaaSAllTheThings: dependency review and an SBOM in the shipped workflow · done 2026-10-25 · S · agent
- Depends on: T170
- PRs: SaaSAllTheThings #32 (merged)
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

### T189 · Godot-Director: the check balances its jobs by last run's timings and splits a slow test file by test method · done 2026-10-25 · L · agent
- Depends on: T163
- PRs: Godot-Director #42 (merged)
- Note: opt-in by the director's choice; measured 376 s file order, 411 s and 284 s balanced on The Guildkeeper.
- Touches: work/Godot-Director: framework/tools/check.sh, framework/tools/check.gd, project/tools/check.cfg, selftest.sh
- Done when: the parallel run hands out test files longest first, using each file's time from the last run (kept under .godot/godot-director/, unknown files first), instead of file order; a file whose last time is over `[tests] split_over` seconds (default 60) is run as several shards of its test methods across the jobs, each shard in its own process, the file's results merged as one; a file that can't be split (its tests share state across methods, marked by a project setting or a header line the docs name) runs whole; on The Guildkeeper's scratch copy the full run's wall time and its slowest job are recorded before and after (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T190 · Godot-Director: the check plays its autoplay scenarios alongside the tests · done 2026-10-29 · M · agent
- PRs: Godot-Director #45 (merged)
- Depends on: T189
- Touches: work/Godot-Director: framework/tools/check.sh, framework/tools/autoplay.sh, project/tools/check.cfg, selftest.sh
- Done when: with `[autoplay] check_in_check` on, the enforced scenarios start as soon as the import and load pass are done, in their own process beside the test jobs (one fewer test job, so the CPU count isn't exceeded), and their result joins the check's report with exit codes unchanged; measured on The Guildkeeper's scratch copy (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T191 · Godot-Director: the check skips the import pass when no imported file changed · done 2026-10-25 · S · agent
- Depends on: -
- PRs: Godot-Director #40 (merged)
- Note: a first build skipped the import when only a class_name changed, which would leave Godot's class cache stale; the fingerprint now includes each script's class_name, extends and @icon lines.
- Touches: work/Godot-Director: framework/tools/check.sh, framework/tools/autoplay.sh, framework/tools/ui_capture.sh, selftest.sh
- Done when: the check, autoplay and capture record a fingerprint of the files Godot imports (everything but scripts, scenes and resources it reads directly, and the .godot folder) after a passing import, and skip the next import pass when it is unchanged and `.godot/imported` exists, saying so in one line; a changed or new asset, a fresh clone, or `--import` forces the pass (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T192 · The Guildkeeper: a prompt for its session to make the three quest map test files fast · done 2026-10-25 · S · agent
- Depends on: -
- Touches: init/guildkeeper-map-tests-prompt.md
- Done when: a prompt for the game's own session, in `init/`, gives the measurements (the three map test files are half of all test time and the floor of the parallel check; each Godot process spends about 12 s starting the game's autoloads, 4 s of it the content loader) and asks it to share built maps across tests in those files, or split them, and to make the content loader lazy if tests don't need all content, verified by the check's slowest-files summary (check)
- Brief: -

### T193 · Release Godot-Director 4.4.0 · done 2026-10-25 · S · agent
- Depends on: T163, T191
- PRs: Godot-Director #41 (merged); v4.4.0 tagged and published
- Touches: work/Godot-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and template link together, turns Unreleased into the 4.4.0 heading (the Bash guard against hangs), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v4.4.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T194 · Release App-Director 1.10.0 · done 2026-10-25 · S · agent
- Depends on: T164, T102 (its App-Director half)
- PRs: App-Director #34 (merged); v1.10.0 tagged and published
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and template link together, turns Unreleased into the 1.10.0 heading (the Bash guard against hangs and the check's time limit), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v1.10.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T195 · Release SaaSAllTheThings 0.12.0 · done 2026-10-25 · S · agent
- Depends on: T165, T167, T169, T170, T171, T172, T179
- PRs: SaaSAllTheThings #33 (merged); v0.12.0 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and template link together, turns Unreleased into the 0.12.0 heading (the Bash guard against hangs and the check's time limit), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v0.12.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T196 · Docs follow Godot-Director 4.4.0, App-Director 1.10.0 and SaaSAllTheThings 0.12.0 · done 2026-10-25 · M · agent
- Depends on: T193, T194, T195
- Touches: docs/**/*.md (the framework links), docs/how-to/check.md, docs/how-to/trouble.md, docs/frameworks/saasallthethings.md, docs/frameworks/godot-director.md
- Done when: every framework link points at the new tags; the check how-to says the check limits each test run (`[tests] timeout`, exit 3) in all three frameworks, and the troubleshooting page says what the Bash guard blocks and the form that works for each (an empty Python heredoc, an unbounded wait, a Godot run without a time limit); the Godot-Director pages say the check skips an unchanged import pass (`--import` forces it); the SaaSAllTheThings page lists the `network-public` rule with what's enforced and what isn't, and mentions the CI workflow template with its dependency review and SBOM, and the compliance mapping table, each checked against the release; the selftest passes (check)
- Brief: Scope › Framework features

### T197 · Godot-Director: a sweep plays its scenarios side by side, and the builder doesn't play smoke twice · done 2026-10-25 · M · agent
- Depends on: -
- PRs: Godot-Director #43 (merged)
- Note: The Guildkeeper sweep of four scenarios: 462 s one call at a time, 124 s in one call.
- Touches: work/Godot-Director: framework/tools/autoplay.sh, framework/.godot-director/procedures/build.md, framework/.godot-director/procedures/autoplay.md, selftest.sh
- Done when: `bash tools/autoplay.sh <scenario> <scenario> ...` (and `--all`) runs the scenarios in separate Godot processes at the same time under the one lock and one import check, each with its own user dir, log and run folder, capped at the CPU count, and reports each scenario's result with exit codes unchanged; one scenario behaves as today (check) · `build.md` has the builder play the scenarios the item names once, after the tests pass, in one call, and leave out `smoke` when `tools/check.cfg` › `[autoplay]` has the check play it (check) · measured on The Guildkeeper's scratch copy: a sweep of quest_job, quest_hold, quest_controls and smoke before and after (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T198 · SaaSAllTheThings: OWASP is a non-negotiable baseline · done 2026-10-25 · M · agent
- Depends on: -
- PRs: SaaSAllTheThings #34 (merged)
- Touches: work/SaaSAllTheThings: framework/.satt/rules.md, framework/.satt/procedures/architect.md, framework/.satt/procedures/review.md, project/compliance/mapping.md, ONBOARDING.md, skills/ (bundle), selftest.sh
- Done when: OWASP Top 10, and the OWASP API Security Top 10 for anything that serves an API, is a baseline every app meets: `rules.md` states it as framework-owned, so no project setting turns it off; every design option states its effect on it; review checks each change that handles input, authentication, authorization, sessions, secrets, data access, file or network access, or dependencies against it and reports the item it falls under; a deviation is only ever an accepted ADR that names the OWASP item and why (check) · the seeded `compliance/mapping.md` carries the ten OWASP Top 10 categories as rows that are always there (marked as the baseline, not deletable like the example), each with what in the framework meets it today and an honest label (for example the tenant rules as partial for broken access control, the secrets rule as partial for cryptographic failures), and `none yet` where nothing does; align reports a removed baseline row (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T199 · App-Director: OWASP is a non-negotiable baseline · done 2026-10-25 · M · agent
- Depends on: -
- PRs: App-Director #35 (merged)
- Touches: work/App-Director: framework/.app-director/rules.md, framework/.app-director/procedures/design.md, framework/.app-director/procedures/review.md, ONBOARDING.md, selftest.sh
- Done when: OWASP Top 10, and the OWASP API Security Top 10 for anything that serves an API, is a baseline every app meets: `rules.md` states it as framework-owned, so no project setting turns it off; every design option states its effect on it; review checks each change that handles input, authentication, authorization, sessions, secrets, data access, file or network access, or dependencies against it and reports the item it falls under; a deviation is only ever an accepted decision (in App-Director a `product/decisions.md` line, since it has no ADRs) that names the OWASP item and why; the check's existing rules that serve an OWASP category (secrets, UI purity) say which one in their messages or docs (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T200 · SaaSAllTheThings: onboarding and the assessment ask which compliance frameworks apply · done 2026-10-25 · M · agent
- Depends on: T198
- PRs: SaaSAllTheThings #35 (merged)
- Touches: work/SaaSAllTheThings: ONBOARDING.md, framework/.satt/procedures/assess.md, framework/.satt/workshops/vision.md, framework/.satt/workshops/tenancy-identity.md, project/product/director-brief.md, project/compliance/mapping.md, skills/ (bundle), selftest.sh
- Done when: when the brief's section 10 is blank or vague, onboarding and the assessment ask a short set of questions instead of moving on: the security framework the organisation or customer works to (for example ISO/IEC 27001, NIST CSF, the ISF Standard of Good Practice, its own); which regulations and control frameworks follow from the markets, industry and data (for example GDPR for personal data of people in the EU, NIS2 and DORA for EU essential and financial entities, SOC 2 for customers who ask for it, PCI DSS for card data, HIPAA for US health data), each asked, never assumed; who audits and what evidence they expect; the answers go to PRD › Data and Compliance and to the brief's section 10 table, and each named framework gets its controls added to `compliance/mapping.md` by the human or from a document the human provides, never from the agent's memory; an unknown answer stays an open question; the vision and tenancy workshops check the answers with the security officer and the data protection officer; nothing marks a control met because a framework is named (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T201 · SaaSAllTheThings: a recurring security assessment validates what is built against the OWASP baseline · done 2026-10-25 · L · agent
- Depends on: T198
- PRs: SaaSAllTheThings #36 (merged)
- Review: the Semgrep command printed matched source, failed tools could read as clean, findings could quote a secret, the fixture's manifests would trip Dependabot, the tenant checks missed where this architecture breaks; all fixed. Semgrep's emacs field layout is unverified (not installed here).
- Touches: work/SaaSAllTheThings: framework/.satt/procedures/security.md (new), framework/.claude/skills/security/ (new), framework/.satt/reference/owasp.md (new), framework/.satt/procedures/release.md, framework/.satt/procedures/next-task.md, framework/.satt/rules.md, ONBOARDING.md, tests/, skills/ (bundle), selftest.sh
- Done when: a security assessment procedure and skill (`/security`) validates what is built against the OWASP baseline: (1) tools first, each skipped with a note when not installed, never installed without asking: the stack's dependency vulnerability audit (`npm audit`, `dotnet list package --vulnerable --include-transitive`, `pip-audit`), the existing secrets scan, and Semgrep with its OWASP rules when present, and the Bicep rules for configuration; (2) then a reviewer pass in a fresh context, category by category through a checklist in the framework's reference (each OWASP Top 10 and API Security Top 10 category broken into checks a reader can verify in code and config, from the OWASP ASVS level 1 where it applies), reading the code that each check concerns and citing file and line; (3) each finding gets the OWASP item, severity, evidence and a proposed fix, and becomes a bug item in TASKS.md (high severity first in the queue); (4) what can't be checked in the repository (people and process: access reviews, incident response, alert routing and who is on call, key rotation, the security officer's sign-off) becomes a list for the director with what to do and why, and human items where the director agrees; (5) the report is written to `assessment/security/YYYY-MM-DD.md` with the date, the commit, what ran, what was skipped and why, and a line per category: verified, findings, not checkable here, or not applicable (check) · it runs on request, as a step of the release procedure before a release is proposed, and is proposed by `/next-task` when a set number of items (a setting, default 10) are done since the last assessment (check) · the assessment never marks a category met from a tool passing alone, and says what a clean run does not prove (check) · the selftest proves a seeded vulnerable fixture (an injection, a missing authorization check, a secret, a vulnerable dependency where a tool is available) is reported with its OWASP item, and a clean fixture isn't (check) · the assessment updates the Met by, Label and Evidence of the OWASP rows in `compliance/mapping.md` and flags rows of the customer's own framework that a finding touches (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T202 · App-Director: a recurring security assessment validates what is built against the OWASP baseline · done 2026-10-25 · L · agent
- Depends on: T199
- PRs: App-Director #36 (merged)
- Review: pip-audit and Corepack could install, squash-merged items weren't counted, a skipped assessment lost the release gate, Semgrep output could copy secrets, the allow-list was a wildcard; all fixed and covered.
- Touches: work/App-Director: framework/.app-director/procedures/security.md (new), framework/.claude/skills/security/ (new), framework/.app-director/reference/owasp.md (new), framework/.app-director/procedures/release.md, framework/.app-director/procedures/next-task.md, framework/.app-director/rules.md, ONBOARDING.md, tests/, selftest.sh
- Done when: a security assessment procedure and skill (`/security`) validates what is built against the OWASP baseline: (1) tools first, each skipped with a note when not installed, never installed without asking: the stack's dependency vulnerability audit (`npm audit`, `dotnet list package --vulnerable --include-transitive`, `pip-audit`), the existing secrets scan, and Semgrep with its OWASP rules when present; (2) then a reviewer pass in a fresh context, category by category through a checklist in the framework's reference (each OWASP Top 10 and API Security Top 10 category broken into checks a reader can verify in code and config, from the OWASP ASVS level 1 where it applies), reading the code that each check concerns and citing file and line; (3) each finding gets the OWASP item, severity, evidence and a proposed fix, and becomes a bug item in TASKS.md (high severity first in the queue); (4) what can't be checked in the repository (people and process: access reviews, incident response, alert routing and who is on call, key rotation, the security officer's sign-off) becomes a list for the director with what to do and why, and human items where the director agrees; (5) the report is written to `product/security/YYYY-MM-DD.md` with the date, the commit, what ran, what was skipped and why, and a line per category: verified, findings, not checkable here, or not applicable (check) · it runs on request, as a step of the release procedure before a release is proposed, and is proposed by `/next-task` when a set number of items (a setting, default 10) are done since the last assessment (check) · the assessment never marks a category met from a tool passing alone, and says what a clean run does not prove (check) · the selftest proves a seeded vulnerable fixture (an injection, a missing authorization check, a secret, a vulnerable dependency where a tool is available) is reported with its OWASP item, and a clean fixture isn't (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T203 · App-Director and SaaSAllTheThings: the OWASP baseline moves to the current Top 10 edition · done 2026-10-25 · M · agent
- Depends on: T201, T202
- PRs: SaaSAllTheThings #38 (merged), App-Director #38 (merged)
- Touches: work/App-Director and work/SaaSAllTheThings: rules.md, reference/owasp.md, check.sh messages, the security procedure, compliance/mapping.md (SaaSAllTheThings), selftest.sh
- Done when: the baseline, the checklists, the mapping rows and the check's messages use the current OWASP Top 10 edition's categories and names, checked against OWASP's published list, with an upgrade step that maps each old row to its new category (merged or renamed categories said plainly); one pull request per repo (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T204 · Release App-Director 1.11.0 · done 2026-10-25 · S · agent
- Depends on: T199, T202, T205, T203
- PRs: App-Director #39 (merged); v1.11.0 tagged and published
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and template link together, turns Unreleased into the 1.11.0 heading (the OWASP baseline and the security assessment), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v1.11.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T205 · App-Director: the security assessment never quotes a secret, and names its OWASP editions · done 2026-10-25 · S · agent
- Depends on: T202
- PRs: App-Director #37 (merged)
- Touches: work/App-Director: framework/.app-director/procedures/security.md, framework/.app-director/reference/owasp.md, framework/.app-director/rules.md, framework/.app-director/procedures/release.md, framework/tools/security.sh, selftest.sh
- Done when: from SaaSAllTheThings' review of the same feature: evidence, the report and bug items never quote a secret, token, key or the line holding one, only file:line and the kind of secret; a tool counts as clean only when it exits 0 with its nothing-found summary, and a timeout, network or restore error is couldn't run (check security.sh does this for every tool); owasp.md and rules.md name the Top 10 (2021) edition until T203; release.md runs the assessment on main at the release commit, not on a detached tag (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T206 · Release SaaSAllTheThings 0.13.0 · done 2026-10-25 · S · agent
- Depends on: T198, T200, T201
- PRs: SaaSAllTheThings #37 (merged); v0.13.0 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier, every skill's version and clone branch, and the template links together, turns Unreleased into the 0.13.0 heading (the OWASP baseline, the compliance questions, the security assessment), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v0.13.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T207 · Release SaaSAllTheThings 0.14.0 · done 2026-10-25 · S · agent
- Depends on: T203
- PRs: SaaSAllTheThings #39 (merged); v0.14.0 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier, every skill's version and clone branch, and the template links together, turns Unreleased into the 0.14.0 heading (the OWASP Top 10 (2025)), passes the selftest and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v0.14.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T208 · Docs follow App-Director 1.11.0 and SaaSAllTheThings 0.14.0: the OWASP baseline, the security assessment and the compliance questions · done 2026-10-25 · M · agent
- Depends on: T204, T207
- Touches: docs/**/*.md (the framework links), docs/frameworks/app-director.md, docs/frameworks/saasallthethings.md, docs/skills/, docs/how-to/, mkdocs.yml, product/brief.md
- Done when: `frameworks.lock` and every App-Director and SaaSAllTheThings link move to v1.11.0 and v0.14.0; the site describes the OWASP Top 10 (2025) baseline in both app frameworks (framework-owned, deviation only by a named, accepted decision), the `/security` assessment (what runs, what comes out, when it runs, what a clean run doesn't prove) with a skill page if the skills section covers framework-specific skills or a how-to otherwise, and SaaSAllTheThings' compliance-framework questions and mapping rows, each checked against the releases and without overclaiming; the selftest passes (check)
- Brief: Scope › Framework features

### T209 · The docs CI checks the framework releases the docs are written against, not GitHub's newest · done 2026-10-25 · M · agent
- Depends on: -
- Touches: selftest.sh, frameworks.lock (new), AGENTS.md, tools/audit.sh
- Done when: a committed `frameworks.lock` names the release each framework's docs are written against (one line per repo, `v<version>`); the selftest's link check, command coverage and release cache use those tags instead of each repo's highest tag, so a framework release no longer turns `main` red; the selftest prints a warning, not a failure, naming each framework whose newest release is past the pinned one; `tools/audit.sh` and the AGENTS.md Selftest row and "Latest only" rule say the docs follow-up item bumps the pin with the links; the pin starts at the releases the docs describe today, so the selftest passes now (check)
- Brief: Scope › Orchestrator for the three frameworks

### T210 · Release Godot-Director 4.5.0 · done 2026-10-25 · S · agent
- Depends on: T189, T197
- PRs: Godot-Director #44 (merged); v4.5.0 tagged and published
- Touches: work/Godot-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the release pull request bumps every version carrier and template link together, turns Unreleased into the 4.5.0 heading (opt-in balanced test jobs, side-by-side autoplay sweeps), passes the selftest without Godot and carries the release notes in its commit body; once merged, `tools/work-release.sh` tags v4.5.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T211 · Docs follow Godot-Director 4.5.0 · done 2026-10-25 · S · agent
- Depends on: T210
- Touches: frameworks.lock, docs/**/*.md (the Godot-Director links), docs/how-to/check.md, docs/frameworks/godot-director.md
- Done when: `frameworks.lock` and every Godot-Director link move to v4.5.0; the check how-to and the Godot-Director page describe the opt-in balanced and split test jobs (`[tests] balance`, `split_over`, `# gdir: no-split`, `--jobs 1` to re-measure, measure before and after) and that a sweep of several scenarios plays side by side in one call, checked against the release; the selftest passes with no WARN (check)
- Brief: Scope › Framework features

### B6 · The CI build installs unpinned transitive Python packages without hashes (A03:2025 Software Supply Chain Failures) · done 2026-10-29 · S · agent · low
- Touches: requirements.txt, .github/workflows/docs.yml
- Repro: 1. `requirements.txt:1-2` pins only mkdocs and mkdocs-material; `docs.yml:24` runs `pip install -r requirements.txt`. 2. Expected: every package the build installs is pinned with a hash. Actual: Markdown, pymdown-extensions, Jinja2 and the rest resolve to their newest releases on every run and render the published site.
- Found in: product/security/2026-10-26.md › F2
- Brief: -

### B7 · The docs workflow pins actions by mutable tag (A08:2025 Software or Data Integrity Failures) · done 2026-10-29 · XS · agent · low
- Touches: .github/workflows/docs.yml, .github/dependabot.yml (new)
- Repro: 1. `docs.yml:19,20,27,44` use actions by major tag. 2. Expected: actions pinned to a commit SHA, with updates proposed. Actual: a moved or compromised tag runs new code in the deploy job, which holds `pages: write` and `id-token: write` (all four are GitHub-owned, which lowers the risk).
- Found in: product/security/2026-10-26.md › F3
- Brief: -

### B8 · Two paths skip the secrets scan: CI and the framework pushes (A07:2025 Authentication Failures) · done 2026-10-29 · S · agent · low
- Touches: .github/workflows/docs.yml, tools/work-publish.sh
- Repro: 1. The scan runs only in `tools/check.sh` and the local pre-commit hook; `docs.yml` runs `selftest.sh`, which has no gitleaks step. 2. `tools/work-publish.sh:142` pushes `work/` clone commits to the public framework repos with no scan from this side. Expected: a commit made outside the hook, or a clone's item commit, is scanned before it reaches a public repo. Actual: neither is.
- Found in: product/security/2026-10-26.md › F4
- Brief: -

### B9 · The published site sets no Content-Security-Policy (A02:2025 Security Misconfiguration) · done 2026-10-29 · S · agent · low
- Touches: mkdocs.yml, overrides/ (new), selftest.sh
- Repro: 1. `mkdocs.yml` has no `theme.custom_dir` and no meta CSP; GitHub Pages can't send custom headers. 2. Expected: a meta CSP limits scripts, frames and images, and the headers Pages can't send are an accepted decision naming A02. Actual: nothing contains injected content.
- Found in: product/security/2026-10-26.md › F5
- Brief: -

### B10 · The itch.io iframe has no sandbox (A08:2025 Software or Data Integrity Failures) · done 2026-10-29 · XS · agent · low
- Touches: docs/examples/pksei.md
- Repro: 1. `docs/examples/pksei.md:12` embeds the itch.io frame without `sandbox`, `referrerpolicy` or `loading`. 2. Expected: the frame gets only what the game needs. Actual: compromised frame content could open popups or navigate the top window with user activation.
- Found in: product/security/2026-10-26.md › F6
- Brief: -

### B11 · Two tools reuse a predictable temp folder (A01:2025 Broken Access Control) · done 2026-10-29 · XS · agent · low
- Touches: tools/push-alignment.sh, tools/audit.sh
- Repro: 1. `tools/push-alignment.sh:27,78` uses `${TMPDIR:-/tmp}/push-alignment-$$` with `mkdir -p`, and with `--add` writes its TASKS.md copy back (line 154); `tools/audit.sh:25-26` does the same. 2. Expected: a fresh folder from `mktemp -d`, as `work-publish.sh` and `work-release.sh` do. Actual: on a shared Unix /tmp another user can pre-create the folder and change the copy before it's written back.
- Found in: product/security/2026-10-26.md › F7
- Brief: -

### B12 · The work scripts' origin check accepts any host and ignores pushurl (A01:2025 Broken Access Control) · done 2026-10-29 · XS · agent · low
- Touches: tools/work-publish.sh, tools/work-release.sh, tools/work-clones.sh
- Repro: 1. `work-publish.sh:89-92`, `work-release.sh:118-121`, `work-clones.sh:76-81` accept any origin ending in `/Freakling/<repo>` on any host, and never check `remote.origin.pushurl`. 2. Expected: only the real GitHub repo URL, and no differing pushurl. Actual: a tampered clone config sends a branch or tag elsewhere while the gh steps target the real repo.
- Found in: product/security/2026-10-26.md › F8
- Brief: -

### B13 · The screen-capture tooling has an open version range and no lock file (A03:2025 Software Supply Chain Failures) · done 2026-10-29 · XS · agent · low
- PRs: App-Director #40 (merged)
- Touches: tools/ui/package.json, tools/ui/.npmrc (framework-owned: an App-Director item); built as work/App-Director: framework/tools/ui/package.json, framework/tools/ui/.npmrc, tests/ui-web/package.json, selftest.sh
- Note: playwright pinned to 1.64.1 with no lock file, since it pins its only dependency exactly; this repo's tools/ui gets it with the next App-Director upgrade.
- Repro: 1. `tools/ui/package.json:9` has `playwright` at `^1.50.0` and `tools/ui/.npmrc:2` sets `package-lock=false`. 2. Expected: an exact version and a lock file, or a decision saying why not. Actual: `npm install` takes the newest release in the range. Framework-owned and unused by this static site, so the fix belongs in App-Director.
- Found in: product/security/2026-10-26.md › F9
- Brief: -

### T173 · The director pilots SaaSAllTheThings' example app in an Azure sandbox · todo · - · human
- Depends on: T169
- Touches: -
- Done when: the example app runs in an Azure sandbox subscription with Azure Policy Deny assignments for public network access and local authentication and Defender for Cloud on, it is tested from outside, and the results are written down in `product/research/` for a later claims decision (demo)
- Brief: Scope › What the site claims for production and compliance

### B14 · The `git grep` allow rule runs any command (A01:2025 Broken Access Control) · done 2026-10-30 · M · agent · med
- Touches: .claude/settings.json, .claude/hooks/guard-commands.sh, selftest.sh (the settings and the guard are framework-owned: App-Director and SaaSAllTheThings items too)
- Repro: 1. `.claude/settings.json` allows `Bash(git grep *)`, and App-Director's template does too. 2. `git grep -O"<command>" <pattern>` runs the command as a pager on the matching files (B5's builder confirmed it with a harmless `echo`). Expected: no allow rule runs an arbitrary command without a prompt. Actual: `-O` or `--open-files-in-pager` does. Also check whether `Bash(bash tools/stacks/*.sh*)` can match a `../` path to another script (not verified).
- Found in: B5
- Brief: -

### B15 · The deny list doesn't cover the gh, git credential and SSH stores (A01:2025 Broken Access Control) · done 2026-10-30 · S · agent · low
- Touches: .claude/settings.json, selftest.sh
- Repro: 1. product/security/2026-10-26.md › F1's fix also asks for deny rules on reading the `gh` CLI's token store, git's credential store and `~/.ssh`. 2. Expected: `.claude/settings.json` (and App-Director's template) deny reads of those stores. Actual: the deny list covers only `.env`, `*.pem` and `*.key`, and a Bash `cat` isn't covered by Read rules.
- Found in: T213
- Brief: -

### B16 · The publish scan reads the clone's own gitleaks allowlist (A07:2025 Authentication Failures) · done 2026-10-29 · XS · agent · low
- Touches: tools/work-publish.sh
- Repro: 1. `tools/work-publish.sh` step 4 runs `gitleaks git` on the clone, which reads the clone's own `.gitleaks.toml` and `.gitleaksignore`. 2. A commit that adds a credential and an allowlist entry for it in the same push passes the scan (B8's builder confirmed it on a sandbox branch). Expected: a change to the clone's gitleaks allowlist in the commits being pushed is refused or named, or the scan ignores the clone's allowlist for those commits. Actual: it passes silently.
- Found in: B8
- Brief: -

### T218 · Godot-Director: the check names a Godot process that exits without an error line · done 2026-10-29 · S · agent
- PRs: Godot-Director #45 (merged)
- Depends on: -
- Touches: work/Godot-Director: framework/tools/check.sh, selftest.sh
- Done when: when the import pass, the load pass, a test group or the layout lint exits non-zero (a crash such as a segmentation fault included) and its log has no error line the scan reports, the check prints one line naming that process, its exit status and its log before the FAIL, instead of a FAIL with no reason; the selftest covers a load pass and a test group that exit non-zero with a clean log (test) · following AGENTS.md › Project rules for framework work
- Found in: T190 (the load pass's Godot process crashed after its report once in 12 runs on The Guildkeeper, and the check failed with no error line)
- Brief: Scope › Framework features

### T219 · SaaSAllTheThings: the screen-capture tooling pins Playwright to one exact version · done 2026-10-29 · XS · agent
- PRs: SaaSAllTheThings #40 (merged)
- Depends on: -
- Touches: work/SaaSAllTheThings: framework/tools/ui/package.json, framework/tools/ui/.npmrc, tests/ui-web/package.json, selftest.sh
- Done when: `playwright` is pinned to 1.64.1, as App-Director's B13 fix does, in both package.json files, `.npmrc` says why no lock file is needed (playwright pins its only dependency exactly), and the selftest fails when either pin is a range (check) · following AGENTS.md › Project rules for framework work
- Found in: B13 (SaaSAllTheThings ships the same files with `^1.50.0`)
- Brief: Scope › Framework features

### T220 · App-Director and SaaSAllTheThings: the screen-capture tooling asks for Node 20, as Playwright does · done 2026-10-29 · XS · agent
- PRs: App-Director #40 (merged), SaaSAllTheThings #40 (merged)
- Depends on: B13, T219
- Touches: work/App-Director and work/SaaSAllTheThings: framework/tools/ui/package.json, framework/tools/ui_capture.sh, framework/.app-director/procedures/ui-design.md (SaaSAllTheThings: its ui-design procedure), project/product/ui/README.md, ONBOARDING.md, selftest.sh, framework/tools/ui/capture.mjs (SaaSAllTheThings also examples/order-desk/product/ui/README.md)
- Done when: in both frameworks `engines.node` in `framework/tools/ui/package.json`, the Node check in `ui_capture.sh` and every place the docs, onboarding or selftest name Node 18 say Node 20 or newer, which playwright 1.64.1 declares (check) · following AGENTS.md › Project rules for framework work
- Found in: B13 (playwright 1.64.1 declares `node >=20`, and `^1.50.0` already resolved to it, so a Node 18 machine passes the check and then fails the install)
- Brief: Scope › Framework features

### T221 · Release App-Director 1.12.0 · done 2026-10-29 · S · agent
- Depends on: T213, T215, T217, B13, T220
- PRs: App-Director #40 (merged); v1.12.0 tagged and published
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 1.12.0 heading (no generic code runner in the settings template, the gitignored local settings, one App Director heading on upgrade, the exact Playwright pin and Node 20), passes the selftest and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v1.12.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T222 · Release Godot-Director 4.6.0 · done 2026-10-29 · S · agent
- Depends on: T190, T218
- PRs: Godot-Director #45 (merged); v4.6.0 tagged and published
- Touches: work/Godot-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 4.6.0 heading (autoplay beside the tests, and the named crashed process), passes the selftest without the Godot path and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v4.6.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T223 · Release SaaSAllTheThings 0.14.1 · done 2026-10-29 · S · agent
- Depends on: T219, T220
- PRs: SaaSAllTheThings #40 (merged); v0.14.1 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists (every skill's version and `--branch` line included), CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier, skill version and `--branch v0.14.1` line together, turns Unreleased into the 0.14.1 heading (the exact Playwright pin and Node 20), passes the selftest and carries the release notes, with What's new, How to install and How to upgrade, in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v0.14.1 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T224 · Docs follow App-Director 1.12.0, Godot-Director 4.6.0 and SaaSAllTheThings 0.14.1 · done 2026-10-29 · M · agent
- Depends on: T221, T222, T223
- Touches: frameworks.lock, docs/**/*.md (the framework links), docs/how-to/ui.md, docs/how-to/trouble.md, docs/how-to/where.md, docs/how-to/check.md, docs/frameworks/godot-director.md
- Done when: `frameworks.lock` and every framework link move to v1.12.0, v4.6.0 and v0.14.1; the site says screen capture in App-Director and SaaSAllTheThings needs Node 20 or newer and installs one exact Playwright version (the "Playwright isn't pinned" limit goes); that App-Director's settings allow no generic code runner, so a stack command the agent runs directly asks first unless `.claude/settings.local.json` allows that exact command, and that the installer gitignores that file, claiming neither for the other two frameworks unless their releases do; that Godot-Director's check, in a parallel run with autoplay in the check, plays the scenarios beside the tests, and names a Godot process that exits without an error line; each checked against the releases and without overclaiming; the selftest passes with no WARN (check)
- Brief: Scope › Framework features

### T98 · The director tests /ui-design in a game · todo · - · human
- Depends on: T97
- Touches: a Godot game of the director's, with Godot-Director 3.11.0
- Done when: the director has captured, drawn, processed and verified at least one screen with the released /ui-design, and said whether App-Director and SaaSAllTheThings should follow as the anchor says or after changes (demo)
- Brief: Scope › Planned framework changes

### B17 · The wildcard git allow rules write and read any file without a prompt (A01:2025 Broken Access Control) · done 2026-10-29 · M · agent · med
- Touches: .claude/settings.json, .claude/hooks/guard-commands.sh, selftest.sh, AGENTS.md (the settings and the guard are framework-owned: an App-Director item too, as T213 was)
- Repro: 1. `.claude/settings.json:15-17,21,23-24` allow `git diff *`, `git log *`, `git show *`, `git commit *`, `git stash *` and `git worktree *` with any flags. 2. `git log --output=<path>` (and `git diff`, `git show` or `git stash show` with `--output`) writes text to any path, such as `tools/check.local.sh`, which the allowed `bash tools/check.sh` then runs; `git diff --no-index /dev/null <path>`, or `git commit -F <path>` and then `git log`, prints any file on the machine, past the Read deny rules. Expected: no allow rule writes a file, reads outside the repository or runs code without a prompt. Actual: these flags do, by git's documented options (not yet confirmed on this machine: confirm each with a harmless write or read in a scratch folder first). Selftest section 8 checks code runners only (`selftest.sh:422-431`). The same class as B14 (`git grep -O`) and B15 (deny rules for the credential stores).
- Found in: product/security/2026-10-29.md › F1
- Brief: -

### B18 · The pre-commit secrets scan skips Markdown, shell, HTML and the records (A07:2025 Authentication Failures) · done 2026-10-30 · S · agent · low
- Touches: .githooks/pre-commit (framework-owned: App-Director and SaaSAllTheThings items too, T240 and T242)
- Repro: 1. Stage a change to a page under `docs/`, `overrides/main.html`, a script under `tools/`, `selftest.sh`, `requirements.txt`, `frameworks.lock` or `TASKS.md`, and commit. 2. Expected: the pre-commit hook scans the staged change for secrets, as `rules.md` › Secrets says. Actual: `.githooks/pre-commit:21-27` runs the check and its staged gitleaks scan only when a staged file ends in `ts`, `tsx`, `js`, `jsx`, `mjs`, `dart`, `py`, `json`, `yaml` or `yml` or is one of the check's own files, and `tools/check.sh:67-71` fingerprints the same set, so `--if-changed` (the hook and the Stop hook) reuses an earlier pass after any other change. CI's full-history scan finds it only once it's pushed to the public repository.
- Found in: product/security/2026-10-29.md › F2
- Brief: -

### B19 · The publish and release pushes follow git push config the scripts don't pin (A01:2025 Broken Access Control) · done 2026-10-30 · XS · agent · low
- Touches: tools/work-publish.sh, tools/work-release.sh
- Repro: 1. In a clone, set `remote.origin.push`, or `push.followTags=true` with a local annotated tag the bundle commits reach. 2. Run `bash tools/work-publish.sh work/<repo>`. Expected: only `refs/heads/<branch>` is pushed, to the same name, as the header (`tools/work-publish.sh:14-17`) promises. Actual: `tools/work-publish.sh:242` runs `git push -u origin "$branch"` with no explicit destination, so a push mapping decides where it lands (a `+` in it forces the push) and followTags pushes the tag too, before the director merges anything; `tools/work-release.sh` pushes its tag the same way. Neither setting is on this machine today.
- Found in: product/security/2026-10-29.md › F3
- Brief: -

### B20 · This repo's screen-capture tooling still takes an open Playwright range (A03:2025 Software Supply Chain Failures) · done 2026-10-30 · XS · agent · low
- Touches: tools/ui/package.json, tools/ui/.npmrc (App Director's files: the App Director upgrade to its current release brings the pin)
- Repro: 1. Read `tools/ui/package.json:9`, `"playwright": "^1.50.0"`, with `package-lock=false` in `tools/ui/.npmrc`. 2. Expected: the exact pin App-Director's release ships (B13). Actual: `npm install` here takes the newest release in the range. Nothing is installed (no `tools/ui/node_modules`), and the site doesn't use the tooling.
- Found in: product/security/2026-10-29.md › F4
- Brief: -

### T225 · The director reviews who can change the repositories and accounts (A01:2025 Broken Access Control) · todo · - · human
- Depends on: -
- Touches: -
- Done when: the director has reviewed who has write or admin access to the four repositories, their Pages settings, the WordPress site and its hosting, itch.io and the Anthropic account, removed what isn't needed, and set when to review it again (on a schedule and when someone leaves) (demo)
- Brief: -

### T226 · The director checks the Pages settings (A02:2025 Security Misconfiguration) · todo · - · human
- Depends on: -
- Touches: -
- Done when: the Pages source is GitHub Actions, "Enforce HTTPS" is on and the `github-pages` environment deploys only from `main`, checked in this repository's settings (demo)
- Brief: -

### T227 · The director turns on dependency alerts and pip updates (A03:2025 Software Supply Chain Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: Dependabot alerts are on in all four repositories and Dependabot proposes `pip` updates where a repository has Python packages, beside the action updates, and the director has said who may add a dependency (demo)
- Brief: -

### T228 · The director rotates the GitHub and WordPress credentials (A04:2025 Cryptographic Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: the gh token, the git credential entry and the SSH keys on this machine and the WordPress application password are rotated, unused application passwords are revoked, the WordPress password lives only in the local MCP configuration, and the director has set when to rotate them again (demo)
- Brief: -

### T229 · The director reviews misuse before changing the agent's permissions or the publish scripts (A06:2025 Insecure Design) · todo · - · human
- Depends on: -
- Touches: -
- Done when: the director has thought through how a change to `.claude/settings.json`, `tools/work-publish.sh` or `tools/work-release.sh` could be misused, starting with B17 and B19, and keeps doing so before each such change (demo)
- Brief: -

### T230 · The director turns on two-factor authentication on every account (A07:2025 Authentication Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: two-factor authentication is on for GitHub, WordPress and its hosting, itch.io and the Anthropic account (demo)
- Brief: -

### T231 · The director sets the GitHub rulesets and Actions settings (A08:2025 Software or Data Integrity Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: a branch ruleset on `main` in all four repositories requires a pull request and blocks force-push and deletion, a tag ruleset protects `v*` in the three framework repositories, the default `GITHUB_TOKEN` is read-only, only GitHub-owned or verified Actions may run, and secret scanning push protection is on (demo)
- Brief: -

### T232 · The director routes the alerts and writes an incident note (A09:2025 Security Logging and Alerting Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: failed workflow runs and Dependabot and secret scanning alerts reach the director's email, and a short note says what to do if the site is defaced or a token leaks (demo)
- Brief: -

### T233 · App-Director: the guard blocks the git flags that write or read any file · done 2026-10-29 · M · agent
- PRs: App-Director #41 (merged)
- Depends on: B17
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, selftest.sh
- Done when: the template's guard hook blocks the git flags that write a file, read a file outside the repository or run a configured command, as this repo's does after B17, and its settings deny them; App-Director's selftest feeds the hook each case and fails when a wildcard git allow rule has no matching deny rules; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T234 · Godot-Director: the agent's git allow rules can't write or read any file · done 2026-10-30 · M · agent
- PRs: Godot-Director #46 (merged)
- Depends on: T233
- Touches: work/Godot-Director: framework/.claude/settings.json, its command hook, selftest.sh
- Done when: `git diff *`, `git log *`, `git show *` and `git commit *` in the template's allow list can no longer write a file, read a file outside the repository or run a configured command without a prompt, by the same means as App-Director's (product/security/2026-10-29.md › F1), and the selftest proves it (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T235 · SaaSAllTheThings: the agent's git allow rules can't write or read any file · done 2026-10-30 · M · agent
- PRs: SaaSAllTheThings #41 (merged)
- Depends on: T233
- Touches: work/SaaSAllTheThings: framework/.claude/settings.json, framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: `git diff *`, `git log *`, `git show *` and `git commit *` in the template's allow list can no longer write a file, read a file outside the repository or run a configured command without a prompt, by the same means as App-Director's (product/security/2026-10-29.md › F1), and the selftest proves it (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T236 · Release App-Director 1.12.1 · done 2026-10-30 · S · agent
- Depends on: T233
- PRs: App-Director #42 (merged); v1.12.1 tagged and published
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 1.12.1 heading (the guard blocks git's file-writing and file-reading flags), passes the selftest and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v1.12.1 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T237 · Release Godot-Director 4.6.1 · done 2026-10-30 · S · agent
- Depends on: T234
- PRs: Godot-Director #46 (merged); v4.6.1 tagged and published
- Touches: work/Godot-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 4.6.1 heading (the guard blocks git's file-writing and file-reading flags), passes the selftest without Godot and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v4.6.1 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T238 · Release SaaSAllTheThings 0.14.2 · done 2026-10-30 · S · agent
- Depends on: T235
- PRs: SaaSAllTheThings #41 (merged); v0.14.2 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists (every skill's version and `--branch` line included), CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier, skill version and `--branch v0.14.2` line together, turns Unreleased into the 0.14.2 heading (the guard blocks git's file-writing and file-reading flags), passes the selftest and carries the release notes, with What's new, How to install and How to upgrade, in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v0.14.2 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T239 · Docs follow App-Director 1.12.1, Godot-Director 4.6.1 and SaaSAllTheThings 0.14.2 · done 2026-10-30 · S · agent
- Depends on: T236, T237, T238
- Touches: frameworks.lock, docs/**/*.md (the framework links), docs/frameworks/index.md, docs/how-to/where.md
- Done when: `frameworks.lock` and every framework link move to v1.12.1, v4.6.1 and v0.14.2; the site says that each framework's command guard also blocks the git flags that write a file, read a file outside the repository or run a configured command, so a commit message comes from `-m` or stdin, checked against the releases and without overclaiming; the selftest passes with no WARN (check)
- Brief: Scope › Framework features

### T240 · App-Director: the guard closes the git grep pager, the credential stores and the unscanned commits · done 2026-10-30 · M · agent
- PRs: App-Director #43 (merged)
- Depends on: B14, B15, B18
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, framework/.githooks/pre-commit, selftest.sh
- Done when: the template's guard hook, settings and pre-commit hook match this repo's after B14, B15 and B18 (the grep pager, a tag message from a file and script paths that leave tools/ blocked; the gh, git credential and SSH stores denied; the staged secrets scan on every commit), App-Director's selftest covers each case, and it passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T241 · Godot-Director: the agent can't read the gh, git credential and SSH stores without the human · done 2026-10-30 · S · agent
- PRs: Godot-Director #47 (merged)
- Depends on: B15
- Touches: work/Godot-Director: framework/.claude/hooks/guard-git.sh, framework/.claude/settings.json, selftest.sh
- Done when: the template's settings deny reads of the SSH folder, git's credential files and the gh token store, and its guard hook blocks shell reads of them and the gh and git commands that print a stored credential, as this repo's do after B15; the selftest covers each case and passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T242 · SaaSAllTheThings: the guard closes the git grep pager, the credential stores and the unscanned commits · done 2026-10-30 · M · agent
- PRs: SaaSAllTheThings #42 (merged)
- Depends on: B14, B15, B18
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, framework/.githooks/pre-commit, selftest.sh
- Done when: the template's guard hook blocks the grep pager, its settings and guard keep the agent out of the gh, git credential and SSH stores, and its pre-commit hook runs its secrets scan on every commit, as this repo's do after B14, B15 and B18; the selftest covers each case and passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T243 · Release App-Director 1.12.2 · done 2026-10-30 · S · agent
- Depends on: T240
- PRs: App-Director #43 (merged); v1.12.2 tagged and published
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 1.12.2 heading, passes the selftest and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v1.12.2 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T244 · Release Godot-Director 4.6.2 · done 2026-10-30 · S · agent
- Depends on: T241
- PRs: Godot-Director #47 (merged); v4.6.2 tagged and published
- Touches: work/Godot-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 4.6.2 heading, passes the selftest without Godot and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v4.6.2 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T245 · Release SaaSAllTheThings 0.14.3 · done 2026-10-30 · S · agent
- Depends on: T242
- PRs: SaaSAllTheThings #42 (merged); v0.14.3 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists (every skill's version and `--branch` line included), CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier, skill version and `--branch v0.14.3` line together, turns Unreleased into the 0.14.3 heading, passes the selftest and carries the release notes with What's new, How to install and How to upgrade, in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v0.14.3 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T246 · Docs follow App-Director 1.12.2, Godot-Director 4.6.2 and SaaSAllTheThings 0.14.3 · done 2026-10-30 · S · agent
- Depends on: T243, T244, T245
- Touches: frameworks.lock, docs/**/*.md (the framework links), docs/frameworks/index.md, docs/how-to/where.md, docs/concept/check.md
- Done when: `frameworks.lock` and every framework link move to v1.12.2, v4.6.2 and v0.14.3; the site says that each framework keeps the agent out of the gh, git credential and SSH stores, and that in App-Director and SaaSAllTheThings every commit is scanned for secrets, checked against the releases and without overclaiming; the selftest passes with no WARN (check)
- Brief: Scope › Framework features

### T247 · Godot-Director: the check and the pre-commit hook scan for secrets · done 2026-10-30 · M · agent
- PRs: Godot-Director #48 (merged)
- Depends on: -
- Touches: work/Godot-Director: framework/tools/check.sh, framework/.githooks/pre-commit, selftest.sh, the onboarding toolchain step
- Done when: with gitleaks installed, a credential committed in a game (a store upload key, an API token in a script or a config file) is caught before it enters history, by the check and by the pre-commit hook on every commit, whatever is staged; without it, both print a note naming the install and go on; the selftest proves both with a secret assembled at run time (check) · following AGENTS.md › Project rules for framework work
- Note: the director chose gitleaks only when it's installed (2026-10-30): with gitleaks, the check and the pre-commit hook scan; without it, they print a note and go on, so a game needs no extra install. Found while building T241.
- Brief: Scope › Framework features

### T248 · SaaSAllTheThings: the guard and the Read rules block .env, .pem and .key reads · done 2026-10-30 · S · agent
- PRs: SaaSAllTheThings #43 (merged)
- Depends on: -
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, selftest.sh
- Done when: the template's settings deny the Read tool `.env`, `*.pem` and `*.key` files, and its guard hook blocks shell reads of them, quoted paths included, as App-Director's do; the selftest covers each case and passes (check) · following AGENTS.md › Project rules for framework work
- Note: found while building T242: App-Director has both, SaaSAllTheThings has neither.
- Brief: Scope › Framework features

### T249 · Release Godot-Director 4.7.0 · done 2026-10-30 · S · agent
- Depends on: T247
- PRs: Godot-Director #48 (merged); v4.7.0 tagged and published
- Touches: work/Godot-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 4.7.0 heading, passes the selftest without Godot and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v4.7.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T250 · Release SaaSAllTheThings 0.14.4 · done 2026-10-30 · S · agent
- Depends on: T248
- PRs: SaaSAllTheThings #43 (merged); v0.14.4 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists (every skill's version and `--branch` line included), CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier, skill version and `--branch v0.14.4` line together, turns Unreleased into the 0.14.4 heading, passes the selftest and carries the release notes, with What's new, How to install and How to upgrade, in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v0.14.4 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T251 · Docs follow Godot-Director 4.7.0 and SaaSAllTheThings 0.14.4 · done 2026-10-30 · S · agent
- Depends on: T249, T250
- Touches: frameworks.lock, docs/**/*.md (the Godot-Director and SaaSAllTheThings links), docs/frameworks/godot-director.md, docs/concept/check.md, docs/frameworks/index.md, docs/how-to/start-game.md
- Done when: `frameworks.lock` and every Godot-Director and SaaSAllTheThings link move to v4.7.0 and v0.14.4; the site says Godot-Director's check and pre-commit hook scan for secrets when gitleaks is installed, and go on with a note when it isn't, checked against the release and without overclaiming; the selftest passes with no WARN (check)
- Brief: Scope › Framework features

### B21 · The .env rules miss .env.local and other .env.* files (A01:2025 Broken Access Control) · done 2026-10-30 · S · agent · low
- Touches: .claude/settings.json, .claude/hooks/guard-commands.sh, selftest.sh (the settings and the guard are framework-owned: App-Director and SaaSAllTheThings items too)
- Repro: 1. `.claude/settings.json` denies `Read(.env)` and `Read(**/.env)`, and the guard's credential check matches a path ending in `.env` only, here and in App-Director's and SaaSAllTheThings' templates. 2. Expected: `.env.local`, `.env.production` and the other `.env.*` files that hold real values are denied to the Read tool and blocked for shell reads, while `.env.example`, which is committed and holds no values, stays readable. Actual: `cat .env.local` passes the guard, and the Read rules name `.env` exactly (the Read tool on `.env.local` is not yet confirmed).
- Found in: T248
- Brief: -

### T252 · App-Director: the .env rules cover .env.local and the other .env.* files · done 2026-10-31 · S · agent
- PRs: App-Director #44 (merged)
- Depends on: B21
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, selftest.sh
- Done when: the template's guard hook and settings match this repo's after B21 (`.env.local`, `.env.production` and the other `.env.*` files blocked and denied, `.env.example`, `.env.sample`, `.env.template` and `.env.dist` readable), and App-Director's selftest covers each case and passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T253 · SaaSAllTheThings: the .env rules cover .env.local and the other .env.* files · done 2026-10-31 · S · agent
- PRs: SaaSAllTheThings #44 (merged)
- Depends on: B21
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, selftest.sh
- Done when: the template's guard hook and settings block and deny `.env.local`, `.env.production` and the other `.env.*` files while `.env.example`, `.env.sample`, `.env.template` and `.env.dist` stay readable, as this repo's do after B21, and the selftest covers each case and passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T254 · Release App-Director 1.12.3 · done 2026-10-31 · S · agent
- Depends on: T252
- PRs: App-Director #44 (merged); v1.12.3 tagged and published
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 1.12.3 heading, passes the selftest and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v1.12.3 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T255 · Release SaaSAllTheThings 0.14.5 · done 2026-10-31 · S · agent
- Depends on: T253
- PRs: SaaSAllTheThings #44 (merged); v0.14.5 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists (every skill's version and `--branch` line included), CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier, skill version and `--branch v0.14.5` line together, turns Unreleased into the 0.14.5 heading, passes the selftest and carries the release notes, with What's new, How to install and How to upgrade, in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v0.14.5 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T256 · Docs follow App-Director 1.12.3 and SaaSAllTheThings 0.14.5 · done 2026-10-31 · XS · agent
- Depends on: T254, T255
- Touches: frameworks.lock, docs/**/*.md (the App-Director and SaaSAllTheThings links)
- Done when: `frameworks.lock` and every App-Director and SaaSAllTheThings link move to v1.12.3 and v0.14.5 (the releases change only the `.env` rules, which no page describes); the selftest passes with no WARN (check)
- Brief: Scope › Framework features

### B22 · The guard checks only the first file a read names for env, pem and key files (A01:2025 Broken Access Control) · done 2026-10-31 · S · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an App-Director item too)
- Repro: 1. Feed the guard hook `cat README.md .env.local`, `tail -n 20 .env` or `head -5 certs/server.pem`. 2. Expected: each is blocked, as the guard blocks `cat .env.local`. Actual: the `.env` and `.pem`/`.key` checks in `reads_cred_file` match only the first word after the read command, so a second file argument or a leading option passes, here and in App-Director's template (the credential-store check already looks at every argument). SaaSAllTheThings' guard tests every argument since its T32.
- Found in: T253
- Brief: -

### T257 · App-Director: the guard checks every file a read names for env, pem and key files · done 2026-11-01 · S · agent
- PRs: App-Director #45 (merged)
- Depends on: B22
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the template's guard hook matches this repo's after B22 (a second file argument or a leading option no longer gets an `.env`, `.env.*`, `.pem` or `.key` read past it), and App-Director's selftest covers each case and passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T258 · Release App-Director 1.12.4 · done 2026-11-01 · S · agent
- Depends on: T257
- PRs: App-Director #45 (merged); v1.12.4 tagged and published
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 1.12.4 heading, passes the selftest and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v1.12.4 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T259 · tools/usage.py prices a project's work per item · done 2026-11-01 · S · agent
- Depends on: T148
- Touches: tools/usage.py, AGENTS.md (Architecture › Usage), docs/concept/cost-tuning.md
- Done when: `python tools/usage.py --tasks <project> <repo> [--csv <file>]` prints the project's total, the director's keyboard hours, the orchestrator's and the subagents' hours, the cost and time by item size and by kind (T, B, R), and the most expensive items, and writes one row per item to the CSV when asked; a subagent's cost goes to the item its first prompt names and its kind comes from its `.meta.json`, the orchestrating sessions' cost and the director's time go to the next item commit, and the per-item total matches the project total; run on BRFService as it stood on 2026-10-31 it gives $949 for 265 done items of 320, and its director hours equal the keyboard hours `python tools/usage.py <project>` reports; the selftest passes (check)
- Brief: -

### T260 · Docs follow Godot-Director 4.8.0 and App-Director 1.12.4 · done 2026-11-01 · S · agent
- Depends on: T258
- Touches: frameworks.lock, docs/**/*.md (the Godot-Director and App-Director links), docs/how-to/check.md, docs/frameworks/godot-director.md
- Done when: `frameworks.lock` and every Godot-Director and App-Director link move to v4.8.0 and v1.12.4; the site describes what 4.8.0 ships where it covers those areas (`bash tools/check.sh --only tests/<file>.gd` to run one test file, the log review leaving the committed signatures file alone, a single-file restore or checkout no longer asking), checked against the release and without overclaiming; the selftest passes with no WARN (check)
- Note: Godot-Director 4.8.0 came from another session's pull request (#49), released here on 2026-11-01 with its notes set as the description.
- Brief: Scope › Framework features

### T261 · App-Director: user stories anchor every item · done 2026-11-02 · L · agent
- PRs: App-Director #46 (merged); released with the next App-Director bundle
- Depends on: -
- Touches: work/App-Director: project/product/user-stories.md (new), framework/tools/stories.sh (new), framework/.app-director/tasks.md, framework/.app-director/rules.md, framework/.app-director/procedures/ (design, next-task, acceptance, align, build, ui-design, drift-reset), framework/.claude/settings.json, framework/.claude/skills/ (design, align), project/TASKS.md, project/tools/check.cfg, ONBOARDING.md, README.md, CHANGELOG.md, TASKS.md, selftest.sh
- Done when: `product/user-stories.md` in the project template, with a worked example: the value in one paragraph per role, the roles, then a table per area with the story ID (`US-<n>`, the next one in the file's header), the story ("As a ... I ..., so ...") and the date the director confirmed it (or `unconfirmed`), and a line with the date and commit the stories were last validated; the item format gains `Stories:` (the IDs an item serves, or `-` for foundation, tooling and infrastructure), and the TASKS.md seed shows it; the design procedure drafts the new or changed stories a design needs and puts them to the director with it, and a feature item with no story gets one drafted before it is built; the director validates on a cadence (`[stories] every` in `tools/check.cfg`, 10 built items by default), proposed by next-task as the security assessment is and named in a run's final report, in each acceptance check (the stories behind the checked items, with "still right?") and in align (stories no item serves, feature items with no story, stories unconfirmed past the cadence); the "each fact lives in one place" table names the file; an existing app's onboarding writes the stories from the code, unconfirmed; the selftest checks the template, the field and the setting; it passes (check) · following AGENTS.md › Project rules for framework work
- Note: the reference build; T262 and T263 follow its format and cadence. Decided 2026-11-01 (product/decisions.md).
- Brief: Scope › Planned framework changes

### T262 · SaaSAllTheThings: user stories anchor every item · done 2026-11-02 · L · agent
- PRs: SaaSAllTheThings #45 (merged)
- Depends on: T261
- Touches: work/SaaSAllTheThings: project/product/user-stories.md (new), framework/tools/stories.sh (new), framework/.satt/tasks.md, framework/.satt/rules.md, framework/.satt/procedures/ (design, next-task, acceptance, align, assess, build, ui-design, drift-reset, roadmap), framework/.satt/templates/assessment.md, framework/.satt/workshops/ (README, capabilities), framework/.claude/settings.json, the design, align and assess skills, skills/saas-assessment, skills/saas-design-session (SKILL.md, references/), project/product/prd.md, project/TASKS.md, project/tools/check.cfg, examples/order-desk/, ONBOARDING.md, README.md, CHANGELOG.md, TASKS.md, selftest.sh
- Done when: the same as App-Director's T261, with the PRD's personas and roles naming the story roles and the PRD linking the file, and `/assess` writing the stories it finds in an existing app or proof of concept into its report, unconfirmed; the selftest checks the template, the field and the setting; it passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes

### T263 · Godot-Director: user stories, if onboarding turns them on · done 2026-11-02 · L · agent
- PRs: Godot-Director #50 (merged)
- Depends on: T261
- Touches: work/Godot-Director: project/design/user-stories.md (new), framework/tools/stories.sh (new), framework/.godot-director/tasks.md, framework/.godot-director/rules.md, framework/.godot-director/procedures/ (design, next-task, align, build, playtest or function-check, ui-design), framework/.claude/settings.json, the design and align skills, project/TASKS.md, project/tools/check.cfg, ONBOARDING.md, README.md, CHANGELOG.md, TASKS.md, selftest.sh
- Done when: onboarding asks once whether the game uses user stories and records the answer as a project rule; with them on, the same as App-Director's T261, in `design/user-stories.md` with "As a player ..." stories under the design pillars, the GDD linking the file, and the validation in the playtest or function check where Godot-Director has no acceptance check; with them off, no item needs `Stories:` and nothing asks; the selftest checks both settings; it passes (check) · following AGENTS.md › Project rules for framework work
- Note: built with deviations the review accepted: the stories file is a framework-owned template that design.md copies when a game turns them on, not a `project/` seed (the installer would restore a seed on every upgrade of a game with them off), so `project/TASKS.md` is untouched; `(none)` instead of `-` and the `GDD:` field, as Godot-Director's items already use; `every=10` in the ConfigFile style; the onboarding question recommends neither answer. Also changed: drift-reset.md, playtesting/README.md, project/AGENTS.md and examples/market-day/.
- Brief: Scope › Planned framework changes

### T264 · App-Director: a prototype routine, apart from real building · done 2026-11-02 · L · agent
- PRs: App-Director #47 (merged)
- Depends on: T261
- Touches: work/App-Director: framework/.app-director/procedures/prototype.md (new), framework/.claude/skills/prototype/SKILL.md (new), framework/tools/prototype.sh (new), framework/.githooks/pre-commit, framework/.githooks/pre-push (new), framework/.claude/hooks/ (stop-check, guard-commands), framework/.claude/settings.json, framework/.app-director/rules.md, framework/.app-director/procedures/ (design, build), framework/.app-director/tasks.md, ONBOARDING.md, README.md, CHANGELOG.md, TASKS.md, selftest.sh
- Done when: a tool-neutral `prototype.md` procedure and a `/prototype` skill: `/prototype <name>` creates a git worktree beside the project on a new `proto/<name>` branch from the latest main, runs `bash tools/setup-clone.sh` there and starts (or tells the director to open) a session in that folder; in a prototype session rules.md's loop is off (no items, no records, no builder), commits need no approval, the pre-commit hook skips the project check on a `proto/` branch but keeps the secrets scan, the guard stays on, and nothing is pushed or merged; the director keeps notes on what was tried and how it felt in `PROTOTYPE.md` in the worktree; `/prototype harvest <name>` in the main session reads the prototype's diff against main and its notes and runs the design procedure on them, proposing decisions, user stories and items that each name the prototype (`Prototype: proto/<name>`), built from main like any item; after the harvest it offers to remove the worktree and delete the branch, on the director's yes; rules.md, the README and the skills list describe it; with `/ui-design` captures before and after where the app has a web UI; the selftest checks the procedure, the skill, the hook's `proto/` rule (the secrets scan still blocks there) and a harvest that writes no item without the director; it passes (check) · following AGENTS.md › Project rules for framework work
- Note: the reference build; T265 and T266 follow it. Decided 2026-11-01 (product/decisions.md). Depends on T261 so the harvest proposes user stories. Built with two deviations from Done when: the worktree starts from the local main, with an offer to bring it up to date when origin is ahead, and the agent removes the worktree but the director runs `git branch -D`, which the guard keeps with the human.
- Brief: Scope › Planned framework changes

### T265 · SaaSAllTheThings: a prototype routine, apart from real building · done 2026-11-02 · M · agent
- PRs: SaaSAllTheThings #45 (merged)
- Depends on: T264, T262
- Touches: work/SaaSAllTheThings: framework/.satt/procedures/prototype.md (new), framework/.claude/skills/prototype/SKILL.md (new), framework/.satt/rules.md, the design procedure, framework/.githooks/pre-commit, framework/.satt/tasks.md, README.md, selftest.sh
- Done when: the same as App-Director's T264, where a prototype never deploys to any Azure environment and the harvest keeps to the reference architecture (a deviation goes through `/architect` and an ADR, as in any design); the selftest checks the same; it passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes

### T266 · Godot-Director: a prototype routine, apart from real building · done 2026-11-02 · M · agent
- PRs: Godot-Director #51 (merged)
- Depends on: T264, T263
- Touches: work/Godot-Director: framework/.godot-director/procedures/prototype.md (new), framework/.claude/skills/prototype/SKILL.md (new), framework/.godot-director/rules.md, the design procedure, framework/.githooks/pre-commit, framework/.godot-director/tasks.md, README.md, selftest.sh
- Done when: the same as App-Director's T264, where the prototype session can run the game, autoplay and a playtest, and the harvest proposes GDD changes and, when the game uses them, user stories; the selftest checks the same; it passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes

### T267 · App-Director: align reports bugs with no story · done 2026-11-02 · XS · agent
- PRs: App-Director #47 (merged)
- Depends on: T261
- Touches: work/App-Director: framework/.app-director/procedures/align.md, selftest.sh
- Done when: align reports bugs that aren't done and have no `Stories:` line (security bugs included), recommending the story whose behaviour each restores, or `-`, instead of skipping them, as SaaSAllTheThings' align does after T262; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T262's review; App-Director's reference build had the same gap.
- Brief: Scope › Planned framework changes

### T268 · App-Director: the guard reads a git command on any line · done 2026-11-02 · S · agent
- PRs: App-Director #47 (merged)
- Depends on: -
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: a git command that starts on a later line of a multi-line command, after a newline and any spaces or tabs, reaches every git rule (`cd x` newline `git branch -D y` and `cd x` newline, tab, `git log --output=/tmp/x` are blocked), as Godot-Director's guard already does for the newline case; the selftest covers both and passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T265's review: the guard's early exit tests the JSON-escaped command, where a newline is the two characters `\n`, so a later line's `git` never matched.
- Brief: Scope › Planned framework changes

### B23 · The guard skips every git rule when the git command starts on a later line (A01:2025 Broken Access Control) · done 2026-11-02 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: App-Director's T268 fixes the template)
- Repro: 1. Feed the guard hook a Bash command whose first line has no git, such as `cd x`, and whose next line is `git branch -D y`, `git commit --no-verify -m x` or a tab-indented `git log --output=/tmp/x`. 2. Expected: each is blocked, as the same command on its own line is. Actual: the hook exits 0 before any git rule, because its early test reads the JSON-escaped text, where a newline is `\n` and the character before `git` is `n`.
- Found in: T265's review
- Brief: -

### B24 · The guard and the deny rules aren't wired to the PowerShell tool (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/settings.json, selftest.sh (framework-owned: an item for each framework too)
- Repro: 1. Read `.claude/settings.json`: the guard hook's matcher is `Bash|Monitor`, and every allow, ask and deny rule is a `Bash(...)` or `Read(...)` rule. 2. In a session that has the PowerShell tool (this one does), a git command such as `git push --force` or `git commit --no-verify` run through PowerShell never reaches the guard, and the `Bash(...)` deny rules don't apply to it. Expected: the guard sees every shell the agent can use, and the deny rules cover them. Actual: PowerShell commands meet only the default permission prompt.
- Found in: T265's review
- Brief: -

### B25 · A line continuation or a tab hides a flag or a read from the guard (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework too)
- Repro: 1. Feed the guard hook `git commit \` with `-n` on the next line, `git push \` with `--force` on the next line, or `cat`, a tab and `.env.local`. 2. Expected: each is blocked, as `git commit -n`, `git push --force` and `cat .env.local` are. Actual: all three pass: the git rules don't join a backslash line continuation, and the credential-read check matches only a space after the command.
- Found in: B23
- Brief: -

### B27 · A PowerShell read of a credential file passes the guard (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `{"tool_name":"PowerShell","tool_input":{"command":"Get-Content .env.local"}}`, or the same with `gc` or `type`. 2. Expected: blocked (exit 2), as `cat .env.local` is. Actual: exit 0: the credential-read check knows only cat, head, tail, less, more and strings, and the `Read(...)` deny rules don't apply to a shell tool.
- Found in: B24
- Brief: -

### B28 · A PowerShell backtick continuation hides a flag or a read from the guard (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a PowerShell payload whose command is `git push` and a backtick, with `--force` on the next line; or `git commit` and a backtick with `-n` next; or `cat` and a backtick with `.env.local` next. 2. Expected: each is blocked, as the same command on one line is. Actual: exit 0: a backtick at the end of a line continues it in PowerShell, but the hook doesn't read `tool_name`, and B25 joins only a backslash continuation, which is Bash's.
- Found in: B25
- Brief: -

### B31 · A Bash comment ending in a backslash hides the next line from the guard (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a Bash payload whose first line is `# note` and a backslash and whose next line is `git push --force` (or `git commit --no-verify -m x`). 2. Expected: blocked, as the second line alone is, since Bash ends a comment at the line break whatever its last character is. Actual: exit 0: B25's join glues the next line onto the comment. A regression from B25; B28 avoids it for PowerShell by reading the command both as written and as joined.
- Found in: B28
- Brief: -

### B29 · A backslash continuation hides an empty heredoc from the hang check · done 2026-11-03 · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `python3 \` with `- <<'EOF'` on the next line and `EOF` on the line after. 2. Expected: blocked as an empty-heredoc probe, as `python3 - <<'EOF'` then `EOF` is. Actual: exit 0: the hang check reads the raw text, not the command with B25's continuation joined.
- Note: closed by B31's readings of a continued command, with its repro in the selftest.
- Found in: B25
- Brief: -

### B30 · A quoted or path-qualified reader, a backtick inside a word or a StreamReader passes the credential-read check (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a PowerShell payload with `& 'Get-Content' .env.local`, a Bash payload with `/bin/cat .env.local`, a PowerShell payload with a backtick inside the reader or the name (`` Get-Con`tent .env.local ``, `` gc .en`v.local ``), or `[System.IO.StreamReader]::new('.env.local')`. 2. Expected: each is blocked, as `Get-Content .env.local` and `cat .env.local` are. Actual: exit 0: the reader must be a bare word, and a backtick inside a word is PowerShell's escape, which B28's continuation doesn't cover.
- Found in: B27
- Brief: -

### B32 · A command substitution hides a git flag from the guard (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `git push $(echo --force)`, or the same with backticks, as a Bash and as a PowerShell payload. 2. Expected: blocked, as `git push --force` is, or the guard says why a substitution in a git command's arguments can't be judged and blocks it. Actual: exit 0: the rules read the text, not what a substitution prints.
- Found in: B28
- Brief: -

### B33 · A force push before a line break or `;`, or with the flag quoted, passes the guard (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `git push --force` with `echo done` on the next line, `git push --force;echo done`, `git push "--force"`, `git push '--force'` or `git push "--force-with-lease=origin/main"`. 2. Expected: each is blocked, as `git push --force` alone is. Actual: exit 0: the force rule's terminator `([[:space:]=]|$)` doesn't include `;`, `&`, `|` or `)`, and the rule reads the text with quotes blanked (B26 covered only `-n`).
- Found in: B31
- Brief: -

### B34 · A git command inside `bash -c`, `sh -c` or `eval` passes the git rules (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `bash -c 'git push --force'`, `sh -c "git commit --no-verify -m x"`, `eval 'git log --output=x'`, or `sh -c "git push $(echo --force)"`. 2. Expected: blocked, as the inner command alone is. Actual: exit 0: the git rules read the text with quoted strings blanked, so a command passed as a quoted string to a shell is never read.
- Found in: B31
- Brief: -

### B41 · The check takes over four minutes, most of it the selftest's guard cases · done 2026-11-03 · S · agent · med
- Touches: selftest.sh
- Repro: 1. Run `bash tools/check.sh` after any change. 2. Expected: well under the five-minute limit every long command keeps to (rules.md › Commands that may run long), with room for the guard cases still to come. Actual: 255 s on 2026-11-03, after B24 to B34 added several hundred guard cases, each a separate run of the hook in a new bash process. Run the cases in parallel or in fewer processes, keeping each case's own exit code and message, and keep the selftest's output the same.
- Found in: B34
- Brief: -

### B35 · In PowerShell, a comment ending in a backtick before a continued git command hides it (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a PowerShell payload: a comment ending in a backtick, then `git commit` and a backtick, then `-F x`. 2. Expected: blocked. Actual: exit 0: B28 reads a PowerShell command only as written and as joined, while B31 gave Bash a third reading, joined from each line after a comment, which PowerShell needs too.
- Found in: B31
- Brief: -

### B36 · grep, sed, awk and other readers, a reader name split by quotes, and IO.File's Open methods pass the credential-read check (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `grep x .env.local`, `awk 1 .env`, `sed -n p .env.local`, `base64 .env.local` or `xxd .env.local`; `ca''t .env.local` or `c"a"t .env.local`; or a PowerShell payload with `[System.IO.File]::OpenText('.env.local')`, `OpenRead` or `Open`. 2. Expected: each is blocked, as `cat .env.local` is. Actual: exit 0: the reader list has only cat, head, tail, less, more, strings and PowerShell's readers, and only a whole quoted name is read as a reader.
- Found in: B30
- Brief: -

### B37 · A variable in a git command's words hides a flag from the guard (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `FLAG=--force; git push $FLAG`, `git commit $NV -m x` after `NV=--no-verify`, or a shell named by a variable (`$X -c 'git push --force'`). 2. Expected: blocked, as `git push --force` is, or blocked with a message saying the guard can't judge a variable in that position, as B32 does for a substitution. Actual: exit 0: the rules read the text, not a variable's value.
- Found in: B32
- Brief: -

### B38 · `git -c` with a key that runs a command passes the guard (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `git -c alias.x="!echo hi" x`, `git -c core.pager="sh -c x" log`, `git -c core.sshCommand=x fetch`, `git -c diff.external=x diff`, a key from a variable (`git -c "$k=v" log`), or a fetch or push flag that names a program (`git fetch --upload-pack=x`, `git push --receive-pack=x`). 2. Expected: blocked, as `--ext-diff` and `-O` are, since each runs a command of the caller's choice. Actual: exit 0: the guard doesn't read `-c` configuration keys or the flags that name a program for git to run.
- Found in: B32
- Brief: -

### B39 · A quoted git, a heredoc a shell runs, a long-form flag, a quoted credential subcommand or a backtick after a flag passes the git rules (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `"git" push --force`; `bash <<'EOF'` with `git log --output=/tmp/x` in the body; `git branch --delete --force x`, `git push --mirror` or `git push --delete origin x`; `git credential "fill"`; or a body a shell runs with a flag in backticks. 2. Expected: each is blocked, as its plain form is. Actual: exit 0: the git test reads unquoted text, the flag rules read text with heredoc bodies cut, the long forms have no rule, the credential-print rules read the blanked text, and a backtick isn't a flag terminator.
- Found in: B33
- Brief: -

### B40 · A commit message or a file written from a heredoc that names a destructive git command is blocked · done 2026-11-03 · S · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `git commit -F - <<'EOF'` with a body line `fix: git push --force; done`. Or `cat > notes.md <<'EOF'` with a body line naming `git log --output=x` or a backticked `git push --force`. 2. Expected: passes: a body with a quoted delimiter given to `git commit -F -` or `git tag -F -` is a message no shell runs, and a file written from one runs nothing until a shell is given it, which the guard sees then (`bash notes.md`); decide how a written file passes without reopening `cat > x.sh <<EOF` followed by `bash x.sh` in the same command. Actual: exit 2: the destructive rules read every heredoc body as commands (B33 added `;`, `&`, `|` and `)` to the terminators that a space already was), and B39's flag rules read a file-writing body as a shell body.
- Found in: B33
- Brief: -

### B42 · A wait loop inside `eval`, `-Command` or `cmd /c` passes the hang check · done 2026-11-03 · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `eval 'until false; do sleep 1; done'`. 2. Expected: blocked, as the same loop on its own is. Actual: exit 0: B34 made the hang rules read a nested script's long sleep, but the loop rule doesn't read nested scripts.
- Found in: B34
- Brief: -

### B43 · A backtick inside a Bash comment blocks the command · done 2026-11-03 · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a Bash payload whose first line is `# note` and a backtick and whose next line is `git status`. 2. Expected: passes: a backtick in a comment starts no command substitution. Actual: exit 2: B32's rule reads it as an unclosed substitution in a git command's words.
- Found in: B35
- Brief: -

### B44 · A backslash inside a reader's name passes the credential-read check (A01:2025 Broken Access Control) · done 2026-11-03 · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a Bash payload with `c\at .env.local` (or `he\ad .env`). 2. Expected: blocked, as `cat .env.local` is: outside quotes a backslash only escapes the next character, so Bash runs `cat`. Actual: exit 0: B36 removes quotes inside a word but not a backslash.
- Found in: B36
- Brief: -

### B45 · A variable as the command's name, or as a shell's script, passes the guard (A01:2025 Broken Access Control) · done 2026-11-03 · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `G=git; $G push --force`, `$G push --force` alone, or `bash -c "$CMD"`. 2. Expected: blocked, or blocked with a message saying the guard can't judge what the variable holds, as B37 does for `$X -c` and a variable in a git command's words. Actual: exit 0: B37 reads a variable command name only before `-c` or `-Command`, and a shell's script held in a variable is never read.
- Found in: B37
- Brief: -

### B46 · In PowerShell, a git command name in another case passes every git rule (A01:2025 Broken Access Control) · done 2026-11-03 · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a PowerShell payload with `GIT push --force origin main` (or `Git commit --no-verify -m x`). 2. Expected: blocked, as `git push --force` is: PowerShell finds commands case-insensitively, and on Windows `GIT` runs git. Actual: exit 0: the git test and the git-word matches are case-sensitive.
- Found in: B38
- Brief: -

### B47 · A quoted `bash`, or `bash` in another case, before a script path that leaves `tools/` passes the guard (A01:2025 Broken Access Control) · done 2026-11-03 · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `"bash" tools/../x.sh`, `'sh' tools/stacks/../../x.sh` or `BASH tools/stacks/../../x.sh`. 2. Expected: blocked, as `bash tools/../x.sh` is. Actual: exit 0: the script-path rule reads the shell's name with its quotes and in its case, while B39 and B46 made the git name read as the shell runs it and in any case.
- Found in: B39
- Brief: -

### B48 · A pull request body, a message naming a git command with a variable, or a word that only names PowerShell is blocked · done 2026-11-03 · S · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `gh pr edit 5 --body-file - <<'EOF'` or `gh pr create --body "$(cat <<'EOF' ... EOF)"` with a body naming `git push --force`; `git commit -q -F - <<'EOF'` with a body line `fix: git push $X handling`; or `echo PowerShell 'bash tools/../x.sh'`, where B34's wrapper reader takes any word PowerShell or pwsh as an interpreter. 2. Expected: passes: each body is a message no shell runs, as a quoted-delimiter commit message is since B39 and B40. Actual: exit 2: only `git commit` and `git tag` messages count as text, and B37's variable rule reads every heredoc body. Release notes passed to `gh pr edit` that name such a command would be blocked.
- Note: a PowerShell, pwsh or shell name starts a script anywhere except right after echo, printf, Write-Output, Write-Host or write (the builder's option b, taken by the orchestrator: it keeps every launcher form blocked that was blocked before, such as ssh, find -exec, docker exec and Start-Process).
- Found in: B40
- Brief: -

### B49 · A `for ((;;))` or `do ... while` loop, a PowerShell or cmd sleep, or a substitution before `timeout` passes the hang check · done 2026-11-03 · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `for ((;;)); do sleep 1; done`; a PowerShell payload with `do { Start-Sleep 1 } while ($true)`; `powershell -Command "Start-Sleep -Seconds 600"` or `cmd /c "timeout /t 300"`; or `timeout 60 echo "$(until false; do sleep 1; done)"`. 2. Expected: each is blocked, as `while true; do sleep 1; done` and `sleep 600` are. Actual: exit 0: the loop rule reads only `until` and `while ... do`, the lone-sleep rule only `sleep N`, and a `timeout` in front is read as covering a substitution that runs before it starts.
- Found in: B42
- Brief: -

### B50 · The hang check reads a commit message or a pull request body as commands · done 2026-11-03 · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `git commit -q -F - -- a <<'EOF'` with a body line saying PowerShell's While loop with Start-Sleep is now seen. The same with a `gh pr edit 5 --body-file - <<'EOF'` body. 2. Expected: passes: B40 and B48 made a quoted-delimiter message to git commit, git tag or gh text for the git rules, and the hang rules should read it the same way. Actual: exit 2, "an until or while loop with sleep and no time limit": the hang rules read every heredoc body, and since B42 the loop rule matches in any case, so plain words in a message trip it. It blocked B42's own commit message.
- Found in: B42
- Brief: -

### B51 · A quote in a Bash comment hides a quoted flag or refspec from the git rules (A01:2025 Broken Access Control) · done 2026-11-03 · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a Bash payload whose first line is `# it's` and whose next line is `git push origin ':main'`. 2. Expected: blocked, as the second line alone is. Actual: exit 0: the decoded words pair the comment's quote with the next one, so the refspec reads as quoted text; B43 taught the substitution reader that a comment is text, but not the word decoder.
- Found in: B43
- Brief: -

### B52 · An escaped space in a store path, ANSI-C quoting in a reader's name, or a substitution in a non-git command passes the credential-read check (A01:2025 Broken Access Control) · done 2026-11-03 · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook `cat ~/AppData/Roaming/GitHub\ CLI/hosts.yml`; `$'\x63at' .env.local`; or a PowerShell payload with `echo $(bash -c 'c\at .env.local')`. 2. Expected: each is blocked, as `cat .env.local` and the unescaped store path are. Actual: exit 0: B44 removes a backslash only before an ordinary character, ANSI-C quoting in a reader's name isn't decoded, and a substitution's script is read as a wrapper only in a git command.
- Found in: B44
- Brief: -

### B55 · An assignment (PowerShell's `$x = 1`, Bash's `x+=y`) or `$true` in a script is read as a variable command name and blocked · done 2026-11-03 · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a PowerShell payload with `$x = 1` or `$files = Get-ChildItem docs`, a Bash payload with `powershell -Command 'while ($true) { Get-Date }'`, or a Bash payload with `c="${x:0:1}"; out+="$c"; echo hi`. 2. Expected: passes: an assignment and a literal like `$true`, `$false` or `$null` run no command. Actual: exit 2: B45's rule reads a `$name` in command position as a variable command name, and its assignment prefix has no `+=`. A regression from B45.
- Found in: B49, B50
- Brief: -

### B60 · PowerShell's `Invoke-Expression` or `iex` with a variable passes the guard (A01:2025 Broken Access Control) · done 2026-11-03 · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: T276, T277 and T278 carry the fix)
- Repro: 1. Feed the guard hook a PowerShell payload with `$x = 'git push --force'; iex $x`, `Invoke-Expression $x` or `iex "$x"`. 2. Expected: blocked, as `eval $CMD` is since B45, or read through the resolved assignment. Actual: exit 0: no rule reads Invoke-Expression; the first form was blocked before B55 only because the assignment was read as a command name.
- Found in: B55
- Brief: -

### T269 · Release App-Director 1.13.0 · done 2026-11-02 · S · agent
- Depends on: T264, T267, T268
- PRs: App-Director #47 (merged); v1.13.0 tagged and published
- Touches: work/App-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 1.13.0 heading (the user stories merged in #46, the prototype routine, align's bugs, the guard's later lines), passes the selftest and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v1.13.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes

### T270 · Release SaaSAllTheThings 0.15.0 · done 2026-11-02 · S · agent
- Depends on: T262, T265
- PRs: SaaSAllTheThings #45 (merged); v0.15.0 tagged and published
- Touches: work/SaaSAllTheThings: the version carriers its CLAUDE.md lists (every skill's version and `--branch` line included), CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier, skill version and `--branch v0.15.0` line together, turns Unreleased into the 0.15.0 heading (the user stories and the prototype routine), passes the selftest and carries the release notes, with What's new, How to install and How to upgrade, in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v0.15.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes

### T271 · App-Director: a quoted no-verify, an inline allow and a gate edit can't get a commit past the hooks · done 2026-11-02 · S · agent
- Depends on: T264
- PRs: App-Director #47 (merged)
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, framework/.claude/hooks/ (the protected-files hook), framework/.githooks/pre-commit, framework/tools/prototype.sh, selftest.sh, CHANGELOG.md
- Done when: the guard blocks `git commit` with `-n` or `--no-verify` quoted or split (`'-n'`, `"-n"`, `-""n`, `--no-ve''rify`); in a prototype the pre-commit hook blocks a staged line with `gitleaks:allow`, Edit and Write are refused on the hooks, the guard, `tools/prototype.sh`, `tools/setup-clone.sh` and the gitleaks allowlist files, and `prototype.sh harvest` and `list` name any of those that differ from main's; the selftest covers each; the entry sits under the 1.13.0 heading and the release notes in #47 say so (check) · following AGENTS.md › Project rules for framework work
- Note: found in T266's review, and the quoted `-n` in all four guards (this repo's is B26).
- Brief: Scope › Planned framework changes

### T272 · SaaSAllTheThings: a quoted no-verify and a gate edit can't get a commit past the hooks · done 2026-11-02 · S · agent
- Depends on: T265
- PRs: SaaSAllTheThings #45 (merged)
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, framework/.claude/hooks/guard-authority.sh, framework/tools/prototype.sh, selftest.sh, CHANGELOG.md
- Done when: the guard blocks `git commit` with `-n` or `--no-verify` quoted or split; in a prototype, Edit and Write are refused on the hooks, the guard, `tools/prototype.sh`, `tools/setup-clone.sh` and the files that excuse a scan finding without the human, and `prototype.sh harvest` and `list` name any of those that differ from main's; the selftest covers each; the entry sits under the 0.15.0 heading and the release notes in #45 say so (check) · following AGENTS.md › Project rules for framework work
- Note: found in T266's review; SaaSAllTheThings' scan has no inline allow, so that part doesn't apply.
- Brief: Scope › Planned framework changes

### B26 · A quoted or split no-verify gets a commit past the guard (A01:2025 Broken Access Control) · done 2026-11-02 · S · agent · high
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: App-Director's T271 fixes the template)
- Repro: 1. Feed the guard hook `git commit '-n' -m x`, `git commit "-n" -m x`, `git commit -""n -m x` or `git commit --no-ve''rify -m x`. 2. Expected: each is blocked, as `git commit -n -m x` is. Actual: all pass, because the `-n` test reads the command with its quoted strings blanked; `git commit *` is allowed, so the commit runs without a prompt and skips the pre-commit check and the secrets scan.
- Found in: T266's review
- Brief: -

### T273 · Release Godot-Director 4.9.0 · done 2026-11-02 · S · agent
- Depends on: T263, T266
- PRs: Godot-Director #51 (merged); v4.9.0 tagged and published
- Touches: work/Godot-Director: the version carriers its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with a release commit that bumps every version carrier and template link together, turns Unreleased into the 4.9.0 heading (the user stories merged in #50, the prototype routine, the guard reading every git command as the shell does), passes the selftest without Godot and carries the release notes in its commit body, which become the pull request's description; once merged, `tools/work-release.sh` tags v4.9.0 and publishes the release (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes

### T274 · Docs follow App-Director 1.13.0, SaaSAllTheThings 0.15.0 and Godot-Director 4.9.0: user stories and prototypes · done 2026-11-02 · M · agent
- Depends on: T269, T270, T273
- Touches: frameworks.lock, docs/**/*.md (the framework links), docs/concept/ (a user stories page), docs/skills/ (a /prototype page), docs/how-to/ (decide, check, align, where, a prototype how-to), docs/frameworks/, mkdocs.yml, product/brief.md
- Done when: `frameworks.lock` and every framework link move to v1.13.0, v0.15.0 and v4.9.0; the site describes user stories (why each thing is built, the stories file, `Stories:` on items, drafted in design, written from the code for an existing app, validated in design, on a cadence, in the acceptance check or playtest and in align; optional in Godot-Director) and the prototype routine (`/prototype`, its own worktree and session outside the build loop, the gates that stay on, the harvest, never merged; no deploy in SaaSAllTheThings, gitleaks required in Godot-Director), and covers every new command the releases ship, each checked against the releases and without overclaiming; the brief's Planned framework changes bullets move to Framework features; the selftest passes with no WARN (check)
- Brief: Scope › Framework features

### T275 · The three frameworks record only after the director approves a summary · done 2026-11-03 · M · agent
- Depends on: -
- Touches: work/App-Director, work/SaaSAllTheThings, work/Godot-Director, read only: every procedure that writes records from a conversation with the director (design, ADRs in SaaSAllTheThings, drift reset, align, assessments and workshops, research, acceptance and playtests, /ui-design, the prototype harvest, the stories validation) and each `rules.md`; TASKS.md here
- Done when: each framework's procedures are checked against the rule (nothing is written without the director's explicit approval; a chat message or an "Other" answer during the session is a scope change or modification, so the session re-assesses the options on it and restarts or continues; once everything is chosen, a summary of what will be written is approved, then written and committed), and every difference becomes an item here for that framework's clone, naming the procedure, the step and the change it needs, reported to the director (check)
- Brief: Scope › Framework features

### T276 · App-Director: the guard and the deny rules reach the PowerShell tool, and a continuation, a tab or a PowerShell read can't hide from it · in-progress 2026-11-03 · M · agent
- PRs: App-Director #48 (open)
- Depends on: B25, B27 to B40, B42 to B52, B55, B60
- Touches: work/App-Director: framework/.claude/settings.json, framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the guard hook's matcher names PowerShell and every Bash deny and ask rule has a PowerShell twin, with no PowerShell allow rule, as B24 did here; the guard closes the gaps B25, B27 to B40, B42 to B52, B55 and B60 closed here, ported with their selftest cases, including the readings of a continued command (as written, as joined, and joined from each line after a comment: B28, B31); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: re-sized from S to M on 2026-11-03: the item now ports every guard fix from B25 to B60, not one.
- Note: found in B24: framework/.claude/settings.json has the same `Bash|Monitor` matcher and eight Bash deny rules, and its selftest pins the matcher.
- Brief: -

### T277 · SaaSAllTheThings: the guard and the deny rules reach the PowerShell tool, and a continuation, a tab or a PowerShell read can't hide from it · in-progress 2026-11-03 · M · agent
- PRs: SaaSAllTheThings #46 (open)
- Depends on: B25, B27 to B40, B42 to B52, B55, B60
- Touches: work/SaaSAllTheThings: framework/.claude/settings.json, framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the guard hook's matcher names PowerShell and every Bash deny and ask rule has a PowerShell twin, with no PowerShell allow rule, as B24 did here; the guard closes the gaps B25, B27 to B40, B42 to B52, B55 and B60 closed here, ported with their selftest cases, including the readings of a continued command (as written, as joined, and joined from each line after a comment: B28, B31); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: re-sized from S to M on 2026-11-03: the item now ports every guard fix from B25 to B60, not one.
- Note: found in B24: framework/.claude/settings.json has the same `Bash|Monitor` matcher plus Bash ask and deny rules, and its selftest pins the matcher.
- Brief: -

### T278 · Godot-Director: the guard and the deny rules reach the PowerShell tool, and a continuation, a tab or a PowerShell read can't hide from it · in-progress 2026-11-03 · L · agent
- PRs: Godot-Director #52 (open)
- Depends on: B25, B27 to B40, B42 to B52, B55, B60
- Touches: work/Godot-Director: framework/.claude/settings.json, framework/.claude/hooks/, selftest.sh
- Done when: the guard hook's matcher names PowerShell and every Bash deny and ask rule has a PowerShell twin, with no PowerShell allow rule, as B24 did here; the guard closes the gaps B25, B27 to B40, B42 to B52, B55 and B60 closed here (the read fixes where its guard checks credential reads), ported with their selftest cases, including the readings of a continued command (as written, as joined, and joined from each line after a comment: B28, B31); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: re-sized from S to L on 2026-11-03: the item now ports every guard fix from B25 to B60, not one.
- Note: found in B24: framework/.claude/settings.json wires guard-git.sh with separate `Bash` and `Monitor` matchers plus Bash ask and deny rules.
- Brief: -

### T279 · Anchor: the director approves a summary before anything is recorded · todo · M · agent
- Depends on: T275
- Touches: product/anchors/record-approval.md (new, in the format of product/anchors/align.md)
- Done when: the anchor states the rule in one wording for all three frameworks (nothing is written without the director's explicit approval; a chat message or an "Other" answer during a session is a scope change or modification that re-opens the options, so the session re-assesses and restarts or continues; once everything is chosen, a summary of every file, line, item, story and ADR status to be written is approved, then everything is written and committed in one change), with a placeholders table (the design document: brief, GDD or PRD; the decision log; the session procedures), the three texts (the rules.md paragraph, a design.md "Summary and approval" step with the reworded wait and Finish, and the one-line pointer other procedures use), SaaSAllTheThings' ADR sentence (an ADR is accepted only by approving the summary that lists it) and Godot-Director's export, release and stories-switch sentence, and a part B listing what the audit compares (check) · align's mechanical fixes are part of the summary, and in a live group workshop the room's read-back at the end is the summary the room approves (check)
- Note: from T275's check of App-Director 8f21d37, SaaSAllTheThings 7e5918f and Godot-Director bf19815: no procedure in any framework has the rule; approval gates only the commit, after the files are written, and nothing treats a chat message or an "Other" answer as a scope change.
- Brief: Scope › Framework features

### T280 · App-Director: record only after the director approves a summary · todo · M · agent
- Depends on: T279
- Touches: work/App-Director: framework/.app-director/rules.md, framework/.app-director/procedures/ (design.md, research.md, next-task.md, drift-reset.md, ui-design.md, acceptance.md), framework/ONBOARDING.md, framework/.claude/skills/design/SKILL.md, selftest.sh
- Done when: following the anchor (T279): rules.md › The human decides has the rule (A1); design.md holds answers in the conversation instead of recording each part (A2), gets a "Summary and approval" step before Record and a reworded Finish (A3), and holds the research note and its R item until the summary is approved (A4); the stories validation and the prototype harvest collect answers and summarise before writing (A5); next-task.md › Report `blocked` records only after the summary is approved (A6); drift-reset.md gives one summary with the decisions, the design diff and the rebuild plan before writing anything, TASKS items included (A7); ui-design.md process step 5 records once the director approves a summary of the spec, decisions, open questions and item (A8); acceptance.md shows a short summary of the B items, story rewrites and Processed line before writing (A9); ONBOARDING.md writes after the interview's summary is approved (A10); the design skill's description mentions the approval; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T281 · SaaSAllTheThings: record only after the director approves a summary · todo · L · agent
- Depends on: T279
- Touches: work/SaaSAllTheThings: framework/.satt/rules.md, framework/.satt/procedures/ (design.md, research.md, next-task.md, drift-reset.md, ui-design.md, acceptance.md, feedback.md, architect.md, integrate.md, assess.md), framework/.satt/workshops/README.md, framework/ONBOARDING.md, the saas-design-session skill (edit framework/.satt/ and run bundle.sh: references/ is a generated copy), selftest.sh
- Done when: following the anchor (T279), the same changes as T280's A1 to A10 in SaaSAllTheThings' files (feedback.md step 3 drops "straight away"; ONBOARDING.md's ADR-1 is accepted by the summary's approval, not "since the human just decided"), and: architect.md writes the ADR, exceptions, TASKS, AGENTS.md and compliance mapping rows only after the director approves a summary that lists them, so an ADR is accepted only by that approval, with the hook's confirmation kept (B1); integrate.md holds each round's answers and fills contract.md after the summary (B2); assess.md › Process workshop notes shows a summary of the PRD, ADR drafts, contract, stories, questions and human items before writing (B3); next-task.md › blocked: architecture points to B1's summary (B4); the design-session skill writes a one-to-one session's notes after the approved summary, and a live group workshop's read-back is the room's summary (B5); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T282 · Godot-Director: record only after the director approves a summary · todo · M · agent
- Depends on: T279
- Touches: work/Godot-Director: framework/.godot-director/rules.md, framework/.godot-director/procedures/ (design.md, research.md, next-task.md, drift-reset.md, ui-design.md, playtest.md, function-check.md, export.md, release.md), framework/ONBOARDING.md, selftest.sh
- Done when: following the anchor (T279), the same changes as T280's A1 to A10 in Godot-Director's files (the GDD in place of the brief; the "Still right?" ticks collected and summarised; playtest.md step 4 drops "straight away"), and: export.md › Set up exports and release.md › Set up release put a summary and its approval between the rounds and "Write it down" (C1); design.md › User stories puts the on and off switch in the summary (C2); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Framework features

### T283 · App-Director: the selftest runs in under five minutes · todo · S · agent
- Depends on: T276
- Touches: work/App-Director: selftest.sh
- Done when: `bash selftest.sh` in work/App-Director finishes in under five minutes on this machine, with the same checks and output, measured before and after per section (check) · following AGENTS.md › Project rules for framework work
- Note: found in T276: the selftest took about 6 min 45 s before and after the guard port, past the five-minute limit every long command keeps to, so it can only run in the background; this repo's B41 shows the pattern (parallel guard batches, one git cat-file batch, bash or awk in place of a process per line).
- Brief: -

### T284 · This repo's guard gets App-Director's own rules and bash 3.2 forms · todo · M · agent
- Depends on: T276, T285
- Touches: .claude/hooks/guard-commands.sh, selftest.sh
- Done when: this repo's guard matches App-Director's merged hook from T276 (branch `-M` and `-C` and a forced move or copy, worktree `remove --force` and `add -B` or `-f`, brace expansion and `$IFS` in a git command, a commit option's value not read as a flag, git's value-taking global options in every subcommand finder, and the bash 3.2 forms: the `lower` and `str_swap` helpers, no `${x,,}` or negative offsets) and the port fixes T285 brings from SaaSAllTheThings and Godot-Director, with their cases in the selftest, which passes (check)
- Note: found in T276. The hook is framework-owned, so the next App-Director upgrade here brings the same file; this item keeps the two equal until then, so a guard fix built here next starts from the merged hook.
- Note: T278's review showed this repo's guard has the gaps T285 closes: on 2026-11-03 a 30 KB heredoc of GDScript `$Node.method()` lines took 10.8 s here, past the hook's 10 s limit (a hook that times out doesn't block, so padding a command could let it through unguarded), `vhang=1` in the environment let `git push --force` pass, and a nested wait loop and `sleep 600.5` passed.
- Brief: -

### T285 · App-Director: the guard takes SaaSAllTheThings' and Godot-Director's port fixes · todo · M · agent
- Depends on: T276, T277, T278
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: App-Director's guard has the three fixes T277 made while porting, with their cases: a path-qualified or `.exe` git (`/usr/bin/git push --force`, `git.exe push --force`) is git; an empty-heredoc probe reads its body line by line, so a heredoc of blank lines isn't read as empty and `/usr/bin/python3` counts as `python3`; and in the PowerShell tool a backslash at a line's end is a path separator, not a continuation, so `# c\` followed by `gh auth token` is blocked; and the loop reader ends a loop at the `done` that closes a command (T278), so `until [ -f done ]; do sleep 5; done` is a wait loop; and the fixes T278's review brought to Godot-Director's guard: a wait loop with a nested loop is read to its own `done` (do and done counted), a pause with a fraction (`sleep 600.5`) is a pause, the view flags (vdep, vcov, vpx, vhang) start empty so the environment can't set them, and the per-character walk skips the bodies nothing runs, PowerShell here-strings included, so a 30 KB heredoc or here-string of `$Node.method()` lines is judged well within the hook's 10 s limit (SaaSAllTheThings' hook took 41 s on the here-string), with a timed case for each shell; and the credential-print rules read the text without message bodies, so a message may name `gh auth token`; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T277 and T278; SaaSAllTheThings' framework hook on its bundle (its T36) has the first three, and Godot-Director's (its T39) the loop reader.
- Brief: -

### T286 · SaaSAllTheThings: the Azure delete rule covers the Az PowerShell module · todo · S · agent
- Depends on: T277
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, selftest.sh
- Done when: the guard blocks the Az PowerShell module's deletes (`Remove-AzResourceGroup`, `Remove-AzResource` and the other `Remove-Az*` cmdlets) as it blocks `az ... delete`, in any case and through every reading, and the settings have the matching ask or deny rules for the PowerShell tool; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T277.
- Brief: -

### T287 · Godot-Director: its docs say the guard covers PowerShell · todo · XS · agent
- Depends on: T278
- Touches: work/Godot-Director: framework/.godot-director/rules.md, framework/.claude/agents/builder.md, README.md, selftest.sh if it pins the wording
- Done when: rules.md (about line 82), the builder agent and README.md (about line 227) say "the guard" or "the command guard" where they say "the Bash guard", since T278 wired it to PowerShell too, and name the PowerShell tool where they list the shells it reads; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T278.
- Brief: -

### T288 · SaaSAllTheThings: the guard takes Godot-Director's loop, pause, view-flag and speed fixes · todo · S · agent
- Depends on: T277, T278
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the hang check's loop reader ends a loop at the `done` that closes a command, not at any word `done`, as Godot-Director's T278 does, so `until [ -f done ]; do sleep 5; done` is still read as a wait loop, with its case, and the fixes T278's review brought to Godot-Director's guard: a wait loop with a nested loop is read to its own `done` (do and done counted), a pause with a fraction (`sleep 600.5`) is a pause, the view flags (vdep, vcov, vpx, vhang) start empty so the environment can't set them, and the per-character walk skips the bodies nothing runs, PowerShell here-strings included, so a 30 KB heredoc or here-string of `$Node.method()` lines is judged well within the hook's 10 s limit (SaaSAllTheThings' hook took 41 s on the here-string), with a timed case for each shell; and the credential-print rules read the text without message bodies, so a message may name `gh auth token`; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T278 and its review.
- Brief: -

### T289 · Godot-Director: the variable command name rule skips a global option's value · todo · XS · agent
- Depends on: T278
- Touches: work/Godot-Director: framework/.claude/hooks/guard-git.sh, selftest.sh
- Done when: `cname_judge` skips both words after `--git-dir`, `--work-tree` and `--namespace`, as `var_segment` does, so with `git` written in tools/godot_bin.local, `G=$(cat tools/godot_bin.local); "$G" --work-tree . restore .` and `... --git-dir .git branch -D x` are blocked, with their cases; the same check in App-Director's and SaaSAllTheThings' hooks, fixed there too if they have it; the selftests pass (check) · following AGENTS.md › Project rules for framework work
- Note: found in T278's review (finding 9); the Godot exception made the assignment from tools/godot_bin.local count as unset.
- Brief: -

### B53 · A script piped to a shell, a path-qualified or `.exe` git or bash, a sudo option's value, cmd's %VAR% or a folder in another case passes the guard (A01:2025 Broken Access Control) · todo · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `printf 'git push --force' | bash` or `echo 'git push --force' | sh`; `/usr/bin/git push --force` or `git.exe push --force` (so `G=/usr/bin/git; $G push --force` too); `sudo -u root "$G" push --force`; `cmd /c "%G% push --force"`; `cat > .GIT/hooks/pre-commit <<'EOF'` with `git push --force` in the body; `bash.exe tools/../x.sh`; or `bash TOOLS/../x.sh`. 2. Expected: each is blocked, as `git push --force` and a `.git/hooks` write are. Actual: exit 0: a shell reading its script from a pipe isn't read as a wrapper, the git test needs the bare name, an option's value before the command name isn't skipped, only `$` variables are read, a shell's name takes no `.exe`, and the `.git` and `tools/` folder tests are case-sensitive, while Windows folders aren't. T285 and T284 bring T277's path-qualified git to the generic and flag rules here; the `-c` key, variable and credential readings still need it, in all three frameworks.
- Found in: B45, B46, B47, T277
- Brief: -

### B54 · A message that names `--no-verify` or `gh auth token` is blocked · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `git commit -q -F - <<'EOF'` with a body line naming `--no-verify`, or `gh pr edit 5 --body-file - <<'EOF'` with a body naming `gh auth token`. 2. Expected: passes: each body is a message no shell runs (B39, B40, B48). Actual: exit 2: the no-verify check reads the raw text, and the credential-print rule reads decoded bodies, messages included.
- Found in: B48
- Brief: -

### B56 · A PowerShell `for (;;)` loop passes the hang check · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook a PowerShell payload with `for (;;) { Start-Sleep 1 }`. 2. Expected: blocked, as the Bash form is since B49. Actual: exit 0: the loop rule reads Bash's C-style loop only. (B52 made the hang rules read PowerShell subexpressions, which was this item's other half.)
- Found in: B49
- Brief: -

### B57 · A `-m` message is read as commands when the same command also runs `bash -c` · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `bash -c 'echo hi' && git commit -q -m "wait: until done; do sleep 1; done"`. 2. Expected: passes: the -m value is a message. Actual: exit 2: with an unquoted `bash -c` in the command, the raw-text scan reads the -m value too.
- Found in: B50
- Brief: -

### B58 · A PowerShell block comment, or an ANSI-C quoted escape before a `#`, hides a git flag (A01:2025 Broken Access Control) · todo · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook a PowerShell payload with `<# it's #> git push origin ':main' 'x'`, or a Bash payload with `git push $'a\'b #' "$(printf '\055\055force')"`. 2. Expected: each is blocked. Actual: exit 0: B51 reads PowerShell's line comments but not its block comments, and B43's substitution reader takes the `#` after an ANSI-C quoted escape as a comment, so the substitution after it is never read.
- Found in: B51
- Brief: -

### B59 · A quoted `;` in a reader's arguments, a substitution inside a reader's name, or git printing a file passes the credential-read check (A01:2025 Broken Access Control) · todo · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `cat 'a;b' .env.local`, `c$(echo a)t .env.local`, `git show HEAD:.env.local` or `git cat-file -p HEAD:.env.local`. 2. Expected: each is blocked, as `cat .env.local` is. Actual: exit 0: a quoted `;` ends the reader's arguments, a substitution inside a reader's name isn't read, and no rule treats git's file printers as readers.
- Found in: B52
- Brief: -

### B61 · A PowerShell pipeline from a variable, an `if` or `foreach` inside `-Command`, or a case-sensitive operator is blocked · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook a PowerShell payload with `$files = Get-ChildItem; $files | Measure-Object`, `$x = "$(git status)"; $x`, or `$x -ceq 1`; `powershell -Command 'if ($x) { Get-Date }'` or a `foreach ($f in $files)` script; or `powershell -ExecutionPolicy Bypass -File` with a path holding `$`. 2. Expected: passes: none runs a command named by a variable. Actual: exit 2: the assignment test matches any `$name =` in the command, a segment starts at `(`, B37's `-c` rule reads `-ceq` and `-cgt`, and the value of `-ExecutionPolicy` is read as the start of a `-Command` script.
- Found in: B55, B60
- Brief: -

### B62 · A PowerShell call operator on a variable, or a wrapper inside a non-git command's substitution, passes the guard (A01:2025 Broken Access Control) · todo · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook a PowerShell payload with `& ($args[0]) push --force`, `& $cmd` or `. $script` (unresolved); `echo "$(powershell -Command '& $args push --force')"`; or `$sb = [scriptblock]::Create('git push --force')` then `$sb.Invoke()`, or `$ExecutionContext.InvokeCommand.NewScriptBlock('...')`. 2. Expected: blocked, or blocked with a message that the guard can't judge what the variable runs. Actual: exit 0: a segment ends at `)`, B45 blocks a call only with a subcommand, a destructive flag, -c or an assignment, a non-git command's substitution gets only the hang and read rules, and a script block's literal isn't read as a script, since the `(` splits the words.
- Found in: B55, B60
- Brief: -

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

### T102 · The secrets scan doesn't flag drawings · done 2026-10-25 · S · agent
- Depends on: T84, T85
- PRs: App-Director #33 (merged); SaaSAllTheThings needs no change: its check has no gitleaks, and each of its built-in secret patterns needs a fixed prefix or a character base64 never contains, so an embedded screenshot can't match one
- Touches: work/App-Director and work/SaaSAllTheThings: the secrets step of framework/tools/check.sh or the gitleaks config seed (one pull request per repo; the director squash-merges)
- Done when: a committed drawing in `director/ui/*.excalidraw`, whose embedded base64 screenshot can match a key pattern, doesn't fail the check, while a real key in any other file still does, following AGENTS.md › Project rules for framework work (check)
- Note: found while building T85. Ships with /ui-design, so it waits for T84 and T85.
- Brief: Scope › Planned framework changes

## Notes
