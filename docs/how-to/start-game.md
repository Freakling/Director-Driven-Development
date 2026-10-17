# Where do I start with a game?

<div class="kicker">From a game idea to a first built task, with Godot-Director</div>

> Install Godot-Director into an empty game folder, restart Claude Code, and let onboarding interview you about the game. It ends with one commit for you to approve. Then say "Do the next task".

This page is for someone with a game idea and no project yet. [Godot-Director](../frameworks/godot-director.md) is the framework for games in Godot 4. For an app, see [Where do I start with an app?](start.md). For a multi-tenant B2B SaaS on Azure, see [Where do I start with a SaaS?](start-saas.md) If a game already exists, go to [I already have a project. Can I use this?](existing.md#an-existing-game-godot-director)

## Short answer

1. **Have three things installed:** Godot 4.3 or newer, git, and bash.
2. **Install the framework** in your game's folder with one command.
3. **Answer onboarding.** It asks about the game, who owns what, and how you want to work, and writes the answers into your project.
4. **Approve the install commit,** restart Claude Code, and ask for the first task.

## What to have installed

- **Claude Code,** in which you run everything. Other AI assistants that read `AGENTS.md` can use the framework's core, but Godot-Director is built and tested on Claude Code and the others are untested.
- **Godot 4.3 or newer.** Onboarding finds it and records the path for this machine. You do not need to create the project in Godot first.
- **git.** Your game lives in its own git repository.
- **bash.** On Windows it comes with Git for Windows, and every command runs in Git Bash.
- **Node.js,** if you install with the skill, because that command uses `npx`.

Make an empty folder for the game and open Claude Code in it. If the folder is not a git repository yet, onboarding offers to run `git init`.

## Install the framework

Pick one of three paths. Each installs the latest release.

| Path | What you run | Then |
|---|---|---|
| Skill | `npx skills add Freakling/Godot-Director` in the game's folder, choosing your assistant in the prompt | Run `/godot-director` in Claude Code |
| Claude Code plugin | `/plugin marketplace add Freakling/Godot-Director`, then `/plugin install godot-director@godot-director` | Open a new session in the game's folder (or run `/reload-plugins`) and run `/godot-director:godot-director` |
| Manual | Clone the release into the game as a folder named `Godot-Director` | Ask: "Read Godot-Director/ONBOARDING.md and follow it to install Godot Director into this project." |

The skill is the shortest path. The full commands, including the manual clone, are in the [install section](../frameworks/godot-director.md#install). The installer only runs onboarding; the workflow itself is committed into your game, so it keeps working without the skill.

## Steps: what onboarding asks

Onboarding is the agent following the framework's `ONBOARDING.md`. You decide everything about the design and who owns what. The agent gathers, proposes and writes. Most questions come as choices, with a recommendation.

### 1. Getting ready

- **Close the Godot editor** for this project if it is open. The editor rewrites `project.godot`, so keep it closed until onboarding is done.
- **Confirm the mode.** The agent tells you what it detected and asks you to confirm. With no `project.godot` and no code, that is a fresh start.
- **Which assistants will work on the game?** The default is Claude Code (`claude`). Answer `none` if you will only use other assistants; you then get the tool-neutral core, which works through `AGENTS.md`. For a first game in Claude Code, take the default.
- **Where is Godot?** The agent finds Godot 4.3 or newer on its own. If it cannot, it asks for the path. On Windows, give the `*_console.exe` build, so the agent can read Godot's output. The path is saved in `tools/godot_bin.local`, which stays on your machine and is never committed.

### 2. The design interview

The agent writes a minimal `project.godot` itself, so do not use Godot's project manager. Then it interviews you in short rounds. Each question comes with options and a recommendation. Pick one, or answer in your own words.

**Your own design document comes first.** Before the interview, onboarding offers `design/director-gdd.md`, a Game Design Document template you fill in, in your own words. Use it instead of the interview or as well as it, and fill it before onboarding, now (the agent waits) or later; the interview works without it. A written document gives the agent your intent and the context behind it, which a chat alone doesn't, and every design session and build later starts from it. If you fill it, the agent reads it first, takes the interview's answers from it marked `(from your document)`, and asks only what it leaves open. What it works out itself is marked `(inferred, please confirm)`. It never edits your document or fills it in for you; `design/gdd.md` stays the design record it maintains.

| It asks about | A sensible first answer | What it changes |
|---|---|---|
| Pitch, genre, and the feeling the game should give | One or two sentences. The feeling matters more than the feature list | The GDD's Pitch, and the pillars that follow |
| Three to five Design Pillars | Short statements you would use to turn down a feature, such as "short sessions" | Every later feature is checked against them, and an idea that contradicts one stops a design session |
| The core loop: moment to moment, a session, a run or campaign, and the starting conditions | The smallest loop that is fun to repeat. Leave out what you have not decided | The GDD's Core Loop, and the first playable scene |
| Platforms, input, 2D or 3D, camera, art direction and target aspect ratios | Where you want to ship first and how it is played. The default renderer is `forward_plus`; `gl_compatibility` suits web and low-end targets | The project's rendering setting, AGENTS.md and the GDD's Presentation and Platforms |

Anything you answer is written into `design/gdd.md` as the current design, with one line in `design/decisions.md` for each decision. Anything you leave undecided becomes an open question (`Q1`, `Q2` and so on). The agent never answers one itself. "I don't know yet" is a fine answer and costs nothing.

### 3. Who owns what

For each work area the agent states the default and asks whether you want to own it. An area you own is never generated: the agent builds a labelled placeholder instead and waits for your real thing.

| Area | Default | If you own it, the agent leaves |
|---|---|---|
| GDScript and game code | agent | A stubbed function or empty class marked `## PLACEHOLDER` |
| UI and screen layout | agent, or you draw and the agent builds | A minimal working screen, commented for redesign |
| Art, sprites, textures | you | A `ColorRect` labelled with what goes there |
| Audio, music, sound effects | you | An audio player with no stream, named for the sound |
| Scene and level design | shared | A grey-box scene for you to finish |
| Tunable values (`data/`) | you | A `## PLACEHOLDER` default you replace in the `.tres` file |
| Player-facing text | agent | A `"[PLACEHOLDER: ...]"` string |

For a first game the defaults work: the agent writes the code, and you keep art, audio and the numbers that decide how the game feels. The result goes into the Ownership table in `AGENTS.md`. The idea is explained in [Ownership](../concept/ownership.md).

Two follow-ups come with it:

- **Do you want to design screens by drawing?** Say yes if you like sketching layouts over screenshots of the running game (free Excalidraw, no account). Say no and nothing changes; drawing is never required. See [How do I work with UI changes?](ui.md)
- **A protected workspace.** If you own any area, or want a folder the agent never touches, onboarding offers `director/`. The agent reads it for context (reference art, sketches, audio, notes) and never creates, changes or deletes anything in it. You choose whether to gitignore it (large binary assets) or commit it (design notes).

### 4. How you want to work

- **Commits and pushes** need no answer. The agent proposes each commit and you approve it. It pushes only when you ask.
- **Model sizing.** The agent recommends it on and shows the mapping. In Claude Code the defaults are Haiku for XS and S, Sonnet for M, Opus for L and XL. Say whether any size should differ. Take the recommendation if unsure; the cost effects are in [It's costing more than I'd like](cost.md).
- **Reviews** are stated rather than asked: an independent review after L and XL items, and after M items that change saves or a system's public methods. See [Reviews](../concept/reviews.md).

### 5. Exports and release (you can skip both)

- **Exports.** Which platforms the game ships to, and where exports run: this machine, a build container, or a hosted service such as GitHub Actions. For a first game, "this machine" and the platform you play on is a good answer. Web needs the `gl_compatibility` renderer; Android needs the Android SDK and a keystore set in the editor's settings; macOS and iOS signing needs Apple's tools and a developer account.
- **Release.** Offered once exports are set up: the command that uploads each build to a test branch or channel, the command for production, and the *names* of the CI secrets those commands need. Values never go in the repository or the chat. Godot-Director knows no store, so you supply the commands.
- **Skipping either** adds an open question and a setup item to your task list. Answer the question in a design session (`/design Q<n>`) when you are ready, and the setup is built like any other task.

### 6. The playtest template

If your core loop is decided, the agent turns each loop into a section of `playtesting/TEMPLATE.md`, usually three to six, with one scored statement and a question or two about decisions and feel. If the loops are not decided yet, it leaves the placeholders and adds an item to fill them in later.

### 7. Approve the install commit

The agent runs `bash tools/check.sh`, walks through the consistency checks of `/align`, and lists every file it created or changed. It then asks you to approve one commit, `chore: install Godot Director <version>`, whose body names the mode and anything it inferred. Read the list; nothing is committed before you say yes.

After the commit:

- If the check passes, the agent installs the git pre-commit hook, so every later commit that touches code, scenes or data runs the check. If it fails, the hook stays off and an item is added to install it once the check passes.
- On a manual install it offers to delete the `Godot-Director` folder from the game. Deleting it is recommended.
- It offers a "Development" section for your README: clone, run `bash tools/setup-clone.sh`, then the commands.
- It tells you what still needs your confirmation and which phrases to use.

## What your game gets

The files below are yours and are never overwritten. The framework's own files (`.godot-director/`, and `.claude/` with Claude Code) are replaced on upgrade.

| File | Holds |
|---|---|
| `AGENTS.md` | Project facts, layout, architecture, ownership and project rules, for every assistant |
| `TASKS.md` | Milestones and the queue of tasks, bugs and research |
| `design/gdd.md` | The current design, and the open questions |
| `design/decisions.md` | Why: one line per decision |
| `playtesting/TEMPLATE.md` | The playtest template, one section per core loop |
| `tools/check.cfg` | Settings for the check |

The concepts behind these files are in [Records in files](../concept/records.md).

## Your first task

1. **Restart Claude Code,** so the new commands, hooks and permissions load.
2. **Open the project in the Godot editor once,** and commit the `.uid` and `.import` files it creates.
3. **Look at `TASKS.md`.** For a new game the queue starts with the folder layout, a first autoload for game state, a first rule class with a test, and a first playable grey-box scene set as the main scene. The order in the file is your priority order; move an item up to build it sooner.
4. **Say "Do the next task"** (or type `/next-task`). The agent builds the first ready item in a fresh context, proves it with the check, updates the records and asks you to approve the commit. Use this one-at-a-time mode while you learn what the agent builds. [How do I get things built?](build.md) covers the questions it can ask, and how to ask for a run.
5. **Run `/clear`** before the next task. The records hold everything the next session needs.

## What can go wrong

- **The editor is open during setup.** It rewrites `project.godot`, so keep it closed until onboarding is done.
- **The commands are missing.** See [Something isn't there, or doesn't work](trouble.md).
- **Godot is not found.** Give the agent the path to Godot 4.3 or newer. Until it is saved, the check cannot run and exits with 3.
- **A new clone of the game.** Every new clone needs `bash tools/setup-clone.sh` once; it finds Godot and installs the hook.
- **Another assistant.** Only the core is the same everywhere: rules, procedures, the check and the pre-commit hook. Fresh-context builds, the reviewer, model sizing and the hooks that block risky commands depend on your assistant supporting subagents and hooks.

## Where to go next

- **Settle what the open questions leave:** [How do I decide what gets built, or change how something works?](decide.md). `/design questions` ranks them by what they unblock.
- **Need facts first:** [I need facts before I decide](facts.md).
- **Play it and check it:** [How do I check that what was built works?](check.md)
- **Ship it:** [How do I ship it?](ship.md)
- **See a finished game:** [PKSEI](../examples/pksei.md), built with Godot-Director, shows the loop as it ran.

## Related

- The [Godot-Director page](../frameworks/godot-director.md), its [install section](../frameworks/godot-director.md#install), and the skill pages [`/next-task`](../skills/next-task.md) and [`/design`](../skills/design.md).
- The concepts [Roles](../concept/roles.md) and [Agent development flow](../concept/agent-flow.md).
- The onboarding steps in full: [`ONBOARDING.md`](https://github.com/Freakling/Godot-Director/blob/v3.13.0/ONBOARDING.md).

<div class="takeaway"><span>Install, answer the interview, approve one commit, then ask for the next task.</span><span class="url"><a href="index.md">All questions</a></span></div>
