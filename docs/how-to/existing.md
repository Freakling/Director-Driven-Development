# I already have a project. Can I use this?

<div class="kicker">Yes: onboarding reads what you have instead of interviewing you from scratch</div>

> Yes. Install the framework into the project you have. Onboarding reads it, fills in the records from what it finds, marks every guess for you to confirm, and ends with one commit for you to approve. Your own files are kept.

Pick the section for what you have: [an app](#an-existing-app-app-director) (App-Director), [a game](#an-existing-game-godot-director) (Godot-Director), or [a SaaS or proof of concept](#an-existing-saas-or-proof-of-concept-saasallthethings) (SaaSAllTheThings, which starts with an assessment). Starting from an idea instead? See [Where do I start with an app?](start.md), [with a game?](start-game.md) or [with a SaaS?](start-saas.md)

## An existing app (App-Director)

A web, mobile or desktop app that already has code, for [App-Director](../frameworks/app-director.md). Install App-Director into the app you have. Onboarding reads the code, writes the product brief and the architecture table from what it finds, marks every guess for you to confirm, and ends with one commit for you to approve.

### Short answer

- **Install it the way you would into a new app.** The paths and the commands are in the [install section](../frameworks/app-director.md#install), and [Where do I start with an app?](start.md#install-the-framework) compares them.
- **Onboarding detects the mode.** Source code and config files without App-Director mean an existing app. You confirm what it found.
- **It reads, it does not interview.** The agent scans the code, fills in the records from what is there, and asks you only about what the code cannot tell.
- **It overwrites nothing of yours.** A file you already have is kept and brought into the framework's shape; your content stays.
- **A failing check is information.** Existing apps often fail the check at first. The failures become the first items in your queue.

### What to have ready

- git, bash (Git Bash on Windows), gitleaks 8.18.0 or newer except 8.19.0, and the tools of your stack, as for a new app. The full list is in [Where do I start with an app?](start.md#what-to-have-installed).
- **A clean git tree.** Commit or stash your changes first; onboarding stops until the tree is clean. Then the install is one reviewable diff. For a repository with files and no commits, the agent commits them as they are before installing.

### Steps: what onboarding does

#### 1. Confirm the mode

The agent tells you the mode it detected and asks you to confirm. An existing app has source code and config files and no App-Director yet.

#### 2. Files are installed, yours are kept

The installer copies the framework's files and reports what it found:

- **Files you already have** (`AGENTS.md`, `CLAUDE.md`, `TASKS.md`) are kept. The agent then brings each into the framework's shape: `CLAUDE.md` gets the line `@AGENTS.md` at the top, `AGENTS.md` keeps its content and gains the missing sections and a pointer to the rules, and `TASKS.md` converts to the framework's format with its content intact.
- **A framework file your project had its own version of** is left alone, and the framework's version is written next to it as `<file>.adir-new`. The agent shows you the difference and asks which to keep, or helps you merge. Each `.adir-new` file is deleted once resolved.

#### 3. The toolchain, a secrets scan and the check

The agent runs `bash tools/setup-clone.sh`, which checks the tool for your stack and the gitleaks version. For an existing app it also scans the whole commit history once, with `gitleaks git --redact .`, and reports every finding: the rule, the file and the commit. Any secret that was ever committed counts as compromised and must be rotated, even if the commit was later removed. Rotating it is yours to do. The agent does not rotate credentials and does not rewrite history.

It then runs `bash tools/check.sh` once and keeps the result. The git pre-commit hook is installed at the very end, so the install commit is not blocked.

#### 4. The scan (read only)

The agent changes nothing while it reads:

- The layout: which folders hold UI, logic, data and tests, with a file count per folder.
- The entry points: the main file, the router or the manifest.
- Existing tests: which framework, and where the files live.
- Existing docs: README, design documents and TODO lists.
- `TODO`, `FIXME` and `HACK` comments, with file and line.
- UI files that import from storage or API code directly.

#### 5. What it writes, and what it marks for you

- **Architecture.** One row in `AGENTS.md` per significant system. "Owns" comes from public exports and module boundaries, not from guesses.
- **The brief.** Each section of `product/brief.md` is filled from your code and any docs. Anything inferred is marked `(inferred, please confirm)`, and anything unknown becomes an open question (`Q1`, `Q2` and so on). This is where you spend the most attention: read the marked lines and correct them.
- **The queue.** TODOs, known bugs and your priorities become items in `TASKS.md`.
- **Check failures become the first items.** A crash or a data-loss bug is high severity, so it is built first.
- **UI files that break the layer rule.** The check requires that screens never import from the data layer. Each file that does gets its own medium-size item, "Decouple: <file>", and the check fails on it until the item is done.

#### 6. The stack, project facts and settings

The agent asks which stack the app uses (TypeScript, Flutter, Python, or none or other) and records it in `tools/check.cfg`. It fills `AGENTS.md` (name, pitch, stack, platforms, storage, API) and the Layout table from your real folders, and lists the UI and data folders in `tools/check.cfg`. It adds third-party and generated folders such as `node_modules` and `build` to the skip list.

#### 7. The questions it asks you

Beyond confirming the inferred lines, onboarding asks the same questions as for a new app, minus the product interview:

- **Your own product brief.** Onboarding offers `product/director-brief.md`, a template for describing the app in your own words, as an addition to the scan. If you fill it, the agent reads it with the code and your existing documents, builds the first assessment from all three, and marks what it took from it and what it inferred. Where they disagree, it says so and you decide. It never edits your brief. See [Where do I start with an app?](start.md#2-the-product-interview).
- **Ownership.** For each work area (UI code, logic, backend, database schema, visual design, copy, testing, infrastructure), whether you own it. An area you own gets labelled placeholders instead of generated content. See [Where do I start with an app?](start.md#4-who-owns-what).
- **Screens by drawing, and a protected workspace** (`director/`), as for a new app.
- **Model sizing and reviews.** Sizing is recommended on, with a mapping you can change.
- **The acceptance template.** Its sections come from the core flows in the brief. If the flows are not clear from your code, the template keeps its placeholders and an item fills them in later.

#### 8. Approve one commit

The agent runs the check again, walks through the consistency checks of `/align`, and lists every file it created, changed or deleted. Nothing is committed until you say yes. The commit is `chore: install App Director <version>`.

If the check passes, the agent installs the pre-commit hook. If it fails, the hook stays off, and an item "Install the pre-commit hook once the check passes" is added to your queue.

### After the commit

1. **Restart Claude Code,** so the commands, hooks and permissions load.
2. **Read the marked lines.** Confirm or correct everything marked `(inferred, please confirm)` in the brief, and answer the open questions in a design session. See [How do I decide what gets built, or change how something works?](decide.md)
3. **Order the queue.** The items from failures and TODOs are in the order the agent found them; the file order is your priority, so move items up or down.
4. **Say "Do the next task".** If the check failed at install, the first items fix those failures, crashes first. [How do I get things built?](build.md) covers the rest.

### What can go wrong

- **The tree is not clean.** Commit or stash first.
- **The check fails right away.** That is expected for some apps. The failures are filed as items, and the hook waits until they pass.
- **Many screens import from the data layer.** Each gets a "Decouple" item. They are cleared one at a time.
- **A secret in the history.** Rotate it yourself; the agent reports it and does not touch the history.
- **Features built before the framework** have no acceptance outcomes. A full round of the check by hand covers them: see [How do I check that what was built works?](check.md)
- **Every new clone** of the app needs `bash tools/setup-clone.sh` once.

## An existing game (Godot-Director)

A Godot game that already has code, for [Godot-Director](../frameworks/godot-director.md). Install it into the game you have. Onboarding reads the project, fills in the records from what it finds, marks every guess for you to confirm, and ends with one commit for you to approve. Your own files are kept.

### Short answer

- **Install it the way you would into a new game.** The paths and the commands are in the [install section](../frameworks/godot-director.md#install), and [Where do I start with a game?](start-game.md#install-the-framework) compares them.
- **Onboarding detects the mode.** A `project.godot` with scripts and no Godot-Director means an existing game. You confirm what it found.
- **It reads, it does not interview.** The agent scans the project, writes the records from what is there, and asks you only about what the code cannot tell.
- **It overwrites nothing of yours.** A file you already have is kept and brought into the framework's shape; your content stays.
- **A failing check is information.** Existing games often fail the check at first. The failures become the first items in your queue.

### What to have ready

- Godot 4.5 or newer, git and bash (Git Bash on Windows), as for a new game. The full list is in [Where do I start with a game?](start-game.md#what-to-have-installed).
- **A clean git tree.** Commit or stash your changes first; onboarding stops until the tree is clean. Then the install is one reviewable diff.
- **The Godot editor closed** for this project during setup, because it rewrites `project.godot`.

### Steps: what onboarding does

#### 1. Confirm the mode and the assistants

The agent tells you the mode it detected and asks you to confirm. The modes that matter here:

- **Existing game:** `project.godot` and scripts, no Godot-Director yet. This section.
- **Upgrade:** a Godot-Director install already exists. You choose a fast or a full upgrade, and the agent reads the changelog first.
- **Migrate:** a project from the first generation of the framework (it has `.promptx/personas/` or `playtesting/FUNCTION_CHECK.md`). The agent rewrites the old files into the new format, keeping your task and question numbers, and asks before deleting what is obsolete.

It also asks which assistants will work on the game: `claude` (the default) or `none`, if you only use other assistants.

#### 2. Files are installed, yours are kept

The installer copies the framework's files and reports what it found:

- **Files the framework seeds only when missing** (`AGENTS.md`, `CLAUDE.md`, `TASKS.md`, `design/gdd.md`, `tools/check.cfg` and the like) are kept as they are. The agent then brings each into the framework's shape: `CLAUDE.md` gets the line `@AGENTS.md` at the top, `AGENTS.md` keeps its content and gains the missing sections and a pointer to the rules, and `TASKS.md` and the GDD convert to the framework's format with their content intact.
- **A framework file your project had its own version of** (such as `.claude/settings.json`) is left alone, and the framework's version is written next to it as `<file>.gdir-new`. The agent merges the two, keeping your permissions, hooks and settings, and asks you when the difference is not obvious. Each `.gdir-new` file is deleted once merged.

#### 3. Godot is found and the check runs once

The agent finds Godot 4.5 or newer, saves the path in `tools/godot_bin.local` (gitignored, never committed), and asks you only if it cannot find it. On Windows, give the `*_console.exe` build. It then runs `bash tools/check.sh` once and keeps the result. The git pre-commit hook is installed at the very end, so the install commit is not blocked.

#### 4. The scan (read only)

The agent changes nothing while it reads:

- `project.godot`: the name, the Godot version, autoloads, the main scene, the renderer and the window settings.
- The layout: where scripts, scenes, resource schemas, `.tres` data, screen scripts and tests live, with a file count per folder.
- Existing test suites (GUT, gdUnit4) and existing docs (README, design documents, TODO lists, changelogs).
- `TODO`, `FIXME` and `HACK` comments, with file and line.
- Game logic inside screens: randomness, or assignments to an autoload's variables, in UI scripts.

#### 5. What it writes, and what it marks for you

- **Architecture.** One row in `AGENTS.md` per autoload, per area of rule code and per group of screens. "Owns" comes from the scripts' top comments and public methods, not from guesses.
- **The GDD.** Each section is filled from your design documents and code. Anything inferred is marked `(inferred, please confirm)`, and anything unknown becomes an open question (`Q1`, `Q2` and so on). A section the game does not need is deleted only after you agree. This is where you spend the most attention: read the marked lines and correct them.
- **The queue.** TODOs, known bugs and your priorities become items in `TASKS.md`, with bugs as `B` items.
- **Check failures become the first items.** A crash is high severity, so it is built first.
- **Screens with game logic.** The check requires that screens only display state. For each screen script that breaks the rule, the agent files a medium-size item "Decouple: <screen>" that moves the logic into a system, and lists the script as a known exception in `tools/check.cfg`, so the check passes meanwhile.
- **Existing tests.** A GUT or gdUnit4 suite keeps running: the agent writes `tools/check.local.sh` to run it headless, and the check itself skips those test files.
- **Typed GDScript.** The agent turns on the untyped-declaration warning as an error. If that fails the check with many hits, it sets the warning level lower and adds an item to type the remaining declarations, then raise it.

#### 6. Project facts and settings

The agent fills `AGENTS.md` (name, pitch, Godot version, platforms, rendering) and the Layout table from your real folders, and points `tools/check.cfg` at your UI folders. It adds third-party folders to the skip list. It asks you before it lets a screen write to an autoload, for example a settings autoload that its screen legitimately changes.

#### 7. The questions it asks you

Beyond confirming the inferred lines, onboarding asks the same questions as for a new game, minus the design interview:

- **Your own design document.** Onboarding offers `design/director-gdd.md`, a template for describing the game in your own words, as an addition to the scan. If you fill it, the agent reads it with the code and your existing documents, builds the first assessment from all three, and marks what it took from it and what it inferred. Where they disagree, it says so and you decide. It never edits your document. See [Where do I start with a game?](start-game.md#2-the-design-interview).
- **Exports and release.** Platforms, where exports run, and the upload commands. An existing `export_presets.cfg` and the platforms in your GDD are used as the answers, so you are asked only for what is missing. You can skip both steps; a skip adds an open question and a setup item. Details are in [Where do I start with a game?](start-game.md#5-exports-and-release-you-can-skip-both).
- **Ownership.** For each work area (code, UI, art, audio, scenes, tunable values, text), whether you own it. An area you own gets labelled placeholders instead of generated content. See [Where do I start with a game?](start-game.md#3-who-owns-what).
- **Screens by drawing, and a protected workspace** (`director/`), as for a new game.
- **Model sizing and reviews.** Sizing is recommended on, with a mapping you can change.
- **The playtest template.** Its sections come from the loops in your GDD › Core Loop. If the loops are not clear from your design, the template keeps its placeholders and an item fills them in later.

#### 8. Approve one commit

The agent runs the check again, walks through the consistency checks of `/align`, and lists every file it created, changed or deleted, including the `.uid` files that Godot 4.4 and newer creates next to scripts. Nothing is committed until you say yes. The commit is `chore: install Godot Director <version>`, and its body names the mode and everything the agent inferred.

If the check passes, the agent installs the pre-commit hook. If it fails, the hook stays off, and an item "Install the pre-commit hook once the check passes" is added to your queue.

### After the commit

1. **Restart Claude Code,** so the commands, hooks and permissions load.
2. **Open the project in the Godot editor once,** and commit the `.uid` and `.import` files it creates.
3. **Read the marked lines.** Confirm or correct everything marked `(inferred, please confirm)` in the GDD and in `AGENTS.md`, and answer the open questions in a design session. See [How do I decide what gets built, or change how something works?](decide.md)
4. **Order the queue.** The items from failures and TODOs are in the order the agent found them; the file order is your priority, so move items up or down.
5. **Say "Do the next task".** If the check failed at install, the first items fix those failures, crashes first. [How do I get things built?](build.md) covers the rest.

### What can go wrong

- **The tree is not clean.** Commit or stash first. For a repository with files and no commits, the agent commits them as they are before installing, so the install stays one diff.
- **The check fails right away.** That is expected for some games. The failures are filed as items, and the hook waits until they pass.
- **Many screens break the screen rule.** Each gets a "Decouple" item and an accepted-exception line. They are cleared one at a time, and the check passes in between.
- **Many untyped declarations.** The typing warning is lowered for now, with an item to raise it.
- **Features built before the framework** have no acceptance outcomes. A full round of the check by hand covers them: see [How do I check that what was built works?](check.md)
- **Every new clone** of the game needs `bash tools/setup-clone.sh` once.

## An existing SaaS or proof of concept (SaaSAllTheThings)

A working proof of concept, or an app in use, that should become a multi-tenant B2B SaaS on Azure, for [SaaSAllTheThings](../frameworks/saasallthethings.md). The app becomes a SaaS area by area, behind tests, while it keeps working. An assessment often comes first, and onboarding picks up where it left off.

### Short answer

- **Assess first if you are unsure what it takes.** The `saas-assessment` skill reads your app without changing it and writes a report. You can run it before installing anything. The report and the notes from the workshops it proposes feed onboarding later, so nothing is asked twice.
- **Or install straight away.** Onboarding detects an existing app: source code without SaaSAllTheThings. You confirm what it found.
- **It reads, it does not interview.** The agent scans the app, including its single-tenant habits and secrets, fills in the records from what is there, and asks you only about what the code cannot tell.
- **It never picks your stack.** It asks your preference and keeps your stack if it fits Azure Functions. Otherwise it lists the ones that do, with a recommendation.
- **It overwrites nothing of yours.** A file you already have is kept and brought into the framework's shape; your content stays.
- **The roadmap starts with Extract.** Old code stays where it is until its area is moved into the layers.

### What to have ready

- git, bash (Git Bash on Windows) and the toolchain of your backend stack, as for a new SaaS. The full list is in [Where do I start with a SaaS?](start-saas.md#what-to-have-installed).
- **A clean git tree.** Commit or stash your changes first; onboarding stops until the tree is clean. Then the install is one reviewable diff. For a repository with files and no commits, the agent commits them as they are before installing.
- **For the assessment alone:** git and bash. The skill comes with the plugin, or install it with `npx skills add Freakling/SaaSAllTheThings`. The install paths are in the [install section](../frameworks/saasallthethings.md#install).

### The assessment

Ask "what does it take to make this app a SaaS?" in the app's folder. The agent follows the framework's assessment procedure. It is read only: it writes the report and nothing else, and it builds, runs or installs nothing unless you agree.

1. **Framing.** It asks who the report is for (internal planning, or a proposal to a customer), what you already know (the goal, a deadline, the team, the first customer, the systems to integrate, constraints such as budget or the customer's Azure governance), and the report's language and place. What is unknown becomes an open question in the report, never a guess. It also asks for your filled product brief (`product/director-brief.md` once installed, or the template you copy and fill in before), reads it first and does not ask again what it answers. The report marks what came from the brief and what the agent inferred. The assessment goes ahead without one.
2. **The scan.** It collects evidence, not impressions: the shape of the code, entry points, where the business rules live, data and whether anything identifies a customer, single-tenant habits, identity, configuration and secrets, integrations, clients, tests and delivery, and documents. A secret is reported as a file and line, never as a value, with the advice to rotate it.
3. **The stack.** It tells you the languages it found and asks your preference, as in onboarding. Your answer decides whether the roadmap reuses or converts.
4. **The verdict.** It scores nine dimensions from 0 (absent, or blocks the move) to 3 (already fits the reference), each with evidence and what it takes: stack, separation of business rules, data and tenant-awareness, identity, configuration and secrets, integrations, clients, tests, and delivery and operations. It maps each existing component onto its target layer as keep, extract, rebuild or retire, and gives a roadmap by stage with rough effort in person-days and a confidence. It recommends a first slice, and lists risks and assumptions. Every choice comes as options with a recommendation.
5. **The workshops.** It picks the workshops your app needs, usually all nine for a mid-size app and fewer sessions for a small one: vision, capabilities, domain events, tenancy and identity, integration, clients, architecture, operations and planning. For each it writes who takes part, the preparation, a timed agenda and the decisions to reach.

The report is saved as `assessment/YYYY-MM-DD-assessment.md` and left uncommitted until you commit it. It is self-contained, so you can hand it to people who do not have the framework. It ends with a short summary and the next step: prepare the first workshop's invitation and pre-read, or install SaaSAllTheThings.

You run the workshops with your people. The `saas-design-session` skill can prepare agendas and pre-reads, and scribe a session, in Claude Code, Cowork or the Claude apps. Put each session's notes in `assessment/workshops/`. Once SaaSAllTheThings is installed, "process the workshop notes" turns them into records: decisions into the PRD, ADRs and integration contracts, open questions into the PRD, and actions into `TASKS.md`. Before it is installed, onboarding reads the notes instead.

### Steps: what onboarding does

#### 1. Confirm the mode and the assistants

The agent tells you the mode it detected and asks you to confirm. It also asks which assistants will work on the app: `claude` (the default) or `none`, if you only use other assistants.

#### 2. Files are installed, yours are kept

The installer copies the framework's files and reports what it found:

- **Files you already have** (`AGENTS.md`, `CLAUDE.md`, `TASKS.md`, or a requirements document) are kept. The agent then brings each into the framework's shape: `CLAUDE.md` gets the line `@AGENTS.md` at the top, `AGENTS.md` keeps its content and gains the missing sections and a pointer to the rules, and `TASKS.md` and a requirements document convert to the framework's formats (`TASKS.md`, `product/prd.md`) with their content intact.
- **A framework file your project had its own version of** is left alone, and the framework's version is written next to it as `<file>.satt-new`. For `.claude/settings.json` the agent merges the two, keeping your permissions, hooks and settings. For anything else it shows you the difference and asks. Each `.satt-new` file is deleted once resolved.

#### 3. The backend stack

The agent finds the app's languages and frameworks, tells you what it found, and asks whether you have a preference.

- **Your stack fits Azure Functions** (.NET, TypeScript, Python or Java). Staying with it is the first option, and the agent reuses what fits: an ASP.NET Core API becomes the host, a WPF or WinForms desktop app becomes the Windows client, and Windows services and scheduled jobs become timer or message-triggered functions.
- **It does not fit** (for example PHP, Ruby or Delphi). The agent says why and lists the stacks that do, with .NET recommended unless your team points elsewhere. Converting means the roadmap's Extract stage rewrites each area in the new stack. It never picks for you.

The choice is recorded as `ADR-1`, which you accept, and in `tools/check.cfg`. The `[layers]` section points at where the layered code will live; the old code stays outside every layer until its area is extracted.

#### 4. The toolchain and the check

The agent runs `bash tools/setup-clone.sh`, which checks the toolchain and restores dependencies. It then runs `bash tools/check.sh` once and keeps the result. An existing app often fails at first; that is information, not a blocker. The git pre-commit hook is installed at the very end, so the install commit is not blocked.

#### 5. The scan (read only)

If `assessment/` holds a report, the agent starts from it, checks that its findings still hold, and scans only what it does not cover. Otherwise it reads:

- The shape: projects and folders with file counts, entry points, and what talks to what.
- The data: stores, how the code reaches them, and whether anything identifies a customer.
- Single-tenant habits: customer names or ids in code or config, per-customer branches or builds, global state holding customer data, and one connection string for everyone.
- Identity: how users sign in today, and where users and roles live.
- Secrets: the check's secrets rule scans every file, and the agent notes connection strings and keys in config files.
- Integrations (Navision or Business Central first, other ERPs, file drops, email) and clients, and whether their screens hold business rules.
- Tests, docs, and `TODO`, `FIXME` and `HACK` comments, with file and line.

#### 6. What it writes, and what it marks for you

If workshop notes are in `assessment/workshops/`, their decisions are your answers: the agent records them, confirms its reading with you and asks only what they leave open.

Onboarding also offers `product/director-brief.md`, a product brief template for you or the customer's architect or product owner to fill in, in your own words. The agent reads a filled one first, together with the code, the assessment report and the workshop notes, marks what it took from it and what it inferred, and drafts ADRs for the architecture constraints it names. It never edits the brief. See [Where do I start with a SaaS?](start-saas.md#3-the-product-interview).

- **The PRD.** Each section of `product/prd.md` is filled from your documents and code. Anything inferred is marked `(inferred, please confirm)`, and anything unknown becomes an open question (`Q1`, `Q2` and so on). This is where you spend the most attention: read the marked lines and correct them.
- **Architecture.** One row in `AGENTS.md` per existing area (a screen group, a service, a job, a store), marked `(outside the layers: Extract)`.
- **The queue.** Known bugs and your priorities become items in `TASKS.md`. A secret found in the old code is a high-severity bug: rotate it first, then remove it.
- **Existing tests** run from the stack's test command if they fit, or from `tools/check.local.sh`.
- **The roadmap.** The agent writes the stage table into `TASKS.md` › Milestones, and the items for Extract and Foundation. Extract has two items per area of the old app: "Characterise", tests that pin today's behaviour against the old code, then "Extract", which moves the area's rules into the layers. Items only you can do are marked for you.

#### 7. Project facts and ownership

The agent fills `AGENTS.md` (name, pitch, stack, clients, Azure region, integrations) and the Layout table from your real folders. A client's UI technology stays a "Decide" item until an ADR settles it, and an unknown region becomes an open question.

Then it walks you through the same defaults as for a new SaaS. You own the product, the priorities, the customers and the business rules of the integrations, and you accept ADRs. The agent owns code, tests, infrastructure as code and the records. Commits are yours to approve, and so is every deploy: dev with your approval each time, production by you. Model sizing, reviews, screens by drawing and the protected workspace (`director/`) are as in [Where do I start with a SaaS?](start-saas.md#5-who-decides-what). The architecture is not a project rule: it changes only through an ADR.

#### 8. The feedback template

Its sections come from the capabilities in the PRD. If the capabilities are not clear from your documents, the template keeps its placeholders and an item fills them in later.

#### 9. Approve one commit

The agent runs the check again, reports how many source files are still outside every layer, walks through the consistency checks of `/align`, and lists every file it created, changed or deleted. Nothing is committed until you say yes. The commit is `chore: install SaaSAllTheThings <version>`, and its body names the mode, the stack and everything the agent inferred.

If the check passes, the agent installs the pre-commit hook. If it fails or cannot run, the hook stays off, and an item "Install the pre-commit hook once the check passes" is added to your queue.

### After the commit

1. **Restart Claude Code,** so the commands, hooks and permissions load.
2. **Read the marked lines.** Confirm or correct everything marked `(inferred, please confirm)` in the PRD, and answer the open questions in a design session. See [How do I decide what gets built, or change how something works?](decide.md)
3. **Settle the architecture calls.** Each "Decide" item, such as a client's UI technology, is an architecture session (`/architect`) that ends in an ADR you accept.
4. **Order the queue.** The file order is your priority, so move items up or down.
5. **Say "Do the next task".** The first items are the failures from the check, then Extract and Foundation. [How do I get things built?](build.md) covers the rest.

### What can go wrong

- **The tree is not clean.** Commit or stash first.
- **The check fails right away.** That is expected for some apps. The failures are filed as items, and the hook waits until they pass.
- **Secrets in the code.** They are filed as high-severity bugs: the credential is rotated first, then the secret is removed from the code.
- **Many source files are outside the layers.** That is the starting point. The Extract stage moves them area by area, and the count at install is your baseline.
- **Your stack does not fit Azure Functions.** The agent lists the stacks that do, or asks for your preferred language. If that one does not fit either, it says so and asks again. It never picks for you.
- **Every new clone** of the app needs `bash tools/setup-clone.sh` once.

## Related

- The framework pages: [App-Director](../frameworks/app-director.md), [Godot-Director](../frameworks/godot-director.md) and [SaaSAllTheThings](../frameworks/saasallthethings.md).
- The skill pages [`/align`](../skills/align.md) and [Acceptance check](../skills/acceptance.md), and the concept [Align and drift reset](../concept/drift.md).
- The onboarding steps in full: [App-Director](https://github.com/Freakling/App-Director/blob/v1.8.0/ONBOARDING.md), [Godot-Director](https://github.com/Freakling/Godot-Director/blob/v4.3.0/ONBOARDING.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/blob/v0.10.0/ONBOARDING.md).

<div class="takeaway"><span>Install into what you have. Onboarding reads it first and marks every guess.</span><span class="url"><a href="index.md">All questions</a></span></div>
