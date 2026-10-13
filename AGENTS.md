# Director-Driven Development docs

The documentation site for Director-Driven Development (DDD) and its three frameworks: a static MkDocs site that explains how DDD works, links each framework's repository as the source of truth, and links back to the blog for the why.

Instructions for AI assistants working on this app. The workflow is App Director: its rules are in `.app-director/rules.md`, which names the procedure for each kind of request. Read it before any work, unless your tool has already loaded it (Claude Code imports it: @.app-director/rules.md).

## Project facts
- Stack: none (Markdown and MkDocs with the Material theme; Python only to run MkDocs) · web, static site
- Storage: none
- API: none
- Hosting: GitHub Pages, deployed by GitHub Actions (`.github/workflows/docs.yml`) from `main`
- Published at: https://freakling.github.io/Director-Driven-Development/

## Layout
| Folder | Holds |
|---|---|
| `docs/` | The pages, one Markdown file each; `docs/index.md` is the home page |
| `docs/concept/` | Concept reference: roles, loop, sizing, reviews, align and drift reset |
| `docs/frameworks/` | One page per framework, plus the comparison page |
| `docs/assets/stylesheets/ddd.css` | The theme: the DDD graphical profile on top of Material |
| `docs/assets/fonts/` | Archivo and IBM Plex Mono, with their OFL licences |
| `mkdocs.yml` | Site settings, theme, Markdown extensions and the navigation |
| `selftest.sh` | Dashes, docs coverage and the strict build; run by `tools/check.local.sh` and CI |
| `.github/workflows/` | CI: selftest on every push and pull request, deploy `main` to Pages |
| `init/` | Gitignored handover material (drafts, graphics, prompts); read for context, never published |

## Architecture
One row per significant system: what it owns and where its boundary is.

| System | Owns | Where | Talks to |
|---|---|---|---|
| Pages | All published text: home, concept, token cost, frameworks | `docs/**/*.md` | Navigation, theme |
| Navigation | Page order and sections | `mkdocs.yml` › `nav` | Pages |
| Theme | Colours, type, cards, tags, buttons, takeaway line | `docs/assets/stylesheets/ddd.css`, `docs/assets/fonts/`, `mkdocs.yml` › `theme` | Pages (CSS classes `ddd-card`, `tag`, `kicker`, `takeaway`) |
| Selftest | En and em dashes, docs coverage of every framework command, strict build with link and anchor checks, no unrendered Markdown links | `selftest.sh` | The three framework repos on GitHub (shallow clones cached in `.app-director/state/frameworks`, reused offline), MkDocs |
| Audit | Compares framework skill files against skill pages and reports undocumented differences | `tools/audit.sh` | The three framework repos (read from `.app-director/state/frameworks/`) |
| Alignment | Translates audit findings into TASKS.md items for updating skill pages | `tools/push-alignment.sh` (planned, not yet built) | Audit (`tools/audit.sh`), TASKS.md |
| Orchestrator | Audit of the framework repos against the skill pages, and alignment tasks pushed to them by pull request (dry run unless `--open-prs`; never merges) | `tools/audit.sh`, `tools/push-alignment.sh` | The cached framework repos, the framework repos on GitHub (`gh`), Pages (skill pages) |
| Delivery | Build and deploy to GitHub Pages | `.github/workflows/docs.yml`, `requirements.txt` | Selftest, GitHub Pages |

## Ownership
| Area | Owner | Placeholder |
|---|---|---|
| Frontend / UI (theme, layout) | agent | |
| Copy / page text | agent | |
| Visual design / assets | agent | |
| Testing (selftest) | agent | |
| Infrastructure / deployment (CI, Pages) | agent | |

## Project rules
- Model sizing: on
  - XS: claude-haiku-5-5
  - S:  claude-haiku-5-5
  - M:  claude-sonnet-5-5
  - L:  claude-opus-5-5
  - XL: claude-opus-5-5
- Not a typed code base: "Statically typed" in the rules doesn't apply; there is no app code. The check is gitleaks plus `tools/check.local.sh` (the selftest).
- Accuracy first: check every statement against the latest version of the three framework repos (`Freakling/Godot-Director`, `Freakling/App-Director`, `Freakling/SaaSAllTheThings`) before writing it. Never overclaim, and never mention version history or past versions.
- Link, don't copy: framework procedures stay in their repos; pages link to them.
- Voice: positive framing; no open-question endings (end with an invitation); no flashy titles; don't repeat information (a table and a figure saying the same thing: keep one); no en or em dashes.
- Words: "requirements", "control framework" or "security framework", never "policy". SaaSAllTheThings is anchored in the customer's security framework; it is not "compliance as code". "Secure by design", not "security by design".
- The blog explains why, the docs explain how: pages link to the saemundsson.se post that introduced the idea. Never change a WordPress post from this project.
