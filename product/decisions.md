# Decisions

<!-- Append-only. Format: YYYY-MM-DD · decision · why
     One line per decision. The AI reads this to avoid re-proposing what was decided against.

Examples:
2026-10-05 · chose React Native over Flutter · existing team TypeScript experience
2026-10-05 · local-first storage with sync · works offline, sync on reconnect
-->
2026-10-10 · one central docs repo, Freakling/Director-Driven-Development, on GitHub Pages · one place for the how; the blog keeps the why
2026-10-10 · framework repos stay the source of truth; pages link to their READMEs and procedures instead of copying them · copies drift
2026-10-10 · a selftest fails on en or em dashes, broken links and undocumented framework commands, run in CI on every push · the docs can't silently fall behind the frameworks
2026-10-11 · MkDocs with the Material theme, styled with the DDD tokens · director's choice over Jekyll
2026-10-11 · fonts self-hosted from the graphical profile (Archivo, IBM Plex Mono) · same look as the graphics, no third-party font requests
2026-10-11 · App Director manages the site; stack none, with the selftest as tools/check.local.sh · the same loop the site describes, and one check for both
2026-10-11 · the agent owns every work area, including copy, visual design and deployment · director's choice at onboarding
2026-10-11 · model sizing on with the Claude Code defaults (Haiku XS-S, Sonnet M, Opus L-XL) · director's choice at onboarding
2026-10-11 · the repo is framework docs first, with a little promotional content that points to the why on the blog · director's choice; the blog keeps the why
2026-10-11 · later, the repo becomes the orchestrator that keeps the three frameworks' shared skills in parity and tracks their differences · director's direction; the docs come first
2026-10-11 · audience: hands-on builders; a visit should lead to installing a framework or applying the method in their own setup · director's choice
2026-10-12 · the framework is for anyone who wants to use AI coding agents to build software and stay in control of what gets built; the docs site is pitched at hands-on builders as the most likely first adopters, but the audience is not limited to developers or tech leads · director's clarification
2026-10-11 · the site uses the MIT licence, the same as the three frameworks · director's choice: one licence across all repos
2026-10-11 · no docs pages for the anchoring and factories posts · they explain the why, which belongs on the blog
2026-10-11 · one docs page per skill that all three frameworks ship, each with a section for what is unique per repo · readable pages, and the base for keeping the repos aligned
2026-10-11 · later, the skill pages are the anchors: tasks here are pushed to each framework repo for its build agents, and this repo audits alignment · director's direction for the orchestrator
2026-10-11 · orchestrator work waits for the director's go-ahead · the docs side comes first
2026-10-11 · a Concepts section with one page per core concept (13 pages), cost split into built-in savings and tuning for developers · readable pages, one idea each
2026-10-11 · concept pages explain the idea framework-neutral; skill pages cover the commands per framework and link to their concept · no repeated information
2026-10-11 · concepts are restructured before the skill pages are written · skill pages link to settled concept pages
2026-10-11 · Godot-Director gets build and release skills: export binaries per platform, and trigger pipelines that push builds to the platforms · director's choice; makes release common to all three frameworks
2026-10-11 · Q6: one Acceptance check skill page covering /acceptance and /function-check; /release stays on the framework pages until all three ship it · agent's call at the director's request, to review later (T21)
2026-10-11 · the home page and README say the repo is built with App-Director: a public example of the framework and a self-check that it works · director's direction
2026-10-11 · the orchestrator is recursive: it aligns App-Director, which builds this repo, along with the other two; the site mentions it once it exists · director's direction; never overclaim
2026-10-11 · the mark is the Signal: a filled D inside two outlined D's sharing a spine, replacing the three D's in a row · director's choice from four sketches; one clear shape at favicon size
2026-10-12 · Q7: tasks reach framework repos via pull request, not direct commit · director retains control of the merge
2026-10-12 · the agent may never merge a pull request; code review and comments are permitted, but merge is a human-owned control · director's rule, applies to all repos
2026-10-12 · the site's tone and feel: calm, technical and trustworthy, in the same dark one-accent look as the blog figures and LinkedIn cards · confirmed by director
2026-10-13 · alignment tasks land in each framework repo's own root TASKS.md, set up before the first push; never in project/TASKS.md · director's choice: each repo runs the loop with its own build agents, and the template stays clean for adopters
2026-10-15 · Q4: no promotional content on the site; it is technical documentation and project orchestration, with how-to guides and a Start here playbook for technical users later · director's choice; the LinkedIn material stays out
2026-10-15 · Q9: Godot-Director's skill is /export · follows Godot's own term for producing a game's binaries
2026-10-15 · Q8: Godot-Director onboarding asks for missing export settings (target platforms) and where exports run (local, a build container, or hosted CI such as GitHub Actions), and can be deferred; CI (export) and CD (release to a UAT branch, optional promotion to production) come in a later stage · director's choice
2026-10-15 · all three frameworks get a research assistant: a read-only researcher subagent that the designer delegates to, plus /research for the director; it informs and never decides · director's choice; same pattern as builder and reviewer, keeps the design session's context small
2026-10-15 · research is a task type with its own IDs (R<n>), Question: and Informs: Q<n> instead of Done when; started on the fly or queued for later, with dependent tasks blocked on it · director's choice; research flows through the same queue as any work
2026-10-15 · each research item writes a dated note per topic, linked from the decision log · records in files: later sessions reuse the evidence instead of redoing it
2026-10-15 · one shared research core in all three frameworks (the anchor, adapted from the director's portable research skill), plus one domain reference file per framework · same model as the other common skills; easy to align and audit
2026-10-15 · research items are sized like tasks and the model map picks the model · cost follows complexity
2026-10-15 · one commit model in all three frameworks, App-Director's: a single /next-task pauses for approval; a run the director asks for ("grab tasks until you're blocked") commits each task without pausing and stops when blocked, on a failed build or a declined commit; git commit allowed, push and deploy still ask · director's choice; Godot-Director's settings asked on every commit despite its procedure, and SaaSAllTheThings had no run mode
2026-10-15 · SaaSAllTheThings follows the same commit model · commits are local and reversible; pushing, deploying and Azure changes keep asking, and risky items are reviewed before their commit
2026-10-15 · Q11: released means a tagged GitHub release; every install path gets the latest release tag, and the docs and selftest follow the latest release, not main · director's choice: users always get a tested, documented version
