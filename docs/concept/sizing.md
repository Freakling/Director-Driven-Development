# Task and model sizing

Every task gets a size before it's built. The size makes the scope clear before any tokens are spent, and it picks the model that builds the task.

## Sizes

| Size | Scope |
|---|---|
| XS | A single value, label, config line or copy change. No logic, no tests |
| S | One or two files, a setting, or a clear bug |
| M | One capability through one or two layers, or a feature that follows a pattern |
| L | Three or more layers or systems, new architecture, a stored schema or contract change, or a bug without a repro |
| XL | A cross-cutting refactor or redesign. Split it before building if you can |

When in doubt, pick the smaller size, and split L and XL tasks where you can. SaaSAllTheThings splits them in a fixed order: contract first, then domain and application, then the host, then the client. Each framework's `tasks.md` has the exact wording for its domain.

## The model map

With model sizing on, each size maps to its own build model in `AGENTS.md` under Project rules. The Claude Code defaults:

| Size | Model |
|---|---|
| XS, S | Haiku |
| M | Sonnet |
| L, XL | Opus, with Fable as an alternative for XL |

A size without an entry uses the session's model. Onboarding writes the map, and [`/refresh-model-sizing`](../skills/refresh-model-sizing.md) updates it. The skill first checks that the assistant can start subagents and choose a model for each one; if it can't, every build runs on the session model. For other assistants the same tiers apply: a fast, low-cost model for XS and S, a balanced one for M, and the most capable for L and XL.

## Escalation

A failed build retries once on the next size's model. The task is then marked with its new size, for example `M (escalated from S)`. An XL task, or a task that has already escalated, stops and goes to the director with the check output.

## The two-attempt limit

After two failed attempts at the same problem, the agent stops and reports instead of guessing further. Each new attempt carries the context of the failed ones, so the limit caps the cost and hands the problem to the director while it's still small enough to explain.

<div class="takeaway"><span>Cost follows complexity, not habit.</span><span class="url" markdown="span">[Built-in cost savings](cost-built-in.md)</span></div>
