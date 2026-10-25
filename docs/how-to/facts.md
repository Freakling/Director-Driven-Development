# I need facts before I decide

<div class="kicker">A researcher gathers the evidence, you make the call</div>

> Ask one question. A read-only researcher looks into it in a fresh context and saves a dated note with options, trade-offs, sources and a recommendation. It informs; you decide.

All three frameworks ship `/research`: App-Director, Godot-Director and SaaSAllTheThings. Nothing to install: run it in Claude Code, in the project where the framework is installed.

## Two ways to do it

**By talking.** Ask in plain words: "Research which library fits {topic}", "What licence does this library use?". Godot-Director also takes "Research how other games handle {topic}", and SaaSAllTheThings "What does our security framework require for {topic}?". A single fact that one source answers, such as a version or a licence, the agent settles itself without starting the researcher. Anything larger goes to the researcher.

**With the skill.** Type `/research <question>` with one question and its scope, such as which date-picker library fits the stack and licence. A narrow question gets a sharper note.

Saying it and typing the command run the same procedure. The stricter path is a queued research item. Add the question to `TASKS.md` as a `todo` research item (`R1`, `R2`, ...) when you want to ask now and read later, or when a task needs the findings: list the item under `Depends on`, and [`/next-task`](build.md) hands it to the researcher in its turn. A design session also starts the researcher itself when its options depend on facts nobody has checked.

## Steps

1. **Ask one question.** The agent lists the notes on file and reuses one on the same topic if its Verified as of date is recent enough. Otherwise it researches only what has changed.
2. **Wait for the researcher.** The question becomes a research item, claimed and sized like any task. The researcher never asks you anything: where something is unclear, it states an assumption in the note and carries on.
3. **Read the note from the top.** It starts with the conclusion, then the options and trade-offs, a recommendation with what would change it, a Sources table and the open gaps. Check two things first: the assumptions it states, and the confidence label (High, Medium, Low or Unknown) on the claims you will rely on.
4. **Approve the commit.** Outside a design session, the agent commits the note and its records once you say yes. Inside one, they join that session's commit.
5. **Take the decision.** When the item informs an open question, the agent says the question is ready and offers a design session with the note as input. Say yes to start one (see [How do I decide what gets built?](decide.md)). The decision line then ends with the note's path, so later sessions reuse the evidence.

Notes are named `YYYY-MM-DD-<slug>.md`. They go in `design/research/` in Godot-Director, and in `product/research/` in App-Director and SaaSAllTheThings.

## What can go wrong

- **Finishing the research doesn't answer the question.** The question stays in Open Questions until you decide, and tasks that need the decision stay blocked.
- **The researcher changes nothing.** It records no decision and edits no project file.
- **The web is searched.** Confidential project text stays out of search queries and fetch requests. Queries use generic terms about the technology, and project text appears only inside the note.
- **Sources have tiers.** Tier 1 is your own records and binding requirements, and tier 5 is search previews and unverified posts. Lower tiers help find evidence, but they are never the only basis for a high-impact recommendation.
- **A larger question costs more.** The item has a size like any task, and the size picks the model. A note that says the question needs more than its size allows is rerun once on the next larger model.
- **Framework differences.**
    - App-Director: its domain file covers stacks and libraries, licences, and app-store and platform requirements.
    - Godot-Director: comparable games count as design references, with Low or Medium confidence, and each option names the Design Pillar it serves or strains.
    - SaaSAllTheThings: its domain file covers Azure, the reference architecture and your security framework, and each requirement is traced to its control. For an architecture question, the note ends with a summary ready for an ADR, which `/architect` then uses.

## Related

- The [`/research` skill page](../skills/research.md), and the concept [Design calls](../concept/design-calls.md).
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.10.0/framework/.app-director/procedures/research.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.4.0/framework/.godot-director/procedures/research.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.12.0/framework/.satt/procedures/research.md).

<div class="takeaway"><span>Ask one question, read the note from the top, then make the call.</span><span class="url"><a href="index.md">All questions</a></span></div>
