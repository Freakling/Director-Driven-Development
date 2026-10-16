# Review and merge the framework pull requests

<div class="kicker">Each change reaches its repo as a pull request you merge</div>

> The agent builds and checks every change in a clone of the framework's repo and opens a pull request for it. Nothing reaches a framework repo until you merge its pull request.

This guide is for you as the director of the frameworks: the person who reviews and merges the pull requests of App-Director, Godot-Director and SaaSAllTheThings. It is not for framework users. It covers what this repository does with each pull request and what you do with it. The [internal workflow page](https://github.com/Freakling/Director-Driven-Development/blob/main/product/framework-workflow.md) shows how the steps fit together.

## What you need to know

- **What reaches you.** Each item the agent builds becomes one pull request in its framework's repo, on its own branch. A release is a pull request too.
- **Who merges.** Only you. The agent never merges a pull request, and the publish script never enables auto-merge.
- **What the description is.** The pull request's description is the item's commit message: its title is the commit's subject, and its body says why the change was made. For a release pull request, the description is the release notes. The agent runs the framework's selftest before it commits, so a pull request that reaches you has passed it.
- **What you're reviewing.**
  - The change itself, in the Files changed tab.
  - The records the item adds to that repo: the item, marked done, at the top of its root `TASKS.md` with that repo's next ID, and an entry at the top of its `CHANGELOG.md`.
  - The notes the agent writes for you, such as anything it asks you to look at and any choice it made while building.

## What you need to do

1. **Review on GitHub.** Open the pull request from the link the agent gives you. Read the description, then the Files changed tab, then the two records. If something needs changing, tell the agent what to change. It makes the change on the same branch and publishes it again, which updates the same pull request.
2. **Merge with "Squash and merge".** Open the menu next to the merge button and choose "Squash and merge". Don't choose "Create a merge commit". The reason: a GitHub merge commit has two parents, and the Claude plugin directory's scanner has rejected every such commit, while it has accepted the single-parent ones. A squash merge puts one commit on the default branch. This is being confirmed with a squash-merged commit, so until it is proven, squash is the practice.
3. **Deal with a blocked merge.**
   - **"Merging is blocked due to failing merge requirements".** A requirement that the repo sets for merging isn't met yet, such as a check that has failed or hasn't finished. The checks listed under the merge box show which one.
   - **"This branch has conflicts that must be resolved".** Two open pull requests on the same repo each add an entry at the top of `TASKS.md` and `CHANGELOG.md`. Merging one makes the other one's entries conflict. This is a conflict in the records, not in the code.
   - **What to do.** Tell the agent, or run `/next-task`. The agent merges the default branch into the open branch, keeps both entries (a duplicate ID gets the next number), reruns the selftest and publishes. The pull request then updates, and the merge button unblocks once its requirements are met.
4. **Let the next `/next-task` run handle a merge.** After you merge, the next `/next-task` run:
   - marks the item done in this repo's `TASKS.md`;
   - brings each other open branch in that repo up to date, the same way as in step 3;
   - proposes a release of each framework the item touched, as a release item here. The release covers everything merged in that repo since its last release, not only this item.
5. **Review and merge the release pull request.** The agent builds the release as its own pull request: the version files, the `CHANGELOG.md` heading and the release notes. Check that the version is right. The agent proposes it, and you can change it in review. Then merge it, with the same squash merge as in step 2.
6. **Let the agent publish the release.** Once the release pull request is merged, the agent tags the merge commit `v<version>` and publishes the GitHub release with the notes. Then it moves the docs links to the new tag and updates the pages for what the release ships. That docs change is committed here, and it's pushed when you ask.

Closing a pull request without merging it takes it out of the flow. The agent brings it to you the next time it checks the pull requests, and the item stays in-progress until you decide.

## Caveats

- **One pull request per repo at a time avoids conflicts.** If you merge one, the others in that repo conflict on the records. The agent fixes them when it runs, but each fix is another push and another selftest.
- **Don't choose "Create a merge commit"** while the scanner question is open. See step 2.
- **A release pull request changes the version files.** Review them with the release notes: each version file and the `CHANGELOG.md` heading should carry the same version.
- **Some changes wait on purpose.** A change you hold back, such as one waiting for a user acceptance test, stays on a local branch with no pull request yet. The item stays in-progress until you ask for the pull request.

## More

- The [internal workflow page](https://github.com/Freakling/Director-Driven-Development/blob/main/product/framework-workflow.md), with the flow of an item from request to merge, the release steps and the tools.
- [Ship a build with /release](release.md). That guide covers shipping a project's build. The framework releases in this guide are the release pull requests above, not the `/release` command.
- The [How-to guides](index.md) for the other guides.

<div class="takeaway"><span>Review on GitHub, merge by squashing, and the agent does the rest.</span><span class="url"><a href="index.md">All how-to guides</a></span></div>
