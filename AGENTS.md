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
| `work/` | Gitignored clones of the three framework repos, where framework items are built (`tools/work-clones.sh`); they leave this machine only as pull requests (`tools/work-publish.sh`) |

## Architecture
One row per significant system: what it owns and where its boundary is.

| System | Owns | Where | Talks to |
|---|---|---|---|
| Pages | All published text: home, concept, token cost, frameworks | `docs/**/*.md` | Navigation, theme |
| Navigation | Page order and sections | `mkdocs.yml` › `nav` | Pages |
| Theme | Colours, type, cards, tags, buttons, takeaway line | `docs/assets/stylesheets/ddd.css`, `docs/assets/fonts/`, `mkdocs.yml` › `theme` | Pages (CSS classes `ddd-card`, `tag`, `kicker`, `takeaway`) |
| Selftest | En and em dashes, docs coverage of every command in each framework's latest release (warns when a page describes something only `main` ships), links into the framework repos at their latest release, strict build with link and anchor checks, no unrendered Markdown links | `selftest.sh` | The three framework repos on GitHub (each kept at its latest `v<version>` release in `.app-director/state/frameworks`, reused offline), MkDocs |
| Audit | Compares each framework's latest release with the skill pages and reports undocumented differences; refuses a cache that isn't at a release | `tools/audit.sh` | The release copies in `.app-director/state/frameworks/`, kept there by the selftest |
| Alignment | Translates audit findings into TASKS.md items for updating skill pages | `tools/push-alignment.sh` (planned, not yet built) | Audit (`tools/audit.sh`), TASKS.md |
| Orchestrator | Framework items built in the clones under `work/` and published as one pull request each (never merges); audit of the framework releases against the skill pages; alignment items pushed by pull request (dry run unless `--open-prs`) | `tools/work-clones.sh`, `tools/work-publish.sh`, `tools/audit.sh`, `tools/push-alignment.sh` | The framework clones in `work/`, the release cache, the framework repos on GitHub (`gh`), Pages (skill pages) |
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
- Accuracy first: check every statement against the latest release of the three framework repos (`Freakling/Godot-Director`, `Freakling/App-Director`, `Freakling/SaaSAllTheThings`) before writing it. Never overclaim, and never mention version history or past versions.
- Link, don't copy: framework procedures stay in their repos; pages link to them.
- Voice: positive framing; no open-question endings (end with an invitation); no flashy titles; don't repeat information (a table and a figure saying the same thing: keep one); no en or em dashes.
- Words: "requirements", "control framework" or "security framework", never "policy". SaaSAllTheThings is anchored in the customer's security framework; it is not "compliance as code". "Secure by design", not "security by design".
- Framework work: an item whose `Touches` names a clone under `work/` is built in that clone, not in this repo.
  - **Where:** `bash tools/work-clones.sh` clones the three framework repos into `work/` or fetches the existing clones. `/next-task <framework>` picks the next ready item whose `Touches` names that framework's clone.
  - **Branch:** `ddd/T<n>` (this repo's item ID) from the latest `origin/main`, one per item and repo.
  - **Rules:** that repo's own developer notes (`CLAUDE.md`; `.claude/CLAUDE.md` in SaaSAllTheThings), not the templates under its `framework/` and `project/`, and not this repo's rules for code.
  - **Gate:** that repo's `selftest.sh` (Godot-Director's takes the path to Godot 4.3 or newer) instead of `bash tools/check.sh`. Two failed attempts stop the build, as in `build.md`.
  - **Records there:** the item is added, already done, to that repo's root `TASKS.md` with that repo's next ID, and the change gets a `CHANGELOG.md` entry. `project/TASKS.md` never receives it.
  - **Publish:** the builder builds and runs the gate; this session then commits on the branch (one item, one commit per repo) and runs `bash tools/work-publish.sh work/<repo>`, which pushes the branch and opens the pull request. No pause for approval, even for a single task: the director's review and merge on GitHub is the gate (Q13). The agent never merges, and releases are the director's call, not part of an item.
  - **Records here:** the item is done when its pull requests are open; its records here are committed without pausing too. Pushing this repo still waits until the director asks.
- The blog explains why, the docs explain how: pages link to the saemundsson.se post that introduced the idea. Never change a WordPress post from this project.
