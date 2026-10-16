# The system was not built as I intended

<div class="kicker">A principle has been built two ways, and patching won't hold</div>

> Type `/drift-reset`. The agent describes the project as built, you decide again where a principle splits, and the rebuild runs as ordinary tasks. Only you start one.

All three frameworks ship `/drift-reset`: Godot-Director, App-Director and SaaSAllTheThings. Nothing to install: run it in Claude Code, in the project where the framework is installed.

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

This is an illustration, not something that happened. It uses [market-day](https://github.com/Freakling/Godot-Director/tree/v3.12.0/examples/market-day), the small grain-market game in the Godot-Director repository.

**The situation.** The GDD has the pillar "Readable luck: prices vary, but the player can see enough to make a reasoned bet". Under Systems › Shop screen it says that from day 2 on, yesterday's price is shown next to today's, and `design/decisions.md` records why (the playtester couldn't tell whether the price was high or low). Suppose the game kept growing. The shop status line shows yesterday's price, from `RunState`, as the GDD says. Later, a second item added a trend arrow to the shop that compares today's price with the base price in `data/market_config.tres`, with the comparison written in `scripts/ui/shop_screen.gd`. Now the arrow can point up while yesterday's price, right beside it, is lower than today's. A playtest report in `playtesting/` says the prices felt unreadable. `/align` has reported the conflict twice, and the second report recommends a reset.

**1. Prepare.** You commit your changes and type `/drift-reset`. The agent suggests the branch `reset-2026-11-03` and you say yes. It lists the areas from the architecture table in `AGENTS.md`: the market rules (`Market` and `MarketConfig`), the run state (`RunState`) and the screens.

**2. Analysis.** Three reviewers read the code and `design/resets/2026-11-03/as-built.md` gets one section per area. The screens section notes that `scripts/ui/shop_screen.gd` compares today's price with `base_price`, which is a rule inside a screen, and that `RunState` already keeps yesterday's price. The check didn't catch it, because `forbidden` in `tools/check.cfg` is empty. You have nothing to decide yet.

**3. Interpretations.** `interpretations.md` classes "One decision a day" and "Two-minute runs" as consistent, and "Readable luck" as divergent. The first reading compares with yesterday and lives in `RunState` and the status line. The second compares with the base price and lives in the shop script. The agent quotes the playtest remark as evidence: the player sees an arrow and a number that disagree, so the bet isn't readable. You read the summary and approve the commit.

**4. The design call.** The agent asks: "Readable luck is read two ways. Which comparison does the shop show?"

- **A. Yesterday's price only.** Keeps the 2026-09-28 decision, removes the arrow, and the comparison moves into `Market` with a test. Recommended.
- **B. The base price only.** Drops yesterday's price, so the decision of 2026-09-28 is replaced, and `RunState` loses its previous price.
- **C. Both, labelled.** Keeps all the code, and strains "one decision a day" with two numbers to weigh.

You pick A. The agent writes the answer into the GDD's Shop screen section, adds a line to `design/decisions.md` that ends with `from: drift reset 2026-11-03`, keeps the old GDD as `gdd-before.md` in the reset folder, and shows you the diff. You approve it.

**5. The plan.** The agent compares the revised GDD with `as-built.md` and adds two tasks to `TASKS.md`. One removes the arrow from `scripts/ui/shop_screen.gd`. The other moves the price comparison into `scripts/systems/market.gd`, with a `(test)` outcome in `tests/test_market.gd`, because the check couldn't catch it. `plan.md` lists both IDs under "Readable luck". You approve the order.

**6. The rebuild.** You run `/clear` and say "Work through the queue". Both tasks are built and committed like any others.

**7. The postmortem.** You type `/drift-reset postmortem`. The reviewer rereads only the files the two tasks touched and marks "Readable luck" resolved. For next time it proposes two checks as design calls: a pattern in `[screens] forbidden` in `tools/check.cfg` that screens must not contain, such as `base_price`, and a test that pins the comparison. You approve the pattern and decline the test, and the pattern becomes a task. `postmortem.md` records both choices.

## What can go wrong

- **Your calls are the point.** The agent changes nothing in the design that you didn't decide, and a reset writes no application code.
- **Nothing is deleted.** The analysis and the old design stay in the reset folder, and it only grows. A later reset gets its own folder. A second reset on the same day adds `-2`.
- **The postmortem waits for the rebuild.** If a rebuild task isn't done, the agent lists it and, in App-Director and SaaSAllTheThings, asks whether to go on. Godot-Director stops.
- **A check rule needs your yes.** Only the rules you choose are recorded.
- **Framework differences.**
    - Godot-Director: art, audio and tunable values are yours and are never rewritten. A tunable value that is part of the drift becomes a design call, and you edit the `.tres` file. The reset folder is `design/resets/`.
    - App-Director: the old brief is kept as `brief-before.md`. If the ownership table makes the brief yours, the draft goes to `brief-proposal.md` for you to apply. The analysis also looks for business rules in your UI folders. The reset folder is `product/resets/`.
    - SaaSAllTheThings: the scope is the product design, so architecture stays out. A conflict with the reference goes through `/architect` and an ADR, and a reset never drops an accepted ADR without a new one. Tenancy and identity are always an area of their own: drift there is a security finding, the agent tells you at once and files a high-severity bug, and it is never a design call. The reset folder is `resets/`, and the agent makes one commit at the end of the plan, where the other two commit after each approved step.

## Related

- The [`/drift-reset` skill page](../skills/drift-reset.md), with each framework's scope and where the reset folder goes.
- The concept [Align and drift reset](../concept/drift.md), and the other ways to keep the records straight: [The records and the code don't agree](align.md).
- The procedures: [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/drift-reset.md), [App-Director](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/drift-reset.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/drift-reset.md).

<div class="takeaway"><span>Align often, reset when you have to.</span><span class="url"><a href="index.md">All questions</a></span></div>
