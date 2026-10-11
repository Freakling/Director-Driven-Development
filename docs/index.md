---
hide:
  - toc
---

<div class="kicker">Director-Driven Development</div>

# You direct. Agents build. A check proves every task.

Director-Driven Development is a way of working with AI coding agents. The human is the director: design, priorities, acceptance and the final say. Agents build one small task at a time in a fresh context, and one automatic check decides when a task is done. Creativity, inside a frame.

## The roles

<div class="ddd-cards" markdown>
<div class="ddd-card ddd-card--highlight" markdown>
<span class="tag tag--primary">You · the director</span>

### Director
Design, priorities, acceptance. Final say.
</div>
<div class="ddd-card" markdown>
<span class="tag tag--tertiary">Main session</span>

### Orchestrator
Picks tasks, records decisions, hands off builds. Never reads the code being changed.
</div>
<div class="ddd-card" markdown>
<span class="tag tag--tertiary">Subagent</span>

### Builder
Builds one task in a fresh context and returns a short report.
</div>
<div class="ddd-card" markdown>
<span class="tag tag--tertiary">Subagent, read-only</span>

### Reviewer
Reviews large and risky changes in a fresh context, before the commit.
</div>
</div>

More in [Roles](concept/roles.md).

## The loop

<div class="ddd-cards" markdown>
<div class="ddd-card" markdown>
<span class="step">01</span>

### Decide
The agent proposes options. The director decides.
</div>
<div class="ddd-card" markdown>
<span class="step">02</span>

### Build
One sized task, one fresh builder.
</div>
<div class="ddd-card" markdown>
<span class="step">03</span>

### Prove
The check passes, or the task isn't done.
</div>
<div class="ddd-card ddd-card--highlight" markdown>
<span class="step">04</span>

### Commit
One task, one commit.
</div>
</div>

More in [The loop](concept/loop.md).

## Three frameworks, one model

The same loop runs all three. Only the rules the check enforces change.

<div class="ddd-cards" markdown>
<div class="ddd-card" markdown>
### [Godot-Director](frameworks/godot-director.md)
Games in Godot 4. The check fails when a screen script holds game rules.
</div>
<div class="ddd-card" markdown>
### [App-Director](frameworks/app-director.md)
Small web, mobile and desktop apps, on TypeScript, Flutter or Python.
</div>
<div class="ddd-card" markdown>
### [SaaSAllTheThings](frameworks/saasallthethings.md)
Multi-tenant B2B SaaS on Azure, with an architecture the check enforces.
</div>
</div>

All three are MIT licensed, run locally, and work with any AI coding assistant that reads `AGENTS.md`. They are built and tested on Claude Code.

## Built with App-Director

This site is built with [App-Director](frameworks/app-director.md). Every change is a task in its [`TASKS.md`](https://github.com/Freakling/Director-Driven-Development/blob/main/TASKS.md), design decisions are recorded in [`product/`](https://github.com/Freakling/Director-Driven-Development/tree/main/product), and one check passes before every commit. The repository is a public example of the framework in use, and a running test that it works.

## Read more

- The idea behind it: [Director-Driven Development](https://saemundsson.se/2026/10/07/director-driven-development/) on saemundsson.se.
- A worked example: [Build a B2B SaaS on Azure with Director-Driven Development](https://saemundsson.se/2026/10/09/build-a-b2b-saas-on-azure-with-director-driven-development/).
- Where the tokens go, and how the frameworks keep the bill down: [Built-in cost savings](concept/cost-built-in.md) and [Cost tuning for developers](concept/cost-tuning.md).

<div class="takeaway"><span>The agent proposes. The director decides.</span><span class="url">saemundsson.se</span></div>
