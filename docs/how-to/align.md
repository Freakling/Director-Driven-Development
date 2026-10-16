# Check consistency with /align

<div class="kicker">The routine pass that catches drift while it is small</div>

> The agent checks that the design, the decisions, the queue, the settings and the code still agree, fixes what is mechanical and lists what needs you.

This guide is for someone who has never run `/align`. All three frameworks ship it: Godot-Director, App-Director and SaaSAllTheThings. The [skill page](../skills/align.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** Over time the design text, the decision log, `TASKS.md`, `AGENTS.md`, the settings and the code drift apart in small ways. `/align` finds those differences early. It is the small counterpart to [`/drift-reset`](drift-reset.md).
- **What it changes.** It fixes mechanical drift, such as an item missing a size or a dependency that points nowhere. It never changes the design. Anything that needs a design call comes back to you.
- **When to run it.** Run it after a big design change, after installing or upgrading a framework, and every so often between milestones.
- **Nothing to install.** The command comes with the framework. Run it in Claude Code, in the project where the framework is installed.

## What you need to do

1. **Run `/align`.** The agent works through its checks without asking you anything.
   - No placeholder is left unfilled, and the entry files point to the right place.
   - Item IDs are unique, dependencies exist, and each item for the agent has a size, the files it touches, tagged outcomes and a link to the design text. Claims on items from an earlier day are reported.
   - Every rule in the design is built, planned or reported as a gap, and every row of the architecture table points at something that exists.
   - Recent decisions are reflected in the design text, the check passes, and the git lines the installer added are still there.
2. **Read the report.** It lists what the agent fixed and what needs you. Each item that needs you comes with one recommendation. Decide each one: accept the recommendation, choose differently, or leave it for now.
3. **Take design gaps to a design session.** A rule in the design that nothing builds is reported, not turned into an item for you. Decide which gaps become tasks, then run [`/design`](design.md) if a call is needed.
4. **Approve the commit.** The fixes are committed as `docs: align` once you say yes. The conflicts that need you are named in the commit body, so the next pass can tell a repeat. During onboarding, the fixes go into the install commit instead.
5. **Act on a reset recommendation.** If a conflict has come back after it was settled, or one conflict spans several design principles, the agent recommends [`/drift-reset`](drift-reset.md) instead of another patch. It never starts one itself. Starting it is your decision.

Differences in what it checks:

- **Godot-Director.** It checks the GDD, `design/decisions.md` and `project.godot` against `AGENTS.md`. Every autoload and rule folder needs an architecture row, and every screen in the `[screens] known` list in `tools/check.cfg` needs an open item that removes it.
- **App-Director.** It checks the brief, `product/decisions.md` and the check config. The `[ui] dirs` and `[data] dirs` in `tools/check.cfg` must match your folders, and each item's `Brief:` value must be an existing heading.
- **SaaSAllTheThings.** It checks the PRD, the ADRs and the integration contracts, and runs `bash tools/check.sh --architecture`. It reports stale ADR exceptions, proposed ADRs waiting more than a week and workshop notes with no `Processed:` line. It never changes the product or the architecture.

## Caveats

- **The check is part of the pass.** `bash tools/check.sh` must pass, so a failing check shows up in the report.
- **A missing installer line has a one-step fix.** If the `.gitignore` or `.gitattributes` lines that `install.sh` adds are gone, rerun the installer.
- **Align reports gaps, it doesn't plan them.** You decide which gaps become items.
- **Repeats are recognised.** Because the commit body names each conflict that needs you, a conflict that returns is spotted and leads to a reset recommendation.

## More

- The [`/align` skill page](../skills/align.md), with what is unique to each framework, and the concept page [Align and drift reset](../concept/drift.md).
- The procedures, which are the source of truth for the steps: [Godot-Director v3.12.0](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/align.md), [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/align.md) and [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/align.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>Run it after every big design change and catch the drift while it is small.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
