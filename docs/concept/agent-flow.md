# Agent development flow

Once the director has made a decision and tasks are in `TASKS.md`, the work runs through a short, repeating sequence: build, prove, commit.

## Build

The orchestrator picks the next ready task from `TASKS.md`, high-severity bugs first, and hands it to a builder in a fresh, empty context.

- The builder reads the files named in the task's `Touches` field, the rows of the architecture table the task involves, and the design sections it names.
- The task's size picks the model that builds it. See [Task and model sizing](sizing.md).
- The builder returns a structured report of about 20 lines. The orchestrator keeps the report, not the code, so ten tasks cost about as much context as one.

## Prove

One check defines done. See [The check](check.md).

Large changes, and medium ones that cross a risky boundary, also get an independent review before the commit. See [Reviews](reviews.md).

## Commit

One task, one commit, with the task's records in the same commit. A commit needs the director's approval; an approval prompt from the assistant counts. The git pre-commit hook runs the check before any commit that touches code, so a failing task cannot land.

After the commit, the records hold everything about the task. The next task can start after `/clear`, or in a new session, without losing anything.

## After the loop

The director checks the running product, not just the tests. Each framework has a human round for that, which turns findings into bugs and design proposals that feed back into the design-calls step.

| Framework | Human rounds |
|---|---|
| Godot-Director | `/playtest` for how the game feels; `/function-check` for whether each built rule works |
| App-Director | `/acceptance` for whether each built behaviour works in the running app |
| SaaSAllTheThings | `/acceptance` for whether each built behaviour works; `/feedback` for customer and pilot sessions |

<div class="takeaway"><span>Trust, but verify.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
