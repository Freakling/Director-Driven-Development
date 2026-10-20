# How Director-Driven Development compares with other AI coding assistants and workflows
R4 · Informs: - · Verified as of 2026-10-20 · Size: M

## Question and assumptions
Question: on DDD's dimensions (who decides vs who builds, small context per task, a check that defines done, records with a decision log, task sizing and model choice, independent review, drift handling, ownership and protected areas, cost), what do the main alternatives ship or prescribe as of 2026, and where does DDD overlap, stand alone, or do less?

Assumptions:
- "Alternatives" means the groups named in the item: official docs and the vendors' own guides, plus two practitioner write-ups (Osmani, Reed).
- Each page was read through a fetch tool that summarises it, so a "not mentioned" finding means "not on that page", not "the product lacks it".
- Pages not in the fetched text (Copilot spec-driven docs, Devin pricing, OpenHands task guidance, Aider architect mode, Gemini CLI sandbox) are treated as unknown, not absent.
- "Prompted" means the rule is text the model is asked to follow. "Checked" means a script or hook can fail the run.
- DDD's column comes from its own records; the framework repos were not re-audited.

## Conclusion
DDD's separate ideas are mostly common practice in 2026: a spec before code, small tasks, fresh contexts, subagent review, instruction files, and a runnable check. What was found nowhere else, in the pages read, is the combination as one enforced system: a role split with a protected director workspace, a size-to-model map with a one-step escalation and a two-attempt stop, an ownership table with placeholders, and a decision log with dated research notes that later sessions reuse. Others do more in sandboxing, parallel and cloud execution, IDE integration, property-based testing and machine-checked approvals. Confidence is medium to high on what each vendor documents, and medium on "alone", because overview pages were read, not every sub-page. A fuller read of Kiro steering, Copilot spec-driven docs and the BMAD docs site could change the "alone" list.

## Matrix: what each group ships or prescribes
| Dimension | DDD (own records) | Plain agent use (Claude Code, Cursor, Copilot, Codex, Gemini CLI) | Spec-driven (Kiro, spec-kit, BMAD, Osmani, Reed) | Harnesses (Aider, Cline, Roo, OpenHands) | Autonomous (Devin, Codex cloud, Jules, Copilot cloud agent) |
|---|---|---|---|---|---|
| Who decides vs builds | Director decides; orchestrator, builder, reviewer, researcher roles; a builder stops and reports a design question as blocked (roles.md, agent-flow.md) | You steer; plan mode splits exploring from editing (Claude Code guide) | Human reviews each phase; spec-kit says to review each result before continuing | Cline Plan mode cannot edit files; Roo Architect edits markdown only, Orchestrator has no tools and delegates | You give a task; Jules shows a plan to approve before changes; Copilot opens a PR you review |
| Small context per task | Orchestrator never reads code; builder reads only files named in `Touches`; about 20-line reports (agent-flow.md, code-shape.md) | The guide's core constraint is context filling; `/clear`, subagents, short CLAUDE.md | Reed: small chunks from a prompt plan; Osmani: one task at a time | Roo Orchestrator delegates subtasks; Cline suggests plan size by task size | Devin guide: split work into verifiable sub-tasks, one session each |
| Check that defines done | One `check.sh` per framework, exit 0/1/3, pre-commit hook blocks the commit (check.md) | Guide: "Give Claude a way to verify its work"; a Stop hook can block the turn until a check passes; `/goal` re-checks | Kiro marks tasks complete; spec-kit `converge` loops until it reports "Converged"; Reed: tests per step | Aider `--auto-test` re-runs tests after each edit and tries to fix failures | Devin: tests, linters, concrete pass conditions; Copilot: CI and your review |
| Records and decision log | `TASKS.md`, brief, append-only `decisions.md`, dated research notes, one home per fact (records.md) | CLAUDE.md, AGENTS.md, GEMINI.md, Cursor rules; memory files | Kiro requirements, design and tasks files; spec-kit constitution and spec files; Reed spec.md, prompt_plan.md, todo.md | Rules and instruction files; no decision log found | AGENTS.md (Jules, Codex), skills and playbooks (Devin) |
| Sizing and model choice | XS to XL, size picks model, escalate once, XL stops (sizing.md) | Claude subagents set `model` in frontmatter; Cursor and Codex let you pick a model | Osmani: pick a model per task and cross-check when stuck; BMAD scales process depth to the work | Cline: different model for Plan and Act; Roo: model per mode | Not found on pages read |
| Independent review | Fresh read-only reviewer for L, XL and risky M; ranked findings (reviews.md) | Guide: adversarial review by a fresh subagent, `/code-review`; Codex review rules in AGENTS.md | Osmani: treat output as untrusted, optional second model; BMAD names "reviewed implementation" without detail | Not found on pages read | Devin Review with Auto-Fix; Copilot code review |
| Drift handling | `/align` routine pass and director-only `/drift-reset` on its own branch (drift.md) | Guide: after two corrections, `/clear` and rewrite; prune CLAUDE.md | Kiro "Analyze Requirements" checks requirements for inconsistency before design; spec-kit analyze checks constitution compliance | Not found | Not found |
| Ownership and protected areas | Ownership table with placeholders; a hook blocks the agent writing to `director/` or framework files (ownership.md) | Hooks can block writes (guide example: block writes to migrations); permission rules and sandbox | Not found | Roo: per-mode tool groups and file permissions | Copilot: limited to one repo, branch rules can block it; Cursor Team Rules can be "enforced" |
| Cost | Sizing map, small contexts, two-attempt cap, tuning page (cost-built-in.md) | Guide: context is the resource; links to a costs page; status line | Not covered | Per-mode model choice | Devin: scope and checks save ACUs; Copilot session cap of 59 minutes |

## Reading: overlap, alone, others do more
Overlap (common practice now):
- Verification as the core loop. The Claude Code guide opens with it, and Devin and Aider say the same. DDD's check is the same idea with a fixed name and exit codes.
- Spec first, small tasks, fresh context. Osmani, Reed, Kiro, spec-kit and the Claude guide ("interview you, write SPEC.md, start a fresh session") all prescribe it.
- Instruction files. AGENTS.md is read by Cursor, Codex and Jules, so DDD's choice of AGENTS.md is mainstream.
- Subagent and fresh-context review, which the Claude guide recommends in nearly DDD's terms.
- Hooks for guarantees. The Claude guide says CLAUDE.md is advisory while hooks are deterministic. DDD relies on that same distinction.

Alone (not found on any page read):
- A recorded decision log tied to dated research notes with confidence and a "verified as of" date, reused by later sessions.
- Size-keyed model mapping with a one-step escalation and a two-attempt stop. Cline and Roo choose a model per mode, Osmani per task, but none ties it to a written size scale with a retry rule.
- A named drift-reset procedure that only the director can start, plus a routine align pass over records and code. Kiro and spec-kit check spec consistency, which is narrower.
- An ownership table with placeholders for human-owned assets, backed by a hook on the director's workspace.
- Rule checks inside the build check (UI cannot import the data layer, tenant id never read from a request) with an accepted decision record (ADR) as the only excuse. The Claude guide says to write such hooks yourself; spec-kit's gates are template checkboxes the model fills in.

Where others do more:
- Isolation and scale: sandboxing and OS-level isolation, cloud runs, parallel worktrees, agent teams, `/batch` fan-out (Claude guide); Copilot's ephemeral cloud environment; Jules's VM.
- Autonomous loops with an evaluator (`/goal`) and a permissions classifier (auto mode).
- Spec depth: Kiro's wave-based parallel task execution and property-based testing (IDE only), spec-kit's presets and extensions, BMAD's multi-role discussions and scale-adaptive depth.
- Team enforcement: Cursor Team Rules with "Enforce this rule"; Copilot organisation instructions and rulesets.
- Rewind: checkpoints that restore conversation and code (Claude Code, Cline).
- Tool reach: IDE integration, MCP servers, plugin marketplaces. DDD ships as skills and hooks in Markdown and shell, with no IDE surface.
- Human acceptance rounds exist in DDD (`/playtest`, `/acceptance`) and the alternatives have equivalents in kind: Devin and the Claude guide also ask for screenshots and running-app checks.

## Closest in spirit, and the enforcement difference
- Closest: spec-driven and records-based methods. Kiro (three spec files), spec-kit (constitution, spec, plan, tasks, implement, converge), BMAD (durable decisions as context, scale-adaptive phases), and Reed's spec.md, prompt_plan.md and todo.md.
- Enforcement: in what was read, these are prompted. spec-kit's page says gates are checkboxes in templates the LLM fills in; the only stated human block is Article III's user approval of tests. BMAD's page describes no enforcement mechanism. Kiro's page did not describe how completion is verified beyond task status. Spec-kit offers extension hooks and quality-gate extensions, so enforcement is possible but optional.
- DDD differs by making the check and hooks the arbiter. The Claude Code guide itself draws the same line (advisory instructions vs deterministic hooks), so DDD builds on vendor-endorsed ground, not against it.
- Practical gap: the others are tool-neutral or tool-native. DDD's enforcement ships per framework (Godot, App, SaaS), so it covers only those three domains.

## Options and trade-offs
| Option | Benefit | Cost and risk |
|---|---|---|
| A. Docs comparison page | Answers "why not just Claude Code or spec-kit?" in one place; stays within "docs explain how" if framed as what DDD adds | Rots fast; vendor claims need re-checking; the site is latest only; naming competitors invites accuracy disputes |
| B. Blog post | The blog is where "why" lives and dated posts age gracefully; can carry the nuance (common practice vs alone) | Does not help docs readers; needs the same fact-checking |
| C. Nothing | No upkeep | The existing concept page already claims "established practice" plus four additions, with no evidence behind it |
| D. Small docs addition | Extend "What the frameworks add" on docs/concept/index.md with a line linking the Claude Code best-practices guide for the shared ideas | Minimal; does not compare tools |

## Recommendation
Option B, with D as a cheap companion: a dated blog post framed as "which ideas are common now and which DDD adds", using this note's overlap, alone and more split, and a link from the concept page's "What the frameworks add" section. The comparison is time-sensitive (vendors ship monthly), and the blog is dated while the site is latest only. The four existing claims on that page hold up against the evidence, except that "rules are enforced, not suggested" should be read as "in the check and hooks the frameworks ship", since the Claude guide shows a user can add hooks themselves. This would change if the director wants a standing docs page; then keep it to a table of dimensions with links, no feature lists per vendor, and a review date.

## Sources
| Claim | Source | Type | Tier | Confidence |
|---|---|---|---|---|
| DDD roles, loop, check, sizing, reviews, records, drift, ownership, code shape | docs/concept/index.md, agent-flow.md, check.md, sizing.md, reviews.md, records.md, drift.md, ownership.md, code-shape.md (read 2026-10-20) | Project records | 1 | High |
| Verification as the key practice; Stop hook, `/goal`; plan mode; CLAUDE.md advisory vs hooks deterministic; subagents with `model`; writer and reviewer; adversarial review; worktrees, agent teams (experimental), `/batch`; auto mode; checkpoints; "after two corrections /clear" | "Best practices for Claude Code", Anthropic, https://code.claude.com/docs/en/best-practices (read 2026-10-20) | Official docs | 2 | High |
| Spec-kit commands incl. converge, constitution, extensions, presets, hooks | github/spec-kit README, https://github.com/github/spec-kit | Official repo | 2 | Medium (page names no artifacts) |
| Spec-kit gates are template checkboxes; Article III human approval; no automated blocking described | https://github.com/github/spec-kit/blob/main/spec-driven.md | Official repo | 2 | Medium (fetch summary, not a full read) |
| Kiro three spec files, waves, Analyze Requirements, property-based testing (IDE only) | https://kiro.dev/docs/specs/ | Official docs | 2 | Medium |
| BMAD phases, scale-adaptive, durable decisions; no enforcement described; v6.12 stable, v7 preview | https://github.com/bmad-code-org/BMAD-METHOD | Official repo | 2 | Medium |
| Cursor rule types, Team Rules enforcement, AGENTS.md support | https://cursor.com/docs/context/rules | Official docs | 2 | High |
| Copilot cloud agent: PR per task, one repo, 59-minute cap, hooks, custom agents | GitHub Docs, about-coding-agent | Official docs | 2 | High |
| Codex AGENTS.md layering, review rules section, 32 KiB default | https://learn.chatgpt.com/docs/agent-configuration/agents-md | Official docs | 2 | High |
| Jules plan approval, VM, reads AGENTS.md | https://jules.google/docs | Official docs | 2 | High |
| Devin scoping, verification, skills, playbooks, Devin Review Auto-Fix | https://docs.devin.ai/essential-guidelines/instructing-devin-effectively | Official docs | 2 | High |
| Cline Plan and Act, model per mode, checkpoints | https://docs.cline.bot/features/plan-and-act | Official docs | 2 | High |
| Roo modes, Orchestrator, tool groups, model per mode | https://roocodeinc.github.io/Roo-Code/basic-usage/using-modes | Official docs | 2 | High |
| Aider lint and auto-test with auto-fix | https://aider.chat/docs/usage/lint-test.html | Official docs | 2 | High |
| Gemini CLI GEMINI.md context files | https://google-gemini.github.io/gemini-cli/docs/cli/gemini-md.html | Official docs | 2 | High (only this feature) |
| OpenHands components (SDK, agent server, cloud, CLI, sandbox server) | https://docs.openhands.dev/ | Official docs | 2 | Medium |
| Osmani workflow (spec, small chunks, tests, review, model choice, commits) | https://addyosmani.com/blog/ai-coding-workflow/ | Practitioner | 4 | Medium |
| Reed workflow (spec.md, prompt_plan.md, todo.md, tests) | https://harper.blog/2025/02/16/my-llm-codegen-workflow-atm/ (2025-02-16) | Practitioner | 4 | Medium |

No contradicting sources found. The Claude guide partly contradicts the framing "enforcement is only in DDD", since it documents Stop hooks and write-blocking hooks.

## Open gaps
- Not read: Kiro steering and hooks pages, Copilot spec-driven or agent-mode IDE docs, Gemini CLI sandbox, checkpoint and approval pages, OpenHands task and skill guides, Aider architect mode, Cline rules and memory, Roo custom-mode file restrictions in detail, the BMAD docs site, Anthropic's agent-teams and subagent pages, Codex sandbox and approvals pages. Any could move an "alone" item to "overlap".
- Cost per vendor (ACU, credits, plans) was not collected; the cost row compares prescriptions only. Related cost evidence is in 2026-10-19-cost-of-working-this-way.md.
- No independent evidence (benchmarks, user studies) on whether checked beats prompted enforcement. That claim is a judgment from documentation only.
- Not covered: Windsurf, Amazon Q, JetBrains Junie, and other published methods beyond Osmani and Reed.
- A builder item could spot-check "alone" claims by installing spec-kit and Kiro and running a small task.
