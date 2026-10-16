# Check a build by hand with the acceptance check

<div class="kicker">You tick what works in the running project, the agent turns the rest into bugs</div>

> The agent writes a checklist of built behaviour. You run the project and tick each item Works or Broken.

This guide is for someone who has never run an acceptance check. App-Director and SaaSAllTheThings ship it as `/acceptance`, and Godot-Director ships it as `/function-check`, where it is called a function check. The two are the same idea, so this guide covers both and says where they differ. The [skill page](../skills/acceptance.md) describes the command, and the procedure for each framework has the details (see [More](#more)).

## What you need to know

- **What it's for.** Tests prove the rules and commands prove the setup, and a person proves the rest. The checklist holds what only a person can verify in the running project: the `(demo)` outcomes in App-Director and SaaSAllTheThings, the `(play)` outcomes in Godot-Director, and bug fixes that have no regression test.
- **Who runs the project.** You do, or whoever tests for you. A person ticks every item.
- **Where the checklist goes.** App-Director and SaaSAllTheThings write `validation/YYYY-MM-DD-acceptance.md`. Godot-Director writes `playtesting/YYYY-MM-DD-function-check.md`.
- **What you need.** The project running somewhere you can use it: locally, or on staging or prod in App-Director, or on a dev environment in SaaSAllTheThings. The checklist names the environment, and a test account where one is needed.
- **A function check is not a playtest.** In Godot-Director, `/playtest` asks how the game feels, and `/function-check` asks whether each rule works. In SaaSAllTheThings, `/feedback` records a customer or pilot session, and `/acceptance` asks whether each built rule works.

## What you need to do

1. **Run `/acceptance` or `/function-check`.** The default is `prepare`. Add `all` for a full regression round, which also covers each rule in the design that no finished item covers. The agent runs the check first and stops if it fails, since a build that fails the check isn't worth testing by hand.
2. **Open the checklist.** The agent collects the outcomes you haven't ticked in an earlier checklist, groups them by design section, and tells you the file. Each item says what you should see, with a *How* hint on how to get to that state.
   - **App-Director:** the header names the environment (`local`, `staging` or `prod`), and the hints name the test account and any state the item needs.
   - **SaaSAllTheThings:** each item names the client and the role. Items about tenant isolation tell you to sign in as the second test tenant and confirm the first tenant's data isn't visible.
   - **Godot-Director:** a finished screen item links a compare image, with your drawing's screenshot on the left and the screen as it is now on the right. Judge the screen against your drawing, and try it with the mouse, the keyboard and a pad. See [Design a screen with /ui-design](ui-design.md) for where the drawing comes from.
3. **Run the project and tick.** Go through the items. Tick Works or Broken / missing for each one. Under Notes, say what went wrong: what you did, what you expected and what you saw. Leave both boxes empty for an item you didn't check, and it comes back in the next round.
4. **Run the same command with `process`.** `/acceptance process` or `/function-check process`. For a Works item there is nothing to record, because the ticked file is the record. A Broken item becomes a bug item (`B<n>`), with the repro taken from your notes and a severity judged from them.
   - **App-Director:** `high` if the app loses data, blocks a core flow or crashes, `low` if it is cosmetic, and `med` otherwise.
   - **SaaSAllTheThings:** `high` if the app loses data, shows another tenant's data, fails sign-in or blocks work, `low` if it is cosmetic, and `med` otherwise.
   - **Godot-Director:** `high` if the game crashes or blocks play, `low` if it is cosmetic, and `med` otherwise.
5. **Answer if the behaviour itself should change.** If your notes say the rule should be different, it isn't a bug. The agent offers design options, or adds an open question for you to settle, and the note is not logged as a bug. Use [`/design`](design.md) to decide.
6. **Approve the commit.** The agent adds a `Processed:` line under the header and commits the checklist and the new items as `docs: process acceptance check YYYY-MM-DD` (`docs: process function check YYYY-MM-DD` in Godot-Director) once you say yes. [`/next-task`](next-task.md) then builds the bugs.

## Caveats

- **Notes drive the bug.** The agent takes the repro from what you wrote, so a precise note gives a precise bug.
- **Use test accounts.** The *How* hints name the account to use. Keep real users' accounts out of it.
- **Fix the check first.** A failing `bash tools/check.sh` stops the preparation.
- **An unticked item waits.** Nothing is lost by leaving it blank, because it is collected again next time.
- **Run it before you close a milestone.** The `all` round is also the way to bring a project that had features before the framework under a checklist.

## More

- The [acceptance check skill page](../skills/acceptance.md), with what is unique to each framework.
- The procedures, which are the source of truth for the steps: [App-Director v1.6.0](https://github.com/Freakling/App-Director/tree/v1.6.0/framework/.app-director/procedures/acceptance.md), [SaaSAllTheThings v0.8.0](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/acceptance.md) and, for `/function-check`, [Godot-Director v3.11.0](https://github.com/Freakling/Godot-Director/tree/v3.11.0/framework/.godot-director/procedures/function-check.md).
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>Tests prove the rules, and you prove the rest. Run the check before you close a milestone.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
