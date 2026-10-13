# Reviews

An independent review runs a second agent in its own fresh context. It reads the change, the task and the rules again, so it costs tokens and time. The frameworks review only where a mistake is expensive, and rely on the check and the builder's own tests for the rest. Enforce what's critical, audit the rest.

## When a change is reviewed

| Framework | Reviewed before the commit |
|---|---|
| Godot-Director | L and XL tasks, and M tasks that rewrite the save codec (the `to_dict` and `from_dict` pair) or touch more than three system boundaries |
| App-Director | L and XL tasks, and M tasks that change a stored data schema or a public API contract |
| SaaSAllTheThings | L and XL tasks, and M tasks that change a contract (an API route, event or command), tenant isolation, identity or a stored schema |

The orchestrator decides from the task's size and the builder's report, which names any API, save or contract change.

## How a review runs

1. The orchestrator gives the reviewer the task ID, the builder's report and the check result.
2. The reviewer reads the diff in a fresh, read-only context and checks it against the task, the framework's rules and the tests. In SaaSAllTheThings it also checks the reference architecture: tenant isolation, identity, messaging, layers and cost.
3. It returns a ranked list of findings, not a rewrite.
4. Findings inside the task's scope go back to a builder to fix. Findings outside it become new items in `TASKS.md`.

## What the check covers instead

The check is the review for every task, every time. It is fast and mechanical, and it never gets tired. The reviewer covers what text matching can't show, such as a data store query that forgets the tenant.

<div class="takeaway" markdown><span>Enforce what's critical, audit the rest.</span><span class="url" markdown="span">[Agent development flow](agent-flow.md)</span></div>
