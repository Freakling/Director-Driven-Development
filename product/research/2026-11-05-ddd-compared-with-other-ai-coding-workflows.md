# How the alternatives to DDD compare on twelve dimensions, and who brings each one
R7 · Informs: - · Verified as of 2026-11-05 · Size: M

## Question and assumptions
Question as asked: as of 5 November 2026, what do the alternatives to Director-Driven Development (DDD) ship or prescribe on twelve dimensions, and which cells of the 20 October matrix (R4) have changed?

Assumptions:
- Every vendor page was read through a fetch tool that summarises it. "Not found" means not on the pages read.
- A cell shows the strongest member of its group.
- For rows 1 to 9 only what could plausibly have moved was re-read. A cell marked "= R4" had no contradicting evidence on the pages read, but was not re-read in full.
- A vendor's own SOC 2 or ISO 27001 certificate for its service is not counted in row 12.
- DDD's column comes from the framework releases of the same day: App-Director 1.14.1, Godot-Director 4.10.1, SaaSAllTheThings 0.16.1.

## Conclusion
Most of R4's matrix holds. On the new rows, only the Copilot cloud agent ships enforced defaults among the tools: CodeQL, secret scanning and dependency checks, plus an approval gate before workflows run. No tool asks which security framework or regulation applies, and no tool has a checked mapping from controls to tests. Roo Code was shut down on 15 May 2026 and leaves the comparison. Nothing among the tools newly offers the five items R4 listed as found only in DDD; the skill and workflow packages are a separate question, in `2026-11-05-ddd-compared-with-skill-and-workflow-packages.md`, and they change that list. Confidence is medium to high on what the pages say and medium on "not found".

## The matrix the blog post publishes
The director corrected the comparison while the post was reworked, and the published graphic differs from a plain update of R4 in three ways.
- **DDD is a workflow, not an AI service.** A service's own features, such as spending caps, don't count against it. The Cost row is what a way of working does about cost, so the research's two "Enforced" cost cells (Claude Code's budget caps, Copilot's 59-minute limit) are not used.
- **The question is who brings it.** A cell comes with the default flow when the way of working takes you there without you having to know to ask. It is yours to set up when you have to know to pick it, turn it on or write it, which includes a vendor guide you must go and read and a skill you must choose from a menu. These ratings are a reading of the evidence below and of the packages note, not new vendor reading.
- **The groups changed.** Harnesses merge into "An agent on its own". Spec-driven workflows join the packages as "Whole workflows", and skill collections get their own column.

E = comes with the default flow, enforced by a check or hook. G = comes with the default flow, as a step or template. Y = yours to set up. N = not found on the pages read.

| Row | DDD | An agent on its own | Skill menus | Whole workflows | Delegated agents |
|---|---|---|---|---|---|
| Who decides, who builds | G | Y | Y | G | E |
| Small context per task | G | Y | Y | G | Y |
| A check that defines done | E | Y | Y | G | Y |
| Records and a decision log | G | Y | Y | G | Y |
| Sizing and model choice | G | Y | Y | G | N |
| Independent review | G | Y | Y | G | E |
| Failure and drift handling | G | Y | Y | G | N |
| Ownership and protected areas | E | Y | Y | G | Y |
| Cost | G | Y | Y | G | Y |
| Security standards as defaults | E | G | Y | E | E |
| Delivery guidance | G | Y | Y | G | E |
| Compliance standards offered | G | N | N | Y | N |

The DDD column shows its strongest framework. The OWASP baseline and `/security` are in App-Director and SaaSAllTheThings, not Godot-Director. The compliance questions and the mapping table are in SaaSAllTheThings only. Delivery differs per framework: SaaSAllTheThings' reference and check workflow template, Godot-Director's release workflow template, App-Director's lock-file checks in its OWASP checklist. "Who decides" stays guidance although SaaSAllTheThings has a hook that asks before writing "accepted"; the rating is deliberately conservative.

## Evidence by group
Ratings here are the researcher's, on R4's scale: Enforced (a check or hook can fail the run), Described (docs or process only), Not found. Source keys are in Sources.

| Dimension | Plain agents | Spec-driven | Harnesses | Autonomous |
|---|---|---|---|---|
| 1 Who decides, who builds | Enforced. Claude Code deny rules, managed settings and sandbox are "deterministic" (S1). = R4 | Described. spec-kit and Kiro: human reviews each phase (S14, S12). = R4 | Enforced. Cline Plan mode "cannot modify any files or execute commands" (S20). = R4 | Enforced. Copilot cloud agent cannot mark ready, approve or merge (S6). = R4 |
| 2 Small context | Described. Interview, SPEC.md, "start a fresh session" (S1). = R4 | Described. Osmani: small chunks (S17). = R4 | Described. Cline `/deep-planning` (S20). = R4 | Described. Devin guide: scoped tasks (S26). = R4 |
| 3 Check that defines done | Enforced. A `Stop` hook exits 2 and the turn doesn't end until the check passes (S1). = R4 | Described. spec-kit converge; Kiro hooks can run lint or type checks (S14, S13). = R4 | Enforced. Aider `--auto-test` (S19). = R4 | Enforced. Copilot workflows wait for human approval; a ruleset can block the agent (S6, S5). = R4 |
| 4 Records and decision log | Described. CLAUDE.md, AGENTS.md (S1, S7). = R4 | Described. Kiro requirements, design and tasks files (S12). = R4 | Described. `.clinerules` or AGENTS.md (S29). No decision log. = R4 | Described. Jules AGENTS.md (S27); Devin skills (S26). = R4 |
| 5 Sizing and model choice | Described. Claude Code model order; no size scale (S3). = R4 | Described. Osmani switches model when stuck (S17). = R4 | Described. Cline: separate models for Plan and Act (S20). = R4 | Not found (S26, S27, S5). = R4 |
| 6 Independent review | Described. Fresh read-only reviewer subagent (S1). = R4 | Described. Osmani: a second session or model critiques (S17). = R4 | Not found. OpenHands `--llm-approve` is an action approver (S22). = R4 | Enforced. Copilot: a human must review and merge (S6). Devin Review is not automatic (S25). = R4 |
| 7 Drift handling | Described. `/clear` after two failed corrections; `/rewind` (S1). = R4 | Described. Kiro Analyze Requirements; `/speckit.analyze` (S12, S15). = R4 | Not found. Cline checkpoints are rollback (S20). = R4 | Not found. = R4 |
| 8 Ownership and protected areas | Enforced. Hooks, deny rules, managed settings; Cursor enforced Team Rules (S1, S2, S7). = R4 | Described. Kiro `PreToolUse` hooks can block tools (S13). Changed from Not found | Not found among current members. R4's rating rested on Roo, which is shut down (S23) | Enforced. A ruleset can block Copilot (S5). = R4 |
| 9 Cost | Enforced in the research, for `--max-budget-usd` and spending limits (S1); not used in the matrix, see above. Otherwise Described as in R4 | Not found. = R4 | Described. Cline cheaper model for Act (S20). = R4 | Enforced in the research, for Copilot's 59-minute limit and Devin's per-PR spend limit (S5, S25); not used in the matrix. Otherwise Described as in R4 |
| 10 Security standards as defaults | Described. Cursor Bugbot on by default when GitHub is connected, findings `neutral` (S8). `/security-review` on demand (S2). No named standard | Described. spec-kit constitution can carry security boundaries (S15) | Not found (S19, S20, S21) | Enforced, medium confidence. Copilot cloud agent runs CodeQL, secret scanning and an advisory check by default; "you can optionally disable" them (S6). Whether a finding fails the run isn't stated |
| 11 Delivery guidance | Described. Claude Code ships workflow templates, OIDC, "protect `main`" (S4, S1) | Described. spec-kit organisational standards; Osmani wants CI (S15, S17) | Not found (S19, S20, S21, S22) | Enforced. Copilot: "Approve and run workflows", draft PRs (S6) |
| 12 Compliance standards offered | Not found. Vendor certificates only (S2); Cursor mentions "internal compliance workflows" (S7) | Described. spec-kit presets "can enforce organizational or regulatory standards" (S14, S15). No question asked | Not found | Not found as a user feature |

## Ten statements from the post, checked
1. Changed. The Claude guide covers a verify step, but its first section is telling Claude what it can't see and its second is giving it a check. It recommends a fresh read-only reviewer that "hasn't seen how the code was written"; "adversarial" is not its word for that. Its contrast is non-deterministic instructions against deterministic hooks, deny rules and managed settings.
2. Holds with a caveat. Hooks, `/sandbox`, cloud sessions, `claude -w` worktrees, agent teams (experimental), `/batch`, `/goal`, an auto-mode classifier and `/rewind` all exist. Checkpoints cover only files edited with Claude's own tools.
3. Changed. Devin Review includes a security scan in each review it runs, through auto-review rules or a trigger, so "every pull request" overstates it. The docs describe no switch to disable the scan.
4. Holds. Aider `--auto-test` (S19).
5. Holds. AGENTS.md is read by Cursor, Codex and Jules, and also Copilot (S7, S10, S27, S28).
6. Holds; drop Roo. Cline and Osmani have no size scale or retry rule.
7. Holds with one wording change. BMAD describes "multiple-agent discussions", not "multi-role sessions".
8. Holds except "ephemeral", which could not be verified. Copilot now describes cloud sandboxes (S5).
9. Holds. Cursor Team Rules, Copilot instructions and rulesets.
10. Changed. Several vendors say in writing that the user reviews the output (Claude Code, Copilot, Cursor). Not verified for the others. The certificates that could be read are for the vendor's service.

## Changes since R4
- Roo Code: "The Roo Code Extension was shut down on May 15th"; the repository is archived (S23, S24).
- Gemini CLI: free and Google AI Pro/Ultra access moved to Antigravity CLI on 18 June 2026; the repository now targets Code Assist (S11).
- OpenHands: the CLI "is no longer actively maintained" (S21, S22).
- Codex docs moved to learn.chatgpt.com (S9, S10). Copilot is now "Copilot cloud agent" (S5).
- Ownership, spec-driven: Not found to Described. Ownership, harnesses: Enforced to Not found.

## Corrections made while the post was reworked
- R4 said DDD's enforcement "covers only those three domains". That is wrong. App-Director has a "None / other" stack: the built-in checks run and `tools/check.local.sh` adds the rest, as this repository does with `stack = none`. Its workflow works on anything kept in git and checked with a script.
- Checkpoints are not something others do better. Every decision and task is a commit, going back is done with git, and anything that discards work or rewrites history needs the human.
- Spending limits, reach across tools and sandboxes are maturity or service features, so the post doesn't count them as leads.
- CodeRabbit's "1.6 times the security issues" (1.57 in secondary coverage) is replaced in the post by the primary page's "up to 2.74 times".

## Sources
All opened on 2026-11-05 through a summarising fetch tool unless marked. Tier 2 unless noted.
- S1 Best practices for Claude Code: https://code.claude.com/docs/en/best-practices
- S2 Claude Code security: https://code.claude.com/docs/en/security
- S3 Agent teams: https://code.claude.com/docs/en/agent-teams
- S4 Claude Code GitHub Actions: https://code.claude.com/docs/en/github-actions
- S5 About Copilot cloud agent: https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent
- S6 Copilot cloud agent risks and mitigations: https://docs.github.com/en/copilot/concepts/agents/coding-agent/risks-and-mitigations
- S7 Cursor rules: https://cursor.com/docs/context/rules
- S8 Cursor Bugbot: https://cursor.com/docs/bugbot
- S9 Codex security: https://learn.chatgpt.com/docs/security
- S10 Codex AGENTS.md: https://learn.chatgpt.com/docs/agent-configuration/agents-md
- S11 Gemini CLI repository: https://github.com/google-gemini/gemini-cli
- S12 Kiro specs: https://kiro.dev/docs/specs/
- S13 Kiro hooks: https://kiro.dev/docs/hooks/
- S14 spec-kit README: https://github.com/github/spec-kit
- S15 spec-kit spec-driven.md: https://github.com/github/spec-kit/blob/main/spec-driven.md
- S16 BMAD-METHOD: https://github.com/bmad-code-org/BMAD-METHOD
- S17 Osmani, 2026-01-04 (tier 4): https://addyosmani.com/blog/ai-coding-workflow/
- S18 Reed, 2025-02-16 (tier 4): https://harper.blog/2025/02/16/my-llm-codegen-workflow-atm/
- S19 Aider lint and test: https://aider.chat/docs/usage/lint-test.html
- S20 Cline plan and act: https://docs.cline.bot/features/plan-and-act
- S21 OpenHands docs: https://docs.openhands.dev/
- S22 OpenHands CLI reference: https://docs.openhands.dev/openhands/usage/cli/command-reference
- S23 Roo Code repository (archived): https://github.com/RooCodeInc/Roo-Code
- S24 Roo Code docs (moved): https://roocodeinc.github.io/Roo-Code/
- S25 Devin Review: https://docs.devin.ai/work-with-devin/devin-review
- S26 Instructing Devin: https://docs.devin.ai/essential-guidelines/instructing-devin-effectively
- S27 Jules: https://jules.google/docs
- S28 Copilot repository instructions: https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions
- S29 Cline rules, from a search result only (tier 5): https://docs.cline.bot/features/cline-rules

DDD's column: `.app-director/state/frameworks/` at the three releases named above.

## Open gaps
- Not opened: Antigravity CLI; Gemini CLI sandbox and checkpointing; Copilot IDE agent mode and code review; Codex approvals and Codex cloud; Cline checkpoints, enterprise and rules pages; OpenHands PR-review and skills; Kiro steering; Devin pricing; Cognition's trust centre; Claude Code's `/security-review` pages; Cursor Security Reviewer. Any of these could move a cell.
- Rows marked "= R4" were not each re-read in full.
- Whether Copilot's default scans fail a run is not stated, so its security cell is medium confidence.
- No run was made. Nothing here tests whether a default scan or gate behaves as documented.
