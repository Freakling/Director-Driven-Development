# Anchor: record only after the director approves a summary

The agreed behaviour of how a session turns the director's choices into records, in App-Director, Godot-Director and SaaSAllTheThings. This file lives only in this repository. A task in each framework's own `TASKS.md` carries it there (T280 for App-Director, T281 for SaaSAllTheThings, T282 for Godot-Director), and that framework's build agents change its rules and procedures. Brief: Scope › Framework features.

How to read it:
- **Part A** (sections 1-3) is what changes in the framework: the purpose, where the rule and the step sit, and their wording.
- **Part B** (section 4) is what the audit compares.

## Placeholders

| Placeholder | App-Director | Godot-Director | SaaSAllTheThings |
|---|---|---|---|
| `<design doc>` | the brief, `product/brief.md` | the GDD, `design/gdd.md` | the PRD, `product/prd.md`, and the ADRs in `adr/` |
| `<decision log>` | `product/decisions.md` | `design/decisions.md` | `product/decisions.md` |
| `<open questions>` | brief › Open Questions | GDD › Open Questions | PRD › Open Questions |
| `<written>` (what a summary lists) | file, line, item and story | file, line, item and story (stories only in a game with `User stories: on`) | file, line, item, story and ADR status |
| the sessions that write records from a conversation | `design.md`, `research.md`, `next-task.md`, `drift-reset.md`, `ui-design.md`, `acceptance.md`, `align.md`, `ONBOARDING.md` | `design.md`, `research.md`, `next-task.md`, `drift-reset.md`, `ui-design.md`, `playtest.md`, `function-check.md`, `export.md`, `release.md`, `align.md`, `ONBOARDING.md` | `design.md`, `research.md`, `next-task.md`, `drift-reset.md`, `ui-design.md`, `acceptance.md`, `feedback.md`, `architect.md`, `integrate.md`, `assess.md`, `align.md`, `workshops/README.md`, the `saas-design-session` skill, `ONBOARDING.md` |

`ONBOARDING.md` sits at the repository root in all three. The texts say "the human", as the procedures do; where the file being edited says "the director" (several SaaSAllTheThings files do), the builder uses that file's word.

# Part A: what the framework changes

## 1. Purpose and role

- The director decides what is recorded, and sees all of it before any of it is written. Nothing is written without the director's explicit approval.
- Until the approval, answers live in the conversation. A chat message or an "Other" answer during a session is a scope change or a modification, not an answer to record: it re-opens the options it touches, and the session reassesses, then restarts or continues.
- Once everything is chosen, one summary lists every `<written>` to be written. The director approves it; then everything is written and committed in one change.
- Two defaults belong to the rule. Align's mechanical fixes are part of the summary, so align writes a fix only after the approval. In a live group workshop the room's read-back at the end is the summary the room approves.

## 2. Where it sits

- **`rules.md`:** one bullet in The human decides (Who decides in SaaSAllTheThings), right after the design-call bullet. That bullet's "Write down only what was chosen" stays; the new bullet says when.
- **`design.md`:** a section, Summary and approval, between For each question and Record each decision in one change. The last step of For each question (the wait) holds the answers instead of recording a part, and Finish writes and commits what the summary lists.
- **The other procedures** get the one-line pointer at the step where they record. Their "commit after the human approves" line becomes a commit of the approved summary, since the approval is already given.

| Procedure | The pointer sits at | The summary lists |
|---|---|---|
| `design.md` › Validate the stories | Record | the stories changed, their Confirmed dates, and the Last validated line |
| `design.md` › Harvest a prototype | Record | the decisions, stories and items, each naming the prototype (SaaSAllTheThings: also each ADR's status) |
| `research.md` | Starting research, step 4 | the note and its `R<n>` item (inside a design session they join its summary) |
| `next-task.md` › Report `blocked` | the design decision, before the rebuild | the decision's records, as `design.md` lists them (SaaSAllTheThings: `blocked: architecture` points to the architect session's summary) |
| `drift-reset.md` | the steps that write the design and the plan | one summary with the decisions, the design diff and the rebuild plan, TASKS.md items included, before anything is written; a postmortem's chosen checks and items likewise |
| `ui-design.md` | process, Record in one change | the spec, the decision lines, the open questions and the item |
| `acceptance.md`, `playtest.md`, `function-check.md`, `feedback.md` | Process, before the first record | the `B` items (a bug no longer becomes an item "straight away"), the story rewrites or ticks, the records of design findings, and the Processed line |
| `align.md` | Report | the mechanical fixes, before they are written; inside a session or onboarding they join its summary |
| `ONBOARDING.md` | the end of the interview | the records the interview and the human's own document produce, written after the approval |
| SaaSAllTheThings: `architect.md` | Record, after Propose's wait | the ADR with its status, the exceptions, the TASKS.md items, the AGENTS.md lines and the compliance mapping rows |
| SaaSAllTheThings: `integrate.md` | 2. Work out the contract | the contract, filled from the rounds' answers (held until then), with the TASKS.md items, AGENTS.md rows and PRD link |
| SaaSAllTheThings: `assess.md` › Process workshop notes | before the first record | the PRD changes, ADR drafts with their status, the contract, stories, open questions, human items and the Processed line |
| SaaSAllTheThings: `workshops/README.md`, `saas-design-session` skill | Notes, Writing it down | the notes file: decisions, stories, open questions, actions and ADR drafts |
| Godot-Director: `export.md`, `release.md` | between the last round and "Write it down" | what "Write it down" will write |
| Godot-Director: `design.md` › User stories | Turning them on, Turning them off | the `User stories` switch with the file, the GDD link and the items' `Stories:` lines |

## 3. The wording

The framework's `rules.md` gets this bullet. The placeholders take the values in the table above.

```
- **Nothing is written without the human's explicit approval.** While a session runs, the answers stay in the conversation. A chat message or an "Other" answer during a session is a scope change or a modification, not an answer to record: it re-opens the options it touches, and the session reassesses, then restarts or continues. Once everything is chosen, show a summary of every <written> to be written (`design.md` › Summary and approval), and write and commit all of it in one change only after the human approves the summary.
```

The framework's `design.md` rewords the wait, the last step of For each question, and gets this section between For each question and Record each decision in one change:

```
N. Wait for the human. Hold the answer in the conversation: nothing is recorded yet, and an answered part is not recorded by itself. If you had to interpret the answer, state your reading and ask them to confirm it.

## Summary and approval
When every question of the session is answered, show one summary of everything the session will write, and wait. Nothing is written before the human approves it.
1. **List it.** For each file, what it gets, as it will read:
   - the <design doc> text written or replaced;
   - each line for the <decision log>, word for word;
   - the <open questions> removed or added;
   - each TASKS.md item, new or changed, in full;
   - each user story with its ID and its Confirmed date, or `unconfirmed`;
   - the research notes and `R<n>` items;
   <ADR line: SaaSAllTheThings only, see below; delete this line elsewhere>
2. **Ask:** "Approve this summary, or tell me what to change?"
3. **Re-open on any change.** A chat message or an "Other" answer, before the summary or after it, is a scope change or a modification: re-open the options it touches, research a new fact if the options now depend on one, then restart the session from the first affected question or continue, and show a new summary. Only a yes to the summary as shown approves it.
```

Finish loses its separate approval for the commit, since the summary carries it. Its first two bullets read as follows; the closing bullet about starting the next topic in a fresh session stays as the framework has it:

```
## Finish
- Write everything the approved summary lists and commit it as one change, `docs: <summary>`, with a body listing the decisions. The approval of the summary is the approval to commit (`rules.md` › Git). The session's research notes and `R<n>` items go in the same commit. A design session doesn't edit source code.
- Say what was decided, what's still open, and the next most useful question.
```

The other procedures in the table get this line at the step named there. Godot-Director's `playtest.md` and SaaSAllTheThings' `feedback.md` drop "straight away" from their bugs step.

```
Write nothing until the human approves a summary of all of it (`design.md` › Summary and approval); a chat message or an "Other" answer before then re-opens the options.
```

SaaSAllTheThings adds this line to the design.md list. App-Director and Godot-Director delete the ADR line there:

```
   - each ADR with the status it will be written with;
```

SaaSAllTheThings also puts this sentence in place of the "Only the director accepts an ADR" bullet of `rules.md` › Who decides, and of the status wording in Record step 1 of `architect.md` ("Status: proposed until the human has said in this conversation that they accept it"). `ONBOARDING.md`'s ADR-1 follows it too, instead of "since the human just decided":

```
An ADR is accepted only by the director's approval of the summary that lists it. The summary names each ADR with its status, and `architect.md` writes the ADR, its exceptions, the TASKS.md items, the AGENTS.md lines and the compliance mapping rows only after that approval. In Claude Code the hook still asks the director to confirm an edit that sets `Status: accepted`.
```

SaaSAllTheThings adds this for `workshops/README.md` and the `saas-design-session` skill, which hold a notes file in place of the records:

```
A one-to-one session holds its decisions, stories, open questions, actions and ADR drafts in the conversation, shows them as the summary, and writes the notes file after the human approves it. In a live group workshop the scribe still confirms each decision aloud as the room moves on, and the read-back at the end is the summary the room approves; the notes file is written from it.
```

Godot-Director adds these two sentences:

```
export.md › Set up exports and release.md › Set up release: after the last round, show a summary of everything "Write it down" will write (the presets or `release.cfg`, the GDD and decision lines, the AGENTS.md line, the workflow file) and wait for the human's approval. "Write it down" starts after it, and "Try it" runs on what it wrote. The open question and the item that a skipped step leaves go into the summary too.
```

```
design.md › User stories: turning them on or off is a write like any other. The summary lists the `User stories: on` or `User stories: off` line for AGENTS.md › Project rules, and with it the stories file, the GDD link and the items' `Stories:` lines. The switch is set only after the approval. The "Still right?" ticks of a playtest or function check are collected and listed in that procedure's summary.
```

# Part B: what the audit compares

## 4. What the audit compares

**The same in all three**

| Part | Behaviour |
|---|---|
| Rule | The `rules.md` bullet in the wording of section 3, in The human decides (Who decides in SaaSAllTheThings) |
| Step | `design.md` has Summary and approval between For each question and Record each decision in one change; its wait holds the answers; Finish writes and commits what the summary lists |
| Pointer | The one-line pointer at the record step of each procedure in the table of section 2 |
| Before approval | Nothing is written: no file, line, item, story or ADR status |
| After approval | Everything is written and committed in one change |
| Scope changes | A chat message or an "Other" answer re-opens the options, and the session reassesses and restarts or continues |
| Defaults | Align's mechanical fixes are part of the summary; in a live group workshop the room's read-back is the summary the room approves |
| Wording | "requirements", "control framework" or "security framework"; no en or em dashes |

**What each framework adds** is its column of the Placeholders table, the procedures marked for it in section 2, and the sentences of section 3: the ADR line and sentence and the workshop sentence for SaaSAllTheThings, the export, release and stories sentences for Godot-Director. The audit compares each framework's procedures at its latest release with the `/design` page; once the rule is released, the page records it.
