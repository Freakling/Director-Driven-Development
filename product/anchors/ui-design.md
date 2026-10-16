# Anchor: /ui-design

The agreed behaviour of the `/ui-design` skill in Godot-Director, App-Director and SaaSAllTheThings, adapted from the director's spec (`init/ui-design-skill-spec.md`, written against Godot-Director 3.5.0) to Godot-Director v3.10.0. This file lives only in this repository. A task in each framework's own `TASKS.md` carries it there, and that framework's build agents implement it. Brief: Scope › Planned framework changes › All three get `/ui-design`.

The director designs screens by drawing annotated boxes over screenshots of the running app or game in Excalidraw. The agent captures the screens, reads the drawings through a reader, records each screen's layout once in a screen spec, builds it, and verifies the result. The director decides; the agent proposes.

How to read it:
- **Part A** (sections 1-7) is the shared core: files, changes to existing procedures, the procedure, drawings, the screen spec, integration, and the settled questions. It is the same in all three frameworks.
- **Part B** (sections 8-10) is the contract every capture and lint adapter meets: inputs, outputs, determinism, exit codes, lint rules, and how `verify` uses the element map.
- **Part C** (sections 11-14) is the two adapters (Godot; Playwright for web apps), their acceptance criteria, and what the audit compares.

Godot-Director pilots the feature; App-Director and SaaSAllTheThings follow from this anchor once the pilot is released. The sections written for Godot are exact; the web adapter is a design to prove, so its acceptance criteria (section 13) are the proof.

## Placeholders

| Placeholder | App-Director (v1.6.0) | Godot-Director (v3.10.0) | SaaSAllTheThings (v0.8.0) |
|---|---|---|---|
| `<framework folder>` | `.app-director/` | `.godot-director/` | `.satt/` |
| the design records | brief and `product/decisions.md` | GDD and `design/decisions.md` | PRD, `product/decisions.md` and the ADRs in `adr/` |
| the design-records line of an item | `Brief:` | `GDD:` | `PRD:` |
| the open questions | brief › Open Questions | GDD › Open Questions | PRD › Open Questions |
| the human check, and its outcome tag | acceptance check (`acceptance.md`), `(demo)`; file `validation/YYYY-MM-DD-acceptance.md` | function check (`function-check.md`), `(play)`; file `playtesting/YYYY-MM-DD-function-check.md` | acceptance check (`acceptance.md`), `(demo)`; file `validation/YYYY-MM-DD-acceptance.md` |
| `<ui folder>`: specs and captures | `product/ui/` | `design/ui/` | `product/ui/` |
| captures (gitignored) | `product/ui/captures/` | `design/ui/captures/` | `product/ui/captures/` |
| the director's drawings (human-owned) | `director/ui/` | `director/ui/` | `director/ui/` |
| protected-space hook that must cover `director/` | `guard-protected.sh` (already blocks `director/`) | `guard-protected.sh` (already blocks `director/`) | `guard-authority.sh`: v0.8.0 knows no `director/`, so the build adds it (see Part A, section 2) |
| screen and view folders | `tools/check.cfg` › `[ui] dirs` | `tools/check.cfg` › `[screens] dirs` (script folders; a view's scene is found through its root script) | `tools/check.cfg` › `[layers]` › `client` (`clients/*`); web clients only |
| capture adapter | Playwright | Godot | Playwright |
| catalog | `tools/ui/screens.mjs` | `tools/ui_screens.gd` | `tools/ui/screens.mjs` |
| config | `tools/ui_capture.cfg` (lists space-separated, as its `check.cfg`) | `tools/ui_capture.cfg` (Godot `ConfigFile`, lists as JSON arrays, as its `check.cfg`) | `tools/ui_capture.cfg` (lists space-separated, as its `check.cfg`) |
| the check and the test runner | `bash tools/check.sh` (stack runner `tools/stacks/<stack>.sh`) | `bash tools/check.sh <...>` (`tests/**/test_*.gd`, `tools/test_case.gd`) | `bash tools/check.sh` (stack runner `tools/stacks/<stack>.sh`) |
| the item's tags | `(test)` `(check)` `(demo)` | `(test)` `(check)` `(play)` | `(test)` `(check)` `(demo)` |

Paths marked as folders or files here are the anchor's choice. The framework's build agents may adjust them to fit the repository, and the audit then records the difference.

# Part A: the shared core

## 1. Goals and non-goals

**Goals**
1. The director redesigns any screen without touching the code: they draw boxes and notes over a screenshot in a free, open-source tool, and the agent turns that into a built screen.
2. The agent sees the screens: a capture renders each screen, in a known state, to PNG at fixed sizes, with a machine-readable element map.
3. Drawings are read precisely, not guessed from pixels: box positions, sizes, labels, notes and arrows come from the drawing file.
4. The chosen layout is recorded once, in a per-screen spec, and items, builds, reviews and the human check all point at it.
5. Layout bugs that tests can't see (a label squeezed to one character wide, a button off-screen, an unreachable control) are caught automatically.
6. It works with mouse, touch, keyboard and controller where the product supports them, at every supported aspect ratio, consistent with each framework's existing UI rules.

**Non-goals**
- No visual design system (fonts, colours, themes). That can come later as its own skill.
- No pixel-perfect reproduction: drawings set arrangement and proportions; the layout system (Containers, flex or grid) makes it responsive.
- No live sync with a design tool, and no design tool bundled with the framework.
- No native Flutter or desktop capture yet (section 14).

## 2. Files and changes to existing files

### Framework-owned (replaced on upgrade)

Installers hash everything under `framework/` and write `<framework folder>/manifest`, so new files are listed in the manifest by being added under `framework/`; nothing is listed by hand.

| Path (in `framework/`) | Purpose |
|---|---|
| `<framework folder>/procedures/ui-design.md` | The procedure (section 3). Tool-neutral. |
| `.claude/skills/ui-design/SKILL.md` | Claude Code wrapper: "Read `<framework folder>/procedures/ui-design.md` and follow it exactly. Request: $ARGUMENTS". Description triggers: "redesign a screen", "UI design", "capture the screens", "process my drawing", "screenshot the game", "/ui-design". `argument-hint: "capture [screen\|all] · process <screen> · verify <screen> · list"`. |
| `tools/ui_capture.sh` | Entry point of the capture adapter (Part B). Exit codes 0, 1, 3 as `check.sh`. |
| the adapter's tools | Godot: `tools/ui_capture.gd`, `tools/ui_catalog.gd`, `tools/ui_lint.gd`, `tools/ui_drawing.gd`, `tools/ui_overlay.gd`. Web: `tools/ui/capture.mjs`, `lint.mjs`, `drawing.mjs`, `overlay.mjs`, `package.json` (section 12). |

### Project-owned (seeds in `project/`: created once, never overwritten)

| Path | Purpose |
|---|---|
| the catalog | `tools/ui_screens.gd` or `tools/ui/screens.mjs`: every screen and how to put it on screen in a representative state (Part C). The seed has one entry. The agent maintains it like project code. |
| `tools/ui_capture.cfg` | Sizes, settle time, lint thresholds, skipped screens, verify tolerance (section 9). |
| `<ui folder>/README.md` | One page for the director: how to draw, the conventions (section 4.2), where files go. Project-owned so the director can annotate it. |
| `<ui folder>/<screen>.md` | One spec per screen, written by `process` (section 5). |

### Generated (gitignored; the installer adds the line)

`/<ui folder>/captures/`. It holds the capture outputs of Part B, starter drawings (`<screen>.starter.excalidraw`), `<screen>.drawing.json` and compare images. All are regenerated on demand. Captures stay out of git; the drawings embed their screenshot anyway.

### Human-owned (protected)

`director/ui/<screen>.excalidraw`, and optionally `director/ui/<screen>.png`, an export the director makes for their own reference. The agent reads, never writes.
- Godot-Director and App-Director: `guard-protected.sh` already blocks Edit and Write on `director/`. No change. (It does not see shell writes; capture and the reader write only under `<ui folder>/captures/`.)
- SaaSAllTheThings: `guard-authority.sh` asks about framework-owned files and ADR acceptance and knows no `director/`. The build adds `director/` to what it asks about (or adds a `guard-protected.sh` as the other two have) and adds the protected-space paragraph to its `rules.md`, as `rules.md` › Protected space reads in the other two. Choice the brief does not settle; the build agent proposes it in review.
- Godot-Director: when onboarding creates `director/ui/` it also writes `director/.gdignore`, so the editor does not import the director's exported PNGs (v3.10.0 has no `.gdignore` for `director/`; `design/` already has one, so captures are not imported).

### Changes to existing framework files

The same in all three, using the placeholders. Names are as they exist at the pilot's release.

1. **`rules.md` › the procedure list:** `ui-design.md: capture screens, process a screen drawing, verify a built screen.`
2. **`rules.md` › Each fact lives in one place:** add `How each screen is laid out` → `<ui folder>/<screen>.md`, and `The director's screen drawings` → `director/ui/` (read-only for the agent).
3. **`rules.md` › Architecture defaults › UI:** extend the bullet:
   - every screen has an entry in the catalog;
   - elements a screen spec names get a stable name the spec, element maps and tests share: Godot a unique node name (`%GearList`), web a `data-testid` (`gear-list`);
   - Godot only: capture sets `godot_director_check` (the meta autoloads already honour; v3.10.0 documents it in `check.gd` and `rules.md` › Saves and settings) and `godot_director_capture`, so no autoload reads or writes player data during a capture. The rule names both.
4. **`tasks.md`:** an optional item field `UI: <ui folder>/<screen>.md` for items that build or change a screen; section 6.1 lists the expected outcomes. `align.md` checks it exists.
5. **`procedures/build.md`:** a "Screens" step for items with `UI:` (6.1), and a `Screen:` line in the report format.
6. **`procedures/review.md`:** the reviewer checks a `UI:` item against its spec and the latest compare image (6.2).
7. **The human-check procedure** (`function-check.md` in Godot-Director, `acceptance.md` in the others) › Prepare: the entry for a `UI:` item links the compare image and asks the director to judge the screen against their drawing (6.3).
8. **`procedures/align.md`:** the checks of 6.4.
9. **`procedures/design.md`:** one line: layout questions go to `ui-design.md`; design sessions settle what a screen is for, not where things sit.
10. **`rules.md` › Reviews and model size** is unchanged: a `UI:` item is sized like any item and reviewed by the same rule. A `UI:` item that is `L` or `XL` is split per screen.
11. **AGENTS.md seed › Ownership and Layout.** Onboarding's ownership interview asks once whether the director wants to design screens:
    - Godot-Director: the row `UI / screen layout` (ONBOARDING.md §7, default `agent`, placeholder "minimal functional screen, commented for redesign") becomes `director designs (director/ui/), agent builds`, with the same placeholder. The director offers `director/` (§7 › Protected workspace) with `director/ui/` and `director/.gdignore`.
    - App-Director and SaaSAllTheThings: the same question in their ownership step (SaaSAllTheThings ONBOARDING.md §8); the row is `UI / screen layout`.
    - If the director declines, the row stays `agent`, nothing else changes, and the skill still works for captures and lint. No open question and no item are added (unlike export setup in Godot-Director, which gates on `Q<n>`): drawing is optional, never a prerequisite.
    - Layout gains `<ui folder>/` (specs, captures) and a mention of `director/ui/`.
12. **Installer and upgrade.** `framework/` files are copied and hashed; `project/` seeds are created only when missing (v3.10.0 `install.sh`); the installer's `ensure_lines` adds `/<ui folder>/captures/` to `.gitignore` (Godot-Director: next to `/builds/`). Godot-Director's `.gitattributes` lines gain `/tools/ui_*.gd text eol=lf` (the existing lines name `tools/check.gd` and `tools/test_case.gd` one by one). The release item bumps the version; this anchor names none.
    - On upgrade, onboarding runs align's UI checks and reports screens missing from the catalog without failing. The seed's `ui_capture.cfg` ships with the lint in the check on (`check_in_check` true, `enforce` all); the upgrade step in `ONBOARDING.md` writes it off (`check_in_check` false, `enforce` empty), since seeds are copied only when missing. That is the settled "on for new projects, off on upgrade".
13. **`.claude/settings.json`** allows `Bash(bash tools/ui_capture.sh *)` next to the check's entries.
14. **Selftest, CHANGELOG, example.** Each framework's `selftest.sh` checks the new files exist, the skill points to its procedure, `rules.md` names `ui-design.md`, and the wiring above (as it does for research). `CHANGELOG.md` gets an Unreleased entry with "Upgrade steps". Godot-Director also updates `examples/market-day` (CLAUDE.md: "if the change affects what a game's files look like").
15. **Godot-Director's checks.** `check.gd` loads every `.gd` under `res://` (outside `[scan] skip` and `.gdignore` folders), so the new tools and the catalog must compile typed on Godot 4.3+ with `untyped_declaration=2` and use only Godot 4 forms. Godot 4.4+ writes `.uid` files next to new scripts; the install and the builder's commit include them. `check.sh --fingerprint` hashes only code, scene and resource files plus the files it names, so it ignores captures; add `tools/ui_capture.cfg` to its list, because it changes the check's result when `check_in_check` is on. `stop-check.sh` filters on code and resource extensions, so captures never trigger it.

## 3. The procedure (`ui-design.md`)

Written in the framework's procedure style: short imperative sentences, one fact in one place.

### Requests
- `list`: print the catalog: screen ids, states, what each opens, whether a drawing and a spec exist, and the spec's last build and verify state.
- `capture [screen|all]` (default `all`).
- `process <screen>`.
- `verify <screen>`.
- No argument: `list`, then ask which screen.

Finding the runtime follows the framework's own pattern: Godot-Director as `export.md` › "Export the game" step 1 (`$GODOT_BIN`, else the first line of `tools/godot_bin.local`, else `bash tools/setup-clone.sh --skip-hook`); the web adapter needs Node (section 12).

### `capture`
1. Run `bash tools/ui_capture.sh <screen|--all>`. Exit 3: say capture couldn't run and why (no display, Godot, Node or Playwright missing); stop.
2. Outputs land in `<ui folder>/captures/` (section 8.2).
3. Look at each `.png` and its `.lint.txt` (if the tool can view images; otherwise use `.elements.json`). Report findings in one line each; a finding that is a real bug becomes a `B` item after the director agrees (at once inside a `/next-task` run).
4. Tell the director, in these words (the same in all three; each procedure may add its own sentences after it): "Nothing to install. Open excalidraw.com in Chrome, Edge or another browser: no account is needed, and Excalidraw+ isn't. Open `<ui folder>/captures/hero_room.starter.excalidraw` from the menu's Open, or drag it onto the page, and draw over the screenshot. To save, use Save to… (Ctrl+S saves over the file you opened), and save it as `director/ui/hero_room.excalidraw`: Chrome and Edge let you pick that folder; other browsers save to Downloads, so move the file there and rename it. Your drawing stays on this computer unless you use Live collaboration or a shareable link. Tell me when it's saved." Point at `<ui folder>/README.md` the first time.

### `process <screen>`
1. **Read** `director/ui/<screen>.excalidraw` through the reader (Part C): it writes `<ui folder>/captures/<screen>.drawing.json`. Never read the raw `.excalidraw` into context: it embeds the screenshot as base64.
2. **Also read** the current spec (if any), the latest `.elements.json` of the screen, the design-records sections the screen implements, and related lines in the decisions log.
3. **Brief** the director, as `design.md` does: what the screen is for, what the drawing changes, element by element:
   - `Gear list (new): a scrolling list on the right third, under the portrait; shows each slot and its item; clicking a row opens Change.`
   - `Belt row (moved): was beside the slots, now its own row above them.`
   - `Repair button (removed).`

   Include anything the drawing leaves ambiguous and anything it conflicts with: recorded rules, project rules (input support for every action), other screens' specs (consistent Back placement).
4. **Confirm the reading** ("Is this what you drew?"). Then, for each open point, offer 2-4 options with a recommendation, exactly as `design.md` › For each question. Typical open points: what a box does at another aspect ratio, what happens when a list is empty or overflows, the keyboard or controller focus order, which element has default focus, keys for new actions.
5. **Record**, in one change:
   - `<ui folder>/<screen>.md` (section 5), replacing superseded content.
   - The decisions log: one line per real decision, in its usual format, `from: drawing director/ui/<screen>.excalidraw`.
   - The design records only when the drawing changed what the screen does (a new action, a removed feature); layout itself lives in the spec. A point left undecided becomes an open question (`Q<n>`), and the spec's Open section names it.
   - `TASKS.md`: one item per screen (split an `L`), with `UI:`, `Touches`, tagged `Done when` (6.1) and the design-records line.
6. **Commit** as `docs: ui <screen>` after the director approves.

### `verify <screen>`
1. Capture the screen (all its states and sizes).
2. Make the compare image (Part C overlay): the drawing's boxes (from `drawing.json`) as outlines over the new capture, labelled and coloured by intent, next to the original drawing's screenshot. Output: `<ui folder>/captures/<screen>.compare@<W>x<H>.png`.
3. Check each spec element as section 10 says.
4. Report deviations as a short table; fix in-scope ones in the same item, file the rest.

### Finish
As `design.md`: summarise, commit, suggest a fresh session before the next screen.

## 4. Drawings

### 4.1 Tool: Excalidraw
Free, open source, runs in a browser or as a desktop app with no account, and saves plain JSON (`.excalidraw`) with every element's type, position, size, colour, text, group and bindings. Drawings are precise and diffable. Other tools: section 14.

### 4.2 Conventions (go into `<ui folder>/README.md`, short and friendly)
- **Start from the starter file** for the screen; the screenshot is locked as the background inside a frame named after the screen. Save your version as `director/ui/<screen>.excalidraw`.
- **One rectangle per thing you care about.** Double-click the box to type inside it. First line: its name (`Gear list`). Next lines: anything about it, in plain words. These keys are understood when you use them, never required:
  - `shows:` what it displays · `does:` or `click:` what using it does · `key:` the keyboard or pad input
  - `size:` `fixed`, `fill` or `fit` · `stick:` `top-left`, `bottom`, `right`... · `scroll:` `yes`
  - `empty:` what it shows with nothing in it · `hidden when:` ...
- **Colour says what changes** (stroke colour, Excalidraw's default palette):
  - green: new · blue: keep but move or resize · red: remove (or a red X over the old element) · orange: not sure, let's talk · black or default: "this is how it should be" (the agent works out whether it is new or existing by overlap with the element map).
- **Boxes inside boxes** mean containment (a panel holding a list).
- **Arrows:** from a note to a box is a comment on that box; from one box to another is flow ("clicking this opens that").
- **Text outside the frame** is notes for the whole screen. Write `mode: replace` there if the screen should contain only what you drew; by default anything you did not touch stays (`mode: patch`).
- Exact pixel sizes don't matter; proportions and arrangement do. Say `size: fixed` or `stick:` when a box must keep its size or corner.
- Another state or size of the same screen: add another frame in the same file, named `<screen>.<state>` or `<screen>@2560x1080`.
- **Using Excalidraw** (a section of the guide, the same in all three frameworks' READMEs):
  > Excalidraw is free and open source, and nothing needs installing. Open excalidraw.com in Chrome, Edge or another browser: no account is needed, and Excalidraw+ isn't. To open your starter, use the menu's Open, or drag the file onto the page. To save, use Save to… (Ctrl+S saves over the file you opened) and save it as `director/ui/<screen>.excalidraw`. Chrome and Edge let you pick that folder; other browsers save to Downloads, so move the file there and rename it. Your drawing stays on this computer unless you use Live collaboration or a shareable link. You can install Excalidraw as an app from Chrome's or Edge's address bar if you like; it's the same as the website.

### 4.3 Starter drawing (written by capture)
An `.excalidraw` file containing:
- One frame per screen state, named `<screen>` (default state, default size), exactly the capture size.
- The capture as a locked `image` element filling the frame (`files` holds the PNG as a data URL).
- Optional, on by default: a locked, 25%-opacity group named `existing` with a thin grey rectangle and a small number label per mapped element, matching `.map.png`. The director can hide or delete it.
- A short legend text block outside the frame with the colour conventions.

Generate valid current-format Excalidraw JSON (`"type": "excalidraw", "version": 2`), with unique ids, integer `seed` and `versionNonce`, `locked: true` on the background and the `existing` group, and `frameId` on contained elements. Validate by round-tripping through the reader, and by a fixture opened once in excalidraw.com during development.

### 4.4 Reader → `drawing.json`
Input: an `.excalidraw` file and, optionally, the screen id. Output, compact and image-free (identical in both adapters; `"schema": 1`):
```json
{
  "schema": 1,
  "source": "director/ui/hero_room.excalidraw", "sha1": "...",
  "frames": [{
    "name": "hero_room", "state": "default", "size": [1920, 1080], "mode": "patch",
    "notes": ["Make the gear panel wider", "mode: patch"],
    "boxes": [
      {"id": "b3", "label": "Gear list", "text": "shows: each slot and its item\nclick: opens Change",
       "keys": {"shows": "each slot and its item", "click": "opens Change"},
       "intent": "new", "rect_pct": [62.0, 12.0, 34.0, 60.0], "parent": "b1",
       "comments": ["should scroll if more than 8 slots"],
       "flows_to": ["b7"],
       "overlaps": [{"n": 14, "name": "BeltLabel", "iou": 0.41}]}
    ],
    "removed": [{"n": 22, "name": "RepairButton", "by": "red-x"}],
    "unparsed": ["a freehand line near (900, 300)"]
  }]
}
```
Rules:
- Coordinates are normalised to the frame's background image (handle a moved or scaled image through the image element's x, y, width and height), as percentages to one decimal.
- Text bound to a rectangle (`containerId`) is the box's label and text; the first line is `label`.
- Free text inside the frame within 1.5 times its height of a box, or connected by an arrow, is a comment on that box; elsewhere inside the frame, a frame note; outside every frame, a file note.
- Intent comes from stroke colour (Excalidraw's palette hex values mapped to new, keep, remove, unsure; anything else is `default`).
- Containment is by geometry: a box fully inside another is its child.
- Overlap with the element map is by intersection over union; list matches above 0.2.
- Anything not understood (freehand, ellipses, images other than the background) goes to `unparsed`, so the agent asks rather than guesses.
- Exit non-zero with a clear message on invalid JSON, no frame, or no background image (then normalise to the frame).

## 5. Screen spec (`<ui folder>/<screen>.md`)

The single place a screen's layout is recorded.
```markdown
# Hero room
**Opens:** <scene or route> · **Catalog:** hero_room (default, exhausted)
**Drawing:** director/ui/hero_room.excalidraw (sha1 3f2a..., processed 2026-10-16) · **<Design records>:** Heroes and Staff › Hero rooms

## Purpose
One or two lines: what the user does here.

## Layout (at 1920x1080)
| # | Element | Name | Where (x, y, w, h %) | Shows | Does | Size |
|---|---|---|---|---|---|---|
| 1 | Hero sheet | %HeroSheet | 1, 11, 20, 70 | stats, morale, backstory | - | fixed width, fills height |
| 2 | Gear list | %GearList | 62, 12, 34, 60 | each slot and its item | click: Change | fill, scrolls |

## Navigation
Default focus · focus order · Back · keys and pad buttons for each action.

## Other sizes
Ultrawide, 16:10, small or phone: what grows, what moves, what hides.

## States
Empty, loading, away, exhausted...: what differs.

## Open
Undecided points, each with its Q<n> if it went to the open questions.
```
Percentages are guidance for the layout system, not positions. `Name` is the stable name the build must create (`%GearList`, or `gear-list` for a `data-testid`). The table is the contract `verify` checks.

## 6. Integration

### 6.1 Items and the builder
- An item that builds or changes a screen has `UI: <ui folder>/<screen>.md`.
- Typical `Done when`: `every element in the spec exists under its stable name and the screen opens without errors (test)` · `the capture is lint-clean at every configured size and matches the spec within tolerance (check)` · `the screen reads as drawn and works by mouse, touch, keyboard and controller where supported (play or demo)`.
- `build.md` gets a step for `UI:` items: read the spec and `drawing.json` (never the raw drawing); build with the layout system (Containers and anchors; flex or grid), never hard-coded positions; give spec elements their stable names; add or update the catalog entry; run `bash tools/ui_capture.sh <screen>`; look at the capture and `.lint.txt`; run `verify`; report deviations in a new `Screen:` line: `Screen: hero_room verified at 3 sizes; 0 lint; 1 deviation: ...`. If capture can't run (exit 3), say so: the item is then unverified for its `(check)` outcome, said plainly in the report, like exit 3 for the check.
- A research item (`R<n>`) is unaffected.

### 6.2 Review
For `UI:` items the reviewer reads the spec, `drawing.json`, the compare image and the lint output, and reports deviations ranked with the usual findings.

### 6.3 The human check
For a done `UI:` item, the entry reads: *"Hero room matches your drawing. Compare: `<ui folder>/captures/hero_room.compare@1920x1080.png`. How: open a hero's room; try mouse, keyboard and pad."* Prepare regenerates compare images first when it can capture. The tag is the framework's own (`(play)` or `(demo)`), so the existing collection of outcomes picks the entry up.

### 6.4 Align
- Every screen has a catalog entry, or is in `ui_capture.cfg` › `skip`. What "every screen" means is the framework's folder setting from the placeholders. Godot-Director: `[screens] dirs` holds script folders, not scenes (v3.10.0), so a view is a scene whose root script is under those folders, found from the `.tscn`'s script reference. With no screen folders set, the check notes it rather than failing, as the screens rule does.
- Every `<ui folder>/<screen>.md` names something that exists, and every stable name it lists exists in that scene or script, or in the page's source (a static check).
- Every drawing in `director/ui/` has a spec whose recorded sha1 matches. A newer drawing: report "drawing changed since it was processed".
- Every `UI:` field points at an existing spec.
- The `.gitignore` line is present (`align.md` › Setup already re-checks the installer's lines; add this one).

### 6.5 Hooks
No new hook. The protected-space hook covers `director/` (section 2). The stop hook and the check's fingerprint ignore captures (section 2, item 15 for Godot-Director; App-Director's and SaaSAllTheThings' own fingerprints and stop filters are verified the same way by the build).

## 7. Settled questions

From the director's spec, as decided on 2026-10-16 (`product/decisions.md`):
1. The skill is `/ui-design`, not `/screens`.
2. Captures stay gitignored; they are not committed for history.
3. The layout lint in the check is on for new projects and off on upgrade (Godot, where the lint can run in the check; see section 11).
4. A `UI:` item's `(check)` outcome may stay unverified when capture can't run on the machine, said plainly in the report.

Also settled by the brief: one shared core and one adapter per framework family; Godot-Director first; native Flutter and desktop capture later.

# Part B: the capture and lint adapter contract

Any adapter satisfies this contract, so the procedure, the spec and the audit do not change per framework.

## 8. Inputs and outputs

### 8.1 Inputs
- **The catalog** (project-owned): every screen with an `id`, a `title`, how to open it, and optional named `states` (for example `default`, `exhausted`, `empty`). Each state builds its data through the product's public APIs, fixtures or seeded data, never real user data. Validation: unknown keys, duplicate ids and a missing scene or route fail that entry with a clear message.
- **Sizes** from `tools/ui_capture.cfg` › `[sizes] list` (`WxH`). The first is the default size, used for starter drawings and `verify`.
- **The request:** one screen id or `--all`, optionally one state or size.
- `[capture] skip` ids are never captured.

### 8.2 Outputs per screen, state and size
In `<ui folder>/captures/`, named `<id>[.<state>]@<W>x<H>`:
- `.png`: the screenshot.
- `.elements.json`: the element map (below).
- `.map.png`: the screenshot with every mapped element outlined and numbered; the legend is the JSON order. It lets the director and the agent say "element 14".
- `.lint.txt`: the lint findings (section 9), empty when clean.
- `<id>.starter.excalidraw`: only for the default state at the default size (section 4.3).

`elements.json` (`"schema": 1`), common fields:
```json
{
  "schema": 1, "adapter": "godot",
  "screen": "hero_room", "state": "default", "size": [1920, 1080],
  "source": "res://scenes/shell/HeroRoomView.tscn",
  "capped": false,
  "elements": [
    {"n": 14, "id": "BeltLabel", "stable": true, "path": "Panel/Gear/BeltRow/Label",
     "kind": "Label", "name": "Belt: Simple Belt (co...",
     "rect": [1173, 216, 18, 498], "rect_pct": [61.1, 20.0, 0.9, 46.1],
     "visible": true, "focusable": false, "focus_order": null,
     "overflow": {"clipped": false, "wraps": true},
     "min_size": [0, 0], "native": {}}
  ]
}
```
- `id`: the stable name when the element has one (`stable: true`: a Godot unique name, a web `data-testid`), else the tool's own best name.
- `kind`: the Godot class, or the web role.
- `name`: the visible text, or the web accessible name, truncated.
- `rect` in pixels of the capture; `rect_pct` as percentages of the capture, one decimal.
- `focus_order`: the position in the keyboard or controller traversal from the default focus, or `null` when unreachable or not focusable.
- `overflow`: whether the content is clipped, and whether text wraps.
- `native`: adapter-specific extras, free-form. Godot: focus neighbours, `autowrap`, and a separate top-level `pickables_3d` for clickable 3D objects projected through the active camera. Web: `tag`, `tabindex`, `aria`, `disabled`, the DOM selector.
- Which elements are mapped: every visible element that is focusable, has text, has a stable name, or is a direct child of a container the spec names; skip anonymous layout containers unless they are needed as parents. Cap at `[capture] max_elements` (default 200) and set `capped: true`.

### 8.3 Determinism
Two captures of the same state at the same size, on the same machine, give identical element maps and, apart from antialiasing noise the adapter documents, the same image. Each adapter:
- seeds randomness per screen (`[capture] seed`);
- stops or skips animation, with a per-screen opt-out for those that cannot be paused;
- waits for the screen to settle (`settle_frames` or the web equivalent) before the screenshot;
- uses default settings and no player data: nothing is read from or written to the user's data, and nothing is sent anywhere.

### 8.4 Exit codes
As `check.sh`: **0** ok · **1** at least one screen failed (setup error, a script or page error, a missing scene or route); the run continues for the others, and the failure is written to that screen's `.lint.txt` · **3** capture couldn't run (no display, no Godot, no Node, no Playwright or browser): a clear message on stderr, nothing half-written. Lint findings alone never change the exit code in capture.

## 9. Layout lint

The same rules in both adapters, with the ids below in `.lint.txt` (one finding per line: `<id> element <n> <path>: <message>`). They run on every capture. Thresholds come from `tools/ui_capture.cfg`:

```ini
[sizes]
; WxH. The first is the default size used for starter drawings and verify.
list = 1920x1080 2560x1080 1280x720
[capture]
seed = 12345
settle_frames = 6
max_elements = 200
; Screen ids never captured (for example a splash that only shows on first boot).
skip =
[lint]
min_label_chars = 6
max_button_height_ratio = 2.0
; Godot only (section 11.4): run the lint inside the check, for the screens in `enforce` ("*" is all).
check_in_check = true
enforce = *
[verify]
tolerance_pct = 4.0
```
(Godot writes the lists as JSON arrays, as its `check.cfg` does; the web adapter as space-separated lists. The keys are the same.)

| Id | Finding |
|---|---|
| `squeezed-text` | A wrapping text element narrower than `min_label_chars` average characters, or a non-wrapping one whose text overflows its rect without clipping or an ellipsis. (It would have caught a belt label squeezed to 18 px wrapping one letter per line.) |
| `stretched-control` | A button taller than `max_button_height_ratio` times its own minimum height because a sibling grew. |
| `off-screen` | A visible element whose rect leaves the viewport or its clipping parent. |
| `overlap` | Two focusable siblings whose rects overlap and where the overlap blocks input. |
| `unreachable` | A visible, enabled, focusable element that traversal from the default focus never reaches. |
| `no-default-focus` | A screen (or dialog) that has focusable elements and no initial focus. |
| `hard-coded-position` | An element positioned in pixels inside a container that lays out its children, which the container will fight (warning only). |

Findings are advisory in capture. In the Godot check they fail only for screens under `[lint] enforce`, so existing projects adopt it gradually (mirroring `check.cfg` › `[screens] known`).

## 10. How `verify` uses the element map

For each element in the spec's Layout table, against the latest `.elements.json` of the same state and size:
- **Present:** an element with that stable name exists and is visible.
- **Where:** its `rect_pct` is within `[verify] tolerance_pct` (default 4.0, of the screen, per edge) of the spec's Where.
- **Reachable:** `focus_order` is not `null` for a focusable element, and the order matches the spec's Navigation.
- **Lint-clean:** no finding names it.

A drawn box whose `overlaps` pointed at an element that has since moved is reported with both rects. The report is a short table: element, expected, found, verdict. It also lists drawing boxes the spec names that the capture does not contain, and mapped elements with stable names that the spec does not list.

# Part C: the adapters

## 11. The Godot adapter (Godot-Director)

From the spec's sections 6 and 8, adapted to v3.10.0.

### 11.1 Capture runner (`ui_capture.sh`, `ui_capture.gd`)
- `ui_capture.sh` finds Godot the way `check.sh` does (`$GODOT_BIN`, else the first line of `tools/godot_bin.local`, else `godot`; exit 3 if missing or older than 4.3), runs Godot **not headless** (headless uses a dummy renderer and cannot produce images), and handles Linux without a display: `xvfb-run` if available, else exit 3 with a clear message. It must run in Git Bash, macOS bash 3.2 and Linux (CLAUDE.md: `/usr/bin/find`, no GNU-only flags, few process starts). The lookup lines are a small copy of `check.sh`'s; changing `check.sh` to share them would touch the check, which this item must not change.
- `godot --path . --resolution <W>x<H> --script res://tools/ui_capture.gd -- <args>`, as a `SceneTree` script.
- It sets `godot_director_check` and `godot_director_capture` (`Engine.set_meta`) in `_init`, before autoloads run, so nothing reads or writes player data, nothing is sent, and settings are defaults (UI scale 100%). The deprecated 2.x meta `claude4godot_check` is not set.
- Determinism: `seed(ui_capture.cfg › seed)` before each screen; animations paused where possible (pausing the tree also stops Tweens and AnimationPlayers; a screen that must keep animating opts out through a catalog flag); wait `settle_frames` (default 6) after setup, then `get_viewport().get_texture().get_image()`.
- Per catalog entry, state and size: reset run state as tests do (the catalog's `reset()` hook; default calls `reset_run()` on every autoload that has it), call the entry's `setup`, wait, capture, write the outputs, free the screen.
- Window size: set the root window size and content scale to the requested size and respect the project's stretch settings, so captures match what players see.
- A screen whose setup errors or prints a `SCRIPT ERROR` fails that screen (exit 1); the run continues.
- `design/` has a `.gdignore` in the project seed, so the editor does not import captures. `builds/` and `release.cfg` (export and release) are unrelated and untouched.

### 11.2 The catalog (`tools/ui_screens.gd`, project-owned)
```gdscript
extends "res://tools/ui_catalog.gd"

## Every screen the game has, and how to put it on screen in a representative state.
## Setup builds state through public APIs and debug hooks, then returns the node to show,
## or opens it through the game's own navigation and returns null.
func screens() -> Array[Dictionary]:
	return [
		{"id": "hub", "title": "Guild hall", "scene": "res://scenes/shell/HubView.tscn", "setup": _hub},
		{"id": "hero_room", "title": "Hero room", "scene": "res://scenes/shell/HeroRoomView.tscn",
			"states": {"default": _hero_room, "exhausted": _hero_room_exhausted}},
	]
```
The seed has one entry: the project's main scene (`application/run/main_scene` in `project.godot`). The base class `ui_catalog.gd` (framework-owned) provides `reset()`, `open_view(scene_path, args := {}) -> Node` (overridable when the game has a shell that must host views), `wait_frames(n)`, `focus_default(node)`, and the validation of 8.1. Writing and updating entries is the agent's job whenever it adds or changes a view.

### 11.3 Element map (Godot fields)
Mapped: every visible `Control` that is focusable, has text, has a unique name, or is a direct child of a Container the spec names; `native` holds `class`, `autowrap`, and `focus: {next, prev, up, down}`. `focus_order` is computed by following focus traversal from the default focus. 3D pickables (an `Area3D` or `CollisionObject3D` the game uses for clicking) are listed in `pickables_3d`, projected to screen rects through the active camera.

### 11.4 Lint in the check
`check_in_check = true` makes `check.gd` instantiate the catalog's screens in a `SubViewport` at the default size without rendering (Container sorting and text measurement work headless) and run `ui_lint.gd`. Findings fail the check only for screens in `enforce`; with `check_in_check = false` (the upgrade default) the check's behaviour and runtime are unchanged. `ui_lint.gd` is the same code capture uses.

### 11.5 Reader and overlay (headless, pure `Image` and JSON)
- `godot --headless --script tools/ui_drawing.gd -- director/ui/<screen>.excalidraw <ui folder>/captures/<screen>.drawing.json` writes `drawing.json` (4.4). Excalidraw's `image` element's `files` data URL is decoded with `Marshalls`/`Image`.
- `godot --headless --script tools/ui_overlay.gd -- compare <screen>` draws the compare image (outlines and labels with `Image` operations; label text uses a built-in bitmap font drawn by the script, since no rendering is available headless).
- Both are typed GDScript under `untyped_declaration=2`.

### 11.6 What changed since the spec's 3.5.0
Recorded so the build agent does not follow the spec where it no longer holds: there is a manifest, written by `install.sh` from `framework/` (nothing listed by hand); the screen setting is `[screens] dirs` of script folders; `check.gd` loads every `.gd`, so the tools must compile; there is `/export`, `/release`, `builds/` and `release.cfg` (unrelated to captures); Godot-Director has researcher and release procedures the rules list already names; the `Depends on: Q<n>` gating (export onboarding) is not used by `/ui-design`; `director/` has no `.gdignore`; the version is the release item's, not 3.6.0.

## 12. The Playwright adapter (App-Director and SaaSAllTheThings)

For web apps and the web clients of SaaSAllTheThings. Native Flutter and desktop clients get capture later (section 14); until then a project without a web client keeps the skill's `list` and `process` and has no capture (`ui_capture.sh` exits 3 with that reason).

### 12.1 Runtime
Node 18 or newer with the `playwright` package, in `tools/ui/` (its own `package.json`; `tools/ui/node_modules/` is gitignored). The scripts are plain ES modules (`.mjs`, no build step). Reasons:
- Playwright's own driver is Node, and it is the one tool here that owns the browser it drives, so nothing else needs installing but Chromium (`npx playwright install chromium`);
- the reader and the overlay run in the same runtime: the reader is JSON and string work, and the overlay draws the boxes in a Chromium page (the capture as the background, absolutely positioned labelled outlines), so no image library is added;
- App-Director's TypeScript stack and SaaSAllTheThings' TypeScript profile and web clients already need Node. A project on another stack (Python, .NET, Flutter web) needs Node only for this tool, not for its own build, and the folder keeps it apart from the stack.

### 12.2 `ui_capture.sh`
Checks for `node` and `tools/ui/node_modules/playwright` and for an installed Chromium; any missing: exit 3 with the exact command to fix it (`cd tools/ui && npm install && npx playwright install chromium`). Otherwise runs `node tools/ui/capture.mjs <args>`. Chromium runs headless, so no display is needed on any OS. It must run in Git Bash, macOS bash 3.2 and Linux. Capture never installs anything itself.

### 12.3 The catalog (`tools/ui/screens.mjs`, project-owned)
```js
// Every screen the app has, and how to put it on screen in a representative state.
// Setup uses fixtures or seeded data through the app's public APIs; never real user data.
export default {
  baseUrl: "http://localhost:5173",          // dev or test only
  screens: [
    { id: "home", title: "Home", route: "/" },
    { id: "orders", title: "Orders", route: "/orders",
      states: { default: seedOrders(3), empty: seedOrders(0) } },
  ],
};
```
- A screen has a `route` (and optional `auth`: a test account's saved sign-in state in the gitignored `tools/ui/.auth/`). A state is an async `(page, api) => ...` that seeds data through `api` (an HTTP helper bound to the dev or test backend) and prepares the page (open a dialog, fill a field). States are named like the Godot ones.
- `baseUrl` may also come from `tools/ui_capture.cfg` › `[web] base_url`. Capture refuses any host that is not `localhost`, `127.0.0.1` or listed in `[web] allow_hosts`: it never points at production. `[web] start_command` (optional) starts the app and capture waits for `[web] ready_url`, then stops it. Every request, redirect and WebSocket the page makes to another host is blocked and noted. SaaSAllTheThings may also capture its dev environment, named explicitly in `[web] dev_url`: that host is the only one allowed off this machine, with seeded test tenants and saved test sign-ins only; production and every other hosted address are refused, and a real tenant's data is never captured.
- The seed has one entry: the root route.

### 12.4 Capture
- Chromium, `viewport` = the requested size, `deviceScaleFactor` 1, fixed locale and timezone, `reducedMotion: "reduce"`, an injected stylesheet that disables animations and transitions, `page.clock` fixed, `Math.random` seeded by an init script (`[capture] seed`).
- Settle: wait for `load`, `document.fonts.ready`, and `settle_frames` animation frames with the network idle, then screenshot (the viewport only: the contract maps what the user sees at that size).
- Per catalog entry, state and size: new browser context (clean storage), seed, open, wait, capture, write outputs, close. A page error (`pageerror`, a failed first request, a state function that throws) fails that screen (exit 1) and the run continues.

### 12.5 Element map (web fields)
From the DOM and the accessibility tree, in one pass per page:
- the tree through Chrome DevTools Protocol (`Accessibility.getFullAXTree` on a `CDPSession`; Chromium-only, as is the capture), joined to DOM nodes by `backendDOMNodeId`, giving `kind` (role) and `name` (accessible name);
- bounding boxes from `getBoundingClientRect` in the same evaluation, rounded to pixels; `visible` from the box and computed style (`display`, `visibility`, `opacity`) and whether an ancestor clips it;
- `focusable` from the DOM (native interactive elements, `tabindex >= 0`, not `disabled`, visible);
- `overflow`: `clipped` is true when `scrollWidth` or `scrollHeight` exceeds the box and `overflow` hides it without an ellipsis; `wraps` from `white-space`;
- `id` is the `data-testid` when present (`stable: true`), else the role and name; `native` holds `tag`, `tabindex`, `aria` states, `disabled` and a CSS selector.
- Mapped: every visible element that is focusable, has a role other than generic or none with a name, has a `data-testid`, or is a direct child of a container the spec names; skip anonymous wrappers unless they are needed as parents. Same cap.
- **Focus order** by Tab traversal: focus the document, press Tab repeatedly (at most the number of focusable elements plus 10), recording `document.activeElement` after each press; the order is the sequence of first visits. A repeat before all are visited is a focus trap, listed as `unreachable` for the rest.

### 12.6 Lint, in web terms
The ids and thresholds of section 9, with these readings:
- `squeezed-text`: a wrapping text node narrower than `min_label_chars` average characters, or `clipped` text with no `text-overflow: ellipsis`.
- `stretched-control`: a `button`, `a` or role button whose height exceeds `max_button_height_ratio` times its content height plus vertical padding and border.
- `off-screen`: a visible element whose box starts left of 0 or ends right of the viewport width (horizontal overflow of the page), or sits outside an `overflow: hidden` ancestor. Content below the fold is normal and is not a finding.
- `overlap`: two focusable siblings whose boxes overlap, where `document.elementFromPoint` at the overlap's centre returns the other one (it blocks the click).
- `unreachable`: a focusable element Tab traversal did not visit.
- `no-default-focus`: a `dialog` or `aria-modal` element with focusable content when focus is not inside it; plain pages are exempt, since the browser's default is no initial focus.
- `hard-coded-position`: `position: absolute` or `fixed` with pixel `left` or `top` inside a flex or grid container (warning only).
- The lint runs at capture and `verify`. It does not run inside `check.sh` (needs a browser and a running app), so `check_in_check` and `enforce` do not exist for the web adapter; "lint in the check, on for new projects and off on upgrade" applies only to Godot-Director. The brief does not settle this; recommendation in review: leave it out until the pilot shows a need.

### 12.7 Reader and overlay
- `node tools/ui/drawing.mjs director/ui/<screen>.excalidraw <ui folder>/captures/<screen>.drawing.json` writes the `drawing.json` of 4.4.
- `node tools/ui/overlay.mjs compare <screen>` writes the compare image (8.2 naming) by rendering a small HTML page in Chromium.
- Starter drawing: `capture.mjs` writes it with the same structure as 4.3.

### 12.8 Where the spec points
The spec's `Opens` is the route; its `Name` column holds `data-testid` values. App-Director's `rules.md` UI layer rule applies unchanged: capture does not import the data layer. SaaSAllTheThings keeps clients thin and contract-only (`.satt/reference/clients.md`): states seed through the public API, which is what a client calls, and an architecture call stays with `architect.md`.

## 13. Acceptance criteria

### Godot (from the spec's section 11)
Prove in the framework's own test project (`examples/market-day`, whose selftest already runs against Godot):
1. `bash tools/ui_capture.sh --all` on Windows and macOS, and on Linux under `xvfb-run`, writes a PNG, element map, map image and lint file per catalog screen, state and size, exit 0. No file appears in `user://`.
2. A starter `.excalidraw` opens in excalidraw.com with the screenshot locked in a named frame; saving it unchanged and reading it back yields zero boxes and no `unparsed` entries.
3. A fixture drawing (checked into the framework's tests) with a green box with bound text and `click:`, a blue box overlapping an existing element, a red X over an element, an arrowed comment, a nested box, a note outside the frame and a freehand squiggle gives a `drawing.json` with exactly the expected boxes, intents, parent, comment, removal, note and one `unparsed` entry; coordinates match to 0.1%.
4. The same fixture with the background image moved and scaled 50% yields the same percentages.
5. Lint catches each rule on a fixture scene built to break it (a squeezed autowrap label, a stretched button, an off-screen button, two overlapping buttons, an unreachable button), and reports nothing on a clean fixture.
6. `verify` on a fixture whose built screen matches the spec reports no deviations; moving one node 10% reports exactly that element.
7. `check.sh` with `check_in_check = true` and a screen under `enforce` fails on a lint finding and passes otherwise; with `check_in_check = false`, the check's behaviour and runtime are unchanged.
8. A project upgraded from v3.10.0 (or earlier) gets the stubs, the `.gitignore` line and the manifest entries, keeps its own `AGENTS.md` and `check.cfg` untouched, ends with `check_in_check = false`, and align lists screens missing from the catalog without failing.
9. The procedure reads correctly with a tool that cannot view images: every step has a text path (element maps, `drawing.json`, lint text).
10. `selftest.sh` checks the wiring of section 2 (files, skill, rules entry, procedures, seeds, installer lines) and passes; no en or em dash appears.

### Web (the equivalent)
Prove in a small fixture web app checked into each framework's tests (static pages served locally, no backend), run on Windows, macOS and Linux:
1. `bash tools/ui_capture.sh --all` writes a PNG, element map, map image and lint file per catalog screen, state and size, exit 0, with no display on Linux. The run touches nothing outside `<ui folder>/captures/` and `tools/ui/`.
2. Capture is deterministic: two runs give identical element maps.
3. Criteria 2, 3 and 4 above, with the reader run by Node.
4. Lint catches each rule on a fixture page built to break it (a squeezed wrapping label, a stretched button, a button off the right edge, two overlapping links, a focusable element Tab skips, a modal that does not take focus), and reports nothing on a clean page.
5. The Tab-order test: a page with a known order and one trap gives that `focus_order` and exactly one `unreachable`.
6. `verify` on a page matching the spec reports no deviations; moving one element 10% reports exactly it.
7. With Node, Playwright or Chromium missing, `bash tools/ui_capture.sh` exits 3 with the install command and writes nothing; the framework's `check.sh` and its selftest still pass without them.
8. A `baseUrl` that is not local and not allowlisted is refused (exit 3).
9. A project upgraded from the earlier release gets the stubs, the `.gitignore` lines (`captures/`, `tools/ui/node_modules/`, `tools/ui/.auth/`) and the manifest entries, keeps its own `AGENTS.md` and `check.cfg`, and align lists routes missing from the catalog without failing.
10. The procedure reads correctly with a tool that cannot view images, and the framework's selftest checks the wiring.

## 14. Later (leave clean seams)

- **Native Flutter and desktop capture:** another adapter that meets Part B (Flutter's golden and integration-test screenshots with the semantics tree as the element map; a desktop app's accessibility tree).
- **Penpot** adapter: read its SVG export with layer names, the same `drawing.json`.
- **Figma** adapter: the REST API with a personal token in a gitignored file; only with the director's consent, and never sending product data.
- **Annotated PNG fallback:** a director who draws on a screenshot in any image editor; the agent reads the image visually, says the reading is approximate, and asks more questions.
- **Theme skill:** fonts, colours and spacing as the framework's theme resource.
- **Mockup-first mode:** the agent builds an HTML mockup of a drawing for quick iteration before the real build.

## 15. What the audit compares

**The same in all three**

| Part | Behaviour |
|---|---|
| Skill | `/ui-design` with `capture`, `process`, `verify`, `list`; one procedure file, `ui-design.md`, and a thin wrapper |
| Role | The director draws and decides; the agent captures, reads, proposes and builds; the agent never writes `director/` |
| Files | The catalog, `tools/ui_capture.cfg`, `<ui folder>/README.md` and specs (project-owned seeds); captures gitignored |
| Drawings | The Excalidraw conventions, the starter drawing and `drawing.json` (`"schema": 1`) |
| Element map | `elements.json` (`"schema": 1`) with the common fields of 8.2 |
| Outputs | `.png`, `.elements.json`, `.map.png`, `.lint.txt`, `.starter.excalidraw`, `.compare@WxH.png` |
| Contract | Exit codes 0, 1 and 3; determinism rules; a skipped capture says why and writes nothing |
| Lint | The seven rule ids of section 9, the same config keys and thresholds |
| Items | `UI: <ui folder>/<screen>.md`; the `Screen:` line of the build report; the three tags of the framework |
| Hooks | build, review, the human check, align, design: one change each, as section 2 lists |
| Ownership | The `UI / screen layout` row asks once; declining changes nothing else |
| Settled | Section 7 |
| Wording | "requirements", "control framework" or "security framework"; no en or em dashes |

**What each framework adds**

| | App-Director | Godot-Director | SaaSAllTheThings |
|---|---|---|---|
| Adapter | Playwright | Godot | Playwright (web clients) |
| Catalog | `tools/ui/screens.mjs` | `tools/ui_screens.gd` | `tools/ui/screens.mjs` |
| Reader and overlay | Node | Godot headless | Node |
| Human check | acceptance check, `(demo)` | function check, `(play)` | acceptance check, `(demo)` |
| `<ui folder>` | `product/ui/` | `design/ui/` | `product/ui/` |
| Screen folders | `[ui] dirs` | `[screens] dirs` (scripts) | `[layers]` › `client` |
| Lint in the check | no | yes (`check_in_check`, `enforce`) | no |
| Protected space | `guard-protected.sh` | `guard-protected.sh` and `director/.gdignore` | `director/` added to `guard-authority.sh` and `rules.md` |
| Extra | stack runner in `tools/stacks/` | 3D pickables, `xvfb-run` on Linux | dev environment and test tenants only; thin clients per `reference/clients.md` |
