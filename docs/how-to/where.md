# I want to change something. Which file is it in?

<div class="kicker">Each fact lives in one file, and each file has one way to change it</div>

> Find the row for what you want to change, then read across to your framework's file. The last column says whether you edit it yourself, or ask for the change through a design session, a build or a question.

## The files

| You want to change | App-Director | Godot-Director | SaaSAllTheThings | How |
|---|---|---|---|---|
| What the product is | `product/brief.md` | `design/gdd.md` | `product/prd.md` | Through a [design session](decide.md) |
| Why a decision was made | `product/decisions.md` | `design/decisions.md` | `product/decisions.md` | Through a [design session](decide.md). The log is append-only: a session adds a line, and no one edits an old one |
| What's undecided | brief › Open Questions | GDD › Open Questions | PRD › Open Questions | Through a [design session](decide.md). `/design questions` ranks them, and the agent never answers one for you |
| What gets built next, and in what order | `TASKS.md` | `TASKS.md` | `TASKS.md` | Edit the order yourself, or ask the agent for a suggestion ([How do I get things built?](build.md)) |
| The rules the agent follows | `AGENTS.md` › Project rules | `AGENTS.md` › Project rules | `AGENTS.md` › Project rules | Edit it yourself. The agent reads it at the start of every session, and [the records check](align.md) compares it with the rest |
| Which systems exist, and what each owns | `AGENTS.md` › Architecture | `AGENTS.md` › Architecture | `AGENTS.md` › Architecture | Ask the agent in the [build](build.md) that adds or moves a system. The row changes in the same commit |
| What the check enforces | `tools/check.cfg` | `tools/check.cfg` | `tools/check.cfg`, and the reference in `.satt/reference/layers.md` | Edit `check.cfg` yourself, since it is yours to change. The reference belongs to the framework, and a project exception needs an accepted ADR ([the check](check.md)) |
| A screen's layout | `product/ui/<screen>.md` | `design/ui/<screen>.md` | `product/ui/<screen>.md` | Through the [UI question](ui.md) |
| Your own assets and notes | `director/` | `director/` | `director/` | Edit it yourself. The agent reads it for context and never writes there. Drawings go in `director/ui/` ([UI changes](ui.md)) |
| What the agent may do without asking | `.claude/settings.json` | `.claude/settings.json` | `.claude/settings.json` | Edit it yourself. Put machine-only changes in `.claude/settings.local.json`, which is gitignored. A new permission loads when a session starts ([Something isn't there](trouble.md)) |
| The model for each task size | `AGENTS.md` › Project rules, Model sizing | `AGENTS.md` › Project rules, Model sizing | `AGENTS.md` › Project rules, Model sizing | Ask for "Refresh the model sizing", or run `/refresh-model-sizing` ([cost](cost.md)) |
| Where research notes live | `product/research/` | `design/research/` | `product/research/` | Ask a question ([I need facts before I decide](facts.md)). The researcher writes the notes, and later sessions reuse or update them |
| Architecture decisions (ADRs) | None | None | `adr/ADR-<n>-<slug>.md` | Through `/architect`. Only you accept an ADR, and a hook asks before it is marked accepted ([the ADR rule](../frameworks/saasallthethings.md#deviation-is-an-adr)) |

## How to read it

Edit a file yourself when the change is small and you can see the result in it. Ask the agent when the change should land with the code it touches, as a build does. Go through a design session when the change is a decision, because the decision and its reason are written down together, and the decision log never changes by hand.

The rows come from each framework's "Each fact lives in one place" table at its latest release: [App-Director](https://github.com/Freakling/App-Director/blob/v1.11.0/framework/.app-director/rules.md), [Godot-Director](https://github.com/Freakling/Godot-Director/blob/v4.4.0/framework/.godot-director/rules.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/blob/v0.14.0/framework/.satt/rules.md). Not sure where a fact lives? Ask the agent. It reads the same table at the start of every session.

## Related

- [Records in files](../concept/records.md), the concept behind these files.
- [How do I decide what gets built, or change how something works?](decide.md) and [How do I get things built?](build.md), the two ways most changes are made.

<div class="takeaway"><span>One fact, one file. Change it where it lives.</span><span class="url"><a href="index.md">All questions</a></span></div>
