# How do I work with UI changes?

<div class="kicker">Describe the change, draw it, or edit the screen yourself</div>

> Say what a screen should do and let the agent build it, or edit the screen yourself and tell the agent. In all three frameworks you can also draw the screen, and the agent builds to your drawing and checks the built screen against it.

## Three ways to do it

**By describing it.** Works in all three frameworks. Say what the screen should show and do: "The shop screen needs a filter bar above the item list". Settle what a screen is for, and any flow or behaviour the design doesn't cover, in a design session (see [How do I decide what gets built?](decide.md)). The decision becomes design text and task items, and [`/next-task`](build.md) builds them. You can also hand a small, settled change straight to the agent in a normal session. A direct request the agent can't finish in that session becomes an item in `TASKS.md`.

**With `/ui-design` and drawings.** Works in all three frameworks. You draw annotated boxes over a screenshot of the running game (Godot-Director) or the running web app (App-Director, and the web clients of SaaSAllTheThings), the agent reads exactly what you drew, records the layout once in a screen spec and builds the screen to it. Say "Capture the screens", "Redesign the shop screen", "Process my drawing" or "Verify the hero room", or type the command.

The drawing pays off when layout is the point and words are slow or vague: positions, sizes, what sticks and what scrolls, the order of keyboard and pad focus. It gives you a spec you can repeat from, and a built screen checked against your drawing. Drawing is optional. Capture and the layout lint work without it.

**By editing it yourself.** Works in all three frameworks, and is always an option. Open the scene in Godot, or the component in your editor for an app, make the change, and commit it through the normal flow. It is often the fastest way for a small change you can see, such as moving a button, changing a label or a colour. Pick it for a small, settled change. Pick a drawing for a redesign, or when you want the layout recorded and checked against your intent. Pick describing it when the change needs a design call. If the ownership table in `AGENTS.md` makes UI layout yours (onboarding asks, in Godot-Director for the UI row and in App-Director for visual design), the agent builds a minimal placeholder screen and the finished layout is your work, which makes this the usual path.

## Steps for describing a change

1. **Say the change.** Name the screen and what should differ.
2. **Answer the options.** If the change is a design call, the agent gives two to four options with a recommendation, and records what you choose.
3. **Let it be built.** Run `/next-task`, or give the task's ID. The check must pass before the commit.
4. **Look at it running.** Whether a screen looks and feels right is checked by a person. It comes up in the next check by hand (see [How do I check that what was built works?](check.md)).

## Steps for editing a screen yourself

1. **Make the change** in Godot or your editor, and run the game or app to see it.
2. **Commit through the normal flow.** The pre-commit hook runs the check on a commit that touches code, so a hand edit has to pass it like any other change. In Godot-Director that means no game rules in screen scripts and typed GDScript. In App-Director and SaaSAllTheThings it means the architecture rules of the framework. Never skip the hook.
3. **Tell the agent what changed.** Say which screen and how, such as "I moved the filter bar above the item list on the shop screen". A screen designed with `/ui-design` has a spec, the one place its layout is recorded, and the agent updates the spec and the screen's catalog entry to follow your edit (where they live: [what differs per framework](#what-differs-per-framework)). If you don't tell it, `/ui-design verify` reports the difference as a deviation from the spec. For a screen without a spec, tell the agent so the design text and the task list agree with the screen.
4. **Tell the agent about a decision too.** If the edit settles a question or changes how something works, say so, and it goes into the records as a design call.

## Steps for drawing a screen

The steps are the same in all three frameworks; the capture differs. Nothing to install for the drawing: Excalidraw runs in your browser and needs no account. The agent writes captures to `captures/` and each screen's spec to `<screen>.md`, both in the folder the table below names. Captures are gitignored; the spec and your drawing are part of your project. Your drawings go in `director/ui/`, which the agent reads and never writes to.

### What differs per framework

| | Godot-Director | App-Director | SaaSAllTheThings |
|---|---|---|---|
| What is captured | The game, rendered offscreen by the Godot engine (4.5 or newer) | The web app, opened on this machine in headless Chromium | The web client, opened on this machine in headless Chromium, as a test user of a seeded test tenant |
| To install | Nothing beyond Godot | Node 20 or newer, then once per clone `cd tools/ui && npm install && npx playwright install chromium` | The same as App-Director |
| Reads your drawing with | The Godot engine, headless | Node (Playwright isn't needed) | Node (Playwright isn't needed) |
| Screen catalog | `tools/ui_screens.gd` | `tools/ui/screens.mjs` | `tools/ui/screens.mjs` |
| Settings | `tools/ui_capture.cfg` | `tools/ui_capture.cfg`, with `[web] base_url`, the app on this machine | `tools/ui_capture.cfg`, with `[web]` `base_url`, `api_url`, `tenants` and, for the dev environment, `dev_url` |
| Folder for specs and captures | `design/ui/` | `product/ui/` | `product/ui/` |
| No capture yet | None | Native Flutter, mobile and desktop apps | Native Windows and mobile clients |

**Once per project.**

1. Run `/ui-design list`. The agent prints the screens in the catalog and any screen files it finds that the catalog doesn't cover. A new Godot-Director game's catalog starts with the game's main scene, and a new web project's with its root route. If the command isn't there, see [Something isn't there, or doesn't work](trouble.md).
2. Ask the agent to add the missing screens. Each entry says how the screen opens and how to put it in a representative state. In Godot-Director that is the scene, and the overlays a player sees over the screen. On the web it is the route and the states, such as an empty list, with each state's data seeded through the app's public API, never real user data.
3. On the web, point capture at your app. Onboarding asks for the address of the app running on this machine (`[web] base_url` in `tools/ui_capture.cfg`) and offers the one-time Playwright install.
    - SaaSAllTheThings: onboarding also asks for the seeded test tenants. A screen behind the sign-in opens as a test user of a seeded test tenant, with that user's sign-in saved once per clone by you or a developer, never a real account, token or customer's data. The web client keeps its sign-in in `localStorage` (or offers a test sign-in) so the saved one holds. The steps are in the catalog section of the [`ui-design` procedure](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.3/framework/.satt/procedures/ui-design.md).

**Capture.** Run `/ui-design capture <screen>`. The agent captures the screen in each state and at each size listed in `tools/ui_capture.cfg`, and gives you:

- a screenshot per state and size in `captures/`, such as `<screen>@1920x1080.png`;
- a `.lint.txt` file for each, listing layout findings such as squeezed text or overlapping controls (empty when clean);
- `<screen>.starter.excalidraw`, the drawing to draw over.

**Draw.** Open the starter in [Excalidraw](https://excalidraw.com), in the browser or as the desktop app.

1. The screenshot is locked inside a frame named after the screen. The faint numbered boxes are what the screen has now, numbered as in the map image. Delete the legend beside the frame once you know it.
    - To re-arrange a screen, drag a grey box to where the element should sit, or resize it; type keys into it if they change. A grey box you don't touch is ignored, and hiding or deleting one changes nothing. Dragging the box out of the frame doesn't count: the agent reports it instead. A blue box named after the element, drawn where it should now sit, works too.
2. Draw one rectangle per thing you care about. The first line inside the box is its name, such as `Gear list`. The lines after it can hold any of these keys, which the agent understands when you use them and never requires: `shows:`, `does:` or `click:`, `key:`, `size:` (`fixed`, `fill` or `fit`), `stick:`, `scroll:`, `empty:` and `hidden when:`.
3. Use the stroke colour to say what changes: green is new, blue is kept but moved or resized, red removes the element (or a red X over it), orange is not sure, let's talk, and black is how it should be.
4. Draw arrows. From a note to a box, the arrow is a comment on that box. From one box to another, it is a flow, such as "clicking this opens that".
5. Write notes outside the frame for the whole screen. Write `mode: replace` there if the screen should hold only what you drew. Otherwise, whatever you didn't touch stays.
6. For another state or size, add another frame to the same file, named `<screen>.<state>` or `<screen>@2560x1080`.
7. Save the file as `director/ui/<screen>.excalidraw`. If `director/ui/` isn't there, create it; in Godot-Director also put an empty `director/.gdignore` beside it so Godot doesn't import the PNGs you export there. In Chrome or Edge, the save can open a folder picker, so choose `director/ui`. In other browsers the file lands in Downloads, so move it there yourself.

The same conventions, feature by feature, with how to open and save the starter, are in your project: `design/ui/README.md` in a Godot-Director game, `product/ui/README.md` in an App-Director or SaaSAllTheThings app.

**Process.** Run `/ui-design process <screen>`. The agent:

1. reads the drawing and tells you, element by element, what it read. Correct anything it got wrong.
2. asks about each open point, with two to four options and a recommendation. Typical points are what a box does at another aspect ratio, what an empty list shows, the keyboard and pad focus order, and which element has focus when the screen opens.
3. records the result in one change: the spec, a decision line for each decision you made, and a task for the screen.
4. asks you to approve the commit of the spec. Nothing is committed before you say yes.

**Build.** Run `/next-task`, or give it the screen's task ID. The builder lays the screen out with containers (flex or grid on the web), gives the elements the names the spec uses (a `data-testid` on the web), updates the catalog entry and runs the verify step. Its report has a `Screen:` line that says what it verified.

**Verify.** The agent runs `/ui-design verify <screen>` and prints a table with one row per element of the spec: whether it is present, where it is, whether the keyboard (and the pad, in Godot-Director) can reach it, and whether the layout lint is clean. The agent fixes the deviations in scope and files the rest as bug items once you agree. Then run the acceptance check: `/function-check` in Godot-Director, `/acceptance` in the other two. For the screen, it links a compare image with your drawing's screenshot on the left and the screen as it is now on the right, with your boxes outlined and labelled `b1`, `b2` and so on, and asks you to judge it by using it: the mouse and the keyboard, and a pad in Godot-Director or touch on the web where the app supports it.

Start with one screen and one or two boxes. Add more once the first one builds and verifies.

## What can go wrong

- **Sizes.** Captures use the sizes listed in `tools/ui_capture.cfg`, so they don't depend on your monitor. Godot-Director renders each screen offscreen, and skips, with a note, a size the graphics card can't render. On the web, Chromium runs headless and needs no display.
- **Overlays (Godot-Director).** A HUD or toast layer that an autoload draws is missing from the shot unless the catalog entry names it in `overlays`, such as `"overlays": ["/root/Hud"]`. A player sees more than the capture shows.
- **Platforms (Godot-Director).** Capture hasn't been tested on macOS, on Linux with xvfb, or on a machine without a display. Where capture can't run, the agent says why and stops. Without a display, the element maps and lint can still be written without images.
- **Only this machine (App-Director and SaaSAllTheThings).** Web capture opens the app running on this machine, never a deployed site. It refuses any host but `localhost`, `127.0.0.1`, `[::1]` and the hosts you list in `[web] allow_hosts` (in SaaSAllTheThings each must resolve to a loopback or private address, and the dev environment goes in `dev_url` instead), and blocks and notes every request the page makes to another host. A dev server whose page calls a hosted backend is captured without that backend's data.
- **The dev environment (SaaSAllTheThings).** Name your dev environment as `[web] dev_url` and `bash tools/ui_capture.sh --dev` captures it instead, with seeded test tenants and saved test sign-ins only. Production and every other hosted address stay refused. Capture never starts or stops dev, and the element maps of a dev capture say `env: dev`.
- **No capture for a native client.** Where `[web] base_url` is empty, capture exits 3 and says it isn't available for this app yet. `list` and `process` still work, and `verify` checks that each name in the spec is in the source and reports the capture check as unverified.
- **The lint in the check.** On the web, the layout lint runs in capture, verify and the build, never in `bash tools/check.sh`, which needs no browser and no running app. In Godot-Director it can run in the check, and on an upgraded game it is off until you name a screen in the `enforce` list in `tools/ui_capture.cfg`. New games start with it on.
- **One Playwright version (App-Director and SaaSAllTheThings).** The capture tools pin Playwright to one exact version, so an install gives the same Playwright and Chromium, and two captures of the same state and size with the same install give the same files. An app that installed the tools earlier keeps its old Playwright until `cd tools/ui && npm install` runs again.
- **Privacy.** Excalidraw's live collaboration and shareable links send your drawing online. Save drawings to your own folder, and don't share a link to a drawing of a screen you haven't released. A drawing carries the screenshot of what the screen showed when it was captured. Captures are gitignored, so git never commits them.
- **A built screen that doesn't match.** Say so at the acceptance check, and the agent files it.

If capture won't run, [Capture can't run](trouble.md#capture-cant-run) lists the causes.

## Related

- The `/ui-design` entry on each framework page ([Godot-Director](../frameworks/godot-director.md#commands), [App-Director](../frameworks/app-director.md#commands) and [SaaSAllTheThings](../frameworks/saasallthethings.md#commands)), and the `ui-design` procedures, which are the source of truth for the drawing steps: [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.6.2/framework/.godot-director/procedures/ui-design.md), [App-Director](https://github.com/Freakling/App-Director/tree/v1.12.2/framework/.app-director/procedures/ui-design.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.3/framework/.satt/procedures/ui-design.md).
- The skill pages [`/design`](../skills/design.md) and [`/next-task`](../skills/next-task.md), for the two ways that need no drawing, and the [`/ui-design`](../skills/ui-design.md) page, which describes the four requests and what differs per framework.

<div class="takeaway"><span>Describe it, or draw it. The agent builds it and a person checks it.</span><span class="url"><a href="index.md">All questions</a></span></div>
