# Is what was built secure?

<div class="kicker">A security assessment of the build, then your call on each finding</div>

> Say "run a security assessment" or type `/security`. The agent runs the tools, has a fresh reader judge the build against the OWASP baseline, and gives you bug items, a list for your people and process, and a dated report. App-Director and SaaSAllTheThings ship it; Godot-Director doesn't.

An assessment finds and proposes, and you decide. It changes no code. This page covers what you do around a run; what the skill reads and how it judges is on the [`/security` skill page](../skills/security.md).

## When to run it

- **On request.** Say "run a security assessment", or type `/security`, for example before you show the build to a customer.
- **When `/next-task` proposes it.** It proposes one when none has run yet, or when enough items have been built since the last report (10 by default, set under `[security] every` in `tools/check.cfg`). You can decline. In a run of several items it only names the assessment in its final report.
- **Before a release.** `/release` runs one when none exists or something was built since the last report, as in [How do I ship it?](ship.md)

## Steps

1. **Run it.** The tools run first, and any that isn't installed is skipped with a note; nothing is installed without your yes. A fresh reader then goes through the OWASP checklist category by category.
2. **Read the report.** It is dated, with a line per category: `product/security/YYYY-MM-DD.md` in App-Director, `assessment/security/YYYY-MM-DD.md` in SaaSAllTheThings. Read the closing section first, on what the run doesn't prove.
3. **Decide what to do with each result.**
    - **Bug items** are in `TASKS.md`, one per finding, with the OWASP item, the evidence and a proposed fix. High findings are at the front of the queue, so "Do the next task" fixes them first. A fix that needs an architecture call comes to you as an `/architect` session in SaaSAllTheThings.
    - **People and process items** are what the repository can't show, such as access reviews, incident response and key rotation. Tell the agent which to track, and each becomes a task for a person.
    - **The report** is the record. Keep it with the release.
4. **Accept a deviation only on purpose.** An open high bug that names an OWASP item blocks a release unless an accepted decision deviates from that item. In App-Director that is a line in `product/decisions.md` naming the item and why, which you add in a [design session](decide.md). In SaaSAllTheThings it is an ADR that names the item, which you accept after an `/architect` session. Fixing the bug is the other way through.

## What a clean run doesn't prove

A clean report says what was read in that commit, not that the app is secure. It doesn't test the running app, the hosting or your people and process, and a category marked not checkable here is unknown, not met. Treat it as one input to your own review, and bring anything with real exposure to a person who does this for a living.

## What can go wrong

- **A tool is skipped.** The report says which and why. Install it and run the assessment again to cover that part.
- **No secrets in the report.** A secret is named by file, line and kind only, so the report is safe to share. Rotate any secret it names.
- **Godot-Director has no `/security`.** The skill and the baseline are in App-Director and SaaSAllTheThings only.

## Related

- The [`/security` skill page](../skills/security.md), and the OWASP baseline on the [App-Director](../frameworks/app-director.md#the-owasp-baseline) and [SaaSAllTheThings](../frameworks/saasallthethings.md#the-owasp-baseline) pages.
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.12.2/framework/.app-director/procedures/security.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.3/framework/.satt/procedures/security.md).

<div class="takeaway"><span>Run it before you release, fix the high findings first, and accept a deviation only on purpose.</span><span class="url"><a href="index.md">All questions</a></span></div>
