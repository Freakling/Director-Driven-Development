# Design calls

Every feature, fix or change starts with a decision. The agent proposes; the director decides.

## How a design call works

When the agent reaches a decision the brief does not settle, it stops and presents 2 to 4 options with a recommendation. The director picks one, writes their own answer, or defers it. [How do I decide what gets built, or change how something works?](../how-to/decide.md) walks through a session of these calls.

Only the director's choice is recorded. The design document holds what was decided; the decision log holds one line on why.

When an option depends on facts nobody has checked, such as a service's limits, a licence or a store requirement, the agent first runs a read-only research item. Its note gives the options, the sources with their confidence and a recommendation, and the call is made with the note in front of the director. The note informs the call and never makes it (see [/research](../skills/research.md), and [I need facts before I decide](../how-to/facts.md) for the steps).

## What happens to undecided questions

Anything the director has not answered goes on the open-questions list. The agent never answers an open question itself. Values the director has not set yet are marked `PLACEHOLDER` in the code and config, so the project compiles and checks can run, but nothing real is in their place.

## From decision to task

Each decision the director makes becomes one or more task items in `TASKS.md`. Each item is sized and names the files it touches, so the builder knows exactly what to read and what to change. See [Task and model sizing](sizing.md).

## During a build

A builder that runs into a decision its task does not settle stops and reports the task as blocked, with options and a recommendation. The question comes to the director, the answer is recorded like any other design call, and the task is rebuilt with it.

<div class="takeaway" markdown><span>The agent proposes. The director decides.</span><span class="url" markdown="span">[Agent development flow](agent-flow.md)</span></div>
