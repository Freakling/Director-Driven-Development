# Cost tuning for developers

<div class="kicker">The principle</div>

The frameworks set sensible defaults. These are the things you can adjust yourself, on top of the built-in savings. The adjustments are based on the frameworks and on the Claude Code documentation. For what the frameworks do automatically, see [Built-in cost savings](cost-built-in.md).

## Clear between topics

Use `/clear` whenever you switch to unrelated work: after a design session, after a batch of tasks, before a new topic. Stale context is paid for again with every message. To come back to a conversation later, name it with `/rename` before clearing and return with `/resume`.

Prefer clearing to compacting. `/compact` sends the whole conversation to be summarised, and after a break it reprocesses all of it. `/clear` costs nothing. When you do compact, say what to keep, for example `/compact Focus on the open decisions and the failing test`.

## Segment your sessions

- **One session per role.** Run design and building in separate sessions. Any two sessions that build at once each get their own git worktree, and only one session per project picks items from the queue ([how](../how-to/build.md#two-sessions-that-build-at-once)).
- **One design topic per session.** Clear after each design session's commit.
- **Work through the queue in batches.** The orchestrator stays lean, but it still grows a little with every report. Clear after a batch, for example at the end of a milestone.
- **Plan by stage.** Plan one stage at a time, and run `/prune` when a stage is done.

## Tune the model map

Run `/refresh-model-sizing` and adjust the map to your budget. Moving L to Sonnet is an easy saving; a failed build still escalates one size up. Without access to Opus, map L and XL to Sonnet. Keep the main session on Sonnet unless you're in a hard design or architecture session: a session switched to Opus also builds the sizes with no entry on Opus, because their launches pass the session's model explicitly.

The orchestrator's model is the biggest single lever: in the [measured projects](https://saemundsson.se/2026/10/19/what-directing-ai-agents-costs/) on saemundsson.se, sizing the builders saved about 9 percent against all-Opus, while running everything on Sonnet, orchestrator included, would have cost a third to a half of what the projects actually did.

## Size tasks smaller and name fewer files

When in doubt, pick the smaller size; escalation catches the tasks that turn out harder. Split L and XL tasks so most work runs on the cheaper tiers. Keep `Touches` narrow: a task that names three files costs less than one that names a folder.

## Keep always-loaded instructions small

`AGENTS.md` and `CLAUDE.md` load into every session, and so does anything they import with `@`. Put only project-wide facts in Project rules. Move instructions for one workflow, such as a release checklist, into a skill, which loads only when it's used. The [Claude Code memory guide](https://code.claude.com/docs/en/memory) recommends keeping each `CLAUDE.md` under 200 lines.

## Filter verbose output before the agent reads it

A hook can preprocess a command's output before the agent sees it. The Claude Code cost guide shows a hook that rewrites test commands to return only failures, turning tens of thousands of tokens into a few hundred. The same idea works for build logs and for project-specific steps in `tools/check.local.sh`: print what failed and where, not everything that passed.

## Trim your tools

Run `/mcp` and disable MCP servers you aren't using. Prefer command-line tools like `gh` and `az` where they exist; they add nothing to the context until they're used. For typed languages such as C#, TypeScript or Python, a code intelligence plugin lets the agent jump to a definition instead of searching and reading several candidate files.

## Lower the thinking effort for routine work

Thinking tokens are billed as output tokens. For routine sessions, lower the effort level with `/effort` or in `/model`, and keep the higher effort for design calls and hard bugs. Pick the model and effort at the start of a session: on some models and providers, changing either mid-session rebuilds the cache.

## Mind the cache

Claude Code caches the repeated start of each request, and the cache expires after a period of inactivity. On a subscription, within the plan's usage, the main conversation's cache lasts an hour; with usage credits, an API key or a cloud provider, it lasts five minutes by default. Subagents, including the builders, get five minutes unless you set a longer TTL. The [prompt caching guide](https://code.claude.com/docs/en/prompt-caching) has the settings.

The first message after a longer break reprocesses the whole context. Finish the current task and clear before a break, rather than coming back to a large, cold session. Scheduled tasks and loops send the session's full context on every run.

## Stop early

If an agent heads in the wrong direction, press Escape at once instead of letting it finish. `/rewind` restores the conversation and the code to an earlier point. For an unclear task, ask for a plan first; a wrong direction caught in a plan is far cheaper than one caught in a finished build.

## Measure, then tune

- `/usage` shows what the session has cost and how much of the input came from the cache. On a subscription plan it also shows how much of your recent usage went to skills, subagents and MCP servers.
- `/context` shows what is filling the context window right now.
- `/insights` analyses your recent sessions and points out friction, such as misunderstood requests.
- [`tools/usage.py`](https://github.com/Freakling/Director-Driven-Development/blob/main/tools/usage.py) in the Director-Driven Development repository prices a project's Claude Code transcripts at dated API rates, by token kind and by session.

Tune what the numbers point at, not what feels expensive.

## Sources

- [Manage costs effectively](https://code.claude.com/docs/en/costs), [How Claude Code uses prompt caching](https://code.claude.com/docs/en/prompt-caching) and [How Claude remembers your project](https://code.claude.com/docs/en/memory), Claude Code documentation
- [App-Director](https://github.com/Freakling/App-Director), [Godot-Director](https://github.com/Freakling/Godot-Director) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings): README, Context and token use, the framework rules, and the next-task, build, review and prune procedures
- [What directing AI agents costs: three projects, measured](https://saemundsson.se/2026/10/19/what-directing-ai-agents-costs/) on saemundsson.se: the measurement behind the figures on this page and on [Built-in cost savings](cost-built-in.md)

<div class="takeaway" markdown><span>Spend tokens on judgement, not on context.</span><span class="url" markdown="span">[Built-in cost savings](cost-built-in.md)</span></div>
