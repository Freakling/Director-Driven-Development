# Task and model sizing

Every task gets a size before it's built. The size makes the scope clear before any tokens are spent, and it picks the model that builds the task. A research item is sized the same way, and its size picks the researcher's model.

## Sizes

| Size | Scope |
|---|---|
| XS | A single value, label, config line or copy change. No logic, no tests |
| S | One or two files, a setting, or a clear bug |
| M | One capability through one or two layers, or a feature that follows a pattern |
| L | Three or more layers or systems, new architecture, a stored schema or contract change, or a bug without a repro |
| XL | A cross-cutting refactor or redesign. Split it before building if you can |

When in doubt, pick the smaller size, and split L and XL tasks where you can. SaaSAllTheThings splits them in a fixed order: contract first, then domain and application, then the host, then the client. Each framework's `tasks.md` has the exact wording for its domain.

For a research item the scope is the question, not code. One fact checked against one source is XS, a comparison of a few options in one area is M, and a comparison that spans several areas is L.

## The model map

With model sizing on, each size maps to its own build model in `AGENTS.md` under Project rules. The Claude Code defaults:

| Size | Model |
|---|---|
| XS, S | Haiku |
| M | Sonnet |
| L, XL | Opus, with Fable as an alternative for XL |

Every subagent launch names its model: the builder, the reviewer, the researcher and an escalated retry each get the entry for the item's size, set in the launch. A size without an entry, or model sizing off, passes the session's model the same way, so no subagent is left to inherit it and the model a build runs on is always the one its launch names. The rule is in each framework's `rules.md` ([App-Director](https://github.com/Freakling/App-Director/blob/v1.11.0/framework/.app-director/rules.md), [Godot-Director](https://github.com/Freakling/Godot-Director/blob/v4.5.0/framework/.godot-director/rules.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/blob/v0.14.0/framework/.satt/rules.md)), and `next-task.md` applies it at each launch.

Onboarding writes the map, and [`/refresh-model-sizing`](../skills/refresh-model-sizing.md) updates it. For cost, see [It's costing more than I'd like](../how-to/cost.md). The skill first checks that the assistant can start subagents and choose a model for each one; if it can't, every build runs on the session model. For other assistants the same tiers apply: a fast, low-cost model for XS and S, a balanced one for M, and the most capable for L and XL.

## Escalation

A failed build retries once on the next size's model. The task is then marked with its new size, for example `M (escalated from S)`. An XL task, or a task that has already escalated, stops and goes to the director with the check output.

## The two-attempt limit

After two failed attempts at the same problem, the agent stops and reports instead of guessing further. Each new attempt carries the context of the failed ones, so the limit caps the cost and hands the problem to the director while it's still small enough to explain.

<div class="takeaway" markdown><span>Cost follows complexity, not habit.</span><span class="url" markdown="span">[Built-in cost savings](cost-built-in.md)</span></div>
