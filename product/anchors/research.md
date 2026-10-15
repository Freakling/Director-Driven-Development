# Anchor: the research assistant

The agreed behaviour of the research assistant in Godot-Director, App-Director and SaaSAllTheThings, adapted from the director's portable research skill. This file lives only in this repository. A task in each framework's own `TASKS.md` carries it there, and that framework's build agents implement it. Brief: Scope › Planned framework changes › All three get a research assistant.

How to read it:
- **Part A** (sections 1-6) is what changes in the framework: items, commands, the subagent, the note.
- **Part B** (sections 7-9) is the research procedure. It becomes `<framework folder>/procedures/research.md`. The core is short; the details are sections the researcher loads only when needed.
- **Part C** (sections 10-11) is the domain file each framework adds, and the summary the alignment audit compares.

## Placeholders

| Placeholder | App-Director | Godot-Director | SaaSAllTheThings |
|---|---|---|---|
| `<framework folder>` | `.app-director/` | `.godot-director/` | `.satt/` |
| the design records | brief and `product/decisions.md` | GDD and `design/decisions.md` | PRD, `product/decisions.md` and the ADRs in `adr/` |
| the design-records line of an item | `Brief:` | `GDD:` | `PRD:` |
| the open questions | brief › Open Questions | GDD › Open Questions | PRD › Open Questions |
| note folder (proposed) | `product/research/` | `design/research/` | `product/research/` |
| domain file (proposed) | `.app-director/research-domain.md` | `.godot-director/research-domain.md` | `.satt/research-domain.md` |

Paths marked "proposed" are the anchor's suggestion. The framework's build agents may adjust them to fit the repository, and the audit then records the difference.

# Part A: what the framework changes

## 1. Purpose and role

The researcher informs. The director decides.

- It researches one question in a fresh context and returns options, trade-offs and a recommendation.
- Its recommendation feeds a design call. It is never the decision.
- It never records a decision, never edits the design records, never answers an open question, and never accepts an ADR.
- It never asks the human. When something is unclear it states an assumption in the note and carries on. The assumptions are the first thing the designer checks.
- The designer shows the recommendation as one option with its reason, and waits for the director, as `design.md` already requires for every option.

## 2. What each framework gains

| Piece | Where (proposed) | Holds |
|---|---|---|
| Core procedure | `<framework folder>/procedures/research.md` | Part B of this anchor, written for the researcher |
| Domain file | `<framework folder>/research-domain.md` | Part C, loaded only when the question touches the domain |
| Subagent `researcher` | with the other subagents (Claude Code: `.claude/agents/researcher.md`) | One line: read the core procedure and follow it exactly |
| Skill `/research` | with the other skills (Claude Code: `.claude/skills/research/SKILL.md`) | One line: read the core procedure and follow it exactly |
| R items | `tasks.md` (the item format) | Section 3 |
| `/next-task` | `procedures/next-task.md` | Section 5 |
| Design session | `procedures/design.md` | Section 4 |
| Note folder | see Placeholders | Section 6 |

Also update wherever the framework lists its commands and models: `rules.md`, the README, the install and bundle scripts, the skills folder for tools other than Claude Code, and the framework's selftest (it checks that the files above exist).

Tools: the `researcher` gets `Read`, `Grep` and `Glob`, plus web search and web fetch where the tool has them. It gets no edit, write or shell tool. Web search and fetch are read operations; the framework's settings allow them for the researcher. Everything with side effects keeps asking.

## 3. R items

Research is a task type with its own ID series, `R<n>`, drawn from the `Next IDs` line like bugs (`T<n> · B<n> · R<n>`). IDs are never reused.

```
### R3 · Which push service fits offline-first sync · todo · M · agent
- Depends on: -
- Question: Which push options fit an offline-first app on Flutter and Android, and what do they cost to run? Assume under 10k users.
- Informs: Q4
- Brief: Notifications
```

- **Heading.** `R<n> · title · status · size · agent`. Status is `todo`, `in-progress YYYY-MM-DD` or `done`, as for any item. The owner is always `agent`.
- **`Depends on`.** As for any item.
- **`Question:`** replaces `Done when`. One question, stated so a reader can tell when it is answered. It may state assumptions and scope.
- **`Informs:`** the open question the research feeds (`Q<n>`), or `-`.
- **The design-records line** (`Brief:`, `GDD:` or `PRD:`) names the heading the question concerns, or `-`.
- **Done** when the research note exists. A note that says what was searched and what stays unknown is a valid result; the director decides whether to queue a follow-up.
- Done R items are pruned and archived like other done items.

**Sizing.** Research is sized like a task, and the size picks the model from the model sizing map in AGENTS.md › Project rules (the session model when sizing is off).

| Size | Research |
|---|---|
| XS | One fact check against one primary source: a version, a licence, a limit, a date |
| S | One narrow question with two options and a few sources: does this library support that |
| M | A comparison of 2-4 options in one area, with trade-offs and a recommendation |
| L | An architecture, security or requirements comparison across several areas, with sources to reconcile |
| XL | Several linked areas feeding more than one decision, such as a stack choice with security, cost and migration. Split it when you can |

When in doubt, pick the smaller size. If the report says the question needs more than its size allows, rerun it once with the next size's model and label the item `M (escalated from S)`, as for builds.

## 4. Two ways to start

**On the fly.** The designer delegates during a design session, or the director runs `/research <question>`. The R item is created, claimed and run at once. Nothing is queued.

- In a design session the designer delegates when the options depend on facts it does not have, or when the director asks. A single fact it can check in one source (an XS question) it may check itself. Anything larger goes to the researcher, so the session's context stays small.
- Before creating an item, look in the note folder for a note on the same topic. Reuse it when its verified-as-of date is recent enough for the claims. Otherwise research only what has changed.
- `/research` runs without a design session. The orchestrator creates the item, runs the researcher, writes the note, and offers a design session when the item informs a question.
- When the director decides after research, the decision line in the log ends with the note's path in its "why" part. Later sessions then reuse the evidence instead of redoing it.

**For later.** The R item is queued in `TASKS.md`. Tasks that need the findings list it under `Depends on`. It informs an open question the same way: `Informs: Q<n>`. A task that needs the decision, not just the findings, stays gated by the question itself (its `Done when` names `Q<n>`), exactly as today. The research finishing does not answer the question.

## 5. Changes to `/next-task`

- **Candidates.** R items are candidates like any item: `agent`, status `todo`, `Depends on` all `done`. Order is file order.
- **Who builds.** A research item goes to the `researcher` subagent instead of the builder. The orchestrator gives it the item ID and full text, in the foreground, with the model for the item's size.
- **No check run.** Research changes no code. Skip the passing-check step in Pick, the Verify step, and the review. Anything that guards the builder's edits (a building marker, a stop hook) does not apply, because the researcher writes nothing. A commit hook that runs the check must not fail a note-only commit.
- **The orchestrator writes.** The report is the note's content. The orchestrator writes it to `<note folder>/YYYY-MM-DD-<slug>.md`, using today's date and a short kebab-case slug of the topic.
- **Records.** Set the item `done` and delete its `Note:`. Follow-ups the report names become new items from `Next IDs`. The note and the records are committed in one commit, by the framework's normal commit model. Nothing else gates it.
- **Informs.** When the item has `Informs: Q<n>`, the report says that Q<n> is ready for a design call and offers a design session with the note as input. The question stays in Open Questions until the director decides. Tasks that need the decision stay gated by it.
- **Several items.** A finished research item does not stop a run. The run goes on with the next candidate, and the final report lists the questions that are now ready for a design call.

## 6. The researcher subagent and the research note

The `researcher`:
- starts in a fresh context and reads the core procedure, the project's records the question touches, and the domain file when the question concerns its domain;
- reads the repository and the web, and changes nothing;
- returns the whole note in its report. The subagent never writes the file; the orchestrator does.

**Confidentiality.** Confidential project text, identifiers, customer data, secrets and unpublished design text never go into a public search query or a fetch request. Write queries in generic terms about the technology. Quote project text only inside the note.

**The note** is one file per topic: `<note folder>/YYYY-MM-DD-<slug>.md`. It is compact and conclusion first. Leave out empty sections.

```
# <The question, as a title>
R<n> · Informs: Q<n> or - · Verified as of YYYY-MM-DD · Size: M

## Question and assumptions
The question as asked. Scope and exclusions. Every assumption, because the researcher did not ask.

## Conclusion
Two to five sentences. The answer, how sure it is, and what would change it.

## Options and trade-offs
Each viable option, the status quo included when it is viable: what it means, what it costs, the risks, when it wins.
A table when it helps. Facts, implications and judgment kept apart.

## Recommendation
One option and the reason. What would change the recommendation.
An ADR-ready summary when the question is architectural (SaaSAllTheThings; see its domain file).

## Sources
| Claim | Source (title, owner, date, version, link or path) | Type | Tier | Confidence |
Include contradicting sources and what was not accessible.

## Open gaps
What was searched and not found, what could not be verified, and the effect on the conclusion.
```

- **Verified as of** is the date the time-sensitive claims were checked. It is the date a later session uses to decide whether to reuse the note.
- Each claim in the conclusion and the options traces to a row in Sources.
- The note records research. It records no decision. The decision line in the log links to it.

# Part B: the research procedure

This part is the text of `<framework folder>/procedures/research.md`, written for the researcher. Sections 7 and 8 are the core. Section 9 holds the details, read as needed.

## 7. Core procedure

Research one question and report a note. You inform; the director decides.

1. **Frame.** Read the item's `Question:` and the records it touches (AGENTS.md, the design records for the `Brief:`, `GDD:` or `PRD:` heading, the decisions log, notes on the same topic). Settle the decision or outcome sought, scope, exclusions, the project's constraints, and the depth needed. State a reasonable assumption instead of asking. Never ask for what you can discover.
2. **Decompose** into subquestions that matter for this question. Use only the categories that apply: current state and constraints, capabilities, options, security and requirements, operation and support, resilience, cost, dependencies, migration.
3. **Plan sources.** Pick the strongest applicable sources before searching broadly. Plan separate searches for the project's own records, binding requirements, official documentation, standards, independent evidence, and views that contradict the likely answer.
4. **Retrieve and inspect.** Open the sources. Find the passage, table, release note, decision record or code that supports each important claim. A search preview is not a source. Close material gaps with targeted searches. For current products, confirm version, documentation date, edition or tier, lifecycle state, and preview or general availability.
5. **Reconcile.** When sources disagree, follow section 9 › Reconcile. Never average incompatible claims or quietly pick the convenient one.
6. **Test sufficiency.** Is every important conclusion supported? Were credible alternatives considered, the status quo included? Are the project's constraints represented accurately? Are sources current? Is fact kept apart from judgment? Would more research plausibly change the recommendation? Name any material gap and its effect.
7. **Synthesize and verify.** Lead with the conclusion. Connect evidence to the decision. Remove what cannot be supported. Check every citation against its claim. Recheck numbers, dates, names, versions, limits and status. Make sure the recommendation follows from the stated criteria and evidence.
8. **Report** the note in the template from section 6, and nothing else.

**Principles.**
- *Evidence before confidence.* Base material claims on sources you inspected. Separate verified facts, source interpretations, assumptions and your judgment. Prefer an incomplete, accurate answer to a complete-looking unsupported one.
- *Decision orientation.* Research ends in a conclusion the director can use: the decision at stake, the drivers, the viable options, the trade-offs, a recommendation, and what would change it. A pile of facts without their relevance is not a result.
- *Proportional effort.* An XS or S question gets a direct answer after verifying the fact. Ambiguous, comparative, high-impact or architectural questions get the full process. Verify harder where it matters most: security, requirements, identity, production design, money, destructive changes. Stop when a few strong primary sources support the decision.
- *Show artifacts, not private reasoning.* The note carries scope, assumptions, criteria, evidence, options, confidence and gaps. That is the reviewable trail.

## 8. Rules for every note

**Source tiers.** Use lower tiers to find stronger evidence, never as the only basis for a high-impact recommendation.

| Tier | Sources |
|---|---|
| 1. Binding and governing | The project's own records: AGENTS.md, the design records, the decisions log, accepted ADRs. Binding requirements: laws and regulations, contract terms, platform and store terms the product must meet, and the customer's security framework where the framework has one |
| 2. Primary technical authority | Official documentation and architecture guidance, release notes and lifecycle notices, source and docs kept by the product's owner, standards, formal control-framework publications, vendor support statements |
| 3. Direct technical evidence | Reproducible tests, code inspection, configuration and deployment files, benchmarks with disclosed method, incident reports and engineering write-ups, peer-reviewed work |
| 4. Reputable interpretation | Established technical publications, independent guidance, recognised experts, well-kept community documentation |
| 5. Discovery only | Search previews, aggregator pages, forums, unverified posts, AI summaries that cannot be traced to a source |

**Citations and traceability.**
- Cite each material claim next to the claim, as a row in Sources.
- A citation points to a source you actually inspected. Never cite a source that only discusses the same topic.
- Prefer a precise passage, section, line or stable link. Give title, owner or publisher, date and version when they matter.
- For project records, give the file, heading and decision or ADR ID.
- Label a source that was inaccessible or only partly retrieved. Mark conflicting evidence.
- Say whether a time-sensitive claim was verified as of the note's date.
- Quote sparingly and exactly. Never alter a quote to support a stronger claim.

**Confidence labels.** Use them on claims and conclusions.
- **High:** directly supported by current primary evidence.
- **Medium:** supported, but depends on interpretation or incomplete context.
- **Low:** plausible, weakly evidenced.
- **Unknown:** not enough evidence.

**Anti-hallucination checks.** Before reporting:
- Never invent a citation, quote, title, version, date, capability, price, limit or decision.
- Check names, dates, versions, regions, limits, prices, lifecycle status and availability.
- Check that no recorded decision has been superseded.
- Separate current behaviour from past behaviour.
- Do not infer undocumented capabilities. Do not turn an example into a universal requirement.
- Do not infer that a requirement is met because a technical control exists.
- Do not call an option supported, certified, recommended or prohibited without evidence.
- Define ambiguous terms or state the reading you took.
- When no answer can be verified, say what you searched, what you found, and what remains unknown.
- Reduce confidence for outdated sources and say so.
- You cannot run code. A claim that needs a run (a benchmark, a build, a spike) stays Low or Unknown, and the note proposes a builder item for it.

**Voice of the note.** Plain, short sentences. Tables where they help a comparison. No empty sections. Quote the project's records only as far as the answer needs.

## 9. Details (read when the question calls for them)

**Project records.**
- Read the records first. Recorded decisions and accepted ADRs are the project's constraints. Check status: proposed, accepted, rejected, superseded. Look for a later decision before relying on an older one.
- Do not re-propose what a decision or ADR rejected without saying what has changed since.
- An open question is the director's. Research it, never answer it. Say which open question the finding bears on.
- Do not override a recorded decision because public guidance differs. Explain the decision, the external guidance, the documented reason for the gap, the consequence, and whether a review is warranted. An outdated decision is a review candidate, not an invalid one.
- Distinguish a standard that holds across the project from a choice made for one part of it.
- Disclose no more of the project's text than the answer needs.

**Reconcile.** When sources disagree:
1. Confirm they cover the same product version, scope, region, jurisdiction and scenario.
2. Check dates, lifecycle state, and whether either has been superseded.
3. Prefer primary, authoritative evidence for claims about what something does.
4. Keep the project's decisions as local constraints unless they are superseded, invalid, or conflict with a higher obligation.
5. Show the disagreement that stays unresolved.

**Binding requirements.** When laws, contracts, store terms or a control framework apply:
- Identify the framework or rule, its jurisdiction, version and effective date.
- Separate legal requirements from framework guidance, certification criteria, the organisation's reading, and implementation choices.
- Trace each requirement to the proposed control or design. Label the mapping direct, partial, interpretive or unverified.
- Name the shared-responsibility boundary where one exists.
- This is technical guidance, not legal advice. Name the areas that need confirmation from a legal, risk, security, privacy or compliance owner.

**Comparing options.**
- Derive the criteria from the question, the constraints and the outcome wanted. Say why each matters. Skip the generic scorecard.
- Separate objective evidence, context-dependent implications, and judgment.
- Avoid numeric scores unless the weights and rules are justified.
- Do not set options of different scope side by side as equals.
- Include the status quo when it is viable.
- Cover switching cost, lock-in, skills, operating burden, maturity and exit where they matter.
- Say which scenario favours each option.
- Do not recommend an option because it is common, fashionable or in a reference design.

**Working in the repository.**
- Read before concluding: the project instructions, the design records, the existing patterns, and the git log when the question is why something was decided.
- Treat code, tests, configuration and deployment files as technical evidence.
- Use only the tools you have. If one is missing (no web access, say), continue with reduced scope and state the limitation in Open gaps.
- Check what a tool returns before you treat it as evidence.

# Part C: domain files and the audit summary

## 10. Domain files

One reference file per framework. The core procedure says: "Read `<framework folder>/research-domain.md` when the question concerns [the domain]." Questions outside the domain stay technology-neutral. Each file is short and adds to the core; it never repeats it.

**SaaSAllTheThings** (`.satt/research-domain.md`)
- *Azure first, when Azure is central.* Treat a question as Azure platform research when Azure is central to it. Consider the concerns that apply: tenant and subscription layout, management groups and resource organisation, identity, privileged access and workload identities, governance, RBAC and guardrails, networking, DNS, routing, segmentation and private access, monitoring, logging, key management and data protection, landing zones and workload onboarding, infrastructure as code, pipelines and drift, operations, ownership and support, availability, resilience, backup and recovery, cost, quotas and service limits, data residency and sovereignty.
- *Primary guidance.* Current Microsoft documentation: the Cloud Adoption Framework, the Well-Architected Framework, the Azure Architecture Center, landing zone guidance, product documentation and release information. These are inputs, not answers. Adapt them to the project's requirements and recorded constraints.
- *Switch to technology-neutral* when Azure is not material, when the question is about a language, framework, protocol or practice, when a cross-cloud or on-premises option is viable, or when an Azure-only framing would distort the decision. Apply the same evidence standard to every option.
- *The reference architecture has authority.* `.satt/reference/` holds unless an accepted ADR says otherwise. Classify the question as the architect session does: an open choice, a deviation, a framework gap, or a requirements conflict. For a deviation, option 1 is to comply, with what that takes. Cost figures start from `reference/cost.md`.
- *The customer's security framework.* Requirements in `compliance/` (and PRD › Data and Compliance) are Tier 1. Trace each to the proposed control and label the mapping direct, partial, interpretive or unverified. Name the shared-responsibility boundary. Do not infer that a requirement is met from the presence of a control.
- *ADR-ready summary.* For a significant decision, the Recommendation section ends with a summary the architect session can turn into an ADR: title, status (`proposed`), context, decision, rationale, alternatives considered, positive and negative consequences, assumptions, references, and review or supersession triggers. The researcher never writes the ADR and never marks it accepted. The architect session does, when the human accepts.
- *Architecture recommendation checklist.* For an architecture question, the note covers: decision context; requirements and constraints; assumptions and unknowns; viable options; criteria from the scenario; evidence-backed trade-offs; the recommended option and its rationale; security and requirements implications; operations and ownership; dependencies and prerequisites; cost where evidence exists; migration or implementation considerations; risks and mitigations; revisit triggers; confidence.

**App-Director** (`.app-director/research-domain.md`)
- *Stacks and libraries.* The project's stack in AGENTS.md is the starting point. Cover the stacks the framework supports (TypeScript, Flutter, Python) and say so when a question goes beyond them.
- *A library or tool is judged on:* maturity, release cadence and the date of the last release, how actively it is maintained and by whom, known security advisories, its licence and whether it fits how the project is distributed, platform and runtime support, size and cost to adopt, and how well it fits the project's check and structure rules.
- *Licences* are read from the licence file or the registry entry actually inspected, with the version the claim applies to.
- *App-store and platform requirements.* The store and platform terms the product must meet to be published, including review guidelines, privacy and data declarations, target platform levels and signing. These are Tier 1 binding requirements and are read from the store's current published text.

**Godot-Director** (`.godot-director/research-domain.md`)
- *The engine and its docs.* The Godot documentation for the engine version the project uses. Read the version from the project, and check that a claim holds for that version, not only the latest one. Say when a feature differs between versions.
- *Plugins and assets.* Maintenance, compatibility with the project's engine version, and the licence of every plugin or asset, including attribution and notice duties. Read the licence file or the listing actually inspected.
- *Export and store requirements.* Export templates and settings per platform, and the store terms the game must meet to be published (technical, rating, privacy and data declarations). These are Tier 1 binding requirements.
- *Comparable games as design references.* How similar games solve the problem, from devlogs, postmortems, talks and reviews. Label them design references, not proof of what works for this game, and give them Low or Medium confidence. Note which Design Pillar an option serves or strains. If an idea contradicts a pillar, say so plainly; the director decides which gives way.

## 11. What stays the same, and what each framework adds

**The same in all three**

| Part | Behaviour |
|---|---|
| Role | The researcher informs, the director decides. It records nothing and asks nothing |
| Items | `R<n>` from `Next IDs`; `Question:`, `Informs:`, `Depends on`, and the design-records line; done when the note exists |
| Sizing | XS to XL by the same table; the size picks the model from the model sizing map |
| Start | On the fly (the designer delegates, or `/research`) or queued for later with `Depends on` |
| `/next-task` | Research items are candidates; they go to the `researcher`; no check run; the orchestrator writes and commits the note; an `Informs:` question becomes ready for a design call and stays gated |
| Subagent | Fresh context; `Read`, `Grep`, `Glob` plus web search and fetch; returns the note; never writes |
| Note | Dated, one per topic, conclusion first, the template in section 6; the decision log links to it |
| Procedure | Frame, decompose, plan sources, retrieve, reconcile, test sufficiency, synthesize and verify |
| Evidence | Five source tiers, claim-to-source traceability, High/Medium/Low/Unknown, anti-hallucination checks, proportional effort |
| Confidentiality | Confidential project text never goes to public search |
| Wording | "requirements", "control framework" or "security framework" |

**What each framework adds**

| | App-Director | Godot-Director | SaaSAllTheThings |
|---|---|---|---|
| Design records | brief, `product/decisions.md` | GDD, `design/decisions.md` | PRD, `product/decisions.md`, ADRs |
| Item line | `Brief:` | `GDD:` | `PRD:` |
| Note folder (proposed) | `product/research/` | `design/research/` | `product/research/` |
| Domain file | Stacks, libraries, licences, app-store and platform requirements | Godot docs and engine version, plugins and asset licences, export and store requirements, comparable games | Azure first, the customer's security framework, ADR-ready summaries, the architecture checklist |
| Extra Tier 1 | Store and platform terms | Store terms | The customer's security framework in `compliance/`, the reference architecture |
| Feeds | The design session | The design session, checked against the Design Pillars | The design session and the architect session |
