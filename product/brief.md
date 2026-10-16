# Product brief: Director-Driven Development docs

<!-- What the app should be. The AI reads only the sections it needs; reference them by heading.
     The AI never answers an Open Question itself; work that depends on one gets a placeholder. -->

## Pitch

The how-to reference for Director-Driven Development, centred on the three frameworks: what the method is, how the loop and its roles work, how to keep token costs down, and how to install and use Godot-Director, App-Director and SaaSAllTheThings. The blog at saemundsson.se explains why, and every page points to the post behind it; this site explains how. Each framework's repository stays the source of truth for its procedures.

**Who it's for:** anyone who wants to use AI coding agents to build software and stay in control of what gets built. The site is aimed at hands-on builders as the most likely first audience, but the framework is not limited to developers or tech leads.

**What a visit should lead to:** the reader installs one of the frameworks, or applies the roles, the loop and the check in their own setup.

**The feeling it should give:** calm, technical and trustworthy: a short, accurate reference in the same dark, one-accent look as the blog figures and LinkedIn cards.

## Scope

### Now: framework docs
The site is technical documentation and project orchestration. Promotional content, such as the LinkedIn material and graphics in `init/`, doesn't belong on it; pages link to the blog for the why.

### How-to guides
A How-to section after Concepts and Skills, written for a director who has never used a framework. It is a FAQ: every page is a question the director asks, in the order the questions come up, grouped as Start here, Day to day, and When things go wrong. Pages are named by what the person wants to do, never by a command, and keep a short stable address.
- **Each page:** the short answer first; then, where the frameworks offer both, the two ways to do it: by talking (what to say in plain words and what happens) and with the skill (when the stricter path pays off: records, repeatability); then the steps, with what the agent asks at each one; then what can go wrong; then the skill, concept and procedure pages it ties into.
- **Start here:** "Where do I start?" is a practical step-by-step for building a project with a framework: install, onboarding and what it asks, the first task. Godot-Director's version comes first, since it ships `/ui-design`; App-Director's and SaaSAllTheThings' follow. "I already have a project. Can I use this?" covers existing projects.
- **Day to day:** getting things built (`/next-task`), deciding what gets built or changing how something works (`/design`), facts before a decision (`/research`), UI changes (by describing them, or with `/ui-design` and drawings), checking what was built (the acceptance check, `/function-check`, `/playtest`), and shipping (`/release`, `/export`).
- **When things go wrong:** "Something isn't there, or doesn't work" (the troubleshooting page: make sure you're on the latest release, with the upgrade commands and the restart for each framework, then the common causes), "The system was not built as I intended" (the drift reset step by step, with a worked example from a framework's example project, and when `/align` is enough), the records and the code disagreeing (`/align`), a long task list (`/prune`), and cost (model sizing, `/refresh-model-sizing`, cost tuning).
- Guides describe only what is released and name the frameworks that ship each path. Skill, framework and concept pages link the question that answers them. How this repository's director reviews and merges the framework pull requests is internal and lives on the framework workflow page, not on the site.

### Later: playbook
A "Start here" playbook that guides technical users through installing and running a framework.

### Concepts
Each core concept of DDD gets its own page in a Concepts section, explained once and framework-neutral: Overview, Roles, Design calls, Agent development flow, The check, Reviews, Task and model sizing, Records in files, Code shaped for agents, Ownership, Align and drift reset, Built-in cost savings, and Cost tuning for developers. Concept pages explain the idea; skill pages cover the commands and link to their concept.

### Common skills
Every skill that all three frameworks ship gets its own page, to keep each one readable: `/next-task`, `/design`, `/research`, `/align`, `/drift-reset`, `/prune`, `/refresh-model-sizing` and `/release`. Each page describes what the skill does and how it works in all three, then has a section that lists what is unique to each repo. Skills only one framework ships stay on that framework's page.
- **Acceptance check:** one shared page covers `/acceptance` (App-Director, SaaSAllTheThings) and its Godot-Director counterpart `/function-check`, since they are the same concept under two names. `/playtest` and `/feedback` are listed as unique per repo. (confirmed by director: T21 2026-10-11)
- **Release:** `/release` has its own skill page, with the shared behaviour and a section for what is unique to each repo. The framework pages keep a short row that links to it.

### Built with App-Director
The site and its repository are built with App-Director: tasks in `TASKS.md`, design in `product/`, and one check before every commit. The home page and the README say so, which makes the repo a public example of the framework in use and a running test that it works. The home page's Built with App-Director section also links to the internal page on how this repository develops the three frameworks.

### Identity
The mark is the Signal: one small filled D nested inside two outlined D's that share a spine, in the amber accent on the dark background. It stands for the director's call going out to the agents. The header logo and the favicon use the same mark.

### Licence
The site uses the same licence as the three frameworks: MIT, with the copyright notice "© 2026 Vikingur Saemundsson".

### Blog posts stay on the blog
Posts about the why, such as the anchoring post and the factories post, get no docs pages. Docs pages link to a post where it explains the why behind them.

### Orchestrator for the three frameworks
The repository is the orchestrator for the three frameworks:
- **Anchors:** `product/anchors/` holds the agreed behaviour of a shared feature before it's built in the frameworks. Once released, its skill page records the behaviour and the differences per repo.
- **Framework work is done here.** This repository builds the framework repos' items with App Director, in gitignored clones of the three repos under `work/`. In a clone, the work follows that repo's own developer notes (`CLAUDE.md`) and passes its `selftest.sh`. Every change reaches a framework repo as a pull request that the director merges; the agent never merges.
  - **One pull request per item.** A framework item waits in this repo's `TASKS.md` until it's built, then reaches the framework's root `TASKS.md` together with its change, so the root queue records what was done there. `project/TASKS.md` is the adopters' template and never receives these items.
  - **The pull request is the gate.** A framework item commits and pushes without pausing for approval, even as a single task; the director's review and merge on GitHub is the only gate.
  - **Done means merged.** A framework item stays in progress, with its pull requests listed, until all of them are merged. Their status on GitHub is a blocker like any other: an item that depends on it waits, and `/next-task` checks the pull requests before it picks. An open pull request blocks only the items that depend on its item and the items that touch the same files; other work carries on, in the same repo too. The records every item adds (the framework's root `TASKS.md` and `CHANGELOG.md`) don't count as the same files: after a merge, the agent merges `main` into that repo's other open item branches and resolves the record conflicts, never force-pushing.
- **An internal page explains it.** A page in the repository, outside the Pages site, describes how framework work runs here, with a flowchart and a sequence diagram.
- This repository acts as the auditor: it checks that the three repos stay aligned with the anchors.
- It is recursive: App-Director builds this repository, and this repository aligns App-Director along with the other two. The home page says so.


### Framework features
What the three frameworks do as decided here, carried out through the orchestrator and released in their repos. The docs describe a feature only once it is released.
- **Released means a tagged GitHub release.** Every install path (the skill, the fetch scripts, and the plugin where its marketplace can pin a ref) gets the framework's latest release tag; `main` is where changes are integrated. Each release is tagged `v<version>`. The docs follow releases: the selftest checks them against each framework's latest release tag, not `main`.
  - **A release when a change is complete.** When an item is done (all its pull requests merged), the next `/next-task` proposes a release of each framework repo it touched, covering everything merged there since that repo's last release. The proposal is a release pull request that follows that repo's `CLAUDE.md`: the version bump, the CHANGELOG heading and the release notes. Once the director merges it, the agent tags `v<version>` and publishes the GitHub release, and the docs items waiting on that release become ready. The director decides every release.
- **One commit model in all three.** One task, one commit, with the pre-commit check as the gate. A single `/next-task` pauses for the director's approval of its commit. When the director asks for a run ("grab tasks until you're blocked", "work through the queue", "the next N tasks"), each task commits without pausing, and the run stops only when an item is blocked on the director, a build fails, or the director declines a commit. `git commit` is allowed in each framework's settings; pushing, deploying and changing cloud resources keep asking every time.
- **All three have a research assistant.** When a design question is complex, or the director asks for research, a read-only `researcher` subagent researches the topic in a fresh context and reports back. It informs; the director decides: its options and recommendation feed a design call, and it never records a decision, edits the design documents or accepts an ADR.
  - **Research is a task type.** Research items get their own IDs, `R<n>`, like bugs. Instead of `Done when` they have `Question:` and, when they inform an open question, `Informs: Q<n>`. They are sized like any task, and the size picks the model. An item is done when its research note exists.
  - **Two ways to start:** on the fly, when the designer delegates or the director runs `/research`, the item is created and run at once; for later, the item is queued, and the tasks that depend on its outcome list it under `Depends on`. `/next-task` hands research items to the researcher instead of the builder. A finished item that informs a question makes that question ready for a design call; tasks that need the decision stay gated by the question.
  - **Research notes:** each item writes a dated note per topic in the project: the conclusion, the options, the sources with confidence, and the date the claims were verified. The decision log line links to it, so later sessions reuse it.
  - **One core, a domain file each:** the research procedure is the same in all three (the anchor, adapted from the director's portable research skill); each framework adds one reference file for its domain: Azure and the customer's security framework in SaaSAllTheThings; stacks, libraries and app-store requirements in App-Director; the Godot docs and engine version, asset licences and store requirements in Godot-Director.
  - **Evidence rules:** claims rest on sources actually read, primary sources first, with confidence labels and a verified-as-of date. The project's records supply the context. Confidential project text never goes to public search.
- **Godot-Director exports and releases games, in two parts:**
  1. **Onboarding and `/export`.** Onboarding guides the director through the export settings Godot doesn't already have, such as the target platforms, and asks where exports should run: on the director's machine, in a build container (local or in a cloud), or on a hosted service such as GitHub Actions, with guidance to set it up. The director can skip this step. Skipping adds an open question to the GDD (which platforms to export to, and where exports run) and an item to set up exports that depends on it. The director runs the step later with `/design Q<n>`, and `/next-task` builds the setup; changing it later is a design session too. The skill is `/export`, following Godot's own term for producing a game's binaries.
  2. **CI and CD.** CI runs the Godot export on every change; CD releases builds to a platform's UAT branch and, if the director wants, promotes them to production.
     - **Targets:** the director supplies an upload command per export preset, one for the UAT branch or channel and one for production; Godot-Director builds in no store knowledge.
     - **CI:** a GitHub Actions workflow ships with the framework, while `/export` and `/release` stay plain commands any CI service can run.
     - **Promotion:** `/release` promotes to production only when the director asks and the check passes; the shipped workflow also has an optional protected production job the director approves on GitHub.
     - **Credentials:** platform credentials live only in CI secrets. Onboarding lists the names to set; they never enter the repo, `export_presets.cfg` or the chat.

### Planned framework changes
Changes the director has decided that aren't released in all three frameworks yet.
- **A human-written starting document in all three.** Each framework ships a template the human fills in themselves, in their own words: how the app or game should work and what it's for. It works for new and existing projects. Onboarding presents it as an alternative or an addition to the chat interview, and tells the director that a written document adds value and context and sets the stage for later development; the agent scans it to build the initial assessment and the design records, marking what it inferred. The template is in every project. The director's own templates are the source (`product/anchors/templates/`): the product brief for App-Director, the GDD for Godot-Director, and for SaaSAllTheThings a variant of the product brief that also asks about enterprise architecture, requirements, security requirements and the control frameworks the customer must meet. Low priority.
- **All three get `/ui-design`.** The director designs screens by drawing annotated boxes over screenshots of the running app or game in Excalidraw, saved in `director/ui/`. The agent captures the screens, reads the drawing precisely through a reader (`drawing.json`, never the raw file), records the layout once per screen in a screen spec, files items, builds them, and verifies the result against the drawing. A layout lint catches squeezed, clipped, overlapping and unreachable controls.
  - **One core, a capture adapter each:** the drawing conventions, `drawing.json`, the screen spec, the capture, process and verify workflow, and its hooks into the build, review, acceptance check and align are the same in all three (the anchor, adapted from the director's spec for Godot-Director). Each framework adds its capture and lint adapter: the Godot engine in Godot-Director; Playwright (Chromium, with the element map from the DOM and the accessibility tree) for web apps in App-Director and SaaSAllTheThings. Native Flutter and desktop apps get capture later.
  - **Godot-Director first:** it pilots the feature. App-Director and SaaSAllTheThings are built from the anchor meanwhile, on local branches with no pull request until the director's UAT of the Godot version is done; the UAT's feedback updates the anchor and those branches first.
  - **The web adapter:** capture runs Node and Playwright against the app on this machine only (never a deployed site), with a catalog of routes and states seeded through public APIs, never real user data. The web lint runs in capture, verify and the build's Screens step, not in the check, since it needs a browser and a running app. Screen specs and captures live in `product/ui/`. SaaSAllTheThings gains the protected `director/` space, so drawings live in `director/ui/` in all three. SaaSAllTheThings may also capture its dev environment, named explicitly in its capture config, with seeded test tenants and saved test sign-ins only; production and every other hosted address stay refused.
  - **Settled from the spec:** the skill is `/ui-design`; captures stay gitignored; the layout lint in the check is on for new projects and off on upgrade; a UI item's `(check)` outcome may stay unverified when capture can't run on the machine, said plainly in the report.

## Core Flows

### Grasp DDD in one screen
A reader lands on the home page and comes away knowing the five roles, the four steps of the loop and the three frameworks, with a link to read more on each.

### Learn the concept
A reader works through the Concepts section, one concept per page, and can explain how a task goes from decision to commit, and when a review or a reset happens.

### Pick and install a framework
A reader compares the frameworks, opens the one that fits, and installs it with one of the listed install paths, knowing what its check enforces and which commands it ships.

### Cut token cost
A reader understands where tokens go, which savings the frameworks build in, and applies the tuning steps to their own sessions.

### Look up a skill
A reader opens the page for a shared skill and learns what it does in every framework, and what differs in the one they use.

### Follow a link from the blog
A reader arrives from a saemundsson.se post on the matching docs page, and can get back to the post that explains the why.

## Screens

| Screen | Purpose |
|---|---|
| Home | DDD in one screen: roles, loop, frameworks, links to the posts |
| Concepts (13 pages) | One page per core concept, from the overview to the two cost pages |
| How-to (13 pages) | An overview and one page per question, in three groups (Start here, Day to day, When things go wrong): the short answer, the ways to do it, the steps, the caveats |
| Skills (10 pages) | An overview, and one page per common skill and the acceptance check: what it does, how it works, and what is unique to each repo |
| Frameworks (4 pages) | Comparison page, and one page per framework: check, install, commands, links |

## Open Questions

<!-- Undecided design questions. Format: Q<n>: question. The AI never answers these itself.
     Work that depends on one gets a PLACEHOLDER. Delete a question when it's decided. -->

Q3: Should the site use a custom domain (for example under saemundsson.se) instead of freakling.github.io? (later)

<!-- Next Q: 14 -->
