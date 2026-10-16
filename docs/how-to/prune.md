# The task list is getting long

<div class="kicker">A short queue is easier to read</div>

> Say "Prune the task list", or type `/prune`. The agent moves finished items into `TASKS-archive.md` and drops notes that are no longer true. The history stays in the repository.

## Short answer

- **Run it when the queue gets hard to read.** Godot-Director and SaaSAllTheThings suggest it once `TASKS.md` holds more than about ten done items. All three frameworks ship `/prune`.
- **Nothing is lost.** Each item moves with its heading and fields unchanged, and IDs are never reused. An ID you can't find in `TASKS.md` is in `TASKS-archive.md`.
- **Only done items move.** Items that are `todo` or `in-progress` stay.
- **Look at the removed notes** in `git diff` before you approve the `docs: prune tasks` commit.

## Related

- The [`/prune` skill page](../skills/prune.md).
- The procedures: [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/prune.md), [App-Director](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/prune.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/prune.md).

<div class="takeaway"><span>Prune when the queue gets hard to read. The history stays in the archive.</span><span class="url"><a href="index.md">All questions</a></span></div>
