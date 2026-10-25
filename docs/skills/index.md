# Skills

<div class="kicker">Common commands</div>

> Each skill is a named command that runs a procedure. The procedure is the source of truth; the skill is the shortcut that invokes it.

Every framework ships a core set of skills that work the same way across all three repositories. These pages describe what each skill does and how it differs by framework. Skills that only one framework ships stay on that framework's page.

## The common skills

| Skill | What it does |
|---|---|
| [/next-task](next-task.md) | Pick the next ready item, build it, prove it and commit |
| [/design](design.md) | Run a design session, record the decisions and open questions |
| [/ui-design](ui-design.md) | Capture the screens for you to draw over, record each layout in a spec and check the built screen against it |
| [/research](research.md) | A read-only researcher answers one question in a fresh context and writes a dated note |
| [/align](align.md) | Check whether the codebase matches the design, and flag what doesn't |
| [/drift-reset](drift-reset.md) | Reset a principle that has been built two different ways back to one |
| [/prune](prune.md) | Remove dead code, stale items and obsolete records |
| [/refresh-model-sizing](refresh-model-sizing.md) | Update the per-size model map in AGENTS.md from the current best options |
| [/release](release.md) | Check the build, prepare the target, and ship it with the human's approval |
| [Acceptance check](acceptance.md) | Prove every (demo) outcome and pass the check before a release |

## How skills work

A skill is a short file that reads a procedure and follows it. The procedure lives in the framework repository and is the only source of truth for that skill's behaviour. The skill page here describes the behaviour and links to the procedure; it doesn't copy it.

In Claude Code, skills appear as slash commands. In other assistants, they work the same way: the skill file is passed to the assistant with the user's request.

<div class="takeaway"><span>The procedure is the contract; the skill is the shortcut.</span><span class="url"><a href="https://github.com/Freakling">github.com/Freakling</a></span></div>
