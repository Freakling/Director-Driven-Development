# It's costing more than I'd like

<div class="kicker">Small tasks on small models, and a few habits that keep the context small</div>

> Set the model for each task size with `/refresh-model-sizing`, then use the habits below. Most of the savings are built in.

All three frameworks ship `/refresh-model-sizing`: App-Director, Godot-Director and SaaSAllTheThings. Nothing to install: run it in Claude Code, in the project where the framework is installed.

## Short answer

- **Where the tokens go.** An AI coding agent is billed by the token, and most tokens are spent re-reading context, not writing code. Keeping the context small is what keeps the bill down: see [Built-in cost savings](../concept/cost-built-in.md).
- **Measured.** The cost of this way of working is measured on three projects in [What directing AI agents costs](https://saemundsson.se/2026/10/19/what-directing-ai-agents-costs/) on saemundsson.se.
- **Most of the savings need nothing from you.** A fresh context for each task, lean instructions, records in files and a short task list work out of the box.
- **What you can turn is a short list.** The model for each task size, the size of the tasks, how you batch them, `/prune`, and clearing the session. The rest of the habits are in [Cost tuning for developers](../concept/cost-tuning.md).

## What you can turn

| Lever | What to do | Where it pays off |
|---|---|---|
| Model sizing | Run `/refresh-model-sizing` when you set up a project and when new models come out | Small tasks build on small models, and the large model is paid for only when a task needs it |
| Item sizes | Pick the smaller size when in doubt, and split L and XL items | More work runs on the cheaper tiers |
| Narrow `Touches` | Name the files an item changes, not a folder | The builder reads a few files instead of searching a folder |
| Runs and single tasks | Clear after each task, or after a batch | The session you keep stays small |
| `/prune` | Run it when the task list gets long: [The task list is getting long](prune.md) | Every session reads the task list to find the next task |
| Fresh sessions | Run `/clear` between topics, after a design session and after a batch | Stale context is paid for again with every message |

Sizes, and why the size picks the model, are on [Task and model sizing](../concept/sizing.md).

## Two ways to set the model for each size

**By talking.** Say "Refresh the model sizing" or "The models have changed, update the sizing". The agent runs the procedure.

**With the skill.** Type `/refresh-model-sizing`.

Saying it and typing the command run the same procedure. The explicit command pays off in a new project, since onboarding also writes the map and the skill is how you revisit it later. The result is a normal edit to `AGENTS.md` that you can review in `git diff`.

## Steps

1. **Run it.** The agent checks that your assistant can do two things: start a builder subagent, and choose that subagent's model for each call. Claude Code can do both. In App-Director the agent looks for the `builder` agent definition in `.claude/agents/`, and it stops if that is missing.
2. **Read the current map.** The agent reports whether sizing is on and which model each size uses now.
3. **Say which models you can use.** In Godot-Director the agent asks first whether you have access to each model, since Opus needs a plan that includes it and Fable needs Claude platform access or usage credits. In the other two, you name any model you can't access when you confirm the proposal.
4. **Review the proposal.** For Claude Code, the proposal is Haiku for XS and S, Sonnet for M, and Opus for L and XL, with a one-line reason for each size. Fable is an alternative for XL if your account has access. In other assistants you get the same tiers with that assistant's model names, and the agent may ask you for the model IDs.
5. **Confirm or change it.** Accept the map, or ask for a size to be mapped differently, for example L on Sonnet as an easy saving. The agent adjusts and asks again. A failed build still escalates one size up.
6. **Check the result.** The agent writes `Model sizing: on` with five entries (XS to XL) into `AGENTS.md` › Project rules and reports the final map in a table.

## What can go wrong

- **It affects the builds after it.** Items built earlier are not rebuilt.
- **Access decides the map.** If you have no access to a model, name it, and the agent maps the size to one you have. With no Opus plan, L and XL can use Sonnet.
- **Not every assistant qualifies.** Without subagents or per-call models, sizing is skipped and the agent writes nothing. Builds simply use the session's model. A size without an entry also uses the session's model, so keep the main session on a model you are happy to pay for.
- **A run keeps reports.** A session that works through a queue holds one short report per task, which is small but not zero. Clear after a batch, not only after a task.
- **Framework differences.**
    - App-Director: the new block replaces any existing `Model sizing` lines, and turns sizing on if it was off.
    - Godot-Director: if sizing is off, the agent asks before turning it on. In an assistant that can't do both things, it suggests a note such as `Model sizing: not supported` in Project rules, so later sessions don't ask again.
    - SaaSAllTheThings: if a block with five entries already exists, the agent shows the values and asks whether to update them or leave them. To turn sizing off, ask for it: the agent writes `Model sizing: off` and removes the size entries.

## Related

- The [`/refresh-model-sizing` skill page](../skills/refresh-model-sizing.md), and the concepts [Task and model sizing](../concept/sizing.md), [Built-in cost savings](../concept/cost-built-in.md) and [Cost tuning for developers](../concept/cost-tuning.md).
- [What directing AI agents costs: three projects, measured](https://saemundsson.se/2026/10/19/what-directing-ai-agents-costs/) on saemundsson.se, the measurement behind these answers.
- Building in runs or one task at a time: [How do I get things built?](build.md)
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.7.1/framework/.app-director/procedures/refresh-model-sizing.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.2.0/framework/.godot-director/procedures/refresh-model-sizing.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.1/framework/.satt/procedures/refresh-model-sizing.md).

<div class="takeaway"><span>Refresh the map when the models change, and the cost of each task follows its size.</span><span class="url"><a href="index.md">All questions</a></span></div>
