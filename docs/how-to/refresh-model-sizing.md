# Set the model for each task size with /refresh-model-sizing

<div class="kicker">Small tasks on small models, large tasks on large ones</div>

> You confirm which model builds each task size, and the agent writes the map into your project rules.

This guide is for someone who has never run `/refresh-model-sizing`. All three frameworks ship it: Godot-Director, App-Director and SaaSAllTheThings. The [skill page](../skills/refresh-model-sizing.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** Every task has a size from XS to XL, and the size picks the model that builds it. A small task on a small model costs less, and a large task gets a model that can handle it. The map from size to model sits in `AGENTS.md`, under Project rules.
- **What it needs.** The assistant has to start a builder subagent and choose that subagent's model for each call. Claude Code does both. If your assistant can't, the agent says so and writes nothing, and every build runs on the model of the session.
- **When to run it.** Run it when you set up a project and when new models come out.
- **Nothing to install.** The command comes with the framework. Run it in Claude Code, in the project where the framework is installed.

## What you need to do

1. **Run `/refresh-model-sizing`.** The agent checks the capability first. In App-Director it looks for the `builder` agent definition in `.claude/agents/`, and it stops if that is missing.
2. **Read the current map.** The agent reports whether sizing is on and which model each size uses now.
3. **Say which models you can use.** In Godot-Director the agent asks first whether you have access to each model, since Opus needs a plan that includes it and Fable needs Claude platform access or usage credits. In the other two, you name any model you can't access when you confirm the proposal.
4. **Review the proposal.** For Claude Code, the proposal is Haiku for XS and S, Sonnet for M, and Opus for L and XL, with a one-line reason for each size. Fable is an alternative for XL if your account has access. In other assistants, you get the same tiers with that assistant's model names, and the agent may ask you for the model IDs.
5. **Confirm or change it.** Accept the map, or ask for a size to be mapped differently. The agent adjusts and asks again.
6. **Check the result.** The agent writes `Model sizing: on` with five entries (XS to XL) into `AGENTS.md` › Project rules and reports the final map in a table. It's a normal edit to a tracked file, so you can review it in `git diff` and commit it.

Differences in what you do:

- **Godot-Director.** If sizing is off, the agent asks before turning it on. In an assistant that can't do both things, it suggests a note such as `Model sizing: not supported` in Project rules, so later sessions don't ask again.
- **App-Director.** The new block replaces any existing `Model sizing` lines, and turns sizing on if it was off.
- **SaaSAllTheThings.** If a block with five entries already exists, the agent shows the values and asks whether to update them or leave them. To turn sizing off, ask for it: the agent writes `Model sizing: off` and removes the size entries.

## Caveats

- **It affects the builds after it.** Items built earlier are not rebuilt.
- **Access decides the map.** If you have no access to a model, name it, and the agent maps the size to one you have. For example, with no Opus plan, L and XL can use Sonnet.
- **Not every assistant qualifies.** Without subagents or per-call models, sizing is skipped. Nothing breaks: builds simply use the session's model.
- **Sizes are a cost lever.** The sizes and the reasons behind the map are on [Task and model sizing](../concept/sizing.md).

## More

- The [`/refresh-model-sizing` skill page](../skills/refresh-model-sizing.md), with what is unique to each framework, and the concept page [Task and model sizing](../concept/sizing.md).
- The procedures, which are the source of truth for the steps: [Godot-Director v3.12.0](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/refresh-model-sizing.md), [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/refresh-model-sizing.md) and [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/refresh-model-sizing.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>Refresh the map when the models change, and the cost of each task follows its size.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
