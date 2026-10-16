# Design a screen with /ui-design

<div class="kicker">Draw the screen, let the agent build it, check the result</div>

> You draw what the screen should do. The agent reads your drawing, builds the screen to it and checks the built screen against the drawing.

This guide is for someone who has never used `/ui-design`. It takes one screen from the first capture to a checked build. Godot-Director ships `/ui-design`, so the guide describes Godot-Director. App-Director and SaaSAllTheThings don't ship it yet. The [skill entry on the Godot-Director page](../frameworks/godot-director.md#commands) lists the command, and the [procedure at v3.12.0](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/ui-design.md) has the details.

## What you need to know

- **What it's for.** You design a screen's layout by drawing annotated boxes over a screenshot of the running game, instead of describing the layout in words. The agent captures the screens, reads what you drew, records the layout once in a screen spec, builds the screen to that spec and checks it.
- **Nothing to install for the drawing.** Excalidraw runs in your browser and needs no account. The capture uses the Godot engine your game already runs on, which must be Godot 4.3 or newer.
- **Where things go.** The agent writes captures to `design/ui/captures/` and the screen spec to `design/ui/<screen>.md`. Your drawings go in `director/ui/`, as `director/ui/<screen>.excalidraw`. The agent reads that folder and never writes to it. Captures are gitignored; the spec and the drawing are part of your project.

## What you need to do

### Once per game

1. Upgrade the game to Godot-Director 3.12.0 (see [Install](../frameworks/godot-director.md#install)), then restart Claude Code so the new skill loads.
2. Run `/ui-design list`. The agent prints the screens in the catalog, `tools/ui_screens.gd`, which starts with the game's main scene, and any screen scenes it finds that the catalog doesn't cover.
3. Ask the agent to add the missing screens to the catalog. Each entry names the scene the screen opens and how to put it in a representative state. Name the overlays a player sees over the screen too (see the caveats below).

### For each screen

**Capture.** Run `/ui-design capture <screen>`. The agent captures the screen in each state and at each size listed in `tools/ui_capture.cfg`, and gives you:

- a screenshot per state and size in `design/ui/captures/`, such as `<screen>@1920x1080.png`, the screen as a player sees it;
- a `.lint.txt` file for each, listing layout findings such as squeezed text or overlapping controls (empty when clean);
- `design/ui/captures/<screen>.starter.excalidraw`, the drawing to draw over.

The agent tells you where the starter drawing is.

**Draw.** Open the starter in [Excalidraw](https://excalidraw.com), in the browser or as the desktop app; the `/ui-design` capture step says how to open it and save it.

1. The screenshot is locked inside a frame named after the screen. The faint numbered boxes are what the screen has now. Hide or delete them, and delete the legend beside the frame once you know it.
2. Draw one rectangle per thing you care about. The first line inside the box is its name, such as `Gear list`. The lines after it can hold any of these keys, which the agent understands when you use them and never requires: `shows:`, `does:` or `click:`, `key:`, `size:` (`fixed`, `fill` or `fit`), `stick:`, `scroll:`, `empty:` and `hidden when:`.
3. Use the stroke colour to say what changes: green is new, blue is kept but moved or resized, red removes the element (or a red X over it), orange is not sure, let's talk, and black is how it should be.
4. Draw arrows. From a note to a box, the arrow is a comment on that box. From one box to another, it is a flow, such as "clicking this opens that".
5. Write notes outside the frame for the whole screen. Write `mode: replace` there if the screen should hold only what you drew. Otherwise, whatever you didn't touch stays.
6. For another state or size, add another frame to the same file, named `<screen>.<state>` or `<screen>@2560x1080`.
7. Save the file as `director/ui/<screen>.excalidraw`. If `director/ui/` isn't there, create it, and put an empty `director/.gdignore` beside it so Godot doesn't import the PNGs you export there. In Chrome or Edge, the save can open a folder picker, so choose `director/ui`. In other browsers the file lands in Downloads, so move it there yourself.

**Process.** Run `/ui-design process <screen>`. The agent:

1. reads the drawing and tells you, element by element, what it read. Correct anything it got wrong.
2. asks about each open point, with two to four options and a recommendation. Typical points are what a box does at another aspect ratio, what an empty list shows, the keyboard and pad focus order, and which element has focus when the screen opens.
3. records the result in one change: the spec `design/ui/<screen>.md`, a decision line for each decision you made, and a task for the screen.
4. asks you to approve the commit of `design/ui/<screen>.md`. Nothing is committed before you say yes.

**Build.** Run `/next-task`, or give it the screen's task ID. The builder lays the screen out with containers, gives the elements the names the spec uses, updates the catalog entry and runs the verify step. Its report has a `Screen:` line that says what it verified.

**Verify.** The agent runs `/ui-design verify <screen>` and prints a table with one row per element of the spec: whether it is present, where it is, whether the keyboard and pad can reach it, and whether the layout lint is clean. Deviations are rows in that table. The agent fixes the ones in scope and files the rest as bug items once you agree.

Then run `/function-check`. For the screen, it links a compare image: your drawing's screenshot on the left, and the screen as it is now on the right, with your boxes outlined and labelled `b1`, `b2` and so on. It asks you to judge the screen against your drawing and to try it with the mouse, the keyboard and a pad.

## Tips

- Start with one screen and one or two boxes. Add more once the first one builds and verifies.
- If an autoload draws a HUD over the screen, name it as an overlay in the catalog entry, such as `"overlays": ["/root/Hud"]`. Otherwise the capture won't show it.
- Report what you see. If the built screen doesn't match your drawing, say so at the function check, and the agent files it.

## Caveats

- **Sizes.** Captures render each screen offscreen at every size listed in `tools/ui_capture.cfg`, so they don't depend on your monitor. A size the graphics card can't render is skipped, with a note.
- **Overlays.** A capture shows the screen as its catalog entry opens it. A HUD or toast layer that an autoload draws is missing from the shot unless the entry names it in `overlays`, so a player sees more than the capture shows.
- **Platforms.** Capture hasn't been tested on macOS, on Linux with xvfb, or on a machine without a display. Where capture can't run, the agent says why and stops. On a machine without a display, the element maps and lint can still be written without images.
- **Upgraded games.** The layout lint in the check is off on an upgraded game until you name a screen in the `enforce` list in `tools/ui_capture.cfg`. New games start with it on.
- **Privacy.** Excalidraw's live collaboration and shareable links send your drawing online. Save drawings to your own folder, and don't share a link to a drawing of a screen you haven't released.
- **Drawings embed the screenshot.** A drawing you share carries what the screen showed when it was captured. Captures are gitignored, so git never commits them.

## More

- The `/ui-design` entry on the [Godot-Director page](../frameworks/godot-director.md#commands), with its command summary.
- The [`ui-design` procedure at v3.12.0](https://github.com/Freakling/Godot-Director/tree/v3.12.0/framework/.godot-director/procedures/ui-design.md), which is the source of truth for the steps.
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>You draw the screen. The agent builds it and checks it against your drawing.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
