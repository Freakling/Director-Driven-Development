# /design

<div class="kicker">A design session, one decision at a time</div>

`/design` runs a design session with the director. It takes one topic, ranks the open questions by what they unblock, or changes how part of the project works. The skill writes down only what the director decides. Its job is to make those decisions fast and well informed, never to make them.

How to use it: [How do I decide what gets built, or change how something works?](../how-to/decide.md)

## What it does

1. **Prepare** by reading the open questions, the design text the topic touches and the related lines in the decision log. It doesn't re-propose a settled decision without saying what has changed since.
2. **Brief** the director with the relevant design text and past decisions before any options appear.
3. **Ask** one question at a time. Each question gets two to four options, with what each would take to build, and one recommendation. The skill waits for the answer, and writes nothing yet: the answers stay in the conversation. A chat message or an "Other" answer during the session is a scope change, not an answer to record. It re-opens the options it touches, and the session reassesses, then restarts or continues.
4. **Summarise** once every question is answered: one summary of everything the session will write, each file, line, item and story as it will read. The skill asks "Approve this summary, or tell me what to change?", and only a yes to the summary as shown approves it.
5. **Record** each decision in one change, as the summary shows it: the design text is rewritten as the current design, one line goes in the decision log, the answered question is removed, and any follow-up questions become new open questions. The tasks the decision creates go into `TASKS.md`. The approval is also the approval to commit: the skill commits the design files as `docs: <summary>`, with a body listing each decision (see `rules.md` › Git). A design session never edits source code. It finishes by saying what is still open.
6. **Clear** the context after the commit. The skill suggests `/clear`, or a fresh session, before the next topic: the records hold everything, and the conversation history no longer adds value.

A question that depends on facts nobody has checked goes to the [researcher](research.md). The researcher writes a note in the repo's research folder, and a decision that followed it ends its `why` with the note's path.

Run it as `/design <topic>` for a topic, or `/design questions` to rank the open questions. Numbers and limits stay placeholders until the director sets them.

Each option names the user stories it serves and drafts the new or changed ones it needs, for the director to confirm with the option ([User stories](../concept/user-stories.md)). The same procedure validates the stories on request, or when `/next-task` proposes it, and harvests a prototype ([/prototype](prototype.md)).

## Unique per repo

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/design.md`](https://github.com/Freakling/Godot-Director/tree/v4.10.1/framework/.godot-director/procedures/design.md) in the Godot-Director repository.

- It reads the Design Pillars and the GDD's Open Questions, and records decisions in `design/gdd.md` and `design/decisions.md`.
- If an idea contradicts a Design Pillar, the skill stops and asks which gives way, the pillar or the idea.
- New items carry a `GDD:` heading and follow the format in `.godot-director/tasks.md`. A big rework is planned in stages: first move rules out of screens, then rework the systems, then rebuild the UI.
- The session leaves data and scenes alone. Tunable values are placeholders the director edits in the `.tres` files.
- Research notes go in `design/research/`.
- User stories are optional. The procedure turns them on or off when the director asks, and asks about stories only in a game that uses them.

### App-Director

The procedure is at [`framework/.app-director/procedures/design.md`](https://github.com/Freakling/App-Director/tree/v1.14.1/framework/.app-director/procedures/design.md) in the App-Director repository.

- It records decisions in `product/brief.md` and `product/decisions.md`, and open questions live in the brief's Open Questions section.
- Before the options, it quotes the related lines from `product/decisions.md` word for word, so the director sees the state of play first.
- New items carry a `Brief:` heading and follow the format in `.app-director/tasks.md`. Numbers and thresholds are set by the human in config or environment variables.
- Where an option touches security (input, authentication, sessions, secrets, data access, file or network access, dependencies), it states the OWASP item it touches and whether it meets, strengthens or would deviate from the [OWASP baseline](../frameworks/app-director.md#the-owasp-baseline). An option that would deviate is shown with the accepted decision it needs, and is never recommended without saying so.
- Research notes go in `product/research/`.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/design.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.16.1/framework/.satt/procedures/design.md) in the SaaSAllTheThings repository.

- It records decisions in the PRD (`product/prd.md`) and `product/decisions.md`. A decision about an external system's data also goes into `integrations/<system>/contract.md`.
- Questions about how the system is built, such as a data store, a client's UI technology or a deviation from the reference, are not product calls. The skill hands them to `/architect` (the `architect.md` procedure).
- If an idea contradicts a Product Pillar, the skill asks which gives way. New items carry a `PRD:` heading and follow the format in `.satt/tasks.md`, and limits, quotas, prices and timeouts stay `PLACEHOLDER` values.
- An ADR is accepted only by the director's approval of the summary that lists it, with its status. In a live group workshop, the read-back at the end is the summary the room approves, and the notes are written from it.
- It accepts both `/design questions` and `/design {topic}`. `/product` still runs the same session; it is a deprecated name for `/design`.
- Research notes go in `product/research/`.

<div class="takeaway"><span>Write down only what the director decides. Bring your next open question to <code>/design</code> in a fresh session.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
