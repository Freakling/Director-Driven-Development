# Acceptance check

<div class="kicker">A human ticks what the running project does</div>

An acceptance check is a checklist of built behaviour that a person verifies in the running project, item by item. The person ticks each item Works or Broken. The skill is `/acceptance` in App-Director and SaaSAllTheThings, and `/function-check` in Godot-Director, where the same idea is called a function check. This is one page for both, because they are the same concept under two names.

## What it does

1. **Prepare.** The skill runs the check first and stops if it fails, since a build that fails the check isn't worth testing by hand. It then collects the items that only a person can verify in the running project, from the done items, and keeps the ones not ticked in an earlier checklist. Finished bugs with no regression test are added, with the outcome "the repro no longer happens".
2. **Write the checklist.** Items are grouped by the design section they belong to. Each one says what the person should see, with a short *How* hint on how to reach that state.
3. **The person ticks.** Works or Broken, with notes on anything that went wrong. Items left blank are checked in the next round.
4. **Process.** Works needs no record. Broken becomes a bug item, with the repro from the notes and a severity judged from the notes. If the notes say the behaviour itself should change, it isn't a bug: the skill raises a design question instead (a product question in SaaSAllTheThings). It offers options following `design.md`, or adds an Open Question for the director to settle, and it doesn't log the note as a bug.
5. **Finish** by marking the checklist as processed and committing the checklist and any new items once the director approves.

The request is `prepare` (the default), `process`, or `all` for a full regression round. `all` keeps every item the person needs to verify, plus one item for each design rule that no done item covers, which picks up behaviour the project had before the framework.

## Unique per repo

### Godot-Director

The skill is `/function-check`. Its procedure is at [`framework/.godot-director/procedures/function-check.md`](https://github.com/Freakling/Godot-Director/tree/v3.9.0/framework/.godot-director/procedures/function-check.md) in the Godot-Director repository.

- It collects the `(play)` outcomes, which are what a person sees while playing. The checklist is written to `playtesting/YYYY-MM-DD-function-check.md`.
- Severity is `high` if the game crashes or blocks play, `low` if it is cosmetic, and `med` otherwise.
- The commit message is `docs: process function check YYYY-MM-DD`.
- The sibling skill `/playtest` is a different job. It asks how the game feels, and it starts or processes a playtest report into bugs, design proposals and score trends.

### App-Director

The procedure is at [`framework/.app-director/procedures/acceptance.md`](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/acceptance.md) in the App-Director repository.

- It collects the `(demo)` outcomes, and the checklist is written to `validation/YYYY-MM-DD-acceptance.md`.
- The checklist header names the environment, `local`, `staging` or `prod`, and the *How* hints name the test account and any state the item needs.
- Severity is `high` if the app loses data, blocks a core flow or crashes, `low` if it is cosmetic, and `med` otherwise.
- `all` adds one item for each core flow in the brief that no done item covers.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/acceptance.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/acceptance.md) in the SaaSAllTheThings repository.

- It collects the `(demo)` outcomes, and the checklist is written to `validation/YYYY-MM-DD-acceptance.md` with the environment, `local` or `dev`.
- Each item names the client and the role to use. Items about tenant isolation tell the tester to sign in as the second test tenant and confirm that the first tenant's data isn't visible.
- Severity is `high` if the app loses data, shows another tenant's data, fails sign-in or blocks work.
- `all` adds one item for each PRD rule that no done item covers.
- The sibling skill `/feedback` is a different job. It records a customer, pilot or tester session by role and tenant label, never by name, and turns the findings into bugs, score trends and product proposals.

<div class="takeaway"><span>Tests prove the rules, and a person proves the rest. Run the next acceptance check before you close a milestone.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
