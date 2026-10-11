# /align

<div class="kicker">The consistency pass, run often</div>

`/align` checks that the design, the decision log, the task queue, the assistant's rules file, the settings and the code still agree with each other. It is the routine pass that catches drift while it is still small. The concept behind it is on [Align and drift reset](../concept/drift.md).

## What it does

1. **Check the placeholders and entry files.** No template value is left unfilled, the rules file points to the right place, and no install file is left unmerged.
2. **Check the items.** IDs are unique and below the next ID, every dependency exists, no finished item depends on an unfinished one, and each agent item has a size, the files it touches, tagged outcomes and a link to the design text. A claim on an item from an earlier day is reported.
3. **Check coverage and architecture.** Every design rule is either built, planned or reported as a gap. Every row of the architecture table points at something that exists.
4. **Check decisions and setup.** Recent decisions are reflected in the design text, and no older text contradicts them. The check passes, and the git lines that the installer added are still there.
5. **Report.** The skill fixes mechanical drift on the spot and lists what needs the director, with one recommendation for each item. It never changes the design. The fixes are committed as `docs: align` once the director approves.

When a conflict comes back that was already settled, or one conflict spans several design principles, the skill recommends a [drift reset](drift-reset.md). It never starts one itself.

## Unique per repo

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/align.md`](https://github.com/Freakling/Godot-Director/tree/main/framework/.godot-director/procedures/align.md) in the Godot-Director repository.

- It checks the GDD, `design/decisions.md`, `playtesting/TEMPLATE.md` and `project.godot` against `AGENTS.md`. Every autoload and every rule folder needs an Architecture row.
- Every file listed under `[screens] known` in `tools/check.cfg` needs an open item that removes it from the list.
- It counts the balance placeholders in the scripts and writes the number into the Content and balance milestone row.
- The check must pass with no notes about typing or hooks.
- During onboarding, the fixes go into the install commit instead of a separate one.

### App-Director

The procedure is at [`framework/.app-director/procedures/align.md`](https://github.com/Freakling/App-Director/tree/main/framework/.app-director/procedures/align.md) in the App-Director repository.

- It checks the brief, `product/decisions.md`, `validation/TEMPLATE.md` and the check config. The `[ui] dirs` and `[data] dirs` in `tools/check.cfg` must match the folder layout.
- Every item's `Brief:` value must be an existing heading, or `-` for items that aren't about the product design.
- The `docs: align` commit body names the conflicts that need the director, so the next pass can tell a repeat.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/align.md`](https://github.com/Freakling/SaaSAllTheThings/tree/main/framework/.satt/procedures/align.md) in the SaaSAllTheThings repository.

- It checks the PRD, `product/decisions.md`, the ADRs and the integration contracts. Every `ADR:` an item names must exist, and every accepted ADR with a temporary deviation needs its removal item.
- It runs `bash tools/check.sh --architecture` and reports any stale ADR exceptions, any proposed ADR waiting longer than a week and the count of source files outside any layer.
- It checks that `AGENTS.md` › Layout matches the layers in `tools/check.cfg`, and reports workshop notes under `assessment/workshops/` that have no `Processed:` line.
- It never changes the product or the architecture.

<div class="takeaway"><span>Run it after every big design change, and let the small drift get caught while it is small.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
