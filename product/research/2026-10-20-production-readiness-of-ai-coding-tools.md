# Do other AI coding tools stop at working, or address production readiness, and what can DDD claim?
R5 · Informs: - · Verified as of 2026-10-20 · Size: M

## Question and assumptions
Question: is the distinction "others help you make something that works; DDD aims at enterprise-ready, structured, automatically tested software you can prove is stable, testable and compliant" real? Covers what the R4 alternatives ship for production readiness, what independent evidence says about AI code in production, what "compliant" would mean, and which parts of the framing DDD can claim.

Assumptions:
- Pages were read through a fetch tool that summarises them. "Not on the page" means not found there, not that the product lacks it.
- "Enforced" means a check, status or hook can fail or block. "Advised" means a suggestion, comment or instruction the model or reader may ignore.
- DDD's side comes from its docs and the blog post. The framework repos were not re-audited and no run was made.
- "Compliant" is read as: meets the customer's security framework or a regulation, with evidence a reviewer can use. This is technical guidance, not legal advice.

## Conclusion
The distinction is partly real, but "others stop at working" is too strong. Every major vendor now ships review and security scanning, and some gate (Copilot cloud agent runs CodeQL, secret scanning and dependency checks by default, and cannot approve or merge its own PR). What none of the pages read ships is DDD's package: architecture rules inside the done-check, an excuse path that exists only as an accepted decision record, and requirements anchored in the customer's own security framework. Independent evidence says AI code carries more defects and security flaws (Veracode 45 percent, CodeRabbit 1.7 times issues, DORA instability), which supports gating. But nothing independent shows that DDD output is more stable or compliant. DDD can claim what its checks enforce and what its records show. It cannot claim "provably stable" or "compliant" without a production record and an audit. Confidence: medium to high on vendor facts, medium on "none ship the package" (overview pages only), high that DDD has no independent measurement.

## 1. What the alternatives ship for production readiness
| Tool | Gating tests | Security scanning | Architecture rules | Decision audit trail | Release and operations | Compliance claim | Source |
|---|---|---|---|---|---|---|---|
| GitHub Copilot cloud agent | Runs tests and linters in its environment; Actions workflows do not run until a human clicks "Approve and run workflows" (enforced) | CodeQL, secret scanning, dependency check against the Advisory Database, on by default, can be disabled per tool (enforced as findings, configurable) | Rulesets and branch protection apply; an incompatible ruleset blocks the agent (enforced) | Session log shows analysis and actions; docs say logs "do not replace your own review" | PR opened as draft; agent cannot mark ready, approve or merge; requester cannot approve (enforced) | Not on pages read | S1, S2 |
| Cursor Bugbot | Not a test gate | Reviews PRs for bugs and security issues; autofix optional | Team and project rules in BUGBOT.md (advised: rules guide reviews) | None found | Check defaults to `neutral` on findings; blocks only if "fail on unresolved issues" is enabled; config read from base branch | Says same privacy compliance as Cursor; no certifications named | S3 |
| Claude Code | Hooks can fail a turn (user-written) | `/security-review` on demand; security guidance plugin | Managed settings, permissions, `ConfigChange` hooks (enforced if configured) | Audit logging for cloud sessions; OpenTelemetry usage metrics | Sandbox, push restrictions through branch rules | Anthropic org: SOC 2 Type 2, ISO 27001 via Trust Center. Docs: "You're responsible for reviewing proposed code" | S4 |
| OpenAI Codex | Not on page read | Codex Security (research preview) scans code and reports evidence | Not on page read | Not on page read | Sandbox and approvals are on a separate page, not read | None on page read | S5 |
| Devin | Tests and linters per guide | Devin Review scans every review for security issues with CWE and severity, cannot be turned off | Not on page read | Not on page read | Posts a CI status check; merge-blocking depends on your branch protection; ACU and per-PR spend limits on Enterprise | Trust center lists SOC 2 Type 2, ISO 27001:2022, CCPA; scope per product not stated | S6, S7 |
| Kiro | Hooks can run tests or lint on save; `PreToolUse` can block tools (enforced if set up); property-based tests (R4) | Not on hooks page | Specs and steering (advised) | Spec files (requirements, design, tasks) | Not on page read | Not read | S8, R4 |
| spec-kit | Constitution Article III: tests first, user approves, must fail (advised; no tool verifies it) | None | Phase -1 gates are checkboxes; a failed gate needs a "Complexity Tracking" entry (prompted) | Spec, plan and tasks files | None | None | S9 |
| BMAD | Described without mechanism (R4) | Not found | Not found | Durable decisions as context | None | None | R4 |
| Amazon Q Developer scanning | Not read: the docs page returned no content, so nothing is claimed | | | | | | gap |

Reading: the strongest enforced items are GitHub's (workflow approval, no self-approval, default scanning) and organisation-level (rulesets, managed settings). Vendor compliance claims (SOC 2, ISO 27001) cover the vendor's service, not the software built with it. Every vendor page read puts review of the output with the user.

DDD for comparison (own records): `check.sh` with exit 0/1/3 and a pre-commit hook; SaaSAllTheThings architecture rules (layers, domain purity, tenant source, tenant branching, secrets, file sizes, message versions, cost SKUs); ADR exceptions as the only way past a rule; requirements and control framework in `compliance/`; hooks asking before an ADR is accepted. These are enforced in the check. The framework's own post says it does not make a product compliant, and that people do.

## 2. Independent evidence on AI-generated code in production
| Study | Sample and method | Finding | Tier |
|---|---|---|---|
| Veracode GenAI Code Security Report 2025 | Over 100 LLMs; task count and method not stated on the page read | Risky security flaws in 45 percent of tests; larger, newer models did not improve security | 4 (vendor, method not seen) |
| CodeRabbit, State of AI vs human code | 470 open-source PRs: 320 AI co-authored, 150 human-only; authorship inferred | 10.83 vs 6.45 issues per PR (about 1.7 times); security issues up to 2.74 times; logic errors about 75 percent more | 3, vendor, small, inferred labels |
| GitClear 2025 | 211 million changed lines, 2020 to 2024, big-company repos | Cloned lines 8.3 to 12.3 percent of changed lines (2021 to 2024); refactoring share 25 to under 10 percent; the "4x clones" headline's baseline was not clear | 3, vendor |
| DORA (Impact of GenAI report, updated 2026-04-13) | Survey-based | A 25 percent rise in AI adoption goes with about 1.5 percent less throughput and 7.2 percent less delivery stability; larger batches suspected; recommends stronger automated testing, fast review, CI | 3 |
| Siddiq et al., AIDev security PRs (arXiv 2601.00477) | 1,293 security-related PRs found among over 33,000 agent PRs | Studies acceptance and review latency; figures not opened beyond the abstract summary | 3 |
| AIDev security smells (arXiv 2607.12428) | 4,022 agent PRs, 16,112 file changes, LLM judge plus manual check | 38.9 percent of agent PRs have at least one security smell; hard-coded credentials 99.6 percent of critical smells; review missed 81.1 percent of those credentials; humans introduced 67.6 percent of genuine leaked secrets in these workflows | 3, preprint |
| Perry et al., "Do users write more insecure code with AI assistants?" (arXiv 2211.03622) | User study, participant count not on page; codex-davinci-002 | Assistant users wrote significantly less secure code and were more confident in it | 3, dated model |
| From R2 (cite only) | Faros 2026: bugs per PR plus 28.7 percent, incidents per PR plus 242.7 percent; He et al.: static warnings plus 30.3 percent, complexity plus 41.6 percent; AIDev: agent PRs accepted less often; Uplevel: bugs plus 41 percent (secondary) | Same direction | 3 and 4 |

Not found: any revert-rate or time-to-revert measure (the AIDev follow-ups surfaced do not report reverts). Apiiro's study could not be opened (HTTP 403), so it is not used.

Reading: the direction is consistent (more defects, more security flaws, more review load), the samples are mostly vendor-run, and the effect sizes differ widely by method. The AIDev result that review missed most leaked credentials supports automated, deterministic checks over human review alone, which is what the secrets rule does. It does not show that any specific tool's gate works.

## 3. Assessment of the framing
| Phrase | Can DDD claim it? | Basis, or what is missing |
|---|---|---|
| Structured | Yes | Roles, records, task sizes, one home per fact (own docs) |
| Automatically tested | Yes, within each framework's check | `check.sh` runs build and tests; the pre-commit hook blocks a failing commit; exit 3 never reads as pass (check.md) |
| Enterprise-ready | Only as "built for" | Architecture is enterprise-shaped (Entra ID, multi-tenancy, Bicep, ADRs). No enterprise has run it in production per the records read |
| Architecture rules enforced | Yes for SaaSAllTheThings | Nine named rules in the check; ADR exception is the only excuse. Others can write hooks, so "enforced, not suggested" should say "in the check the framework ships" (as R4 found) |
| Anchored in the customer's security framework | Yes as process, partial as mapping | Requirements in `compliance/` are read by architecture sessions. The post says compliance judgement is not pattern-matching and falls to the director. No rule is traced to a named control |
| Audit trail of decisions | Yes | ADRs, `decisions.md`, `TASKS.md`, one approved item per commit. This is traceability of decisions, not requirement-to-test traceability, which was not found in either DDD or the vendors |
| Provably stable | No | No production deployment data, no independent quality measurement. The check proves rules and setup; a person proves behaviour (check.md) |
| Testable | Yes | Tests and rules run on every task |
| Compliant | No | No audit performed; the post itself says the framework does not make a product compliant |

What binding guidance says: NIST SP 800-218A (July 2024) extends the SSDF for generative AI model development, and the page read does not say it covers code produced by AI tools. EU AI Act Article 15 applies to high-risk AI systems themselves, not to software merely built with AI tools. So no regulation read requires a particular gate on AI-written code; a customer's control framework and its auditor decide what evidence counts. ISO 42001 and financial-regulator notes were not opened. Confirm with the people who own legal, risk and security.

Wording that holds:
- "A check that fails the build when architecture or security requirements are broken, with exceptions only through a decision record you accept."
- "Requirements and your control framework live in the repository, and every architecture session reads them."
- "Every decision and every change leaves a record you can show a reviewer."
- "Built for enterprise SaaS on Azure; the framework helps you produce the evidence, and people own compliance."

Wording that would not hold: "provably stable", "compliant", "production-ready", "others stop at working", "unlike other tools, tests gate" (Copilot and Claude hooks also gate).

## 4. Options for the message and recommendation
| Option | Means | Risk |
|---|---|---|
| A. Keep the director's framing | "Others make it work; DDD makes it enterprise-ready and provable" | Overclaims; invites a counterexample (Copilot's gates, vendor SOC 2); "provable" and "compliant" are unsupported |
| B. Reframe as enforcement plus evidence | "AI tools generate and review; DDD makes the architecture and security requirements part of done, and leaves records a reviewer can read" | Holds on the records. Needs the SaaSAllTheThings anchor shown, and an honest "people own compliance" |
| C. Say less, say it later | Make no production claim until there is a production run or an audit | Safe; loses the strongest differentiator |
| D. Earn the claim | Commission an audit by a third party or a measured project (defect, rework, incident rates against a baseline) | Costs time and money; the only route to "provably stable" |

Recommendation: B now, D as the path to anything stronger. Lead with what the check enforces and what the records give a reviewer, cite the independent findings (Veracode 45 percent, CodeRabbit 1.7 times, DORA stability) as the reason a gate matters, and state the limit in one plain sentence. Pair it with a builder item that traces each SaaSAllTheThings rule to a named control in a common control framework (labelled partial or interpretive), since that would turn the anchoring from description into mapping. This would change if a customer deployment or an audit produces evidence, or if a fuller read of Kiro, Codex approvals and Amazon Q finds enforced architecture rules.

## Sources
| Claim | Source | Type | Tier | Confidence |
|---|---|---|---|---|
| DDD check, exit codes, rules, ADR exception, hooks, what a person proves | docs/concept/check.md; docs/frameworks/saasallthethings.md; docs/frameworks/index.md (read 2026-10-20) | Project records | 1 | High |
| Anchoring approach; "framework does not make a product compliant"; no independent testing cited; audit trail is the repo | Blog post "Anchoring AI-built SaaS in your security framework", saemundsson.se, 2026-10-13 | Author's description | 4 | High for what it says, none for efficacy |
| R4 matrix and "alone" list; R2 quality findings | product/research/2026-10-20-ddd-compared-with-other-ai-coding-workflows.md and 2026-10-19-external-numbers-ai-coding-output.md | Project notes | 1 | Medium to high |
| S1 Copilot agent: rulesets block agent, tests and linters, code review, "do not replace your own review" | GitHub Docs, About Copilot cloud agent | Official docs | 2 | High |
| S2 CodeQL, secret scanning, dependency checks default; workflow approval; draft PR, no self-approval | GitHub Docs, Risks and mitigations for Copilot cloud agent | Official docs | 2 | High |
| S3 Bugbot: neutral by default, fail-on-unresolved option, rules, privacy statement | cursor.com/docs/bugbot | Official docs | 2 | High |
| S4 Claude Code: SOC 2 Type 2, ISO 27001 via Trust Center; audit logging in cloud; `/security-review`; user responsibility | code.claude.com/docs/en/security | Official docs | 2 | High |
| S5 Codex Security research preview; no compliance claim on that page | learn.chatgpt.com/docs/security | Official docs | 2 | Medium (approvals page not read) |
| S6 Devin Review security scan, status check, Enterprise limits, no compliance statement | docs.devin.ai/work-with-devin/devin-review | Official docs | 2 | High |
| S7 Cognition trust centre lists SOC 2 Type 2, ISO 27001:2022, CCPA; scope not stated | trust.cognition.ai | Vendor | 2 | Medium |
| S8 Kiro hooks and PreToolUse blocking | kiro.dev/docs/hooks | Official docs | 2 | Medium |
| S9 spec-kit Article III and checkbox gates; no automated verifier | github/spec-kit spec-driven.md | Official repo | 2 | Medium (fetch summary) |
| Veracode 45 percent, 100+ LLMs, bigger models no better | veracode.com 2025 GenAI Code Security Report page | Vendor | 4 | Medium (method not on page) |
| CodeRabbit 470 PRs, 10.83 vs 6.45, 2.74 times, 75 percent | coderabbit.ai State of AI vs Human Code report | Vendor study | 3 | Medium |
| GitClear 211M lines, clones 8.3 to 12.3 percent, refactor 25 to under 10 percent | gitclear.com AI code quality 2025 research | Vendor study | 3 | Medium |
| DORA 25 percent adoption, minus 1.5 throughput, minus 7.2 stability | dora.dev/ai/gen-ai-report | Research report | 3 | Medium (report page; the 2025 report named in the item was not the page returned) |
| AIDev security smells 38.9 percent etc. | arXiv 2607.12428 abstract | Preprint | 3 | Medium |
| AIDev security PRs 1,293 of over 33,000 | arXiv 2601.00477 (via search result) | Preprint | 3 | Low to medium (abstract not opened) |
| Perry et al. less secure and more confident | arXiv 2211.03622 | Preprint | 3 | High (old model, n not seen) |
| NIST SP 800-218A scope | csrc.nist.gov SP 800-218A final, 2024-07-26 | Standard | 1 or 2 | Medium (AI-code coverage unconfirmed) |
| EU AI Act Art. 15 scope | artificialintelligenceact.eu/article/15 | Reproduced regulation | 2 | Medium |

Contradicting evidence: DORA's page says AI adoption is associated with lower stability, while the 2025 DORA text (cited in R2) found throughput positive and instability still rising; the two pages differ on throughput. Not accessible: Apiiro (403), Amazon Q docs (empty), Codex approvals page.

## Open gaps
- Apiiro study, Amazon Q scanning, Snyk and Semgrep AI-code marketing, Kiro steering, Codex approvals and enterprise pages were not read. Any could add an enforced item to the table.
- No revert rate or time-to-revert study found. Effect: rework evidence rests on GitClear churn and Faros.
- ISO 42001, financial-regulator guidance and the full NIST text were not opened. Effect: "what compliant means" stays a customer-and-auditor question.
- No tool found offering requirement-to-test traceability; absence in pages read only.
- Veracode's method, and the exact DORA 2025 report, were not opened. Treat the headline figures as vendor claims.
- A builder item could map each SaaSAllTheThings rule to a named control and test the rules on a sample app. That would turn a claim into evidence; this note ran no code.
