# How do I get things built?

<div class="kicker">One task, or a run, built and checked</div>

> Say "Do the next task". The agent builds the next ready item, proves it with the check, updates the records and asks you to approve the commit. Put the items in the order you want them in `TASKS.md`.

All three frameworks ship `/next-task`: App-Director, Godot-Director and SaaSAllTheThings. Nothing to install: run it in Claude Code, in the project where the framework is installed.

## Two ways to do it

**One task at a time.** Say "Do the next task", or type `/next-task`. To build a particular item, give its ID: `/next-task T12`. You approve each commit, so you see every item before it lands. Use this while you learn what the agent builds, and for anything you want to review closely.

**A run.** Say "Do the next 3 tasks", "Work through the queue" or "Grab tasks until you're blocked". The agent builds item after item and commits each without pausing, because asking for a run approves its commits in advance. Use it when the queue is well specified and you trust the check to catch mistakes.

Saying it and typing the command run the same procedure.

## Steps

1. **Start from a clean tree.** If another item's changes are still uncommitted, the agent asks whether to finish that item, commit it, or set it aside with `git stash`. Answer with one of the three.
2. **Ask for the task or the run.** The next item is the first `todo` item, in file order, that is yours to hand to the agent and whose dependencies are all `done`. High-severity bugs come first.
3. **Answer if the check fails before anything is built.** The agent says so and offers the items that would fix it. Pick one, or tell it to build another item anyway.
4. **Answer if the item is already claimed.** An item claimed today may have another session working on it, so the agent asks before touching it. An older claim means a session probably ended partway: the agent reads the item's note and the working tree, then resumes it or sets it back to `todo`, and tells you which.
5. **Answer if the builder is blocked.** The agent brings you the question with two to four options and a recommendation. A decision you make here is recorded and committed with the item, and the build continues.
6. **Read the report.** It says what changed, the check result, any placeholder values added and what waits on you. A failed build is retried once on the next larger model, unless it already ran on the largest. If the retry fails too, you get the check output.
7. **Approve the commit.** The agent commits the item and its records once you say yes. Then run `/clear`, or start a fresh session, before the next item. The records hold everything the next session needs.

## What can go wrong

- **A run stops.** It stops when an item is blocked on you, a build fails, or you decline a commit. A run commits only: pushes ask every time.
- **Nothing is ready.** The agent reports what is blocked and on what: dependencies, items assigned to you, or open questions. That is a result, not a failure.
- **A failed check blocks the commit.** The pre-commit hook runs the check, so a task that fails it cannot land.
- **Two sessions on one tree.** Run one builder at a time.
- **Manual outcomes wait for you.** Outcomes tagged `(demo)` or `(play)`, and bug fixes without a regression test, show up in the next check by hand. See [How do I check that what was built works?](check.md)
- **Framework differences.**
    - Godot-Director: an item that depends on an open question (`Q<n>`) is ready once the question has been answered in `/design`.
    - SaaSAllTheThings: a blocked report can say `blocked: architecture`. You choose to comply with the reference architecture or to accept a deviation, and a deviation needs an accepted ADR before the rebuild.
    - All three: a research item (`R<n>`) goes to the researcher instead of the builder, and the commit holds the note.

## Related

- The [`/next-task` skill page](../skills/next-task.md), and the concept [Agent development flow](../concept/agent-flow.md).
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.7.1/framework/.app-director/procedures/next-task.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.1.1/framework/.godot-director/procedures/next-task.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.1/framework/.satt/procedures/next-task.md).
- When the queue has no items yet: [How do I decide what gets built, or change how something works?](decide.md)

<div class="takeaway"><span>One task, one check, one commit. Ask for a run when you trust the queue.</span><span class="url"><a href="index.md">All questions</a></span></div>
