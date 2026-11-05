# /prototype

<div class="kicker">Try a change fast, before anything is built for real</div>

`/prototype` gives a change its own git worktree and its own session, outside the build loop, so you can feel a flow, a screen or a mechanic before it is built against the design. What is worth keeping reaches the project only through a harvest in your main session, as decisions, user stories and items that are built from main like any other. The prototype itself is never merged. The command is the same in all three frameworks, and the procedure of each repository is the source of truth.

How to use it: [How do I try a change before it's built?](../how-to/prototype.md)

## What it does

1. **Start** with `/prototype <name>`, in the main session. `bash tools/prototype.sh start <name>` creates the worktree `../<project folder>-proto-<name>` on a new branch `proto/<name>` from your local `main`, with no upstream. It runs `bash tools/setup-clone.sh` there and commits `PROTOTYPE.md`, where you keep notes on what you are trying, how it felt and what to keep. You then open a second session in that folder, and the agent says how where the tool can't start one itself. If `origin/main`, as last fetched, is ahead of `main`, it creates nothing and offers to bring main up to date first (you approve the `git pull --ff-only`) or to start from main as it is.
2. **Try it** in the prototype's session. That session is outside the loop: no items, no records, no builder, no reviews, and no check on its commits, which need no approval. The guard and the secrets scan stay on, and nothing is pushed or merged. The smallest change that lets you feel the idea beats a complete one.
3. **Harvest** with `/prototype harvest <name>`, back in the main session. The agent reads the commits, the diff against main (`git diff main...proto/<name>`) and your notes, then runs the design procedure on them: options, a recommendation, and you decide, then approve one summary before anything is written. The decisions, user stories and items it files each name the prototype, and the items carry a `Prototype: proto/<name>` line. A part you don't answer stays out, and leaving the prototype files nothing.
4. **Remove** it when you are done. The agent offers to remove the worktree, never forced, and asks you to delete the branch yourself with `git branch -D`, since a prototype is never merged and deleting it discards its commits.

`/prototype list` shows each prototype, its worktree and its commits since main. `/prototype remove <name>` removes one without a harvest.

`tools/prototype.sh` does the git steps and never pushes, merges or deletes a branch. A pre-push hook refuses a push of a `proto/` branch, from the prototype or to the remote, and of any commit only such a branch has. The prototype is built from main and compared with main, and its code is only a reference for the items the harvest files: a builder reads the prototype's diff for an item's paths while the branch exists, and never merges or cherry-picks it.

## Unique per repo

### Godot-Director

The procedure is at [`framework/.godot-director/procedures/prototype.md`](https://github.com/Freakling/Godot-Director/tree/v4.10.1/framework/.godot-director/procedures/prototype.md) in the Godot-Director repository.

- The game can run in the prototype. You play it, `bash tools/autoplay.sh` plays it and `bash tools/log_review.sh` reads the run, and `bash tools/check.sh --only tests/<file>.gd` runs one test file. A playtest report or function check stays a record of the main session, and nothing is exported, released or uploaded.
- `start` copies the clone's saved Godot path (`tools/godot_bin.local`) into the worktree. The first run there builds its own `.godot/` import cache, so it is slower than usual.
- A prototype needs gitleaks. Every other commit keeps it optional, with a note when it is missing, but a prototype skips the check, so the secrets scan is its only gate: `start` refuses without gitleaks, and the pre-commit hook blocks a prototype's commit while it is missing.
- The same gate blocks a commit while `.gitleaksignore` or `.gitleaks.toml` differs from main's, or a staged line carries a `gitleaks:allow` comment. The hooks, the guard and settings, `tools/prototype.sh`, `tools/setup-clone.sh` and the two gitleaks files are the prototype's only gates, so the Edit and Write guard refuses them there.
- The harvest files GDD changes, decisions, user stories in a game that uses them, and items. A number the prototype tuned stays a placeholder, and you tune it in the `.tres` file.
- Where the game has screens, `/ui-design` captures before (in the main checkout) and after (in the worktree) are offered, so you can compare.

### App-Director

The procedure is at [`framework/.app-director/procedures/prototype.md`](https://github.com/Freakling/App-Director/tree/v1.14.1/framework/.app-director/procedures/prototype.md) in the App-Director repository.

- The app runs from the worktree on this machine, with its own `.env` copied by you and its dependencies installed as in any new clone.
- The pre-commit hook skips the project check and still scans the staged changes for secrets. It blocks the commit while gitleaks is missing, while `.gitleaksignore` or `.gitleaks.toml` differs from main's, and when a staged line adds `gitleaks:allow`. The protected-files hook refuses edits to the hooks, the guard, `tools/prototype.sh`, `tools/setup-clone.sh` and the two gitleaks files while `PROTOTYPE.md` sits at the project root.
- Where the app has a web UI, `/ui-design` captures before (in the main checkout) and after (in the worktree) are offered.
- The harvest files decisions, user stories and items.

### SaaSAllTheThings

The procedure is at [`framework/.satt/procedures/prototype.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.16.1/framework/.satt/procedures/prototype.md) in the SaaSAllTheThings repository.

- A prototype never deploys, to any Azure environment, dev included, and not through a pipeline. It runs on this machine with the Functions host and the emulators. In a prototype session the guard blocks `az`, `azd`, `func azure` and `gh workflow run`. The guard reads the text of a command, so a script or an allowed command can still call `az` where it cannot see, and the procedure tells the agent to keep to this as well. A prototype you want others to see is harvested, built from main and released with `/release` and your approval.
- The pre-commit hook skips the project check and runs the secrets scan (`bash tools/check.sh --secrets`) on every commit. It blocks the commit when the scan can't run, and while `adr/`, `tools/check.cfg`, `tools/check.sh`, `tools/archcheck.awk` or a `.gitattributes` file, which decide what the scan excuses or skips, differ from main's.
- The reference architecture is not enforced in the prototype, since the check gates nothing. The harvest lists each place the prototype goes against it and sends it to [`/architect`](../frameworks/saasallthethings.md#deviation-is-an-adr) with "comply" first. Until you accept an ADR, the real build follows the reference.
- Where the product has a web client, `/ui-design` captures before and after are offered, on this machine and never in dev.
- The harvest files decisions, user stories, ADRs and items.

<div class="takeaway"><span>Try it in a prototype, keep what feels right, and build that from main.</span><span class="url"><a href="https://saemundsson.se/2026/10/07/director-driven-development/">Why: the blog post</a></span></div>
