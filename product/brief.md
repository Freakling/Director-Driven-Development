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
- **Start here:** "Where do I start?" is a practical step-by-step for building a project with a framework: install, onboarding and what it asks, the first task. App-Director is the first framework in the How-to section, since it applies most widely: "Where do I start?" is the app walkthrough at the section's stable address, and the game and SaaS walkthroughs follow it in the nav and the overview. Where a page needs one framework as its example, it uses App-Director unless the skill is only in another. "I already have a project. Can I use this?" covers existing projects.
- **Day to day:** getting things built (`/next-task`), deciding what gets built or changing how something works (`/design`), facts before a decision (`/research`), UI changes (three ways: by describing them, with `/ui-design` and drawings, or by editing in Godot or your editor yourself and telling the agent, so the screen spec follows and the check still runs on commit), checking what was built (the acceptance check, `/function-check`, `/playtest`, `/autoplay`, `/feedback`), whether it is secure (`/security`, App-Director and SaaSAllTheThings), shipping (`/release`, `/export`), and "I want to change something. Which file is it in?": a row per thing a director may want to change (what the product is, why a decision was made, what gets built next, the rules the agent follows, what the check enforces, a screen's layout, their own assets, what the agent may do without asking), with the file per framework and whether to edit it or ask, from each framework's "Each fact lives in one place" table.
- **When things go wrong:** "Something isn't there, or doesn't work" (the troubleshooting page: make sure you're on the latest release, with the upgrade commands and the restart for each framework, then the common causes), "The system was not built as I intended" (the drift reset step by step, with a worked example from a framework's example project, and when `/align` is enough), the records and the code disagreeing (`/align`), a long task list (`/prune`), and cost (model sizing, `/refresh-model-sizing`, cost tuning).
- Guides describe only what is released and name the frameworks that ship each path. Skill, framework and concept pages link the question that answers them. How this repository's director reviews and merges the framework pull requests is internal and lives on the framework workflow page, not on the site.

### Concepts
Each core concept of DDD gets its own page in a Concepts section, explained once and framework-neutral: Overview, Roles, Design calls, Agent development flow, The check, Reviews, Task and model sizing, Records in files, Code shaped for agents, Ownership, Align and drift reset, Built-in cost savings, and Cost tuning for developers. Concept pages explain the idea; skill pages cover the commands and link to their concept.

### Common skills
Every skill that all three frameworks ship gets its own page, to keep each one readable: `/next-task`, `/design`, `/research`, `/align`, `/drift-reset`, `/prune`, `/refresh-model-sizing`, `/release` and `/ui-design`. Each page describes what the skill does and how it works in all three, then has a section that lists what is unique to each repo. Skills only one framework ships stay on that framework's page.
- **Acceptance check:** one shared page covers `/acceptance` (App-Director, SaaSAllTheThings) and its Godot-Director counterpart `/function-check`, since they are the same concept under two names. `/playtest` and `/feedback` are listed as unique per repo. (confirmed by director: T21 2026-10-11)
- **Security:** `/security` (App-Director, SaaSAllTheThings) has its own skill page, like the acceptance check, with a section for what is unique to each; the page says Godot-Director doesn't ship it. (director's call: T201, T202 2026-10-25)
- **Release:** `/release` has its own skill page, with the shared behaviour and a section for what is unique to each repo. The framework pages keep a short row that links to it.

### Examples
An Examples section after Frameworks shows Director-Driven Development in use, one example per framework, as the proof of concept of the whole project. The overview has a card per example: PKSEI for Godot-Director (the game, its repository and its devlog), this site for App-Director (the repository is a public example of the framework in use and a running test that it works), and the Azure SaaS worked example on the blog for SaaSAllTheThings. The home page's Built with section names all three and links the overview and the internal page on how this repository develops the three frameworks. Each framework page and the matching Start here walkthrough link their example.
- **An example page** is documentation, not promotion: what was built and where to play or see it, the loop as it ran (Decide, Build, Prove, Commit), what the check and the reviews caught, the numbers as the example's own devlog states them with the devlog as the source, the recipe in short, and the records as the diary: the design document, the decision log, the task list and `AGENTS.md`, linked in the example's repository. The page embeds itch.io's widget for a game on itch.io, so the cover and the play button stay itch's.
- **PKSEI** (*Paddla Kanot Som En Idiot*, Freakling/PKSEI, freakling.itch.io/pksei) is the first example page: a rage game built with Godot-Director in two days, 77 items and 6 bugs, 89 decision lines, 285 tests, about twenty itch.io builds, art and sound generated by scripts, played and fixed on a real phone, and the framework upgraded mid-project as one commit with its follow-ups as items.

### Identity
The mark is the Signal: one small filled D nested inside two outlined D's that share a spine, in the amber accent on the dark background. It stands for the director's call going out to the agents. The header logo and the favicon use the same mark.

### Licence
The site uses the same licence as the three frameworks: MIT, with the copyright notice "© 2026 Vikingur Saemundsson".

### Blog posts stay on the blog
Posts about the why, such as the anchoring post and the factories post, get no docs pages. Docs pages link to a post where it explains the why behind them.

### What the site claims for production and compliance
The site describes SaaSAllTheThings' production and compliance value only as its records show it: the check fails the build when architecture and security requirements are broken, with exceptions only through a decision record the director accepts; the requirements and the customer's control framework live in the repository, and every architecture session reads them; every decision and change leaves a record a reviewer can read; and the running system, not the repository, provides the operating evidence. "Production-ready", "compliant", "more secure than others", "a full supply-chain view" and "cannot exfiltrate" stay off the site; a pilot deployment, and then an audit, is the route to anything stronger.

### Orchestrator for the three frameworks
The repository is the orchestrator for the three frameworks:
- **Anchors:** `product/anchors/` holds the agreed behaviour of a shared feature before it's built in the frameworks. Once released, its skill page records the behaviour and the differences per repo.
- **Framework work is done here.** This repository builds the framework repos' items with App Director, in gitignored clones of the three repos under `work/`. In a clone, the work follows that repo's own developer notes (`CLAUDE.md`) and passes its `selftest.sh`. Every change reaches a framework repo as a pull request that the director merges; the agent never merges.
  - **One pull request per framework repo.** Each repo has at most one open bundle pull request, and every item built for it goes on that bundle as its own commit, so no item waits for another's merge. A framework item waits in this repo's `TASKS.md` until it's built, then reaches the framework's root `TASKS.md` together with its change, so the root queue records what was done there. `project/TASKS.md` is the adopters' template and never receives these items.
  - **The pull request is the gate.** A framework item commits and pushes without pausing for approval, even as a single task; the director's review and merge on GitHub is the only gate.
  - **Done means merged.** A framework item stays in progress, with its pull requests listed, until all of them are merged. `/next-task` checks the pull requests before it picks. An open bundle blocks nothing: an item that depends on an item in it is built on the same branch after it, and the next repo's work goes on that repo's own bundle.
- **An internal page explains it.** A page in the repository, outside the Pages site, describes how framework work runs here, with a flowchart and a sequence diagram.
- This repository acts as the auditor: it checks that the three repos stay aligned with the anchors.
- It is recursive: App-Director builds this repository, and this repository aligns App-Director along with the other two. The home page says so.

### Framework features
What the three frameworks do as decided here, carried out through the orchestrator and released in their repos. The docs describe a feature only once it is released.
- **Released means a tagged GitHub release.** Every install path (the skill, the fetch scripts, and the plugin where its marketplace can pin a ref) gets the framework's latest release tag; `main` is where changes are integrated. Each release is tagged `v<version>`. The docs follow releases: the selftest checks them against each framework's latest release tag, not `main`.
  - **The release rides in the bundle.** Once a run has built what it can for a repo, the bundle ends with a release commit that follows that repo's `CLAUDE.md`: the version bump, the CHANGELOG heading and the release notes, which become the pull request's description. One merge takes the items and their release; the agent then tags `v<version>` and publishes the GitHub release, and the docs items waiting on that release become ready. The director decides every release.
- **One commit model in all three.** One task, one commit, with the pre-commit check as the gate. A single `/next-task` pauses for the director's approval of its commit. When the director asks for a run ("grab tasks until you're blocked", "work through the queue", "the next N tasks"), each task commits without pausing, and the run stops only when an item is blocked on the director, a build fails, or the director declines a commit. `git commit` is allowed in each framework's settings; pushing, deploying and changing cloud resources keep asking every time.
- **App-Director and SaaSAllTheThings assess against OWASP.** The OWASP Top 10 (2025) is a framework-owned baseline in both, deviated from only by a named, accepted decision, and `/security` assesses what is built against it. SaaSAllTheThings also asks the compliance-framework questions when the brief's section 10 is blank or vague.
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
- **A human-written starting document in all three.** Each framework ships a template the human fills in themselves, in their own words: how the app or game should work and what it's for. It works for new and existing projects. Onboarding presents it as an alternative or an addition to the chat interview, and tells the director that a written document adds value and context and sets the stage for later development; the agent scans it to build the initial assessment and the design records, marking what it inferred. The template is in every project. The director's own templates are the source (`product/anchors/templates/`): the product brief for App-Director, the GDD for Godot-Director, and for SaaSAllTheThings a variant of the product brief that also asks about enterprise architecture, requirements, security requirements and the control frameworks the customer must meet. Low priority.
- **All three have `/ui-design`.** The director designs screens by drawing annotated boxes over screenshots of the running app or game in Excalidraw, saved in `director/ui/`. The agent captures the screens, reads the drawing precisely through a reader (`drawing.json`, never the raw file), records the layout once per screen in a screen spec, files items, builds them, and verifies the result against the drawing. A layout lint catches squeezed, clipped, overlapping and unreachable controls.
  - **One core, a capture adapter each:** the drawing conventions, `drawing.json`, the screen spec, the capture, process and verify workflow, and its hooks into the build, review, acceptance check and align are the same in all three (the anchor, adapted from the director's spec for Godot-Director). Each framework adds its capture and lint adapter: the Godot engine in Godot-Director; Playwright (Chromium, with the element map from the DOM and the accessibility tree) for web apps in App-Director and SaaSAllTheThings. Native Flutter, mobile and desktop apps, and SaaSAllTheThings' native Windows and mobile clients, get capture later.
  - **The web adapter:** capture runs Node and Playwright against the app on this machine only (never a deployed site), with a catalog of routes and states seeded through public APIs, never real user data. The web lint runs in capture, verify and the build's Screens step, not in the check, since it needs a browser and a running app. Screen specs and captures live in `product/ui/`. SaaSAllTheThings has the protected `director/` space, so drawings live in `director/ui/` in all three. SaaSAllTheThings can also capture its dev environment, named explicitly in its capture config, with seeded test tenants and saved test sign-ins only; production and every other hosted address stay refused.
  - **Settled from the spec:** the skill is `/ui-design`; captures stay gitignored; Godot-Director's layout lint in the check is on for new projects and off on upgrade; a UI item's `(check)` outcome may stay unverified when capture can't run on the machine, said plainly in the report.
- **Godot-Director plays its own games.** Every game built with Godot-Director plays itself, logs everything it does, takes screenshots while it plays, and has its logs and screenshots reviewed by the assistant, so an AI playtests a change before a human does (the director's spec, `init/godot-director-autoplaytest-prompt.md`, from The Guildkeeper's hand-built pieces).
  - **A play log in every game:** a framework-owned base the project's autoload extends, writing one human-readable file per run and a machine-readable JSONL twin with stable event ids: a session header, a state snapshot at each point the player may act, every action and outcome, why progress is blocked, engine errors, scrubbed of personal data, written nowhere under the check.
  - **Autoplay:** `/autoplay` runs the real game through a project-owned adapter (the legal actions, perform, state, the block reason), by real input for UI actions and API calls for speed, from scripted and strategy scenarios with a required smoke scenario; screenshots and element maps at every view change, snapshot and failure; framework invariants (errors, softlocks, no actions, a freed view, no focus, orphan growth, hitches) plus project ones; a replayable repro on every failure; deterministic from a seed.
  - **Where a view's focus lives:** the adapter's `focus_roots()` names the nodes under which the current view's focusable controls and focus owner live (the view node by default; a HUD layer or a `ui_root` the shell hands each view; a `SubViewport` page whose focus counts beside the window's), so the no-focus invariant holds for shells that keep a view's UI outside the view node; an empty list opts a mouse-only screen out. A weight of 0 in a scenario means never pick that action (the director's analysis from The Guildkeeper, `init/godot-director-focus-root-prompt.md`).
  - **Log review:** a GDScript tool writes a timeline, findings grouped by stable signatures, coverage against the catalog and the controls, and a delta against the last run; "check the logs" reviews the newest human-played log the same way.
  - **The workflow uses it:** an `(autoplay)` outcome tag, the builder plays the scenarios its item names side by side in one call, plus smoke unless the check already plays it, the reviewer checks logging coverage and drivability, the function check pre-verifies what a machine can judge, the playtest attaches a review, align lists logging and scenario gaps, and the check can run smoke headless.
  - **Rules:** everything is logged, every action is drivable, agent-visible state goes in a dev menu inspector and the snapshot (replacing the Remote-tree advice), seeded randomness, privacy unchanged.
  - **A dev menu base ships too,** and onboarding asks whether the director wants a dev menu in the game and how to enable it: a setting, in game, or a command-line flag at start.
  - **Godot-Director only,** released as one feature built in stages; the minimum Godot is 4.5, for the engine Logger.
- **Godot-Director's check is fast on a large game.** It times every test file and ends with a slowest-files summary, runs the tests in parallel Godot processes (`[tests] jobs`, `--jobs`), skips the import pass when nothing it depends on changed, and limits each run with `[tests] timeout`. Balanced jobs and splitting a slow test file by test method are opt-in (`[tests] balance`, `split_over`), since on The Guildkeeper heavy files competed for the CPU and the new order exposed tests that depend on run order. The full check stays what Done means: a scoped per-item check comes back only if a measured full run exceeds about three minutes again (The Guildkeeper's runs in about 90 seconds).
- **SaaSAllTheThings closes the largest gaps between its records and the operating envelope.** A check rule (`network-public`) fails Bicep that leaves public network access or local authentication on, with private-only through an ADR and a `cost-sku` exception; a CI workflow template keeps the check's output as an artifact, reviews dependency changes and exports an SBOM; and a compliance mapping table traces each control to the rule, ADR or test that meets it, with an honest label and where the evidence is.
- **The Bash guard blocks the commands that hang a session, in all three.** An empty Python heredoc, a sleep loop or long sleep without a time limit under five minutes, and in Godot-Director a direct Godot run without one, each with the form that works; the app frameworks' checks limit their test runs too. A wait past five minutes lets the prompt cache expire.
- **An install from a non-release source says so.** Each framework's installer records the source commit in the project's manifest and, when the source's CHANGELOG has an Unreleased section with entries, marks the installed version as unreleased (`<version> + unreleased (<commit>)`) and says so at the end of the install, so a project's records can tell a release from a development snapshot (PKSEI installed a snapshot that reported itself as the last release).

### Planned framework changes
Changes the director has decided that aren't released yet.

- **A pilot of SaaSAllTheThings in Azure:** the director deploys the example app to an Azure sandbox with Azure Policy Deny assignments and Defender for Cloud, tests it from outside and records the results.

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
| How-to (18 pages) | An overview and one page per question, in three groups (Start here, Day to day, When things go wrong): the short answer, the ways to do it, the steps, the caveats |
| Skills (12 pages) | An overview, and one page per common skill, `/security` and the acceptance check: what it does, how it works, and what is unique to each repo |
| Frameworks (4 pages) | Comparison page, and one page per framework: check, install, commands, links |
| Examples (2 pages) | An overview with a card per framework's example, and one page per example: the loop as it ran, what the check caught, the numbers from its devlog, the recipe, the records as the diary |

## Open Questions

<!-- Undecided design questions. Format: Q<n>: question. The AI never answers these itself.
     Work that depends on one gets a PLACEHOLDER. Delete a question when it's decided. -->

Q3: Should the site use a custom domain (for example under saemundsson.se) instead of freakling.github.io? (later)

<!-- Next Q: 14 -->
