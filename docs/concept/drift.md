# Align and drift reset

Agents don't break a design. They drift. A principle that can be read two ways gets read two ways. The frameworks handle that at two levels, and all three ship both commands.

## Align often: `/align`

`/align` is the routine consistency pass across the design document, the decision log, `TASKS.md`, `AGENTS.md`, the settings and the code. It checks that everything is accounted for: every design rule has a task, every decision is reflected in the design, every row of the architecture table points at something real.

- Mechanical drift gets fixed on the spot.
- Anything that touches the design comes back to the director, with a recommendation for each.
- The pass never changes the design itself.

Run it after a big design change, before closing a milestone, or whenever the records feel out of step. When a conflict comes back that was already settled, or one conflict spans several design principles, `/align` recommends a reset.

## Reset when you have to: `/drift-reset`

Sometimes everything is accounted for, but the same principle has been built two different ways. Patching won't hold, so the design is reset. Only the director starts a reset. The agent never starts one on its own, and `/align` can only recommend it.

The reset runs on its own branch, and its records go in a reset folder.

1. **Analyse as built.** Each area of the system is analysed read-only, in a fresh context.
2. **Map interpretations.** For each design principle: how it was actually built, and where.
3. **Rewrite the design.** One design call per divergent principle, with options and a recommendation. Only the director's choices are recorded.
4. **Plan the rebuild.** Ordinary sized tasks in `TASKS.md`. The reset itself writes no code; the rebuild runs through `/next-task`.
5. **Postmortem.** Once the rebuild is done, `/drift-reset postmortem` checks whether each drift is fixed. Drift a script could have caught becomes a proposed check rule, for the director to approve.

In SaaSAllTheThings the reset covers the product design the director owns: the product pillars, the PRD, the decision log and the business rules in integration contracts. The architecture is the framework's, and changes to it go through `/architect` and an ADR.

A reset means throwing work away. That is the price of keeping the design yours, and the routine `/align` pass keeps the price rare.

<div class="takeaway"><span>Align often, reset when you have to.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
