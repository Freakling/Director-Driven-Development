# Something isn't there, or doesn't work

<div class="kicker">A missing command, a failing check or a tool that won't run, and what to do first</div>

> Most "it isn't there" problems are an older install. Update to the latest release, restart Claude Code, and the commands, hooks and permissions are the ones this site describes.

Every page here describes the latest release of each framework. If a command, a step or a file doesn't match what you see, start with the first section. If it does, the second section lists what a new director meets most often.

## Short answer

1. **Update to the latest release** with the command for the way you installed. The table below has one per framework and install path.
2. **Restart Claude Code.** Skills, hooks and permissions load when a session starts.
3. **Still stuck?** Find your symptom under [Common causes](#common-causes).

## Make sure you're on the latest release

Run the command for your framework and your install path, in the project's folder.

| Framework | Skill (`npx skills add`) | Claude Code plugin | Manual |
|---|---|---|---|
| Godot-Director | `npx skills add Freakling/Godot-Director` again, then ask for it (`/godot-director` in Claude Code) | `/plugin marketplace update godot-director`, then `/plugin update godot-director@godot-director`. Start a new session in the game and run `/godot-director:godot-director` again | Put the new Godot-Director folder in the game, and ask for `ONBOARDING.md` again |
| App-Director | `npx skills add Freakling/App-Director` again, then ask your assistant to set up App Director | The same two plugin commands with App-Director's names: `/plugin marketplace update app-director`, then `/plugin update app-director@app-director`. Start a new session in the app and run `/app-director:app-director` again | Put the new App-Director folder next to the app, and ask for `ONBOARDING.md` again |
| SaaSAllTheThings | `npx skills add Freakling/SaaSAllTheThings` again, then ask for the upgrade | `/plugin marketplace update saasallthethings`, then `/plugin update saasallthethings@saasallthethings`. Start a new session in the app and run `/saasallthethings:saas-all-the-things` again | Put the new SaaSAllTheThings folder in the app, and ask for `ONBOARDING.md` again |

Each of these takes you to the agent, which sees the install already there and runs onboarding in its upgrade mode. It tells you what changes and asks before it touches anything of yours. Only the framework's own files are replaced; the files that are yours are kept.

**Restart Claude Code afterwards.** A new skill, hook or permission loads only when a session starts, so a session that was open during the update still has the old ones.

The install paths themselves are on each framework page: [Godot-Director](../frameworks/godot-director.md#install), [App-Director](../frameworks/app-director.md#install) and [SaaSAllTheThings](../frameworks/saasallthethings.md#install).

## Common causes

### A slash command isn't there

- **The session was open during the install or update.** Restart Claude Code.
- **Claude Code is open in another folder.** The commands live in the project's own `.claude/` folder. Open Claude Code in the project's root folder, the one that holds `AGENTS.md`.
- **The framework isn't installed in this project.** Install it first: [Where do I start with a game?](start.md), [with an app?](start-app.md) or [with a SaaS?](start-saas.md) for a new project, [I already have a project. Can I use this?](existing.md) for an existing one.
- **It's an older install.** Update as above. A command added in a later release isn't in an older install.

You can always say what you want in plain words, such as "Do the next task". The agent follows the same procedure as the command.

### The check fails, or exits with 3

The check, `bash tools/check.sh`, ends with one of three results.

| Exit | What it means | What to do |
|---|---|---|
| 0 | It passed | Nothing |
| 1 | It ran and found something | Read the output: the agent shows it and fixes what it points at. The pre-commit hook blocks the commit until the check passes |
| 3 | It couldn't run | A tool it needs is missing. Run `bash tools/setup-clone.sh`, which checks the toolchain and says what is missing |

What can be missing depends on the framework:

- **Godot-Director:** Godot is not found, or is older than 4.3. Give the agent the path to Godot; `setup-clone.sh` records it for this machine.
- **App-Director:** gitleaks is missing, too old, or a version that can't scan, or the tool for your stack is missing.
- **SaaSAllTheThings:** the toolchain of your backend stack is missing, such as the .NET SDK for the default stack.

An exit 3 is not a failure of your work. The agent reports the work as unverified rather than done, and says why.

### A fresh clone of the project

Everything in the project is committed except the per-machine setup. In a new clone, or on a second machine, run `bash tools/setup-clone.sh` once. It finds or checks the tools and installs the pre-commit hook. Without it, commits aren't checked, and the check prints a note that the clone has no pre-commit hook. For two sessions at once, give the second its own worktree and run it there too.

### Capture can't run (Godot-Director)

`/ui-design capture` renders the screens in Godot, which needs a display. It exits with 3 and says why: no Godot, a Godot older than 4.3, no display, or Godot couldn't open a window or start its renderer. Fix what the message names. On Linux it needs a display or `xvfb-run`. Where the display is the reason, the agent can still write the element maps and the layout lint without images, and tells you they come from a headless run. More in [How do I work with UI changes?](ui.md)

### A write to `director/` was refused

This is by design, in Godot-Director and App-Director. `director/` is your own workspace for reference art, sketches and notes. The agent reads it for context and never writes there, whether the path is relative or absolute. Put files in it yourself.

### The agent asks before every commit

This is by design too: the agent commits only with your approval. Asking for a run, such as "Do the next 3 tasks" or "Work through the queue", approves its commits in advance for that run. The agent pushes only when you ask. See [How do I get things built?](build.md)

## Related

- The install sections of [Godot-Director](../frameworks/godot-director.md#install), [App-Director](../frameworks/app-director.md#install) and [SaaSAllTheThings](../frameworks/saasallthethings.md#install).
- The procedures: [Godot-Director onboarding](https://github.com/Freakling/Godot-Director/blob/v3.13.0/ONBOARDING.md), [App-Director onboarding](https://github.com/Freakling/App-Director/blob/v1.7.0/ONBOARDING.md) and [SaaSAllTheThings onboarding](https://github.com/Freakling/SaaSAllTheThings/blob/v0.9.0/ONBOARDING.md).

<div class="takeaway"><span>Update, restart, and the commands you expect are there.</span><span class="url"><a href="index.md">All questions</a></span></div>
