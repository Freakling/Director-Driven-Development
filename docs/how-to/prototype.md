# How do I try a change before it's built?

<div class="kicker">A prototype has its own folder and session, apart from the build loop</div>

> Say "Let me try a quick-add button in a prototype", or type `/prototype quick-add`. The agent makes a separate copy of the project on its own branch, you try the change there fast, and a harvest later turns what felt right into decisions, user stories and items that are built from main. The prototype itself is never merged.

All three frameworks ship `/prototype`: App-Director, Godot-Director and SaaSAllTheThings. Nothing to install: run it in Claude Code, in the project where the framework is installed.

## Two ways to do it

**By talking.** Say "Prototype {the idea}", "Let me try {the idea} quickly" or "Spike {the idea}". "List the prototypes" shows what exists, and "Harvest the prototype" starts the harvest.

**With the skill.** Type `/prototype <name>` to start one, `/prototype list`, `/prototype harvest <name>` or `/prototype remove <name>`.

Saying it and typing the command run the same procedure.

## What stays on and what is off

A prototype is for feeling an idea, so it skips the parts of the loop that make a build trustworthy.

**Stays on:**

- **The command guard,** which blocks work-destroying git commands.
- **The secrets scan on every commit.** It is the only gate, so a finding blocks the commit, and so does a scan that can't run. Excusing a secret goes through you, in the main session.
- **Your protected space,** `director/`, which stays yours.
- **No push and no merge.** The pre-push hook refuses a `proto/` branch and any commit only such a branch has, and the agent never merges a prototype into another branch, or another into it.

**Off:**

- **Items and records.** The prototype changes no item, claim, design text, decision log or `AGENTS.md`.
- **The builder and the reviews.**
- **The check gate.** The pre-commit hook skips the project check, and so does the hook that runs the check at the end of a turn. You can ask for the check when it helps.
- **Approvals.** The agent commits as `proto: <what changed>` as often as it helps, and none of those commits asks you first.

## Steps

1. **Start in the main session.** Say what you want to try and give it a name, in lowercase letters, digits and dashes, such as `quick-add`, or let the agent propose one. It runs `bash tools/prototype.sh start <name>`, which creates the worktree `../<project folder>-proto-<name>` on a new branch `proto/<name>` from your local `main`, with no upstream. It runs `bash tools/setup-clone.sh` there and commits `PROTOTYPE.md`, your notes under *What we're trying*, *How it felt* and *What to keep*. Uncommitted changes in your checkout don't go with it. If `origin/main`, as last fetched, is ahead of `main`, it creates nothing and offers two ways on: bring main up to date first (you approve the `git pull --ff-only`), or start from main as it is.
2. **Capture the screens before.** Where the project has screens, the agent offers to capture the ones the prototype will change, now and in the main checkout ([How do I work with UI changes?](ui.md)).
3. **Open the second session** in the new folder. Where the tool can't start one itself, the agent says how: in Claude Code, open a new terminal there and run `claude`. Gitignored files aren't in the worktree, so if the app needs its `.env` or local settings, copy them there yourself. The agent never reads or copies them. Dependencies are installed as in any new clone.
4. **Try it.** Ask for the smallest change that lets you feel the idea. Run the app or game and tell the agent how it felt. It writes your words in `PROTOTYPE.md` and commits them with the work, and the harvest reads them.
5. **Capture the screens after,** when you want to compare. They land in the worktree's `captures/` folder under the same names as the before in the main checkout.
6. **Finish.** When you have seen enough, the agent commits everything and asks you to stop the prototype's app or game and close its session. Go back to the main session.
7. **Harvest.** Run `/prototype harvest <name>` in the main session. The agent reads the commits, the files changed since main, the notes and the diff (`git diff main...proto/<name>`), shows the after captures next to the before where both exist, and names what the prototype skipped that a real build needs, such as tests and the project's layers. Then it runs a design session on them: options, a recommendation, and you decide. The options are usually to build it as tried, a variant your notes point to, or to leave it. Each decision, story and item it files names the prototype, and an item carries a `Prototype: proto/<name>` line. Nothing is filed without your answer, a drafted story you leave unanswered stays out, and leaving the prototype files nothing. The items are built from main with the check and the reviews, like any other ([How do I get things built?](build.md)). The builder may read the prototype's diff for an item's paths, as a reference and never as code to merge.
8. **Remove it.** Once the session and the app are closed, the agent offers to remove the worktree with `git worktree remove`, never forced. The folder goes with everything in it, ignored files too: a copied `.env`, installed dependencies and the after captures. The branch keeps the commits. Deleting it discards them, so the agent asks you to run `git branch -D proto/<name>` yourself in a terminal in the project folder. While an item that names the prototype isn't built, its builder can read the prototype's code only while the branch is kept.

## What differs per framework

- **App-Director.** The app runs from the worktree on this machine.
- **Godot-Director.** A prototype needs gitleaks. A normal commit keeps it optional and prints a note when it is missing, but a prototype skips the check, so `start` refuses without gitleaks and the pre-commit hook blocks the commit while it is missing. The game can run there: you play it, the agent can run `bash tools/autoplay.sh` and read the run with `bash tools/log_review.sh`, and `bash tools/check.sh --only tests/<file>.gd` runs one test file. If you open the editor, open the worktree's folder, not the main checkout's. The first run there builds its own `.godot/` import cache. A playtest report or function check stays in the main session, and nothing is released or uploaded. A number the prototype tuned stays a placeholder for you to tune.
- **SaaSAllTheThings.** A prototype never deploys, to any Azure environment, dev included. It runs on this machine with the Functions host and the emulators, and the guard blocks `az`, `azd`, `func azure` and `gh workflow run` in the prototype's session. A prototype you want others to see is harvested, built from main and released with `/release` and your approval. The reference architecture isn't enforced in the prototype, so the agent notes in `PROTOTYPE.md` where the prototype goes against it. The harvest sends each such place to [`/architect`](../frameworks/saasallthethings.md#deviation-is-an-adr) with "comply" first, and until you accept an ADR the real build follows the reference.

## What can go wrong

- **Start refuses and creates nothing.** The prototype's only gates must be in place first, and the agent says which is missing: the framework's hooks and `tools/prototype.sh` committed on main, this clone's pre-commit and pre-push hooks (run `bash tools/setup-clone.sh` here), and, in App-Director and Godot-Director, gitleaks on the path. In SaaSAllTheThings the secrets scan must run here (`bash tools/check.sh --secrets` exits 3 when it can't). Fix it and start again. If the command isn't there, see [Something isn't there, or doesn't work](trouble.md).
- **A prototype with that name exists.** Start refuses a name whose branch or folder is taken. Pick another name, continue the existing prototype in its own session, or harvest it.
- **Start stops with exit 4.** The prototype exists, but `bash tools/setup-clone.sh` or the first commit needs attention. Open its session only once setup passes in the new folder and `PROTOTYPE.md` is committed there.
- **A commit is blocked in the prototype.** A secrets finding, a scan that can't run, or a difference from main in the files that decide what the scan excuses blocks it. In App-Director and Godot-Director these are `.gitleaksignore` and `.gitleaks.toml`, and a staged `gitleaks:allow` comment is blocked too. In SaaSAllTheThings they are `adr/`, `tools/check.cfg`, `tools/check.sh`, `tools/archcheck.awk` and the `.gitattributes` files. Allowlisting is yours to decide in the main session, and the agent doesn't add an exception to get past it.
- **The agent can't edit a gate file there.** The hooks, the guard and settings, `tools/prototype.sh` and `tools/setup-clone.sh` are the prototype's gates, so edits to them are refused, and in SaaSAllTheThings so are edits to the files the scan reads. `/prototype list` and the harvest name any that differs from main's, so a change can be taken to main first.
- **A push of a `proto/` branch is refused.** That is by design: a prototype stays on your machine. A branch that isn't a prototype shouldn't start with `proto/`.
- **Removal refuses.** `git worktree remove` stops at uncommitted or untracked changes. Commit or delete them in the prototype's session, or free the folder by closing the app and the editor. It is never forced, and the guard blocks `--force`.
- **A prototype is not a build.** It skips the tests and the layers, and the harvest names what it skipped. Treat what you felt as the finding, and the code as a reference for the items.

## Related

- The [`/prototype` skill page](../skills/prototype.md), with what the gates are in each framework.
- The harvest files stories as well as decisions: [User stories](../concept/user-stories.md), and [How do I decide what gets built?](decide.md) for the session itself.
- The procedures: [App-Director](https://github.com/Freakling/App-Director/tree/v1.14.2/framework/.app-director/procedures/prototype.md), [Godot-Director](https://github.com/Freakling/Godot-Director/tree/v4.10.3/framework/.godot-director/procedures/prototype.md) and [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings/tree/v0.16.2/framework/.satt/procedures/prototype.md).

<div class="takeaway"><span>Try it fast in a prototype, then build what you keep from main.</span><span class="url"><a href="index.md">All questions</a></span></div>
