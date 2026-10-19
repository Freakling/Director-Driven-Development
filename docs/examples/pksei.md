# Game: PKSEI, built with Godot-Director

PKSEI (*Paddla Kanot Som En Idiot*, Swedish for "paddle a canoe like an idiot") is a rage game. Four drunk guys have lashed two canoes into a catamaran and need to reach an island in the middle of a lake. You control all four at once, the lake throws hazards at them, and they keep drinking, so the boat gets harder to control the longer the crossing takes. Nobody dies: a bad stretch drifts the boat back into water already crossed.

It is also a tech demo for [Godot-Director](../frameworks/godot-director.md). This page shows how the game was made with it, from an empty folder to the build on itch.io.

## Where to play it

The game is free, runs in the browser and is still in development. It plays with keyboard and touch, in English and Swedish.

<div class="ddd-embed">
<iframe frameborder="0" src="https://itch.io/embed/5170526?dark=true" width="552" height="167"><a href="https://freakling.itch.io/pksei">PKSEI by freakling</a></iframe>
</div>

- **The game:** [freakling.itch.io/pksei](https://freakling.itch.io/pksei).
- **The repository:** [Freakling/PKSEI](https://github.com/Freakling/PKSEI), records included.
- **The devlog:** [Devlog 1, how PKSEI was made](https://freakling.itch.io/pksei/devlog/1712142/devlog-1-how-pksei-was-made-in-two-evenings-a-recipe), a recipe written as the game was built. The numbers and the recipe below come from it.

## The loop as it ran

The whole project ran on the same four words: **Decide, Build, Prove, Commit.** The loop itself is described in [Agent development flow](../concept/agent-flow.md).

- **Decide.** Installing the framework ended in a design interview: the pitch, the genre, the design pillars, the core loop, platforms, input and who owns what. Each question came as multiple choice with a recommendation. When a question was open, the agent researched reference games first and then came back with two to four options. Only what was decided was written down: the design document rewritten, one line in the decision log with its reason, the open question deleted.
- **Build.** Every item in `TASKS.md` has a size, the files it touches and outcomes tagged as a test, a check or a play. A builder agent got one item in a fresh context, built it, ran the check and returned a report of about twenty lines. Small items went to a cheaper model, medium ones to a mid-tier one, and the session's own model was kept for design. See [Task and model sizing](../concept/sizing.md).
- **Prove.** The check ran before every commit and enforces the game's architecture: screens that roll randomness or write to autoloads fail the build. The rules were written as pure classes with tests before any scene existed. The large items also got an independent [review](../concept/reviews.md) in a fresh context before their commit.
- **Commit.** One item, one commit. The orchestrating session read only the builder's report, updated the records and committed.

## What the check and the reviews caught

The devlog lists what the pre-commit check, the reviews and the builders' reports found across the two days. In its words, none of these were bugs the director would have filed from playing:

- A design call the builder had made silently about the shore reset.
- A swimmer who could drift past the shoreline, out of reach.
- A wind-up that could expire unseen while a guy was in the water.
- A hit that could land during the win cutscene.
- A gameplay constant hiding as a cosmetic one.
- The guaranteed path leading into the beast's water.
- A spawn window too narrow for the widest hazard.
- A floating-point edge on the touch pads' forward and reverse line, which made a press exactly on the line reverse.

The first review also found six tunables sitting on scene scripts instead of in the data resources. Each finding became a fix in the same item or a new item in the queue.

## The numbers, as the devlog counts them

The devlog gives these figures for the build it describes. They are a snapshot, and the repository keeps moving.

| | As the devlog counts it |
|---|---|
| Time | Two days, an evening and then a long day |
| Commits | 104, one item each |
| Task items | 77, plus 6 bugs |
| Decisions recorded | 89 lines, each with its reason |
| Tests | 285 in 46 files |
| Tunables still marked placeholder | 116 |
| Builds shipped to itch.io | After every stage, about twenty |

Source: [Devlog 1](https://freakling.itch.io/pksei/devlog/1712142/devlog-1-how-pksei-was-made-in-two-evenings-a-recipe).

## The recipe in short

1. **Install and interview.** Install Godot-Director, answer the design interview and write the design pillars. Everything later is checked against them.
2. **Ship early.** Get the export and upload working on an empty scene, so every stage of the game reaches the page with one command.
3. **Research, then decide.** Let the agent research the reference games and propose options. You decide, and every decision is recorded with its reason.
4. **Rules first.** Build the rules as pure classes with tests before the scenes, one item per commit, with a review for the large ones.
5. **Play on the real device.** Play early and record what you learned as decisions, not patches. In PKSEI a phone showed that the flick gesture for reverse was unreliable and that the screen showed only a third of the canvas.
6. **Follow-ups are items.** Every follow-up from a builder's report goes in the queue, never into silent work.
7. **Generate the placeholders.** The sprites, the sounds and the itch.io cover are made by committed scripts, so the art is reproducible. Telegraphs come first.
8. **Ship after every stage.**
9. **Upgrade the workflow like any other change.** The framework was upgraded mid-project as one commit, with the decisions recorded and the follow-ups as items: what the upgrade needed wired into the game went into the queue instead of being done silently in the upgrade commit.

## The records as the diary

The devlog calls the repository's records the diary of the project. All four are in [Freakling/PKSEI](https://github.com/Freakling/PKSEI):

- [`design/gdd.md`](https://github.com/Freakling/PKSEI/blob/main/design/gdd.md): the design document, with the pitch and the four design pillars: Hard but fair, Four bodies one brain, Drunker is funnier, No death only setbacks.
- [`design/decisions.md`](https://github.com/Freakling/PKSEI/blob/main/design/decisions.md): one line per decision, with its reason.
- [`TASKS.md`](https://github.com/Freakling/PKSEI/blob/main/TASKS.md): the work, one item per commit.
- [`AGENTS.md`](https://github.com/Freakling/PKSEI/blob/main/AGENTS.md): the instructions for the agents, with the architecture table.

[Records in files](../concept/records.md) explains why the records are kept this way.

## Where to go next

- **Start your own game:** [Where do I start with a game?](../how-to/start-game.md)
- **The framework:** the [Godot-Director page](../frameworks/godot-director.md).
- **The other examples:** the [Examples overview](index.md).

<div class="takeaway"><span>Decide, Build, Prove, Commit.</span><span class="url"><a href="https://freakling.itch.io/pksei">freakling.itch.io/pksei</a></span></div>
