# The records and the code don't agree

<div class="kicker">The routine pass that catches drift while it is small</div>

> Say "Check the docs are aligned", or type `/align`. The agent checks that the design, the decisions, the queue, the settings and the code still agree, fixes what is mechanical and lists what needs you.

All three frameworks ship `/align`: App-Director, Godot-Director and SaaSAllTheThings. Nothing to install: run it in Claude Code, in the project where the framework is installed.

## Short answer

- **Run it after a big design change,** after installing or upgrading a framework, before closing a milestone, and every so often between milestones. Over time the design text, the decision log, `TASKS.md`, `AGENTS.md`, the settings and the code drift apart in small ways, and the pass finds the differences early.
- **It never changes the design.** It fixes mechanical drift, such as an item missing a size or a dependency that points nowhere, and brings anything that needs a design call back to you with a recommendation.
- **If a conflict returns,** or one conflict spans several principles, the agent recommends a reset instead of another patch: see [The system was not built as I intended](drift.md).

## Two ways to do it

**By talking.** Say "Check the docs are aligned", "Review the docs" or "Make sure the tasks are aligned". The agent runs the pass.

**With the skill.** Type `/align`.

Saying it and typing the command run the same procedure. The explicit command pays off when you want a repeatable pass at a known moment, such as before a milestone closes. The fixes are committed as `docs: align`, which makes each pass a record you can find in the history. App-Director also names the conflicts that need you in the commit body, which is how the next pass tells a repeat.

## Steps

1. **Run it.** The agent works through its checks without asking you anything.
    - No unfilled template placeholder is left, and the entry files point to the right place.
    - Item IDs are unique, dependencies exist, and each item for the agent has a size, the files it touches, tagged outcomes and a link to the design text. Claims on items from an earlier day are reported.
    - Every rule in the design is built, planned or reported as a gap, and every row of the architecture table points at something that exists.
    - The whole design document is read, and every statement of state in it (a section marked later or planned, a count, a list of what exists, a line saying work waits on something) is checked against the built product, the done items and the latest releases.
    - Every decision recorded since the last `docs: align` commit is checked one by one, to see that the design text reflects it and no older text contradicts it.
    - The check passes, and the lines the installer added to `.gitignore` and `.gitattributes` are still there.
2. **Read the report.** It lists what the agent fixed and what needs you, and names each stale statement it found in the design text. A statement whose fact is settled, such as a section marked planned for an item that is done, is fixed for you. One whose fix is a design call comes to you. Each item that needs you comes with one recommendation. Decide each one: accept the recommendation, choose differently, or leave it for now.
3. **Take design gaps to a design session.** A rule in the design that nothing builds is reported, not turned into an item for you. Decide which gaps become tasks, then run [`/design`](decide.md) if a call is needed.
4. **Approve the commit.** The fixes are committed as `docs: align` once you say yes. During onboarding, the fixes go into the install commit instead.
5. **Act on a reset recommendation.** If a conflict has come back after it was settled, or one conflict spans several principles, the agent recommends `/drift-reset` instead of another patch. It never starts one itself. Starting it is your decision.

## What can go wrong

- **A failing check shows up in the report.** `bash tools/check.sh` is part of the pass.
- **A missing installer line has a one-step fix.** If the `.gitignore` or `.gitattributes` lines that `install.sh` adds are gone, rerun the installer.
- **Align reports gaps, it doesn't plan them.** You decide which gaps become items.
- **Framework differences.**
    - App-Director: it checks the brief, `product/decisions.md` and the check config. The `[ui] dirs` and `[data] dirs` in `tools/check.cfg` must match your folders, and each item's `Brief:` value must be an existing heading. If the app has a screen catalog (`tools/ui/screens.mjs`), it also lists screens with no catalog entry, specs that name something missing from the source, drawings that changed since they were processed, and `UI:` fields that point at no spec. None of that fails the pass.
    - Godot-Director: it checks the GDD, `design/decisions.md` and `project.godot` against `AGENTS.md`. Every autoload and rule folder needs an architecture row, and every screen in the `[screens] known` list in `tools/check.cfg` needs an open item that removes it. It counts the `## PLACEHOLDER` values and writes the number into the Content & balance milestone. If the game has a UI catalog, it also lists screens with no catalog entry, specs that name something missing, and drawings that changed since they were processed. None of that fails the pass.
    - SaaSAllTheThings: it checks the PRD, the ADRs and the integration contracts, and runs `bash tools/check.sh --architecture`. It reports stale ADR exceptions, proposed ADRs waiting more than a week and workshop notes with no `Processed:` line, and counts the undecided values. If the product has a screen catalog (`tools/ui/screens.mjs`), it also lists the same screen gaps as App-Director, none of which fails the pass. It never changes the product or the architecture.

## Related

- The [`/align` skill page](../skills/align.md), with what the pass checks in each framework, and the concept [Align and drift reset](../concept/drift.md).
- When the pass keeps finding the same conflict: [The system was not built as I intended](drift.md).
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.8.0/framework/.app-director/procedures/align.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.2.1/framework/.godot-director/procedures/align.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.10.0/framework/.satt/procedures/align.md).

<div class="takeaway"><span>Run it after every big design change and catch the drift while it is small.</span><span class="url"><a href="index.md">All questions</a></span></div>
