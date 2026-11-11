# App-Director

<div class="kicker">Small web, mobile and desktop apps</div>

Make the app you designed, with AI doing the building and you staying the director. App-Director works for new apps and apps already in development, on TypeScript, Flutter or Python. You decide what the app does, how it should feel and what gets built next; the AI builds, tests and keeps the records.

[Repository](https://github.com/Freakling/App-Director){ .md-button .md-button--primary } [README](https://github.com/Freakling/App-Director#readme){ .md-button } [Procedures](https://github.com/Freakling/App-Director/tree/v1.16.0/framework/.app-director/procedures){ .md-button }

## What the check enforces

`bash tools/check.sh` runs four steps over the whole project, which is the full tier:

1. **UI purity:** fails when a file in a UI folder imports from a data-layer folder. Screens display state and call services; they never fetch data or call storage directly.
2. **Secrets:** runs gitleaks on the working tree and fails when a credential is found. The pre-commit hook also scans staged changes, so secrets are caught before they enter git history.
3. **Stack:** the type check, lint and tests for the app's stack (`tools/stacks/typescript.sh`, `flutter.sh` or `python.sh`).
4. **Custom:** runs `tools/check.local.sh`, if the app has one.

The UI and data folders are set in `tools/check.cfg`. If gitleaks is missing, too old or can't scan, the check exits 3 and never passes silently.

### The fast and the full tier

`bash tools/check.sh --fast` runs the same steps, with the stack check doing what the change needs. For TypeScript that is tsc over the project, eslint on the changed files and the tests related to the change. The build, the commit and the Stop hook use the fast tier. The full tier runs on request, before a push, for a release and at the end of a run of several items, and a commit runs it instead of the fast tier when it is due. `bash tools/check.sh --due` says whether it is due and why: no full pass recorded yet, a set number of commits since the last one (10 by default), or a changed dependency, toolchain setting, file under `tools/` or configured path.

- **One suite.** The python, flutter and none stack checks have no fast mode. Where `tools/check.local.sh` has none either, a fast request runs as the full tier and says so, and that one pass serves a build, a commit and a push.
- **A very large change** (more than 100 changed source files, or 6,000 characters of their paths) makes a fast request run as the full tier too, and says so.
- **Hooks.** The pre-commit hook asks for the full tier when it is due and the fast tier otherwise, and says which and why. The pre-push hook asks for the full tier and reuses a full pass of the same files. Before a commit the agent asks `--due` and, when the full tier is due, runs it in the background first, so the commit reuses that pass ([Running the check](https://github.com/Freakling/App-Director/blob/v1.16.0/framework/.app-director/rules.md)).
- **The cache.** `--if-changed` repeats a recorded result for the same files. A fast pass never stands for a full request, and a miss names what changed.
- **One check at a time.** In a checkout one check runs at a time. A second waits for the running one and reuses its result when the files and the tier match; `CHECK_WAIT` caps the wait, and past it the check exits 3.
- **Settings.** The settings are under `[tests]` in [`tools/check.cfg`](https://github.com/Freakling/App-Director/blob/v1.16.0/project/tools/check.cfg): which tests the fast tier runs, how many commits pass between full runs, the paths that make the full tier due, and the paths that can't change a result.

## The records gate

The pre-commit hook also runs [`tools/records.sh`](https://github.com/Freakling/App-Director/blob/v1.16.0/framework/tools/records.sh), which holds a commit to what you decided. A commit refuses the record lines that no approval of yours covers, and names them: every added or removed line of the brief and the decisions, a confirmed story, an item that is added or moved on from `proposed`, and a changed outcome of an item. The commit message names the approval in an `Approved:` line. Status changes, notes, `unconfirmed` stories and `proposed` items are free.

- **How you approve.** The agent registers the summary's exact lines and shows them with an id. A message that is only an approval word, or the Approve option of a question dialog that names the summary, approves it in Claude Code; with another assistant you run `bash tools/records.sh approve <id>` in your own terminal. See [how to decide](../how-to/decide.md).
- **`proposed` items.** What the agent files by itself is `proposed`, and `/next-task` never picks it until a summary you approve makes it `todo`. A bug that names the brief heading or confirmed story it restores may be filed `todo`; `[records] bugs` in [`tools/check.cfg`](https://github.com/Freakling/App-Director/blob/v1.16.0/project/tools/check.cfg) sets that, and onboarding asks it.
- **Limits.** The gate judges commits made with `git commit`. In Claude Code the command guard refuses the agent's `git cherry-pick`, `revert`, `rebase` and `am`, which commit without it, so you run those yourself. It is a safety net, not a lock. If a commit is refused or an "ok" didn't count, see [the troubleshooting page](../how-to/trouble.md#a-commit-was-refused-or-an-ok-didnt-count).

## The time limits

The stack check and `tools/check.local.sh` each run under a time limit that depends on the tier: `[tests] timeout-fast` (300 seconds by default) and `[tests] timeout-full` (3600 seconds by default; a `[tests] timeout` counts for the full tier when `timeout-full` isn't set). A run past its limit exits 3, which means the check couldn't run. The hook timeouts in `.claude/settings.json` are in seconds, as Claude Code reads them: the guard stops after 10 seconds, the protected-space guard after 5 and the Stop hook after an hour, so a long check isn't cut off. The Bash tool's own limits are the `BASH_DEFAULT_TIMEOUT_MS` and `BASH_MAX_TIMEOUT_MS` environment variables.

## The OWASP baseline

The OWASP Top 10 (2025), and the OWASP API Security Top 10 (2023) for an app that serves an API, is the baseline every app meets. It is framework-owned: no setting turns it off, and a rule in `AGENTS.md` can't relax it. A deviation is only an accepted decision, a line in `product/decisions.md` that names the OWASP item and why; without one it is a finding in review. Design sessions state each option's effect on the baseline, review checks each change against it, and [`/security`](../skills/security.md) assesses what is built from time to time. The check serves only two parts of it, the secrets scan and UI purity, and makes no claim to cover the rest. The rule is in [`rules.md`](https://github.com/Freakling/App-Director/blob/v1.16.0/framework/.app-director/rules.md), and the checklist in [`owasp.md`](https://github.com/Freakling/App-Director/blob/v1.16.0/framework/.app-director/reference/owasp.md).

## User stories

`product/user-stories.md` keeps the roles the app serves and a story for each thing a role does, each with the date you confirmed it. Every feature item names the stories it serves in `Stories:`. A design drafts the new ones for you to confirm, an existing app's are written from its code at onboarding and wait as `unconfirmed`, and `/next-task` proposes a validation after enough built items (`bash tools/stories.sh --due`, with `[stories] every` in `tools/check.cfg`). More in [User stories](../concept/user-stories.md).

## Install

**Start here: write your product brief.** The README opens its install with this step. Before you install, describe the app in your own words in a copy of the [product brief template](https://github.com/Freakling/App-Director/blob/v1.16.0/project/product/director-brief.md), saved as `product/director-brief.md` in your app, and fill in what you know. Then install: onboarding reads your brief and asks only what you left open. More in [write it down first](../how-to/start.md#write-it-down-first).

You need git with no uncommitted changes, bash (on Windows it comes with Git for Windows) and [gitleaks](https://github.com/gitleaks/gitleaks#installing) 8.18.0 or newer, except 8.19.0, which can't scan. Every option installs the latest release, tagged `v` followed by its version, not `main`.

=== "Skill"

    In the app's folder:

    ```
    npx skills add Freakling/App-Director
    ```

    In Claude Code it becomes the `/app-director` command. The skill fetches the latest release outside your app and runs onboarding.

=== "Claude Code plugin"

    ```
    /plugin marketplace add Freakling/App-Director
    /plugin install app-director@app-director
    ```

    Then open a new session in the app's folder and run `/app-director:app-director`.

=== "Manual"

    Clone the latest release next to your app as `App-Director/`, using the release's tag from the [Releases page](https://github.com/Freakling/App-Director/releases):

    ```
    git clone --branch <tag> --depth 1 https://github.com/Freakling/App-Director.git App-Director
    ```

    Then ask your assistant:

    > Read App-Director/ONBOARDING.md and follow it to install App Director into this project.

Onboarding works out whether this is a new app, an existing app or an upgrade, sets up the toolchain, reads your product brief first, if you wrote one (and offers the template if you didn't), interviews you or reads the code, agrees who owns what, and ends with one commit for you to approve. Restart Claude Code afterwards so the commands load. Each new clone later needs `bash tools/setup-clone.sh`. Step by step, with what onboarding asks: [where do I start with an app?](../how-to/start.md), or [I already have a project](../how-to/existing.md#an-existing-app-app-director) for an existing app.

## Commands

| Command | What it does |
|---|---|
| `/next-task` | Builds the next ready item in a fresh context, proves it with the check, updates the records and commits. Two sessions that build at once each get [their own git worktree](../how-to/build.md#two-sessions-that-build-at-once). Step by step: [how do I get things built?](../how-to/build.md) |
| `/design` | A design session on a topic, or `/design questions` to rank the open questions by what they unblock. Step by step: [how do I decide what gets built?](../how-to/decide.md) |
| `/research` | A read-only researcher answers one question in a fresh context and writes a dated note with its sources to `product/research/`. It informs; you decide. Procedure: [`research.md`](https://github.com/Freakling/App-Director/tree/v1.16.0/framework/.app-director/procedures/research.md). Step by step: [I need facts before I decide](../how-to/facts.md) |
| `/ui-design` | Captures your web app's screens for you to draw over, turns your drawing into a screen spec, and checks the built screen against that spec. Capture opens the app on this machine only, with Node and Playwright installed once in `tools/ui/`. Shared behaviour and this repo's section: [`/ui-design`](../skills/ui-design.md). Procedure: [`ui-design.md`](https://github.com/Freakling/App-Director/tree/v1.16.0/framework/.app-director/procedures/ui-design.md). Step by step: [how do I work with UI changes?](../how-to/ui.md) |
| `/prototype` | Tries a change before it's built against the product. A git worktree beside the app, on a `proto/<name>` branch, gets a session of its own outside the build loop: no items, records or check gate, the guard and the secrets scan still on, and nothing pushed or merged. `/prototype list` shows the prototypes, `/prototype harvest <name>` turns one into decisions, user stories and items that are built from main, and `/prototype remove <name>` removes one. Shared behaviour and this repo's section: [`/prototype`](../skills/prototype.md). Procedure: [`prototype.md`](https://github.com/Freakling/App-Director/tree/v1.16.0/framework/.app-director/procedures/prototype.md). Step by step: [how do I try a change before it's built?](../how-to/prototype.md) |
| `/acceptance` | Prepares or processes a checklist of built behaviour for you to tick Works or Broken, and whether the user stories behind each item are still right. Step by step: [how do I check that what was built works?](../how-to/check.md) |
| `/align` | Consistency pass across the brief, decisions, tasks, `AGENTS.md` and check config. Step by step: [the records and the code don't agree](../how-to/align.md) |
| `/drift-reset` | Design drift reset, started only by you; `/drift-reset postmortem` after the rebuild. Step by step: [the system was not built as I intended](../how-to/drift.md) |
| `/prune` | Moves done items to `TASKS-archive.md`. Step by step: [the task list is getting long](../how-to/prune.md) |
| `/security` | A security assessment against the OWASP baseline: the tools first, each skipped when absent, then a fresh-context review through the checklist. Findings become bug items with the OWASP item and a proposed fix, the people and process items come to you, and a dated report goes in `product/security/`. It runs on request, before a release is proposed and when `/next-task` finds one due. A clean run doesn't prove the app secure. Shared behaviour and this repo's section: [`/security`](../skills/security.md). Procedure: [`security.md`](https://github.com/Freakling/App-Director/tree/v1.16.0/framework/.app-director/procedures/security.md) |
| `/release` | Runs the check, builds for the target platform and walks you through the deploy. Shared behaviour and this repo's section: [`/release`](../skills/release.md). Step by step: [how do I ship it?](../how-to/ship.md) |
| `/refresh-model-sizing` | Sets or updates the model for each task size. Every subagent launch passes that model explicitly ([how sizing works](../concept/sizing.md#the-model-map)). Step by step: [it's costing more than I'd like](../how-to/cost.md) |

## Read more

- In use: [this site](../examples/index.md), built with App-Director
- [The concept](../concept/index.md) and [agent development flow](../concept/agent-flow.md)
- [Director-Driven Development](https://saemundsson.se/2026/10/07/director-driven-development/) on saemundsson.se

<div class="takeaway"><span>Logic lives in the logic layer, not the UI.</span><span class="url"><a href="https://github.com/Freakling/App-Director">Freakling/App-Director</a></span></div>
