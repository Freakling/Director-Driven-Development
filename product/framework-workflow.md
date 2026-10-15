# Framework work

This repository builds the items of the three framework repos, App-Director, Godot-Director and SaaSAllTheThings, with App Director. Each item is built in a clone of its repo under `work/`, which is gitignored, and reaches the repo as one pull request. The director reviews and merges each pull request on GitHub; the agent never merges one.

The rules are in AGENTS.md › Project rules, under Framework work. This page shows how they fit together.

## The flow

In the diagram, `REPO` stands for the framework's name: App-Director, Godot-Director or SaaSAllTheThings.

```mermaid
flowchart TD
  subgraph DIR["Director"]
    d1["Decision, or an audit difference"]
    d2{"Reviews the pull request"}
    d3["Closed without a merge: brought to the director"]
    d4["Stop and report to the director"]
    d5{"Reviews the release pull request"}
  end
  subgraph REPO["This repo"]
    r1["Item waits in TASKS.md, Touches names work/REPO"]
    r2["/next-task: gh pr view on each PRs: line"]
    r3{"Pull request state"}
    r4{"Ready item? Dependencies done, no open pull request on the same files, records excepted"}
    r5["Claim: item in-progress, dated"]
    r6["work-publish.sh: push the branch, open the pull request"]
    r7["PRs: line added, item stays in-progress"]
    r8["Item done in TASKS.md"]
    r9["Other open item branches: merge origin/main, resolve record conflicts, selftest, publish"]
    r10["Docs item: links move to the new tag, pages updated"]
    r11["No ready item: report what is blocked"]
    r12["/next-task proposes a release of each repo the item touched"]
    r13["work-release.sh: tag v(version), publish the release"]
    r14["work-publish.sh: push the release branch, open the release pull request"]
  end
  subgraph CLONE["work/REPO clone"]
    c1["Branch ddd/T(ID) from origin/main"]
    c2["Builder changes the clone, following its CLAUDE.md"]
    c3["Root TASKS.md gets the item as done, and a CHANGELOG entry"]
    c4{"selftest.sh passes"}
    c5["Commit on the branch, one commit"]
    c6["Release branch: version bump, CHANGELOG heading, release notes"]
  end
  subgraph GH["GitHub"]
    g1["Pull request open"]
    g2["Merged"]
    g3["Latest release tag"]
    g4["Release pull request open"]
    g5["Release pull request merged"]
  end

  d1 --> r1
  r1 --> r2
  r2 --> r3
  r3 -->|"Merged"| r8
  r3 -->|"Closed without a merge"| d3
  r3 -->|"Open, or none listed"| r4
  r4 -->|"Yes"| r5
  r4 -->|"No"| r11
  r5 --> c1
  c1 --> c2
  c2 --> c3
  c3 --> c4
  c4 -->|"Fails, first time"| c2
  c4 -->|"Fails again, or a design question"| d4
  c4 -->|"Passes"| c5
  c5 --> r6
  r6 --> g1
  g1 --> r7
  r7 --> d2
  d2 -->|"Merge"| g2
  d2 -->|"Request changes"| c2
  d2 -->|"Close"| d3
  g2 -.->|"Next /next-task run"| r2
  r8 --> r9
  r8 --> r12
  r12 --> c6
  c6 --> r14
  r14 --> g4
  g4 --> d5
  d5 -->|"Merge"| g5
  d5 -->|"Request changes"| c6
  d5 -->|"Close"| d3
  g5 --> r13
  r13 --> g3
  g3 --> r10
```

## The sequence

One item, from the request to its merge.

```mermaid
sequenceDiagram
  participant D as Director
  participant C as Claude (this session)
  participant B as Builder (fresh context)
  participant W as work/REPO clone
  participant G as GitHub

  D->>C: Do the next App-Director task
  Note over C: Picks the first ready item and claims it in-progress
  C->>W: Create branch ddd/T(ID) from origin/main
  C->>B: Item ID, full text, the repo's CLAUDE.md
  B->>W: Change the clone, add the item as done to TASKS.md, CHANGELOG entry
  Note over B: A design question stops the build and goes to the director
  B->>W: Run selftest.sh
  alt Passes
    B-->>C: Done, with a short report
  else Fails, first time
    B->>W: Fix, then run selftest.sh again
    alt Passes
      B-->>C: Done, with a short report
    else Fails again
      B-->>C: Blocked: stop and report to the director
    end
  end
  C->>W: Commit on the branch, one commit
  C->>G: work-publish.sh: push the branch, open the pull request
  G-->>C: Pull request URL
  Note over C: PRs: line added, item stays in-progress
  D->>G: Reviews and merges the pull request
  D->>C: Do the next App-Director task
  C->>G: gh pr view for each PRs: line
  G-->>C: MERGED
  Note over C: Item done in TASKS.md
```

## Where items come from

A decision, or a difference that `tools/audit.sh` finds between a framework's latest release and its skill page, becomes an item in TASKS.md. `bash tools/push-alignment.sh` lists the items for the differences, and `--add` writes them. Each item's `Touches` names its clone under `work/`.

## The builder

The builder follows that repo's own `CLAUDE.md` (`.claude/CLAUDE.md` in SaaSAllTheThings), not the templates under its `framework/` and `project/` folders, and not this repo's rules for code. The gate is that repo's `selftest.sh`, in place of `bash tools/check.sh`. Godot-Director's `selftest.sh` takes the path to Godot 4.3 or newer.

## Done means merged

An item stays in-progress, with a `PRs:` line that lists its pull requests (for example `Godot-Director #2 (open)`), until all of them are merged. `/next-task` updates that line before it picks anything. A pull request closed without a merge goes to the director. The records here are committed without pausing, but this repo is pushed only when the director asks.

## What blocks an item

An item waits while an item it depends on isn't done, so an open pull request blocks the items that depend on its item. It also blocks an item whose `Touches` shares a file with it. Compare them with `gh pr view <n> -R Freakling/<repo> --json files`. The records every item adds (the root `TASKS.md` and `CHANGELOG.md`) don't count. Other items carry on, in the same repo too.

## After a merge

Each other open item branch in that repo gets `origin/main` merged in; it is never rebased or force-pushed. Where the record files conflict, keep both entries, and give a duplicate ID the next number. Then run that repo's `selftest.sh` and publish with `bash tools/work-publish.sh work/<repo>`, which updates the open pull request.

## Releases

A release comes when a change is complete. Once an item is done, with all its pull requests merged, the next `/next-task` proposes a release of each framework repo the item touched. The release covers everything merged in that repo since its last release, not only this item.

The proposal is a release pull request that follows the repo's own `CLAUDE.md`: the version bump, the `CHANGELOG.md` heading and the release notes. The release notes are the commit message, which `tools/work-publish.sh` turns into the pull request description. The director decides every release, and merging the pull request is the approval.

After the merge, `bash tools/work-release.sh work/<repo> <pull request number>` tags the merged commit `v<version>` and publishes the GitHub release with that description as its notes. Then an item here moves the docs links to the new tag and updates the pages for what the release ships.

## The tools

- `tools/work-clones.sh` clones the three repos into `work/`, or fetches the clones already there. It never resets or switches a clone.
- `tools/work-publish.sh work/<repo>` pushes the item's branch and opens its pull request. It refuses the default branch, never merges and never force-pushes. `--dry-run` prints the commands without running them.
- `tools/work-release.sh work/<repo> <pull request number>` tags the merged release commit and publishes the GitHub release. It refuses when the pull request isn't merged, the version files disagree, the tag or the release already exists, or the description has no "How to install" section. It pushes only the new tag and never merges, force-pushes or moves a tag. `--dry-run` prints the tag, the notes and the commands without running them.
