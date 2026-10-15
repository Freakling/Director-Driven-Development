# Concept

<div class="kicker">The principle</div>

> A director doesn't need to act. A director needs to recognize a good take.

Director-Driven Development (DDD) solves the second prompt problem. A single prompt can build an app. The fix, the new feature and the change to something that already works are where results start to vary: context fills up, the design drifts, and "done" means "it compiled". AI is a non-deterministic tool, and that is also where its creativity comes from. DDD keeps the creativity and adds a frame: small context, small tasks, and automated proof that every task works.

The director doesn't write the implementation. The director decides what gets built, judges the result and owns the design.

## The pages

| Page | What it covers |
|---|---|
| [Roles](roles.md) | Director, orchestrator, builder, reviewer and researcher, and who may do what |
| [Design calls](design-calls.md) | How the director decides: options, research notes, records, open questions and placeholders |
| [Agent development flow](agent-flow.md) | Build, research, commit and the human rounds that feed back into design |
| [The check](check.md) | One automated check that defines done, per framework |
| [Task and model sizing](sizing.md) | Sizes XS to XL for tasks and research items, the model map, escalation and the two-attempt limit |
| [Reviews](reviews.md) | When a change gets an independent review, per framework |
| [Records in files](records.md) | The records that hold the project between sessions, and why each fact has one home |
| [Code shaped for agents](code-shape.md) | How the codebase is split so that each task reads only what it needs |
| [Ownership](ownership.md) | Who owns each area, the director or the agent, and what stands in for human-owned assets |
| [Align and drift reset](drift.md) | The routine consistency pass, and the reset for when a principle is built two ways |
| [Built-in cost savings](cost-built-in.md) | The cost optimisations the three frameworks build in automatically |
| [Cost tuning for developers](cost-tuning.md) | What you can adjust yourself, on top of the framework defaults |

## What the frameworks add

Small batches, a single source of truth, a definition of done, decision records and an orchestrator that delegates to subagents are established practice. Trust, but verify: enforce what's critical, audit the rest. The frameworks combine these for AI agents and add four things.

- **Rules are enforced, not suggested.** The check fails the build when a rule is broken, for example game rules in a screen script, a UI file that imports the data layer, or a tenant id read from a request.
- **Deviation is a decision.** Where the framework owns the architecture (SaaSAllTheThings), the only way past a rule is an architecture decision record (ADR) the director accepts. The check excuses only the exceptions an accepted ADR names. Builders and reviewers flag anything outside their task for the director instead of fixing it on the spot.
- **Context discipline is a rule.** The orchestrator never reads the code being changed. Its context holds decisions and reports, so a long session stays as sharp as a short one.
- **Ownership is protected.** The frameworks back [ownership](ownership.md) with hooks. In Godot-Director and App-Director, a hook keeps the agent from writing to the director's own `director/` workspace. In SaaSAllTheThings, a hook asks the director before a framework file changes or an ADR is accepted.

## Who it's for

Anyone who can judge the design of code, even without writing it. It takes design judgement, the discipline to keep documents authoritative, and the willingness to throw work away when it no longer matches intent.

<div class="takeaway"><span>AI didn't remove the need for engineering judgement. It concentrated it.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
