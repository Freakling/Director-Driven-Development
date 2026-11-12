# Could `/ui-design` take a design kept in Penpot or Figma as its source through the tool's own MCP server?
R10 · Informs: - · Verified as of 2026-11-12 · Size: M

## Question and assumptions
As the item states: accept a design kept in Penpot or Figma beside the Excalidraw drawing, using each tool's own MCP server and existing skills instead of a reader of our own. Scope: a web app on App-Director; Excalidraw stays the default; Godot-Director and SaaSAllTheThings only where the answer differs.
Assumptions:
- The director may or may not already design in one of the tools.
- "Bridge" means code in `/ui-design` (a reader beside `drawing.mjs`) that produces `drawing.json` schema 1 from the tool.
- "Bring your own" means the director's own agent session uses the vendor's server and skill, and nothing in App-Director changes.
- The Penpot half is carried over from the first pass (2026-11-12) and was not re-researched. The Figma half was researched today from Figma's developer documentation. Pages carry no dates unless stated.

## Conclusion
Both tools have an official MCP server that works for "bring your own" with no framework change, so a director who already designs in either can use it today. Neither server is a file reader. Penpot's is an agent-driven code runner inside an open browser tab. Figma's gives an agent structured read tools (metadata, design context, variables, screenshot) over a pasted frame link, and its answers are code-flavoured (React and Tailwind by default) rather than the boxes, intent and flows that `drawing.json` records. Neither design is a committed file by default, so a bridge would break the rule that `/ui-design` reads a protected file in `director/ui/`. Figma's read limits, its plan and seat rules and its terms make a Figma bridge costlier to depend on than a Penpot one. Confidence: High on what each server offers, Medium on the bridge costs (implications), Low on whether geometry maps cleanly (needs a spike).

## Options and trade-offs
Facts are marked F, implications I, judgment J.

Where the tools differ in a way that changes the answer:

| Point | Penpot | Figma |
|---|---|---|
| How the agent reaches the design | F: Plugin API code run in an open browser tab with the plugin connected; one tab, tab kept awake; focused page only | F: remote server reads a pasted "Copy link to selection" (node ID), no desktop app; desktop server at `127.0.0.1:3845/mcp` reads the Dev Mode selection and needs the app open |
| What it gives | F: whatever the agent's code reads (secondary article: tools `execute_code`, `high_level_overview`, `penpot_api_info`, `export_shape`, `import_image`; tokens in W3C draft format since 2.14) | F: `get_metadata` (XML outline: IDs, names, types, positions, sizes), `get_design_context` (React and Tailwind by default), `get_variable_defs`, `get_screenshot`, `download_assets` (PNG, JPG, SVG, PDF, remote only) |
| Account and seat | F: account or self-hosted instance, MCP key; which hosted plans include MCP is not found | F: Figma account. Remote read: Full or Dev seat for useful use, View or Collab seats limited to 20 calls a month. Desktop server: Dev or Full seat on a paid plan |
| Read limits | F: none found | F: Full or Dev seat: Professional 200 a day and 10 a minute, Organization 200 a day and 15 a minute, Enterprise 600 a day and 20 a minute; Starter with a Full or Dev seat: none (no access); "Figma may change rate limits at any time" |
| Maturity | F: in the main product since 2.15 (2026-04-20) after an open beta; neither README nor note labels it beta | F: no general-availability statement found; write-to-canvas is "free during the beta period"; Figma Specs and the skills are beta |
| Licence and terms | F: Penpot repository MPL 2.0; the `mcp` folder has no separate licence seen | F: MCP falls under Figma's Developer Terms (effective 2026-05-05): Figma may bar integrations that block write-back tool calls (4f), owns "any data derived from" its Services (8a), and may change rate limits on 30 days' notice (8e); a separate Figma AI Terms exists and was not read. The guide repo shows no licence |
| Committed, offline file | F: none by default; `.penpot` export exists, format not verified | F: REST `GET /v1/files/:key` returns the file as JSON (`document` tree, styles, components) with a personal access token (`X-Figma-Token`, scope `file_content:read`); `.fig` is binary (lead, not opened). I: a JSON snapshot could be committed, but only fetched with a live token |
| Self-hosting | F: possible (self-host steps not found) | F: not offered by any source opened |

Options, per tool and together:

| Option | Penpot | Figma | Both |
|---|---|---|---|
| Do nothing | Costs nothing; a director who designs there pastes screenshots by hand. Wins if no project asks. | Same | Same |
| Document "bring your own server and skill" | F: works now. Costs one page of setup (hosted: MCP key, plugin connected, tab open; local: Node 20+, `npx -y @penpot/mcp@latest`). I: the output is the agent's own reading, with no `drawing.json`, so `verify` compare images and the drawing hash don't apply. | F: works now (`claude mcp add --transport http figma https://mcp.figma.com/mcp`, sign in once, paste a frame link). Costs one page, plus a warning about seats and limits. I: same gap as Penpot; `get_design_context` returns code, which a spec step may over-trust. | One page with a table per tool, one rule: the design becomes intent in the spec (`shows:`, `does:`), not code copied from the tool. Wins when a project already designs in one. |
| Build a bridge in `/ui-design` | I: a second reader with its own run model (code run in a live tab), keys in client config, no committed file; Godot-Director's port must match or decline. Costs a new tool and a trust model. | I: more tractable reading (`get_metadata` gives positions and sizes; REST gives JSON), but needs a token or sign-in, is rate-limited by seat, and the design lives outside the repo. Needs a colour or layer-name convention for intent. | J: one bridge could share the back half (shape list to `rect_pct`, `parent`, `flows_to`, `overlaps`, write `drawing.json`, handling of intent and hash), but each needs its own front half, since the access models share nothing. A snapshot committed under `director/ui/` would need a gitleaks allowlist decision like the one on 2026-10-25. |

Judgment: the two tools differ most on access. Penpot can be self-hosted and has no read quota found; Figma is hosted only, seat-gated and rate-limited, with terms that favour Figma. Figma's structured read tools and JSON file are closer to what `drawing.js` needs than Penpot's code runner, so if a bridge is ever built, Figma's front half is easier and Penpot's cheaper to run.

## Recommendation
Document "bring your own server and skill" for both tools in one how-to page. Keep Excalidraw the default. Build no bridge until one real project has used either tool and wanted the drawing recorded. Reason: the vendors' servers already work, no committed file exists to protect, and the unknowns that decide a bridge (geometry mapping, intent convention) need a run.
What would change it: a project that designs in Figma or Penpot and finds hand-written intent too slow; Figma giving a stable GA and a documented offline export; a spike showing node geometry maps cleanly to `rect_pct`.
Proposed builder items (for the director to file): (1) a Figma spike, one real frame read with `get_metadata` and the REST file endpoint, checking mapping to `rect_pct`; (2) the Penpot spike from the first pass; (3) the how-to page.

## Sources
| Claim | Source | Type | Tier | Confidence |
|---|---|---|---|---|
| Penpot server in main product, tools read and modify through the Plugin API, agent runs code | penpot/penpot `mcp` README, github.com/penpot/penpot/tree/develop/mcp, read 2026-11-12 | Docs | 2 | High |
| Penpot five tool names; tokens exposed in 2.14 | dev.to/creeta article | Article | 4 | Medium |
| Penpot hosted setup, limits (focused page, one tab, plugin open, remote export limits), local mode | help.penpot.app/mcp, read 2026-11-12 | Docs | 2 | High |
| Penpot MPL 2.0; 2.15 moved the server into the app, 2026-04-20 | github.com/penpot/penpot LICENSE; penpot.app/release-notes/2-15-master-of-puppets | Repo, release note | 2 | High |
| Standalone `penpot/penpot-mcp` archived 2026-02-03 | secondary article | Article | 4 | Medium |
| Penpot community servers `montevive/penpot-mcp` (MIT), `ancrz/penpot-mcp-server` (Apache-2.0, reads PostgreSQL); skill `penpot-uiux-design` in `github/awesome-copilot` | their READMEs | Repo docs | 4 | Medium |
| Figma MCP overview: remote recommended, no desktop app; desktop needs Dev or Full seat on a paid plan; write-to-canvas free during beta; Specs in open beta; no GA statement; no page date | developers.figma.com/docs/figma-mcp-server/ | Docs | 2 | High (no date) |
| Figma tool list, remote-only marks, read versus write tools; `get_metadata` returns IDs, names, types, positions, sizes; `get_design_context` defaults to React and Tailwind; `create_design_system_rules` is a prompt | developers.figma.com/docs/figma-mcp-server/tools-and-prompts/ | Docs | 2 | High |
| Figma sign-in by browser "Allow access"; link-based reference; client catalog (and a waitlist, which conflicts with the "Other clients" section) | developers.figma.com/docs/figma-mcp-server/remote-server-installation/ | Docs | 2 | High; the catalog conflict is unresolved |
| Desktop endpoint `127.0.0.1:3845/mcp`, app open, Dev Mode, no write | developers.figma.com/docs/figma-mcp-server/local-server-installation/ | Docs | 2 | High |
| Rate limits (20 a month View and Collab; 200 a day and 10, 15, 20 a minute by plan; 600 a day for Enterprise; writes exempt; may change at any time) | developers.figma.com/docs/figma-mcp-server/rate-limits-access/ | Docs | 2 | High |
| CONFLICT: the guide README says Starter and View or Collab seats get 6 calls a month | github.com/figma/mcp-server-guide README | Repo docs | 2 | Unresolved; the developer docs page (20) is taken as the current one, but its date is not shown |
| Guide repo: plugin skills (implement designs, Code Connect, design-system rules) in beta, two workflow skills (`video-interaction-mapper`, `generate-project-plan`), no LICENSE file seen, use implies Developer Terms | github.com/figma/mcp-server-guide | Repo docs | 2 | High that no licence was shown; the 404 on the raw LICENSE URL supports it |
| REST file endpoints, scope `file_content:read`, JSON `document` tree, image URLs expire after 30 days; no plan or seat stated for GET | developers.figma.com/docs/rest-api/file-endpoints/ | Docs | 2 | High |
| PAT created in Settings, Security; sent in `X-Figma-Token`; scopes and expiry set at creation | developers.figma.com/docs/rest-api/personal-access-tokens/ and `/authentication/` | Docs | 2 | High |
| REST Tier 1: View and Collab up to 20 a month; Enterprise figure unclear | developers.figma.com/docs/rest-api/rate-limits/ | Docs | 2 | Medium |
| Figma Developer Terms effective 2026-05-05: MCP is a Developer Resource; 4f write-back; 8a derived data; 8e rate-limit changes on 30 days' notice | figma.com/legal/developer-terms/ | Terms | 1 | Medium (via a summarising fetch; legal reading needs the owner) |
| Project side: the procedure, the reader header, drawing schema 1, protected `director/ui/`, `.gitleaks.toml` allowlist for `director/ui/*.excalidraw` (2026-10-25), Excalidraw chosen 2026-10-16, no mention of Penpot or Figma | `work/App-Director/framework/.app-director/procedures/ui-design.md`, `tools/ui/drawing.mjs`, `product/decisions.md` (as read in the first pass) | Project records | 1 to 2 | High (not reread today) |

## Open gaps
- Figma: no overall general-availability statement found; no documentation date on any page; the 6 versus 20 monthly calls conflict; the Figma AI Terms were not read, so whether they bear on an agent reading a design is unknown (legal reading belongs to the owner); the `figma-spec` skill and the full skill list of the plugin were not opened; the `.fig` format and the REST PAT's plan requirement were not verified; the "Sources disagreed on seats" lead: the docs put Full or Dev seats at real limits and View or Collab at 20 a month, desktop needs Dev or Full.
- Penpot (carried over, unchanged): not opened: Plugin API reference, `.penpot` export format, backend API access tokens, 2.17 release note, `penpot-atomic-design`, any licence for the skill; the `mcp` folder's own licence and the exact tool list from the official source are unknown; which hosted plans include MCP is unknown; self-host steps not found.
- Needs a run: whether either tool's geometry maps to `rect_pct` and intent (the two spikes above); whether Figma's `get_metadata` positions are absolute or parent-relative was not checked.
- Effect on the conclusion: none of these gaps changes the recommendation to document and wait; they would matter only if a bridge is chosen.
