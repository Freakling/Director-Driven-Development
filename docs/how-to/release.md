# Ship a build with /release

<div class="kicker">A checked build, shipped where you say</div>

> Nothing ships without the check, and anything that reaches users or production waits for your yes.

This guide is for someone who has never run `/release`. All three frameworks ship it, and each releases to its own kind of target: Godot-Director to a platform's test or production channel, App-Director to web, mobile or desktop, and SaaSAllTheThings to an Azure environment. The steps below say where they differ. The [skill page](../skills/release.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** `/release` takes the project from a passing check to a target you name. It prepares the build, shows you what it will do, and ships only after your yes.
- **What it needs first.** A clean working tree and a passing `bash tools/check.sh`. A failing check stops the release.
- **What is yours.** Production credentials stay with you, and so do store submissions. Where the agent can't run a step, it hands you the exact command.
- **What to set up first.**
  - **Godot-Director.** A `release.cfg` in the project root, with one section per export preset: a `uat` command, an optional `production` command and the names of the secrets they read. Only names go in the file, never values. If you skipped the release setup, `/design` on its open question runs it.
  - **App-Director.** The stack and the deploy method, in `tools/check.cfg` and in AGENTS.md › Project facts.
  - **SaaSAllTheThings.** An `infra/env/<env>.bicepparam` file for the environment, with no `PLACEHOLDER` that the deploy needs.

## What you need to do

1. **Run `/release` with a target.**
   - **Godot-Director:** `uat` (the default) or `production`, and optionally one preset, such as `/release uat Web`.
   - **App-Director:** `web`, `mobile` or `desktop`.
   - **SaaSAllTheThings:** `dev` (the default) or `prod`. Dev deploys from `main`, and prod deploys from a tag.
2. **Check what the release contains.** App-Director and SaaSAllTheThings list the `done` items since the last release tag. In SaaSAllTheThings, a breaking contract change without its next version side by side stops the release.
3. **Review the dry run.** Nothing is uploaded or deployed before you see what will happen.
   - **Godot-Director** exports the presets with `/export`, then shows the commands that `tools/release.sh uat --dry-run` would run.
   - **App-Director** builds for the target and checks the output.
   - **SaaSAllTheThings** runs a what-if of the Bicep for the environment, with your approval, and summarises what it creates, changes and deletes. Anything deleted, or anything outside this app's resources, stops the run and comes to you.
4. **Approve the shipping step.**
   - **Godot-Director** uploads each preset with its `uat` command. Production needs you to ask for the promotion in the request, a passing UAT upload of the same commit and your yes. If the environment lacks the production credentials, you get the exact command to run.
   - **App-Director** deploys web targets by the method AGENTS.md names, such as Vercel, Netlify or GitHub Pages. For mobile and desktop, the agent stops at a prepared build, and you submit it to the store.
   - **SaaSAllTheThings** deploys dev with your approval at each Azure step. For prod, you run the pipeline or the commands, and the agent hands you the what-if summary.
5. **Read the smoke test.** App-Director walks the primary core flow once after a web deploy. SaaSAllTheThings checks `GET /api/health` on each function app and, if the environment has a test tenant, one read as a test user. A failed smoke test is a `high` bug. Godot-Director reports each preset's command and result instead.
6. **Keep the record.** App-Director tags the commit `v<version>`, SaaSAllTheThings tags a prod release `v<YYYY.MM.DD>`, and both push the tag only when you ask. In Godot-Director, the report is the record, and nothing is written to `TASKS.md`.

## Caveats

- **A missing secret stops Godot-Director before anything is uploaded.** The agent names the secrets to set. They come from your CI's secrets or your own shell, never from the repo or the chat.
- **Some things never run.** SaaSAllTheThings never runs a complete-mode deployment and never deletes resources.
- **Manual outcomes go to the next check.** The `(demo)` outcomes now released go into the next [acceptance check](acceptance.md), with the environment they were deployed to.
- **CI can run the same steps.** Godot-Director's GitHub Actions template exports on every push, uploads to UAT on `main`, and runs production as a job you start by hand, which waits for your approval in a protected GitHub Environment. Any other CI can run the export and then `tools/release.sh uat`.

## More

- The [`/release` skill page](../skills/release.md), with what is unique to each framework.
- The procedures, which are the source of truth for the steps: [Godot-Director v3.11.0](https://github.com/Freakling/Godot-Director/tree/v3.11.0/framework/.godot-director/procedures/release.md), [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/release.md) and [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/release.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>The check gates the build, and you gate the release.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
