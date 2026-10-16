# The records and the code don't agree

<div class="kicker">The routine pass that catches drift while it is small</div>

> Say "Check the docs are aligned", or type `/align`. The agent checks that the design, the decisions, the queue, the settings and the code still agree, fixes what is mechanical and lists what needs you.

## Short answer

- **Run it after a big design change,** after installing or upgrading a framework, and every so often between milestones. All three frameworks ship `/align`.
- **It never changes the design.** It fixes mechanical drift, such as an item missing a size, and brings anything that needs a design call back to you with a recommendation.
- **If a conflict returns,** or one conflict spans several principles, the agent recommends a reset instead of another patch: see [The system was not built as I intended](drift.md).

## Related

- The [`/align` skill page](../skills/align.md), with what the pass checks in each framework, and the concept [Align and drift reset](../concept/drift.md).
- The procedures: [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/align.md), [App-Director](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/align.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/align.md).

<div class="takeaway"><span>Run it after every big design change and catch the drift while it is small.</span><span class="url"><a href="index.md">All questions</a></span></div>
