# Tasks

Milestones, the work queue and bugs: the only place work is tracked. Item format: `.app-director/tasks.md`. Queue order is priority; reorder by moving items. Pruning moves done items to `TASKS-archive.md`.

**Next IDs:** T70 · B5

## Milestones
| Milestone | Status |
|---|---|
| Foundation: site builds, selftest and check passing, CI running | ✅ |
| Live: the site is published on GitHub Pages | ✅ |
| Acceptance: all core flows verified on the live site | ⬜ |
| Concepts: one page per core concept | ✅ |
| Skills: one page per common skill | ✅ |
| Polish: identity, licence and offline-safe check | ✅ |
| Orchestrator: anchors, framework items built here and published as pull requests, releases, audit | 🟨 |

✅ done · 🟨 in progress · ⬜ not started

## Queue

### T61 · Release Godot-Director 3.7.0 · done · S · agent
- PRs: Godot-Director #6 (merged); released as v3.7.0
- Depends on: T51
- Touches: work/Godot-Director: VERSION, .claude-plugin/plugin.json, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T42 (the research assistant), is merged, and `tools/work-release.sh` has tagged `v3.7.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.7.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T62 · Release App-Director 1.5.0 · done · S · agent
- PRs: App-Director #13 (merged); released as v1.5.0
- Depends on: T51, T64, T65
- Touches: work/App-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T57, T39 and T65, is merged, and `tools/work-release.sh` has tagged `v1.5.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v1.5.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T67 · Release Godot-Director 3.8.0 · done · S · agent
- PRs: Godot-Director #9 (merged); released as v3.8.0
- Depends on: T51, T64, T65
- Touches: work/Godot-Director: the version files its CLAUDE.md lists, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T39 and T65, is merged, and `tools/work-release.sh` has tagged `v3.8.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v3.8.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T66 · Docs follow Godot-Director 3.7.0 · done · S · agent
- Depends on: T61
- Touches: docs/frameworks/godot-director.md, docs/skills/*.md
- Done when: every link into Godot-Director points at v3.7.0 (check) · the Godot-Director page lists `/research` among what's unique to it, linking to the procedure, until T34 gives it a skill page once all three ship it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T68 · SaaSAllTheThings' manual install takes the latest release · done · XS · agent
- PRs: SaaSAllTheThings #8 (merged)
- Depends on: T39
- Touches: work/SaaSAllTheThings: README.md (one pull request; the director merges)
- Done when: the manual install option in SaaSAllTheThings' README clones the latest release tag instead of main, worded as App-Director #12 and Godot-Director #8 do, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T63 · Release SaaSAllTheThings 0.8.0 · done · S · agent
- PRs: SaaSAllTheThings #9 (merged); released as v0.8.0
- Depends on: T51, T39, T64, T68
- Touches: work/SaaSAllTheThings: VERSION, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, skills/*/SKILL.md, CHANGELOG.md (one pull request; the director merges)
- Done when: the release pull request, which covers T43 (the research assistant), T39 and T68, is merged, and `tools/work-release.sh` has tagged `v0.8.0` and published the GitHub release, following AGENTS.md › Project rules › Framework work › Releases (check) · an item here moves the docs links to `v0.8.0` and updates the pages for what it ships (check)
- Brief: Scope › Planned framework changes

### T64 · The release step checks every file that carries the version · done · S · agent
- Depends on: T39
- Touches: tools/work-release.sh
- Done when: for each framework, `tools/work-release.sh` checks every file its release rule lists as carrying the version (after T39: App-Director's package.json, both SKILL.md files with their --branch, the fetch script's tag and the marketplace ref; Godot-Director's skill version and --branch and the marketplace ref; SaaSAllTheThings' marketplace ref), and refuses a release where one disagrees (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Planned framework changes

### T65 · Manual installs clone the latest release · done · XS · agent
- PRs: App-Director #12 (merged), Godot-Director #8 (merged)
- Depends on: T39
- Touches: work/App-Director: README.md; work/Godot-Director: README.md (one pull request per repo; the director merges)
- Done when: the manual install option in App-Director's and Godot-Director's READMEs clones the latest release tag instead of main, as SaaSAllTheThings' does if it does, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T39 · The framework repos install the latest release · done · M · agent
- PRs: App-Director #11 (merged), Godot-Director #7 (merged), SaaSAllTheThings #7 (merged)
- Depends on: T40
- Touches: work/App-Director: SKILL.md, skills/app-director/SKILL.md, package.json, scripts/fetch-app-director.sh, .claude-plugin/marketplace.json, CLAUDE.md, README.md, selftest.sh; work/Godot-Director: skills/godot-director/SKILL.md, .claude-plugin/marketplace.json, CLAUDE.md, README.md, selftest.sh; work/SaaSAllTheThings: .claude-plugin/marketplace.json (one pull request per repo; the director merges)
- Done when: App-Director and Godot-Director each have a merged pull request that makes the skill, the fetch script and, where the marketplace can pin a ref, the plugin install the latest release tag, and that tags every release `v<version>`, with Godot-Director's `skills/godot-director/SKILL.md` `metadata.version` (3.3.0) and App-Director's root `SKILL.md` and `package.json` versions (1.0.0) kept in step with VERSION, following AGENTS.md › Project rules for framework work (check) · SaaSAllTheThings' plugin follows the release tag, with a pull request if it needs a change (check)
- Brief: Scope › Planned framework changes

### T69 · Docs follow App-Director 1.5.0, Godot-Director 3.8.0 and SaaSAllTheThings 0.8.0 · done · S · agent
- Depends on: T62, T67, T63
- Touches: docs/frameworks/*.md, docs/skills/*.md, docs/index.md
- Done when: every link into the three frameworks points at its latest release (check) · the pages describe what these releases changed where they state the old behaviour: the skills, plugins and manual installs take the latest release, and SaaSAllTheThings' page lists `/research` until T34 gives it a skill page (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T33 · App-Director: the research assistant · in-progress 2026-10-15 · M · agent
- PRs: App-Director #14 (open)
- Depends on: T32, T40
- Touches: work/App-Director (one pull request; the director merges)
- Done when: App-Director has a merged pull request that builds the research assistant from `product/anchors/research.md`, with its domain file (stacks, libraries and app-store requirements), an `R<n>` counter on its `Next IDs` line, and the new files in its README, install script, skills folder and selftest, following AGENTS.md › Project rules for framework work (check)
- Brief: Scope › Planned framework changes

### T34 · The Research skill page · todo · S · agent
- Depends on: T33, T42, T43
- Touches: docs/skills/research.md (new), docs/skills/index.md, mkdocs.yml, docs/concept/design-calls.md
- Done when: once all three frameworks have released the research assistant, the page describes the shared behaviour and what is unique per repo, matching the released procedures (check) · Design calls links to it (check) · `bash tools/check.sh` passes (check)
- Brief: Scope › Common skills

### T19 · Godot-Director: export onboarding and /export · todo · M · agent
- Depends on: T40
- Touches: work/Godot-Director (one pull request; the director merges); docs/frameworks/godot-director.md once released
- Done when: Godot-Director has a merged pull request whose onboarding asks for missing export settings (target platforms) and where exports run (local, a build container, or hosted CI such as GitHub Actions); when the step is skipped, onboarding adds a GDD open question on both and a setup item that depends on it, so `/design Q<n>` runs the step later and `/next-task` builds it; and that adds an `/export` skill, following AGENTS.md › Project rules for framework work (check) · once released there, the Godot-Director page documents them (check)
- Brief: Scope › Planned framework changes

### T31 · Godot-Director: CI export and CD release · todo · M · agent
- Depends on: T19
- Touches: work/Godot-Director (one pull request; the director merges); docs/frameworks/godot-director.md and a /release skill page once released
- Done when: Godot-Director has a merged pull request with CI that runs the export on every change, and CD that releases builds to a platform's UAT branch with optional promotion to production, following AGENTS.md › Project rules for framework work (check) · once released there, the Godot-Director page documents them and /release gets its own skill page (check)
- Brief: Scope › Planned framework changes

## Notes
- T55, T54 and T56 are released as SaaSAllTheThings v0.7.0, Godot-Director v3.6.0 and App-Director v1.4.0.
- T34 waits until all three frameworks have released the research assistant.
- App-Director v1.5.0, Godot-Director v3.8.0 and SaaSAllTheThings v0.8.0 are released; T69 brings the docs up to them. T33 waits on App-Director #14.
- T31 follows T19.
