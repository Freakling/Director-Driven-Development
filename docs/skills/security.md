# /security

<div class="kicker">The build against the OWASP baseline, read by a fresh reader</div>

> It finds and proposes; you decide. It changes no code, and it never says a category is met because a tool passed.

`/security` runs a security assessment of what is built, against the OWASP baseline the framework sets. App-Director and SaaSAllTheThings ship it; Godot-Director doesn't. The skill follows the security procedure of its repository, which is the source of truth.

How to use it: [Is what was built secure?](../how-to/security.md) A release runs it first, as [How do I ship it?](../how-to/ship.md) describes. The baseline is described on the [App-Director](../frameworks/app-director.md#the-owasp-baseline) and [SaaSAllTheThings](../frameworks/saasallthethings.md#the-owasp-baseline) pages.

## What runs

1. **Tools first.** The repository's tools run, and each one that isn't installed is skipped with a note; nothing is installed without asking you. The dependency audits for the manifests found come first, then the check's own rules, then Semgrep with the OWASP rules when it is installed. Each tool gets one line: clean, findings, skipped, or couldn't run, with the reason.
2. **A fresh-context review.** A reviewer in a fresh context goes through the repository's OWASP checklist category by category, reads the code and configuration behind each check, and judges it: holds, broken, not applicable, or not checkable here. A tool's clean line is evidence for a check, never the whole answer.
3. **Never a secret.** A secret is named by file, line and kind only. The evidence, the report and the bug items never quote it or the line that holds it.

## What comes out

- **Bug items** in `TASKS.md`, one per finding, each naming the OWASP item, the evidence and a proposed fix. High findings go to the front of the queue, and a finding that already has an open item gets no second one.
- **People and process items** for you: what the repository can't show, such as access reviews, incident response, alert routing and key rotation. You say which to track, and each becomes a task for a human.
- **A dated report** with a line per category and a closing section on what a clean run doesn't prove.

## When it runs

- On request: say "run a security assessment", or type `/security`.
- Before a release is proposed. An open high bug that names an OWASP item blocks the release, unless an accepted decision deviates from that item.
- When `/next-task` proposes it: none has run yet, or enough items have been built since the last report (10 by default, set under `[security]` in `tools/check.cfg`). You can decline, and a run of several items only names it in its final report.

## What a clean run doesn't prove

A category is verified only for the checks in the checklist, read in that commit. The tools find only known issues they have rules for. Nothing in it tests the running app, the hosting or the people and process items, and a category marked not checkable here is unknown, not met.

## Unique per repo

### App-Director

The procedure is at [`framework/.app-director/procedures/security.md`](https://github.com/Freakling/App-Director/tree/v1.12.0/framework/.app-director/procedures/security.md) in the App-Director repository.

- `bash tools/security.sh` runs the tools: the dependency audit of the manifests it finds (npm, pnpm, yarn, pip-audit on fully pinned requirements, dotnet, and `flutter pub outdated` as information only), the check's secrets scan and UI purity step, and Semgrep.
- The report is `product/security/YYYY-MM-DD.md`. It covers the OWASP Top 10 (2025), and the OWASP API Security Top 10 (2023) when the app serves an API.
- The accepted deviations it reads are the lines of `product/decisions.md` that name an OWASP item.
- `bash tools/security.sh --due` says whether an assessment is due.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/security.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.1/framework/.satt/procedures/security.md) in the SaaSAllTheThings repository.

- The tools are the check's architecture rules, the .NET, npm and pinned pip dependency audits, Semgrep, and the CI workflow's dependency review and SBOM when `gh` is signed in. It never calls Azure, and the dependency audits send package names and versions to public advisory databases, never code.
- The report is `assessment/security/YYYY-MM-DD.md`, and the accepted deviations it reads are the ADRs that name an OWASP item.
- It also brings the `OWASP A01` to `OWASP A10` rows of `compliance/mapping.md` up to date: a row is never `direct` from a tool alone. Rows of your own control framework stay as they are; the report names the ones a finding touches.
- A finding that needs an architecture call is offered as an `/architect` session.

<div class="takeaway"><span>A clean report says what was read, not that the app is secure.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
