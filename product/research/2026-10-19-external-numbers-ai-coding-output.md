# What large studies say AI-assisted coding produces, and per what unit
R2 · Informs: - · Verified as of 2026-10-19 · Size: M

## Question and assumptions
Question: what do randomised trials, industry surveys, vendor telemetry and benchmark cost tables measure as output and productivity, in what units, and what do they find, so that R1's figures can sit beside them without over-claiming. R1's figures: $2 to $3 API-equivalent per done item, $10 to $20 per attended hour, and 93 to 96 percent of tokens as cache reads.

Scope: public studies and datasets from 2023 to 2026. Vendor marketing without a method is excluded. Vendor studies with a stated method are included and labelled.

Assumptions:
- "Done item" in R1 is a small, one-commit unit. It is not a feature or a pull request.
- R1's dollars are API-equivalent value of subscription usage, not spend.
- Percent changes are as each source states them. METR's sign convention (negative means less time) is converted to plain words here.
- Secondary summaries are used only to find primaries, and are flagged where nothing better could be opened.

## Conclusion
- **The structural numbers can be placed beside external ones; the productivity numbers cannot.** R1's cache-read share matches what Cursor and an academic study of agent runs report. Its cost per day is far above Anthropic's published enterprise average. Its per-item and per-hour figures have no like-for-like external counterpart. (Confidence: medium.)
- **The output studies use different units.** They measure time on task, completed tasks or pull requests per developer, and pull request cycle time. Gains run from about 8 percent to 56 percent in controlled settings, with one trial of experienced developers finding 19 percent more time and later METR data too unreliable to use. Telemetry from vendors shows more output with more review load and defects. None pairs output with dollars on real projects. (Confidence: high that no rigorous public cost per merged change exists, as far as could be found.)
- **R1's "the figures describe, they don't compare" stance holds.** No external number gives a baseline for R1's throughput. Quality is unmeasured in R1, and the critical studies say that is where the cost of speed shows up.
- What would change this: a published study pairing token or dollar cost with merged, surviving changes on real projects, or an hours-based cost figure.

## What the studies measure, in what unit, and what they find
| Study (type) | Sample and task | Unit | Headline | Method tier |
|---|---|---|---|---|
| Peng et al. 2023 (RCT, GitHub and Microsoft Research) | 95 Upwork programmers, 45 treated, 50 control; write an HTTP server in JavaScript | Time to finish one task | 55.8 percent faster; 95 percent CI 21 to 89 percent; success rate difference not significant | 3 |
| Google RCT, ICSE 2025 | 96 Google engineers; one enterprise task, summer 2024 tools | Time on task | About 21 percent less time; wide CI | 3 |
| Cui et al. (three field experiments: Microsoft, Accenture, a Fortune 100) | 4,867 developers; ordinary work | Completed tasks per developer (exact measure definitions not opened) | Plus 26.08 percent, standard error 10.3; each experiment noisy | 3 |
| GitHub and Accenture (vendor study) | Developer count and duration not stated | Pull requests per developer, merge rate, successful builds | Plus 8.69 percent PRs, plus 15 percent merge rate, plus 84 percent builds | 3, vendor |
| METR 2025 (RCT) | 16 experienced open-source developers, 246 real tasks in their own mature repositories | Time to complete an issue | 19 percent more time (CI plus 2 to plus 39); developers had forecast 24 percent less and still believed 20 percent less afterwards | 3 |
| METR 2026 follow-up | 57 developers, 143 repositories, over 800 tasks | Time to complete | Returning developers 18 percent less time (CI minus 38 to plus 9), new 4 percent less (CI minus 15 to plus 9). METR calls this an unreliable signal: developers refused to work without AI and skipped tasks, pay fell from $150 to $50 an hour, and multi-agent work breaks time tracking. A 349-person survey found a median 1.4 to 2 times self-reported change in value of work | 3, withdrawn by authors |
| Anthropic internal study, Dec 2025 | 132 survey responses, 53 interviews, about 200,000 Claude Code transcripts, August 2025 | Self-reported gain; merged PRs per engineer per day | Self-reported gain 50 percent; merged PRs per engineer per day up 67 percent; 27 percent of Claude-assisted work "would not have been done otherwise" | 3, vendor, own staff |
| DORA 2025 | Nearly 5,000 professionals, survey | Perceived productivity; throughput and instability as team-level DORA measures | Throughput now positively linked to AI use, instability still rises; over 80 percent perceive higher productivity; median about 2 hours a day with AI | 3 (full methods not read) |
| Faros 2025 (vendor telemetry) | Over 10,000 developers, 1,255 teams, correlational | Per developer and per team | PRs merged plus 98 percent, review time plus 91, PR size plus 154, tasks plus 21, bugs per developer plus 9 | 3, vendor |
| Faros 2026 (vendor telemetry) | 22,000 developers, 4,000 teams, same organisations at low vs high adoption | Per developer and per PR | Tasks plus 33.7, PR merge rate plus 16.2, PR size plus 51, bugs per PR plus 28.7, median review time 5 times, incidents per PR plus 242.7, deployments per week minus 11.7 | 3, vendor |
| Jellyfish 2025 (vendor telemetry) | 259 companies, 21,209 engineers, 2.16 million merged PRs; Copilot users only | PR cycle time | 95.5 to 83.8 hours; no meaningful link to bug PRs | 3, vendor |
| Uplevel 2024 | About 800 developers (351 with Copilot, 434 without) | PR cycle time, throughput, bug rate | Cycle time down 1.7 minutes, no throughput gain, bug rate up 41 percent | 4 (secondary reports) |
| He et al., MSR 2026 | 806 Cursor repositories vs 1,380 matched controls | Lines added and commits per month | Lines added plus 28.6 percent overall, commits plus 2.6 (not significant); gains significant only in the first two months; static analysis warnings plus 30.3, complexity plus 41.6 | 3 |
| AIDev dataset | 456,000 agent PRs, 61,000 repositories, 5 agents | PR acceptance | Agent PRs are accepted less often than human PRs; agent PRs are simpler | 3 (percentages seen only in secondary summaries) |
| Anthropic Economic Index (Apr 2025; Jun 2026) | About 500,000 conversations (2025); a sampled slice and a 9,700-respondent survey (2026) | Share of conversations; autonomy score 1 to 5; tokens | Claude Code 79 percent automation vs 49 percent on Claude.ai; autonomy 0.37 points higher than chat. Reports no dollars, no task time, no productivity | 2 |

Reading across: controlled trials measure time per task and see 19 percent slower to 56 percent faster. Field experiments and telemetry measure counts per developer and see tens of percent more. The telemetry that also measures review, defects and churn finds those rising faster than output (Faros 2026, He et al., Uplevel mixed). Gains come from the lab-like and early-adopter setting. The one trial on experienced developers in familiar code found a slowdown, and its replication failed for selection reasons. DORA's reading is that AI amplifies the organisation it lands in.

## Cost and token units
| Source | Unit | Figure |
|---|---|---|
| Claude Code docs (Anthropic, enterprise deployments) | Dollars per developer per active day | Average about $13; $150 to $250 per developer per month; under $30 per active day for 90 percent of users |
| Aider polyglot leaderboard | Dollars per full run of 225 exercises | gpt-5 (high) 88.0 percent for $29.08, about $0.13 per exercise by division; o3-pro (high) $146.32 |
| Terminal-Bench 4.0 (Snorkel) | Total tokens and dollars per full run of 66 tasks, trials not stated | Opus 5.5 max with Claude Code: 8.0 billion tokens, $4.7k. Sonnet 5.5: 19.4 billion, $7.3k. Not per task |
| Bai et al. 2026 (arXiv 2604.22750) | Tokens per SWE-bench Verified instance (500 instances, 4 runs, 8 models, OpenHands) | Agentic tasks use about 1,000 times the tokens of chat; same task varies up to 30 times between runs; more tokens do not mean more accuracy; no dollars per task given |
| Insight (practitioner blog) | Dollars and minutes per merged feature | $3 to $33 and 26 to 176 minutes for one real feature, 23 arms, 29 runs, cost computed from tokens at published rates |
| Cursor via The Pragmatic Engineer | Share of tokens; lines per user per week | Cache read 90 percent, cache write 2.5, input 7, output 0.6; median user 700 lines a week, p90 about 9,000 |
| Anthropic Economic Index 2026 | Tokens per conversation | Geometric means; no dollars |

## Placing R1's figures
| R1 figure | Closest external | Can it be compared? |
|---|---|---|
| 96 to 97 percent of tokens as cache reads (29 to 51 percent of cost; R1 corrected 2026-10-19) | Cursor: 90 percent of tokens are cache reads, two years of aggregate data. Bai et al.: cache reads are the largest token category and largest cost share in every phase | Yes, for token share. Cursor publishes no cost shares, so only the token share lines up. Supports "agentic coding is mostly cache reads". |
| Blended cost per million tokens: DDD $0.34, PKSEI $0.72, Lantern $0.36 (division of R1's corrected totals) | Terminal-Bench 4.0 Claude Code runs: Opus 5.5 about $0.59, Sonnet 5.5 about $0.38 (division of its totals) | Same order of magnitude. The leaderboard does not say what its token count includes, so keep this at low confidence. |
| $2 to $3 per done item | Aider about $0.13 per exercise; Insight $3 to $33 per merged feature; an Artificial Analysis page (not opened) reportedly shows about $2 per benchmark task | Not ranked. Items here are one commit, cut small by design; a benchmark task or a feature is a different size. Say "same order as public per-task figures", nothing more. |
| $10 to $20 per attended hour | No study uses cost per hour. The nearest is Anthropic's $13 per active day average and under $30 for 90 percent | Different unit. R1's cost per calendar day is at least $40 (DDD, $364 over 9 days), $44 (Lantern) and $98 (PKSEI), so all three are above the 90th percentile of the enterprise figure. "Active day" is not defined, and R1 counts calendar days, so R1's per-active-day figure is at least those values. |
| 142 items in 9 days; 330 commits | Studies report plus 8.69 to plus 98 percent PRs, plus 67 percent merged PRs per engineer per day | No. R1 has no baseline, so no uplift can be stated. The size of R1's output does not fit inside any of these ranges, which is a reason for care, not for a claim. |

## Does anyone publish work per million tokens or cost per merged change for real projects?
No rigorous, public figure for either was found.
- **Closest:** Anthropic's enterprise cost per developer-day, Anthropic's own merged PRs per engineer per day (no cost), Cursor's lines per user per week (no cost), and Insight's single-feature cost. An Unblocked post defines cost per surviving PR but its worked example is labelled illustrative, so it is not data.
- **Usual denominators:** per developer-day or month (cost); per task or time on task (trials); per PR, per developer and per team (telemetry); per benchmark instance or per full run (benchmarks); per conversation (Economic Index). No source uses attended hours, and no source reports output per million tokens.

## Options and trade-offs
| Option | Means | Risk |
|---|---|---|
| A. Keep R1 alone | State R1's numbers with its caveats and no outside figures | Misses the cheap corroboration; leaves cost looking unanchored |
| B. Anchor structure only | Add the cache-read share and Anthropic's $13 per active day beside R1; describe productivity studies without comparing | Low risk. Needs the "API-equivalent, subscription" caveat each time |
| C. Set R1's throughput beside the productivity studies | Compare 142 items in 9 days with plus 26 or plus 67 percent | High risk. No baseline, different units, and the critical studies show quality loss R1 did not measure |

## Recommendation
Option B. State the cache-read share as consistent with outside data, and state R1's cost per day as well above Anthropic's published enterprise average, with the sources named. Quote the productivity studies only to say that the field has no agreed unit and that output studies disagree. Say plainly that DDD's own figures are descriptive. Name quality as the gap the critical studies point to. It would change if the director commissions a with-and-without comparison, or if a source appears that pairs cost with surviving merged changes.

## Sources
| Claim | Source (owner, date, link) | Type | Tier | Confidence |
|---|---|---|---|---|
| 55.8 percent faster; 95 participants (45 and 50); CI 21 to 89 | Peng et al., "The Impact of AI on Developer Productivity: Evidence from GitHub Copilot", 2023, arxiv.org/abs/2302.06590 (participants and CI from the ar5iv copy) | Preprint | 3 | High |
| About 21 percent, 96 engineers, summer 2024 tools | "How much does AI impact development speed?", Google, ICSE 2025, arxiv.org/abs/2410.12944v3 | Peer-reviewed | 3 | High (CI bounds not seen) |
| Plus 26.08 percent, SE 10.3, 4,867 developers | Cui et al., "Effects of Generative AI on High-Skilled Work", SSRN 4945566 and Microsoft Research page | Working paper | 3 | Medium (measure definitions not read; PDF unreadable here) |
| Accenture: plus 8.69, 15, 84 percent; n and duration not stated | GitHub blog, "Quantifying GitHub Copilot's impact in the enterprise with Accenture", github.blog | Vendor study | 3 | Medium |
| METR 2025: 16 developers, 246 tasks, 19 percent more time, forecast 24 and belief 20 percent less | arXiv 2507.09089 (abstract); search summary for forecast; METR 2026 post for CI plus 2 to plus 39 | Preprint, RCT | 3 | High |
| METR 2026: 57 developers, 143 repositories, 800 tasks; estimates and why unreliable; 349-person survey | metr.org/blog/2026-02-24-uplift-update | Primary | 3 | High |
| Anthropic internal: 132 survey, 53 interviews, 200K transcripts, plus 67 percent merged PRs per engineer per day, self-report 50 percent | anthropic.com/research/how-ai-is-transforming-work-at-anthropic, Dec 2025 | Vendor study | 3 | Medium (own staff, self-report) |
| Economic Index 2025: 79 vs 49 percent automation; no productivity measure | anthropic.com/news/impact-software-development, 2025-04-28 | Vendor study | 2 | High |
| Economic Index 2026: autonomy 0.37 higher, tokens as unit, no dollars | anthropic.com/research/economic-index-june-2026-report, 2026-06-26 | Vendor study | 2 | High |
| DORA 2025: about 5,000 respondents, throughput up, instability up | dora.dev/dora-report-2025 (theme only); research.google DORA 2025 page; InfoQ 2025-09 for findings | Report; secondary | 3 and 4 | Medium (142-page report not read) |
| No 2026 DORA AI report found | Search and dora.dev pages; an ROI report is listed as coming | Absence | 4 | Low |
| Faros 2025: over 10,000 developers; PRs plus 98, review plus 91, size plus 154, bugs plus 9 | faros.ai blog (AI Productivity Paradox) | Vendor telemetry | 3 | Medium (correlational) |
| Faros 2026: 22K developers; tasks plus 33.7, merge rate plus 16.2, bugs per PR plus 28.7, review 5 times, incidents per PR plus 242.7 | faros.ai/research/ai-acceleration-whiplash | Vendor telemetry | 3 | Medium (undated page; the 2025 and 2026 PR figures differ widely) |
| Jellyfish: 259 companies, 21,209 engineers, 2.16M PRs, 95.5 to 83.8 hours | jellyfish.co/blog/ai-impact-data-june-2025 | Vendor telemetry | 3 | Medium |
| Uplevel: about 800 developers, cycle time minus 1.7 minutes, bugs plus 41 percent | devops.com, CIO coverage (primary not opened) | Secondary | 4 | Low |
| He et al.: 806 vs 1,380 repositories, lines added plus 28.6, warnings plus 30.3, complexity plus 41.6 | arXiv 2511.04427 (HTML v3); paper's text cites 25 percent complexity in places | Preprint (MSR 2026) | 3 | Medium (internal inconsistency; second half of page unread) |
| AIDev: 456K agent PRs, accepted less often than human | arXiv 2507.15003 abstract | Preprint | 3 | Medium (percentages unverified) |
| Claude Code cost: $13 average per active day, $150 to $250 a month, under $30 for 90 percent | code.claude.com/docs/en/costs, read 2026-10-19 | Official docs | 2 | High (population and "active day" undefined) |
| Aider: gpt-5 (high) 88.0 percent, $29.08; 225 exercises | aider.chat/docs/leaderboards | Benchmark | 3 | Medium (cost definition is inferred as per run) |
| Terminal-Bench 4.0: 66 tasks; tokens and dollars are run totals, not per task | snorkel.ai/leaderboard/terminal-bench-4-0 | Benchmark | 3 | Medium (trial count and token definition not stated) |
| Agent token use: 500 instances, 4 runs, cache reads largest cost, 30 times variance | arXiv 2604.22750 (HTML) | Preprint | 3 | High |
| Insight: $3 to $33, 26 to 176 minutes, 29 runs, one feature | blog.apac.insight.com, 2026-07-06 | Practitioner blog | 4 | Medium (author states small sample) |
| Cursor token mix: 90, 2.5, 7, 0.6 percent; 700 lines a week median | Pragmatic Engineer, "Interesting AI coding stats from Cursor" | Vendor data via press | 4 | Medium |
| Unblocked cost per surviving PR is illustrative | getunblocked.com/blog/cost-per-merged-pr, 2026-06-12 | Vendor blog | 4 | High (that it is illustrative) |
| Stanford Denisov-Blanch, about 100K developers, 15 to 20 percent net | Talk summaries only | Secondary | 5 | Low; not used in the conclusion |
| Veracode, GitClear, CodeRabbit-style quality findings | Search summaries only | Vendor, secondary | 4 and 5 | Low; not relied on |

## Open gaps
- **Cost per merged change on real projects:** searched in several ways, nothing rigorous found. Effect: the per-item comparison is at the level of "same order", not a ranking.
- **Cost per attended hour:** no external figure. R1's cost per calendar day and per active day could be computed from the transcripts, to compare with Anthropic's $13, with "active day" defined first.
- **DORA 2025 full report and the 2024 report:** not read; DORA 2026 not found. Effect: the DORA row rests on the summary page and one news report.
- **Cui et al. definitions:** the PDF was unreadable here. What "completed tasks" means should be checked before anyone quotes the 26 percent as pull requests.
- **SWE-bench cost per instance:** the official cost column and HAL pages could not be opened; no dollars-per-task figure from SWE-bench is in this note. Terminal-Bench and Artificial Analysis per-task costs were not obtained (the latter returned 404 or no figures).
- **Uplevel, Stanford, GitClear, Veracode:** only secondary coverage was read, so they carry no weight here.
- **Cline and OpenAI or Google engineering blogs:** no published cost per task or per user found.
- **Dollar claims depend on date and price:** the Terminal-Bench division assumes the leaderboard's tokens and dollars cover the same runs.
