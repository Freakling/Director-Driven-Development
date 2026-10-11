# Acceptance check

<!-- One section per core flow from the brief. Keep the fixed descriptions' wording stable:
     changing it makes earlier results incomparable. Keep the sections after the flows as they are. -->

- **Date:**
- **Tester:**
- **Build:** <!-- git rev-parse --short HEAD -->
- **Environment** (local / staging / prod):
- **Flows checked:** [ ] Grasp DDD in one screen · [ ] Learn the concept · [ ] Pick and install a framework · [ ] Cut token cost · [ ] Look up a skill · [ ] Follow a link from the blog

This is about whether each built behaviour works in the running app, not whether features exist. Tick one box per item. Write what went wrong in Notes; leave both empty if you didn't check it.

---

## Grasp DDD in one screen

- **The home page shows the four roles, the four loop steps and the three frameworks** *How: open the home page on a laptop and on a phone*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

- **Every card and "More in" link on the home page opens the right page** *How: click each one*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

## Learn the concept

- **The concept pages read in order from the navigation, each ending with its takeaway line** *How: go through Concept from the first page to the last*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

- **The review table matches each framework's current rules** *How: compare Reviews with each repo's `rules.md` › Reviews and model size*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

## Pick and install a framework

- **The comparison page helps choose a framework** *How: read Frameworks and open the one that fits a sample project*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

- **Each framework page's install tabs and commands match the repo's README** *How: compare each page with its README › Install and Day to day*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

## Cut token cost

- **The token cost page's tuning steps work as described in Claude Code** *How: try /clear, /usage and /context in a session*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

## Look up a skill

- **The /next-task page describes the skill in all three frameworks** *How: open Skills › /next-task and read each "Unique per repo" subsection*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

- **Each "Unique per repo" subsection names what differs in that framework and links to its procedure** *How: click the procedure links in all three subsections and confirm they open the right file*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

## Follow a link from the blog

- **Each page links back to the post that explains the why, and the links open** *How: click the takeaway or Read more links on each page*
  - [ ] Works   - [ ] Broken / missing
  - Notes:

---

## Bugs

One block per bug you noticed that isn't already an item above. Copy as often as you need.

**Bug:** (one line: what's wrong)
- **Where:** (screen or flow)
- **Steps:**
- **Expected:**
- **Actual:**
- **How often:** always / sometimes / once
- **Severity:** high (data lost, core flow blocked, crash) / med (wrong but workable) / low (cosmetic)

**Might be a bug, might be intended:**
-

## Free-Format Comments

Anything else: ideas, friction you felt, things that seemed off, features you wished for.
