# Frameworks

Three frameworks put Director-Driven Development to work. The same loop runs all three; only the rules the check enforces change. Each repository's README and procedures are the source of truth, and these pages link to them.

| | [App-Director](app-director.md) | [Godot-Director](godot-director.md) | [SaaSAllTheThings](saasallthethings.md) |
|---|---|---|---|
| For | Small web, mobile and desktop apps | Games in Godot 4 | Multi-tenant B2B SaaS on Azure |
| Stacks | TypeScript, Flutter, Python | GDScript | .NET by default; TypeScript and Python |
| The director owns | Product vision and design | Design, balance, art direction | The product; the framework owns the architecture |
| The check fails on | UI importing the data layer, secrets, failing types, lint or tests | Game rules in screen scripts, load errors, failing tests, smoke autoplay findings once the game's adapter is wired | Architecture rules (layers, tenancy, secrets, sizes, cost SKUs), failing build or tests |
| Human rounds | `/acceptance` | `/playtest`, `/function-check` | `/acceptance`, `/feedback` |
| In your project | `.app-director/` | `.godot-director/` | `.satt/` |

## Shared by all three

- The loop through `/next-task`, design sessions through `/design`, and the records: `AGENTS.md`, `TASKS.md`, a design document and a decision log.
- `/align`, `/drift-reset`, `/prune`, `/refresh-model-sizing`, [`/research`](../skills/research.md) and [`/ui-design`](../skills/ui-design.md).
- A builder, a read-only reviewer and a read-only researcher as Claude Code subagents.
- `bash tools/check.sh` with result caching (`--if-changed`), and a git pre-commit hook that runs it when a commit touches code.
- Hooks in Claude Code that run the check before the agent ends its turn and block work-destroying git commands.
- Installation as a skill (`npx skills add`), as a Claude Code plugin, or by hand, each taking the latest release, followed by onboarding that ends in one commit for you to approve.
- MIT licence. Each framework runs on your machine and sends nothing anywhere, except the web searches its researcher makes.

<div class="takeaway"><span>Directing scales by turning repeated judgement into checks.</span><span class="url"><a href="https://github.com/Freakling">github.com/Freakling</a></span></div>
