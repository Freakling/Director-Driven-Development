# Tidy the queue with /prune

<div class="kicker">A short queue is easier to read</div>

> The agent moves finished items into the archive and drops notes that are no longer true. The history stays in the repository.

This guide is for someone who has never run `/prune`. All three frameworks ship it: Godot-Director, App-Director and SaaSAllTheThings. The steps are the same in each. The [skill page](../skills/prune.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** As the project grows, `TASKS.md` fills with done items, and the open ones get hard to find. `/prune` moves the done items into `TASKS-archive.md`, so the queue shows what is left to do.
- **When to run it.** Run it when the queue gets hard to read. Godot-Director and SaaSAllTheThings suggest it once `TASKS.md` holds more than about ten done items. App-Director names no threshold.
- **Nothing is lost.** Each item moves with its heading and fields unchanged, and IDs are never reused. An open item that depends on an archived ID still works, because [`/next-task`](next-task.md) looks in the archive too.
- **Nothing to install.** The command comes with the framework. Run it in Claude Code, in the project where the framework is installed.

## What you need to do

1. **Run `/prune`.** Run it from a session where the finished items are committed, so the diff shows only the move.
2. **Let the agent move the items.** Every `done` item goes from `TASKS.md` to the end of `TASKS-archive.md`. If the archive doesn't exist yet, the agent creates it with a short header.
3. **Check the notes it removed.** The agent deletes lines under the Notes section of `TASKS.md` that are no longer true. Look at them in `git diff` before you approve, and tell the agent to put back any that still matter.
4. **Approve the commit.** The agent commits the change as `docs: prune tasks` once you say yes.

## Caveats

- **The counters and milestones stay as they are.** The next ID counter and the milestones are not changed, so new items keep numbering from where they were.
- **Look in the archive for old IDs.** An ID you can't find in `TASKS.md` is in `TASKS-archive.md`.
- **Only done items move.** Items that are `todo` or `in-progress` stay in `TASKS.md`.

## More

- The [`/prune` skill page](../skills/prune.md), with what is unique to each framework.
- The procedures, which are the source of truth for the steps: [Godot-Director v3.11.0](https://github.com/Freakling/Godot-Director/tree/v3.11.0/framework/.godot-director/procedures/prune.md), [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/prune.md) and [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/prune.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>Prune when the queue gets hard to read. The history stays in the archive.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
