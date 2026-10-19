# What do AI coding agents cost per unit of work when teams use them without a workflow?
R3 · Informs: - · Verified as of 2026-10-19 · Size: M

## Question and assumptions
Question: for teams using AI coding agents freeform, which published figures join spend (dollars or tokens) to output (merged changes, tasks, features, PRs) per developer or per unit of work, and does any source separate structured workflows from freeform use? Scope: real projects, 2024 to 2026, not benchmarks. R1 and R2 are not repeated; R2 holds Anthropic's $13 per active day, Cursor's token mix, Faros, the Insight blog, the Unblocked illustration and benchmark cost tables.

Assumptions:
- "Freeform" is not a label any source uses. Telemetry vendors do not record whether a team follows a workflow, so their populations are treated as mostly unspecified. That is a reading, not a finding.
- Every dollar figure below is an API list-price estimate unless a source says it is billed. It is said row by row.
- Per-unit figures marked "division" are arithmetic on a source's totals.
- Fortune, The Information and Bloomberg were not opened. Press-reported items carry that label.

## Conclusion
- **One source joins spend to merged PRs across many developers: Jellyfish** (Q1 2026, 12,000 developers, about 7,500 joined to PR data). Its cost per merged PR runs from $0.28 in the lowest tier to $89.32 in the highest, with about 10 times the tokens for about 2 times the PRs at the top. It is vendor telemetry, correlational, priced at list rates, and the tier boundaries are undefined. No audited or billed cost per merged PR from an enterprise was found. (Confidence: medium.)
- **R1's per-item and per-commit costs sit at the cheap end of everything found**, but only one external figure uses a comparable unit (cost per commit, one developer: $35.71 against R1's $1.31 to $2.66). R1's cost per calendar day ($48 to $84) is above LinearB's 90th percentile ($35.20 per coding day) and Anthropic's. Per-PR figures cannot be set against R1's one-commit items. (Confidence: medium.)
- **No source compares structured and freeform use on cost or output.** Correlational hints exist (Jellyfish context-file investment and supervision level, an AGENTS.md replay study), none with a workflow label and cost together. (Confidence: high that none was found.)
- What would change this: a billed (not list-price) spend series joined to merged PRs, or any with-and-without workflow comparison.

## What joins spend to output
| Source (owner, date) | Sample | Metric and definition | Figure | Spend basis | Tier |
|---|---|---|---|---|---|
| Jellyfish, "Is tokenmaxxing cost effective?" (Apr 15, 2026) | 12,000 developers, 200 companies, Q1 2026; about 7,500 joined to PRs | Estimated monthly token cost; merged PRs per quarter; cost per merged PR | Median $52.38 a month, p75 $226.58, p90 $691.14. Bottom 20 percent: about $3 for the quarter and 11 merged PRs. Top 20 percent: $1,822 and 23 merged PRs. Cost per merged PR $0.28 (lowest tier) to $89.32 (highest). PRs per week 0.77 to 2.15. Tokens per PR about 7M (median), about 69M (top decile) | API list-price estimate | 3, vendor |
| Jellyfish, State of AI in Software Engineering H1 2026 (undated, assets June 2026) | Spend trend Aug 2025 to May 2026 | Spend per user per month | Typical company's median user rose from about $5 to $81; mean $248 in May 2026; p99 $2,452; cache reads 96 percent of all tokens | Not stated, probably list | 3, vendor |
| Jellyfish AI engineering trends (Sept 2026) | 294K engineers, 105M PRs, 1,300+ companies | Spend per developer | Top users $949 a month; no median; no cost per PR | Not stated | 3, vendor |
| LinearB, AI engineering productivity gap (2026) | 2.7M PRs, 83,000 developers, 253 orgs, Feb to May 2026 | Token cost per developer; agent-PR merge rate | p90 $481 a month or $35.20 per coding day; tiers $481 / $152 / $50. Top 10 percent of orgs: 79 percent of agent-opened PRs merge in 30 days (92 percent human-only); top 60 percent: 37 percent | Method not described | 3, vendor |
| Peng, Lin, Lee, arXiv 2607.13080 (Jul 2026) | One developer, production monorepo, two 28-day periods | API cost, tokens, commits | Opus 4.7/4.8 via Claude Code: $8,785.21, 15.33B tokens, 31,901 requests, 246 non-merge commits (113 fixes), cache hit 99.3 percent, $0.573 per M tokens. Division: $35.71 per commit, $314 per day. Cache reads were 87 percent of dollars | "Realized API cost"; whether billed is unconfirmed | 3, preprint, n = 1 |
| Anthropic, Carlini (Feb 5, 2026) | 16 parallel agents, about 2 weeks, one Rust C compiler | API cost, sessions, output | About 2,000 sessions, just under $20,000, 2B input and 140M output tokens, about 100,000 lines. Division: about $10 per session, $0.20 per line | API | 2, vendor, research stunt |
| Zest, claude-code-pricing page (Oct 2026) | One engineer, Sep 4 to Oct 3, 2026, 318 sessions | Cost per merged PR | 601 merged PRs, $26,072 at list price, $43 per PR; the engineer is on Max 20x, so "not what was billed" | List price | 4, vendor anecdote |
| Gartner via Computer Weekly and The Register (Jun 24, 2026) | Peer Insights, size not stated | Token spend per developer | 23 percent of tech leaders at $200 to $500 a month; 6 percent of organisations above $2,000 | Reported | 4, secondary |
| DX Q2 2026 | 500+ organisations | Organisation AI spend | Median quarterly spend from about $1.5K to about $44K in four quarters; no per-developer or per-output figure | Not stated | 4 |
| Uber (Bloomberg via Outlook Business, Jun 3, 2026) | About 5,000 engineers (other outlets) | Budget and cap | Full-year budget gone in four months; $1,500 a month cap; 95 percent monthly use; 10 percent of code from agents. No per-engineer cost or output in that article | Reported | 5 to 4, press |
| Microsoft Research, arXiv 2607.01418 (Jul 2026) | Tens of thousands of engineers, four months | Merged PRs per engineer per day | About 24 percent more; no cost in the abstract; quality "open" | None | 3 |

Output with no spend, for context: Cursor with University of Chicago (Nov 2025): merged-PR rate plus 39 percent, "tens of thousands" of users, revert rate unchanged. Watanabe et al. (arXiv 2509.14745): 567 Claude Code PRs in 157 open-source projects, 83.8 percent merged, 54.9 percent of merged PRs without further changes. Cognition, Devin 2025 review: merge rate 67 percent (34 percent a year earlier), "2x more efficient in resource consumption" with no unit, customer figures (for example 10 times faster per ETL file) with no sample or dollars. Nubank's "8x time, 20x cost" appears only in secondary summaries and conflicts with another (50 engineers, one third of the timeline), so it is unused. Amazon's 4,500 developer-years is savings, not spend. Stripe's 1,000 to 1,300 merged PRs a week from "Minions" has no cost in what was retrieved (secondary). GitHub's docs say one premium request per cloud agent session, with no cost per PR published. Amp, Replit and Factory publish no per-task averages. Faros calls work restarts (up 66.7 percent) "the biggest source of duplicated AI spend" but does not quantify it.

## Structured versus freeform
No source reports cost or output for a named structured workflow against freeform use. The nearest:
- **Jellyfish, 134,911 developers, 670 companies, May 2026:** each doubling of context-file investment (CLAUDE.md, Cursor rules) goes with about 29 percent more PRs per developer per week. Correlational, and more context means more input tokens. In the longest sessions, runs under 30 percent human intervention produced about 11 times the net lines of heavily supervised runs. That is lines, not PRs, and not a workflow label.
- **Lulla et al., arXiv 2601.20404:** 10 repositories, 124 PRs; with AGENTS.md, median runtime fell 28.64 percent and output tokens 16.58 percent. A replay of merged PRs, not live work.
- **ETH Zurich, arXiv 2602.11988 (abstract seen only in search results):** LLM-generated context files lowered task success and raised cost by over 20 percent; human-written ones helped. It is a 138-task benchmark, so it is context, not evidence for this scope.
- **Peng et al. above:** both periods used spec-driven development, so the paper cannot isolate it.
- **Gartner** (secondary coverage; the release returned 403) says costs outpace gains "without a governed engineering operating model". That is a forecast, not a measurement.
- Searches for spec-driven or vibe-coding cost and rework studies found practitioner guides and design papers only (arXiv 2609.00252 is conceptual).

## Placing R1's figures
| R1 figure | External | Comparable? |
|---|---|---|
| $2.30 to $3.04 per done item; $1.31 to $2.66 per commit | Peng: $35.71 per commit (one developer, SDD). Jellyfish: $0.28 to $89.32 per merged PR. Zest: $43 per PR | Peng's commit is the only like unit: R1 is 13 to 27 times lower; its output per commit is 82K tokens against R1's 6.5K to 12.5K (division), so the commits differ in size. PR figures cannot be compared: R1's items are one-commit by design. Say "inside Jellyfish's range" and no more. |
| $48 to $84 per calendar day | LinearB p90 $35.20 per coding day; Anthropic $13 average per active day (R2); Peng $314 per day | R1 is above the p90 values and well under Peng. Calendar days (R1) differ from "coding days" (LinearB), so R1 per active day is higher still. |
| About $1,440 (DDD) and $1,790 (Lantern) per 30 days, extrapolated | Jellyfish p90 $691, p99 $2,452; Gartner $200 to $500 typical, 6 percent above $2,000; Zest $26,072 | Between Jellyfish's p90 and p99. R1 is API-equivalent on a Max plan, as Zest's anecdote is; the others are list estimates of API or seat spend. |
| $0.31 to $0.64 per million tokens | Peng $0.573 | Yes, same range, caching dominant in both. |
| 93 to 96 percent of tokens as cache reads | Jellyfish 96 percent; Peng hit rate 99.3 percent | Yes. Peng's cache reads are 87 percent of dollars against R1's 32 to 52 percent, a pricing and session-length difference not explained here. |
| $25 to $75 per hour at the keyboard | None | No. Nothing uses attended hours. |
| 142 items in 9 days; 330 commits | Jellyfish at most 2.15 PRs per week; Microsoft plus 24 percent | No. Different units, no baseline in R1. |

## Options and trade-offs
| Option | Means | Risk |
|---|---|---|
| A. Cite no cost-per-unit comparison | Keep R1 plus R2 | Leaves R1's cost looking unanchored |
| B. Anchor on spend per developer and token structure | Place R1 beside Jellyfish and LinearB percentiles, Peng's $ per M tokens and cache share, and Anthropic's per-day figure, naming each as list-price or API-equivalent | Low; needs the caveat each time |
| C. Quote cost per PR or per commit as a baseline | "Our items cost less than $43 per PR" | High: units differ, tiers undefined, Peng's n = 1, and R1 items are small by design |

## Recommendation
Option B. State R1's per-day and per-30-day cost against the published percentiles, and say R1 is API-equivalent on a subscription while the others are list-price estimates. Quote Jellyfish's range only to show that cost per merged PR is unsettled ("$0.28 to $89 in one 12,000-developer dataset"). Say that no published study separates structured from freeform use on cost or output, which leaves a with-and-without measurement as the open evidence. A builder item could extend the transcript script (R1 follow-up) to print cost per day, per commit and output tokens per commit, so the Peng comparison can be repeated. It would change if a source gives billed spend with merged PRs, or a workflow A/B appears.

## Sources
| Claim | Source (owner, date, link) | Type | Tier | Confidence |
|---|---|---|---|---|
| Median $52.38, p90 $691.14; 11 vs 23 PRs; $0.28 and $89.32; 0.77 to 2.15 PRs a week; list-price estimate | Jellyfish blog, Arcolano, 2026-04-15, jellyfish.co/blog/is-tokenmaxxing-cost-effective-new-data-from-jellyfish-explains/ | Vendor telemetry | 3 | Medium: tiers undefined; $1,822 / 23 = $79, not $89.32, so the tiers differ; one Jellyfish post gives $0.26 to about $25 for deciles (search snippet only) |
| Median user $5 to $81; mean $248; p99 $2,452; cache reads 96 percent; context investment (134,911 developers); under-30-percent intervention runs 11 times the lines | Jellyfish, State of AI in Software Engineering H1 2026, jellyfish.co/state-of-ai-software-engineering/ | Vendor report | 3 | Medium: undated; "11 PRs per million" wording inconsistent; unused here |
| Top users $949 a month; 294K engineers, 105M PRs | jellyfish.co/ai-engineering-trends/, Sept 2026 | Vendor report | 3 | Medium |
| p90 $481 a month, $35.20 per coding day; 37 and 79 percent agent-PR merge | LinearB, linearb.io/resources/ai-engineering-productivity-gap, 2026 | Vendor report | 3 | Medium: method not described; its $864 to $613 per PR example is modelled, unused |
| Peng et al. figures and SDD in both periods | arXiv 2607.13080 (abstract and HTML, first 100K characters read), Jul 2026 | Preprint | 3 | Medium: n = 1; last 37K characters unread; "realized" cost basis unclear; per-commit division ours |
| Compiler: 2,000 sessions, about $20,000, 2B in and 140M out, 100K lines | anthropic.com/engineering/building-c-compiler, 2026-02-05 | Vendor engineering post | 2 | High; token counts' cache treatment not stated |
| 601 PRs, $26,072, $43, Max 20x | meetzest.com/for/claude-code-pricing/ | Vendor page | 4 | Low: one engineer, vendor-priced |
| Gartner 23 percent / 6 percent | letsdatascience.com summary of Computer Weekly and The Register; Jellyfish library page repeats it; gartner.com release returned 403 | Secondary | 4 | Low to medium |
| DX median org spend $1.5K to $44K | newsletter.getdx.com/p/the-state-of-ai-impact-in-engineering | Vendor newsletter | 4 | Medium (excerpt) |
| Uber cap and budget | outlookbusiness.com, 2026-06-03, relaying Bloomberg | Press | 4 | Medium: second-hand |
| Microsoft plus 24 percent | arXiv 2607.01418 abstract | Preprint | 3 | High (abstract only) |
| Cursor plus 39 percent, revert unchanged | cursor.com/blog/productivity, 2025-11-11 | Vendor | 3 | Medium: denominator undefined |
| 83.8 / 54.9 percent | arXiv 2509.14745 | Preprint | 3 | High |
| 28.64 / 16.58 percent | arXiv 2601.20404 abstract | Preprint | 3 | High |
| Context files raise cost over 20 percent | arXiv 2602.11988 abstract via search result | Preprint | 3 | Low: not opened |
| Devin 67 vs 34 percent; 2x resource; no dollars | cognition.com/blog/devin-annual-performance-review-2025 | Vendor | 4 | Medium; merge rate undefined |
| Premium request per cloud agent session | docs.github.com Copilot premium requests page | Official docs | 2 | Medium: billing moved to usage-based in 2026 per press |
| Rejections overstate agent error (11,048 closed PRs) | arXiv 2605.22534 | Preprint | 3 | Medium; no cost |
| Faros "work restarts" | faros.ai/blog/the-most-expensive-number-in-our-new-ai-engineering-report | Vendor | 4 | Medium |
| Gartner governance quote | letsdatascience.com | Secondary | 5 | Low |

## Open gaps
- **Billed spend with output:** none found. Every spend-to-output figure is a list-price estimate or a vendor's own pricing.
- **Jellyfish primary tables:** only the blog and report text were read; tier boundaries, the pricing formula and the PR attribution are unstated, and the 7,548 versus 12,000 sample counts differ.
- **Gartner:** the release was blocked (403); numbers come from coverage with no sample size.
- **Peng et al. last 37K characters:** unread. Whether their spend was billed is unconfirmed.
- **Anthropic and Cursor enterprise customer stories, Google, Amazon Kiro, Factory, Sourcegraph, Replit:** no published cost joined to output found. Cursor's Coinbase and Upwork figures were seen only in secondary summaries and are unused.
- **FinOps Foundation State of FinOps 2026:** only secondary summaries; nothing on coding agents' spend per developer.
- **Stripe Minions, Microsoft and Uber per-engineer costs, DX $128,000 a week anecdote, Microsoft "60 trillion tokens":** secondary or unconfirmed and unused.
- **Structured versus freeform:** no cost-bearing comparison exists in what was found. The conclusion holds unless one is published in a venue these searches missed.
