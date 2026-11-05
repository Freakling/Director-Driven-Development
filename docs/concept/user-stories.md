# User stories

A user story says what a role does in the product and why. The stories tell the agent why each thing is built, so the work stays aligned with the design, and they give you one place to confirm that what you asked for is still what you want. The agent drafts them and only you confirm them.

## Why stories anchor each item

The design text says what the product is. The stories say, for each role, what that role does and why it matters. Every feature item names the stories it serves, so the builder reads the reason together with the design sections the item points to.

A feature with no story gets one before it is built. `/next-task` drafts it, marks it `unconfirmed`, and names it in its report for you to confirm. Foundation, tooling and infrastructure items change nothing a user does, so they name no story.

## The stories file

Each project keeps its stories in one file, and each framework's "Each fact lives in one place" table names it ([which file is it in?](../how-to/where.md)). It holds:

- **The value in one paragraph per role,** so the agent knows what each role is after.
- **The roles,** one line each.
- **One table of stories per area,** each row an ID (`US-<n>`), the story, and the date you last confirmed it or `unconfirmed`.
- **A header** with the next story ID and the date and commit of the last validation.

```
| ID | Story | Confirmed |
|---|---|---|
| US-2 | As a member I say whether I'm coming with one tap, so the organiser knows how many to expect. | 2026-11-01 |
| US-3 | As an organiser I schedule a meeting and every member is told, so I don't have to message each of them. | unconfirmed |
```

A story names no screen, technology or implementation. IDs are never reused: a dropped story's row is deleted.

On an item, `Stories:` sits next to the design heading (`Brief:`, `PRD:` or `GDD:`), such as `Stories: US-2, US-5`. A bug names the story whose behaviour it restores. A research item names none.

## How stories are written

**A design drafts them.** When a design session offers options, it names the stories each option serves and drafts the new or changed ones the option needs. You confirm them together with the option, and each one you confirm is dated that day. A drafted story you don't answer goes in as `unconfirmed`, and comes back at the next validation.

**An existing project's stories are written from the code.** Onboarding writes them for an existing app or game, as what each role can do today and not as a plan. Every one is `unconfirmed`, the file says they were written from the code before the project kept stories, and the first validation is proposed to you. In SaaSAllTheThings the assessment writes them first, into the readiness report with the evidence for each, and the design sessions and workshops that follow confirm them. See [I already have a project](../how-to/existing.md).

A prototype's harvest files the stories you confirm, each naming the prototype ([How do I try a change before it's built?](../how-to/prototype.md)).

## How you validate them

Four moments put the stories in front of you, and a story you don't answer stays as it is.

1. **In the design.** The session that drafts a story asks you to confirm it with the option it belongs to ([How do I decide what gets built?](../how-to/decide.md)).
2. **On a cadence of built items.** `bash tools/stories.sh --due` counts the items built since the commit on the file's last-validated line against `[stories] every` in `tools/check.cfg`, which is 10 by default. It also says due while the stories have never been validated. `/next-task` proposes the validation when it is due, and a run of several items names it in its final report instead of stopping. The validation shows each story the recent items served, and each one still unconfirmed, and you confirm, correct or drop it. Then the last-validated line moves.
3. **In the human round.** The acceptance check shows the stories behind its items, with *Still right* and *Needs a change* ticks beside Works and Broken. In Godot-Director the function check does the same, and the playtest shows the stories behind the items built since the previous report. Processing the round dates a story you ticked Still right and rewrites one that needs a change from your notes. If the agent had to interpret your notes, it shows its reading and keeps the story `unconfirmed` until you confirm it. If the notes say the built behaviour should change too, that is a design question ([How do I check that what was built works?](../how-to/check.md)).
4. **In align.** `/align` lists the stories no item serves, the feature items and bugs with no story, and the stories still unconfirmed when a validation is due ([The records and the code don't agree](../how-to/align.md)).

## What differs per framework

| | App-Director | Godot-Director | SaaSAllTheThings |
|---|---|---|---|
| Stories | Always kept | Optional: onboarding asks once whether the game uses them, and records `User stories: on` or `off` in `AGENTS.md` › Project rules | Always kept |
| File | `product/user-stories.md` | `design/user-stories.md`, linked from the GDD | `product/user-stories.md` |
| Roles | The roles the app serves | The player, and a streamer or a modder where the game has them: "As a player I ..." | The personas in the PRD, by the same names. Each PRD capability names the stories it serves |
| A table per | Area | Design Pillar or system in the GDD | Area |
| An item with no story | `Stories: -` | `Stories: (none)` | `Stories: none` |
| Validated in the human round | The acceptance check | The playtest and the function check | The acceptance check |
| Written from existing code by | Onboarding | Onboarding, or a later "turn on user stories" | The assessment, then onboarding |

With stories off in Godot-Director nothing changes: there is no file, no item has `Stories:`, and nothing asks. You can turn them on later by asking for it.

Stories are part of the design procedure and have no skill of their own. The procedures are the source of truth: see the user stories sections of the design procedure of [App-Director](https://github.com/Freakling/App-Director/tree/v1.14.1/framework/.app-director/procedures/design.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.10.1/framework/.godot-director/procedures/design.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.16.1/framework/.satt/procedures/design.md).

The file starts from a seed in App-Director ([`user-stories.md`](https://github.com/Freakling/App-Director/blob/v1.14.1/project/product/user-stories.md)) and SaaSAllTheThings ([`user-stories.md`](https://github.com/Freakling/SaaSAllTheThings/blob/v0.16.1/project/product/user-stories.md)), and from a [template](https://github.com/Freakling/Godot-Director/blob/v4.10.1/framework/.godot-director/templates/user-stories.md) in Godot-Director. `tools/stories.sh --due` says whether a validation is due and changes nothing: [App-Director](https://github.com/Freakling/App-Director/blob/v1.14.1/framework/tools/stories.sh), [Godot-Director](https://github.com/Freakling/Godot-Director/blob/v4.10.1/framework/tools/stories.sh) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/blob/v0.16.1/framework/tools/stories.sh).

<div class="takeaway" markdown><span>The agent drafts the stories. You confirm why each thing is built.</span><span class="url" markdown="span">[Design calls](design-calls.md)</span></div>
