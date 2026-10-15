# Godot-Director

<div class="kicker">Games in Godot 4</div>

Make the game you designed, with AI doing the building and you staying the director. Godot-Director works for new games and games already in development. You decide the design, the balance and the priorities; the AI builds, tests and keeps the records.

[Repository](https://github.com/Freakling/Godot-Director){ .md-button .md-button--primary } [README](https://github.com/Freakling/Godot-Director#readme){ .md-button } [Procedures](https://github.com/Freakling/Godot-Director/tree/v3.9.0/framework/.godot-director/procedures){ .md-button }

## What the check enforces

`bash tools/check.sh` runs four steps:

1. Godot's import pass.
2. Loads every script, scene and resource, checks screen scripts for game rules, and runs `tests/**/test_*.gd`.
3. Scans Godot's output for errors.
4. Runs `tools/check.local.sh`, if the game has one (for example an existing GUT suite).

A screen script fails the check when it rolls random numbers or writes to an autoload's state. Game rules live in plain classes that tests build directly, and screens only display them. The screen folders and any accepted exceptions are set in `tools/check.cfg`.

## Install

You need git with no uncommitted changes, Godot 4.3 or newer, and bash (on Windows it comes with Git for Windows). Every option installs the latest release, tagged `v` followed by its version, not `main`.

=== "Skill"

    In the game's folder:

    ```
    npx skills add Freakling/Godot-Director
    ```

    In Claude Code it becomes the `/godot-director` command. The skill fetches the latest release outside your game and runs onboarding; to pick up a newer release later, run `npx skills add` again.

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

Onboarding works out whether this is a new game, an existing game or an upgrade, interviews you or reads the game, agrees who owns what, and ends with one commit for you to approve. It also asks for the export settings: the target platforms, and where exports run (this machine, a build container or a hosted service such as GitHub Actions). You can skip that step; a skip adds an open question and a setup item that wait for a design session. Restart Claude Code afterwards so the commands load. Each new clone later needs `bash tools/setup-clone.sh`.

## Commands

| Command | What it does |
|---|---|
| `/next-task` | Builds the next ready item in a fresh context, proves it with the check, updates the records and commits it once you approve. A run you ask for, such as "grab tasks until you're blocked", commits each item without pausing. Also takes an item ID, a number of items, or `queue` |
| `/design` | A design session on a topic, or `/design questions` to rank the open questions by what they unblock |
| `/research` | A read-only researcher answers one question in a fresh context and writes a dated note with its sources to `design/research/`. It informs; you decide. Procedure: [`research.md`](https://github.com/Freakling/Godot-Director/tree/v3.9.0/framework/.godot-director/procedures/research.md) |
| `/export` | Exports the game with Godot's export presets into `builds/`, one folder per preset, and reports the files. It changes no source file. Procedure: [`export.md`](https://github.com/Freakling/Godot-Director/tree/v3.9.0/framework/.godot-director/procedures/export.md) |
| `/playtest` | Starts a playtest report, or turns a filled-in one into bugs, score trends and design proposals |
| `/function-check` | Prepares or processes a checklist of built features for you to tick Works or Broken |
| `/align` | Consistency pass across the GDD, decisions, tasks, `AGENTS.md`, settings and code |
| `/drift-reset` | Design drift reset, started only by you; `/drift-reset postmortem` after the rebuild |
| `/prune` | Moves done items to `TASKS-archive.md` |
| `/refresh-model-sizing` | Sets or updates the model for each task size |

## Read more

- [The concept](../concept/index.md) and [agent development flow](../concept/agent-flow.md)
- [Director-Driven Development](https://saemundsson.se/2026/10/07/director-driven-development/) on saemundsson.se

<div class="takeaway"><span>Rules live in systems, not screens.</span><span class="url"><a href="https://github.com/Freakling/Godot-Director">Freakling/Godot-Director</a></span></div>
