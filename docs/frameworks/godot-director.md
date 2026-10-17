# Godot-Director

<div class="kicker">Games in Godot 4</div>

Make the game you designed, with AI doing the building and you staying the director. Godot-Director works for new games and games already in development. You decide the design, the balance and the priorities; the AI builds, tests and keeps the records.

[Repository](https://github.com/Freakling/Godot-Director){ .md-button .md-button--primary } [README](https://github.com/Freakling/Godot-Director#readme){ .md-button } [Procedures](https://github.com/Freakling/Godot-Director/tree/v4.1.0/framework/.godot-director/procedures){ .md-button }

## What the check enforces

`bash tools/check.sh` runs five steps:

1. Godot's import pass.
2. Loads every script, scene and resource, checks screen scripts for game rules, and runs `tests/**/test_*.gd`.
3. Scans Godot's output for errors.
4. Plays the smoke scenario headless, when `tools/check.cfg` › `[autoplay]` turns it on.
5. Runs `tools/check.local.sh`, if the game has one (for example an existing GUT suite).

A screen script fails the check when it rolls random numbers or writes to an autoload's state. Game rules live in plain classes that tests build directly, and screens only display them. The screen folders and any accepted exceptions are set in `tools/check.cfg`.

## The play log and autoplay

Every game gets a play log: a plain-text line for you and a JSON line for tools, for each event of each run, in every build. Autoplay plays the game through its main scene with real clicks and key presses, and reads that log, so an assistant can playtest a change before you do. Each game also gets the base of a dev menu, an overlay with a tab per system and an inspector for values only the code can see. The game owns the seeds that wire these in, and onboarding asks whether the game should have the dev menu and how it opens (F12 in debug builds, a setting, a command-line flag, or none). The procedure is in the [repository](https://github.com/Freakling/Godot-Director/tree/v4.1.0/framework/.godot-director/procedures/autoplay.md).

## Install

You need git with no uncommitted changes, Godot 4.5 or newer, and bash (on Windows it comes with Git for Windows). Every option installs the latest release, tagged `v` followed by its version, not `main`.

=== "Skill"

    In the game's folder:

    ```
    npx skills add Freakling/Godot-Director
    ```

    In Claude Code it becomes the `/godot-director` command. The skill fetches the latest release outside your game and runs onboarding.

=== "Claude Code plugin"

    ```
    /plugin marketplace add Freakling/Godot-Director
    /plugin install godot-director@godot-director
    ```

    Then open a new session in the game's folder and run `/godot-director:godot-director`.

=== "Manual"

    Clone the latest release into the game's root folder, next to `project.godot`, as `Godot-Director`, using the release's tag from the [Releases page](https://github.com/Freakling/Godot-Director/releases):

    ```
    git clone --branch <tag> --depth 1 https://github.com/Freakling/Godot-Director.git Godot-Director
    ```

    Then ask your assistant:

    > Read Godot-Director/ONBOARDING.md and follow it to install Godot Director into this project.

Onboarding works out whether this is a new game, an existing game or an upgrade, interviews you or reads the game (and offers a Game Design Document template, `design/director-gdd.md`, to fill in first, in your own words, which gives the agent your intent and context for the sessions and builds that follow), agrees who owns what, and ends with one commit for you to approve. It also asks for the export settings: the target platforms, and where exports run (this machine, a build container or a hosted service such as GitHub Actions). You can skip that step; a skip adds an open question and a setup item that wait for a design session. Restart Claude Code afterwards so the commands load. Each new clone later needs `bash tools/setup-clone.sh`. Step by step, with what onboarding asks: [where do I start with a game?](../how-to/start-game.md), or [I already have a project](../how-to/existing.md#an-existing-game-godot-director) for an existing game.

## Commands

| Command | What it does |
|---|---|
| `/next-task` | Builds the next ready item in a fresh context, proves it with the check, updates the records and commits it once you approve. A run you ask for, such as "grab tasks until you're blocked", commits each item without pausing. Also takes an item ID, a number of items, or `queue`. Step by step: [how do I get things built?](../how-to/build.md) |
| `/design` | A design session on a topic, or `/design questions` to rank the open questions by what they unblock. Step by step: [how do I decide what gets built?](../how-to/decide.md) |
| `/research` | A read-only researcher answers one question in a fresh context and writes a dated note with its sources to `design/research/`. It informs; you decide. Procedure: [`research.md`](https://github.com/Freakling/Godot-Director/tree/v4.1.0/framework/.godot-director/procedures/research.md). Step by step: [I need facts before I decide](../how-to/facts.md) |
| `/export` | Exports the game with Godot's export presets into `builds/`, one folder per preset, and reports the files. It changes no source file. Procedure: [`export.md`](https://github.com/Freakling/Godot-Director/tree/v4.1.0/framework/.godot-director/procedures/export.md). Step by step: [how do I ship it?](../how-to/ship.md) |
| `/ui-design` | Captures the game's screens for you to draw over, turns your drawing into a screen spec, and checks the built screen against that spec. Procedure: [`ui-design.md`](https://github.com/Freakling/Godot-Director/tree/v4.1.0/framework/.godot-director/procedures/ui-design.md). Step by step: [how do I work with UI changes?](../how-to/ui.md) |
| `/release` | Checks the build, exports it with `/export`, and uploads it to the UAT stage. Production only when you ask and say yes. Shared behaviour and this repo's section: [`/release`](../skills/release.md). Procedure: [`release.md`](https://github.com/Freakling/Godot-Director/tree/v4.1.0/framework/.godot-director/procedures/release.md). Step by step: [how do I ship it?](../how-to/ship.md) |
| `/autoplay` | Plays the game through its real main scene and reviews the play log into findings, each with a signature, a step, a screenshot or element map and a repro command. `/autoplay <scenario>` or `--all` plays those, `--replay <run folder>` plays a failure again, and `--player` reviews the newest session you played. Procedure: [`autoplay.md`](https://github.com/Freakling/Godot-Director/tree/v4.1.0/framework/.godot-director/procedures/autoplay.md). Step by step: [how do I check that what was built works?](../how-to/check.md) |
| `/playtest` | Starts a playtest report, or turns a filled-in one into bugs, score trends and design proposals. Step by step: [how do I check that what was built works?](../how-to/check.md) |
| `/function-check` | Prepares or processes a checklist of built features for you to tick Works or Broken. Step by step: [how do I check that what was built works?](../how-to/check.md) |
| `/align` | Consistency pass across the GDD, decisions, tasks, `AGENTS.md`, settings and code. Step by step: [the records and the code don't agree](../how-to/align.md) |
| `/drift-reset` | Design drift reset, started only by you; `/drift-reset postmortem` after the rebuild. Step by step: [the system was not built as I intended](../how-to/drift.md) |
| `/prune` | Moves done items to `TASKS-archive.md`. Step by step: [the task list is getting long](../how-to/prune.md) |
| `/refresh-model-sizing` | Sets or updates the model for each task size. Step by step: [it's costing more than I'd like](../how-to/cost.md) |

To design a screen by drawing, you draw annotated boxes over screenshots of the running game in [Excalidraw](https://excalidraw.com), which is free, runs in the browser and needs no account, and save each drawing in `director/ui/`. The agent captures the screens, reads your drawing, records the layout in `design/ui/`, builds the screen to it and verifies the result. A layout lint catches squeezed text, controls running off the screen, overlapping and unreachable controls.

## Release and CI export

Exports can run in CI on every change. If you use GitHub Actions, the workflow template in `.godot-director/templates/release-workflow.yml` exports every preset on each push and pull request, uploads to UAT on `main`, and has a production job that you start by hand and that waits for approval in a protected GitHub Environment. Onboarding can set up the upload commands in `release.cfg`, which name the secrets they read. The secrets are CI secrets only, never values in the repository or the chat. The [release page](../skills/release.md) covers `/release` in detail.

## Read more

- In use: [PKSEI](../examples/pksei.md), a game built with Godot-Director, with its loop, numbers and recipe
- [The concept](../concept/index.md) and [agent development flow](../concept/agent-flow.md)
- [Director-Driven Development](https://saemundsson.se/2026/10/07/director-driven-development/) on saemundsson.se

<div class="takeaway"><span>Rules live in systems, not screens.</span><span class="url"><a href="https://github.com/Freakling/Godot-Director">Freakling/Godot-Director</a></span></div>
