# Records in files

Nobody holds the project in their head, human or agent. Everything that matters lives in a few plain files in the repository, and every session starts by reading them. These files are the records.

## The records

| Record | Holds | Changes when |
|---|---|---|
| `TASKS.md` | Work, bugs and milestones, with their status and the files each one touches | A task is added, claimed, finished or reprioritised |
| `product/brief.md` | What the app should be, in sections, plus the open questions | The director makes a design call or settles a question |
| `product/decisions.md` | Why a design decision was made, one line each, appended and never rewritten | A design call is decided |
| `AGENTS.md` | The systems that exist, what each one owns, and the project rules | A system is added, moved or re-scoped |
| Commit messages | Why each change was made | Every commit |

The file names above are the ones App-Director uses. Every framework keeps the same kinds of record under its own names: a task list, a design document, a decision log and an architecture table. See [Frameworks](../frameworks/index.md).

## One home per fact

Each fact lives in exactly one record. When a fact needs to appear somewhere else, the other place points to its home instead of copying it. A task names the brief section it builds from, for example "Brief: Scope › Concepts", and does not repeat the section's text.

A duplicate is a bug. Two copies of the same fact drift apart, and then neither the director nor the agent can tell which one is true. So when a fact changes, its owning record changes in the same commit that makes the old version untrue. The old text is replaced, not struck through and not kept beside the new version.

## Why clearing a session loses nothing

Every session starts with an empty context. The records carry everything across the gap:

- A design session writes its decisions into the brief and the decision log, and the tasks they create into the task list.
- A build reads its task, does the work and commits the change together with the task's record updates.
- After that commit, the task list says what is done and what is next, and the commit message says why the change was made.

A new session, or `/clear` in Claude Code, only has to read those files to pick up where the project stands. Anything still unfinished is written down in the task list before the session ends, so the next one can carry on from it.

This is also what keeps each session cheap. A builder reads the records its task points to and nothing else, so the context it starts with stays small.

## Explore the framework

The three frameworks differ in their details, but the records work the same way in each. The best way to see them at work is to open a framework's repository and read its `TASKS.md`, its design records and a few of its commit messages. [Choose a framework](../frameworks/index.md) and look at how its records were written.

<div class="takeaway"><span>The files are the memory. The chat is only the conversation.</span><span class="url" markdown="span">[Agent development flow](agent-flow.md)</span></div>
