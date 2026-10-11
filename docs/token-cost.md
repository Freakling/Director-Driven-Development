# Token cost optimisation

AI coding agents are billed by the token, and most tokens aren't spent writing code. They're spent re-reading context: the conversation so far, the files the agent opened and the output of the commands it ran, sent again with every request. As [Claude Code's cost guide](https://code.claude.com/docs/en/costs) puts it, token costs scale with context size.

The three frameworks have the same cost optimisations built in. This page describes each one, then what you can tune yourself on top of them.

## Built into the frameworks

### Lean instructions, loaded on demand

A session starts with two files: the project's `AGENTS.md` and the framework's rules, about 10 to 14 KB together depending on the framework. That is the only part loaded into every session.

Everything else loads when it's used. Each command, such as `/next-task` or `/design`, is a short pointer to a procedure file, and the procedure is read only when the command runs. The task format is read only when a task is written. In SaaSAllTheThings, the reference architecture is one file per topic (tenancy, identity, messaging, cost and so on), and the agent reads only the topics a task touches.

### A fresh builder context per task

The main session never builds anything itself. It hands each task to a builder subagent that starts with an empty context, so nothing from earlier tasks is carried along and paid for again. The builder reads only what its task names, by heading or line range, and its context is thrown away when it's done.

### An orchestrator that only reads reports

The orchestrator never reads the code being changed. A builder returns a structured report of about 20 lines, and that report is all the orchestrator keeps. Source files, test output and check logs stay in the builder's context and disappear with it. A session that works through ten tasks holds ten short reports, and stays about as lean as one that worked through one.

### Sizing, escalation and the two-attempt limit

Every task is sized before it's built, and the size picks the model: the bigger model is paid for only when the task needs it, or when the smaller one couldn't do the job. After two failed attempts at the same problem, the agent stops and reports, which caps the cost of a runaway loop. See [Task and model sizing](concept/sizing.md).

### Reviews only where the risk is

An independent review reads the change, the task and the rules all over again in a fresh context. The frameworks run one only where a mistake is expensive. See [Reviews](concept/reviews.md).

### Records in files, so sessions can be cleared

Everything a session needs lives in plain files in the repo: the design document, the decision log, the task list, the architecture table and the commit history. Once a task is committed, clearing the session loses nothing. A task interrupted halfway gets a one-line `Note:` in the task list, and the next session picks it up from there. After a design session the conversation has no value left, because every decision is in the files, and the procedure reminds you to clear before the next topic.

### Task pruning

Every session reads the task list to find the next task. `/prune` moves finished tasks from `TASKS.md` to `TASKS-archive.md`, so the list every session reads holds only what's still open. Tasks can still depend on archived ones; `/next-task` looks them up in the archive.

### Check result caching

The check runs before commits and, in Claude Code, before the agent ends its turn. Two things keep it from running more than needed. The pre-commit hook runs it only when a commit touches code, so commits that only change documentation skip it. And `bash tools/check.sh --if-changed` fingerprints the files it covers: when nothing has changed since the last run, it repeats the last result at once instead of building and testing again.

### Small files and scoped reads

The frameworks shape code as many small, single-purpose files. A task names exactly the files it touches, and the builder reads a few hundred lines instead of a few thousand. SaaSAllTheThings also enforces it: the check fails source files over 300 lines and Azure Function hosts over 80 lines by default, both set in `tools/check.cfg`.

## Tuning for the developer

The frameworks set sensible defaults. These are the things you can change yourself, based on the frameworks and on the Claude Code documentation.

### Clear between topics

Use `/clear` whenever you switch to unrelated work: after a design session, after a batch of tasks, before a new topic. Stale context is paid for again with every message. To come back to a conversation later, name it with `/rename` before clearing and return with `/resume`.

Prefer clearing to compacting. `/compact` sends the whole conversation to be summarised, and after a break it reprocesses all of it. `/clear` costs nothing. When you do compact, say what to keep, for example `/compact Focus on the open decisions and the failing test`.

### Segment your sessions

- **One session per role.** Run design and building in separate sessions, in separate git worktrees (`git worktree add`, then `bash tools/setup-clone.sh` there). The `in-progress` claim in `TASKS.md` keeps them off the same task.
- **One design topic per session.** Clear after each design session's commit.
- **Work through the queue in batches.** The orchestrator stays lean, but it still grows a little with every report. Clear after a batch, for example at the end of a milestone.
- **Plan by stage.** Plan one stage at a time, and run `/prune` when a stage is done.

### Tune the model map

Run `/refresh-model-sizing` and adjust the map to your budget. Moving L to Sonnet is an easy saving; a failed build still escalates one size up. Without access to Opus, map L and XL to Sonnet. Keep the main session on Sonnet unless you're in a hard design or architecture session: a session switched to Opus also passes Opus to any subagent that inherits the session's model, such as a size with no entry.

### Size tasks smaller and name fewer files

When in doubt, pick the smaller size; escalation catches the tasks that turn out harder. Split L and XL tasks so most work runs on the cheaper tiers. Keep `Touches` narrow: a task that names three files costs less than one that names a folder.

### Keep always-loaded instructions small

`AGENTS.md` and `CLAUDE.md` load into every session, and so does anything they import with `@`. Put only project-wide facts in Project rules. Move instructions for one workflow, such as a release checklist, into a skill, which loads only when it's used. The [Claude Code memory guide](https://code.claude.com/docs/en/memory) recommends keeping each `CLAUDE.md` under 200 lines.

### Filter verbose output before the agent reads it

A hook can preprocess a command's output before the agent sees it. The cost guide shows a hook that rewrites test commands to return only failures, turning tens of thousands of tokens into a few hundred. The same idea works for build logs and for project-specific steps in `tools/check.local.sh`: print what failed and where, not everything that passed.

### Trim your tools

Run `/mcp` and disable MCP servers you aren't using. Prefer command-line tools like `gh` and `az` where they exist; they add nothing to the context until they're used. For typed languages such as C#, TypeScript or Python, a code intelligence plugin lets the agent jump to a definition instead of searching and reading several candidate files.

### Lower the thinking effort for routine work

Thinking tokens are billed as output tokens. For routine sessions, lower the effort level with `/effort` or in `/model`, and keep the higher effort for design calls and hard bugs. Pick the model and effort at the start of a session: on some models and providers, changing either mid-session rebuilds the cache.

### Mind the cache

Claude Code caches the repeated start of each request, and the cache expires after a period of inactivity. On a subscription, within the plan's usage, the main conversation's cache lasts an hour; with usage credits, an API key or a cloud provider, it lasts five minutes by default. Subagents, including the builders, get five minutes unless you set a longer TTL. The [prompt caching guide](https://code.claude.com/docs/en/prompt-caching) has the settings.

The first message after a longer break reprocesses the whole context. Finish the current task and clear before a break, rather than coming back to a large, cold session. Scheduled tasks and loops send the session's full context on every run.

### Stop early

If an agent heads in the wrong direction, press Escape at once instead of letting it finish. `/rewind` restores the conversation and the code to an earlier point. For an unclear task, ask for a plan first; a wrong direction caught in a plan is far cheaper than one caught in a finished build.

### Measure, then tune

- `/usage` shows what the session has cost and how much of the input came from the cache. On a subscription plan it also shows how much of your recent usage went to skills, subagents and MCP servers.
- `/context` shows what is filling the context window right now.
- `/insights` analyses your recent sessions and points out friction, such as misunderstood requests.

Tune what the numbers point at, not what feels expensive.

## Sources

- [Manage costs effectively](https://code.claude.com/docs/en/costs), [How Claude Code uses prompt caching](https://code.claude.com/docs/en/prompt-caching) and [How Claude remembers your project](https://code.claude.com/docs/en/memory), Claude Code documentation
- [Godot-Director](https://github.com/Freakling/Godot-Director), [App-Director](https://github.com/Freakling/App-Director) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings): README › Context and token use, the framework rules, and the next-task, build, review and prune procedures

<div class="takeaway"><span>Spend tokens on judgement, not on context.</span><span class="url">saemundsson.se</span></div>
