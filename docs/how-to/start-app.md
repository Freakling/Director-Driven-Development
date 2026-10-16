# Where do I start with an app?

<div class="kicker">From an app idea to a first built task, with App-Director</div>

> Install App-Director in the app's folder, restart Claude Code, and let onboarding interview you about the app. It ends with one commit for you to approve. Then say "Do the next task".

This page is for someone with a web, mobile or desktop app idea and no project yet. [App-Director](../frameworks/app-director.md) is the framework for small apps. For a game, see [Where do I start with a game?](start.md). For a multi-tenant B2B SaaS on Azure, see [Where do I start with a SaaS?](start-saas.md) If the app already exists, go to [I already have a project. Can I use this?](existing.md#an-existing-app-app-director)

## Short answer

1. **Have four things installed:** git, bash, gitleaks, and the tools for your stack (Node.js for TypeScript, Flutter, or Python).
2. **Install the framework** in your app's folder with one command.
3. **Answer onboarding.** It asks about the app, the stack, who owns what, and how you want to work, and writes the answers into your project.
4. **Approve the install commit,** restart Claude Code, and ask for the first task.

## What to have installed

- **Claude Code,** in which you run everything. Other AI assistants that read `AGENTS.md` can use the framework's core, but App-Director is built and tested on Claude Code and the others are untested.
- **git.** Your app lives in its own git repository. If the folder is not one yet, onboarding offers to run `git init`.
- **bash.** On Windows it comes with Git for Windows, and every command runs in Git Bash.
- **gitleaks 8.18.0 or newer, except 8.19.0,** which cannot scan. The check uses it to look for secrets. On macOS run `brew install gitleaks`, on Windows `winget install gitleaks`. If it is missing, onboarding stops and tells you the command for your system.
- **The tools of your stack.** Onboarding asks which stack the app uses, and the check runs that stack's own tools:

| Stack | Have installed | The check runs |
|---|---|---|
| TypeScript (React, React Native, Node) | Node.js and npm | `tsc`, `eslint`, and `vitest` or `jest` |
| Flutter | Flutter | `flutter analyze` and `flutter test` |
| Python | Python, `pytest`, and `pyright` or `mypy` | the type checker and `pytest` |
| None or other | Nothing extra | Only the layer and secrets checks; you add your own steps in `tools/check.local.sh` |

- **Node.js,** if you install with the skill, because that command uses `npx`.

Make a folder for the app and open Claude Code in it. The tree has to be clean: an empty folder, or one with only an initial commit, is a fresh start.

## Install the framework

Pick one of three paths. Each installs the latest release.

| Path | What you run | Then |
|---|---|---|
| Skill | `npx skills add Freakling/App-Director` in the app's folder, choosing your assistant in the prompt | Run `/app-director` in Claude Code |
| Claude Code plugin | `/plugin marketplace add Freakling/App-Director`, then `/plugin install app-director@app-director` | Open a new session in the app's folder (or run `/reload-plugins`) and run `/app-director:app-director` |
| Manual | Clone the release next to the app as a folder named `App-Director` | Ask: "Read App-Director/ONBOARDING.md and follow it to install App Director into this project." |

The skill is the shortest path. The full commands, including the manual clone, are in the [install section](../frameworks/app-director.md#install). The installer only runs onboarding; the workflow itself is committed into your app, so it keeps working without the skill.

## Steps: what onboarding asks

Onboarding is the agent following the framework's `ONBOARDING.md`. You decide everything about the design and who owns what. The agent gathers, proposes and writes. Most questions come as choices, with a recommendation.

### 1. Getting ready

- **Confirm the mode.** The agent tells you what it detected and asks you to confirm. With no code, that is a fresh start.
- **Install the files and check the toolchain.** The agent copies the framework into the app, then runs `bash tools/setup-clone.sh`. That checks the tool for your stack and the gitleaks version, and tells you what to install if something is missing. If you put the `App-Director` folder inside the app, the agent keeps it out of git for you.

### 2. The product interview

The agent interviews you in short rounds. Each question comes with options and a recommendation. Pick one, or answer in your own words.

**Your own product brief comes first.** Before the interview, onboarding offers `product/director-brief.md`, a product brief template you fill in, in your own words. Use it instead of the interview or as well as it, and fill it before onboarding, now (the agent waits) or later; the interview works without it. A written brief gives the agent your intent and the context behind it, which a chat alone doesn't, and every design session and build later starts from it. If you fill it, the agent reads it first, takes the interview's answers from it marked `(from your brief)`, and asks only what it leaves open. What it works out itself is marked `(inferred, please confirm)`. It never edits your brief or fills it in for you; `product/brief.md` stays the design record it maintains.

| It asks about | A sensible first answer | What it changes |
|---|---|---|
| The pitch: what the app does, who it is for, and the feeling it should give | One or two sentences. Say who the user is | The brief's Pitch |
| Core flows: the three to five things a user actually does | Actions with an outcome, such as "add a task and tick it off", not screen names | The brief's Core Flows, the first screen, and the acceptance template |
| Platforms and constraints: web, mobile, desktop or a mix; offline support; whether sign-in is required | Where you want to ship first. Leave out what you have not decided | The brief, and the project facts in `AGENTS.md` |
| The stack: TypeScript, Flutter, Python, or none | The one you or your team already know | `tools/check.cfg`, and which tools the check runs |

Anything you answer is written into `product/brief.md` as the current design. Anything you leave undecided becomes an open question (`Q1`, `Q2` and so on). The agent never answers one itself. "I don't know yet" is a fine answer and costs nothing.

### 3. Project facts and folders

The agent fills in `AGENTS.md` with the name, pitch, stack, platforms, storage and API. It writes the Layout table from your real folders, in three layers: the UI layer (screens, pages, components), the logic layer (services, hooks, stores) and the data layer (api, repositories, storage). It lists the UI and data folders in `tools/check.cfg`, and the check fails when a screen imports from the data layer directly.

### 4. Who owns what

For each work area the agent states the default and asks whether you want to own it. An area you own is never generated: the agent builds a labelled placeholder instead and waits for your real thing.

| Area | Default | If you own it, the agent leaves |
|---|---|---|
| Frontend and UI code | agent | A minimal working component, commented for redesign |
| Business logic and services | agent | A stub service returning hard-coded data, marked `PLACEHOLDER` |
| Backend and API | agent | A stub endpoint returning mock data, documented |
| Database schema and migrations | agent | A schema with `PLACEHOLDER` on new fields, and a migration stub |
| Visual design and assets | you | An image tag labelled `[PLACEHOLDER: describe asset]` |
| Copy and user-facing text | agent | A `"[PLACEHOLDER: describe the text]"` string |
| Testing | agent | Tests for every outcome the task list marks as a test |
| Infrastructure and deployment | you | A config stub with `PLACEHOLDER` on the values you must set |

For a first app the defaults work: the agent writes the code and the tests, and you keep the look and the infrastructure. The result goes into the Ownership table in `AGENTS.md`. The idea is explained in [Ownership](../concept/ownership.md).

If you own any area, or want a folder the agent never touches, onboarding offers `director/`. The agent reads it for context (mockups, brand assets, reference images, notes, third-party API specs) and never creates, changes or deletes anything in it. You choose whether to gitignore it (large binary assets) or commit it (design notes).

### 5. How you want to work

- **Commits and pushes** need no answer. The agent proposes each commit and you approve it. It pushes only when you ask.
- **Model sizing.** The agent recommends it on and shows the mapping. In Claude Code the defaults are Haiku for XS and S, Sonnet for M, Opus for L and XL. Say whether any size should differ. Take the recommendation if unsure; the cost effects are in [It's costing more than I'd like](cost.md).
- **Reviews** are stated rather than asked: an independent review after L and XL items, and after M items that change stored data schemas or public API contracts. See [Reviews](../concept/reviews.md).

### 6. The acceptance template

If your core flows are decided, the agent turns each into a section of `validation/TEMPLATE.md`, usually three to five, each with a Works and a Broken box and a notes line. If the flows are not decided yet, it leaves the placeholders and adds an item to fill them in later.

### 7. Approve the install commit

The agent runs `bash tools/check.sh`, walks through the consistency checks of `/align`, and lists every file it created or changed. It then asks you to approve one commit, `chore: install App Director <version>`. Read the list; nothing is committed before you say yes.

After the commit:

- If the check passes, the agent installs the git pre-commit hook, so every later commit that touches code runs the check. If it fails, the hook stays off and an item is added to install it once the check passes.
- It tells you what still needs your confirmation and which phrases to use.

## What your app gets

The files below are yours and are never overwritten. The framework's own files (`.app-director/`, and `.claude/` with Claude Code) belong to the framework.

| File | Holds |
|---|---|
| `AGENTS.md` | Project facts, layout, architecture, ownership and project rules, for every assistant |
| `TASKS.md` | Milestones and the queue of tasks, bugs and research |
| `product/brief.md` | The current design, and the open questions |
| `product/decisions.md` | Why: one line per decision |
| `validation/TEMPLATE.md` | The acceptance template, one section per core flow |
| `tools/check.cfg` | Settings for the check: the stack, and the UI and data folders |

The concepts behind these files are in [Records in files](../concept/records.md).

## Your first task

1. **Restart Claude Code,** so the new commands, hooks and permissions load.
2. **Look at `TASKS.md`.** For a new app the queue starts with the folder layout, the first passing check and the first working screen for your main flow. The order in the file is your priority order; move an item up to build it sooner.
3. **Say "Do the next task"** (or type `/next-task`). The agent builds the first ready item in a fresh context, proves it with the check, updates the records and asks you to approve the commit. Use this one-at-a-time mode while you learn what the agent builds. [How do I get things built?](build.md) covers the questions it can ask, and how to ask for a run.
4. **Run `/clear`** before the next task. The records hold everything the next session needs.

## What can go wrong

- **The commands are missing.** See [Something isn't there, or doesn't work](trouble.md).
- **gitleaks is missing, too old, or 8.19.0.** The check cannot run and exits with 3. Install a supported version and run `bash tools/setup-clone.sh` again.
- **The tool for your stack is missing.** Onboarding says which one. Install it, then run `bash tools/setup-clone.sh`.
- **A new clone of the app.** Every new clone needs `bash tools/setup-clone.sh` once; it checks the tools and installs the hook.
- **Another assistant.** Only the core is the same everywhere: rules, procedures, the check and the pre-commit hook. Fresh-context builds, the reviewer, model sizing and the hooks that block risky commands depend on your assistant supporting subagents and hooks.

## Where to go next

- **Settle what the open questions leave:** [How do I decide what gets built, or change how something works?](decide.md). `/design questions` ranks them by what they unblock.
- **Need facts first:** [I need facts before I decide](facts.md).
- **Try it and check it:** [How do I check that what was built works?](check.md)
- **Ship it:** [How do I ship it?](ship.md)

## Related

- The [App-Director page](../frameworks/app-director.md), its [install section](../frameworks/app-director.md#install), and the skill pages [`/next-task`](../skills/next-task.md) and [`/design`](../skills/design.md).
- The concepts [Roles](../concept/roles.md) and [Agent development flow](../concept/agent-flow.md).
- The onboarding steps in full: [`ONBOARDING.md`](https://github.com/Freakling/App-Director/blob/v1.7.0/ONBOARDING.md).

<div class="takeaway"><span>Install, answer the interview, approve one commit, then ask for the next task.</span><span class="url"><a href="index.md">All questions</a></span></div>
