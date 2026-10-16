# Get a question researched with /research

<div class="kicker">A researcher gathers the evidence, you make the call</div>

> The researcher informs. You decide.

This guide is for someone who has never run `/research`. All three frameworks ship it: Godot-Director, App-Director and SaaSAllTheThings. The [skill page](../skills/research.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** You have a question whose answer depends on facts, such as which library fits, what a licence allows or what a store requires. The researcher reads your project and the web, and writes a dated note with options, trade-offs, sources and a recommendation.
- **What it never does.** The researcher changes nothing in your project and records no decision. The session writes its note to the notes folder, and the note feeds a design call that you make.
- **It doesn't ask you questions.** The researcher works in a fresh context. Where something is unclear, it states an assumption in the note and carries on.
- **Nothing to install.** The command comes with the framework. Run it in Claude Code, in the project where the framework is installed.
- **Where notes go.** Notes are named `YYYY-MM-DD-<slug>.md`. They go in `design/research/` in Godot-Director, and in `product/research/` in App-Director and SaaSAllTheThings.

## What you need to do

1. **Ask one question.** Run `/research` with a single question and its scope, such as which date-picker library fits the project's stack and licence. A narrow question gets a sharper note.
2. **Let the agent check what exists.** It lists the notes on file and reuses one on the same topic if its Verified as of date is recent enough. Otherwise it researches only what has changed. A single fact that one source answers, such as a version or a licence, the agent settles itself without starting the researcher.
3. **Wait for the researcher.** The question becomes a research item, `R<n>`, claimed and sized like any task. The researcher runs in a fresh context and reports the note. You don't answer anything during this step.
4. **Read the note from the top.** It starts with the conclusion, then the options and trade-offs, a recommendation with what would change it, a Sources table and the open gaps. Check two things first: the assumptions it states, and the confidence label (High, Medium, Low or Unknown) on the claims you will rely on.
5. **Approve the commit.** Outside a design session, the agent commits the note and its records once you say yes, as `/next-task` does. Inside a design session, they join that session's commit.
6. **Take the decision.** When the item informs an open question, the agent says the question is ready and offers a design session with the note as input. Say yes to start one with [`/design`](design.md). The decision line then ends with the note's path, so later sessions reuse the evidence.

To ask now and read later, queue the question as a `todo` research item. [`/next-task`](next-task.md) picks it up like any other item and hands it to the researcher. A task that needs the findings lists the item under `Depends on`.

Differences in what you get:

- **Godot-Director.** Comparable games count as design references, with Low or Medium confidence, and each option names the Design Pillar it serves or strains.
- **App-Director.** Its domain file covers stacks and libraries (maturity, maintenance, advisories, licence and platform support), licences, and app-store and platform requirements.
- **SaaSAllTheThings.** Its domain file covers Azure, the reference architecture and your security framework. Each requirement is traced to its control and labelled direct, partial, interpretive or unverified. For an architecture question, the note ends with a summary ready for an ADR, which `/architect` then uses.

## Caveats

- **Finishing the research doesn't answer the question.** The question stays in Open Questions until you decide, and tasks that need the decision stay blocked until then.
- **The web is searched.** Web search and fetch are on for research in all three frameworks, so the researcher can check current facts. Confidential project text stays out of search queries and out of fetch requests. Queries use generic terms about the technology, and project text appears only inside the note. In SaaSAllTheThings this also covers tenant and subscription identifiers, integration contracts and anything from `compliance/`.
- **Sources have tiers.** Tier 1 is your own records and binding requirements, and tier 5 is search previews and unverified posts. Lower tiers help find evidence, but they are never the only basis for a high-impact recommendation.
- **A larger question costs more.** The item has a size like any task, and the size picks the model. A note that says the question needs more than its size allows is rerun once on the next larger model.
- **It sits outside the build.** No check runs for a research item, because it changes no code.

## More

- The [`/research` skill page](../skills/research.md), with what is unique to each framework.
- The procedures, which are the source of truth for the steps: [Godot-Director v3.12.0](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/research.md), [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/research.md) and [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/research.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>Ask one question, read the note from the top, then make the call.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
