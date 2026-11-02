# Frameworks

Three frameworks put Director-Driven Development to work. The same loop runs all three; only the rules the check enforces change. Each repository's README and procedures are the source of truth, and these pages link to them.

| | [App-Director](app-director.md) | [Godot-Director](godot-director.md) | [SaaSAllTheThings](saasallthethings.md) |
|---|---|---|---|
| For | Small web, mobile and desktop apps | Games in Godot 4 | Multi-tenant B2B SaaS on Azure |
| Stacks | TypeScript, Flutter, Python | GDScript | .NET by default; TypeScript and Python |
| The director owns | Product vision and design | Design, balance, art direction | The product; the framework owns the architecture |
| The check fails on | UI importing the data layer, secrets, failing types, lint or tests | Game rules in screen scripts, secrets (when gitleaks is installed), load errors, failing tests, layout lint findings on the screens it enforces, smoke autoplay findings once the game's adapter is wired | Architecture rules (layers, tenancy, secrets, sizes, cost SKUs), failing build or tests |
| Security baseline | OWASP Top 10 (2025), assessed by `/security` | `/security` isn't shipped | OWASP Top 10 (2025), assessed by `/security` |
| Control framework | | | The compliance questions, and `compliance/mapping.md` |
| Human rounds | `/acceptance` | `/playtest`, `/function-check` | `/acceptance`, `/feedback` |
| User stories | Always kept, in `product/user-stories.md` | Optional, asked once in onboarding, in `design/user-stories.md` | Always kept, in `product/user-stories.md`, with the PRD's personas as the roles |
| In your project | `.app-director/` | `.godot-director/` | `.satt/` |

## Shared by all three

- The loop through `/next-task`, design sessions through `/design`, and the records: `AGENTS.md`, `TASKS.md`, a design document and a decision log.
- [`/release`](../skills/release.md), each to its own kind of target, `/align`, `/drift-reset`, `/prune`, `/refresh-model-sizing`, [`/research`](../skills/research.md), [`/ui-design`](../skills/ui-design.md) and [`/prototype`](../skills/prototype.md), which tries a change in a worktree of its own before it is built.
- [User stories](../concept/user-stories.md) that say why each item is built, and that you confirm in design sessions, in the human round and in align.
- A builder, a read-only reviewer and a read-only researcher as Claude Code subagents.
- `bash tools/check.sh` with result caching (`--if-changed`), and a git pre-commit hook that runs it when a commit touches code.
- Hooks in Claude Code that run the check before the agent ends its turn and block work-destroying git commands. They also block the git flags that write a file, read a file outside the repository or run a configured command. The hooks also keep the agent out of the gh, git credential and SSH stores.
- Installation as a skill (`npx skills add`), as a Claude Code plugin, or by hand, each taking the latest release, followed by onboarding that ends in one commit for you to approve.
- MIT licence. Each framework runs on your machine and sends nothing anywhere, except the web searches its researcher makes.

<div class="takeaway"><span>Directing scales by turning repeated judgement into checks.</span><span class="url"><a href="https://github.com/Freakling">github.com/Freakling</a></span></div>
