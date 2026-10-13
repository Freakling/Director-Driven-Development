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
The site is framework documentation first. A small amount of promotional content is in scope, as long as it points to the why on the blog rather than repeating it.

### Concepts
Each core concept of DDD gets its own page in a Concepts section, explained once and framework-neutral: Overview, Roles, Design calls, Agent development flow, The check, Reviews, Task and model sizing, Records in files, Code shaped for agents, Ownership, Align and drift reset, Built-in cost savings, and Cost tuning for developers. Concept pages explain the idea; skill pages cover the commands and link to their concept.

### Common skills
Every skill that all three frameworks ship gets its own page, to keep each one readable: `/next-task`, `/design`, `/align`, `/drift-reset`, `/prune` and `/refresh-model-sizing`. Each page describes what the skill does and how it works in all three, then has a section that lists what is unique to each repo. Skills only one framework ships stay on that framework's page.
- **Acceptance check:** one shared page covers `/acceptance` (App-Director, SaaSAllTheThings) and its Godot-Director counterpart `/function-check`, since they are the same concept under two names. `/playtest` and `/feedback` are listed as unique per repo. (confirmed by director: T21 2026-10-11)
- **Release:** `/release` stays on the App-Director and SaaSAllTheThings pages while only two frameworks ship it, because it works differently in each. It gets a skill page once Godot-Director ships its release skill (T19). (confirmed by director: T21 2026-10-11)

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
- **Godot-Director gets build and release skills:** one exports the game's binaries for specific platforms; the other triggers the build pipelines that push builds to the platforms. Details are open (Q8, Q9).

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
Q4: Which promotional content belongs on the site (for example a list of posts, talks and workshops, or a "work with me" invitation), and where does it go?
Q8: For Godot-Director's build and release: which platforms and stores come first (for example Windows, macOS, Linux, web, Android, iOS; itch.io, Steam, the mobile stores), and which pipeline host runs the builds (for example GitHub Actions)? (later, orchestrator)
Q9: What should Godot-Director's build skill be called? `/build` would share its name with the `build.md` procedure the builder already follows; `/export` matches Godot's own term. (later, orchestrator)

<!-- Next Q: 10 -->
