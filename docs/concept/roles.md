# Roles

Four roles share the work. Only one of them is human.

| Role | Who | Does | Never |
|---|---|---|---|
| **Director** | You | Decides design and priorities, accepts the result, approves commits. Has the final say on everything | |
| **Orchestrator** | The main session | Picks the next task, records the director's decisions, hands builds off, updates the records | Reads the code being changed |
| **Builder** | A subagent with a fresh context | Builds one task, runs the check, returns a structured report of about 20 lines | Fixes things outside its task; it reports them instead |
| **Reviewer** | A read-only subagent with a fresh context | Checks a finished change against its task, the rules and the tests, and returns ranked findings | Edits code |

## The director

The agent proposes. The director decides. Design calls come to the director as 2 to 4 options with a recommendation, and the director can always write their own answer. Anything undecided goes on an open-questions list, and values the director hasn't set stay marked `PLACEHOLDER`.

Each framework names what the director owns. In Godot-Director that is design, balance, art direction and playtesting. In App-Director it is the product vision, design and testing the running app. In SaaSAllTheThings it is the product, the customers, which system owns which data, and accepting ADRs; the architecture belongs to the framework.

## The orchestrator

The orchestrator keeps the session small. It starts with `AGENTS.md` and the framework's rules, loads each procedure only when it's used, and keeps only the builder's report after each task. See [Built-in cost savings](cost-built-in.md) for what that saves.

## The builder

Each task gets a new builder with an empty context. It reads the files the task names, builds, runs the check and reports back. The report fields are the only channel back to the orchestrator.

## The reviewer

The reviewer runs only where a mistake is expensive. See [Reviews](reviews.md) for the triggers in each framework. The same read-only agent analyses the system as built during a [drift reset](drift.md) in Godot-Director and App-Director.

## Without subagents

The core of each framework is tool-neutral: the rules, the procedures, the check and the git pre-commit hook work with any assistant that reads `AGENTS.md`. Fresh-context builds, the reviewer, model sizing and the hooks that block risky commands need an assistant that supports subagents and hooks.

<div class="takeaway"><span>A director doesn't need to act. A director needs to recognize a good take.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
