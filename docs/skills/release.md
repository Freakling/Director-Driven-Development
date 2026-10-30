# /release

<div class="kicker">A checked build, shipped where the human says</div>

> Nothing ships without the check, and anything that reaches users or production waits for your yes.

`/release` takes the game, app or service from a passing check to the target the request names. Each framework runs it against its own target: a platform, an upload stage, or an environment. The skill follows the release procedure of its repository, which is the source of truth.

How to use it: [How do I ship it?](../how-to/ship.md)

## What it does

1. **Ready?** The working tree is clean and `bash tools/check.sh` passes. A failing check stops the release, since a build that fails the check isn't worth shipping.
2. **Prepare the target.** The build, export or deployment plan is prepared for the target the request names, such as a platform, a UAT stage or an environment. The human sees a dry run, a build or a what-if before anything is uploaded or deployed.
3. **Ship with approval.** The step that reaches users, or uses credentials or a production environment, waits for the human's request and approval. Store submissions and production credentials stay with the human.
4. **Smoke test** where the repository's procedure asks for one, and report anything that failed.
5. **Record** the release as the repository's procedure says. The records differ by framework, so see each section below.

Each framework reports what ran and the result of each step.

## Unique per repo

### App-Director

The procedure is at [`framework/.app-director/procedures/release.md`](https://github.com/Freakling/App-Director/tree/v1.12.2/framework/.app-director/procedures/release.md) in the App-Director repository.

- The request names the target: `web`, `mobile` (iOS or Android) or `desktop`. The stack and deploy method are in `tools/check.cfg` and AGENTS.md › Project facts.
- The skill lists the `done` items since the last release tag, so the release says what it contains. A `high` bug that's done without a regression test goes into the next acceptance check.
- Before it proposes the release, it runs a [`/security`](security.md) assessment when none exists yet or something was built since the last report. An open `high` bug that names an OWASP item blocks the release, unless an accepted decision in `product/decisions.md` deviates from that item.
- Web targets deploy with the method AGENTS.md names (Vercel, Netlify, GitHub Pages or another), and a smoke test follows. Mobile and desktop targets stop at a prepared build; the human submits it to the store.
- The release is recorded with a `v<version>` tag on the commit, pushed when the human asks. The `(demo)` outcomes go into the next acceptance check.

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/release.md`](https://github.com/Freakling/Godot-Director/tree/v4.6.2/framework/.godot-director/procedures/release.md) in the Godot-Director repository.

- Godot Director knows no store. `release.cfg` in the project root has one section per export preset, with a `uat` command, an optional `production` command and the names of the secrets the commands read. Only names are in the file, never values.
- The request names the stage, `uat` (the default) or `production`, and optionally one preset. The skill exports with [`/export`](../frameworks/godot-director.md), shows a dry run, then runs `tools/release.sh uat`.
- Production needs the request to promote, a passing UAT upload of the same commit and your yes. The production commands belong to you: if the environment lacks their credentials, the skill gives you the exact command.
- A missing secret stops the run before anything is uploaded, and the skill names the secrets to set. They come from the CI's secrets or your own shell.
- A release writes nothing to TASKS.md; the report is the record.
- The GitHub Actions template exports every preset on each push and pull request, uploads to UAT on `main`, and runs production as a job you start by hand, which waits for approval in a protected GitHub Environment. Any other CI can run the export and then `tools/release.sh uat`.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/release.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.3/framework/.satt/procedures/release.md) in the SaaSAllTheThings repository.

- The request names the environment, `dev` (the default) or `prod`. Dev deploys from `main`; prod deploys from a tag.
- Before it proposes the release, it runs a [`/security`](security.md) assessment when none exists yet or something was built since the last report. An open `high` bug that names an OWASP item blocks the release, unless an accepted ADR deviates from that item.
- Every step that touches Azure needs your approval, each time. The skill runs a what-if of the Bicep for the environment's resource group and summarises what it creates, changes and deletes. A deletion, or anything outside this app's resources, stops the run.
- A complete-mode deployment and resource deletion are never run. Production is yours to run: the skill prepares everything and hands over the pipeline run or the commands, with the what-if summary.
- The smoke test checks `GET /api/health` on each function app and, when the environment has a test tenant, one read as a test user.
- A prod release is tagged `v<YYYY.MM.DD>` after your approval, and the tag is pushed only when you ask. The release record names the CI run and its artifact (or the local check result when the app has no workflow) and the security report. The `(demo)` outcomes now deployed go into the next acceptance check, with their environment.

<div class="takeaway"><span>The check gates the build, and you gate the release.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
