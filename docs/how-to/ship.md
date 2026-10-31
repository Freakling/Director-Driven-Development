# How do I ship it?

<div class="kicker">A checked build, shipped where you say</div>

> Say "Release to dev" or type `/release` with a target. Nothing ships without the check, and anything that reaches users or production waits for your yes.

All three frameworks ship `/release`, and each releases to its own kind of target: App-Director to web, mobile or desktop, Godot-Director to a platform's test or production channel, and SaaSAllTheThings to an Azure environment. Godot-Director also ships `/export`.

## Two ways to do it

**Export a build to look at.** Godot-Director only. Say "Export the game" or "Make a Web build", or type `/export`. It exports every export preset headless into the gitignored `builds/` folder and reports what it produced. It changes no source file, commits nothing and does not run the check. The export templates for your Godot version must be installed, and the agent tells you how if they aren't.

**Release.** Say "Release to web" (App-Director), "Release the game", "Push a build to UAT" or "Promote to production" (Godot-Director) or "Release to dev" (SaaSAllTheThings), or type `/release <target>`. Saying it and typing the command run the same procedure. The release exports or builds, shows you what it will do, and ships only after your yes.

The stricter path is to let CI run the same steps, which pays off once you release often. Godot-Director's GitHub Actions template exports on every push, uploads to UAT from `main`, and runs production as a job you start by hand, which waits for your approval in a protected GitHub Environment. Any other CI can run the export and then `tools/release.sh uat`.

## Steps

1. **Get ready.** The release needs a clean working tree and a passing `bash tools/check.sh`. Production credentials stay with you, and so do store submissions. Where the agent can't run a step, it hands you the exact command. Set up first:
    - App-Director: the stack and the deploy method, in `tools/check.cfg` and in AGENTS.md › Project facts.
    - Godot-Director: a `release.cfg` in the project root, with one section per export preset: a `uat` command, an optional `production` command and the names of the secrets they read. Only names go in the file, never values. If you skipped the release setup, `/design` on its open question runs it.
    - SaaSAllTheThings: an `infra/env/<env>.bicepparam` file for the environment, with no `PLACEHOLDER` that the deploy needs.
2. **Name the target.**
    - App-Director: `web`, `mobile` or `desktop`.
    - Godot-Director: `uat` (the default) or `production`, and optionally one preset, such as `/release uat Web`.
    - SaaSAllTheThings: `dev` (the default) or `prod`. Dev deploys from `main`, and prod deploys from a tag.
3. **Check what the release contains.** App-Director and SaaSAllTheThings list the `done` items since the last release tag. In SaaSAllTheThings, a breaking contract change without its next version side by side stops the release.
    - App-Director and SaaSAllTheThings also run a [`/security`](../skills/security.md) assessment before proposing the release, when none exists yet or something was built since the last one. An open high bug that names an OWASP item stops the release, unless an accepted decision deviates from that item.
4. **Review the dry run.** Nothing is uploaded or deployed before you see what will happen.
    - App-Director builds for the target and checks the output.
    - Godot-Director exports the presets with `/export`, then shows the commands that `tools/release.sh uat --dry-run` would run.
    - SaaSAllTheThings runs a what-if of the Bicep for the environment, with your approval, and summarises what it creates, changes and deletes. Anything deleted, or anything outside this app's resources, stops the run and comes to you.
5. **Approve the shipping step.**
    - App-Director deploys web targets by the method AGENTS.md names, such as Vercel, Netlify or GitHub Pages. For mobile and desktop, the agent stops at a prepared build, and you submit it to the store.
    - Godot-Director uploads each preset with its `uat` command. Production needs you to ask for the promotion in the request, a passing UAT upload of the same commit and your yes. If the environment lacks the production credentials, you get the exact command to run.
    - SaaSAllTheThings deploys dev with your approval at each Azure step. For prod, you run the pipeline or the commands, and the agent hands you the what-if summary.
6. **Read the smoke test.** App-Director walks the primary core flow once after a web deploy. SaaSAllTheThings checks `GET /api/health` on each function app and, if the environment has a test tenant, one read as a test user. A failed smoke test is a `high` bug. Godot-Director reports each preset's command and result instead.
7. **Keep the record.** App-Director tags the commit `v<version>`, SaaSAllTheThings tags a prod release `v<YYYY.MM.DD>`, and both push the tag only when you ask. In Godot-Director, the report is the record, and nothing is written to `TASKS.md`.

## What can go wrong

- **A failing check stops the release.** Fix it first, as in [How do I get things built?](build.md)
- **A missing secret stops Godot-Director before anything is uploaded.** The agent names the secrets to set. They come from your CI's secrets or your own shell, never from the repo or the chat.
- **Some things never run.** SaaSAllTheThings never runs a complete-mode deployment and never deletes resources.
- **Manual outcomes go to the next check.** The `(demo)` outcomes now released go into the next acceptance check, with the environment they were deployed to (see [How do I check that what was built works?](check.md)).

## Related

- The [`/release` skill page](../skills/release.md), and the [Godot-Director page](../frameworks/godot-director.md#commands) for `/export`.
- The procedures: [Godot-Director `/release`](https://github.com/Freakling/Godot-Director/tree/v4.7.0/framework/.godot-director/procedures/release.md) and [`/export`](https://github.com/Freakling/Godot-Director/tree/v4.7.0/framework/.godot-director/procedures/export.md), [App-Director](https://github.com/Freakling/App-Director/tree/v1.12.3/framework/.app-director/procedures/release.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.5/framework/.satt/procedures/release.md).

<div class="takeaway"><span>The check gates the build, and you gate the release.</span><span class="url"><a href="index.md">All questions</a></span></div>
