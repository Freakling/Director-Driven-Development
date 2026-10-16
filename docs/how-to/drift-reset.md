# Reset a drifted design with /drift-reset

<div class="kicker">Rebuild shared understanding when patching won't hold</div>

> The agent describes the project as built, you rewrite the design where it splits, and the rebuild runs as ordinary tasks.

This guide is for someone who has never run `/drift-reset`. All three frameworks ship it: Godot-Director, App-Director and SaaSAllTheThings. The [skill page](../skills/drift-reset.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** A design principle has been built two or more ways, and patching one place makes the other worse. A reset describes what the project does today, maps how each principle was read, lets you decide the design again where it splits, and plans the rebuild.
- **Only you start it.** `/align` may recommend a reset, and it never starts one. A reset is the big counterpart to `/align`: align often, reset when you have to.
- **It takes several sessions.** The analysis, the design rewrite and the plan are separate steps, and the agent commits after you approve. The rebuild itself runs through [`/next-task`](next-task.md), and a postmortem closes the reset.
- **It writes no application code.** Nothing in a reset discards work or rewrites history, and the reset folder only grows. A later reset gets its own folder.
- **Where things go.** Godot-Director uses `design/resets/YYYY-MM-DD/`, App-Director `product/resets/YYYY-MM-DD/`, and SaaSAllTheThings `resets/YYYY-MM-DD/`. A second reset on the same day adds `-2`.

## What you need to do

1. **Prepare the tree and the branch.** Commit or set aside any uncommitted changes. The agent recommends running the reset on its own branch and waits for your answer. Say yes unless you have a reason not to.
2. **Run `/drift-reset`.** The agent lists the areas it will analyse, one per row of the architecture table. Read-only subagents analyse them in fresh contexts, and every finding cites a file and a line. Nothing changes in this step except the analysis file.
3. **Review the interpretations.** The agent classes each principle as consistent, divergent or contradictory, and gives each one that isn't consistent a failure mode: what went wrong, and what would have shown it earlier. It shows the count per class and one line per problem principle. Approve the commit.
4. **Make the design calls.** For each divergent or contradictory principle, you get one design call at a time, with two to four options (usually including each reading found) and a recommendation. You can also write your own answer. Only what you choose is recorded. The agent keeps the old design beside the new one, shows you the changed sections, and commits after you approve. If the design is yours to edit and the agent can't write it, it writes a proposal and asks you to apply it.
5. **Approve the plan.** The agent compares the approved design with what is built, and writes each difference as a task in `TASKS.md`. It also writes `rebuild.md`, which lists the task IDs for each principle. This step writes no code. Approve the commit.
6. **Run the rebuild.** Start a fresh session (`/clear`), then run `/next-task` and work through the queue.
7. **Run `/drift-reset postmortem`.** After the rebuild tasks are done, the agent runs the check and looks again at each failure mode. Each principle is marked fixed or still drifting. For drift that a script could catch next time, you get a design call on a proposed check. A principle still drifting becomes a task, or a new design call. Approve the commit.

Differences in what you do:

- **Godot-Director.** The areas you didn't give to the agent, such as art, audio and tunable values, are never rewritten. A tunable value that is part of the drift becomes a design call, and you edit the `.tres` file. The postmortem proposes a test or a forbidden-pattern rule for `tools/check.cfg`.
- **App-Director.** The old brief is kept as `brief-before.md`. If the ownership table makes the brief yours, the draft goes to `brief-proposal.md` for you to apply. The analysis also looks for business rules in your UI folders.
- **SaaSAllTheThings.** The scope is the product design. Architecture is out of scope, and a conflict with the reference goes through `/architect` and an ADR. It makes one commit of the reset folder and the records, at the end of the plan, and you merge the reset branch the way you usually do. Drift in tenancy and identity is a security finding: the agent tells you at once and files a high-severity bug, and it is never a design call. If an accepted ADR isn't honoured, the reset stops until you decide to comply or to record a new ADR.

## Caveats

- **Start only when you're ready to rebuild.** A reset ends in a plan that changes the project. For a one-off conflict, `/align` is the lighter tool.
- **Your calls are the point.** The agent changes nothing in the design that you didn't decide.
- **Nothing is deleted.** The as-built analysis and the old design stay in the reset folder, so a later reset can compare against them.
- **A check rule needs your yes.** The postmortem proposes rules and records only the ones you choose.

## More

- The [`/drift-reset` skill page](../skills/drift-reset.md), with what is unique to each framework, and the concept page [Align and drift reset](../concept/drift.md).
- The procedures, which are the source of truth for the steps: [Godot-Director v3.11.0](https://github.com/Freakling/Godot-Director/tree/v3.11.0/framework/.godot-director/procedures/drift-reset.md), [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/drift-reset.md) and [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/drift-reset.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>Align often, reset when you have to, and start only when you are ready to rebuild.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
