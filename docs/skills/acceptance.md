# Acceptance check

<div class="kicker">A human ticks what the running project does</div>

An acceptance check is a checklist of built behaviour that a person verifies in the running project, item by item. The person ticks each item Works or Broken. The skill is `/acceptance` in App-Director and SaaSAllTheThings, and `/function-check` in Godot-Director, where the same idea is called a function check. This is one page for both, because they are the same concept under two names.

How to use it: [How do I check that what was built works?](../how-to/check.md), which covers `/function-check` in Godot-Director too.

## What it does

1. **Prepare.** The skill runs the check first and stops if it fails, since a build that fails the check isn't worth testing by hand. It then collects the items that only a person can verify in the running project, from the done items, and keeps the ones not ticked in an earlier checklist. Finished bugs with no regression test are added, with the outcome "the repro no longer happens".
2. **Write the checklist.** Items are grouped by the design section they belong to. Each one says what the person should see, with a short *How* hint on how to reach that state. Under each item are the user stories it serves, word for word, each with ticks of its own ([User stories](../concept/user-stories.md)).
3. **The person ticks.** Works or Broken, with notes on anything that went wrong, and Still right or Needs a change for each story. Items left blank are checked in the next round.
4. **Process.** Works needs no record. Broken becomes a bug item, with the repro from the notes and a severity judged from the notes. If the notes say the behaviour itself should change, it isn't a bug: the skill raises a design question instead (a product question in SaaSAllTheThings). It offers options following `design.md`, or adds an Open Question for the director to settle, and it doesn't log the note as a bug. A story ticked Still right is dated as confirmed. One that Needs a change is rewritten from the notes, and kept `unconfirmed` until the director confirms it if the skill had to interpret them.
5. **Finish** by showing one summary of the bug items, the story rewrites and ticks, the design findings and the Processed line. Nothing is written until the director approves it. The skill then marks the checklist as processed and commits the checklist and any new items.

The request is `prepare` (the default), `process`, or `all` for a full regression round. `all` keeps every item the person needs to verify, plus one item for each design rule that no done item covers, which picks up behaviour the project had before the framework.

## Unique per repo

### Godot-Director

The skill is `/function-check`. Its procedure is at [`framework/.godot-director/procedures/function-check.md`](https://github.com/Freakling/Godot-Director/tree/v4.10.1/framework/.godot-director/procedures/function-check.md) in the Godot-Director repository.

- It collects the `(play)` outcomes, which are what a person sees while playing. The checklist is written to `playtesting/YYYY-MM-DD-function-check.md`.
- It plays the scenarios behind the `(autoplay)` outcomes first, and lists the clean ones as pre-verified with their review, such as `playtesting/autoplay/trade_week-1-20261017-101500/review.md`, so the person checks only what a machine can't judge.
- A done `UI:` item asks the person to judge the screen against their drawing and links its compare image, such as `design/ui/captures/hero_room.compare@1920x1080.png`, regenerated first when capture can run.
- Severity is `high` if the game crashes or blocks play, `low` if it is cosmetic, and `med` otherwise.
- The commit message is `docs: process function check YYYY-MM-DD`.
- In a game that uses user stories, the function check shows the stories behind its items, and a playtest the stories behind the items built since the previous report, each with the same two ticks.
- The sibling skill `/playtest` is a different job. It asks how the game feels, and it starts or processes a playtest report into bugs, design proposals and score trends.

### App-Director

The procedure is at [`framework/.app-director/procedures/acceptance.md`](https://github.com/Freakling/App-Director/tree/v1.14.1/framework/.app-director/procedures/acceptance.md) in the App-Director repository.

- It collects the `(demo)` outcomes, and the checklist is written to `validation/YYYY-MM-DD-acceptance.md`.
- The checklist header names the environment, `local`, `staging` or `prod`, and the *How* hints name the test account and any state the item needs.
- A done `UI:` item asks the person to judge the screen against their drawing and links its compare image, such as `product/ui/captures/hero_room.compare@1920x1080.png`, regenerated first when capture can run.
- Severity is `high` if the app loses data, blocks a core flow or crashes, `low` if it is cosmetic, and `med` otherwise.
- `all` adds one item for each core flow in the brief that no done item covers.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/acceptance.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.16.1/framework/.satt/procedures/acceptance.md) in the SaaSAllTheThings repository.

- It collects the `(demo)` outcomes, and the checklist is written to `validation/YYYY-MM-DD-acceptance.md` with the environment, `local` or `dev`.
- Each item names the client and the role to use. Items about tenant isolation tell the tester to sign in as the second test tenant and confirm that the first tenant's data isn't visible.
- A done `UI:` item asks the person to judge the screen against their drawing and links its compare image, such as `product/ui/captures/orders.compare@1920x1080.png`, regenerated first when capture can run.
- Severity is `high` if the app loses data, shows another tenant's data, fails sign-in or blocks work.
- `all` adds one item for each PRD rule that no done item covers.
- The sibling skill `/feedback` is a different job. It records a customer, pilot or tester session by role and tenant label, never by name, and turns the findings into bugs, score trends and product proposals.

<div class="takeaway"><span>Tests prove the rules, and a person proves the rest. Run the next acceptance check before you close a milestone.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
