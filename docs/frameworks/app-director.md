# App-Director

<div class="kicker">Small web, mobile and desktop apps</div>

Make the app you designed, with AI doing the building and you staying the director. App-Director works for new apps and apps already in development, on TypeScript, Flutter or Python. You decide what the app does, how it should feel and what gets built next; the AI builds, tests and keeps the records.

[Repository](https://github.com/Freakling/App-Director){ .md-button .md-button--primary } [README](https://github.com/Freakling/App-Director#readme){ .md-button } [Procedures](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures){ .md-button }

## What the check enforces

`bash tools/check.sh` runs four steps:

1. **UI purity:** fails when a file in a UI folder imports from a data-layer folder. Screens display state and call services; they never fetch data or call storage directly.
2. **Secrets:** runs gitleaks on the working tree and fails when a credential is found. The pre-commit hook also scans staged changes, so secrets are caught before they enter git history.
3. **Stack:** the type check, lint and tests for the app's stack (`tools/stacks/typescript.sh`, `flutter.sh` or `python.sh`).
4. **Custom:** runs `tools/check.local.sh`, if the app has one.

The UI and data folders are set in `tools/check.cfg`. If gitleaks is missing, too old or can't scan, the check exits 3 and never passes silently.

## Install

You need git with no uncommitted changes, bash (on Windows it comes with Git for Windows) and [gitleaks](https://github.com/gitleaks/gitleaks#installing) 8.18.0 or newer, except 8.19.0, which can't scan. Every option installs the latest release, tagged `v` followed by its version, not `main`.

=== "Skill"

    In the app's folder:

    ```
    npx skills add Freakling/App-Director
    ```

    In Claude Code it becomes the `/app-director` command. The skill fetches the latest release outside your app and runs onboarding; to pick up a newer release later, run `npx skills add` again.

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

Onboarding works out whether this is a new app, an existing app or an upgrade, sets up the toolchain, interviews you or reads the code, agrees who owns what, and ends with one commit for you to approve. Restart Claude Code afterwards so the commands load. Each new clone later needs `bash tools/setup-clone.sh`.

## Commands

| Command | What it does |
|---|---|
| `/next-task` | Builds the next ready item in a fresh context, proves it with the check, updates the records and commits |
| `/design` | A design session on a topic, or `/design questions` to rank the open questions by what they unblock |
| `/research` | A read-only researcher answers one question in a fresh context and writes a dated note with its sources to `product/research/`. It informs; you decide. Procedure: [`research.md`](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/research.md) |
| `/acceptance` | Prepares or processes a checklist of built behaviour for you to tick Works or Broken |
| `/align` | Consistency pass across the brief, decisions, tasks, `AGENTS.md` and check config |
| `/drift-reset` | Design drift reset, started only by you; `/drift-reset postmortem` after the rebuild |
| `/prune` | Moves done items to `TASKS-archive.md` |
| `/release` | Runs the check, builds for the target platform and walks you through the deploy |
| `/refresh-model-sizing` | Sets or updates the model for each task size |

## Read more

- [The concept](../concept/index.md) and [agent development flow](../concept/agent-flow.md)
- [Director-Driven Development](https://saemundsson.se/2026/10/07/director-driven-development/) on saemundsson.se

<div class="takeaway"><span>Logic lives in the logic layer, not the UI.</span><span class="url"><a href="https://github.com/Freakling/App-Director">Freakling/App-Director</a></span></div>
