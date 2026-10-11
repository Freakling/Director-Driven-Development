# Built-in cost savings

<div class="kicker">The principle</div>

AI coding agents are billed by the token, and most tokens aren't spent writing code: they're spent re-reading context. The three frameworks are built to keep that bill down from the start. This page covers what they do automatically; [Cost tuning for developers](cost-tuning.md) covers what you can change on top.

## Lean instructions, loaded on demand

A session starts with two files: the project's `AGENTS.md` and the framework's rules, about 10 to 14 KB together depending on the framework. That is the only part loaded into every session.

Everything else loads when it's used. Each command, such as `/next-task` or `/design`, is a short pointer to a procedure file, and the procedure is read only when the command runs. The task format is read only when a task is written. In SaaSAllTheThings, the reference architecture is one file per topic (tenancy, identity, messaging, cost and so on), and the agent reads only the topics a task touches.

## A fresh builder context per task

The main session never builds anything itself. It hands each task to a builder subagent that starts with an empty context, so nothing from earlier tasks is carried along and paid for again. The builder reads only what its task names, by heading or line range, and its context is thrown away when it's done.

## An orchestrator that only reads reports

The orchestrator never reads the code being changed. A builder returns a structured report of about 20 lines, and that report is all the orchestrator keeps. Source files, test output and check logs stay in the builder's context and disappear with it. A session that works through ten tasks holds ten short reports, and stays about as lean as one that worked through one.

## Sizing, escalation and the two-attempt limit

Every task is sized before it's built, and the size picks the model: the bigger model is paid for only when the task needs it, or when the smaller one couldn't do the job. After two failed attempts at the same problem, the agent stops and reports, which caps the cost of a runaway loop. See [Task and model sizing](sizing.md).

## Reviews only where the risk is

An independent review reads the change, the task and the rules all over again in a fresh context. The frameworks run one only where a mistake is expensive. See [Reviews](reviews.md).

## Records in files, so sessions can be cleared

Everything a session needs lives in plain files in the repo: the design document, the decision log, the task list, the architecture table and the commit history. Once a task is committed, clearing the session loses nothing. A task interrupted halfway gets a one-line `Note:` in the task list, and the next session picks it up from there. After a design session the conversation has no value left, because every decision is in the files, and the procedure reminds you to clear before the next topic.

## Task pruning

Every session reads the task list to find the next task. `/prune` moves finished tasks from `TASKS.md` to `TASKS-archive.md`, so the list every session reads holds only what's still open. Tasks can still depend on archived ones; `/next-task` looks them up in the archive.

## Check result caching

The check runs before commits and, in Claude Code, before the agent ends its turn. Two things keep it from running more than needed. The pre-commit hook runs it only when a commit touches code, so commits that only change documentation skip it. And `bash tools/check.sh --if-changed` fingerprints the files it covers: when nothing has changed since the last run, it repeats the last result at once instead of building and testing again.

## Small files and scoped reads

The frameworks shape code as many small, single-purpose files. A task names exactly the files it touches, and the builder reads a few hundred lines instead of a few thousand. SaaSAllTheThings also enforces it: the check fails source files over 300 lines and Azure Function hosts over 80 lines by default, both set in `tools/check.cfg`.

<div class="takeaway"><span>Spend tokens on judgement, not on context.</span><span class="url" markdown="span">[Cost tuning for developers](cost-tuning.md)</span></div>
