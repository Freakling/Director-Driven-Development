# The task list is getting long

<div class="kicker">A short queue is easier to read</div>

> Say "Prune the task list", or type `/prune`. The agent moves finished items into `TASKS-archive.md` and drops notes that are no longer true. The history stays in the repository.

All three frameworks ship `/prune`: App-Director, Godot-Director and SaaSAllTheThings. The steps are the same in each. Nothing to install: run it in Claude Code, in the project where the framework is installed.

## Short answer

- **Run it when the queue gets hard to read.** As the project grows, `TASKS.md` fills with done items and the open ones are hard to find. Godot-Director and SaaSAllTheThings suggest pruning once `TASKS.md` holds more than about ten done items. App-Director names no threshold.
- **Nothing is lost.** Each item moves with its heading and fields unchanged, and IDs are never reused. An ID you can't find in `TASKS.md` is in `TASKS-archive.md`.
- **Only done items move.** Items that are `todo` or `in-progress` stay.
- **It also saves tokens.** Every session reads the task list to find the next task, so a shorter list is cheaper to read: see [It's costing more than I'd like](cost.md).

## Two ways to do it

**By talking.** Say "Prune the task list".

**With the skill.** Type `/prune`.

Saying it and typing the command run the same procedure, so use whichever is quicker.

## Steps

1. **Start from committed work.** Run it from a session where the finished items are committed, so the diff shows only the move.
2. **Let the agent move the items.** Every `done` item goes from `TASKS.md` to the end of `TASKS-archive.md`. If the archive doesn't exist yet, the agent creates it with a short header.
3. **Check the notes it removed.** The agent deletes lines under the Notes section of `TASKS.md` that are no longer true. Look at them in `git diff` before you approve, and tell the agent to put back any that still matter.
4. **Approve the commit.** The agent commits the change as `docs: prune tasks` once you say yes.

## What can go wrong

- **The counters and milestones stay as they are.** The next ID counter and the milestones are not changed, so new items keep numbering from where they were.
- **Look in the archive for old IDs.** An open item that depends on an archived ID still works, because [`/next-task`](build.md) looks in the archive too.
- **A removed note you still need.** It is in `git diff` and in the history. Ask the agent to put it back before you approve.

## Related

- The [`/prune` skill page](../skills/prune.md), with what is unique to each framework.
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.7.1/framework/.app-director/procedures/prune.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.2.0/framework/.godot-director/procedures/prune.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.1/framework/.satt/procedures/prune.md).

<div class="takeaway"><span>Prune when the queue gets hard to read. The history stays in the archive.</span><span class="url"><a href="index.md">All questions</a></span></div>
