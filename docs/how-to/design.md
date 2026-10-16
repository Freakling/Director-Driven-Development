# Make a design decision with /design

<div class="kicker">One question at a time, with options and a recommendation</div>

> The agent briefs you, offers options and writes down only what you decide.

This guide is for someone who has never run `/design`. All three frameworks ship it: Godot-Director, App-Director and SaaSAllTheThings. The session records decisions in your design files and turns them into tasks. The [skill page](../skills/design.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** A design session settles open questions or changes how part of the project works. You decide, and the agent makes each decision fast and well informed.
- **Where decisions go.** In Godot-Director, the design text is `design/gdd.md` and the log is `design/decisions.md`. In App-Director, they are `product/brief.md` and `product/decisions.md`. In SaaSAllTheThings, they are `product/prd.md` and `product/decisions.md`, and the session is called a product session.
- **Nothing to install.** The command comes with the framework. Run it in Claude Code, in the project where the framework is installed.
- **What it never does.** A design session never edits source code. Numbers and limits stay placeholders until you set them.

## What you need to do

1. **Start a session.** Run `/design <topic>` for one topic, such as `/design inventory limits`. Run `/design questions` to have the agent rank the open questions by what they unblock: first a question that blocks a ready item, then one that would cause rework if answered later, then one that gates a placeholder value, then long-term questions. Each position gets a one-line reason.
2. **Read the briefing.** Before any option appears, the agent shows the design text the topic touches, the related lines in the decision log and any research on file. Tell the agent if something is missing or out of date. If you want to change something already decided, the agent says what has changed since.
3. **Answer each question.** The agent asks one question at a time, with two to four options. Each option says what it would take to build and how it fits the project, and one is recommended. Pick an option, or answer in your own words. If you answer only part of a question, only that part is recorded. If the agent had to interpret your answer, it writes down its reading and asks you to confirm it.
4. **Let research run when facts are missing.** When the options depend on something nobody has checked, such as which library fits or what a store requires, the agent starts the researcher. Its note appears in the research folder. Check the assumptions it lists first, because the researcher never asks you and states them instead. Its recommendation is one option among the others.
5. **Review what was recorded.** Each decision is written in one change: the design text is rewritten as the current design, one line goes in the decision log, the answered question is removed, and the tasks the decision creates go into `TASKS.md`. The agent leaves `in-progress` items alone and tells you about any it would have changed.
6. **Approve the commit.** The agent summarises what was decided and what is still open, then commits the design files as `docs: <summary>` once you say yes. Run `/clear` before the next topic.

Differences in what you do:

- **Godot-Director.** If an idea contradicts a Design Pillar, the agent stops and asks which gives way, the pillar or the idea. Where things sit on a screen goes to [`/ui-design`](ui-design.md), so a design session settles what a screen is for.
- **App-Director.** The agent quotes the related lines from `product/decisions.md` word for word before the options.
- **SaaSAllTheThings.** A question about how the system is built, such as a data store, a client's UI technology or a deviation from the reference, goes to `/architect` instead. A decision about an external system's data is also written into that integration's contract. If an idea contradicts a Product Pillar, the agent asks which gives way.

## Caveats

- **You decide, always.** The agent records an option only after you have chosen it. Suggested reorders of `TASKS.md` stay suggestions.
- **Values stay placeholders.** Limits, quotas, prices and timeouts are marked as placeholders. You set them in the `.tres` files (Godot-Director), in config or environment variables (App-Director), or when you give the value (SaaSAllTheThings).
- **A decision changes a finished item through a new one.** Items already `done` are not reopened. The decision creates a new item.
- **One topic per session.** Start the next topic in a fresh session. The design files hold everything the next session needs.

## More

- The [`/design` skill page](../skills/design.md), with what is unique to each framework.
- The procedures, which are the source of truth for the steps: [Godot-Director v3.12.0](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/design.md), [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/design.md) and [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/design.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>You make the call. The agent writes down only what you decided.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
