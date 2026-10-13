# Ownership

Every part of the codebase has an owner. The owner is either the human, who acts as director, or the agent. The owner of each area is written down in `AGENTS.md`, so both can tell at a glance who decides and who builds.

## Who owns what

The director owns the product vision, the design and the priorities. The director also owns the personal assets they keep for the project, such as mockups, brand assets, reference images, notes and third-party API specifications.

The agent owns the areas it builds. It builds them one item at a time, keeps the [records](records.md) up to date and proposes changes to the design. It never changes what the director owns.

## The ownership table

The `Ownership` section of `AGENTS.md` has one row per area. Each row names the area, its owner and a placeholder. The placeholder column says what stands in for an area when the human owns the real thing.

## Placeholders for human-owned assets

When work depends on something the human owns, the agent does not generate the real thing. It uses the placeholder that the ownership table names for that asset, so the work can continue, and the human supplies the real asset when it is ready.

The agent can still read a human-owned asset for context. It never creates, changes or deletes what the human keeps.

## Why it matters

Clear ownership tells the director which changes need their judgement, and tells the agent which changes it may make on its own. Work on a human-owned area then waits for the human, and nothing is generated over it by mistake.

Open `AGENTS.md` in your own project and check that every area in its ownership table has an owner you would name.

<div class="takeaway" markdown><span>Every area has an owner, and the owner decides.</span><span class="url" markdown="span">[Records in files](records.md)</span></div>
