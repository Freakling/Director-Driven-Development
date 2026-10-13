# Code shaped for agents

Agent quality drops as context grows. The codebase is shaped so that a task needs only a small part of it read, changed and checked.

## What it looks like

- **Small, separate units.** Each file does one job and works like a small service: input in, output out. SaaSAllTheThings goes furthest, with one type, function or handler per file and a check that fails files over a size limit.
- **Layers that depend one way.** Screens and pages display state and call the logic layer. The logic layer (services, hooks, providers, stores) holds the business rules and calls the data layer. The data layer (repositories, API clients, storage) handles network access and persistence only. A layer never reaches past the one below it, so a task inside one layer can be read without tracing the whole app.
- **Read only what the task needs.** Each task names the files it may touch in its `Touches` field. The builder reads those files and the records the task points to, by heading or line range. The records themselves are covered in [Records in files](records.md).
- **Rules in testable code.** Business rules sit in plain code that tests can call directly, without a running screen. The check fails when they leak into the UI or into the wrong layer, as described on [The check](check.md).
- **One task, one commit.** A large task is split before it starts. [Task and model sizing](sizing.md) sets out how.
- **Nothing lives only in chat.** Whatever a later session needs is written to a file. The [records](records.md) hold it.

Pick one task in your own project and check whether its `Touches` field names only the files that task needs. That check is the quickest way to see how well a codebase is shaped for agents.

<div class="takeaway" markdown><span>A small context is what keeps the agent sharp.</span><span class="url" markdown="span">[Ownership](ownership.md)</span></div>
