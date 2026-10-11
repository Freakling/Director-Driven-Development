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
