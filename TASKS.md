# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T349 · B77 · R11

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

### R7 · How the alternatives to DDD compare on twelve dimensions, and who brings each one · done 2026-11-05 · M · agent
- Depends on: R4
- Note: product/research/2026-11-05-ddd-compared-with-other-ai-coding-workflows.md
- Question: As of 5 November 2026, what do the alternatives to Director-Driven Development ship or prescribe on twelve dimensions, and which cells of the 20 October matrix have changed?
- Informs: -
- Brief: -

### R8 · How skill and workflow packages compare with DDD's three frameworks, in packaging and guidance · done 2026-11-05 · M · agent
- Depends on: R7
- Note: product/research/2026-11-05-ddd-compared-with-skill-and-workflow-packages.md
- Question: How do published skill, agent and workflow packages for AI coding agents compare with App-Director, SaaSAllTheThings and Godot-Director in how they are packaged and how they guide a developer?
- Informs: -
- Brief: -

### R9 · Do the outside facts in the production post still hold on 5 November 2026 · done 2026-11-05 · M · agent
- Depends on: R6
- Note: product/research/2026-11-05-outside-facts-of-the-production-post.md
- Question: Do sixteen outside statements from the post of 21 October 2026, on what production means beyond the code, still hold today?
- Informs: -
- Brief: -

### R10 · Could `/ui-design` take a design kept in Penpot or Figma as its source through the tool's own MCP server · done 2026-11-12 · M · agent
- Depends on: -
- Note: product/research/2026-11-12-penpot-and-figma-mcp-as-ui-design-sources.md
- Question: What would it take for App-Director's `/ui-design` to accept a design kept in Penpot or in Figma as its source, beside the Excalidraw drawing, by using each tool's own MCP server and the existing skills instead of a reader of our own? Assume a web app on App-Director, a director who may or may not already design in one of them, and that Excalidraw stays the default.
- Informs: -
- Brief: Scope › Framework features

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
- Stories: -

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
- Stories: -

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
- Stories: -

### T226 · The director checks the Pages settings (A02:2025 Security Misconfiguration) · todo · - · human
- Depends on: -
- Touches: -
- Done when: the Pages source is GitHub Actions, "Enforce HTTPS" is on and the `github-pages` environment deploys only from `main`, checked in this repository's settings (demo)
- Brief: -
- Stories: -

### T227 · The director turns on dependency alerts and pip updates (A03:2025 Software Supply Chain Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: Dependabot alerts are on in all four repositories and Dependabot proposes `pip` updates where a repository has Python packages, beside the action updates, and the director has said who may add a dependency (demo)
- Brief: -
- Stories: -

### T228 · The director rotates the GitHub and WordPress credentials (A04:2025 Cryptographic Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: the gh token, the git credential entry and the SSH keys on this machine and the WordPress application password are rotated, unused application passwords are revoked, the WordPress password lives only in the local MCP configuration, and the director has set when to rotate them again (demo)
- Brief: -
- Stories: -

### T229 · The director reviews misuse before changing the agent's permissions or the publish scripts (A06:2025 Insecure Design) · todo · - · human
- Depends on: -
- Touches: -
- Done when: the director has thought through how a change to `.claude/settings.json`, `tools/work-publish.sh` or `tools/work-release.sh` could be misused, starting with B17 and B19, and keeps doing so before each such change (demo)
- Brief: -
- Stories: -

### T230 · The director turns on two-factor authentication on every account (A07:2025 Authentication Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: two-factor authentication is on for GitHub, WordPress and its hosting, itch.io and the Anthropic account (demo)
- Brief: -
- Stories: -

### T231 · The director sets the GitHub rulesets and Actions settings (A08:2025 Software or Data Integrity Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: a branch ruleset on `main` in all four repositories requires a pull request and blocks force-push and deletion, a tag ruleset protects `v*` in the three framework repositories, the default `GITHUB_TOKEN` is read-only, only GitHub-owned or verified Actions may run, and secret scanning push protection is on (demo)
- Brief: -
- Stories: -

### T232 · The director routes the alerts and writes an incident note (A09:2025 Security Logging and Alerting Failures) · todo · - · human
- Depends on: -
- Touches: -
- Done when: failed workflow runs and Dependabot and secret scanning alerts reach the director's email, and a short note says what to do if the site is defaced or a token leaks (demo)
- Brief: -
- Stories: -

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

### T276 · App-Director: the guard and the deny rules reach the PowerShell tool, and a continuation, a tab or a PowerShell read can't hide from it · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged)
- Depends on: B25, B27 to B40, B42 to B52, B55, B60
- Touches: work/App-Director: framework/.claude/settings.json, framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the guard hook's matcher names PowerShell and every Bash deny and ask rule has a PowerShell twin, with no PowerShell allow rule, as B24 did here; the guard closes the gaps B25, B27 to B40, B42 to B52, B55 and B60 closed here, ported with their selftest cases, including the readings of a continued command (as written, as joined, and joined from each line after a comment: B28, B31); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: re-sized from S to M on 2026-11-03: the item now ports every guard fix from B25 to B60, not one.
- Note: found in B24: framework/.claude/settings.json has the same `Bash|Monitor` matcher and eight Bash deny rules, and its selftest pins the matcher.
- Brief: -

### T277 · SaaSAllTheThings: the guard and the deny rules reach the PowerShell tool, and a continuation, a tab or a PowerShell read can't hide from it · done 2026-11-04 · M · agent
- PRs: SaaSAllTheThings #46 (merged)
- Depends on: B25, B27 to B40, B42 to B52, B55, B60
- Touches: work/SaaSAllTheThings: framework/.claude/settings.json, framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the guard hook's matcher names PowerShell and every Bash deny and ask rule has a PowerShell twin, with no PowerShell allow rule, as B24 did here; the guard closes the gaps B25, B27 to B40, B42 to B52, B55 and B60 closed here, ported with their selftest cases, including the readings of a continued command (as written, as joined, and joined from each line after a comment: B28, B31); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: re-sized from S to M on 2026-11-03: the item now ports every guard fix from B25 to B60, not one.
- Note: found in B24: framework/.claude/settings.json has the same `Bash|Monitor` matcher plus Bash ask and deny rules, and its selftest pins the matcher.
- Brief: -

### T278 · Godot-Director: the guard and the deny rules reach the PowerShell tool, and a continuation, a tab or a PowerShell read can't hide from it · done 2026-11-04 · L · agent
- PRs: Godot-Director #52 (merged)
- Depends on: B25, B27 to B40, B42 to B52, B55, B60
- Touches: work/Godot-Director: framework/.claude/settings.json, framework/.claude/hooks/, selftest.sh
- Done when: the guard hook's matcher names PowerShell and every Bash deny and ask rule has a PowerShell twin, with no PowerShell allow rule, as B24 did here; the guard closes the gaps B25, B27 to B40, B42 to B52, B55 and B60 closed here (the read fixes where its guard checks credential reads), ported with their selftest cases, including the readings of a continued command (as written, as joined, and joined from each line after a comment: B28, B31); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: re-sized from S to L on 2026-11-03: the item now ports every guard fix from B25 to B60, not one.
- Note: found in B24: framework/.claude/settings.json wires guard-git.sh with separate `Bash` and `Monitor` matchers plus Bash ask and deny rules.
- Brief: -

### T279 · Anchor: the director approves a summary before anything is recorded · done 2026-11-03 · M · agent
- Depends on: T275
- Touches: product/anchors/record-approval.md (new, in the format of product/anchors/align.md)
- Done when: the anchor states the rule in one wording for all three frameworks (nothing is written without the director's explicit approval; a chat message or an "Other" answer during a session is a scope change or modification that re-opens the options, so the session re-assesses and restarts or continues; once everything is chosen, a summary of every file, line, item, story and ADR status to be written is approved, then everything is written and committed in one change), with a placeholders table (the design document: brief, GDD or PRD; the decision log; the session procedures), the three texts (the rules.md paragraph, a design.md "Summary and approval" step with the reworded wait and Finish, and the one-line pointer other procedures use), SaaSAllTheThings' ADR sentence (an ADR is accepted only by approving the summary that lists it) and Godot-Director's export, release and stories-switch sentence, and a part B listing what the audit compares (check) · align's mechanical fixes are part of the summary, and in a live group workshop the room's read-back at the end is the summary the room approves (check)
- Note: from T275's check of App-Director 8f21d37, SaaSAllTheThings 7e5918f and Godot-Director bf19815: no procedure in any framework has the rule; approval gates only the commit, after the files are written, and nothing treats a chat message or an "Other" answer as a scope change.
- Note: built 2026-11-03. Two calls taken by default, for the director to change: a standalone `/research` holds its note and R item until the summary is approved, as inside a design session; and a drift reset's analysis files (as-built, interpretations) are written without a summary, since starting the reset asks for them.
- Brief: Scope › Framework features

### T280 · App-Director: record only after the director approves a summary · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged)
- Depends on: T279
- Touches: work/App-Director: framework/.app-director/rules.md, framework/.app-director/procedures/ (design.md, research.md, next-task.md, drift-reset.md, ui-design.md, acceptance.md, align.md), ONBOARDING.md, framework/.claude/skills/design/SKILL.md, selftest.sh
- Done when: following the anchor (T279): rules.md › The human decides has the rule (A1); design.md holds answers in the conversation instead of recording each part (A2), gets a "Summary and approval" step before Record and a reworded Finish (A3), and holds the research note and its R item until the summary is approved (A4); the stories validation and the prototype harvest collect answers and summarise before writing (A5); next-task.md › Report `blocked` records only after the summary is approved (A6); drift-reset.md gives one summary with the decisions, the design diff and the rebuild plan before writing anything, TASKS items included (A7); ui-design.md process step 5 records once the director approves a summary of the spec, decisions, open questions and item (A8); acceptance.md shows a short summary of the B items, story rewrites and Processed line before writing (A9); ONBOARDING.md writes after the interview's summary is approved (A10); the design skill's description mentions the approval; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: T279's anchor (`product/anchors/record-approval.md`) is the wording: its section 2 table names the step in each procedure, align.md included, and `ONBOARDING.md` is at the repository root.
- Note: built 2026-11-03 as App-Director's T40. The drift reset's design and plan commits are now one, after one approval (the postmortem keeps its own); its analysis files are written when the analysis runs, as T279's note says; and onboarding's summary covers section 5's records in both modes, while the stack, AGENTS.md facts and ownership settings keep the install commit's approval as their gate.
- Brief: Scope › Framework features

### T281 · SaaSAllTheThings: record only after the director approves a summary · done 2026-11-04 · L · agent
- PRs: SaaSAllTheThings #46 (merged)
- Depends on: T279
- Touches: work/SaaSAllTheThings: framework/.satt/rules.md, framework/.satt/procedures/ (design.md, research.md, next-task.md, drift-reset.md, ui-design.md, acceptance.md, feedback.md, architect.md, integrate.md, assess.md, roadmap.md, align.md), framework/.satt/workshops/README.md, ONBOARDING.md, framework/.claude/skills/design/SKILL.md, the saas-design-session skill (edit framework/.satt/ and run bundle.sh: references/ is a generated copy), selftest.sh
- Done when: following the anchor (T279), the same changes as T280's A1 to A10 in SaaSAllTheThings' files (feedback.md step 3 drops "straight away"; ONBOARDING.md's ADR-1 is accepted by the summary's approval, not "since the human just decided"), and: architect.md writes the ADR, exceptions, TASKS, AGENTS.md and compliance mapping rows only after the director approves a summary that lists them, so an ADR is accepted only by that approval, with the hook's confirmation kept (B1); integrate.md holds each round's answers and fills contract.md after the summary (B2); assess.md › Process workshop notes shows a summary of the PRD, ADR drafts, contract, stories, questions and human items before writing (B3); next-task.md › blocked: architecture points to B1's summary (B4); the design-session skill writes a one-to-one session's notes after the approved summary, and a live group workshop's read-back is the room's summary (B5); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: T279's anchor (`product/anchors/record-approval.md`) is the wording: its section 2 table names the step in each procedure, align.md included, and `ONBOARDING.md` is at the repository root.
- Note: built 2026-11-03 as SaaSAllTheThings' T37, reviewed, and the review's fixes built. roadmap.md also records from a conversation, so it got the pointer and the anchor names it; onboarding's Both step (the roadmap) now comes before its summary. The builder also updated framework/validation/README.md, README.md and examples/scenarios.md, which described the old behaviour.
- Brief: Scope › Framework features

### T282 · Godot-Director: record only after the director approves a summary · done 2026-11-04 · M · agent
- PRs: Godot-Director #52 (merged)
- Depends on: T279
- Touches: work/Godot-Director: framework/.godot-director/rules.md, framework/.godot-director/procedures/ (design.md, research.md, next-task.md, drift-reset.md, ui-design.md, playtest.md, function-check.md, export.md, release.md, align.md), ONBOARDING.md, framework/.claude/skills/design/SKILL.md, selftest.sh
- Done when: following the anchor (T279), the same changes as T280's A1 to A10 in Godot-Director's files (the GDD in place of the brief; the "Still right?" ticks collected and summarised; playtest.md step 4 drops "straight away"), and: export.md › Set up exports and release.md › Set up release put a summary and its approval between the rounds and "Write it down" (C1); design.md › User stories puts the on and off switch in the summary (C2); the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: T279's anchor (`product/anchors/record-approval.md`) is the wording: its section 2 table names the step in each procedure, align.md included, and `ONBOARDING.md` is at the repository root.
- Note: built 2026-11-03 as Godot-Director's T40. export.md and release.md got a Summary and approval step 3 (Write it down and Try it are 4 and 5), the playtest's machine review joins its summary, and onboarding's settings sections (facts, ownership, dev menu, model sizing) keep the install commit's approval as their gate, as in App-Director's T40. The builder also updated README.md, framework/playtesting/README.md and examples/scenarios.md.
- Brief: Scope › Framework features

### T283 · App-Director: the selftest runs in under five minutes · done 2026-11-05 · L (escalated from M) · agent
- PRs: App-Director #48 (merged), App-Director #50 (merged)
- Depends on: T276
- Touches: work/App-Director: selftest.sh
- Done when: `bash selftest.sh` in work/App-Director finishes in under five minutes on this machine, with the same checks and output, measured before and after per section (check) · following AGENTS.md › Project rules for framework work
- Note: found in T276: the selftest took about 6 min 45 s before and after the guard port, past the five-minute limit every long command keeps to, so it can only run in the background; this repo's B41 shows the pattern (parallel guard batches, one git cat-file batch, bash or awk in place of a process per line).
- Note: built 2026-11-04 as App-Director's T42: the independent parts run side by side and the guard batches run in lanes, with the same 492 ok lines. Under five minutes isn't shown yet: every run so far shared the machine with two or three other selftests (1627 s for the gate, 2231 s before), so one run on a quiet machine decides it before the release; the serial chain (installer, check, Stop hook, pre-commit, ui-design) is what's left to speed up.
- Note: measured 2026-11-04 with no other selftest running (four stuck processes from other projects still held four of the twelve cores): 871 s and 816 s, so under five minutes isn't met. Both runs failed in the UI capture section, which T304 fixes; what's left for this item is the serial chain (installer, check, Stop hook, pre-commit, ui-design), with fixtures built once and copied (setup-clone runs 24 times in the pre-commit block).
- Note: T42's lanes shipped in 1.14.0, and the five-minute target isn't met: T304's runs took 524 to 995 s. This item stays open for the serial chain, in a new bundle.
- Note: built 2026-11-04 and 2026-11-05 as App-Director's T53, two attempts, the second escalated to L after the first reached only 464 to 691 s with twelve lanes. The run is limited by process starts: about 35 a second from six lanes up, whatever the lanes, so a run's length is its starts divided by 35. Starts fell from 20,190 to about 10,000 by making the selftest eighteen parts, sourcing the guard hook in one bash per lane and reading `tools/check.cfg` without a pipeline per line, which took `tools/check.sh` from about 330 starts to about 40. Final files: 283 s with the machine quiet (CPU 5 to 31 percent, no Godot), 292 s on the release bump, 629 passed and the output the same line for line. The original took 962 to 1351 s. The target holds only when the machine is quiet: 491 s in a run that shared it with another project for part of its length. Git Bash on Windows only: macOS and Linux weren't run, and App-Director has no CI that would. Before and after by section, in seconds, with spans overlapping: check 326 to 71, 80 and 80 in three parts; guard-commands 212 to 192; guard-protected and stop-check 192 to 111; security 169 to 138; pre-commit and staged secret 264 to 159; prototypes 363 to 293 and 66; /ui-design 363 to 185; installer 168 to 96, 133 and 96. The review caught that a fast `cd` in `check.sh` ran the check in the wrong folder for a `$0` with a backslash, and a here-string that added a way for the fingerprint to skip contents; both went back to the old lines. Left as they are: `security.sh`, `stories.sh` and `setup-clone.sh` keep the slow per-line `cfg_get`, `install.sh` starts about 33 programs a run, and `prototype.sh` runs about 360 git commands per selftest.
- Brief: -

### T284 · This repo's guard gets App-Director's own rules and bash 3.2 forms · done 2026-11-04 · M · agent
- Depends on: T276, T285
- Touches: .claude/hooks/guard-commands.sh, selftest.sh
- Done when: this repo's guard matches App-Director's merged hook from T276 (branch `-M` and `-C` and a forced move or copy, worktree `remove --force` and `add -B` or `-f`, brace expansion and `$IFS` in a git command, a commit option's value not read as a flag, git's value-taking global options in every subcommand finder, and the bash 3.2 forms: the `lower` and `str_swap` helpers, no `${x,,}` or negative offsets) and the port fixes T285 brings from SaaSAllTheThings and Godot-Director, with their cases in the selftest, which passes (check)
- Note: found in T276. The hook is framework-owned, so the next App-Director upgrade here brings the same file; this item keeps the two equal until then, so a guard fix built here next starts from the merged hook.
- Note: T278's review showed this repo's guard has the gaps T285 closes: on 2026-11-03 a 30 KB heredoc of GDScript `$Node.method()` lines took 10.8 s here, past the hook's 10 s limit (a hook that times out doesn't block, so padding a command could let it through unguarded), `vhang=1` in the environment let `git push --force` pass, and a nested wait loop and `sleep 600.5` passed.
- Note: built 2026-11-04: `.claude/hooks/guard-commands.sh` is byte-identical to App-Director v1.14.0, with the new cases in this repo's selftest, including B64's form. This repo's hook had been its own larger copy, ahead of the 229-line hook of the release it installed, so it was compared on 40 forms fed as hook input: nothing it blocked now passes, and its selftest cases hold but one flipped on purpose (a Python heredoc with a body now blocks). App-Director's T292 cases and timing check weren't copied, since that release's selftest covers this same file.
- Brief: -

### T285 · App-Director: the guard takes SaaSAllTheThings' and Godot-Director's port fixes · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged)
- Depends on: T276, T277, T278
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: App-Director's guard has the three fixes T277 made while porting, with their cases: a path-qualified or `.exe` git (`/usr/bin/git push --force`, `git.exe push --force`) is git; an empty-heredoc probe reads its body line by line, so a heredoc of blank lines isn't read as empty and `/usr/bin/python3` counts as `python3`; and in the PowerShell tool a backslash at a line's end is a path separator, not a continuation, so `# c\` followed by `gh auth token` is blocked; and the loop reader ends a loop at the `done` that closes a command (T278), so `until [ -f done ]; do sleep 5; done` is a wait loop; and the fixes T278's review brought to Godot-Director's guard: a wait loop with a nested loop is read to its own `done` (do and done counted), a pause with a fraction (`sleep 600.5`) is a pause, the view flags (vdep, vcov, vpx, vhang) start empty so the environment can't set them, and the per-character walk skips the bodies nothing runs, PowerShell here-strings included, so a 30 KB heredoc or here-string of `$Node.method()` lines is judged well within the hook's 10 s limit (SaaSAllTheThings' hook took 41 s on the here-string), with a timed case for each shell; and the credential-print rules read the text without message bodies, so a message may name `gh auth token`; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T277 and T278; SaaSAllTheThings' framework hook on its bundle (its T36) has the first three, and Godot-Director's (its T39) the loop reader.
- Note: built 2026-11-03 as App-Director's T41: the 30 KB heredoc and here-string went from about 27 s to about 2 s, and a path-qualified git is read in the substitution, variable and `-c` readings too. Left open: a backslash-path git (`C:\Git\bin\git.exe push --force`, T290's class) and `sleep 1e3`, which GNU sleep reads as 1000 seconds.
- Brief: -

### T286 · SaaSAllTheThings: the Azure delete rule covers the Az PowerShell module · done 2026-11-04 · S · agent
- PRs: SaaSAllTheThings #46 (merged)
- Depends on: T277
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, selftest.sh
- Done when: the guard blocks the Az PowerShell module's deletes (`Remove-AzResourceGroup`, `Remove-AzResource` and the other `Remove-Az*` cmdlets) as it blocks `az ... delete`, in any case and through every reading, and the settings have the matching ask or deny rules for the PowerShell tool; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T277.
- Brief: -

### T287 · Godot-Director: its docs say the guard covers PowerShell · done 2026-11-04 · XS · agent
- PRs: Godot-Director #52 (merged)
- Depends on: T278
- Touches: work/Godot-Director: framework/.godot-director/rules.md, framework/.claude/agents/builder.md, README.md, selftest.sh if it pins the wording
- Done when: rules.md (about line 82), the builder agent and README.md (about line 227) say "the guard" or "the command guard" where they say "the Bash guard", since T278 wired it to PowerShell too, and name the PowerShell tool where they list the shells it reads; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T278.
- Brief: -

### T288 · SaaSAllTheThings: the guard takes Godot-Director's loop, pause, view-flag and speed fixes · done 2026-11-04 · S · agent
- PRs: SaaSAllTheThings #46 (merged)
- Depends on: T277, T278
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the hang check's loop reader ends a loop at the `done` that closes a command, not at any word `done`, as Godot-Director's T278 does, so `until [ -f done ]; do sleep 5; done` is still read as a wait loop, with its case, and the fixes T278's review brought to Godot-Director's guard: a wait loop with a nested loop is read to its own `done` (do and done counted), a pause with a fraction (`sleep 600.5`) is a pause, the view flags (vdep, vcov, vpx, vhang) start empty so the environment can't set them, and the per-character walk skips the bodies nothing runs, PowerShell here-strings included, so a 30 KB heredoc or here-string of `$Node.method()` lines is judged well within the hook's 10 s limit (SaaSAllTheThings' hook took 41 s on the here-string), with a timed case for each shell; and the credential-print rules read the text without message bodies, so a message may name `gh auth token`; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T278 and its review.
- Note: built 2026-11-03 as SaaSAllTheThings' T39: the 30 KB heredoc and here-string went from 37.5 s and 35.1 s to about 1 s and 2 s. The loop reader reads a `bash -c` script's raw text without quote awareness, so a quoted `done` in one can end a loop early.
- Brief: -

### T289 · Godot-Director: the variable command name rule skips a global option's value · done 2026-11-04 · XS · agent
- PRs: Godot-Director #52 (merged)
- Depends on: T278
- Touches: work/Godot-Director: framework/.claude/hooks/guard-git.sh, selftest.sh
- Done when: `cname_judge` skips both words after `--git-dir`, `--work-tree` and `--namespace`, as `var_segment` does, so with `git` written in tools/godot_bin.local, `G=$(cat tools/godot_bin.local); "$G" --work-tree . restore .` and `... --git-dir .git branch -D x` are blocked, with their cases; the same check, read-only, in App-Director's and SaaSAllTheThings' hooks, with an item here if they have it; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T278's review (finding 9); the Godot exception made the assignment from tools/godot_bin.local count as unset.
- Note: built 2026-11-04 as Godot-Director's T43; it skips every global option `var_segment` skips (`-C`, `-c`, `--git-dir`, `--work-tree`, `--namespace`, `--config-env`, `--attr-source`, `--super-prefix`). App-Director's and SaaSAllTheThings' hooks block the item's payloads by their assignment rule, but pass the same commands with the variable from the environment (T301).
- Brief: -

### T290 · SaaSAllTheThings: a quoted path with a space, or a backslash path, can't hide az, git or a Remove-Az cmdlet from the guard · done 2026-11-04 · S · agent
- PRs: SaaSAllTheThings #46 (merged)
- Depends on: T286
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the guard blocks `& 'C:\Program Files\Az\Remove-AzResourceGroup' -Name rg`, `"C:\Program Files\Git\bin\git.exe" push --force`, `"C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd" group delete -n rg` and `C:\bin\az.cmd group delete -n rg`, in the Bash and PowerShell tools, as it blocks the bare names, with their cases: a quoted command name with a space is read as a name, not blanked as text, and a backslash path keeps its last part for the az rule; the same check, read-only, in App-Director's and Godot-Director's hooks for the git form, with an item here for each that has the gap; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T286; all four pass on the hook before T286 too.
- Note: built 2026-11-03 as SaaSAllTheThings' T40. App-Director's and Godot-Director's hooks pass both git payloads (T292, T293).
- Brief: -

### T291 · Godot-Director: the selftest runs in under fifteen minutes · done 2026-11-04 · M · agent
- PRs: Godot-Director #52 (merged)
- Depends on: T278
- Touches: work/Godot-Director: selftest.sh
- Done when: `bash selftest.sh <path to Godot>` in work/Godot-Director finishes in under fifteen minutes on this machine with nothing else running, with the same checks and output, measured before and after per section; the sections that take longest are named in the item's note (check) · following AGENTS.md › Project rules for framework work
- Note: found in T282: the full run took 6006 s after T278 and 6324 s for T282 on 2026-11-03 (1041 and 1042 cases), with other builders and two stuck processes from other projects sharing the machine, so each Godot-Director item takes close to two hours to gate. T283 is App-Director's counterpart.
- Note: built 2026-11-04 as Godot-Director's T42: 6719 s before, then 749 s for the gate and 741 to 916 s in four more runs, all on the shared machine. The time went to about 190 check and Godot runs one after another, not the guard cases; the sections now run as 39 lanes with their own game copies. The 25 KB guard-speed case flakes under load (3.7 s quiet, 7.0 s busy), so it runs before the lanes.
- Brief: -

### T292 · App-Director: a quoted path with a space, or a backslash path, can't hide git from the guard · done 2026-11-04 · S · agent
- PRs: App-Director #48 (merged)
- Depends on: T285
- Touches: work/App-Director: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: the guard blocks `"C:\Program Files\Git\bin\git.exe" push --force`, `& 'C:\Program Files\Git\bin\git.exe' push --force` and `C:\Git\bin\git.exe push --force` in the Bash and PowerShell tools, as it blocks the bare name, with their cases, as SaaSAllTheThings' T290 does (a command name quoted with a space or a path, or an unquoted backslash path that starts with a drive, `.`, `..`, `~` or two backslashes, is read as its last part without `.exe`, `.cmd` or `.bat`); `& 'C:\Program Files\Git\bin\git.exe' status`, a commit message naming the path, and `c\at README.md` still pass; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T290; both payloads exit 0 on the hook at its bundle's head.
- Note: built 2026-11-04 as App-Director's T43. An unquoted backslash path to git in an argument (`echo C:\Git\bin\git.exe push --force`) is blocked, as `echo git push --force` already is.
- Brief: -

### T293 · Godot-Director: a quoted path with a space, or a backslash path, can't hide git from the guard · done 2026-11-04 · S · agent
- PRs: Godot-Director #52 (merged)
- Depends on: T278
- Touches: work/Godot-Director: framework/.claude/hooks/guard-git.sh, selftest.sh
- Done when: the guard blocks `"C:\Program Files\Git\bin\git.exe" push --force`, `& 'C:\Program Files\Git\bin\git.exe' push --force` and `C:\Git\bin\git.exe push --force` in the Bash and PowerShell tools, as it blocks the bare name, with their cases, as SaaSAllTheThings' T290 does (a command name quoted with a space or a path, or an unquoted backslash path that starts with a drive, `.`, `..`, `~` or two backslashes, is read as its last part without `.exe`, `.cmd` or `.bat`); `& 'C:\Program Files\Git\bin\git.exe' status`, a commit message naming the path, and `c\at README.md` still pass; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T290; both payloads exit 0 on the hook at its bundle's head.
- Brief: -

### T295 · Godot-Director: the Stop hook runs the check only for the session that changed the code · done 2026-11-04 · M · agent
- PRs: Godot-Director #52 (merged)
- Depends on: T278
- Touches: work/Godot-Director: framework/.claude/hooks/stop-check.sh, a new framework-owned PostToolUse hook in framework/.claude/hooks/, framework/.claude/settings.json, selftest.sh, the docs that describe the Stop hook, CHANGELOG.md
- Done when: the Stop hook runs the project check only when this session itself wrote or edited a code, scene or data file (`.gd`, `.tscn`, `.scn`, `.tres`, `.res`, `.gdshader`, `.gdshaderinc`, `project.godot`) since its last passing check: a PostToolUse hook on Edit, Write, MultiEdit and NotebookEdit records the paths it touched in `.godot/godot-director/sessions/<session_id>.touched` (the hook input's `session_id`), and for Bash it compares the dirty files before and after the command (a PreToolUse snapshot, or a file list with modification times) and records the ones that changed; a session that touched only docs (design/, TASKS.md, `*.md`, assets) never triggers the check; the builder marker, the fingerprint (the same failure isn't reported twice), `GODOT_DIRECTOR_STOP_CHECK=0` and the exit 0 when tools/check.sh is missing keep working; the session's record is removed when the check passes, and records older than a day are ignored (check) · in a design session that edits only Markdown while another session has uncommitted a code, scene or data file (`.gd`, `.tscn`, `.scn`, `.tres`, `.res`, `.gdshader`, `.gdshaderinc`, `project.godot`) in the same folder, the Stop hook exits at once without running the check, tested with a scripted hook input; a session that edits a code, scene or data file (`.gd`, `.tscn`, `.scn`, `.tres`, `.res`, `.gdshader`, `.gdshaderinc`, `project.godot`) still gets the check and is blocked once on failure, tested; the release notes' upgrade section says what changed (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-03: when two sessions share one working folder (a design session and a build session on the same checkout, no worktree), the build session's uncommitted code makes the hook run the check at the end of every turn of the design session too, which edited no code, waits minutes, and is sometimes blocked by failures it can't fix.
- Note: built 2026-11-04 as Godot-Director's T45, ported from SaaSAllTheThings' T41 and App-Director's T44 with Godot's source list (`project.godot` only at the root, `.godot/` and `.gd.uid` never source); its selftest lane needs no Godot and adds 39 assertions, which fail against the old hook.
- Brief: -

### T302 · Release Godot-Director 4.10.0 · done 2026-11-04 · S · agent
- PRs: Godot-Director #52 (merged)
- Depends on: T278, T282, T287, T289, T291, T293, T295
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/godot-director/SKILL.md, the design document template links its CLAUDE.md lists, CHANGELOG.md
- Done when: the bundle ends with the release commit: the version files bumped to 4.10.0 as its CLAUDE.md lists them, `## Unreleased` in CHANGELOG.md is `## 4.10.0 (<date>)`, the selftest passes without the Godot path (check), and the commit's body is the release notes (How to install with How to upgrade, then What's changed with this release's upgrade steps, in the previous release's layout), which are also the pull request's description · following AGENTS.md › Project rules for framework work › Releases ride in the bundle
- Note: 4.10.0 is the agent's proposal: the bundle adds features (recording after an approved summary, the per-session Stop hook) next to the guard's fixes. The director can change it in review.
- Note: the release commit is on the bundle (selftest without the Godot path: 237 passed; it also adds the CHANGELOG entry T291's selftest change had left out), and the release notes are #52's description. Once the director merges #52, `bash tools/work-release.sh work/Godot-Director 52` tags and publishes v4.10.0.
- Brief: -

### T303 · Docs follow App-Director 1.14.0, SaaSAllTheThings 0.16.0 and Godot-Director 4.10.0: recording after an approved summary, the guard in PowerShell, the per-session Stop hook, no shell heredocs, the two session-start hooks · done 2026-11-04 · M · agent
- Depends on: T298, T300, T302, T305, T306, T307, T308, T309, T310, T311
- Touches: frameworks.lock, docs/**/*.md (the framework links), docs/skills/ (design, research, acceptance, align, ui-design and the other pages whose procedure now records after an approved summary), docs/concept/ (the loop, reviews, the guard and the hooks), docs/how-to/, docs/frameworks/, product/brief.md
- Done when: once the three bundles are merged and tagged (`tools/work-release.sh`), `frameworks.lock` and every framework link move to v1.14.0, v0.16.0 and v4.10.0; the site describes what the releases ship, each checked against the releases and without overclaiming: a session writes nothing until the director approves one summary of everything it will write, and a chat message or an "Other" answer re-opens the options (in SaaSAllTheThings an ADR is accepted only by that approval, and a live workshop's read-back is the room's summary); the guard and the deny rules reach the PowerShell tool; the Stop hook runs the check only for the session that changed the code; SaaSAllTheThings' guard blocks the Az PowerShell module's deletes; App-Director's hook timeouts are in seconds; files are written with the file tools, never a shell heredoc, every shell call is one short command, and a command moved to the background is stopped before a report, by the subagent and by the session after it (the how-to's troubleshooting table gains the heredoc row); the guard blocks any Python reading its script from a heredoc; a session says when the project is behind the latest release, with what the lookup reads, and lists processes whose parent shell is gone; Godot-Director's autoplay and layout lint reach controls drawn in a SubViewport through a provider; the brief's Planned framework changes bullets move to Framework features; the selftest passes with no WARN (check)
- Note: built 2026-11-04: `frameworks.lock` and the links move to the three new tags, and the skill, concept, how-to and framework pages and the brief describe what shipped. The brief's Planned framework changes held only the SaaSAllTheThings Azure pilot, which no release ships, so it stays. `tools/audit.sh` at the new pins lists 43 lines of procedure detail that the pages summarise and link to; none is a release's behaviour the pages get wrong. The Stop hook's changed-source test differs by framework (Godot-Director counts `.gd`, `.tscn`, `.tres` and the like, the other two any file but `*.md`), and the pages say only that it runs for a session that changed code itself.
- Brief: Scope › Framework features

### T296 · App-Director: the Stop hook runs the check only for the session that changed the code · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged)
- Depends on: T276
- Touches: work/App-Director: framework/.claude/hooks/stop-check.sh, a new framework-owned PostToolUse hook in framework/.claude/hooks/, framework/.claude/settings.json, selftest.sh, the docs that describe the Stop hook, CHANGELOG.md
- Done when: the Stop hook runs the project check only when this session itself wrote or edited a source file (any file but `*.md` and `.app-director/state/`, the hook's present rule) since its last passing check: a PostToolUse hook on Edit, Write, MultiEdit and NotebookEdit records the paths it touched in `.app-director/state/sessions/<session_id>.touched` (the hook input's `session_id`), and for Bash it compares the dirty files before and after the command (a PreToolUse snapshot, or a file list with modification times) and records the ones that changed; a session that touched only docs (`*.md`, product/, TASKS.md) never triggers the check; the builder marker, the fingerprint (the same failure isn't reported twice), `APP_DIRECTOR_STOP_CHECK=0` and the exit 0 when tools/check.sh is missing keep working; the session's record is removed when the check passes, and records older than a day are ignored (check) · in a design session that edits only Markdown while another session has uncommitted a source file (any file but `*.md` and `.app-director/state/`, the hook's present rule) in the same folder, the Stop hook exits at once without running the check, tested with a scripted hook input; a session that edits a source file (any file but `*.md` and `.app-director/state/`, the hook's present rule) still gets the check and is blocked once on failure, tested; the release notes' upgrade section says what changed (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-03: when two sessions share one working folder (a design session and a build session on the same checkout, no worktree), the build session's uncommitted code makes the hook run the check at the end of every turn of the design session too, which edited no code, waits minutes, and is sometimes blocked by failures it can't fix.
- Note: built 2026-11-04 as App-Director's T44, ported from SaaSAllTheThings' T41 with App-Director's source rule (no adr/ exception), plus a Windows-path test where cygpath exists. This repo runs App-Director's hooks, so the fix reaches it with the next App-Director upgrade.
- Brief: -

### T299 · App-Director: the hook timeouts are in seconds · done 2026-11-04 · XS · agent
- PRs: App-Director #48 (merged)
- Depends on: T296
- Touches: work/App-Director: framework/.claude/settings.json, selftest.sh, CHANGELOG.md
- Done when: framework/.claude/settings.json gives guard-commands.sh a timeout of 10, guard-protected.sh 5 and stop-check.sh 3600, since Claude Code reads a hook's `timeout` in seconds (10000, 5000 and 660000 now), and drops the top-level `"bash": {"timeout": 600000}`, which isn't a Claude Code setting (the Bash tool's limits are `BASH_DEFAULT_TIMEOUT_MS` and `BASH_MAX_TIMEOUT_MS` in `env`, and 600000 ms is already the default maximum); the selftest checks every hook timeout is at most 3600 and the guard's at most 10; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T296; Claude Code's hooks reference says a hook's timeout is "Seconds before canceling" (default 600). Godot-Director and SaaSAllTheThings use seconds already. This repo's .claude/settings.json is App-Director's and gets the fix with the next upgrade.
- Note: built 2026-11-04 as App-Director's T45. The Stop hook got 3600, as in the other two frameworks, not 660: the stack check and tools/check.local.sh may each take up to 600 s, and a Stop hook that times out ends the turn without the check's result.
- Brief: -

### T300 · Release App-Director 1.14.0 · done 2026-11-04 · S · agent
- PRs: App-Director #48 (merged)
- Depends on: T276, T280, T283, T285, T292, T296, T299
- Touches: work/App-Director: VERSION, .claude-plugin/plugin.json, package.json, .claude-plugin/marketplace.json, SKILL.md, skills/app-director/SKILL.md, scripts/fetch-app-director.sh, README.md, project/product/director-brief.md, the example's copy of the brief, CHANGELOG.md
- Done when: the bundle ends with the release commit: the version files bumped to 1.14.0 as its CLAUDE.md lists them, `## Unreleased` in CHANGELOG.md is `## 1.14.0 (<date>)`, the selftest passes (check), and the commit's body is the release notes (How to install first, then What's new and How to upgrade with this release's upgrade steps, in the previous release's layout), which are also the pull request's description · following AGENTS.md › Project rules for framework work › Releases ride in the bundle
- Note: 1.14.0 is the agent's proposal: the bundle adds features (recording after an approved summary, the per-session Stop hook) next to the guard's fixes. The director can change it in review.
- Note: the release commit is on the bundle (selftest 533 passed), and the release notes are #48's description. Once the director merges #48, `bash tools/work-release.sh work/App-Director 48` tags and publishes v1.14.0.
- Brief: -

### T304 · App-Director: the selftest's UI capture section passes on every run · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged)
- Depends on: T283, T300
- Touches: work/App-Director: selftest.sh, framework/tools/ui/ if the cause is there, CHANGELOG.md (under the 1.14.0 heading, since the release isn't published)
- Done when: the cause of the two failing runs on 2026-11-04 is found and fixed: one run failed 4 checks when the `clean.busy` state's setup passed the fixture's 3-second `setup_timeout` on a busy machine, and the next failed 26 when every 1280x720 capture output went missing while the 800x600 ones were written, and left two `chrome-headless-shell` processes holding its temp folder; the fixture keeps a short limit for the `stuck` state's test without making a state that must finish fail on a busy machine; no parallel lane shares the UI capture section's folders, ports or captures; a capture run leaves no browser running; then five runs of `bash selftest.sh` in a row pass, with each time noted (check) · following AGENTS.md › Project rules for framework work
- Note: found while measuring T283; the gate runs for T296, T299 and T300 passed, so the failure is intermittent, and T42's parallel lanes are the change most likely to have made it so.
- Note: built 2026-11-04 as App-Director's T46. The fixture gave every state the 3-second `setup_timeout` meant for `stuck`, so on a busy machine (36-68% CPU from other dev servers, the prototype lane beside it) a state that must finish overran it; no lane shares the UI section's folders or port. And the kill test's `taskkill /F` could land while Chromium was starting, leaving 1-3 `chrome-headless-shell` helpers alive for up to 33 s, which held `todo-web`. Now the states keep the shipped 60 s, `stuck` runs on its own at 3 s, the kill waits for the capture to begin and stops the helpers a kill leaves, and the EXIT trap stops a capture's app and browser; all in selftest.sh, framework/tools/ui unchanged. Five runs in a row passed 533 checks, in 524 to 995 s.
- Brief: -

### T305 · SaaSAllTheThings: subagents write no shell heredocs, and the background commands they leave are stopped · done 2026-11-04 · M · agent
- PRs: SaaSAllTheThings #46 (merged)
- Touches: work/SaaSAllTheThings: framework/.satt/rules.md, framework/.satt/procedures/build.md, research.md, review.md and next-task.md, framework/.claude/agents/builder.md, researcher.md and reviewer.md, skills/saas-design-session/references/ (`bash bundle.sh`), CHANGELOG.md (under 0.16.0, since the release isn't published), TASKS.md
- Done when: `rules.md` › Doing the work has a Shell commands bullet: files are written with the file tools (Write or Edit in Claude Code), never with a shell heredoc or an `echo` or `printf` redirect of multi-line content; a multi-line script goes in a file first; every shell call is one short command, with the check, a build and a host start the only long runs, each with an explicit long timeout; a command moved to the background is stopped before a report or the end of a turn (check) · `build.md` says it before step 1, has a step before Report that stops a command of the builder's that was moved to the background (the tool's stop, or `kill` or `taskkill` with its pid) and never reports while one is alive, and a `Background:` line in the report (check) · `research.md` › Core procedure and `review.md` say it in one sentence each (check) · `next-task.md` › 3. Build stops what a subagent left in the background before it deletes `.satt/state/building` and moves on, tool-neutral, with TaskStop named in its In Claude Code bullet, and Review and Research items point to it (check) · `builder.md`, `researcher.md` and `reviewer.md` each carry one line with the rule, their tools lists unchanged (check) · a CHANGELOG entry (subagents: no shell heredocs; background commands stopped before and after a report) with upgrade steps none; the release commit already bumped the version · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-04: in an installed app a builder wrote three files with shell heredocs in one Bash call that never returned; the tool moved it to the background after its 900 s timeout, the builder rewrote the files with Write and reported 45 minutes after launch, and the live background shell kept the finished subagent showing as running for ten and a half hours. The same hang hit the main session twice that day. One wording serves all three frameworks, apart from each one's paths and long runs.
- Note: built 2026-11-04 as SaaSAllTheThings' T42, 11 files, with 725 selftest checks passing; the bundle's release commit already sets 0.16.0, so the entry sits under that heading and the version isn't bumped again. The first selftest run hit `timeout 1500` with two other selftests running, so its gate needs a longer limit under load. The researcher and reviewer have no shell tool, so their line says so; the wording in rules.md, build.md and the agent definitions repeats by the director's request, with rules.md as its home.
- Brief: -

### T306 · Godot-Director: subagents write no shell heredocs, and the background commands they leave are stopped · done 2026-11-04 · M · agent
- PRs: Godot-Director #52 (merged)
- Touches: work/Godot-Director: framework/.godot-director/rules.md, framework/.godot-director/procedures/build.md, research.md, review.md and next-task.md, framework/.claude/agents/builder.md, researcher.md and reviewer.md, CHANGELOG.md (under 4.10.0), TASKS.md
- Done when: every outcome of T305, in Godot-Director's files: the marker is `.godot/godot-director/building`, the long runs are the check, an autoplay run and an export, the new build step is 8, and the entry goes under 4.10.0; the selftest passes with the Godot path (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-04, with T305.
- Note: built 2026-11-04 as Godot-Director's T46, 10 files, with 1083 selftest checks passing with Godot 4.7.2; the entry sits under 4.10.0, which the bundle's release commit already sets.
- Brief: -

### T307 · App-Director: subagents write no shell heredocs, and the background commands they leave are stopped · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged)
- Depends on: T304
- Touches: work/App-Director: framework/.app-director/rules.md, framework/.app-director/procedures/build.md, research.md, review.md and next-task.md, framework/.claude/agents/builder.md, researcher.md and reviewer.md, CHANGELOG.md (under 1.14.0), TASKS.md
- Done when: every outcome of T305, in App-Director's files: the marker is `.app-director/state/building`, the long runs are the check, a build and a host start, and the entry goes under 1.14.0; the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-04, with T305.
- Note: built 2026-11-04 as App-Director's T47, 10 files, with 533 selftest checks passing; the entry sits under 1.14.0, which the bundle's release commit already sets. The first run hit `timeout 2400` with an empty log, beside two other selftests and another session's jobs; the selftest prints nothing until it ends, so where it stalled isn't known. The second run passed in about 20 minutes.
- Brief: -

### T297 · SaaSAllTheThings: the Stop hook runs the check only for the session that changed the code · done 2026-11-04 · M · agent
- PRs: SaaSAllTheThings #46 (merged)
- Depends on: T277
- Touches: work/SaaSAllTheThings: framework/.claude/hooks/stop-check.sh, a new framework-owned PostToolUse hook in framework/.claude/hooks/, framework/.claude/settings.json, selftest.sh, the docs that describe the Stop hook, CHANGELOG.md
- Done when: the Stop hook runs the project check only when this session itself wrote or edited a source file (any file but `*.md`, with `adr/` counting as source, the hook's present rule) since its last passing check: a PostToolUse hook on Edit, Write, MultiEdit and NotebookEdit records the paths it touched in `.satt/state/sessions/<session_id>.touched` (the hook input's `session_id`), and for Bash it compares the dirty files before and after the command (a PreToolUse snapshot, or a file list with modification times) and records the ones that changed; a session that touched only docs (`*.md` outside `adr/`, product/, TASKS.md) never triggers the check; the builder marker, the fingerprint (the same failure isn't reported twice), `SATT_STOP_CHECK=0` and the exit 0 when tools/check.sh is missing keep working; the session's record is removed when the check passes, and records older than a day are ignored (check) · in a design session that edits only Markdown while another session has uncommitted a source file (any file but `*.md`, with `adr/` counting as source, the hook's present rule) in the same folder, the Stop hook exits at once without running the check, tested with a scripted hook input; a session that edits a source file (any file but `*.md`, with `adr/` counting as source, the hook's present rule) still gets the check and is blocked once on failure, tested; the release notes' upgrade section says what changed (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-03: when two sessions share one working folder (a design session and a build session on the same checkout, no worktree), the build session's uncommitted code makes the hook run the check at the end of every turn of the design session too, which edited no code, waits minutes, and is sometimes blocked by failures it can't fix.
- Note: built 2026-11-04 as SaaSAllTheThings' T41: one new hook, session-touched.sh, records a session's source files from Edit, Write, MultiEdit and NotebookEdit, and from Bash and PowerShell by comparing `git status` before and after (also on PostToolUseFailure, so a failing command's writes count); about 0.9 s per Bash call on this machine. Limits: parallel Bash calls in one session share one snapshot, a background command's later writes aren't seen, and another session's write during a command can be counted for it. A subagent reports its parent's session_id, so a builder's edits count for the session that started it.
- Brief: -

### T298 · Release SaaSAllTheThings 0.16.0 · done 2026-11-04 · S · agent
- PRs: SaaSAllTheThings #46 (merged)
- Depends on: T277, T281, T286, T288, T290, T297
- Touches: work/SaaSAllTheThings: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/*/SKILL.md, README.md, project/product/director-brief.md, the example's copy of the brief, CHANGELOG.md
- Done when: the bundle ends with the release commit: the version files bumped to 0.16.0 as its .claude/CLAUDE.md lists them, `## Unreleased` in CHANGELOG.md is `## 0.16.0 (<date>)`, the selftest passes (check), and the commit's body is the release notes (What's new, How to install, How to upgrade with this release's upgrade steps), which are also the pull request's description · following AGENTS.md › Project rules for framework work › Releases ride in the bundle
- Note: 0.16.0 is the agent's proposal: the bundle adds features (recording after an approved summary, the per-session Stop hook) next to the guard's fixes. The director can change it in review.
- Note: the release commit is on the bundle (selftest 725 passed), and the release notes are #46's description. Once the director merges #46, `bash tools/work-release.sh work/SaaSAllTheThings 46` tags and publishes v0.16.0.
- Brief: -

### T316 · The skill pages carry what the audit finds, and the audit reads all twelve · done 2026-11-05 · M · agent
- Touches: docs/skills/*.md, tools/audit.sh
- Done when: `bash tools/audit.sh` reads every skill page (the seven it reads today, plus research, release, ui-design, prototype and security) and prints PASS at the pinned releases (check) · each statement added to a page is checked against the pinned release, and a page links a procedure rather than copying it (check) · `bash tools/check.sh` passes (check)
- Note: found 2026-11-05 when the director asked whether the site is up to date: the audit listed 43 bullets on the seven pages it reads, and the other five pages, which it doesn't read, have 80 more.
- Note: built 2026-11-05: `tools/audit.sh` reads all twelve skill pages, skips Godot-Director's `/security`, which it doesn't ship, and ignores no terms, and it prints PASS. It had also read a term that starts with `--` as a grep option, so such a term always counted as missing. The 123 bullets closed were about 12 real gaps, such as Godot-Director's screens check in `/align`, its release setup, `/prototype list` and `remove`, and the `/security` reviewer, plus paths, cross-references and worked examples named in the pages' own sentences. The review of the pages fixed a pre-push snippet split by a line break. The audit tests that each path is named, not that a sentence is right, so a PASS doesn't prove the prose.
- Brief: Scope › Common skills
- Stories: US-10

### T319 · Release App-Director 1.14.2 · done 2026-11-05 · S · agent
- PRs: App-Director #51 (merged)
- Depends on: T294
- Touches: work/App-Director: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries T294's App-Director item, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### T320 · Release SaaSAllTheThings 0.16.2 · done 2026-11-05 · S · agent
- PRs: SaaSAllTheThings #49 (merged)
- Depends on: T294, T317
- Touches: work/SaaSAllTheThings: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries T294's and T317's SaaSAllTheThings items, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### T321 · Release Godot-Director 4.10.2 · done 2026-11-05 · S · agent
- PRs: Godot-Director #55 (merged)
- Depends on: T294, T318
- Touches: work/Godot-Director: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries T294's and T318's Godot-Director items, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### T322 · Docs follow App-Director 1.14.2, SaaSAllTheThings 0.16.2 and Godot-Director 4.10.2 · done 2026-11-05 · M · agent
- Depends on: T319, T320, T321
- Touches: frameworks.lock, docs/**/*.md (the framework links and what the releases ship), selftest.sh
- Done when: `frameworks.lock` and every framework link are at v1.14.2, v0.16.2 and v4.10.2 (check) · a page that describes the guard or the CI and release workflow templates says what the releases ship, checked against them (check) · this repo's selftest covers a quoted and a backslash path to git and to a shell (check) · `bash tools/audit.sh` prints PASS and `bash tools/check.sh` passes (check)
- Note: built 2026-11-05: `frameworks.lock` and 258 framework links moved to the three tags, the SaaSAllTheThings, Godot-Director and `/release` pages say the workflow templates pin every action by commit, and this repo's selftest has 20 new cases for a path to git or a shell, with no existing case flipped. `docs/how-to/trouble.md` and the guard line in `docs/frameworks/index.md` needed nothing, since a quoted path is a detail of how the guard reads.
- Brief: Scope › Framework features
- Stories: -

### T324 · Docs follow Godot-Director 4.10.3 · done 2026-11-06 · XS · agent
- Depends on: T323
- Touches: frameworks.lock, docs/**/*.md (the Godot-Director links), docs/how-to/trouble.md
- Done when: `frameworks.lock` and every Godot-Director link are at v4.10.3, and the troubleshooting page says a repeated failure prints its saved reason (check)
- Brief: Scope › Framework features
- Stories: US-11

### T323 · Release Godot-Director 4.10.3 · done 2026-11-06 · S · agent
- PRs: Godot-Director #56 (merged)
- Depends on: B68
- Touches: work/Godot-Director: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries B68, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### B68 · Godot-Director: a check failure doesn't always say why · done 2026-11-06 · M · agent · medium
- PRs: Godot-Director #56 (merged)
- Touches: work/Godot-Director: framework/tools/check.sh, selftest.sh, the version files, CHANGELOG.md, TASKS.md
- Repro: 1. In The Guildkeeper (its B117), a test group whose log has `GDIR-TESTS:` exits non-zero, with an error line only that group's allow list reads as an error. 2. Expected: a line that names what failed. Actual: `check: FAIL (full logs in .godot/godot-director/)` and nothing else. 3. Run `bash tools/check.sh --if-changed` on the same files. Actual: only `check: FAIL (nothing changed since the last failing run; run 'bash tools/check.sh' to see why)`, so the agent reruns the tests to learn the reason, and a hook that waits on a running check repeats the same message.
- Done when: every path that sets `failed=1` or `hard_fail=1` prints a line naming what failed or adds to `errors` (test) · a failing run saves its reason lines beside `last-fail`, capped at about 20, and a repeat prints them after the FAIL line, in `--if-changed`, the pre-commit hook and the Stop hook (test) · a leak line at exit, such as `ERROR: 1 RID allocations of type ... were leaked at exit`, counts as an error and stays in the saved reason (test) · the existing wording and exit codes are unchanged (test) · the selftest passes (check)
- Note: from the director on 2026-11-06, from The Guildkeeper's session. Its `tools/check.sh` carries the first fix as a local patch, commit be0be6c5, which the upgrade replaces. Nothing is committed in the clone until the director approves.
- Note: built 2026-11-06 as Godot-Director's B6. `silent_exit` allowed from one log and the final scan from all of them, so one group's `GDIR-IGNORE` could erase another's error; the load pass had the same hole. The review showed the director's patch would print on every ordinary failing test, since `tools/check.gd` exits 1 on any failure, so the line prints at once for a crash or a kill and, for status 1, only when the final scan reports nothing from that log. An ordinary failure's output is line for line what it was. The selftest passed 1249 of 1249, and the release run 335. One earlier run failed once in an autoplay screenshot case this doesn't touch (`0000-view.png` for `0000-start.png`); it passed on the others, is probably a flake under load, and wasn't looked into.
- Brief: -
- Stories: -

### T331 · Docs follow Godot-Director 4.10.4 and SaaSAllTheThings 0.16.3 · done 2026-11-11 · XS · agent
- Depends on: T329, T330
- Touches: frameworks.lock, docs/**/*.md (the Godot-Director and SaaSAllTheThings links)
- Done when: `frameworks.lock` and every Godot-Director and SaaSAllTheThings link are at v4.10.4 and v0.16.3 (check) · `bash tools/audit.sh` prints PASS and `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features
- Stories: -

### T329 · Release Godot-Director 4.10.4 · done 2026-11-11 · S · agent
- PRs: Godot-Director #57 (merged)
- Depends on: B69
- Touches: work/Godot-Director: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries B69, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### B69 · Godot-Director: staging a new file changes the check's fingerprint and the import fingerprint · done 2026-11-11 · S · agent · med
- PRs: Godot-Director #57 (merged)
- Touches: work/Godot-Director: framework/tools/check.sh, framework/tools/autoplay.sh, framework/tools/ui_capture.sh, selftest.sh, CHANGELOG.md, TASKS.md
- Repro: 1. In a game with a committed `scripts/a.gd` and a new, untracked `scripts/b.gd`, run `bash tools/check.sh --fingerprint`. 2. Run `git add scripts/b.gd`, then the same command. Expected: the same hash, since no file's content changed. Actual: a different hash. `fingerprint()` hashes the paths in the order `git ls-files -c -o --exclude-standard` prints them, untracked files first, so staging moves the file in the list. `--if-changed` then misses, and the pre-commit hook runs the whole check again right after the build or the Stop hook passed the same files. `import_fingerprint()`, the block `check.sh`, `autoplay.sh` and `ui_capture.sh` share, orders its list the same way, so staging a new asset or script runs the import pass again.
- Found in: T325 (its first review), reproduced on v4.10.3
- Note: built 2026-11-11 as Godot-Director's B7. `fingerprint()` and `import_fingerprint()` sort their lists with `LC_ALL=C sort -u`, through `/usr/bin/sort` where it exists, and the import block is the same in its three scripts. `git grep --untracked` already prints in path order, so the block's `decl` line is as it was. Three selftest cases in the framework lane, which runs without Godot: both fingerprints are the same before and after `git add` of a new script and a new asset, and a changed script still changes the check's fingerprint. The two staging cases failed before the fix. The selftest passed 1252 of 1252 with Godot 4.7.2, and the release run 338.
- Brief: -
- Stories: -

### T330 · Release SaaSAllTheThings 0.16.3 · done 2026-11-11 · S · agent
- PRs: SaaSAllTheThings #50 (merged)
- Depends on: B70
- Touches: work/SaaSAllTheThings: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries B70, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### B70 · SaaSAllTheThings: staging a new file changes the check's fingerprint · done 2026-11-11 · S · agent · med
- PRs: SaaSAllTheThings #50 (merged)
- Touches: work/SaaSAllTheThings: framework/tools/check.sh, selftest.sh, CHANGELOG.md, TASKS.md
- Repro: 1. In an app with a committed `src/a.cs` and a new, untracked `src/b.cs`, run `bash tools/check.sh --fingerprint`. 2. Run `git add src/b.cs`, then the same command. Expected: the same hash, since no file's content changed. Actual: a different hash, for B69's reason: `fingerprint()` hashes the paths in the order `git ls-files -c -o --exclude-standard` prints them. `--if-changed` then misses, and the pre-commit hook runs the whole check again right after the build or the Stop hook passed the same files.
- Found in: T325 (its first review), reproduced on v0.16.2
- Note: built 2026-11-11 as SaaSAllTheThings' B3. `fingerprint()` sorts its list with `LC_ALL=C sort -u`, through `/usr/bin/sort` where it exists. Four selftest cases in the check section: a check passes with a new, untracked file, the fingerprint is the same after `git add`, `--if-changed` reuses that pass, and a changed file still changes the fingerprint. Run against a `check.sh` without the sort, the second and third fail. The selftest passed 811 of 811, for the fix and again for the release; its .NET part was skipped, since this machine has no .NET SDK.
- Brief: -
- Stories: -

### T328 · Docs follow App-Director 1.15.0 · done 2026-11-11 · M · agent
- Depends on: T327
- Touches: frameworks.lock, docs/**/*.md (the App-Director links), docs/frameworks/app-director.md, docs/frameworks/index.md, docs/concept/check.md, docs/concept/cost-built-in.md, docs/how-to/check.md, docs/how-to/build.md
- Done when: `frameworks.lock` and every App-Director link are at v1.15.0 (check) · the pages that describe App-Director's check say what the release ships, each statement checked against it: the fast and the full tier and when the full tier is due, which tier the pre-commit, pre-push and Stop hooks ask for, a stack with no fast mode running one suite, the time limit of each tier, the cache naming what changed on a miss, and one check at a time in a checkout (check) · `bash tools/audit.sh` prints PASS and `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features
- Stories: US-5, US-13

### T327 · Release App-Director 1.15.0 · done 2026-11-10 · S · agent
- PRs: App-Director #52 (merged)
- Depends on: T325
- Touches: work/App-Director: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries T325, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### T325 · App-Director: a fast check tier for every commit, a cache that says why it missed, and one check at a time · done 2026-11-10 · XL · agent
- PRs: App-Director #52 (merged)
- Touches: work/App-Director: framework/tools/check.sh, framework/tools/stacks/typescript.sh, framework/.githooks/pre-commit, framework/.githooks/pre-push, framework/.claude/hooks/stop-check.sh, framework/.app-director/procedures/build.md, next-task.md, release.md, framework/.app-director/rules.md, project/tools/check.cfg, README.md, ONBOARDING.md, framework/tools/prototype.sh, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: `bash tools/check.sh --fast` runs UI purity, the secrets scan, tsc, eslint on the changed files and only the tests related to the change, and `bash tools/check.sh` with no argument still runs everything and fails on any failure (test) · the pre-commit and Stop hooks run the fast tier, the commit hook and the pre-push hook run the full tier when `[tests] full-every` commits have passed or a changed path is a dependency, config, tool or `[tests] full-when` path, and a fast pass is never recorded or reported as a full one (test) · `--if-changed` prints one line on every miss naming what changed and the pass it compared with, reuses a builder's pass on identical files, and every run is logged in `.app-director/state/check-runs.log` with its tier and duration (test) · two simultaneous checks start one suite, the second says it's waiting and reuses the first's result, and a stale lock is removed (test) · the Stop hook never runs the full tier and never reports "couldn't run" because another check is running (test) · each tier has its own time limit (300 and 3600 s by default), the check prints its progress every 60 s, and exit codes 0, 1 and 3 and the secrets scan on every commit are unchanged (test) · a commit that changes one .ts file and its test in a clone of brfservice runs the fast tier in under 2 minutes, measured and recorded (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: from the director on 2026-11-10, from brfservice's session: 17 commits that day each ran the whole check (UI purity, gitleaks, tsc, eslint, a production build, npm audit, about 4,900 vitest tests) in the pre-commit hook, 15 to 25 minutes a commit; a builder's pass was run again by the commit hook on the same files without saying why it missed; a JSON wording change ran every test; and a Stop hook beside a commit hook timed out at 1200 s. brfservice's own `tools/check.cfg` keys (`[tests] fast = related`, `full-every = 10`, the per-tier limits) are delivered with it, and its product code isn't touched. Built in three stages: the check, then single flight and the hooks, then the procedures.
- Note: built 2026-11-10 as App-Director's T55, in three stages and two rounds of review fixes. The first review found the fingerprint hashed `git ls-files` in its order, untracked files first, so `git add` of a new file changed it and a builder's pass of an item that adds a file was never reused; the list is sorted now. It also found three ways the TypeScript fast tier failed where the full tier passed: a legacy eslint config, cmd.exe's 8,191-character limit, and coverage thresholds. The second review found the large-change fallback ran the whole suite under the fast limit, so such a change now runs as the full tier, and that requiring the same commit threw away the pass that gated a commit, so a fast record now keeps its changed list. It also closed gaps in the lock's heartbeat: sleep and wake, a mismatch, and the holder's limit. Vitest has no result cache by file content, so none is faked; the check's own cache skips a repeat. Selftest 866 of 866. Timed on a scratch clone of brfservice with its packages, an otherwise quiet machine, and its proposed settings and `check.local.sh`:
  - A commit of one .ts file and its test ran the fast tier in 67 s twice: 37 of 278 test files (686 of 4,938 tests), and the check took 60 s. The first commit, before the incremental tsc had its build info and with the build and audit still in `check.local.sh`, took 145 s; the next took 126 s.
  - A translations-only commit took 48 s: only `tests/i18n.test.tsx` ran.
  - A docs-only commit took 2 s.
  - Two checks at once started one suite; the second waited and reused its pass.
  - A full-tier commit took 398 s, and a plain full run 618 s.
  - `--coverage.enabled=false` was confirmed off in vitest 5.0.5.

  brfservice's settings and the optional `check.local.sh` change were handed to the director as a patch and aren't applied there.
- Note: a third round on 2026-11-10, after the director asked for a reassessment of the pull request and approved its recommendations. Where neither the stack check nor `tools/check.local.sh` reads `CHECK_TIER` (the python, flutter and none stacks), a fast request runs as the full tier, so one pass serves the build, the commit and the push, and the Stop hook's check there is the whole suite under the full tier's limit. The paths that make the full tier due count in the cache and in the hook's staged test, so a changed migration is a miss and a commit that stages only one starts the check. The rules have the agent ask `bash tools/check.sh --due` before a commit and run a due full tier in the background first. The same commit reads a `tools/check.cfg` with CRLF line endings without a pipeline for each line: in the scratch clone of brfservice `--due` went from about 6 s to about 1 s. Selftest 893 of 893. Merged with #52 and released as 1.15.0.
- Brief: -
- Stories: -

### T332 · App-Director: a `proposed` item status, the bugs rule, and what a message means · done 2026-11-11 · M · agent
- PRs: App-Director #53 (merged)
- Touches: work/App-Director: framework/.app-director/tasks.md, framework/.app-director/rules.md, framework/.app-director/procedures/next-task.md, design.md, review.md, research.md, security.md, project/tools/check.cfg, ONBOARDING.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: `tasks.md` has the status `proposed`, an item the assistant filed by itself that no procedure picks or builds until an approved summary makes it `todo` (check) · `next-task.md` files a builder's `Found:` lines, review leftovers, research follow-ups and a failing full run as `proposed`, or as a `todo` bug where the bugs rule allows it, and never picks a `proposed` item (check) · the bugs rule is in `rules.md`: a bug restores behaviour the brief or a confirmed story already states and names that heading or story, one that can name neither is `proposed`, and `[records] bugs` in `tools/check.cfg` (`cited` by default, `all` or `none`) is asked at onboarding (check) · `rules.md` and `design.md` say that a complaint, an observation, a screenshot or a bug report means diagnose, propose and ask, that a question dialog the director left unanswered is no answer whatever its tool result says, and that a run mode or a project's commit rule never authorises a record (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: from the director on 2026-11-11, from brfservice's session: its assistant wrote decisions, brief text and items five times in one day without an approved summary, and withdrew one item at the director's demand. The director chose this design on 2026-11-11.
- Note: built on 2026-11-11 as App-Director's T56, the first commit of the bundle. It also changed `procedures/align.md`, which `Touches` didn't name: a `done` item may not depend on a `proposed` one, and a `proposed` item isn't planned work. Selftest 895 of 895.
- Brief: Scope › Planned framework changes
- Stories: -

### T333 · App-Director: `tools/records.sh` and a commit gate for records · done 2026-11-11 · L · agent
- PRs: App-Director #54 (merged)
- Depends on: T332
- Touches: work/App-Director: framework/tools/records.sh (new), framework/.githooks/pre-commit, framework/.githooks/commit-msg (new), framework/tools/setup-clone.sh, project/tools/check.cfg, install.sh and the manifest where they list files, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: `bash tools/records.sh summary <file>` registers the exact lines a summary adds and removes, per file, and prints its id, its hash and the lines (test) · `bash tools/records.sh approve <id>`, and `approve --staged` for the director's own edits, record an approval from the director's own terminal, the path for an assistant without hooks (test) · the pre-commit hook refuses a commit that adds or removes a line of `product/brief.md` or `product/decisions.md`, sets, changes or removes a confirmed story or the Last validated line, adds an item that isn't `proposed` (except a bug the bugs setting frees), moves a `proposed` item on, changes an item's `Done when`, `Repro` or `Question`, removes an item that isn't `done`, or changes a `[records]` or `[approval]` setting, unless an approval covers exactly those lines; it names the lines and what to do (test) · status changes, the escalation label, `Note:` lines, `Next IDs`, pruned `done` items, `unconfirmed` stories and `proposed` items pass, and so do lines a merge brings from a commit, and a prototype checkout (test) · an approval covers only the text registered: a changed summary, an approval older than its summary and an approval whose lines are already committed are refused (test) · the commit-msg hook refuses a commit that carries approved record lines and doesn't name the approval, with the line to add (test) · `bash tools/records.sh report` lists the approvals used since a commit and the `proposed` items (test) · the record paths come from `[records]` in `tools/check.cfg`, with the defaults when it has none, on Git Bash, bash 3.2 and BSD tools (test) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: built on 2026-11-11 as App-Director's T57, the first commit of a second bundle (#53 was merged with T332 alone). Three reviews and three rebuilds. It also changed `README.md`, `ONBOARDING.md` and `framework/.app-director/tasks.md`, which `Touches` didn't name. The gate judges commits made with `git commit`; the header of `tools/records.sh` states what it doesn't judge: commands that commit without the pre-commit hook, a merge git completes by itself, a prototype checkout, a record file's first commit, and an approval forged on purpose. Selftest 1162 of 1162.
- Brief: Scope › Planned framework changes
- Stories: -

### T334 · App-Director: Claude Code records the director's approval and guards the records · done 2026-11-11 · L · agent
- PRs: App-Director #54 (merged)
- Depends on: T333
- Touches: work/App-Director: framework/.claude/hooks/record-approval.sh (new), framework/.claude/hooks/record-watch.sh (new), framework/.claude/hooks/guard-protected.sh, framework/.claude/hooks/guard-commands.sh, framework/.claude/settings.json, project/tools/check.cfg, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: a probe in a scratch repo, run by the orchestrating session before the build, shows what the hooks receive for a typed message, a dialog answer, a message typed while a dialog is open, a background subagent's report, another session's message and a scheduled prompt, and the hook's header and the CHANGELOG say what it showed (check) · a prompt hook records an approval when the director's message is nothing but a word from `[approval] words` in `tools/check.cfg` (godkänt, godkänd, approve, approved, ok, ja, yes and kör by default), alone for a summary registered since the previous message or followed by the summary's id; where the probe shows a hook receives a dialog's answer, the Approve option of a question that names the summary counts too (test) · any other message withdraws an approval that isn't committed yet and tells the assistant, as context, that nothing may be written; with no summary waiting the hook prints nothing; only the approval is stored, never another message's text (test) · the file tools can't change `product/brief.md` or `product/decisions.md` without an open approval, never from a subagent, and never the approval state; the command guard refuses `records.sh approve` and a prompt the assistant schedules or sends that is only an approval word (test) · an approval counts only in the session that registered its summary, and a prompt that equals one the session has scheduled is never an approval (test) · the command guard refuses `git cherry-pick`, `git revert`, `git rebase` and `git am`, which make commits the record gate never sees, and says to ask the director to run them (test) · after a file tool or a shell command changes a protected file, a hook tells the assistant at once which lines no approval covers, whatever wrote them (`sed -i`, `node -e`, a Python one-liner) (test) · the 2026-11-11 sequence, replayed against a fake repository, ends with no approval and a refused commit: a dialog left unanswered, a complaint, then a decision line, brief text and a `todo` item (test) · the guard's existing cases still pass, and the new hooks run on Git Bash and bash 3.2 (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: the probe ran on 2026-11-11 in a scratch repo, in the Claude desktop app, with the director doing four steps. A dialog's chosen option reaches the hook that runs after the dialog, and no prompt hook fires for it. A message typed while a dialog is open reaches the prompt hook as plain text. A typed message and a next-step button reach it as their text, at times with a note from the app in front. A subagent's report and another session's message reach it inside a frame. A scheduled prompt reaches it as plain text, with nothing that tells it from a typed one; the hook that runs when a turn ends receives the session's pending scheduled prompts. Every tool call inside a subagent carries an agent id. When a turn ends on a tool call, that hook gets no last message, so a hook can't check that the summary's lines were shown.
- Note: built on 2026-11-11 as App-Director's T58, the second commit of the second bundle. Three reviews and three rebuilds. It added `framework/.claude/hooks/record-paths.sh` and changed `framework/tools/records.sh` (the `word` and `withdraw <id>` subcommands, an atomic claim of a summary's id), which `Touches` didn't name; `project/tools/check.cfg` needed no change. The command guard reads a command's words, so a disguised command stays a stated limit, as do the four git commands run through `xargs` or after `timeout`. Selftest 1321 of 1321.
- Brief: Scope › Planned framework changes
- Stories: -

### T335 · App-Director: the procedures write records through the approved summary · done 2026-11-11 · M · agent
- PRs: App-Director #54 (merged)
- Note: built on 2026-11-11 as App-Director's T59, the third commit of the second bundle, with a fourth that makes its selftest case find the changelog section under a release heading as well as under Unreleased. `prototype.md` needed no change: it points to the harvest in `design.md`. Selftest 1322 of 1322.
- Depends on: T334
- Touches: work/App-Director: framework/.app-director/rules.md, framework/.app-director/procedures/design.md, next-task.md, build.md, acceptance.md, align.md, research.md, ui-design.md, drift-reset.md, security.md, prune.md, prototype.md, framework/.claude/agents/builder.md, reviewer.md, researcher.md, README.md, ONBOARDING.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: `design.md` › Summary and approval registers the summary, shows its lines word for word with its id, and writes and commits only after the approval, and every procedure that writes from a conversation points there (check) · `next-task.md` commits a decision's records at once, before the rebuild, and a run's final report lists each record written with its approval and every `proposed` item filed, from `bash tools/records.sh report` (check) · `build.md` and the three agents say that a builder, reviewer or researcher reports record text and never writes it (check) · the CHANGELOG has Upgrade steps: the hook wiring in `.claude/settings.json`, `bash tools/setup-clone.sh` for the new git hook, the settings in `tools/check.cfg`, and that lines already committed aren't judged (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes
- Stories: -

### T336 · Release App-Director 1.16.0 · done 2026-11-11 · S · agent
- PRs: App-Director #54 (merged)
- Depends on: T335
- Touches: work/App-Director: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries T332 to T335, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### T337 · Docs follow App-Director 1.16.0 · done 2026-11-11 · M · agent
- Depends on: T336
- Touches: frameworks.lock, docs/**/*.md (the App-Director links), docs/frameworks/app-director.md, docs/skills/design.md, docs/skills/next-task.md, docs/how-to/decide.md, docs/how-to/trouble.md, docs/concept/design-calls.md, docs/concept/records.md
- Done when: `frameworks.lock` and every App-Director link are at v1.16.0 (check) · the pages that describe App-Director's design session, its items and its commits say what the release ships, checked against it: the registered summary and its approval, the commit gate, `proposed` items and the bugs setting (check) · `bash tools/audit.sh` prints PASS and `bash tools/check.sh` passes (check)
- Note: built on 2026-11-11. The pin, 45 links and seven pages follow the release, and the brief's bullet moved from Planned framework changes to Framework features. The audit prints PASS and the check passes without the pin warning.
- Brief: Scope › Framework features
- Stories: US-5, US-9, US-10, US-11

### T326 · App-Director: the TypeScript stack finds every eslint config name · todo · XS · agent
- Touches: work/App-Director: framework/tools/stacks/typescript.sh, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: a project whose only eslint config is `eslint.config.cjs`, `.ts`, `.mts` or `.cts`, `.eslintrc.yml`, `.eslintrc.yaml` or `.eslintrc` gets the lint step in both tiers, a flat one with the changed files and `--no-warn-ignored` in the fast tier, a legacy one over the whole project (test) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T325's second review: `typescript.sh` lints only when `.eslintrc.json`, `.js` or `.cjs`, or `eslint.config.js` or `.mjs`, exists, so a project with another config name gets no lint in either tier. It was so before T325.
- Brief: -
- Stories: -

### B67 · A long enough command body outlasts the guard's time limit (A01:2025 Broken Access Control) · todo · M · agent · medium
- Touches: work/App-Director, work/SaaSAllTheThings, work/Godot-Director: each guard hook and selftest.sh
- Repro: 1. Feed App-Director's guard a Bash heredoc or a PowerShell here-string whose lines each name `C:\Git\bin\bash.exe -c` and `git.exe -c`. 2. Expected: it finishes inside the hook's 10 s limit at any size. Actual: Bash 5.7 s at 42 KB, 22.9 s at 85 KB and 86 s at 170 KB; PowerShell 2.1, 6.8 and 24 s. The cost grows with the square of the length, on `origin/main` too, so a body of about 60 KB in Bash or 100 KB in PowerShell passes the limit. A hook that times out doesn't block, so a command padded this way runs unguarded.
- Note: measured on App-Director's hook on 2026-11-05; Godot-Director scales the same way. It needs a redesign of the per-line reading, or a size past which the guard blocks and says why, which is a design call.
- Found in: T294
- Brief: -
- Stories: -

### T294 · The three guards: a quoted or backslash path to git or a shell can't hide git's program flags or a wrapper's script · done 2026-11-05 · M · agent
- PRs: App-Director #51 (merged), SaaSAllTheThings #49 (merged), Godot-Director #55 (merged)
- Depends on: T290, T292, T293
- Touches: work/SaaSAllTheThings, work/App-Director, work/Godot-Director: each guard hook and selftest.sh
- Done when: `"C:\Program Files\Git\bin\git.exe" -c core.pager=calc log` and `--upload-pack` with a quoted git path, and `"C:\Program Files\Git\bin\bash.exe" -c "git push --force"` and `C:\Git\bin\bash.exe -c ...`, are blocked as the bare names are, with their cases, in each framework's guard; the selftests pass (check) · following AGENTS.md › Project rules for framework work
- Note: found in T290: the `-c` and program-flag rules and the shell wrapper gate read only a bare git or shell word.
- Note: built 2026-11-05 as App-Director's T54, SaaSAllTheThings' T48 and Godot-Director's T52, resized from S to M since the three guards read text three ways. A quoted or backslash path to git or a shell now reads as the bare name for the `-c` and program-flag rules and the shell wrapper gate. The first pass widened `cfg_pre`, so a long PowerShell here-string that names `git.exe -c` took 13.8 to 25.7 s against each hook's 10 s limit; the orchestrator's timing run caught it, the rebuild reads those bodies without the here-string text, and all three are back within noise of `origin/main`, with a timing case each. B67 is the cost that remains. Selftests: 631, 807 and 1200 passed. App-Director's first run on the 1.14.2 bump failed two cases in `/ui-design`'s capture restart, with SaaSAllTheThings' selftest beside it, and passed 631 on the rerun; it's a suspected race, not shown.
- Brief: -
- Stories: -

### T317 · SaaSAllTheThings: the check workflow template pins every action by commit, as its OWASP check asks · done 2026-11-05 · S · agent
- PRs: SaaSAllTheThings #49 (merged)
- Depends on: T294
- Touches: work/SaaSAllTheThings: framework/.satt/templates/check-workflow.yml, framework/.satt/reference/owasp.md, skills/saas-design-session/references/reference/owasp.md (by `bash bundle.sh`), selftest.sh
- Done when: every `uses:` in the template is a full commit SHA with its version in a trailing comment, each SHA read from the action's own repository (check) · `owasp.md` A08 says pinned by commit and the bundled copy matches it (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: built 2026-11-05 as SaaSAllTheThings' T49, after T294 on its bundle, with 807 selftest checks passing (.NET skipped: no SDK here). The selftest required major version tags, with no recorded decision behind it, so it now requires the SHA and the comment. Each SHA is the commit the template's tag points at today, so no action changed version.
- Brief: -
- Stories: -

### T318 · Godot-Director: the release workflow template pins every action by commit · done 2026-11-05 · S · agent
- PRs: Godot-Director #55 (merged)
- Depends on: T294
- Touches: work/Godot-Director: framework/.godot-director/templates/release-workflow.yml, selftest.sh
- Done when: every `uses:` in the template is a full commit SHA with its version in a trailing comment, each SHA read from the action's own repository (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: built 2026-11-05 as Godot-Director's T53, after T294 on its bundle, with 1201 selftest checks passing with Godot 4.7.2. The selftest had no check on this, so it gained one that fails on an action not pinned this way. Each SHA is the commit the template's tag points at today, so no action changed version.
- Brief: -
- Stories: -

### T301 · App-Director and SaaSAllTheThings: a variable command name followed by a global option can't hide a git subcommand · todo · XS · agent
- Depends on: T289, T300, T298
- Touches: work/App-Director and work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh, selftest.sh
- Done when: with `G` set in the environment, `"$G" --work-tree . restore .` and `"$G" --git-dir .git branch -D x` are blocked in each hook, as Godot-Director's T43 does by skipping each global option's value before it looks for the subcommand, with their cases; the selftests pass (check) · following AGENTS.md › Project rules for framework work
- Note: found in T289; both exit 0 on each hook at its bundle's head. Built after the two releases, in each repo's next bundle.
- Brief: -
- Stories: -

### B53 · A script piped to a shell, a path-qualified or `.exe` git or bash, a sudo option's value, cmd's %VAR% or a folder in another case passes the guard (A01:2025 Broken Access Control) · todo · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `printf 'git push --force' | bash` or `echo 'git push --force' | sh`; `/usr/bin/git push --force` or `git.exe push --force` (so `G=/usr/bin/git; $G push --force` too); `sudo -u root "$G" push --force`; `cmd /c "%G% push --force"`; `cat > .GIT/hooks/pre-commit <<'EOF'` with `git push --force` in the body; `bash.exe tools/../x.sh`; or `bash TOOLS/../x.sh`. 2. Expected: each is blocked, as `git push --force` and a `.git/hooks` write are. Actual: exit 0: a shell reading its script from a pipe isn't read as a wrapper, the git test needs the bare name, an option's value before the command name isn't skipped, only `$` variables are read, a shell's name takes no `.exe`, and the `.git` and `tools/` folder tests are case-sensitive, while Windows folders aren't. T285 and T284 bring T277's path-qualified git to the generic and flag rules here; the `-c` key, variable and credential readings still need it, in all three frameworks.
- Found in: B45, B46, B47, T277
- Brief: -
- Stories: -

### B54 · A message that names `--no-verify` or `gh auth token` is blocked · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `git commit -q -F - <<'EOF'` with a body line naming `--no-verify`, or `gh pr edit 5 --body-file - <<'EOF'` with a body naming `gh auth token`. 2. Expected: passes: each body is a message no shell runs (B39, B40, B48). Actual: exit 2: the no-verify check reads the raw text, and the credential-print rule reads decoded bodies, messages included.
- Found in: B48
- Brief: -
- Stories: -

### B56 · A PowerShell `for (;;)` loop passes the hang check · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook a PowerShell payload with `for (;;) { Start-Sleep 1 }`. 2. Expected: blocked, as the Bash form is since B49. Actual: exit 0: the loop rule reads Bash's C-style loop only. (B52 made the hang rules read PowerShell subexpressions, which was this item's other half.)
- Found in: B49
- Brief: -
- Stories: -

### B57 · A `-m` message is read as commands when the same command also runs `bash -c` · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `bash -c 'echo hi' && git commit -q -m "wait: until done; do sleep 1; done"`. 2. Expected: passes: the -m value is a message. Actual: exit 2: with an unquoted `bash -c` in the command, the raw-text scan reads the -m value too.
- Found in: B50
- Brief: -
- Stories: -

### B58 · A PowerShell block comment, or an ANSI-C quoted escape before a `#`, hides a git flag (A01:2025 Broken Access Control) · todo · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook a PowerShell payload with `<# it's #> git push origin ':main' 'x'`, or a Bash payload with `git push $'a\'b #' "$(printf '\055\055force')"`. 2. Expected: each is blocked. Actual: exit 0: B51 reads PowerShell's line comments but not its block comments, and B43's substitution reader takes the `#` after an ANSI-C quoted escape as a comment, so the substitution after it is never read.
- Found in: B51
- Brief: -
- Stories: -

### B59 · A quoted `;` in a reader's arguments, a substitution inside a reader's name, or git printing a file passes the credential-read check (A01:2025 Broken Access Control) · todo · S · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `cat 'a;b' .env.local`, `c$(echo a)t .env.local`, `git show HEAD:.env.local` or `git cat-file -p HEAD:.env.local`. 2. Expected: each is blocked, as `cat .env.local` is. Actual: exit 0: a quoted `;` ends the reader's arguments, a substitution inside a reader's name isn't read, and no rule treats git's file printers as readers.
- Found in: B52
- Brief: -
- Stories: -

### B61 · A PowerShell pipeline from a variable, an `if` or `foreach` inside `-Command`, or a case-sensitive operator is blocked · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook a PowerShell payload with `$files = Get-ChildItem; $files | Measure-Object`, `$x = "$(git status)"; $x`, or `$x -ceq 1`; `powershell -Command 'if ($x) { Get-Date }'` or a `foreach ($f in $files)` script; or `powershell -ExecutionPolicy Bypass -File` with a path holding `$`. 2. Expected: passes: none runs a command named by a variable. Actual: exit 2: the assignment test matches any `$name =` in the command, a segment starts at `(`, B37's `-c` rule reads `-ceq` and `-cgt`, and the value of `-ExecutionPolicy` is read as the start of a `-Command` script.
- Found in: B55, B60
- Brief: -
- Stories: -

### B62 · A PowerShell call operator on a variable, or a wrapper inside a non-git command's substitution, passes the guard (A01:2025 Broken Access Control) · todo · XS · agent · med
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook a PowerShell payload with `& ($args[0]) push --force`, `& $cmd` or `. $script` (unresolved); `echo "$(powershell -Command '& $args push --force')"`; or `$sb = [scriptblock]::Create('git push --force')` then `$sb.Invoke()`, or `$ExecutionContext.InvokeCommand.NewScriptBlock('...')`. 2. Expected: blocked, or blocked with a message that the guard can't judge what the variable runs. Actual: exit 0: a segment ends at `)`, B45 blocks a call only with a subcommand, a destructive flag, -c or an assignment, a non-git command's substitution gets only the hang and read rules, and a script block's literal isn't read as a script, since the `(` splits the words.
- Found in: B55, B60
- Brief: -
- Stories: -

### B63 · A redirect after `git diff` is read as a path outside the repository · todo · XS · agent · low
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built)
- Repro: 1. Feed the guard hook `git diff > /tmp/x.diff` or `git -C work/App-Director diff > /tmp/x.diff`. 2. Expected: passes: the redirect writes git's output, and git reads no path outside the repository. Actual: exit 2, "git diff of a path outside the repository": the outside-path rule takes the redirect's target as a pathspec.
- Found in: T280
- Brief: -
- Stories: -

### B64 · A quoted multi-line string after an empty Python heredoc hides it from the hang check · done 2026-11-04 · S · agent · medium
- Touches: .claude/hooks/guard-commands.sh, selftest.sh (the guard is framework-owned: an item for each framework once it's built; Godot-Director's is guard-git.sh)
- Repro: 1. Feed the guard hook, without running it, a command of three lines: `python3 - <<'E' 2>/dev/null || node -e "`, then `x()"`, then `E`. 2. Expected: blocked as an empty Python heredoc: the quoted string closes on the second line, so the shell starts the heredoc's body after it and the body is empty. Actual: exit 0 in this repo's guard and in App-Director's, SaaSAllTheThings' and Godot-Director's (2026-11-04), while the plain empty form, `python3 - <<'E'` then `E`, exits 2 in all four. The hang check takes the line after the header as the body, so it never reaches the delimiter.
- Found in: T305, by a forked session reading processes left spinning on 2026-11-04: pids 39632 and 36756 came from this form and 23516 is the same shape from another project; each burns a core until it is killed. The hang behind T305 is likely this family too: a shell that ran two `cat` heredocs and then `python - <<'EOF' 2>/dev/null || true` with an empty body; likely, not proven.
- Note: closed by T309 in the three released guards and T284 here.
- Brief: -

### B65 · App-Director's selftest hit its time limit with an empty log on two runs · todo · S · agent · low
- Touches: work/App-Director: selftest.sh
- Repro: 1. Run `bash selftest.sh` in App-Director beside other selftests. 2. Expected: it ends, or shows where it is. Actual: on 2026-11-04 one run hit `timeout 2400` (T307) and one hit `timeout 3300` (T308), each with an empty log, and the rerun of each passed, in about 20 and 30 minutes. The selftest prints nothing until it ends and deletes its temp folder on exit, so where it stood isn't known; load is likely, a stall isn't ruled out.
- Note: a line per section as it starts would show where a run stands. Both reruns used `KEEP=1`, and other runs without it passed, so that isn't shown to matter.
- Found in: T307, T308
- Brief: -
- Stories: -

### T338 · The UI How-to says how to start from a design kept in Penpot or Figma · done 2026-11-12 · M · agent
- Depends on: R10
- Touches: docs/how-to/ui.md
- Done when: "How do I work with UI changes?" says, with describing a change, that a design you keep in Penpot or Figma can be the starting point: you connect the tool's own MCP server to your agent yourself, give the agent the board or the frame's link in a design session, and it reads the design and proposes the screen's behaviour and items, which you approve as in any design session (check) · it says what this path leaves out: the frameworks ship no reader for either tool, so a screen spec, the compare image and `verify` still come from a drawing, and the agent records what the screen shows and does, not code the tool generated (check) · it links each vendor's own page for setup, seats and limits instead of copying numbers that change, and says the key or sign-in stays in your own client, outside the repository (check) · every statement about the two tools is in the research note of R10 with a source, and the page claims no support the frameworks don't ship (check) · `bash tools/check.sh` passes (check)
- Note: from the director on 2026-11-12, after R10, whose note recommends documenting this path.
- Brief: Scope › How-to guides
- Stories: US-9

### T339 · SaaSAllTheThings: the check runs its backend, Bicep and project steps side by side · done 2026-11-14 · M · agent
- PRs: SaaSAllTheThings #51 (merged)
- Depends on: -
- Touches: work/SaaSAllTheThings: framework/tools/check.sh, framework/tools/cfg.sh, project/tools/check.cfg, framework/.satt/rules.md, ONBOARDING.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: with the setting on, `bash tools/check.sh` runs the backend stack, the Bicep compile and `tools/check.local.sh` at the same time once the architecture step is done, each under its own time limit with its own log, prints each step's lines together in the order of a serial run, and exits 0, 1 or 3 as a serial run of the same files would (test) · the setting is a key in `tools/check.cfg`: the seed turns it on, an app without the key runs the steps in order as before, and the CHANGELOG's Upgrade steps say when to turn it on (an app whose own steps don't need the backend's build output) (test) · every run ends with each step's seconds and the total (test) · a full run in a scratch clone of Project Director is timed with the setting on and off, and both times are in the item's note (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: from the director on 2026-11-13: Project Director's full check takes about 7 minutes, one step after the other (architecture about 1, backend about 3, Bicep 0.5, the web client 2.2).
- Note: built 2026-11-13 as SaaSAllTheThings' T50. The setting is `[tests] parallel = on` in `tools/check.cfg`: each step runs as a background job with its lines in `.satt/state/step-<name>.out`, and every run ends with a `check: seconds:` line. `ONBOARDING.md` needed no change. The selftest passed 834 of 834; its .NET part was skipped, since this machine has no .NET SDK. Timed on 2026-11-13 in a scratch clone of Project Director with the new `check.sh` and `cfg.sh`: in order 585 seconds (architecture 71, stack 285, Bicep 41, project steps 188), side by side 338 seconds (architecture 51, stack 287, Bicep 80, project steps 277), so a run now lasts as long as the architecture step and the backend stack together. The run in order came first, on a machine just restarted; a second run in order, after the side-by-side run and while a selftest ran on the same machine, took 494 seconds (architecture 35, stack 174, Bicep 59, project steps 226), so the gain is between 150 and 250 seconds a run on this machine. All three runs exited 1 on the same two tests, `infra/scripts/modelDeployments.test.mjs` and `clients/web/src/styles/profile.test.ts`, with every other test run in each (2,403 backend tests and 86 web test files); the scratch clone checked its files out with CRLF line endings (seen for `tokens.css`, which the second test reads).
- Brief: Scope › Planned framework changes
- Stories: -

### T340 · SaaSAllTheThings: a fast tier for the check, selected by area · done 2026-11-14 · L · agent
- PRs: SaaSAllTheThings #51 (merged)
- Depends on: T339
- Touches: work/SaaSAllTheThings: framework/tools/check.sh, framework/tools/cfg.sh, project/tools/check.cfg, framework/.satt/rules.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: `bash tools/check.sh --fast` runs the architecture rules and the secrets scan over the whole project, then only the steps the change from HEAD touches: the Bicep compile for a change under `infra/`, the backend stack unless every changed path is under `infra/`, in the `client` layer or documentation, and `tools/check.local.sh` with `CHECK_TIER=fast` and the changed paths in `CHECK_CHANGED`, so an app's own steps can leave out what the change doesn't touch; `bash tools/check.sh` with no argument still runs everything (test) · a change to a dependency or its lockfile, a toolchain setting, a file under `tools/` or a `[tests] full-when` path runs as the full tier and says so (test) · a recorded result names its tier, a fast pass never stands for a full one, `--if-changed` reuses a pass of the same files and tier, and `bash tools/check.sh --due` says whether the full tier is due and why: no full pass recorded, `[tests] full-every` commits since the last one, or such a path changed (test) · each tier has its own time limit, and exit codes 0, 1 and 3 and the secrets scan on every commit are unchanged (test) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: App-Director's tiers are the model (its `framework/tools/check.sh` at v1.16.0): port what fits this check's steps.
- Note: built 2026-11-13 as SaaSAllTheThings' T51 and reviewed twice; the first review's findings were rebuilt. Options: `--fast`, `--full` (the same as no argument), each with `--if-changed`, and `--due`, which always exits 0 and starts its line `check: full tier due:` or `check: full tier not due:`; an unknown flag exits 3. Settings under `[tests]`: `timeout-fast` (300), `timeout-full` (600; the older `timeout` counts when it isn't set), `full-every` (10; 0: never by count) and `full-when` (empty). A changed `bicepconfig.json` runs the Bicep compile too, and the full-tier paths count in the fingerprint even when they are Markdown. `CHECK_TIER` is exported in both tiers; `CHECK_CHANGED` is the path of a file that lists the changed paths, set in the fast tier only. It also changed `framework/tools/archcheck.awk` (a mode that prints each path's layer) and the example's `tools/check.cfg`, which Touches doesn't list. The selftest passed 916 of 916; its .NET part was skipped, since this machine has no .NET SDK.
- Brief: Scope › Planned framework changes
- Stories: -

### T341 · SaaSAllTheThings: the hooks and the procedures pick the check's tier · done 2026-11-14 · L · agent
- PRs: SaaSAllTheThings #51 (merged)
- Note: built 2026-11-13 as SaaSAllTheThings' T52 and reviewed twice; the first review's findings were rebuilt. The Stop hook asks for the fast tier, which T340 runs as the full tier for a dependency, a toolchain setting, a file under `tools/` or a `full-when` path, so the texts there say "the fast tier, as the full tier where the change needs it". The hooks ask the check which paths count (`--unignored`) instead of filtering Markdown themselves. `--due` reads its path rule from the changes from HEAD only, as App-Director's does: with the commits since the last full pass included, a commit that carried such a path ran the full tier and so did the next one. A change that arrives without the commit hook, such as a pull, is covered by the count and by the push. It also changed `framework/tools/check.sh` and `framework/tools/setup-clone.sh`, which Touches doesn't list; `framework/.claude/agents/builder.md` needed no change, since it points at `build.md`. A clone without the stack's toolchain can't push any more (T346 is proposed for that). The selftest passed 969 of 969; its .NET part was skipped, since this machine has no .NET SDK.
- Depends on: T340
- Touches: work/SaaSAllTheThings: framework/.githooks/pre-commit, framework/.githooks/pre-push, framework/.claude/hooks/stop-check.sh, framework/.satt/rules.md, framework/.satt/procedures/build.md, next-task.md, release.md, framework/.claude/agents/builder.md, README.md, ONBOARDING.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: the pre-commit hook runs the full tier when `--due` says so and the fast tier otherwise, says which and why, and reuses a builder's pass of the same files; the pre-push hook runs the full tier unless a full pass of the same files stands; the Stop hook runs only the fast tier (test) · `rules.md` › Done and Running the check say which tier runs where: the fast tier for a build, a commit and the turn end; the full tier when it's due, before a push, at the end of a run of several items, where a failure becomes a bug item, and for a release, which never takes a fast pass (check) · `build.md` verifies with the fast tier, `next-task.md` asks `--due` before a commit and runs a due full check in the background first, and the CHANGELOG has Upgrade steps for an app's `tools/check.cfg` and `tools/check.local.sh` (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes
- Stories: -

### T342 · SaaSAllTheThings: the TypeScript fast tier tests the changed packages and the packages that depend on them · done 2026-11-14 · M · agent
- PRs: SaaSAllTheThings #51 (merged)
- Note: built 2026-11-13 as SaaSAllTheThings' T53. A root `test:fast` script comes first and gets the selected packages' folders in `CHECK_PACKAGES` (relative to the repository root, separated by spaces, sorted); without it, each selected package's own `test` script runs in one `npm run test --workspace` call; with neither, or when a changed backend path is outside every package, the root `test` runs whole and the check says why. The check gives the stack profile `CHECK_BACKEND_CHANGED`, the changed paths that make the backend run. The selftest passed 995 of 995; its .NET part was skipped, since this machine has no .NET SDK.
- Note: timed on 2026-11-14 in a scratch clone of Project Director with a `test:fast` script that runs `node --test` over the selected packages' built tests. A change in `packages/functions` tests that package alone, 426 of the 2,403 backend tests; a change in `packages/domain` tests every package but `contracts`, 2,349 tests, since the others depend on it. The test step alone, three rounds each while other sessions' checks ran on the machine: 30, 30 and 43 seconds for the functions change and 76, 181 and 146 for the domain change, against 82, 95 and 107 for the whole test. Whole fast runs under that load took 286 seconds (functions) and 448 (domain), with the architecture step at 92 and 113 of them, so the totals say little. The timing found two faults in T53, fixed in T343's build: the profile wrote its node script to `.satt/state/select-packages.js`, which node loaded as an ES module in an app whose root `package.json` says `"type": "module"`, so the selection fell back to the whole test, and which the app's own `eslint .` then linted and failed on. The script now goes to node on stdin.
- Depends on: T340
- Touches: work/SaaSAllTheThings: framework/tools/stacks/typescript.sh, framework/tools/check.sh, framework/.satt/reference/stacks.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: in the fast tier of an app with npm workspaces, the TypeScript stack tests only the changed packages and the packages that depend on them, by the dependencies their `package.json` files declare: through each such package's own `test` script, or through a root `test:fast` script that gets their folders in `CHECK_PACKAGES`; with neither, the root `test` runs whole and the check says so (test) · typecheck, lint and build cover the whole project as before, a changed backend file outside every package runs the whole `test`, and the run names the packages it tested and the ones it left to the full tier (test) · a change in `packages/functions` and one in `packages/domain` are each timed in a scratch clone of Project Director with a `test:fast` script, and the times are in the item's note (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes
- Stories: -

### T343 · SaaSAllTheThings: the .NET fast tier tests the changed projects and the projects that reference them · done 2026-11-14 · M · agent
- PRs: SaaSAllTheThings #51 (merged)
- Note: built 2026-11-14 as SaaSAllTheThings' T54 and reviewed twice, because this machine has no .NET SDK: the selftest's real .NET part was skipped, so `dotnet` never ran against the change. The reviewer walked the selection by hand over `examples/order-desk` and got what the three cases of the real .NET part expect; about 60 cases with a stand-in `dotnet` run on every machine. The selection stays inside the target (the projects a `.sln`, `.slnx` or `.slnf` names, or a project-file target and what it references), the test step has one time budget, and every selected project runs. When the selection can't be sure, the whole `dotnet test` of the target runs and the check says why: a test SDK from a `Directory.Build.props`, a project that imports a file, a name or folder ending in `test` or `tests` without a test SDK, a reference it can't resolve, and more. `<IsTestProject>false</IsTestProject>` in a project's own file says it is no test project. The same commit fixes the two faults in T342's selection. It also changed `framework/tools/stacks/typescript.sh`, which Touches doesn't list. The selftest passed 1060 of 1060. T348 is proposed for the run with the real SDK.
- Depends on: T342
- Touches: work/SaaSAllTheThings: framework/tools/stacks/dotnet.sh, framework/tools/stacks/python.sh, framework/.satt/reference/stacks.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: in the fast tier the .NET stack builds the whole target and runs `dotnet test` only for the test projects that changed or that reference a changed project, directly or through other projects, read from their `ProjectReference` entries; a changed file outside every project runs every test project, and the run names the test projects it ran and the ones it left to the full tier (test) · the Python stack runs whole in both tiers and the check says so (test) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Brief: Scope › Planned framework changes
- Stories: -

### T344 · Release SaaSAllTheThings 0.17.0 · done 2026-11-14 · S · agent
- PRs: SaaSAllTheThings #51 (merged)
- Note: the release commit ends the bundle on 2026-11-14: the version files are at 0.17.0, the changelog section is headed 0.17.0 with its entries in the order they were built, and the release notes are the pull request's description. The selftest passed 1060 of 1060 on the release commit's files; its .NET part was skipped, since this machine has no .NET SDK. Next, once the director has merged the bundle: `bash tools/work-release.sh work/SaaSAllTheThings 51`.
- Depends on: T341, T343
- Touches: work/SaaSAllTheThings: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries T339 to T343, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -
- Stories: -

### T345 · Docs follow SaaSAllTheThings 0.17.0 · done 2026-11-14 · M · agent
- Depends on: T344
- Touches: frameworks.lock, docs/**/*.md (the SaaSAllTheThings links), docs/frameworks/saasallthethings.md, docs/concept/check.md, docs/how-to/check.md, docs/skills/next-task.md, docs/how-to/trouble.md
- Done when: `frameworks.lock` and every SaaSAllTheThings link are at v0.17.0 (check) · the pages that describe SaaSAllTheThings' check say what the release ships, checked against it: the steps side by side, the two tiers and where each runs, and selection by area and by package (check) · `bash tools/audit.sh` prints PASS and `bash tools/check.sh` passes (check)
- Brief: Scope › Framework features
- Stories: US-5, US-9, US-10, US-11

### B71 · SaaSAllTheThings: the .NET stack's build runs without the check's time limit · proposed · S · agent · low
- Touches: work/SaaSAllTheThings: framework/tools/stacks/dotnet.sh, selftest.sh, CHANGELOG.md, TASKS.md
- Repro: 1. In an app with `stack = dotnet` and `[tests] timeout = 60`, make `dotnet build` hang (a build step that waits). 2. Run `bash tools/check.sh`. Expected: the build is stopped at the limit and the check exits 3, as `dotnet test` is. Actual: `stack_check` in `tools/stacks/dotnet.sh` runs `dotnet build` without `run_limited`, so only `dotnet test` is cut, and a hung build holds the check, or its stack step when the steps run side by side, for as long as it hangs.
- Found in: T339 (the builder's report), read in the script; not reproduced, since this machine has no .NET SDK
- Brief: -
- Stories: -

### B72 · SaaSAllTheThings: an interrupted side-by-side check leaves its steps' commands running in Git Bash · proposed · S · agent · low
- Touches: work/SaaSAllTheThings: framework/tools/check.sh, selftest.sh, CHANGELOG.md, TASKS.md
- Repro: 1. In an app with `[tests] parallel = on` and a `tools/check.local.sh` that runs `sleep 300`, start `bash tools/check.sh` in Git Bash on Windows. 2. Send it `TERM` (`kill <pid>`). Expected: the step shells and the commands they started stop, as the CHANGELOG says ("An interrupted run stops its jobs"). Actual: `cleanup()` stops what a step started with `pkill -P`, and a plain Git Bash shell has no `pkill`, so only the step shells are killed, and `sleep`, or `npm` and `node` in a real app, run on until they end.
- Found in: T339 (read in the script while verifying its build; `pkill` checked on this machine, the interrupt itself not reproduced)
- Brief: -
- Stories: -

### B73 · SaaSAllTheThings: the selftest's `put` helper makes a folder out of a file name without a slash · proposed · XS · agent · low
- Touches: work/SaaSAllTheThings: selftest.sh, TASKS.md
- Repro: 1. In a case of `selftest.sh`, call `put notes.txt "x"` in a test folder. Expected: a file `notes.txt` holding `x`. Actual: `${1%/*}` is the whole name when it has no slash, so `put` runs `mkdir -p notes.txt` and the write to it fails: a folder named `notes.txt` and no file. No case calls it that way today, so nothing fails yet.
- Found in: T340 (the builder's report), read in `selftest.sh` (the `put` helper)
- Brief: -
- Stories: -

### B74 · SaaSAllTheThings: a check that waited for another one compares with the fingerprint from before the wait · proposed · S · agent · low
- Touches: work/SaaSAllTheThings: framework/tools/check.sh, selftest.sh, CHANGELOG.md, TASKS.md
- Repro: 1. Start `bash tools/check.sh` in an app. 2. While it runs, start `bash tools/check.sh --if-changed`, which waits for the lock. 3. Edit a source file in the two seconds between the first run recording its pass and the second run taking the lock. Expected: the second run checks the edited files. Actual: it took its fingerprint before the wait and asks `reuse_last` with that one, so it prints a pass for files it never saw. An edit earlier in the wait costs a run instead: the second run checks the current files, finds that its old fingerprint differs from the new one, and records no pass ("files changed while the check ran").
- Found in: T340 (its review), read in `check.sh` at v0.16.3; not reproduced
- Brief: -
- Stories: -

### B75 · SaaSAllTheThings: a file whose name git quotes is left out of the check's fingerprint · proposed · S · agent · low
- Touches: work/SaaSAllTheThings: framework/tools/check.sh, selftest.sh, CHANGELOG.md, TASKS.md
- Repro: 1. On Linux or macOS, in an app with a passing check, add a source file whose name holds a double quote or a backslash, and run `bash tools/check.sh`. 2. Change that file and run `bash tools/check.sh --if-changed`. Expected: the check runs, since a file changed. Actual: `fingerprint()` reads `git ls-files` without `-z`, git prints such a name quoted even with `core.quotePath=false`, the `[ -f ]` test fails on the quoted form, and the file is left out of the hash, so the last pass is reused. Windows allows neither character in a file name.
- Found in: T340 (its review), read in `check.sh`; not reproduced
- Brief: -
- Stories: -

### T346 · SaaSAllTheThings: a push that changes only documentation runs no check · proposed · M · agent
- Depends on: T341
- Touches: work/SaaSAllTheThings: framework/.githooks/pre-push, framework/tools/setup-clone.sh, framework/.satt/rules.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: the pre-push hook runs no check for a push whose commits change only paths the check doesn't count (Markdown outside `adr/` and outside `[tests] full-when`, asked of `bash tools/check.sh --unignored`), so a clone without the backend's toolchain can push documentation; every other push runs the full tier as before (test) · `rules.md` › Running the check and the comment in `tools/setup-clone.sh` say so (check) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T341's review. With T341 the pre-push hook runs the full tier and blocks when the check can't run, so a clone without the stack's toolchain, such as a workshop or documentation collaborator's, can't push at all. App-Director's hook has the same gate.
- Brief: -
- Stories: -

### T347 · SaaSAllTheThings: the Stop hook stops waiting for a running check at the fast tier's limit · proposed · M · agent
- Depends on: T341
- Touches: work/SaaSAllTheThings: framework/tools/check.sh, framework/.claude/hooks/stop-check.sh, framework/.satt/rules.md, selftest.sh, CHANGELOG.md, TASKS.md
- Done when: a check that waits for another one stops waiting after the seconds in `CHECK_WAIT` (or the limit of the tier it names), prints a `check: busy:` line naming the run it waited for, and exits 3 without starting a second check (test) · the Stop hook asks with `CHECK_WAIT=fast` and lets the turn end on that line (test) · the selftest passes (check) · following AGENTS.md › Project rules for framework work
- Note: found in T341's review. `rules.md` and `next-task.md` now start full runs in the background on purpose; a turn that ends while one runs, with no pass of the current files, waits for the lock for up to 30 minutes. App-Director's check and Stop hook at v1.16.0 are the model (`CHECK_WAIT`, `check: busy`).
- Brief: -
- Stories: -

### B76 · A push of main from a prototype worktree runs no check · proposed · S · agent · low
- Touches: work/SaaSAllTheThings: framework/.githooks/pre-push, selftest.sh, CHANGELOG.md, TASKS.md · work/App-Director: the same files
- Repro: 1. In an app with a failing check committed on `main`, start a prototype (`bash tools/prototype.sh start try`). 2. In the prototype's worktree, run `git push origin main`. Expected: the push is checked like a push from the main checkout, or refused there. Actual: `main` holds no prototype commits, so the refusal doesn't apply, and the hook then skips the check because the checkout is a prototype: `main` is pushed unchecked.
- Found in: T341 (its review), read in the hooks of SaaSAllTheThings and App-Director; not reproduced. The hook also checks the working tree and not the commits it pushes, which its comment says.
- Brief: -
- Stories: -

### T348 · SaaSAllTheThings: the selftest's .NET part runs against the fast tier's project selection · proposed · S · agent
- Depends on: T344
- Touches: work/SaaSAllTheThings: selftest.sh, framework/tools/stacks/dotnet.sh, CHANGELOG.md, TASKS.md
- Done when: `bash selftest.sh` in `work/SaaSAllTheThings` runs its .NET part on a machine with the .NET SDK 8 or newer and passes, the three fast-tier cases on `examples/order-desk` included: a change in the Domain project tests both test projects, and a change in the Application project tests its own and leaves the Domain's (check) · the lines `dotnet test <project> --no-build` prints come through the check as they do for the whole target (check) · what fails is fixed there, or filed as a bug item (check) · following AGENTS.md › Project rules for framework work
- Note: found while building T343. This machine has no .NET SDK and SaaSAllTheThings' repository has no CI, so nothing has run the real `dotnet` against T343: its cases use a stand-in. It needs the SDK installed here, which is the director's call, or a run on another machine.
- Brief: -
- Stories: -

### T312 · Release SaaSAllTheThings 0.16.1 · done 2026-11-04 · S · agent
- PRs: SaaSAllTheThings #48 (merged)
- Touches: work/SaaSAllTheThings: the version files, CHANGELOG.md
- Done when: the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -

### T313 · Release Godot-Director 4.10.1 · done 2026-11-04 · S · agent
- PRs: Godot-Director #54 (merged)
- Touches: work/Godot-Director: the version files, CHANGELOG.md
- Done when: the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -

### T314 · Release App-Director 1.14.1 · done 2026-11-05 · S · agent
- PRs: App-Director #50 (merged)
- Depends on: T283
- Touches: work/App-Director: the version files, CHANGELOG.md
- Done when: it ends the bundle that carries T283, the bundle is merged and `tools/work-release.sh` has tagged and published it
- Brief: -

### T315 · Docs follow App-Director 1.14.1, SaaSAllTheThings 0.16.1 and Godot-Director 4.10.1, and this repo's guard follows App-Director · done 2026-11-05 · M · agent
- Depends on: T283, T312, T313, T314, B66
- Touches: frameworks.lock, docs/**/*.md (the framework links), docs/how-to/trouble.md, .claude/hooks/guard-commands.sh, selftest.sh
- Done when: `frameworks.lock` and every framework link are at v1.14.1, v0.16.1 and v4.10.1 (check) · the guard's table in `docs/how-to/trouble.md` names a Python with nothing to run and the form that works, checked against the three releases (check) · `.claude/hooks/guard-commands.sh` is byte-identical to App-Director v1.14.1, and this repo's selftest covers a Python with nothing to run and a heredoc delimiter named `PY` (check)
- Note: built 2026-11-05: `frameworks.lock` and 96 link lines in 35 pages moved to the three tags, the guard's table in `docs/how-to/trouble.md` names a Python with nothing to run, and `docs/frameworks/index.md`'s line on the guard says so too. `.claude/hooks/guard-commands.sh` is byte-identical to App-Director v1.14.1, with 38 cases in this repo's selftest, and no existing case flipped.
- Brief: Scope › Framework features

### B66 · A bare Python with no script passes the hang check · done 2026-11-05 · M · agent · medium
- PRs: App-Director #49 (merged), SaaSAllTheThings #47 (merged), Godot-Director #53 (merged), SaaSAllTheThings #48 (merged), Godot-Director #54 (merged), App-Director #50 (merged)
- Touches: work/App-Director, work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh; work/Godot-Director: framework/.claude/hooks/guard-git.sh; each repo's selftest.sh, CHANGELOG.md; then this repo's guard
- Repro: 1. Feed each guard hook, without running it, `python3 -`, `python`, `py -3` or `python3 2>/dev/null || true`. 2. Expected: blocked: with no script, no `-c`, no `-m` and nothing piped or redirected in, Python waits for input that never comes. Actual: exit 0 in all three guards at their latest releases, on 2026-11-04.
- Note: T309 blocks a Python reading its script from a heredoc, and this form has none. It isn't theoretical: on 2026-11-04 T303's builder ran `python3 - 2>/dev/null; sed ...`, the shell hung, the tool moved it to the background, the builder reported that it had exited by itself, and the task stayed alive until this session stopped it with TaskStop by the ID in the builder's transcript; the builder's own run ended at once. `python3 - < x.py`, `cat x.py | python3 -` and `python3 --version` stay allowed.
- Note: built 2026-11-04 as App-Director's T51 and T52, SaaSAllTheThings' T46 and T47 and Godot-Director's T51, the same `py_bare` block in each guard, and resized from S to M since the three guards read text three ways. Three defects surfaced after 178 forms passed: a line continuation read as a bare Python in the as-written reading, a delimiter line named `PY` read as the launcher, and a SaaSAllTheThings glob that blanked everything between a command's first and last quote (a `sleep 999` between two strings passed there too). The first two were found by the selftests; the delimiter fix reached App-Director and SaaSAllTheThings after their first bundles merged, so it's in the next one, and nothing with the defect was released. Known limits: a Python behind a variable and a wrapper option that takes a value pass, and `;; python)` and a bare `python` line in a script's data heredoc are false blocks. This repo's guard follows with App-Director's release.
- Found in: T303
- Brief: -

### T308 · The three frameworks warn when a project is behind the latest release · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged), SaaSAllTheThings #46 (merged), Godot-Director #52 (merged)
- Touches: work/App-Director, work/SaaSAllTheThings, work/Godot-Director: a new session-start hook in framework/.claude/hooks/, framework/.claude/settings.json, PRIVACY.md, README.md, selftest.sh, CHANGELOG.md
- Done when: the check or a session-start hook warns when the installed framework is older than the latest release, so a project that has fallen behind shows up without anyone looking (test) · a warning never fails the check (test) · `PRIVACY.md` says what the lookup reads and how to turn it off, since it promises the framework sends nothing (check) · the selftests pass (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-04, to ride in the open bundles. The frameworks already block the hang, but the fix never reached the projects: a read-only probe of the installed guards on 2026-11-04 found brfservice passing a bare `python - <<'EOF'` with an empty body, and project-director blocking that but passing the incident's shape (`cat` heredocs followed by `python - <<'EOF' 2>/dev/null || true`), while the three bundles block both.
- Note: built 2026-11-04 as App-Director's T49 (571 selftest checks), SaaSAllTheThings' T44 (767) and Godot-Director's T48 (1122). `release-check.sh` is a new SessionStart hook, matcher `startup|resume`, timeout 10 seconds. It reads the public tags with `git ls-remote` at most once a day, under `timeout 5`, and an offline machine pays for one try a day. `PRIVACY.md` and the README now say so, since both promised the framework sends nothing, and `<PREFIX>_RELEASE_CHECK=0` turns it off. Real runs against GitHub took about 3 s with the lookup and about 0.5 s from the cache. Claude Code's docs don't say `systemMessage` and `additionalContext` combine in one object, and this hasn't been seen in a live session; if it isn't taken as JSON, the text still reaches Claude as stdout.
- Brief: -

### T309 · The three guards block any Python that reads its script from a heredoc · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged), SaaSAllTheThings #46 (merged), Godot-Director #52 (merged)
- Touches: work/App-Director, work/SaaSAllTheThings: framework/.claude/hooks/guard-commands.sh; work/Godot-Director: framework/.claude/hooks/guard-git.sh; each repo's selftest.sh, the rules bullet that names the empty heredoc, CHANGELOG.md
- Done when: each guard blocks `python`, `python3` and `py`, path-qualified too, reading its script from a heredoc, whatever the body, in place of the shape-by-shape empty-body check, so B64's form is blocked, with cases (test) · a bounded form isn't exempt unless a test shows `timeout` can stop it through the Windows Store alias (test) · the selftests pass (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-04, to ride in the open bundles. It enforces T305's rule that a multi-line script goes in a file first; the cost is that agents write a script to a file before running it. It closes B64, and this repo's guard follows with the App-Director upgrade.
- Note: built 2026-11-04 as App-Director's T48 (534 selftest checks), SaaSAllTheThings' T43 (726) and Godot-Director's T47 (1086). 48 forms of my own, fed to each guard as hook input, all got the right verdict. On one 25 KB PowerShell here-string, Godot-Director's guard took a median 4.96 s after the change and 5.50 s before it. Not blocked: a wrapper the guard doesn't know (`docker exec c python3 - <<E`, `ssh host python3 - <<E`), and an interpreter in a variable (`"$PY" - <<E`). Blocked though harmless: `python3 --version <<E`; a multi-line `-m` message with a later line that starts with the form. The three guards implement it differently. No test shows whether `timeout` can stop this form through the Windows Store alias, so a bounded form isn't exempt.
- Brief: -

### T310 · The three frameworks report orphaned processes at session start · done 2026-11-04 · M · agent
- PRs: App-Director #48 (merged), SaaSAllTheThings #46 (merged), Godot-Director #52 (merged)
- Touches: work/App-Director, work/SaaSAllTheThings, work/Godot-Director: a session-start hook in framework/.claude/hooks/, framework/.claude/settings.json, selftest.sh, CHANGELOG.md
- Done when: a session-start hook lists long-running processes whose parent shell is gone (test) · it stops nothing, and leaves stopping them to the human (test) · the selftests pass (check) · following AGENTS.md › Project rules for framework work
- Note: asked for by the director on 2026-11-04, to ride in the open bundles. T305 to T307 clean up only what a running session knows about; a process from an ended session ran over two days unnoticed.
- Note: built 2026-11-04 as App-Director's T50 (628 selftest checks), SaaSAllTheThings' T45 (804) and Godot-Director's T49 (1179). `orphan-report.sh` is a read-only SessionStart hook: stub `kill` and `taskkill` were never called, and a run writes no file. A real run on 2026-11-04 listed nine leftovers, each confirmed from its command line: `http.server` from this session's scratchpad, unbounded `until grep` loops from brfservice, `npx` and `npm` dev-server wrappers, a Guild-Manager test server and a project-director `func start`. It took 2 to 4 s warm; PowerShell's cold start took 13 to 15 s on the loaded machine, past `timeout 8`, and that session then reports nothing. Godot-Director's first two runs failed one check, the guard's 5-second limit, under load; T309's timing above shows that wasn't the change, and the third run passed.
- Brief: -

### T311 · Godot-Director: autoplay and the layout lint reach controls drawn in a SubViewport · done 2026-11-04 · M · agent
- PRs: Godot-Director #52 (merged)
- Touches: work/Godot-Director: framework/tools/ui_lint.gd, framework/tools/autoplay.gd, framework/tools/autoplay_adapter_base.gd, framework/.godot-director/procedures/autoplay.md, selftest.sh, CHANGELOG.md
- Done when: a game can give a SubViewport a provider that maps its controls to screen positions, and `UiLint` then lists those controls as elements at their screen rects, so `_press()` clicks them as any other `ui` action, with the same disabled and reached checks (test) · a SubViewport with no provider is skipped as it is today, so a game with flat UI sees no change (test) · UI in a 2D SubViewportContainer can be covered by the same provider, and a SubViewportContainer with none stays skipped, so no upgrade brings a game new lint findings (test) · `autoplay.md` says how a game adds a provider (check) · the selftest passes with the Godot path (check) · following AGENTS.md › Project rules for framework work
- Note: Guild Manager's B138, filed here by the director on 2026-11-04, to ride in #52. `UiLint._walk` skips SubViewports (ui_lint.gd:136) and `_press()` only clicks a lint element (autoplay.gd:814), so a game's in-world UI (a letter on a desk, a terminal, a book) can't be a `ui` action, and Guild Manager's letter actions post their own clicks. The Done when follows the option Guild Manager recommended, a provider on the SubViewport. Its other options were a `ui` action carrying a screen position (`at: Vector2`), or leaving it. Once this ships, Guild Manager's adapter turning those actions into `ui` actions is that project's own item.
- Note: built 2026-11-04 as Godot-Director's T50, 1199 selftest checks passing with Godot 4.7.2. The provider is a meta on the SubViewport, `godot_director_screen_rect`: a Callable from a Rect2 in its own canvas to the Rect2 on screen, empty while the page isn't shown. A meta rather than a method, since Guild Manager's SubViewports are plain scene nodes with no script. The lint's overlap, off-screen and focus rules keep reading a control in its own canvas, so only the element's rect and the click use the provider; the reached check is unchanged, and a click the game doesn't forward fails it honestly. A real SubViewport fixture runs through both the lint and autoplay; a tilted 3D plane was tried by hand only. Guild Manager still has to set the meta, name its page controls and turn its letter actions into `ui` actions, which is that project's own item after it upgrades.
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
