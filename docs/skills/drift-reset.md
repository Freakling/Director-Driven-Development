# /drift-reset

<div class="kicker">Reset the design, only when patching won't hold</div>

`/drift-reset` rebuilds shared understanding when a design principle has been built two or more ways. The director starts it, on a branch of its own. It describes the project as built, maps how each principle was read, has the director rewrite the design where it splits, and plans the rebuild as ordinary tasks. A later `/drift-reset postmortem` checks whether the drift is gone. The concept behind it is on [Align and drift reset](../concept/drift.md).

## What it does

1. **Analyse as built.** Each area of the project is read in a fresh, read-only context, and the findings cite file and line. The output is a record of how the project behaves today, not how the design says it should.
2. **Map interpretations.** Each principle is classed as consistent, divergent or contradictory. Each one that isn't consistent gets a failure mode: what went wrong, and what would have shown it earlier.
3. **Rewrite the design.** The director answers one design call per divergent or contradictory principle, using the same options-and-recommendation format as `/design`. Only the chosen readings are recorded. The old design is kept beside the new one.
4. **Plan the rebuild.** Each difference from the approved design becomes a task. This step writes no code. The rebuild runs through [`/next-task`](next-task.md).
5. **Postmortem**, run after the rebuild items are done. Each failure mode is checked again: fixed, or still drifting. Drift that a script could catch becomes a proposed check, for the director to approve.

Each step is committed after the director approves it. Nothing in a reset discards work or rewrites history, and the reset folder only grows. A later reset gets its own folder.

## Unique per repo

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/drift-reset.md`](https://github.com/Freakling/Godot-Director/tree/main/framework/.godot-director/procedures/drift-reset.md) in the Godot-Director repository.

- The branch is `reset-YYYY-MM-DD`, and the reset folder is `design/resets/YYYY-MM-DD/`.
- The areas are one per row of the Architecture table, plus the screens, merged down to about six.
- The evidence includes the playtest reports and function checks under `playtesting/`.
- Human-owned areas, such as art, audio and tunable values, are never rewritten. A tunable value that is part of the drift becomes a design call.
- The postmortem proposes either a test under `tests/` or a pattern for `[screens] forbidden` in `tools/check.cfg`.

### App-Director

The procedure is at [`framework/.app-director/procedures/drift-reset.md`](https://github.com/Freakling/App-Director/tree/main/framework/.app-director/procedures/drift-reset.md) in the App-Director repository.

- The branch is `drift-reset-YYYY-MM-DD`, and the reset folder is `product/resets/YYYY-MM-DD/`. The working tree must be clean before it starts.
- The analysis looks for business rules in the UI folders named in `[ui] dirs`, since logic there is a common source of different readings.
- The old brief is kept as `brief-before.md`. If the ownership table makes the brief human-owned, the draft goes to `brief-proposal.md` for the director to apply.
- The postmortem proposes check rules for `tools/check.local.sh` or `tools/check.cfg`.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/drift-reset.md`](https://github.com/Freakling/SaaSAllTheThings/tree/main/framework/.satt/procedures/drift-reset.md) in the SaaSAllTheThings repository.

- The scope is the product design the director owns: the Product Pillars, the PRD, the decision log and the business rules in integration contracts. The architecture is out of scope. A framework rule that conflicts with the product goes through `/architect` and an ADR, and an accepted ADR is never dropped without a new one.
- Tenancy and identity is always its own area. A finding there is marked as a security finding and becomes a high-severity bug, not a design call.
- The branch is `reset/YYYY-MM-DD`, and the reset folder is `resets/YYYY-MM-DD/`.
- The rebuild items put security fixes first, then contracts and stored schemas, then the rest as slices. The last item is a human task to run the postmortem.
- The postmortem repeats the tenancy analysis, and project-specific checks go in `tools/check.local.sh`. A check the framework itself needs is recorded as a gap for the framework, not patched locally.

<div class="takeaway"><span>Align often, reset when you have to. Start a reset only when you are ready to rebuild.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
