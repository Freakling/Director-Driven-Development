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
| `overrides/` | Material template overrides: `main.html` sets the Content-Security-Policy meta tag |
| `mkdocs.yml` | Site settings, theme, Markdown extensions and the navigation |
| `selftest.sh` | Dashes, docs coverage and the strict build; run by `tools/check.local.sh` and CI |
| `.github/workflows/` | CI: selftest on every push and pull request, deploy `main` to Pages |
| `product/ui/` | Screen specs from `/ui-design` and its gitignored `captures/`; unused while the site has no screens to design |
| `tools/ui/` | Screen capture (Node and Playwright), with `screens.mjs` the catalog; installed by App Director, not used by this static site |
| `init/` | Gitignored handover material (drafts, graphics, prompts); read for context, never published |
| `work/` | Gitignored clones of the three framework repos, where framework items are built (`tools/work-clones.sh`); they leave this machine only as pull requests (`tools/work-publish.sh`) |

## Architecture
One row per significant system: what it owns and where its boundary is.

| System | Owns | Where | Talks to |
|---|---|---|---|
| Pages | All published text: home, concept, token cost, frameworks | `docs/**/*.md` | Navigation, theme |
| Navigation | Page order and sections | `mkdocs.yml` › `nav` | Pages |
| Theme | Colours, type, cards, tags, buttons, takeaway line, and the Content-Security-Policy meta tag first in every page's head | `docs/assets/stylesheets/ddd.css`, `docs/assets/fonts/`, `overrides/main.html`, `mkdocs.yml` › `theme` | Pages (CSS classes `ddd-card`, `tag`, `kicker`, `takeaway`) |
| Selftest | En and em dashes, the agent's allow-list naming no generic code runner, the guard hook and deny rules blocking git's file-writing, file-reading and external-command flags and script paths that leave `tools/`, docs coverage of every command in each framework's pinned release (warns when a page describes something only `main` ships, and when a framework has a newer release than its pin), links into the framework repos at the pinned release, strict build with link and anchor checks, the Content-Security-Policy allowing every inline script the built site runs, no unrendered Markdown links | `selftest.sh` | `frameworks.lock` (the pinned release of each framework), the three framework repos on GitHub (each kept at its pinned `v<version>` release in `.app-director/state/frameworks`, reused offline), MkDocs |
| Audit | Compares each framework's pinned release (`frameworks.lock`) with the skill pages and reports undocumented differences; refuses a cache that isn't at the pin | `tools/audit.sh` | The release copies in `.app-director/state/frameworks/`, kept there by the selftest |
| Orchestrator | Framework items built in the clones under `work/` and published as one bundle pull request per repo, after a gitleaks scan of the commits it pushes (never merges); releases tagged and published once the director merges the bundle pull request; audit of the framework releases against the skill pages; alignment items filed in TASKS.md, to be built in `work/` (dry run unless `--add`) | `tools/work-clones.sh`, `tools/work-publish.sh`, `tools/work-release.sh`, `tools/audit.sh`, `tools/push-alignment.sh` | The framework clones in `work/`, gitleaks, the release cache, the framework repos on GitHub (`gh`), Pages (skill pages), TASKS.md |
| Delivery | Secrets scan of the full history, build and deploy to GitHub Pages, with every Python package pinned by hash and every action by commit | `.github/workflows/docs.yml`, `.github/dependabot.yml`, `requirements.txt` | gitleaks (its release, checksum verified), Selftest, GitHub Pages |
| Usage | What a project's Claude Code sessions cost: the transcripts priced at dated API rates, by token kind and session, with the director's keyboard hours and the no-cache and single-model counterfactuals | `tools/usage.py` | The transcripts under `~/.claude/projects` |

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
- Latest only: every page assumes the latest release of each framework, and the site isn't versioned. `frameworks.lock` pins each framework to the release the pages describe, and the selftest checks links and commands against the pin, so a new release never turns CI red by itself: the selftest prints a `WARN` while a framework is released past its pin, and the docs follow-up item clears it. No page tells the reader to upgrade, names a framework version number in prose, or says to restart so a new skill loads; the troubleshooting page in How-to is the one place that says "make sure you're on the latest release", with the upgrade commands per framework, and other pages link it when a step may fail on an older install.
- Voice: positive framing; no open-question endings (end with an invitation); no flashy titles; don't repeat information (a table and a figure saying the same thing: keep one); no en or em dashes.
- Words: "requirements", "control framework" or "security framework", never "policy". SaaSAllTheThings is anchored in the customer's security framework; it is not "compliance as code". "Secure by design", not "security by design".
- Framework work: an item whose `Touches` names a clone under `work/` is built in that clone, not in this repo.
  - **Where:** `bash tools/work-clones.sh` clones the three framework repos into `work/` or fetches the existing clones. `/next-task <framework>` picks the next ready item whose `Touches` names that framework's clone.
  - **Branch:** one bundle branch per repo. While a repo has no open bundle pull request, its next item starts `ddd/bundle-YYYY-MM-DD` (the day it starts) from the latest `origin/main`; while it has one, every new item for that repo goes on its branch, so no item waits for another's merge.
  - **Rules:** that repo's own developer notes (`CLAUDE.md`; `.claude/CLAUDE.md` in SaaSAllTheThings), not the templates under its `framework/` and `project/`, and not this repo's rules for code.
  - **Gate:** that repo's `selftest.sh` (Godot-Director's takes the path to Godot 4.5 or newer) instead of `bash tools/check.sh`. Two failed attempts stop the build, as in `build.md`.
  - **Records there:** the item is added, already done, to that repo's root `TASKS.md` with that repo's next ID, and the change gets a `CHANGELOG.md` entry. `project/TASKS.md` never receives it.
  - **Publish:** the builder builds and runs the gate; this session then commits on the bundle branch (one item, one commit) and runs `bash tools/work-publish.sh work/<repo>`, which pushes the branch and opens the bundle pull request the first time, or updates it. `gh pr edit` then keeps the title naming every item it carries and the body listing them, one line each with its source, until the release notes replace the body (Releases). A feature built in stages is one commit per stage on the same bundle. No pause for approval, even for a single task: the director's review and merge on GitHub is the gate (Q13). The agent never merges.
  - **Records here:** once its bundle pull requests are open, the item stays `in-progress` with a `- PRs:` line listing them, such as `Godot-Director #2 (open)`, shared by every item in that bundle, and it's done only when all of them are merged. An `in-progress` item with a `PRs:` line is waiting for review, not abandoned. The records here are committed without pausing; pushing this repo still waits until the director asks.
  - **Releases ride in the bundle:** once a run has built the items it can for a repo, it ends that repo's bundle with a release commit, so one merge takes the items and their release. It's a release item here (`Release <repo> <version>`, size S) that shares the bundle's `PRs:` line and adds no item to the repo's root `TASKS.md` (its CHANGELOG heading is the record), with these steps on the bundle branch:
    1. The version is the agent's proposal, covering everything in the bundle and merged since that repo's last release; the director can change it in review.
    2. Bump the version files that repo's `CLAUDE.md` lists (`VERSION` and `.claude-plugin/plugin.json`; in SaaSAllTheThings also every skill's version and `--branch v<version>` line), and turn `## Unreleased` in `CHANGELOG.md` into the version heading.
    3. Run its selftest (Godot-Director's without the Godot path: the release commit changes only version files, links and notes, and each item before it passed the full run), then commit with the release notes as the commit message body. They follow that repo's `CLAUDE.md` (a "How to install" section in all three; SaaSAllTheThings also "What's new" and "How to upgrade"); the previous release's notes show the layout.
    4. Publish with `bash tools/work-publish.sh work/<repo>`, then make the release notes the pull request's description with `gh pr edit --body-file`: `tools/work-release.sh` publishes that description as the release notes. The director decides the items and the release by merging or closing the bundle.
    5. An item added to a bundle that already ends with its release commit puts its CHANGELOG entry under that version heading, since the version isn't published yet, and the release notes in the description are updated to match.
    6. Once the bundle is merged, `bash tools/work-release.sh work/<repo> <pr>` tags the merge commit `v<version>` and publishes the GitHub release. Its items and the release item are then done, and an item here moves the docs links and the pin in `frameworks.lock` to the new tag and updates the pages for what the release ships. Until then the selftest warns and stays green.
  - **Pull request status first:** before picking, `/next-task` checks every listed pull request with `gh pr view <n> -R Freakling/<repo>` and updates its `PRs:` line. Merged: its items are done. Closed without a merge: bring it to the director. An open bundle blocks nothing: new items for that repo go on its branch. An item whose `Depends on` names an item in the same open bundle is built on that branch after it; any other dependency that isn't done makes it wait.
  - **After a merge:** the merged bundle's items are done, and that repo's next item starts a new bundle from the latest `origin/main`. There are no other open item branches to bring up to date.
- The blog explains why, the docs explain how: pages link to the saemundsson.se post that introduced the idea. Never change a WordPress post from this project.
