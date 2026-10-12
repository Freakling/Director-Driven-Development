# /next-task

<div class="kicker">The build loop, one step at a time</div>

Pick the next ready item in `TASKS.md`, have it built in a fresh context, prove it with the check, update the records and commit it. Running `/next-task` once advances the project by one task. Running it with "the next N tasks" or "work through the queue" keeps going until something needs a human decision.

This is the skill that drives the agent development flow. Each run is self-contained: the context that builds the item is fresh, and after the commit the records hold everything a new session needs to continue.

## What it does

1. **Pick** the next ready item: a `todo` `agent` item whose dependencies are all `done`, in file order (which is the director's priority order). High-severity bugs come first. If nothing is ready, the skill reports what is blocking and stops.
2. **Claim** the item by setting it to `in-progress YYYY-MM-DD`.
3. **Build** in a fresh context, using a builder subagent in Claude Code. The orchestrator session keeps only the item, the report and the bookkeeping, so its context stays small across many items.
4. **Verify** by running `bash tools/check.sh --if-changed`. A passing check is the definition of done for this item.
5. **Update the records**: set the item to `done`, update `AGENTS.md` from the report's `Systems:` line, log any new items from `Found:`, and update milestones.
6. **Review** when the framework's rules call for one, based on item size and whether the build changed a public contract.
7. **Commit** the item's files and its records together, then report what changed, the check result and anything waiting on the human.

If a build fails, the skill escalates to the next model size and retries once. If blocked, it brings the question with options and a recommendation to the director. A design decision made this way is recorded following `design.md` before the rebuild, and that record is committed with the item.

Tools without a `builder` subagent follow `build.md` directly, or hand it to a subagent if they have one. Once the item is committed, the records hold everything about it, so a new session (or `/clear` in Claude Code) can start the next item without losing context.

## Unique per repo

### App-Director

The procedure is at [`framework/.app-director/procedures/next-task.md`](https://github.com/Freakling/App-Director/tree/main/framework/.app-director/procedures/next-task.md) in the App-Director repository.

- The building state file is `.app-director/state/building`. The Stop hook checks for it and leaves half-built files alone while it exists.
- The review diff is written to `.app-director/state/review.diff`.
- New items are formatted following `.app-director/tasks.md`, and IDs come from `Next IDs` in that file.
- The commit follows `rules.md` › Git and pauses for the director's approval. When the director asks for autonomous work, such as "the next N tasks" or "work through the queue", it commits without pausing and lists all commits in the final report.
- The report notes that `(demo)` outcomes and bug fixes without regression tests will appear in the next acceptance check.

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/next-task.md`](https://github.com/Freakling/Godot-Director/tree/main/framework/.godot-director/procedures/next-task.md) in the Godot-Director repository.

- The building state file is `.godot/godot-director/building`. The Stop hook checks for it and leaves half-built files alone while it exists.
- The review diff is written to `.godot/godot-director/review.diff`.
- New items are formatted following `.godot-director/tasks.md`, and IDs come from `Next IDs` in that file.
- The builder is told to skip the final `bash tools/check.sh` call: step 4 runs the check from the orchestrator session, and the pre-commit hook is the safety net.
- The commit follows `rules.md` › Git and is not paused for approval. It happens as soon as the check passes, and the pre-commit hook is the gate. This differs from App-Director and SaaSAllTheThings, which wait for the director's approval.
- The report notes that `(play)` outcomes and bug fixes without regression tests will appear in the next function check.
- After a passing check, recurring warnings may appear as `check: note: recurring warning (N x): <text>`. The skill has a procedure for verifying, proposing and applying suppressions via `tools/check.ignore`.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/next-task.md`](https://github.com/Freakling/SaaSAllTheThings/tree/main/framework/.satt/procedures/next-task.md) in the SaaSAllTheThings repository.

- The building state file is `.satt/state/building`. The Stop hook checks for it and leaves half-built files alone while it exists.
- The review diff is written to `.satt/state/review.diff`.
- New items are formatted following `.satt/tasks.md`, and IDs come from `Next IDs` in that file.
- A blocked report can carry `blocked: architecture`, which triggers the `architect.md` procedure. The director chooses to comply or to accept a deviation; a deviation requires an accepted Architecture Decision Record (ADR) before the rebuild.
- If the current stage of the roadmap has no items left, the skill offers `roadmap.md` for the next stage.
- The commit follows `rules.md` › Git and pauses for the director's approval.
- The report notes that `(demo)` outcomes and bug fixes without regression tests will appear in the next acceptance check.

<div class="takeaway"><span>One task, one check, one commit: the loop runs as fast as the check.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
