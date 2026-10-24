# The system was not built as I intended

<div class="kicker">A principle has been built two ways, and patching won't hold</div>

> Type `/drift-reset`. The agent describes the project as built, you decide again where a principle splits, and the rebuild runs as ordinary tasks. Only you start one.

All three frameworks ship `/drift-reset`: App-Director, Godot-Director and SaaSAllTheThings. Nothing to install: run it in Claude Code, in the project where the framework is installed.

## Short answer

First tell the cases apart. Most of the time the answer is smaller than a reset.

| What you see | What to do |
|---|---|
| One screen or one behaviour is wrong, and the design is clear about it | It is a bug. Tick it Broken in the [acceptance check](check.md) and the agent files a bug item. [`/next-task`](build.md) builds the fix. |
| The behaviour is not what you want, and the design never said | It is a design call. Settle it in a [design session](decide.md). |
| The design text, the decisions, the task list and the code are out of step | Run `/align`: [The records and the code don't agree](align.md). |
| One principle of the design has been built two different ways in different places, or a conflict you settled keeps coming back | Run `/drift-reset`. This page is for that case. |

The agent never starts a reset. `/align` can recommend one, and starting it is your decision. A reset ends in a plan that changes the project, so start one when you are ready to rebuild. `/align` is enough when the mismatch is a one-off, and the reset is for when patching one place makes the other worse.

## How to start it

There is one way: type `/drift-reset`. The agent can't start it on its own, which keeps the decision with you. A second command, `/drift-reset postmortem`, closes the reset after the rebuild.

The reset takes several sessions. Each stage ends with something you approve, and the reset folder holds everything the next session needs.

## Steps

1. **Prepare the tree and the branch.** Commit or set aside uncommitted changes. The agent recommends running the reset on its own branch and waits for your answer. Say yes unless you have a reason not to. SaaSAllTheThings first asks you what triggered the reset, then confirms the list of areas it will analyse.
2. **Let the analysis run.** The agent splits the project into areas, one per row of the architecture table in `AGENTS.md`, and reads each in a fresh, read-only context. Every claim cites a file and a line. It describes what the project does today, not what the design says. Only one file is written, `as-built.md`. You decide nothing yet.
3. **Review the interpretations.** For each principle in the design, the agent lists how it was read and where, and classes it as consistent, divergent (readings that pull different ways) or contradictory (readings that can't both hold). You get a short summary, with the problem principles in detail. In App-Director and SaaSAllTheThings each problem principle also gets a failure mode, which says what went wrong, and the postmortem checks it later. Approve the commit.
4. **Make the design calls.** For each divergent or contradictory principle, one at a time, you get two to four options, usually including each reading found, with a recommendation. You can also write your own answer. In Godot-Director and SaaSAllTheThings, when a pillar is in question the agent asks which gives way, the pillar or the implementation. Only what you choose is recorded. The old design is kept beside the new one, and you see the diff before you approve. If a hook or the ownership table keeps the agent from writing the design, it writes a proposal and asks you to apply it.
5. **Approve the plan.** Every difference between the approved design and the analysis becomes a task in `TASKS.md`. Godot-Director and App-Director also write a file in the reset folder that lists the task IDs for each principle, and SaaSAllTheThings adds a last task for you: run the postmortem. This step writes no code. Reorder the tasks if your priorities differ, then approve.
6. **Run the rebuild.** Start a fresh session (`/clear`), then say "Work through the queue". The rebuild is ordinary tasks: see [How do I get things built?](build.md)
7. **Run `/drift-reset postmortem`.** After the rebuild tasks are done, the agent looks again at each principle and marks it fixed or still there. For drift that a script could catch next time, it proposes a check as a design call, such as a test or a pattern the code must not contain. You choose which to add. A principle that is still drifting becomes a task, or a new design call if the design itself is the problem. Merging the reset branch is your call.

## A worked example

This is an illustration, not something that happened. It uses [todo-web](https://github.com/Freakling/App-Director/tree/v1.8.0/examples/todo-web), the small to-do list in the App-Director repository.

**The situation.** The brief says of the app: "No accounts, no sync; everything lives in the current session", and `product/decisions.md` records the choice: session-only for now. Suppose the app kept growing. `TodoStore` keeps the tasks in memory, as the brief says. Later, a second item made finished tasks survive a reload, with the `localStorage` calls written in `src/ui/TodoList.ts`. Now a reload brings back the finished tasks and loses the open ones. A bug in `TASKS.md` says the list looks broken after a refresh. `/align` has reported the conflict twice, and the second report recommends a reset.

**1. Prepare.** You commit your changes and type `/drift-reset`. The agent suggests the branch `drift-reset-2026-11-03` and you say yes. It lists the areas from the architecture table in `AGENTS.md`: the UI, the services and the store.

**2. Analysis.** Three reviewers read the code and `product/resets/2026-11-03/as-built.md` gets one section per area. The UI section notes that `src/ui/TodoList.ts` reads and writes `localStorage`, which is a rule about what survives a reload and belongs in a layer below the UI, and that `TodoStore` still holds everything in memory. The check didn't catch it, because it looks for imports from the store, and a `localStorage` call is not an import. You have nothing to decide yet.

**3. Interpretations.** `interpretations.md` classes "Add a task" and "Remove a task" as consistent, and "everything lives in the current session" as divergent. The first reading keeps all tasks in memory, in `TodoStore`. The second keeps the finished tasks in the browser, in the list's UI code. The agent quotes the bug as evidence: the list after a refresh matches neither reading. You read the summary and approve the commit.

**4. The design call.** The agent asks: "The brief says everything lives in the current session, and the code keeps finished tasks across reloads. Which is it?"

- **A. Session only.** Keeps the decision of 2026-10-07, and the `localStorage` calls are removed from the UI.
- **B. Every task is kept in the browser.** Replaces the decision of 2026-10-07 with one rule, and the saving moves behind the store. Recommended.
- **C. Only finished tasks are kept.** Keeps the code as it is, and a reload loses the open tasks.

You pick B. The agent copies the brief to `brief-before.md` in the reset folder, writes the answer into the brief in place of the text it replaces, adds a line to `product/decisions.md` that names `drift reset 2026-11-03`, and shows you the diff. You approve it.

**5. The plan.** The agent compares the revised brief with `as-built.md` and adds two items to `TASKS.md`. One removes the `localStorage` calls from `src/ui/TodoList.ts`. The other makes `TodoStore` save and load every task, with a `(code)` outcome that names it. `rebuild.md` lists both IDs under "everything lives in the current session". You approve the order.

**6. The rebuild.** You run `/clear` and say "Work through the queue". Both items are built and committed like any others.

**7. The postmortem.** You type `/drift-reset postmortem`. The agent runs the check, rereads the files the two items touched and marks the principle `fixed` in `postmortem.md`. For next time it proposes a check rule as a design call: UI files must not contain `localStorage`. You approve it, and it becomes an item that adds the rule to `tools/check.cfg` or `tools/check.local.sh`.

## What can go wrong

- **Your calls are the point.** The agent changes nothing in the design that you didn't decide, and a reset writes no application code.
- **Nothing is deleted.** The analysis and the old design stay in the reset folder, and it only grows. A later reset gets its own folder. A second reset on the same day adds `-2`.
- **The postmortem waits for the rebuild.** If a rebuild task isn't done, the agent lists it and, in App-Director and SaaSAllTheThings, asks whether to go on. Godot-Director stops.
- **A check rule needs your yes.** Only the rules you choose are recorded.
- **Framework differences.**
    - App-Director: the old brief is kept as `brief-before.md`. If the ownership table makes the brief yours, the draft goes to `brief-proposal.md` for you to apply. The analysis also looks for business rules in your UI folders. The reset folder is `product/resets/`.
    - Godot-Director: art, audio and tunable values are yours and are never rewritten. A tunable value that is part of the drift becomes a design call, and you edit the `.tres` file. The reset folder is `design/resets/`.
    - SaaSAllTheThings: the scope is the product design, so architecture stays out. A conflict with the reference goes through `/architect` and an ADR, and a reset never drops an accepted ADR without a new one. Tenancy and identity are always an area of their own: drift there is a security finding, the agent tells you at once and files a high-severity bug, and it is never a design call. The reset folder is `resets/`, and the agent makes one commit at the end of the plan, where the other two commit after each approved step.

## Related

- The [`/drift-reset` skill page](../skills/drift-reset.md), with each framework's scope and where the reset folder goes.
- The concept [Align and drift reset](../concept/drift.md), and the other ways to keep the records straight: [The records and the code don't agree](align.md).
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.8.0/framework/.app-director/procedures/drift-reset.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.2.1/framework/.godot-director/procedures/drift-reset.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.10.0/framework/.satt/procedures/drift-reset.md).

<div class="takeaway"><span>Align often, reset when you have to.</span><span class="url"><a href="index.md">All questions</a></span></div>
