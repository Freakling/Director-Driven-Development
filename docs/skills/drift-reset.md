# /drift-reset

<div class="kicker">Reset the design, only when patching won't hold</div>

`/drift-reset` rebuilds shared understanding when a design principle has been built two or more ways. The director starts it, on a branch of its own. It describes the project as built, maps how each principle was read, has the director rewrite the design where it splits, and plans the rebuild as ordinary tasks. A later `/drift-reset postmortem` checks whether the drift is gone. The concept behind it is on [Align and drift reset](../concept/drift.md).

## What it does

1. **Analyse as built.** Each area of the project is read in a fresh, read-only context, and the findings cite file and line. The output is a record of how the project behaves today, not how the design says it should.
2. **Map interpretations.** Each principle is classed as consistent, divergent or contradictory. Each one that isn't consistent gets a failure mode: what went wrong, and what would have shown it earlier.
3. **Rewrite the design.** The director answers one design call per divergent or contradictory principle, using the same options-and-recommendation format as `/design`. Only the chosen readings are recorded. The old design is kept beside the new one.
4. **Plan the rebuild.** Each difference from the approved design becomes a task. This step writes no code. The rebuild runs through [`/next-task`](next-task.md).
5. **Postmortem**, run after the rebuild items are done. Each failure mode is checked again: fixed, or still drifting. Drift that a script could catch becomes a proposed check, for the director to approve.

Only the human starts a reset, and nothing in a reset writes application code. Each step is committed after the director approves it. Nothing in a reset discards work or rewrites history, and the reset folder only grows. A later reset gets its own folder.

## Unique per repo

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/drift-reset.md`](https://github.com/Freakling/Godot-Director/tree/v3.8.0/framework/.godot-director/procedures/drift-reset.md) in the Godot-Director repository.

- The branch is `reset-YYYY-MM-DD`, and the reset folder is `design/resets/YYYY-MM-DD/`. A second reset on the same day adds `-2`.
- Everything the reset writes goes in the reset folder, except the GDD and `design/decisions.md`, which change at the design step, and TASKS.md, which changes at the plan and postmortem steps. Nothing in the reset folder is deleted or rewritten; a correction is a new section.
- The areas are one per row of the Architecture table, plus the screens, merged down to about six.
- The evidence includes the playtest reports and function checks under `playtesting/`.
- Human-owned areas, the ones AGENTS.md gives to the human such as art, audio and tunable values, are never rewritten. A tunable value that is part of the drift becomes a design call, and the human edits the `.tres` file.
- The analysis looks for rules the check can't catch: logic in screens that is neither randomness nor an autoload write, rules without a test in `tests/`, and values hard-coded in place of values read from a `.tres` file.
- Git follows the rules in `rules.md`: no destructive commands. Each step's files are committed after approval, as `docs: drift reset <step> (YYYY-MM-DD)`.
- The postmortem proposes either a test under `tests/` or a pattern for `[screens] forbidden` in `tools/check.cfg`.

### App-Director

The procedure is at [`framework/.app-director/procedures/drift-reset.md`](https://github.com/Freakling/App-Director/tree/v1.5.0/framework/.app-director/procedures/drift-reset.md) in the App-Director repository.

- The branch is `drift-reset-YYYY-MM-DD`, and the reset folder is `product/resets/YYYY-MM-DD/`. The working tree must be clean before it starts. If it isn't, the director decides what happens to the changes first.
- No destructive git commands are used. The reset never discards work or rewrites history, and the git rules are in `rules.md`.
- "Contradictory" means the principle is built in a way the brief rules out, or the brief contradicts itself or `product/decisions.md`. "Divergent" means it is read two or more ways in different places.
- The analysis looks for business rules in the UI folders named in `tools/check.cfg` under `[ui] dirs`, since logic there is a common source of different readings.
- The old brief is kept as `brief-before.md`. If the ownership table makes the brief human-owned, the draft goes to `brief-proposal.md` for the director to apply.
- The postmortem proposes check rules for `tools/check.local.sh` or `tools/check.cfg`.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/drift-reset.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/drift-reset.md) in the SaaSAllTheThings repository.

- The scope is the product design the director owns: the Product Pillars, the PRD, the decision log and the business rules in integration contracts. The architecture is out of scope. A framework rule that conflicts with the product goes through `architect.md` and an ADR, and an accepted ADR is never dropped without a new one.
- "Contradictory" means the build contradicts the text, or two texts contradict each other, such as the PRD and `product/decisions.md`, or the PRD and a contract. "Divergent" means the principle is built two or more ways, each defensible from the text.
- Tenancy and identity is always its own area. Drift there is a security finding, not a design one: it is marked `security`, the director is told at once, and it becomes a high-severity bug. The reference already settles it, in `reference/tenancy.md` and `reference/identity.md`, so it is never a design call.
- The analysis is written to `resets/YYYY-MM-DD/as-built.md`, one section per area, with each statement carrying its `file:line`.
- ADR compliance is a gate. If an accepted ADR isn't honoured, the reset stops and follows `architect.md`. Complying is option one, and a new ADR stays proposed until the director accepts it.
- The rebuild items put security fixes first, as high bugs that cite `resets/YYYY-MM-DD/as-built.md`, then contracts and stored schemas, then the rest as slices. Anything `L` or bigger is split, as `.satt/tasks.md` sets out. The last item is a human task to run the postmortem.
- The branch is `reset/YYYY-MM-DD`, and the reset folder is `resets/YYYY-MM-DD/`.
- The postmortem repeats the tenancy analysis, and project-specific checks go in `tools/check.local.sh`. A check the framework itself needs is recorded as a gap for the framework, not patched locally.
- At the end, the director starts the rebuild in a fresh session: `/clear`, then `/next-task`.

<div class="takeaway"><span>Align often, reset when you have to. Start a reset only when you are ready to rebuild.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
