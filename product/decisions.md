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
