# /align

<div class="kicker">The consistency pass, run often</div>

`/align` checks that the design, the decision log, the task queue, the assistant's rules file, the settings and the code still agree with each other. It is the routine pass that catches drift while it is still small. The concept behind it is on [Align and drift reset](../concept/drift.md).

How to use it: [The records and the code don't agree](../how-to/align.md)

## What it does

1. **Check the placeholders and entry files.** No template value is left unfilled, the rules file points to the right place, and no install file is left unmerged.
2. **Check the items.** IDs are unique and below the next ID, every dependency exists, no finished item depends on an unfinished one, and each agent item has a size, the files it touches, tagged outcomes and a link to the design text. A claim on an item from an earlier day is reported.
3. **Check coverage and architecture.** Every design rule is either built, planned or reported as a gap. Every row of the architecture table points at something that exists.
4. **Check the design text against reality.** The skill reads the whole design document, from its first line to its last, not section by section. Every statement of state is checked against the built product, the done items and the latest releases: a section marked later or planned, a count, a list of what exists, a line saying work waits on something, and "once X exists". Every decision recorded since the last `docs: align` commit is checked one by one, not a sample, to see that the design text reflects it and nothing older contradicts it.
5. **Check the setup.** The check passes, and the git lines that the installer added are still there.
6. **Report.** The skill fixes mechanical drift on the spot, such as a statement whose fact is settled because the item is done. It lists what needs the director, with one recommendation for each item, and names each stale statement so the next pass can tell a repeat. It never changes the design. The fixes are committed as `docs: align` once the director approves.

When a conflict comes back that was already settled, or one conflict spans several design principles, the skill recommends a [drift reset](drift-reset.md). It never starts one itself.

## Unique per repo

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/align.md`](https://github.com/Freakling/Godot-Director/tree/v3.13.0/framework/.godot-director/procedures/align.md) in the Godot-Director repository.

- It checks the GDD, `design/decisions.md`, `playtesting/TEMPLATE.md` and `project.godot` against `AGENTS.md`. The whole-document read is of `design/gdd.md`, and the latest releases are the game's exports and their UAT or production uploads. Every autoload and every rule folder needs an Architecture row.
- Every file listed under `[screens] known` in `tools/check.cfg` needs an open item that removes it from the list.
- It counts the balance placeholders in the scripts and writes the number into the Content and balance milestone row.
- The check must pass with no notes about typing or hooks.
- During onboarding, the fixes go into the install commit instead of a separate one.
- `AGENTS.md` points to `.godot-director/rules.md`, and `CLAUDE.md` contains `@AGENTS.md`.
- Items follow `.godot-director/tasks.md`.
- `bash tools/check.sh` passes with no `note:` about typing or hooks.
- The `.gitignore` and `.gitattributes` lines that `install.sh` adds are still there. If any are missing, rerun the installer.

### App-Director

The procedure is at [`framework/.app-director/procedures/align.md`](https://github.com/Freakling/App-Director/tree/v1.7.0/framework/.app-director/procedures/align.md) in the App-Director repository.

- It checks the brief, `product/decisions.md`, `validation/TEMPLATE.md` and the check config. The whole-document read is of `product/brief.md`, and the latest releases are the app's deploys. The `[ui] dirs` and `[data] dirs` in `tools/check.cfg` must match the folder layout.
- Every item's `Brief:` value must be an existing heading, or `-` for items that aren't about the product design.
- The `docs: align` commit body names the conflicts that need the director, so the next pass can tell a repeat.
- `AGENTS.md` points to `.app-director/rules.md`, and `CLAUDE.md` contains `@AGENTS.md`.
- Items follow `.app-director/tasks.md`.
- `bash tools/check.sh` passes.
- The `.gitignore` and `.gitattributes` lines that `install.sh` adds are still there.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/align.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.9.0/framework/.satt/procedures/align.md) in the SaaSAllTheThings repository.

- It checks the PRD, `product/decisions.md`, the ADRs and the integration contracts. The whole-document read covers the PRD and every ADR, and an ADR's status is a statement of state too: an accepted ADR's decision is in the code or infrastructure or has an open item, and a proposed ADR that the code already follows is stale. The latest releases are the deploys to `dev` and `prod`. Every `ADR:` an item names must exist, and every accepted ADR with a temporary deviation needs its removal item.
- It runs `bash tools/check.sh --architecture` and reports any stale ADR exceptions, any proposed ADR waiting longer than a week and the count of source files outside any layer.
- It checks that `AGENTS.md` › Layout matches the layers in `tools/check.cfg`, and reports workshop notes under `assessment/workshops/` that have no `Processed:` line.
- It never changes the product or the architecture.
- `AGENTS.md` points to `.satt/rules.md`, and `CLAUDE.md` contains `@AGENTS.md`.
- Items follow `.satt/tasks.md`.
- `bash tools/check.sh` passes and prints no `note:` about the hook or the toolchain.
- The `.gitignore` and `.gitattributes` lines that `install.sh` adds are still there. If any are missing, rerun the installer.

<div class="takeaway"><span>Run it after every big design change, and let the small drift get caught while it is small.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
