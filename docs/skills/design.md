# /design

<div class="kicker">A design session, one decision at a time</div>

`/design` runs a design session with the director. It takes one topic, ranks the open questions by what they unblock, or changes how part of the project works. The skill writes down only what the director decides. Its job is to make those decisions fast and well informed, never to make them.

## What it does

1. **Prepare** by reading the open questions, the design text the topic touches and the related lines in the decision log. It doesn't re-propose a settled decision without saying what has changed since.
2. **Brief** the director with the relevant design text and past decisions before any options appear.
3. **Ask** one question at a time. Each question gets two to four options, with what each would take to build, and one recommendation. The skill waits for the answer, and records only the part the director answered.
4. **Record** each decision in one change: the design text is rewritten as the current design, one line goes in the decision log, the answered question is removed, and any follow-up questions become new open questions. The tasks the decision creates go into `TASKS.md`.
5. **Finish** by summarising what was decided and what is still open. Once the director approves, the skill commits the design files as `docs: <summary>`, with a body listing each decision (see `rules.md` › Git). A design session never edits source code.
6. **Clear** the context after the commit. The skill suggests `/clear`, or a fresh session, before the next topic: the records hold everything, and the conversation history no longer adds value.

Run it as `/design <topic>` for a topic, or `/design questions` to rank the open questions. Numbers and limits stay placeholders until the director sets them.

## Unique per repo

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/design.md`](https://github.com/Freakling/Godot-Director/tree/v3.8.0/framework/.godot-director/procedures/design.md) in the Godot-Director repository.

- It reads the Design Pillars and the GDD's Open Questions, and records decisions in `design/gdd.md` and `design/decisions.md`.
- If an idea contradicts a Design Pillar, the skill stops and asks which gives way, the pillar or the idea.
- New items carry a `GDD:` heading and follow the format in `.godot-director/tasks.md`. A big rework is planned in stages: first move rules out of screens, then rework the systems, then rebuild the UI.
- The session leaves data and scenes alone. Tunable values are placeholders the director edits in the `.tres` files.
- A complex question that depends on facts nobody has checked goes to the `researcher`. The note goes in `design/research/`, and a decision that followed it ends its `why` with the note's path.

### App-Director

The procedure is at [`framework/.app-director/procedures/design.md`](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/design.md) in the App-Director repository.

- It records decisions in `product/brief.md` and `product/decisions.md`, and open questions live in the brief's Open Questions section.
- Before the options, it quotes the related lines from `product/decisions.md` word for word, so the director sees the state of play first.
- New items carry a `Brief:` heading and follow the format in `.app-director/tasks.md`. Numbers and thresholds are set by the human in config or environment variables.
- A question whose options depend on facts nobody has checked goes to the `researcher`. The note goes in `product/research/`, and a decision that followed it ends its `why` with the note's path.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/design.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/design.md) in the SaaSAllTheThings repository.

- It records decisions in the PRD (`product/prd.md`) and `product/decisions.md`. A decision about an external system's data also goes into `integrations/<system>/contract.md`.
- Questions about how the system is built, such as a data store, a client's UI technology or a deviation from the reference, are not product calls. The skill hands them to `/architect` (the `architect.md` procedure).
- If an idea contradicts a Product Pillar, the skill asks which gives way. New items carry a `PRD:` heading and follow the format in `.satt/tasks.md`, and limits, quotas, prices and timeouts stay `PLACEHOLDER` values.
- It accepts both `/design questions` and `/design {topic}`.
- A question that depends on facts nobody has checked goes to the `researcher`. The note goes in `product/research/`, and a decision that followed it ends its `why` with the note's path.

<div class="takeaway"><span>Write down only what the director decides. Bring your next open question to <code>/design</code> in a fresh session.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
