# Product brief: Director-Driven Development docs

<!-- What the app should be. The AI reads only the sections it needs; reference them by heading.
     The AI never answers an Open Question itself; work that depends on one gets a placeholder. -->

## Pitch

The how-to reference for Director-Driven Development, centred on the three frameworks: what the method is, how the loop and its roles work, how to keep token costs down, and how to install and use Godot-Director, App-Director and SaaSAllTheThings. The blog at saemundsson.se explains why, and every page points to the post behind it; this site explains how. Each framework's repository stays the source of truth for its procedures.

**Who it's for:** anyone who wants to use AI coding agents to build software and stay in control of what gets built. The site is aimed at hands-on builders as the most likely first audience, but the framework is not limited to developers or tech leads.

**What a visit should lead to:** the reader installs one of the frameworks, or applies the roles, the loop and the check in their own setup.

**The feeling it should give:** calm, technical and trustworthy: a short, accurate reference in the same dark, one-accent look as the blog figures and LinkedIn cards.

## Scope

### Now: framework docs
The site is technical documentation and project orchestration. Promotional content, such as the LinkedIn material and graphics in `init/`, doesn't belong on it; pages link to the blog for the why.

### Later: playbook
How-to guides and a "Start here" playbook that guide technical users through installing and running a framework.

### Concepts
Each core concept of DDD gets its own page in a Concepts section, explained once and framework-neutral: Overview, Roles, Design calls, Agent development flow, The check, Reviews, Task and model sizing, Records in files, Code shaped for agents, Ownership, Align and drift reset, Built-in cost savings, and Cost tuning for developers. Concept pages explain the idea; skill pages cover the commands and link to their concept.

### Common skills
Every skill that all three frameworks ship gets its own page, to keep each one readable: `/next-task`, `/design`, `/align`, `/drift-reset`, `/prune` and `/refresh-model-sizing`. Each page describes what the skill does and how it works in all three, then has a section that lists what is unique to each repo. Skills only one framework ships stay on that framework's page.
- **Acceptance check:** one shared page covers `/acceptance` (App-Director, SaaSAllTheThings) and its Godot-Director counterpart `/function-check`, since they are the same concept under two names. `/playtest` and `/feedback` are listed as unique per repo. (confirmed by director: T21 2026-10-11)
- **Research:** `/research` gets a skill page once all three frameworks ship the research assistant (T34).
- **Release:** `/release` stays on the App-Director and SaaSAllTheThings pages while only two frameworks ship it, because it works differently in each. It gets a skill page once Godot-Director ships its release skill (T31). (confirmed by director: T21 2026-10-11)

### Built with App-Director
The site and its repository are built with App-Director: tasks in `TASKS.md`, design in `product/`, and one check before every commit. The home page and the README say so, which makes the repo a public example of the framework in use and a running test that it works.

### Identity
The mark is the Signal: one small filled D nested inside two outlined D's that share a spine, in the amber accent on the dark background. It stands for the director's call going out to the agents. The header logo and the favicon use the same mark.

### Licence
The site uses the same licence as the three frameworks: MIT, with the copyright notice "© 2026 Vikingur Saemundsson".

### Blog posts stay on the blog
Posts about the why, such as the anchoring post and the factories post, get no docs pages. Docs pages link to a post where it explains the why behind them.

### Later: orchestrator for the three frameworks
Once the director is happy with the docs side, the repository becomes the orchestrator for the three frameworks:
- The common skill pages become the anchors: the agreed behaviour of each shared skill, and the recorded differences per repo.
- A task here pushes tasks to each framework repo's own root `TASKS.md`, by pull request, and that repo's build agents make the changes. Each framework repo gets its own root queue before the first push; `project/TASKS.md` is the adopters' template and never receives these tasks.
- This repository acts as the auditor: it checks that the three repos stay aligned with the anchors.
- It is recursive: App-Director builds this repository, and this repository aligns App-Director along with the other two. The site mentions this once the orchestrator exists.

All orchestrator work waits for the director's go-ahead (T12).

### Planned framework changes
Changes the director has decided for the framework repos, carried out through the orchestrator. The docs describe a change only once it is released in its repo.
- **Released means a tagged GitHub release.** Every install path (the skill, the fetch scripts, and the plugin where its marketplace can pin a ref) gets the framework's latest release tag; `main` is where changes are integrated. Each release is tagged `v<version>`. The docs follow releases: the selftest checks them against each framework's latest release tag, not `main`.
- **One commit model in all three.** One task, one commit, with the pre-commit check as the gate. A single `/next-task` pauses for the director's approval of its commit. When the director asks for a run ("grab tasks until you're blocked", "work through the queue", "the next N tasks"), each task commits without pausing, and the run stops only when an item is blocked on the director, a build fails, or the director declines a commit. `git commit` is allowed in each framework's settings; pushing, deploying and changing cloud resources keep asking every time. Godot-Director and SaaSAllTheThings change to match App-Director.
- **All three get a research assistant.** When a design question is complex, or the director asks for research, a read-only `researcher` subagent researches the topic in a fresh context and reports back. It informs; the director decides: its options and recommendation feed a design call, and it never records a decision, edits the design documents or accepts an ADR.
  - **Research is a task type.** Research items get their own IDs, `R<n>`, like bugs. Instead of `Done when` they have `Question:` and, when they inform an open question, `Informs: Q<n>`. They are sized like any task, and the size picks the model. An item is done when its research note exists.
  - **Two ways to start:** on the fly, when the designer delegates or the director runs `/research`, the item is created and run at once; for later, the item is queued, and the tasks that depend on its outcome list it under `Depends on`. `/next-task` hands research items to the researcher instead of the builder. A finished item that informs a question makes that question ready for a design call; tasks that need the decision stay gated by the question.
  - **Research notes:** each item writes a dated note per topic in the project: the conclusion, the options, the sources with confidence, and the date the claims were verified. The decision log line links to it, so later sessions reuse it.
  - **One core, a domain file each:** the research procedure is the same in all three (the anchor, adapted from the director's portable research skill); each framework adds one reference file for its domain: Azure and the customer's security framework in SaaSAllTheThings; stacks, libraries and app-store requirements in App-Director; the Godot docs and engine version, asset licences and store requirements in Godot-Director.
  - **Evidence rules:** claims rest on sources actually read, primary sources first, with confidence labels and a verified-as-of date. The project's records supply the context. Confidential project text never goes to public search.
- **Godot-Director gets export and release, in two stages:**
  1. **Onboarding and `/export`.** Onboarding guides the director through the export settings Godot doesn't already have, such as the target platforms, and asks where exports should run: on the director's machine, in a build container (local or in a cloud), or on a hosted service such as GitHub Actions, with guidance to set it up. The director can skip this step. Skipping adds an open question to the GDD (which platforms to export to, and where exports run) and an item to set up exports that depends on it. The director runs the step later with `/design Q<n>`, and `/next-task` builds the setup; changing it later is a design session too. The skill is `/export`, following Godot's own term for producing a game's binaries.
  2. **CI and CD.** CI runs the Godot export on every change; CD releases builds to a platform's UAT branch and, if the director wants, promotes them to production.

## Core Flows

### Grasp DDD in one screen
A reader lands on the home page and comes away knowing the four roles, the four steps of the loop and the three frameworks, with a link to read more on each.

### Learn the concept
A reader works through the Concepts section, one concept per page, and can explain how a task goes from decision to commit, and when a review or a reset happens.

### Pick and install a framework
A reader compares the frameworks, opens the one that fits, and installs it with one of the listed install paths, knowing what its check enforces and which commands it ships.

### Cut token cost
A reader understands where tokens go, which savings the frameworks build in, and applies the tuning steps to their own sessions.

### Look up a skill
A reader opens the page for a shared skill and learns what it does in every framework, and what differs in the one they use.

### Follow a link from the blog
A reader arrives from a saemundsson.se post on the matching docs page, and can get back to the post that explains the why.

## Screens

| Screen | Purpose |
|---|---|
| Home | DDD in one screen: roles, loop, frameworks, links to the posts |
| Concepts (13 pages) | One page per core concept, from the overview to the two cost pages |
| Skills (6 pages) | One page per common skill: what it does, how it works, and what is unique to each repo |
| Frameworks (4 pages) | Comparison page, and one page per framework: check, install, commands, links |

## Open Questions

<!-- Undecided design questions. Format: Q<n>: question. The AI never answers these itself.
     Work that depends on one gets a PLACEHOLDER. Delete a question when it's decided. -->

Q3: Should the site use a custom domain (for example under saemundsson.se) instead of freakling.github.io? (later)

<!-- Next Q: 12 -->
