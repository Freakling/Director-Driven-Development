# The system was not built as I intended

<div class="kicker">A principle has been built two ways, and patching won't hold</div>

> Start a design drift reset. The agent describes the project as built, you rewrite the design where it splits, and the rebuild runs as ordinary tasks. Only you start one.

## Short answer

- **For a one-off mismatch,** run `/align` first. It is the routine pass: see [The records and the code don't agree](align.md).
- **When one principle is built two ways,** or a settled conflict keeps coming back, run `/drift-reset`. All three frameworks ship it, and `/drift-reset postmortem` closes the reset after the rebuild.
- **The agent never starts a reset.** `/align` can recommend one. Starting it is your decision.

## Related

- The [`/drift-reset` skill page](../skills/drift-reset.md), with each framework's scope and where the reset folder goes.
- The concept [Align and drift reset](../concept/drift.md).
- The procedures: [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/drift-reset.md), [App-Director](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/drift-reset.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/drift-reset.md).

<div class="takeaway"><span>Align often, reset when you have to.</span><span class="url"><a href="index.md">All questions</a></span></div>
