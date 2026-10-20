# /prune

<div class="kicker">A short queue is easier to read</div>

`/prune` moves finished items out of `TASKS.md` and into `TASKS-archive.md`, and removes notes that are no longer true. The queue stays short enough to read, and the history stays in the repository.

How to use it: [The task list is getting long](../how-to/prune.md)

## What it does

1. **Move** every item marked done from `TASKS.md` to the end of `TASKS-archive.md`. Each item keeps its heading and its fields unchanged. If the archive doesn't exist yet, the skill creates it with a short header that says IDs are never reused.
2. **Clean the notes.** Lines under the Notes section of `TASKS.md` that are no longer true are deleted.
3. **Leave the rest alone.** The next ID counter and the milestones are not changed.
4. **Commit** as `docs: prune tasks` once the director approves.

Archived items stay valid. An open item that depends on an archived ID still works, because [`/next-task`](next-task.md) looks in the archive as well as in `TASKS.md`.

## Unique per repo

The steps are the same in all three frameworks. What differs is the item format each one follows, and when the skill suggests running it.

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/prune.md`](https://github.com/Freakling/Godot-Director/tree/v4.2.0/framework/.godot-director/procedures/prune.md) in the Godot-Director repository.

- Items follow the format in `.godot-director/tasks.md`, which is what the move must keep unchanged.
- The skill suggests pruning once `TASKS.md` holds more than about ten done items.

### App-Director

The procedure is at [`framework/.app-director/procedures/prune.md`](https://github.com/Freakling/App-Director/tree/v1.7.1/framework/.app-director/procedures/prune.md) in the App-Director repository.

- Items follow the format in `.app-director/tasks.md`.
- The skill file gives no threshold. Run it whenever the queue gets hard to read.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/prune.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.1/framework/.satt/procedures/prune.md) in the SaaSAllTheThings repository.

- Items follow the format in `.satt/tasks.md`.
- The skill suggests pruning once `TASKS.md` holds more than about ten done items.

<div class="takeaway"><span>Prune when the queue gets hard to read. The history stays in the archive.</span><span class="url"><a href="https://github.com/Freakling/Director-Driven-Development">Freakling/Director-Driven-Development</a></span></div>
