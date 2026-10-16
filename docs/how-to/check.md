# How do I check that what was built works?

<div class="kicker">You tick what works in the running project, the agent turns the rest into bugs</div>

> Say "Prepare an acceptance check". The agent writes a checklist of built behaviour, you run the project and tick each item Works or Broken, and the agent turns the Broken ones into bug items.

Tests prove the rules and the check proves the setup. A person proves the rest: the `(demo)` outcomes in App-Director and SaaSAllTheThings, the `(play)` outcomes in Godot-Director, and bug fixes that have no regression test. App-Director and SaaSAllTheThings ship the acceptance check as `/acceptance`, and Godot-Director ships it as `/function-check`. They are the same idea, so this page covers both.

## Two ways to do it

**Does each rule work? The acceptance check.** Say "Prepare an acceptance check" and later "Process the acceptance check", or type `/acceptance` (`/function-check` in Godot-Director, with "Prepare a function check" and "Process the function check"). The checklist is a record you keep: a dated file in the repository, so the same round can be repeated and an unticked item comes back next time. Use it before you close a milestone, and add `all` for a full regression round, which also covers each rule in the design that no finished item covers.

**How does it feel? `/playtest`.** Godot-Director ships `/playtest` for how the game feels, with scores and free comments. Say "New playtest", or "Process my playtest". It turns a filled-in report into bugs, score trends and design proposals. In SaaSAllTheThings, `/feedback` plays the same part for a customer or pilot session.

Saying it and typing the command run the same procedure.

## Steps

1. **Prepare.** The default is `prepare`. The agent runs the check first and stops if it fails, since a build that fails the check isn't worth testing by hand. Then it collects the outcomes you haven't ticked in an earlier checklist, groups them by design section, and tells you the file: `validation/YYYY-MM-DD-acceptance.md` in App-Director and SaaSAllTheThings, `playtesting/YYYY-MM-DD-function-check.md` in Godot-Director.
2. **Get the project running.** Locally, or on staging or prod in App-Director, or on a dev environment in SaaSAllTheThings. The checklist names the environment, and a test account where one is needed.
3. **Read each item.** It says what you should see, with a *How* hint on how to get to that state.
    - App-Director: the header names the environment, and the hints name the test account and any state the item needs.
    - SaaSAllTheThings: each item names the client and the role. Items about tenant isolation tell you to sign in as the second test tenant and confirm the first tenant's data isn't visible.
    - Godot-Director: a finished screen item links a compare image, with your drawing's screenshot on the left and the screen as it is now on the right (see [How do I work with UI changes?](ui.md)). Try it with the mouse, the keyboard and a pad.
4. **Tick.** Mark Works or Broken / missing for each item. Under Notes, say what went wrong: what you did, what you expected and what you saw. Leave both boxes empty for an item you didn't check, and it comes back in the next round.
5. **Process.** Run the same command with `process`. For a Works item there is nothing to record, because the ticked file is the record. A Broken item becomes a bug item (`B<n>`), with the repro taken from your notes and a severity judged from them: `high` if it loses data, blocks a core flow or crashes (in SaaSAllTheThings also if it shows another tenant's data or fails sign-in), `low` if it is cosmetic, and `med` otherwise.
6. **Answer if the behaviour itself should change.** If your notes say the rule should be different, it isn't a bug. The agent offers design options, or adds an open question for you to settle, and the note is not logged as a bug (see [How do I decide what gets built?](decide.md)).
7. **Approve the commit.** The agent adds a `Processed:` line under the header and commits the checklist and the new items once you say yes. [`/next-task`](build.md) then builds the bugs.

## What can go wrong

- **Notes drive the bug.** The agent takes the repro from what you wrote, so a precise note gives a precise bug.
- **Use test accounts.** The *How* hints name the account to use. Keep real users' accounts out of it.
- **A failing check stops the preparation.** Fix `bash tools/check.sh` first.
- **An unticked item waits.** Nothing is lost by leaving it blank, because it is collected again next time.
- **A function check is not a playtest.** `/playtest` asks how the game feels, and `/function-check` asks whether each rule works.

## Related

- The [acceptance check skill page](../skills/acceptance.md), and the concept [The check](../concept/check.md).
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/acceptance.md), [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/acceptance.md), and for Godot-Director [`/function-check`](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/function-check.md) and [`/playtest`](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/playtest.md).
- Once the bugs are fixed: [How do I ship it?](ship.md)

<div class="takeaway"><span>Tests prove the rules, and you prove the rest. Run the check before you close a milestone.</span><span class="url"><a href="index.md">All questions</a></span></div>
