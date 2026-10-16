# Build the next task with /next-task

<div class="kicker">One command, one task built, checked and committed</div>

> You keep the queue in order. The agent builds the next ready item, proves it with the check and commits it once you approve.

This guide is for someone who has never run `/next-task`. All three frameworks ship it: Godot-Director, App-Director and SaaSAllTheThings. Where they differ in what you do, the step says so. The [skill page](../skills/next-task.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** `/next-task` advances the project by one task. It picks the next ready item in `TASKS.md`, has it built in a fresh context, runs the check, updates the records and commits the item together with its records.
- **Which item comes next.** The next item is the first `todo` item, in file order, that is yours to hand to the agent and whose dependencies are all `done`. High-severity bugs come first. File order is your priority order, so move an item up in `TASKS.md` to build it sooner.
- **Nothing to install.** The command comes with the framework. Run it in Claude Code, in the project where the framework is installed.
- **Where things go.** The item's files and its records go into one commit. The item moves from `in-progress` to `done` in `TASKS.md`, and new work the builder finds becomes new items.

## What you need to do

1. **Start from a clean tree.** If another item's changes are still uncommitted, the agent asks whether to finish that item, commit it, or set it aside with `git stash`. Answer with one of the three.
2. **Run `/next-task`.** To build a particular item, give its ID: `/next-task T12`. To build several, say how many ("the next 3 tasks") or ask to work through the queue (see the caveats on runs).
3. **Let the agent check the starting point.** If the check fails before anything is built, the agent says so and offers the items that would fix it. Pick one, or tell it to build another item anyway.
4. **Answer if the item is already claimed.** An item claimed today may have another session working on it, so the agent asks before touching it. An older claim means a session probably ended partway: the agent reads the item's note and the working tree, then resumes it or sets it back to `todo`, and tells you which.
5. **Wait for the build.** The builder runs in a fresh context and the check follows. If the builder is blocked, the agent brings you the question with two to four options and a recommendation. Answer it. A design decision you make here is recorded and committed with the item, and the build continues.
6. **Read the report.** It says what changed, the check result, any placeholder values added and what waits on you. A failed build is retried once on the next larger model, unless it already ran on the largest. If the retry fails too, you get the check output.
7. **Approve the commit.** The agent commits the item and its records once you say yes. Then run `/clear`, or start a fresh session, before the next item. The records hold everything the next session needs.

Differences in what you do:

- **Godot-Director.** An item that depends on an open question (`Q<n>`) is ready once the question has been answered in `/design`. After a passing check, a note about a recurring warning may appear. The agent checks that it is harmless and proposes a line for `tools/check.ignore`. Say yes or no.
- **SaaSAllTheThings.** A blocked report can say `blocked: architecture`. You then choose to comply with the reference architecture or to accept a deviation, and a deviation needs an accepted ADR before the rebuild. When the current stage of the roadmap has no items left, the agent offers to plan the next stage. Its commands for Azure (`az`, `azd`) ask before they run.
- **All three.** A research item (`R<n>`) goes to the researcher instead of the builder. No check runs, and the commit holds the note.

## Caveats

- **A run commits without pausing.** Asking for "the next N tasks", "work through the queue" or "grab tasks until you're blocked" approves the run's commits in advance. The run stops when an item is blocked on you, a build fails, or you decline a commit. A run commits only. Pushes ask every time.
- **One builder at a time.** Don't start a second session on the same tree while one is building.
- **Nothing ready is a result.** The agent then reports what is blocked and on what: dependencies, items assigned to you, or open questions.
- **Manual outcomes wait for you.** Outcomes tagged `(demo)` or `(play)`, and bug fixes without a regression test, show up in the next [acceptance check](acceptance.md). The report tells you when an item has some.
- **A failed check blocks the commit.** The pre-commit hook runs the check, so a task that fails it cannot land.

## More

- The [`/next-task` skill page](../skills/next-task.md), with what is unique to each framework.
- The procedures, which are the source of truth for the steps: [Godot-Director v3.11.0](https://github.com/Freakling/Godot-Director/tree/v3.11.0/framework/.godot-director/procedures/next-task.md), [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/next-task.md) and [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/next-task.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>One task, one check, one commit. Run it again for the next one.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
