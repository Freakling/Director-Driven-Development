# What this way of working costs: three projects measured
R1 · Informs: - · Verified as of 2026-10-19 · Size: M

Question: what does Director-Driven Development cost in tokens and money, measured rather than claimed, and what can be said about it without over-claiming.

## Question and assumptions

- **Source of truth:** the Claude Code transcripts on the director's machine (`~/.claude/projects/<project>/**/*.jsonl`), main sessions and subagents, every assistant message's `usage` (fresh input, output, cache writes, cache reads) and `model`, de-duplicated by message id. The devlog's numbers for PKSEI come from Claude Code's own session report and differ (see Caveats); this note uses the transcripts for all three projects so they compare.
- **Prices:** pay-as-you-go API prices from [claude.com/pricing](https://claude.com/pricing) on 2026-10-19, per million tokens: Fable 5.1 $10 in, $50 out, $0.25 cache read, $12.50 cache write; Opus 5.5 $4, $20, $0.20, $5; Sonnet 5.5 $2, $10, $0.10, $2.50; Haiku 5.5 $0.10, $0.50, $0.01, $0.125 (prompts over 100K at $0.50, $2.50, $0.05, $0.625). Cache writes priced at the 5-minute rate; the 1-hour rate adds about 20 percent (second-hand tables, [growthcab](https://www.growthcab.com/claude-opus-api-pricing)).
- **Nothing here was billed per token.** All three projects ran on a Claude Max subscription. Every dollar figure is what the same tokens would cost at API prices: a measure of the work's size, not money spent.
- **Hours:** events in the main sessions sorted by time (user and assistant entries only; the queue entries share the director's timestamps). "At the keyboard" is every gap of 30 minutes or less that ends with a message from the director; "on its own" is every other gap of 30 minutes or less. Permission approvals aren't distinguishable from tools finishing and are left out (the PKSEI devlog counts them and gets 4.7 h against 2.9 here). Time away from the keyboard (testing, thinking, reviewing on GitHub) isn't measured, so the per-hour figures are upper bounds.

## The three projects

| | Director-Driven Development (this repo and the three frameworks) | PKSEI (a game) | Lantern (a codename: a larger indie game, about half done in technical functionality; assets, playtesting and tuning later) |
|---|---|---|---|
| Span | 2026-10-10 to 10-19 (9 days) | 2026-10-16 to 10-19 (2.5 days) | 2026-09-25 to 10-19 (24 days) |
| Director at the keyboard (hours) | 17 | 3 | 30 |
| Agent working on its own (hours) | 24 | 14 | 96 |
| Director turns (main sessions) | 293 | 67 | about 1,900 incl. subagents |
| Commits | 200 here + 130 in the frameworks = 330 | 127 | 537 |
| Done items | 142 | 92 | 514 |
| Tokens (all kinds) | 1.38 billion | 0.33 billion | 4.0 billion |
| Output tokens (incl. thinking) | 2.65 million | 0.82 million | 6.7 million |
| API-equivalent cost | $431 | $211 | $1,428 |
| Per commit | $1.31 (330) or $2.16 (this repo's 200) | $1.66 | $2.66 |
| Per done item | $3.04 | $2.30 | $2.78 |
| Per hour at the keyboard | $25 | $73 | $48 |

What those commits are: here, the docs site (44,000 words of pages) plus everything the frameworks shipped since 2026-10-12 (20 releases across the three repos; Godot-Director alone gained 14,000 lines, including auto-playtesting). PKSEI: 22,000 lines of GDScript with its tests, generated art and sound, about twenty itch.io builds.

## Where the money goes

| Share of cost | DDD | PKSEI | Lantern |
|---|---|---|---|
| Cache reads | 52% | 32% | 50% |
| Cache writes | 34% | 49% | 37% |
| Output | 14% | 19% | 13% |
| Fresh input | 0% | 0% | 0% |
| The orchestrating session (not the subagents) | 76% | 66% | 64% |

Cache reads are 93 to 96 percent of the tokens and a third to a half of the cost. The orchestrating session is the cost centre in all three projects: in this repo it produced 2.5 million output tokens against the builders' 0.13 million, because it designs, records, reviews reports and writes every commit and pull request.

## What each cost feature actually did

- **Caching: the big lever, and not the framework's.** With nothing cached the same tokens would cost $5,281 (DDD), $2,761 (PKSEI) and $15,243 (Lantern): 12 to 13 times more. The workflow earns part of that by keeping context stable (records in files, a fixed set of instructions, builders that read the same records), but prompt caching is Anthropic's feature and any Claude Code session gets it. Claim "cache-friendly", not "cheap because of the framework".
- **Model sizing: real but small.** If every call in this repo had run on Opus 5.5 the equivalent would be $501 instead of $431 (16 percent more); in Lantern $1,563 instead of $1,428 (9 percent). The builders' models matter less than the orchestrator's, because the orchestrator holds most of the tokens. Running everything on Sonnet 5.5 would roughly halve the bill in all three projects; nobody has measured what that does to quality, so it isn't a recommendation.
- **The orchestrator's model is the biggest single choice.** In PKSEI the orchestrating session ran on Fable 5.1 on purpose, to try it with weekly limits to spare: $136 of $211. The same session on Opus 5.5 would have been about $55. In this repo Fable was used for part of the run: $101 of $431 for 253 messages, against $225 for 2,091 messages on Opus.
- **Builders that inherit the model.** In PKSEI, 48 of 89 subagent runs ran on Fable 5.1 ($67, a third of the project) and 41 on Haiku or Sonnet ($4). The transcripts show the Fable runs were ordinary build prompts, so the model was inherited from the session rather than chosen by size. The devlog's "S on Haiku, M on Sonnet" holds for the runs where a model was passed. A fix belongs in the frameworks: the next-task procedure should require the builder's model to be passed explicitly, never inherited.
- **A fresh context per item costs something.** Each builder run writes its context to the cache: about 80K tokens per Haiku run, 150K per Sonnet run, and 1M per Opus run for the large items here (five L builds and five reviews on Opus cost $62). That is the price of isolation; it is cheap on small models and real on large ones.

## What can be claimed, and how

Defensible, with the numbers beside the claim and "API-equivalent, on a Max subscription" stated:

1. **Cost per done item was $2 to $3 in all three projects** ($2.30, $2.78, $3.04), across a docs site, a small game and a large one, over 24 days. This is the most consistent finding. It is a property of how the work is cut (small items, one commit each), so say that too: the items are small by design.
2. **Per hour at the keyboard, $25 to $75 equivalent**, with the agent working one and a half to five hours on its own per hour of the director's. The director's attention is the scarce input. Time away from the keyboard isn't measured, so these are upper bounds.
3. **A playable game, 22,000 lines with tests, in two and a half days for about $210 to $260 equivalent** (the two figures are the two sources; see Caveats).
4. **Caching turned a four-figure bill into a three-figure one.** True, and worth saying with the counterfactual stated as a counterfactual.

Do not claim:

- **That it is cheaper than another way of working.** Nothing was measured against a baseline: the same work without the framework, or by a person. The figures describe, they don't compare.
- **The dollars as spend.** A Max subscription at $100 or $200 a month covered all of it; the equivalents for October alone exceed that, so the subscription is the cheaper way to pay and the API numbers overstate the money. Say which one you mean.
- **That model sizing is what makes it cheap.** It saves 10 to 15 percent where it is applied; caching and the orchestrator's model choice dominate.
- **Quality or completeness.** Not measured: rework, bugs found after the fact, the 116 placeholders PKSEI still has, the `/ui-design` UAT still open here. A low cost per item says nothing about whether the items were the right ones.

## Open gaps

- **Two sources disagree for PKSEI.** The devlog's table (Claude Code's session report) says 1.67 million output tokens and $258; the transcripts say 0.82 million and $211 (with 125 commits at the report, 127 now). The cache figures agree within 4 percent, so the difference is in how output is counted; the report may include streamed partials. Pick one source per claim and name it.
- **Prices move.** Sonnet 5.5's cache read price halved on 2026-10-07 according to one aggregator; date every figure.
- **Cache write TTL.** At 1-hour write prices the totals are about 20 percent higher ($519, $274, $1,745).
- **Keyboard hours** miss anything done outside Claude Code (playing the game on a phone, thinking, reviewing pull requests on GitHub) and permission approvals.
- **Lantern** is a codename; the game is not yet announced and appears here only as the larger data point, without its name or details.

## What the subscriptions turn that into

Anthropic publishes the plan prices and the session multiples (Max 5x and 20x are five and twenty times Pro per five-hour session), not the weekly caps in tokens. Two independent measurements exist, both third-party, both from real accounts: [Wokey](https://wokey.ai/claude-usage-limits) (week of 2026-10-12, 474 Pro accounts, 17 Max 20x accounts, traffic priced at API rates with caching) and this director's own transcripts.

| | Pro | Max 5x | Max 20x |
|---|---|---|---|
| Price per month | $20 | $100 | $200 |
| Weekly cap, API-equivalent (Wokey, measured) | about $170 | not published (under 5 accounts) | about $1,640 |
| Five-hour window, API-equivalent (Wokey) | about $14 | 5x Pro by Anthropic's definition, about $70 | about $205 |
| Per month if the week is always used | about $740 | between $2,000 and $4,000 (see below) | about $7,100 |
| Price paid per API-equivalent dollar | about 2.7 cents | about 2.5 to 5 cents | about 2.8 cents |
| This director's heaviest week ($1,401, limits left) | | | consistent with 20x |

The Max 5x week is unmeasured. Third-party derivations put a 20x week at 1.7 to 3.5 times a 5x week, so $470 to $960 a week; the Classmethod figure (3.5x) was taken during a temporary Claude Code boost and overstates it. Plan for about twice.

What this means for the figures above, if the weekly limit is always met:

- **A fully used plan costs about 3 cents per API-equivalent dollar**, on Pro and on Max 20x alike; Max 5x is in the same range but unmeasured. The $2 to $3 per done item becomes 6 to 10 cents, and the $25 to $75 per hour at the keyboard becomes about $1 to $2. State the measured basis every time: the caps are unpublished, third-party measured, and have changed at least three times in 2026.
- **Which plan the week fits.** At this workflow's $25 to $75 per hour at the keyboard, a Pro week ($170) covers 2 to 7 hours of directing, a Max 5x week roughly 6 to 35, a Max 20x week 20 to 65. The weekly cap is not the binding constraint for one director running one session; the director's hours are. What binds on Pro is the five-hour window: about $14 of API value, which this workflow spends in roughly an hour (the busiest day here ran $535). Max 20x's window ($205) is not reached at single-session pace, and was approached only on the day three sessions ran in parallel.
- **Fable costs limit, not money.** On Max, Fable may use up to half the weekly cap at no extra charge, and one measurement has it moving the meter about twice as fast as Opus for the same API value. Choosing Fable for the orchestrator, as PKSEI did deliberately, trades weekly headroom, not dollars, until the cap is hit.
- **Past the cap, the API price returns.** Extra usage is billed at standard API rates, prepaid. The $100 and $200 of monthly API credits that Max includes since 2026-10-07 apply to the API and the Agent SDK, not to Claude Code or extra usage.
- **The honest comparison** is therefore: the API-equivalent figures measure the work; the subscription price measures the money; the ratio between them is about 30 to 37 to 1 for a fully used plan, and smaller for any week the plan isn't driven to its cap. Nothing in these numbers says the subscription is cheaper than another way of working, only that it is far cheaper than paying for the same tokens by the token.

## Follow-ups worth filing

- Frameworks: the next-task procedure requires the builder's model to be passed explicitly from the sizing table; a session that launches a builder without one is the bug behind a third of PKSEI's cost.
- Docs: the cost pages can quote the per-item and per-hour figures with their caveats; the "model sizing" page should stop short of calling it the main saving.
- Measurement: a `tools/usage.sh` that reads the transcripts and prints this table would let any director repeat the measurement; the scripts behind this note are in the session scratchpad.

Sources: [claude.com/pricing](https://claude.com/pricing) (plans and API prices, read 2026-10-19), [growthcab: Claude API pricing](https://www.growthcab.com/claude-opus-api-pricing) (1-hour cache write rates), [sentra: Claude API pricing](https://www.sentra.app/articles/claude-api-pricing), [superblocks: Claude Code pricing](https://www.superblocks.com/blog/claude-code-pricing), [PKSEI devlog 1](https://freakling.itch.io/pksei/devlog/1712142/devlog-1-how-pksei-was-made-in-two-evenings-a-recipe).
