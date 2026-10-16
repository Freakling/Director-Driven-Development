# I already have a project. Can I use this?

<div class="kicker">Yes: onboarding reads your game instead of interviewing you from scratch</div>

> Yes. Install Godot-Director into the game you have. Onboarding reads the project, fills in the records from what it finds, marks every guess for you to confirm, and ends with one commit for you to approve. Your own files are kept.

This page covers a Godot game that already has code, for [Godot-Director](../frameworks/godot-director.md). App-Director and SaaSAllTheThings will get their own pages for existing projects later. Starting from an idea instead? See [Where do I start?](start.md)

## Short answer

- **Install it the way you would into a new game.** The paths and the commands are in the [install section](../frameworks/godot-director.md#install), and [Where do I start?](start.md#install-the-framework) compares them.
- **Onboarding detects the mode.** A `project.godot` with scripts and no Godot-Director means an existing game. You confirm what it found.
- **It reads, it does not interview.** The agent scans the project, writes the records from what is there, and asks you only about what the code cannot tell.
- **It overwrites nothing of yours.** A file you already have is kept and brought into the framework's shape; your content stays.
- **A failing check is information.** Existing games often fail the check at first. The failures become the first items in your queue.

## What to have ready

- Godot 4.3 or newer, git and bash (Git Bash on Windows), as for a new game. The full list is in [Where do I start?](start.md#what-to-have-installed).
- **A clean git tree.** Commit or stash your changes first; onboarding stops until the tree is clean. Then the install is one reviewable diff.
- **The Godot editor closed** for this project during setup, because it rewrites `project.godot`.

## Steps: what onboarding does

### 1. Confirm the mode and the assistants

The agent tells you the mode it detected and asks you to confirm. The modes that matter here:

- **Existing game:** `project.godot` and scripts, no Godot-Director yet. This page.
- **Upgrade:** a Godot-Director install already exists. You choose a fast or a full upgrade, and the agent reads the changelog first.
- **Migrate from 1.x:** a project from the first generation of the framework (it has `.promptx/personas/` or `playtesting/FUNCTION_CHECK.md`). The agent rewrites the old files into the new format, keeping your task and question numbers, and asks before deleting what is obsolete.

It also asks which assistants will work on the game: `claude` (the default) or `none`, if you only use other assistants.

### 2. Files are installed, yours are kept

The installer copies the framework's files and reports what it found:

- **Files the framework seeds only when missing** (`AGENTS.md`, `CLAUDE.md`, `TASKS.md`, `design/gdd.md`, `tools/check.cfg` and the like) are kept as they are. The agent then brings each into the framework's shape: `CLAUDE.md` gets the line `@AGENTS.md` at the top, `AGENTS.md` keeps its content and gains the missing sections and a pointer to the rules, and `TASKS.md` and the GDD convert to the framework's format with their content intact.
- **A framework file your project had its own version of** (such as `.claude/settings.json`) is left alone, and the framework's version is written next to it as `<file>.gdir-new`. The agent merges the two, keeping your permissions, hooks and settings, and asks you when the difference is not obvious. Each `.gdir-new` file is deleted once merged.

### 3. Godot is found and the check runs once

The agent finds Godot 4.3 or newer, saves the path in `tools/godot_bin.local` (gitignored, never committed), and asks you only if it cannot find it. On Windows, give the `*_console.exe` build. It then runs `bash tools/check.sh` once and keeps the result. The git pre-commit hook is installed at the very end, so the install commit is not blocked.

### 4. The scan (read only)

The agent changes nothing while it reads:

- `project.godot`: the name, the Godot version, autoloads, the main scene, the renderer and the window settings.
- The layout: where scripts, scenes, resource schemas, `.tres` data, screen scripts and tests live, with a file count per folder.
- Existing test suites (GUT, gdUnit4) and existing docs (README, design documents, TODO lists, changelogs).
- `TODO`, `FIXME` and `HACK` comments, with file and line.
- Game logic inside screens: randomness, or assignments to an autoload's variables, in UI scripts.

### 5. What it writes, and what it marks for you

- **Architecture.** One row in `AGENTS.md` per autoload, per area of rule code and per group of screens. "Owns" comes from the scripts' top comments and public methods, not from guesses.
- **The GDD.** Each section is filled from your design documents and code. Anything inferred is marked `(inferred, please confirm)`, and anything unknown becomes an open question (`Q1`, `Q2` and so on). A section the game does not need is deleted only after you agree. This is where you spend the most attention: read the marked lines and correct them.
- **The queue.** TODOs, known bugs and your priorities become items in `TASKS.md`, with bugs as `B` items.
- **Check failures become the first items.** A crash is high severity, so it is built first.
- **Screens with game logic.** The check requires that screens only display state. For each screen script that breaks the rule, the agent files a medium-size item "Decouple: <screen>" that moves the logic into a system, and lists the script as a known exception in `tools/check.cfg`, so the check passes meanwhile.
- **Existing tests.** A GUT or gdUnit4 suite keeps running: the agent writes `tools/check.local.sh` to run it headless, and the check itself skips those test files.
- **Typed GDScript.** The agent turns on the untyped-declaration warning as an error. If that fails the check with many hits, it sets the warning level lower and adds an item to type the remaining declarations, then raise it.

### 6. Project facts and settings

The agent fills `AGENTS.md` (name, pitch, Godot version, platforms, rendering) and the Layout table from your real folders, and points `tools/check.cfg` at your UI folders. It adds third-party folders to the skip list. It asks you before it lets a screen write to an autoload, for example a settings autoload that its screen legitimately changes.

### 7. The questions it asks you

Beyond confirming the inferred lines, onboarding asks the same questions as for a new game, minus the design interview:

- **Exports and release.** Platforms, where exports run, and the upload commands. An existing `export_presets.cfg` and the platforms in your GDD are used as the answers, so you are asked only for what is missing. You can skip both steps; a skip adds an open question and a setup item. Details are in [Where do I start?](start.md#5-exports-and-release-you-can-skip-both).
- **Ownership.** For each work area (code, UI, art, audio, scenes, tunable values, text), whether you own it. An area you own gets labelled placeholders instead of generated content. See [Where do I start?](start.md#3-who-owns-what).
- **Screens by drawing, and a protected workspace** (`director/`), as for a new game.
- **Model sizing and reviews.** Sizing is recommended on, with a mapping you can change.
- **The playtest template.** Its sections come from the loops in your GDD › Core Loop. If the loops are not clear from your design, the template keeps its placeholders and an item fills them in later.

### 8. Approve one commit

The agent runs the check again, walks through the consistency checks of `/align`, and lists every file it created, changed or deleted, including the `.uid` files that Godot 4.4 and newer creates next to scripts. Nothing is committed until you say yes. The commit is `chore: install Godot Director <version>`, and its body names the mode and everything the agent inferred.

If the check passes, the agent installs the pre-commit hook. If it fails, the hook stays off, and an item "Install the pre-commit hook once the check passes" is added to your queue.

## After the commit

1. **Restart Claude Code,** so the commands, hooks and permissions load.
2. **Open the project in the Godot editor once,** and commit the `.uid` and `.import` files it creates.
3. **Read the marked lines.** Confirm or correct everything marked `(inferred, please confirm)` in the GDD and in `AGENTS.md`, and answer the open questions in a design session. See [How do I decide what gets built, or change how something works?](decide.md)
4. **Order the queue.** The items from failures and TODOs are in the order the agent found them; the file order is your priority, so move items up or down.
5. **Say "Do the next task".** If the check failed at install, the first items fix those failures, crashes first. [How do I get things built?](build.md) covers the rest.

## What can go wrong

- **The tree is not clean.** Commit or stash first. For a repository with files and no commits, the agent commits them as they are before installing, so the install stays one diff.
- **The check fails right away.** That is expected for some games. The failures are filed as items, and the hook waits until they pass.
- **Many screens break the screen rule.** Each gets a "Decouple" item and an accepted-exception line. They are cleared one at a time, and the check passes in between.
- **Many untyped declarations.** The typing warning is lowered for now, with an item to raise it.
- **Features built before the framework** have no acceptance outcomes. A full round of the check by hand covers them: see [How do I check that what was built works?](check.md)
- **Every new clone** of the game needs `bash tools/setup-clone.sh` once.

## Related

- The [Godot-Director page](../frameworks/godot-director.md), the skill pages [`/align`](../skills/align.md) and [Acceptance check](../skills/acceptance.md), and the concept [Align and drift reset](../concept/drift.md).
- The onboarding steps in full: [`ONBOARDING.md`](https://github.com/Freakling/Godot-Director/blob/v3.12.0/ONBOARDING.md).

<div class="takeaway"><span>Install into the game you have. Onboarding reads it first and marks every guess.</span><span class="url"><a href="index.md">All questions</a></span></div>
