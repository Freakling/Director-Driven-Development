# Anchor: the align step, brief against reality

The agreed behaviour of the "Brief against reality" step of `/align` in App-Director, Godot-Director and SaaSAllTheThings. This file lives only in this repository. A task in each framework's own `TASKS.md` carries it there (T93 to T95), and that framework's build agents add the step to its align procedure. Brief: Scope › Common skills.

How to read it:
- **Part A** (sections 1-3) is what changes in the framework: the purpose, where the step sits, and its wording.
- **Part B** (section 4) is what the audit compares.

## Placeholders

| Placeholder | App-Director | Godot-Director | SaaSAllTheThings |
|---|---|---|---|
| `<design doc>` (read whole, and checked against) | the brief, `product/brief.md` | the GDD, `design/gdd.md` | the PRD, `product/prd.md`, and the ADRs in `adr/` |
| `<built>` (what exists) | the built app | the built game | the built system: its code, infrastructure and clients |
| `<decision log>` | `product/decisions.md` | `design/decisions.md` | `product/decisions.md` |
| done items (`TASKS.md` and its archive) | `TASKS.md` and `TASKS-archive.md` | `TASKS.md` and `TASKS-archive.md` | `TASKS.md` and `TASKS-archive.md` |
| `<releases>` (what a release is) | the app's deploys; a release is a release tag, and its contents are the done items since the last tag (`release.md`) | the game's exports and their UAT or production uploads (`release.md`); the release report records each one, and nothing goes in TASKS.md | the deploys to `dev` and `prod` (`release.md`); `prod` deploys from a tag, and its contents are the done items since the last tag |

# Part A: what the framework changes

## 1. Purpose and role

- Align checks the design document against the project. This step reads every statement of state in it against what exists, and every decision line, so that a section marked later does not outlive the work it describes.
- It fixes mechanical drift and reports design calls. Align never changes design, as the procedure already says.
- A project may add checks for the statements a script can test, in its own selftest. The framework doesn't require one.

## 2. Where the step sits

- The step is item 6, before **Decisions**. It replaces the Decisions spot-check: its sub-step 3 checks every decision line, not a sample. The items after it renumber.
- The Report item stays as it is. It commits the fixes as `docs: align` and names the conflicts in the commit body, as sub-step 4 requires.

## 3. The wording

The framework's align procedure gets this item in place of Decisions. The placeholders take the values in the table above.

```
6. **Brief against reality.** For this step only, read the whole <design doc>, not sections by heading.
   1. Read the whole <design doc>, from its first line to its last.
   2. For every statement of state, check it against what exists: the <built>, the done items (`TASKS.md` and `TASKS-archive.md`) and, where the project tracks them, the latest <releases>. A statement of state is a section marked later or planned, a count, a list of what exists, a line saying work waits on something, and "once X exists". Fix a stale statement as mechanical drift when the fact is settled (the item is done, the page exists). Report it to the human when the fix is a design call.
   <ADR sentence: SaaSAllTheThings only, see below; delete this line elsewhere>
   3. Check every line added to `<decision log>` since the last `docs: align` commit (`git log --grep="^docs: align"` for the last one; all lines if there is none) against the <design doc>, one by one and not a sample. Each is reflected in it, and no older text contradicts it.
   4. Report what was fixed and what needs the human, naming each stale statement, so the next align can tell a repeat.
```

SaaSAllTheThings adds this sentence as the ADR line of sub-step 2. App-Director and Godot-Director delete the line:

```
An ADR's status is a statement of state too: an `accepted` ADR's Decision is in the code or infrastructure, or an open item builds it; a `proposed` ADR that the code already follows is stale; and `superseded by ADR-<m>` names an ADR that exists.
```

# Part B: what the audit compares

## 4. What the audit compares

**The same in all three**

| Part | Behaviour |
|---|---|
| Step | Item 6, "Brief against reality", before Decisions, which it replaces |
| Reading | The whole design doc, for this step only; every statement of state checked against the built product, the done items and the latest releases |
| Decisions | Every line since the last `docs: align` commit, one by one, checked against the design doc |
| Fixes | Mechanical drift fixed when the fact is settled; design calls reported, with the stale statement named |
| Wording | "requirements", "control framework" or "security framework"; no en or em dashes |

**What each framework adds** is its column of the Placeholders table and, for SaaSAllTheThings, the ADR sentence of section 3. The audit compares each framework's align procedure at its latest release with the `/align` page; once the step is released, the page records it.
