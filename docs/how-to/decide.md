# How do I decide what gets built, or change how something works?

<div class="kicker">One question at a time, with options and a recommendation</div>

> Start a design session. The agent briefs you, offers options and writes down only what you decide. Your decisions become design text, a decision-log line and task items.

All three frameworks ship `/design`: App-Director, Godot-Director and SaaSAllTheThings. Nothing to install: run it in Claude Code, in the project where the framework is installed.

## Two ways to do it

**By talking.** Say what you want in plain words. "Let's design {topic}" starts a session (Godot-Director says "Let's brainstorm {topic}", and SaaSAllTheThings "Let's work out {capability}"). "Which open questions block development?" ranks the open questions. A change to something already built can be said as it is. If it is a design call, which is a behaviour or flow the design doesn't settle, the agent gives you two to four options with a recommendation first and waits for your answer.

**With the skill.** Type `/design <topic>`, such as `/design inventory limits`, or `/design questions`.

Saying it and typing the command run the same procedure. The explicit session pays off when the answer must outlive the conversation: the decision is written to the design text and the decision log, so later sessions find it, and it becomes tasks you can order.

| Framework | Design text | Decision log |
|---|---|---|
| App-Director | `product/brief.md` | `product/decisions.md` |
| Godot-Director | `design/gdd.md` | `design/decisions.md` |
| SaaSAllTheThings | `product/prd.md` | `product/decisions.md` |

## Steps

1. **Pick what to settle.** `/design questions` ranks the open questions: first one that blocks a ready item, then one that would cause rework if answered later, then one that gates a placeholder value, then long-term questions. Each position gets a one-line reason.
2. **Read the briefing.** Before any option appears, the agent shows the design text the topic touches, the related lines in the decision log and any research on file. Tell it if something is missing or out of date. If you change something already decided, the agent says what has changed since.
3. **Answer each question.** The agent asks one at a time, with two to four options. Each says what it would take to build and how it fits the project, and one is recommended. Pick an option or answer in your own words. If you answer only part of a question, only that part is recorded. If the agent had to interpret your answer, it writes down its reading and asks you to confirm it.
4. **Let research run when facts are missing.** The agent starts the researcher, and its note appears in the research folder. See [I need facts before I decide](facts.md).
5. **Review what was recorded.** One change holds the rewritten design text, one line in the decision log, the removed question and the tasks the decision creates in `TASKS.md`. The agent leaves `in-progress` items alone and tells you about any it would have changed.
6. **Approve the commit.** The agent summarises what was decided and what is open, then commits the design files as `docs: <summary>` once you say yes. Run `/clear` before the next topic.

## What can go wrong

- **You decide, always.** The agent records an option only after you have chosen it. Suggested reorders of `TASKS.md` stay suggestions.
- **Values stay placeholders.** Limits, quotas, prices and timeouts are marked until you set them: in the `.tres` files (Godot-Director), in config or environment variables (App-Director), or when you give the value (SaaSAllTheThings).
- **A decision changes a finished item through a new one.** Items already `done` are not reopened.
- **The session never edits source code.** The tasks it creates are built through [`/next-task`](build.md).
- **Framework differences.**
    - Godot-Director: an idea that contradicts a Design Pillar stops the session until you say which gives way. Where things sit on a screen goes to [the UI question](ui.md).
    - SaaSAllTheThings: a question about how the system is built, such as a data store or a deviation from the reference, goes to `/architect`.

## Related

- The [`/design` skill page](../skills/design.md), and the concepts [Design calls](../concept/design-calls.md) and [Agent development flow](../concept/agent-flow.md).
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.7.0/framework/.app-director/procedures/design.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.1.0/framework/.godot-director/procedures/design.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.0/framework/.satt/procedures/design.md).

<div class="takeaway"><span>You make the call. The agent writes down only what you decided.</span><span class="url"><a href="index.md">All questions</a></span></div>
