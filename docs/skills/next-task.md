# /next-task

<div class="kicker">The build loop, one step at a time</div>

Pick the next ready item in `TASKS.md`, have it built in a fresh context, prove it with the check, update the records and commit it. Running `/next-task` once advances the project by one task. Running it with "the next N tasks" or "work through the queue" repeats that for each task in turn, committing as it goes (see [Commits](#commits)).

This is the skill that drives the agent development flow. Each run is self-contained: the context that builds the item is fresh, and after the commit the records hold everything a new session needs to continue.

How to use it: [How do I get things built?](../how-to/build.md)

## What it does

1. **Pick** the next ready item: a `todo` `agent` item whose dependencies are all `done`, in file order (which is the director's priority order). High-severity bugs come first. If nothing is ready, the skill reports what is blocking and stops.
2. **Claim** the item by setting it to `in-progress YYYY-MM-DD`.
3. **Build** in a fresh context, using a builder subagent in Claude Code. The orchestrator session keeps only the item, the report and the bookkeeping, so its context stays small across many items. Every subagent launch passes its model explicitly: the one for the item's size, or the session's model where the size has no entry ([Task and model sizing](../concept/sizing.md#the-model-map)).
4. **Verify** by running `bash tools/check.sh --if-changed`. A passing check is the definition of done for this item.
5. **Update the records**: set the item to `done`, update `AGENTS.md` from the report's `Systems:` line, log any new items from `Found:`, and update milestones.
6. **Review** when the framework's rules call for one, based on item size and whether the build changed a public contract.
7. **Commit** the item's files and its records together (see [Commits](#commits)), then report what changed, the check result and anything waiting on the human.

If a build fails, the skill escalates to the next model size and retries once. If blocked, it brings the question with options and a recommendation to the director. A design decision made this way is recorded following `design.md` before the rebuild, and that record is committed with the item.

Tools without a `builder` subagent follow `build.md` directly, or hand it to a subagent if they have one. Once the item is committed, the records hold everything about it, so a new session (or `/clear` in Claude Code) can start the next item without losing context.

## Commits

One task, one commit: the item's files and its records go in together, and the pre-commit hook runs the check before any commit that touches code, so a failing task cannot land. A single `/next-task` pauses for the director's approval of that commit.

When the director asks for a run, such as "grab tasks until you're blocked", "work through the queue" or "the next N tasks", the request approves the run's commits in advance. Each task commits without pausing, and the final report lists every commit. The run stops when an item is blocked on the director, a build fails, or the director declines a commit. It also ends when nothing is ready.

A run covers commits only, not pushes, deploys or cloud changes. Each framework's settings allow `git commit` without a prompt, so the director's approval is asked for in the conversation, while pushes ask every time.

## Unique per repo

### App-Director

The procedure is at [`framework/.app-director/procedures/next-task.md`](https://github.com/Freakling/App-Director/tree/v1.12.2/framework/.app-director/procedures/next-task.md) in the App-Director repository.

- The building state file is `.app-director/state/building`. The Stop hook checks for it and leaves half-built files alone while it exists.
- The review diff is written to `.app-director/state/review.diff`.
- New items are formatted following `.app-director/tasks.md`, and IDs come from `Next IDs` in that file.
- The report notes that `(demo)` outcomes and bug fixes without regression tests will appear in the next acceptance check.
- A research item (`R<n>`) goes to the `researcher` instead of the builder. No check runs and there is no review: the session writes the note to `product/research/` and commits it with the records.
- When a [`/security`](security.md) assessment is due, it proposes one before picking an item, and you can decline. In a run of several items it carries on picking and only names the assessment in the final report.

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/next-task.md`](https://github.com/Freakling/Godot-Director/tree/v4.6.2/framework/.godot-director/procedures/next-task.md) in the Godot-Director repository.

- The building state file is `.godot/godot-director/building`. The Stop hook checks for it and leaves half-built files alone while it exists.
- The review diff is written to `.godot/godot-director/review.diff`.
- New items are formatted following `.godot-director/tasks.md`, and IDs come from `Next IDs` in that file.
- An item's `Depends on` can name an open question (`Q<n>`). That part is met once the question is no longer in GDD › Open Questions, so a decision made in `/design` makes the item ready.
- The builder is told to skip the final `bash tools/check.sh` call: step 4 runs the check from the orchestrator session, and the pre-commit hook is the safety net.
- The builder plays the scenarios the item names once, in one call, and leaves out `smoke` when the check already plays it.
- The report notes that `(play)` outcomes and bug fixes without regression tests will appear in the next function check.
- After a passing check, recurring warnings may appear as `check: note: recurring warning (N×): <text>`. The skill has a procedure for verifying, proposing and applying suppressions via `tools/check.ignore`.
- A research item (`R<n>`) goes to the `researcher` instead of the builder. No check runs and there is no review: the session writes the note to `design/research/` and commits it with the records.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/next-task.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.3/framework/.satt/procedures/next-task.md) in the SaaSAllTheThings repository.

- The building state file is `.satt/state/building`. The Stop hook checks for it and leaves half-built files alone while it exists.
- The review diff is written to `.satt/state/review.diff`.
- New items are formatted following `.satt/tasks.md`, and IDs come from `Next IDs` in that file.
- A blocked report can carry `blocked: architecture`, which triggers the `architect.md` procedure. The director chooses to comply or to accept a deviation; a deviation requires an accepted Architecture Decision Record (ADR) before the rebuild.
- If the current stage of the roadmap has no items left, the skill offers `roadmap.md` for the next stage.
- Its settings ask before the `az` and `azd` commands.
- A research item (`R<n>`) goes to the `researcher` instead of the builder. No check runs and there is no review: the session writes the note to `product/research/` and commits it with the records.
- The report notes that `(demo)` outcomes and bug fixes without regression tests will appear in the next acceptance check.
- When a [`/security`](security.md) assessment is due, it proposes one before picking an item, and you can decline. In a run of several items it carries on picking and only names the assessment in the final report.

<div class="takeaway"><span>One task, one check, one commit: the loop runs as fast as the check.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
