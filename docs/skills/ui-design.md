# /ui-design

<div class="kicker">You draw the layout, and the agent checks the built screen against it</div>

> The drawing is read once, the layout is recorded once, and the built screen is checked against that record.

`/ui-design` captures a project's screens, reads your drawings of them into a screen spec, and checks the built screen against that spec. The four requests are the same in all three frameworks. The capture differs by framework, and the procedure of each repository is the source of truth.

How to use it: [How do I work with UI changes?](../how-to/ui.md)

## What it does

1. **List** the screens in the catalog, and any screen file the catalog doesn't cover yet.
2. **Capture** each screen in each state and at each size that the project's settings list. Each one gives a screenshot, an element map, a numbered map image and a lint file of layout findings, such as squeezed text or overlapping controls. The capture also writes a starter drawing to draw over.
3. **Process** a drawing. The agent reads each box you drew, briefs you on it element by element, and asks about each open point with options and a recommendation. Then it records the screen spec, one decision line per decision and a task for the screen. Nothing is committed until you approve.
4. **Verify** the built screen against the spec. It prints one row per element, saying whether the element is present, where it is, whether the keyboard (and the pad, in Godot-Director) reaches it, and whether its layout is clean. With a processed drawing it also writes a compare image: your screenshot on the left, the screen as it is now on the right, and your boxes labelled `b1`, `b2` and so on. The deviations go in a table. The ones in scope are fixed, and the rest become bug items once you agree.

## Drawing

Open the starter in [Excalidraw](https://excalidraw.com), which runs in the browser and needs no account. Draw one rectangle per element, with its name on the first line. The stroke colour says what changes: green is new, blue is kept but moved or resized, red removes the element, orange is a question for you, and black is how it should be. To re-arrange a screen, drag a grey box to where the element should sit, or draw a blue box named after the element. Your drawings go in `director/ui/`, which the agent reads and never writes.

The drawing conventions are in the README that each project keeps with its screen designs: [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.6.0/project/design/ui/README.md), [App-Director](https://github.com/Freakling/App-Director/tree/v1.12.0/project/product/ui/README.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.1/project/product/ui/README.md).

## Text path

Every step has a text path for an assistant that can't view images. The element map, the lint file and the reader's JSON stand in for the pictures, and the table that verify prints says in text what the compare image shows.

## Unique per repo

| | Godot-Director | App-Director | SaaSAllTheThings |
|---|---|---|---|
| What is captured | The running game, rendered offscreen by the Godot engine. Capture needs a display: a small window opens for a few seconds | The web app on this machine, in headless Chromium | The web client on this machine, or the dev environment named in the settings, in headless Chromium. Production is never captured |
| Signed-in screens | None: a state seeds its data through the game's own APIs, fixtures and debug hooks | The test account's saved sign-in, when the catalog names one | A screen behind the sign-in opens as a test user of a seeded test tenant, never a real account |
| Overlays | A HUD or toast that an autoload draws appears only when the catalog entry names it in `overlays` | - | - |
| Layout lint in the check | Runs in `bash tools/check.sh` when `check_in_check` is on in `tools/ui_capture.cfg`, and fails it for the screens named in `enforce` | Never in the check: it needs a browser and a running app, so it runs in capture, verify and a build | Never in the check, as App-Director |
| The reader runs on | Godot, headless, with no display | Node | Node |
| Spec folder | `design/ui/` | `product/ui/` | `product/ui/` |

The procedures for each step are at [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.6.0/framework/.godot-director/procedures/ui-design.md), [App-Director](https://github.com/Freakling/App-Director/tree/v1.12.0/framework/.app-director/procedures/ui-design.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.14.1/framework/.satt/procedures/ui-design.md).

<div class="takeaway"><span>You draw the layout once; the agent records it and checks the screen against it.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
