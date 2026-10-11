# Frameworks

Three frameworks put Director-Driven Development to work. The same loop runs all three; only the rules the check enforces change. Each repository's README and procedures are the source of truth, and these pages link to them.

| | [Godot-Director](godot-director.md) | [App-Director](app-director.md) | [SaaSAllTheThings](saasallthethings.md) |
|---|---|---|---|
| For | Games in Godot 4 | Small web, mobile and desktop apps | Multi-tenant B2B SaaS on Azure |
| Stacks | GDScript | TypeScript, Flutter, Python | .NET by default; TypeScript and Python |
| The director owns | Design, balance, art direction | Product vision and design | The product; the framework owns the architecture |
| The check fails on | Game rules in screen scripts, load errors, failing tests | UI importing the data layer, secrets, failing types, lint or tests | Architecture rules (layers, tenancy, secrets, sizes, cost SKUs), failing build or tests |
| Human rounds | `/playtest`, `/function-check` | `/acceptance` | `/acceptance`, `/feedback` |
| In your project | `.godot-director/` | `.app-director/` | `.satt/` |

## Shared by all three

- The loop through `/next-task`, design sessions through `/design`, and the records: `AGENTS.md`, `TASKS.md`, a design document and a decision log.
- `/align`, `/drift-reset`, `/prune` and `/refresh-model-sizing`.
- A builder and a read-only reviewer as Claude Code subagents.
- `bash tools/check.sh` with result caching (`--if-changed`), and a git pre-commit hook that runs it when a commit touches code.
- Hooks in Claude Code that run the check before the agent ends its turn and block work-destroying git commands.
- Installation as a skill (`npx skills add`), as a Claude Code plugin, or by hand, followed by onboarding that ends in one commit for you to approve.
- MIT licence. Each framework runs on your machine and sends nothing anywhere.

<div class="takeaway"><span>Directing scales by turning repeated judgement into checks.</span><span class="url"><a href="https://github.com/Freakling">github.com/Freakling</a></span></div>
