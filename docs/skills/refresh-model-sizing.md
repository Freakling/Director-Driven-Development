# /refresh-model-sizing

<div class="kicker">Keep the model for each task size current</div>

`/refresh-model-sizing` sets or updates the model that builds each task size. It writes one entry per size, XS through XL, into the project's rules file. The sizes and the reasons behind the map are on [Task and model sizing](../concept/sizing.md).

How to use it: [It's costing more than I'd like](../how-to/cost.md)

## What it does

1. **Check the capability.** Model sizing needs an assistant that can start a builder subagent and choose that subagent's model for each call. If the assistant can't do both, the skill says so, writes nothing, and every build runs on the session's model.
2. **Read the current map** in the project rules. The skill reports whether sizing is on and which model each size uses now.
3. **Propose a model for each size**, with one line of reason for each. For Claude Code the tiers are Haiku for XS and S, Sonnet for M, and Opus for L and XL, with Fable as an alternative for XL where the account has access (Claude platform credits, or in Godot-Director also usage credits). Other assistants get the same tiers with their own model names.
4. **Confirm with the director.** The director can name any model they can't access, or ask for a size to be mapped differently. The skill adjusts and asks again.
5. **Write the block** into the project rules as `Model sizing: on` with five entries, and report the final map in a table.

## Unique per repo

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/refresh-model-sizing.md`](https://github.com/Freakling/Godot-Director/tree/v4.7.0/framework/.godot-director/procedures/refresh-model-sizing.md) in the Godot-Director repository.

- The capability check is explicit for other tools. The skill states which of the two capabilities the tool has, and if one is missing it suggests a note such as `Model sizing: not supported` in Project rules, so future sessions don't ask again.
- Before proposing the map, it asks whether the director has access to each model, since Opus needs a plan that includes it and Fable needs Claude platform access or usage credits.
- If sizing is off, the skill asks before turning it on.

### App-Director

The procedure is at [`framework/.app-director/procedures/refresh-model-sizing.md`](https://github.com/Freakling/App-Director/tree/v1.12.2/framework/.app-director/procedures/refresh-model-sizing.md) in the App-Director repository.

- The capability check looks for the `builder` agent definition in `.claude/agents/`, and for a way to pass a different model to each subagent call. If either is missing, the skill stops.
- The new block replaces any existing `Model sizing` lines in Project rules. If sizing was off, it is switched on.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/refresh-model-sizing.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.4/framework/.satt/procedures/refresh-model-sizing.md) in the SaaSAllTheThings repository.

- If a sizing block with five entries already exists, the skill shows the current values and asks whether to update them or leave them.
- To turn sizing off, the skill writes `Model sizing: off` and removes the size entries.
- Outside Claude Code, the skill asks for the tool's model IDs if it doesn't know them.

<div class="takeaway"><span>Refresh the map when the models change, and the cost of each task follows its size.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
