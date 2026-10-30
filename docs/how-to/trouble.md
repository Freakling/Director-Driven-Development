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
| App-Director | `npx skills add Freakling/App-Director` again, then ask your assistant to set up App Director | The same two plugin commands with App-Director's names: `/plugin marketplace update app-director`, then `/plugin update app-director@app-director`. Start a new session in the app and run `/app-director:app-director` again | Put the new App-Director folder next to the app, and ask for `ONBOARDING.md` again |
| Godot-Director | `npx skills add Freakling/Godot-Director` again, then ask for it (`/godot-director` in Claude Code) | `/plugin marketplace update godot-director`, then `/plugin update godot-director@godot-director`. Start a new session in the game and run `/godot-director:godot-director` again | Put the new Godot-Director folder in the game, and ask for `ONBOARDING.md` again |
| SaaSAllTheThings | `npx skills add Freakling/SaaSAllTheThings` again, then ask for the upgrade | `/plugin marketplace update saasallthethings`, then `/plugin update saasallthethings@saasallthethings`. Start a new session in the app and run `/saasallthethings:saas-all-the-things` again | Put the new SaaSAllTheThings folder in the app, and ask for `ONBOARDING.md` again |

Each of these takes you to the agent, which sees the install already there and runs onboarding in its upgrade mode. It tells you what changes and asks before it touches anything of yours. Only the framework's own files are replaced; the files that are yours are kept.

**Restart Claude Code afterwards.** A new skill, hook or permission loads only when a session starts, so a session that was open during the update still has the old ones.

The install paths themselves are on each framework page: [App-Director](../frameworks/app-director.md#install), [Godot-Director](../frameworks/godot-director.md#install) and [SaaSAllTheThings](../frameworks/saasallthethings.md#install).

## Common causes

### A slash command isn't there

- **The session was open during the install or update.** Restart Claude Code.
- **Claude Code is open in another folder.** The commands live in the project's own `.claude/` folder. Open Claude Code in the project's root folder, the one that holds `AGENTS.md`.
- **The framework isn't installed in this project.** Install it first: [Where do I start with an app?](start.md), [with a game?](start-game.md) or [with a SaaS?](start-saas.md) for a new project, [I already have a project. Can I use this?](existing.md) for an existing one.
- **It's an older install.** Update as above. A command added in a later release isn't in an older install.

You can always say what you want in plain words, such as "Do the next task". The agent follows the same procedure as the command.

### The check fails, or exits with 3

The check, `bash tools/check.sh`, ends with one of three results.

| Exit | What it means | What to do |
|---|---|---|
| 0 | It passed | Nothing |
| 1 | It ran and found something | Read the output: the agent shows it and fixes what it points at. The pre-commit hook blocks the commit until the check passes |
| 3 | It couldn't run | Fix what the output names. For a missing tool, run `bash tools/setup-clone.sh`, which checks the toolchain and says what is missing. For a timeout, see Godot-Director below |

What can be missing depends on the framework:

- **App-Director:** gitleaks is missing, too old, or a version that can't scan, or the tool for your stack is missing.
- **Godot-Director:** Godot is not found, or is older than 4.5. Give the agent the path to Godot; `setup-clone.sh` records it for this machine. Where GNU `timeout` is installed, a Godot run that passes its timeout also exits 3, and the report names the test file it was in. A hung test needs fixing; a suite that is only slow can have a longer `[tests] timeout` in `tools/check.cfg` (600 seconds by default). The check ends each run with its ten slowest test files, which show where the time goes. More in [what the check enforces](../frameworks/godot-director.md#what-the-check-enforces).

Balanced test jobs are opt-in. `[tests] balance = true` in `tools/check.cfg` deals the test files to the parallel jobs by the last run's times, and `split_over` (seconds) splits a slow file by test method. A file whose tests share state across methods keeps a line `# gdir: no-split` among its first ten lines and runs whole, and `bash tools/check.sh --jobs 1` measures every file whole again. Where heavy test files compete for the CPU, balancing may not help, so measure with the slowest-files summary before and after. Turn it on only once no test depends on the order the files run in.
- **SaaSAllTheThings:** the toolchain of your backend stack is missing, such as the .NET SDK for the default stack.

An exit 3 is not a failure of your work. The agent reports the work as unverified rather than done, and says why.

### The agent's command is blocked

A Bash guard in each framework blocks commands that hang or run past five minutes, since a wait that long lets the prompt cache expire and the next turn rewrites the whole context. The message names the form that works, and the agent uses it.

| Blocked | The form that works |
|---|---|
| Python reading from an empty heredoc, the "is Python here?" probe, which waits for console input on Windows | `python3 --version` |
| An `until` or `while` loop with `sleep` and no limit | The same loop under `timeout 240`, or, for a background command, wait for its completion notice |
| A loop on a background command's output that doesn't wait for its exit line | Loop until the output holds `[exited with code N]` or `[killed]`, under `timeout 240` |
| A `sleep` over 280 seconds | A shorter sleep, or a `timeout` loop of 280 seconds or less |
| Godot-Director only: a direct Godot run with no time limit | `timeout 120` before the Godot command; `tools/check.sh`, `tools/autoplay.sh` and `tools/ui_capture.sh` cap their own runs |

### A Godot test fails only in the check

In Godot-Director the test files run side by side. A test that reads autoload or `user://` state another file left behind can pass alone and fail in the check. Make the test set up what it reads, and give each test file its own `user://` file name. Until the test is fixed, set `[tests] jobs` to `1` in `tools/check.cfg`, or pass `--jobs 1` for one run; either runs the tests in one process. More in [what the check enforces](../frameworks/godot-director.md#what-the-check-enforces).

### A fresh clone of the project

Everything in the project is committed except the per-machine setup. In a new clone, or on a second machine, run `bash tools/setup-clone.sh` once. It finds or checks the tools and installs the pre-commit hook. Without it, commits aren't checked, and the check prints a note that the clone has no pre-commit hook. For two sessions at once, give the second its own worktree and run it there too.

### Capture can't run

**Godot-Director.** `/ui-design capture` renders the screens in Godot, which needs a display. It exits with 3 and says why: no Godot, a Godot older than 4.5, no display, or Godot couldn't open a window or start its renderer. Fix what the message names. On Linux it needs a display or `xvfb-run`. Where the display is the reason, the agent can still write the element maps and the layout lint without images, and tells you they come from a headless run. More in [How do I work with UI changes?](ui.md)

**App-Director and SaaSAllTheThings.** `/ui-design capture` opens your web app in headless Chromium, which needs no display. It exits with 3, writes nothing and says why: Node 20 or newer is missing, Playwright or Chromium isn't installed in `tools/ui` (the message prints the command: `cd tools/ui && npm install && npx playwright install chromium`), `[web] base_url` in `tools/ui_capture.cfg` is empty because the app has no web UI, the address isn't this machine, or the app didn't start. In SaaSAllTheThings it also stops when a test user's sign-in isn't saved, and names the file, the test tenant and the command that saves it. A screen that fails alone, with the run going on, is usually a page error, a route that answers with an error, or, in SaaSAllTheThings, a screen sent to sign in because its test user's saved sign-in has expired. Fix what the message names and capture again. More in [How do I work with UI changes?](ui.md)

### A write to `director/` was refused

This is by design, in all three frameworks. `director/` is your own workspace for reference art, drawings, sketches and notes. The agent reads it for context and never writes there, whether the path is relative or absolute. Put files in it yourself.

### The agent asks before every commit

This is by design too: the agent commits only with your approval. Asking for a run, such as "Do the next 3 tasks" or "Work through the queue", approves its commits in advance for that run. The agent pushes only when you ask. See [How do I get things built?](build.md)

## Related

- The install sections of [App-Director](../frameworks/app-director.md#install), [Godot-Director](../frameworks/godot-director.md#install) and [SaaSAllTheThings](../frameworks/saasallthethings.md#install).
- The procedures: [App-Director onboarding](https://github.com/Freakling/App-Director/blob/v1.12.2/ONBOARDING.md), [Godot-Director onboarding](https://github.com/Freakling/Godot-Director/blob/v4.6.2/ONBOARDING.md) and [SaaSAllTheThings onboarding](https://github.com/Freakling/SaaSAllTheThings/blob/v0.14.3/ONBOARDING.md).

<div class="takeaway"><span>Update, restart, and the commands you expect are there.</span><span class="url"><a href="index.md">All questions</a></span></div>
