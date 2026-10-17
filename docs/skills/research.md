# /research

<div class="kicker">A read-only researcher, one question at a time</div>

> The researcher informs. The director decides.

`/research` answers one question in a fresh context and writes a dated note with its options, trade-offs, sources and a recommendation. The researcher reads and changes nothing; the note is its only output. A design session uses the note as input to a design call. The note records no decision.

How to use it: [I need facts before I decide](../how-to/facts.md)

## What it does

1. **Reuse** an earlier note when one exists. The skill lists the note folder for the topic and reuses a note whose Verified as of date is recent enough for its claims. Otherwise it researches only what has changed.
2. **Settle a single fact** that one source answers, such as a version or a licence, in the session itself. Anything larger goes to the researcher, so the session's context stays small.
3. **Create the item.** The question becomes a research item, `R<n>`, with one `Question:` and, when it feeds an open question, `Informs:`. The item is claimed as in progress and sized like any task, so the size picks the model.
4. **Research** in a fresh context. In Claude Code the `researcher` subagent frames the question, reads primary sources before broad searches, reconciles sources that disagree and tests whether the evidence is enough. It never asks the human. It states its assumptions in the note and carries on.
5. **Write and record.** The session writes the note that the researcher reports, sets the item to `done` and commits the note with the records.
6. **Offer the design call.** When the item informs an open question, the skill says that the question is ready and offers a design session with the note as input. The question stays open until the director decides, and tasks that need the decision stay gated by it.

A question can also be queued instead of run at once. `/next-task` picks up a queued research item like any other item and hands it to the researcher. A task that needs the findings lists the item under `Depends on`. Finishing the research doesn't answer the question. A design session also calls the researcher when an option depends on facts nobody has checked.

## How the note reads

A note is compact and starts with the conclusion. It has the options and trade-offs, a recommendation with what would change it, a Sources table and open gaps. Empty sections are left out.

- Each material claim traces to a source the researcher opened. Each source has a tier, from 1 for the project's own records and binding requirements down to 5 for search previews and unverified posts, and each claim has a confidence label: High, Medium, Low or Unknown.
- Lower tiers help find evidence. They are never the only basis for a high-impact recommendation.
- The note gives a Verified as of date, so a later session can tell whether to reuse it.
- Sources that contradict the likely answer are listed, and so are sources that could not be reached.
- The researcher doesn't invent a citation, and doesn't call an option supported, certified or prohibited without evidence.

## Commits

Research changes no code, so there's no build, check or review for a research item. Its note and its records are committed together:

- In a design session, they join the session's commit.
- A `/research` run outside a design session commits them as `/next-task` does, after the director approves the commit.
- A run the director asks for, such as "work through the queue", approves its research commits in advance, as it does for `/next-task` (see [Commits](next-task.md#commits)).

## Web access

Web search and fetch are allowed for every research session in all three frameworks. The `researcher` has both tools, and each framework's settings allow them, so the researcher checks the web for the current facts a question needs. Confidential project text never goes into a search query or a fetch request. Queries stay in generic terms about the technology, and project text is quoted only inside the note.

## Unique per repo

### App-Director

The procedure is at [`framework/.app-director/procedures/research.md`](https://github.com/Freakling/App-Director/tree/v1.7.1/framework/.app-director/procedures/research.md) in the App-Director repository.

- The domain file, [`research-domain.md`](https://github.com/Freakling/App-Director/tree/v1.7.1/framework/.app-director/research-domain.md), covers stacks and libraries (maturity, maintenance, advisories, licence and platform support), licences, and app-store and platform requirements. Those requirements are tier 1 binding requirements.
- Notes go in `product/research/`, named `YYYY-MM-DD-<slug>.md`.
- The item heading is `Brief:`, and an item that informs no question writes `Informs: -`.
- The decision line in `product/decisions.md` ends its "why" with the note's path.

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/research.md`](https://github.com/Freakling/Godot-Director/tree/v4.1.1/framework/.godot-director/procedures/research.md) in the Godot-Director repository.

- The domain file, [`research-domain.md`](https://github.com/Freakling/Godot-Director/tree/v4.1.1/framework/.godot-director/research-domain.md), covers the Godot docs for the project's engine version, plugins and assets (maintenance, engine version support and licence), export and store requirements, and comparable games as design references.
- Comparable games are design references with Low or Medium confidence, and each option names the Design Pillar it serves or strains.
- Notes go in `design/research/`, named `YYYY-MM-DD-<slug>.md`.
- The item heading is `GDD:`, and an item that informs no question writes `Informs: (none)`.
- The decision line in `design/decisions.md` ends its "why" with the note's path.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/research.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.1/framework/.satt/procedures/research.md) in the SaaSAllTheThings repository.

- The domain file, [`research-domain.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.1/framework/.satt/research-domain.md), covers Azure when Azure is central to the question, the reference architecture and the customer's security framework. The reference architecture holds unless an accepted ADR says otherwise, and the requirements in `compliance/` are tier 1. Each requirement is traced to its control, labelled direct, partial, interpretive or unverified.
- Notes go in `product/research/`, named `YYYY-MM-DD-<slug>.md`.
- The item heading is `PRD:`, and an item that informs no question writes `Informs: none`.
- For an architecture question, the note ends with an ADR-ready summary. The [`/architect`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.1/framework/.satt/procedures/architect.md) session lists the research on file, and when a decision followed the research, the ADR names the note in its Context. The researcher never writes an ADR and never accepts one.
- Confidential text is wider here: PRD and ADR text, tenant and subscription identifiers, integration contracts and anything from `compliance/` stay out of search queries, including the query strings of URLs.

<div class="takeaway"><span>The researcher informs. The director decides.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
