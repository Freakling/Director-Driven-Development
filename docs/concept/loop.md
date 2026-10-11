# The loop

Every change runs the same four steps. In all three frameworks, `/next-task` runs steps 2 to 4 for the next ready task, and the design commands (`/design`, and `/architect` in SaaSAllTheThings) run step 1.

<div class="ddd-cards" markdown>
<div class="ddd-card" markdown>
<span class="step">01</span>

### Decide
</div>
<div class="ddd-card" markdown>
<span class="step">02</span>

### Build
</div>
<div class="ddd-card" markdown>
<span class="step">03</span>

### Prove
</div>
<div class="ddd-card ddd-card--highlight" markdown>
<span class="step">04</span>

### Commit
</div>
</div>

## 1. Decide

The agent proposes. The director decides.

- Design calls come to the director as 2 to 4 options with a recommendation. The director can always write their own answer.
- Only the director's choice is recorded: the design document holds what was decided, and the decision log holds one line on why.
- Anything undecided goes on the open-questions list. The agent never answers an open question itself.
- Values the director hasn't set are marked `PLACEHOLDER` until they are.
- Each decision becomes task items in `TASKS.md`, sized and naming the files they touch.

## 2. Build

The orchestrator picks the next ready task (high-severity bugs first) and hands it to a builder with a fresh, empty context.

- The builder reads the files in the task's `Touches` field, the rows of the architecture table it involves, and the design sections it names.
- The task's size picks the model that builds it. See [Task and model sizing](sizing.md).
- The builder returns a structured report of about 20 lines. The orchestrator keeps the report, not the code, so ten tasks cost about as much context as one.

## 3. Prove

One check defines done. Each framework ships it as `bash tools/check.sh`, and each enforces its own rules:

| Framework | The check |
|---|---|
| Godot-Director | Godot's import pass; loads every script, scene and resource; fails screen scripts that hold game rules; runs the tests; scans Godot's output for errors |
| App-Director | UI purity (UI files may not import the data layer); secrets with gitleaks; the stack's type check, lint and tests |
| SaaSAllTheThings | The architecture rules (layers, tenant source, secrets, file sizes, cost SKUs and more); the backend build and tests; the Bicep files |

All three also run `tools/check.local.sh` when a project has one. The check exits 0 on pass, 1 on fail and 3 when it can't run, so "it couldn't run" is never read as a pass.

Large changes, and medium ones that cross a risky boundary, also get an independent review before the commit. See [Reviews](reviews.md).

## 4. Commit

One task, one commit, with the task's records in the same commit. A commit needs the director's approval; an approval prompt from the assistant counts. The git pre-commit hook runs the check before any commit that touches code, so a failing task can't land.

After the commit, the records hold everything about the task. The next task can start after `/clear`, or in a new session, without losing anything.

## After the loop

The director checks the running product, not just the tests. Each framework has a human round for that, which turns findings into bugs and design proposals that feed back into step 1.

| Framework | Human rounds |
|---|---|
| Godot-Director | `/playtest` for how the game feels; `/function-check` for whether each built rule works |
| App-Director | `/acceptance` for whether each built behaviour works in the running app |
| SaaSAllTheThings | `/acceptance` for whether each built behaviour works; `/feedback` for customer and pilot sessions |

<div class="takeaway"><span>Trust, but verify.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
