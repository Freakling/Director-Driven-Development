# How skill and workflow packages compare with DDD's three frameworks, in packaging and guidance
R8 · Informs: - · Verified as of 2026-11-05 · Size: M

## Question and assumptions
Question as asked: how do published skill, agent and workflow packages for AI coding agents compare with App-Director 1.14.1, SaaSAllTheThings 0.16.1 and Godot-Director 4.10.1 in how they are packaged and how they guide a developer? R4 did not cover this category, so its "found nowhere else" list was untested against it.

Assumptions:
- Pages were read through a fetch tool that summarises them. "Not found" means not on the pages read, not that the package lacks it.
- DDD was judged by the researcher from its READMEs. The orchestrating session confirmed the two-attempt stop and the workspace hook from the rules and hooks of App-Director and Godot-Director.
- GSD's original repository is archived and points to `open-gsd/gsd-core`, which is treated as the current GSD.
- Spec Kit and Kiro were not re-read; the evidence for them comes from R4 and R7.

## Conclusion
R4's "found nowhere else" list does not hold as worded. Superpowers documents a model-per-role rule with an escalation tier and a cap of five fix rounds. Matt Pocock's `retro` turns failures into proposed checks. Compound Engineering writes learnings that later plans read. gstack has a `/cso` audit with an OWASP phase. GSD has a security gate on by default, tied to an OWASP ASVS level. BMAD has a place for security and compliance requirements.

Still not found in any package on the pages read:
- Dated research notes with sources, confidence and a verified-as-of date.
- A human-only drift reset beside a routine alignment pass.
- A placeholder ownership table with a hook that keeps the agent out of the human's workspace.
- Architecture rules inside the build check with an accepted decision record as the only exception (SaaSAllTheThings).
- Asking which security framework and regulations apply, with a mapping table seeded with a baseline (SaaSAllTheThings).

"Missing from the market" is false as a general claim, and the blog post doesn't make it. Many packages add real value, and several guide a developer well. The view that packages aren't built to guide is true for menus (Pocock's skills, gstack) and false for whole workflows (Superpowers, GSD, BMAD). Confidence: medium. No package was run, and no user evidence exists on whether DDD's guidance is better for a non-expert.

## Packages
| Package | Repository | What it is | Install |
|---|---|---|---|
| Matt Pocock's skills | github.com/mattpocock/skills | About 25 composable skills | Plugin, or `npx skills@latest add mattpocock/skills`, then a setup skill per repo |
| Sandcastle | github.com/mattpocock/sandcastle | TypeScript library for agents in isolated sandboxes. Infrastructure, not guidance | Not on the page read |
| Superpowers | github.com/obra/superpowers | A methodology: a staged workflow with about 20 skills, "mandatory workflows" | Per harness, about 15 |
| Compound Engineering | github.com/EveryInc/compound-engineering-plugin | 37 skills. Brainstorm, plan, work, review, compound; `/lfg` runs it hands-off | Plugin marketplace; 14 hosts |
| GSD | github.com/open-gsd/gsd-core | Discuss, plan, execute, verify, ship | `npx @opengsd/gsd-core@latest` |
| gstack | github.com/garrytan/gstack | About 23 role skills in a sprint order | Git clone, `./setup`, needs Bun |
| OpenSpec | github.com/Fission-AI/OpenSpec | Spec-driven change workflow | npm, script or Homebrew |
| BMAD-METHOD | github.com/bmad-code-org/BMAD-METHOD | Agile multi-perspective method | `npx bmad-method install` |

## Rating the two groups
Default-flow rule. Enforced: it comes with the default flow, and a check or hook can fail or block the run without the developer setting it up. Guidance: it comes with the default flow, as a step, template or instruction. Yours: the package gives you the means, but you have to know to pick it, combine it, turn it on or write it. Not found: on the pages read.

Menus are Pocock's skills and gstack. Workflows are Superpowers, GSD, Compound Engineering, OpenSpec, BMAD, spec-kit and Kiro. A menu skill counts as Yours however good it is, so that column follows largely from the rule.

| Row | Menus | Workflows |
|---|---|---|
| Who decides, who builds | Yours. `grilling` gives a recommended answer per round and "The _decisions_ are the user's" [PM-GR]; you invoke it | Guidance. Superpowers: "Recommend one and say why" [SP-BR]. BMAD: "alternatives weighed, then you choose" [B-arch] |
| Small context per task | Yours. Pocock `research` starts a background agent in a fresh context [PM-RS] | Guidance. GSD: "Each executor starts with a clean 200k-token context" [GSD-R] |
| A check that defines done | Yours. gstack `/ship` [GS-RM]; Pocock `tdd` and `setup-pre-commit` [PM-RM] | Guidance. Superpowers: "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE", no hook named [SP-VER]. GSD verifier on by default [GSD-CF]. No test failure shown blocking by default |
| Records and a decision log | Yours. `grill-with-docs` creates ADRs and a glossary [PM-GD]; `/office-hours` [GS-RM] | Guidance. BMAD architecture spine with decision IDs [B-arch]; CE `docs/solutions/` [CE-C]; GSD `STATE.md` [GSD-R] |
| Sizing and model choice | Yours, low confidence. gstack browse routes models inside one skill [GS-RM] | Guidance. Superpowers: "least powerful model that can handle each role" [SP-SDD]. GSD `model_profile` [GSD-CF] |
| Independent review | Yours. gstack `/autoplan`; Pocock `code-review` [GS-RM, PM-RM] | Guidance. Superpowers: "Never skip the task review" [SP-SDD]. CE and BMAD review don't block [CE-R, B-review] |
| Failure and drift handling | Yours. `retro`: "Default to building the check over writing the rule" [PM-RT] | Guidance. Superpowers: five-round cap with adjudication [SP-FL]. CE `/ce-compound` [CE-RM]. BMAD epic retro [B-epic]. No human-only drift reset |
| Ownership and protected areas | Yours. gstack `/freeze` and `/careful` are hooks you invoke [GS-FZ, GS-CA]; Pocock `git-guardrails` [PM-GG] | Guidance, medium. BMAD: "marking it done is yours" [B-review]. CE: "merge stays yours" [CE-L]. No ownership table |
| Cost | Yours, low confidence. `retro` keeps AGENTS.md to pointers [PM-RT] | Guidance. Superpowers model rule; GSD `budget` profile; BMAD on human attention [SP-SDD, GSD-C, B-build] |
| Security standards as defaults | Yours. `/cso` Phase 9 is OWASP Top 10 (2025) with ten ASVS 5.0.0 requirements [GS-AP], not in the sprint order [GS-RM] | Enforced, medium. GSD: `/gsd-ship` gate "blocks while `SECURITY.md` reports `threats_open > 0`", on by default [GSD-C, GSD-CF]; auditor takes an ASVS level [GSD-SA]. Not shown: whether `SECURITY.md` always exists |
| Delivery guidance | Yours. gstack `/ship`, `/land-and-deploy`, `/canary` [GS-RM] | Guidance. CE `/lfg` to PR and CI, no release step [CE-L]. GSD `/gsd-ship`, tag on milestone [GSD-C]. No deploy command found |
| Compliance standards offered | Not found. `/cso` avoids "legal-compliance conclusions" [GS-AP] | Yours. BMAD project context holds "security and compliance" policy [B-ctx]; OpenSpec `rules` free text [OS-CU]; spec-kit presets. None names a regulation for you |

## Claims in the post, checked
| Claim | Result |
|---|---|
| Superpowers picks a model per role, with an escalation tier and a cap | Confirmed. Rounds 4 and 5 use a more capable model; five rounds maximum [SP-SDD, SP-FL]. By role, not a written size scale |
| Pocock's `retro` turns a failed session into a proposed check | Confirmed. It presents candidates to the user [PM-RT]. The page says nothing is applied by the skill, not that the human applies it |
| `/ce-compound` writes learnings for the next plan | Confirmed for plan. The guide doesn't say brainstorm reads them; the README does [CE-C, CE-RM] |
| gstack's `/cso` covers the OWASP Top 10 | Confirmed. Not part of the default flow [GS-AP, GS-RM]. Whether a plain `/cso` runs Phase 9 is not confirmed |
| GSD has a security gate on by default | Confirmed [GSD-C, GSD-CF] |
| GSD runs parallel waves with fresh contexts | Confirmed [GSD-C, GSD-R] |
| gstack's `/qa` opens a real browser | Confirmed [GS-RM]. DDD's screen capture, playtesting and acceptance checks do the same job in another form |
| None asks which regulation applies | Holds on the pages read. A place for your own requirements exists in BMAD, OpenSpec and spec-kit as text you fill in. The unread part of GSD's `COMMANDS.md` could change this |

Default flow by package, for release, security and ownership:

| Package | Release | Security | Ownership |
|---|---|---|---|
| Pocock skills | `pr` skill not opened | Menu only | Guardrail hook is a menu item |
| gstack | Menu: `/ship`, `/land-and-deploy` | Menu: `/cso` | Menu hooks |
| Superpowers | Branch finish; "no release or deploy step" [SP-FIN] | Not found | No table |
| GSD | PR, and a tag on milestone [GSD-C] | Yes, on by default | Not found; workflow guard off by default |
| Compound Engineering | PR and CI only [CE-L] | Reviewer conditional on the diff [CE-R] | Merge stays yours |
| OpenSpec | Archive only | Not found | Not found |
| BMAD | Epic retro, no release step [B-epic] | No default lens [B-review] | You approve plan and done |

## Packaging and guidance
- Menus: Pocock's skills and gstack give excellent pieces; you need to know which to pick and how to combine them.
- Superpowers is a staged flow that guides well inside a feature. It has no project-level records beyond specs, and no release or security stage.
- GSD is the closest whole loop: onboarding, a first-project walkthrough, and security by default.
- BMAD is a whole method with `bmad-help`. OpenSpec covers a change rather than a project.
- DDD is a whole loop installed once, with onboarding, ownership, options with a recommendation, and a summary to approve. The cost is many commands and records to learn. It is built and tested on Claude Code.

Closest to DDD: GSD and Superpowers on loop shape, Compound Engineering on records that feed later sessions, BMAD as a whole method.

## How the blog post uses this
- It compares by group, not head to head, and credits packages by name.
- Reach across tools is left out: it is a maturity difference, not a difference in the workflow. Hands-off runs, testing and sandboxes are also left out as leads: DDD has unattended runs and test flows, and sandboxes belong to the agent layer.
- Parallel by default is stated as a design choice. DDD runs one task at a time by default and can run tasks in parallel when they don't overlap.

## Sources
All read on 2026-11-05. Tier 2 unless noted.
| Key | Page |
|---|---|
| SP-FL, SP-SDD, SP-BR, SP-VER, SP-TDD, SP-FIN, SP-RM | github.com/obra/superpowers: `skills/subagent-driven-development/references/fix-loop.md`, its `SKILL.md`, `skills/brainstorming`, `skills/verification-before-completion`, `skills/test-driven-development`, `skills/finishing-a-development-branch`, `README.md` |
| GSD-R, GSD-C, GSD-CF, GSD-SA | github.com/open-gsd/gsd-core: README, `docs/COMMANDS.md` (first 100k of 155k characters), `docs/CONFIGURATION.md` (first 100k of 207k), `agents/gsd-security-auditor.md` |
| CE-RM, CE-C, CE-L, CE-R | github.com/EveryInc/compound-engineering-plugin: `README.md`, `docs/guides/ce-compound.md`, `lfg.md`, `ce-code-review.md` |
| PM-RT, PM-GR, PM-RS, PM-WF, PM-TR, PM-GG, PM-GD, PM-RM | github.com/mattpocock/skills: `retro`, `grilling`, `research`, `wayfinder`, `triage`, `git-guardrails-claude-code`, `grill-with-docs`, `README.md` |
| GS-RM, GS-AP, GS-FZ, GS-CA | github.com/garrytan/gstack: `README.md`, `cso/sections/audit-phases.md`, `freeze/SKILL.md`, `careful/SKILL.md` |
| OS-ST, OS-CU | github.com/Fission-AI/OpenSpec: `docs/supported-tools.md`, `docs/customization.md` |
| B-* | docs.bmad-method.org: build a change, review a change, finish an epic, design UX and architecture, plan inside an organization, set and maintain project context |

## Open gaps
- Not opened: the last 55k characters of GSD's `COMMANDS.md` and its model profile table; CE's `ce-compound` skill file, review agents and a solutions template; Pocock's `pr`, `implement`, `to-spec`, `to-tickets`, `software-factory`, `setup-pre-commit`; gstack's hook scripts, `/benchmark`, `/review`; several BMAD pages; OpenSpec's verify and onboard docs. Any of these could move a cell.
- Kiro and spec-kit were not re-read here.
- Every cell is a documentation reading. No package was run.
- No user or adoption evidence shows whether DDD's guidance is better for a non-expert. A builder item could install two packages and run a small task to test it.
