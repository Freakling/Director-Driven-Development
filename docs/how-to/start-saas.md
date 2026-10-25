# Where do I start with a SaaS?

<div class="kicker">From a SaaS idea to a first built task, with SaaSAllTheThings</div>

> Install SaaSAllTheThings in the app's repository, restart Claude Code, and let onboarding settle the stack and interview you about the product. It ends with one commit for you to approve and the first stages of the roadmap in `TASKS.md`. Then say "Do the next task".

This page is for someone with a B2B SaaS idea and no code yet. [SaaSAllTheThings](../frameworks/saasallthethings.md) builds a multi-tenant SaaS on Azure: you own the product, and the framework owns the architecture and enforces it. For a game, see [Where do I start with a game?](start-game.md). For a smaller web, mobile or desktop app, see [Where do I start with an app?](start.md) If you already have a proof of concept or a running app, go to [I already have a project. Can I use this?](existing.md#an-existing-saas-or-proof-of-concept-saasallthethings): the path starts with an assessment of what you have.

## Short answer

1. **Have three things installed:** git, bash, and the toolchain of your backend stack (the .NET SDK 8 or newer by default).
2. **Write it down first,** in your own words, in the product brief template.
3. **Install the framework** in your app's repository with one command.
4. **Answer onboarding.** It settles the backend stack, interviews you about the product, agrees who owns what, and plans the first stages.
5. **Approve the install commit,** restart Claude Code, and ask for the first task.

## What to have installed

- **Claude Code,** in which you run everything. Other AI assistants that read `AGENTS.md` can use the framework's core, but SaaSAllTheThings is built and tested on Claude Code and the others are untested.
- **git.** The SaaS lives in its own git repository. If the folder is not one yet, onboarding offers to run `git init`.
- **bash.** On Windows it comes with Git for Windows, and every command runs in Git Bash.
- **The toolchain of your backend stack.** The default is .NET (C#) and needs the .NET SDK 8 or newer. TypeScript and Python are the other stacks that fit Azure Functions, and each needs its own runtime. Onboarding asks which stack you want and recommends .NET.
- **Azure tools, when you reach deploys.** Onboarding does not need them, and the check never calls Azure. `bash tools/setup-clone.sh` reports whether the Bicep CLI, the Azure CLI, the Azure Developer CLI and the Functions Core Tools are installed. The Bicep CLI lets the check compile the Bicep files in `infra/`; the others are for deploys and for running the functions locally. A deploy asks for your approval each time, and production is yours to run.
- **Node.js,** if you install with the skill, because that command uses `npx`.

Make a folder for the app and open Claude Code in it. An empty folder, or one with only documents, is a fresh start.

## Write it down first

Before you install, describe the product in your own words in the product brief template. Open the [template](https://github.com/Freakling/SaaSAllTheThings/blob/v0.11.0/project/product/director-brief.md) at the latest release and choose Raw to download it. Fill in the product, and the four sections for your customer's architect or product owner if you have one: the enterprise architecture, the requirements, the security requirements and the control frameworks. Leave out what you have not decided. Keep it in the app's repository at `product/director-brief.md`, the path onboarding offers. The SaaSAllTheThings README opens its how-to-use section with this same "Start here" step.

Why first: a written brief gives the agent your intent and the context behind it, which a chat interview doesn't, and the customer's own requirements anchor every later session in their security framework. When you install, the agent reads it before it asks anything. You can also fill it during onboarding (the agent waits), after it, or with the customer.

## Install the framework

Pick one of three paths. Each installs the latest release.

| Path | What you run | Then |
|---|---|---|
| Claude Code plugin | `/plugin marketplace add Freakling/SaaSAllTheThings`, then `/plugin install saasallthethings@saasallthethings` | Open a new session in the app's folder (or run `/reload-plugins`) and run `/saasallthethings:saas-all-the-things` |
| Manual | Clone the release into the app's root as a folder named `SaaSAllTheThings` | Ask: "Read SaaSAllTheThings/ONBOARDING.md and follow it to install SaaSAllTheThings into this project." |
| Skill | `npx skills add Freakling/SaaSAllTheThings` in the app's folder | Ask your assistant to "SaaS all the things" |

The full commands, including the manual clone, are in the [install section](../frameworks/saasallthethings.md#install). The installer only runs onboarding; the workflow itself is committed into your app, so it keeps working without the plugin or the skill.

## Steps: what onboarding asks

Onboarding is the agent following the framework's `ONBOARDING.md`. You decide every product, stack and ownership decision. The agent gathers, proposes and writes. Most questions come as choices, with the recommendation first.

### 1. Getting ready

- **Confirm the mode.** The agent tells you what it detected and asks you to confirm. With no source code yet (documents are fine), that is a fresh start.
- **Which assistants will work on the app?** The default is Claude Code (`claude`). Answer `none` if you will only use other assistants; you then get the tool-neutral core, which works through `AGENTS.md`.
- **Files are installed.** The agent copies the framework into the app. If you put the `SaaSAllTheThings` folder inside the app, it keeps that folder out of git for you.

### 2. The backend stack

The agent recommends .NET, then TypeScript and Python, and says that other languages do not run on Azure Functions. Take .NET unless your team clearly works in another of the three. The choice is recorded as the first architecture decision record, `ADR-1`, and in `tools/check.cfg`. An ADR is accepted only by you: in Claude Code a hook asks you to confirm.

The agent then runs `bash tools/setup-clone.sh`, which checks the toolchain and restores dependencies. If it cannot find one, it tells you what to install and carries on, because `bash tools/check.sh --architecture` needs no toolchain.

### 3. The product interview

The agent interviews you in short rounds. Each question comes with options and a recommendation. Pick one, or answer in your own words.

**Your product brief comes first.** If you wrote it (see [Write it down first](#write-it-down-first)), the agent reads it before the interview, takes the interview's answers from it marked `(from your document)`, and asks only what it leaves open. What it works out itself is marked `(inferred, please confirm)`. If you did not, onboarding offers `product/director-brief.md` before the interview, and the interview works without it. The agent never edits your brief or fills it in for you, and it never treats a requirement as met because the brief names a framework; `product/prd.md` stays the record of requirements it maintains.

| It asks about | A sensible first answer | What it changes |
|---|---|---|
| The pitch, the customers (tenants), the first customer, and how they pay (plans) | One paragraph. Name the first real customer and two plans | The PRD's Pitch, and Customers and Tenants |
| Three to five Product Pillars | Short statements you would use to turn down a feature, such as "set up in under a day" | Every later capability is checked against them, and an idea that contradicts one is flagged |
| The first capabilities, in priority order | The smallest one a customer would pay for. Order is priority | The PRD's Capabilities, and which capability is built first |
| The clients: who uses the Windows app and who the mobile app, for what, and whether either must work offline | Say who and what; leave the technology open | The PRD's Clients. Each client's UI technology becomes a "Decide" item, settled later in an architecture session |
| The integrations: which systems (Navision first?), their purpose and direction | Name the system and why it matters | The PRD's Integrations. The details are worked out later with `/integrate` |
| Data and compliance: residency, retention, personal data | Where the data must live and how long you keep it | The PRD's Data and Compliance |

Anything you answer is written into `product/prd.md` as the current requirements, with one line in `product/decisions.md` for each decision. Anything you leave undecided becomes an open question (`Q1`, `Q2` and so on). The agent never answers one itself. "I don't know yet" is a fine answer and costs nothing.

### 4. Your customer's security framework

SaaSAllTheThings is anchored in the customer's own security framework. If your customer has one, put its security and compliance requirements in a `compliance/` folder in the app. Architecture sessions and research read it, and weigh every option against it, tracing each requirement to a control. The residency, retention and personal data answers from the interview sit beside it in the PRD. You can add the folder at any time; nothing in onboarding waits for it.

### 5. Who decides what

The agent walks you through the defaults and records only the differences in `AGENTS.md`.

- **You own the product:** the capabilities, priorities, customers, plans and the business rules of the integrations. You accept every ADR.
- **The framework owns the architecture.** It is not a project rule and changes only through an ADR you accept. A build that cannot comply stops and asks, and "comply" is always the first option.
- **The agent owns** code, tests, infrastructure as code and the records.
- **Commits and pushes.** The agent proposes each commit and you approve it. It pushes only when you ask.
- **Deploys.** Dev needs your approval each time, and production is yours to run. Onboarding asks whether dev deploys may run without asking each time.
- **Screens by drawing.** Onboarding asks once whether you want to design screens by drawing over screenshots of the running product (free Excalidraw, no account). Say yes and Project rules gain `UI / screen layout: director designs (director/ui/), agent builds`, and `director/ui/` is offered for your drawings. Say no and nothing changes; drawing is never required. For a web client it also asks for the client's address on this machine and the seeded test tenants, and offers the one-time Playwright install. See [How do I work with UI changes?](ui.md)
- **A protected workspace.** If you want a folder the agent never touches (screen drawings, mockups, brand assets, notes, third-party API specs), onboarding offers `director/`. The agent reads it for context and never creates, changes or deletes anything in it. You choose whether to gitignore it (large binary assets) or commit it (drawings and notes).
- **Model sizing.** The agent recommends it on and shows the mapping. In Claude Code the defaults are Haiku for XS and S, Sonnet for M, Opus for L and XL. Say whether any size should differ. Take the recommendation if unsure; the cost effects are in [It's costing more than I'd like](cost.md).
- **Reviews** are stated rather than asked: an independent review after L items, and after M items that change contracts, tenant isolation, identity or a stored schema. See [Reviews](../concept/reviews.md).

The idea is explained in [Ownership](../concept/ownership.md).

### 6. The roadmap

Every SaaSAllTheThings project goes through the same stages: foundation, tenancy and identity, first slice, delivery, clients, integrations, second tenant, and the rest of the capabilities. Onboarding writes the stage table into `TASKS.md` › Milestones and the items for the current stage and the next one, so a new SaaS starts with Foundation and Tenancy and identity. Items only you can do, such as app registrations and consent, are marked for you.

### 7. The feedback template

If your capabilities are decided, the agent turns each into a section of `validation/TEMPLATE.md`, usually three to six, with one scored statement and a question or two. If they are not decided yet, it leaves the placeholders and adds an item to fill them in later.

### 8. Approve the install commit

The agent runs `bash tools/check.sh`, walks through the consistency checks of `/align`, and lists every file it created or changed. It then asks you to approve one commit, `chore: install SaaSAllTheThings <version>`, whose body names the mode, the stack and anything it inferred. Read the list; nothing is committed before you say yes.

After the commit:

- If the check passes, the agent installs the git pre-commit hook. If it fails or cannot run, the hook stays off and an item is added to install it once the check passes.
- On a manual install it offers to delete the `SaaSAllTheThings` folder from the app. Deleting it is recommended.
- It offers a "Development" section for your README: clone, run `bash tools/setup-clone.sh`, then the commands.
- It tells you what still needs your confirmation and which phrases to use.

## What your SaaS gets

The files below are yours and are never overwritten. The framework's own files (`.satt/`, and `.claude/` with Claude Code) belong to the framework, and `.satt/reference/` holds the reference architecture.

| File | Holds |
|---|---|
| `AGENTS.md` | Project facts, layout, architecture, and project rules, for every assistant |
| `TASKS.md` | The stages as milestones, and the queue of tasks, bugs and research |
| `product/prd.md` | The current requirements, and the open questions |
| `product/decisions.md` | Why: one line per product decision |
| `adr/` | Architecture decision records: the stack, and every accepted deviation |
| `validation/TEMPLATE.md` | The feedback template, one section per capability |
| `tools/check.cfg` | Settings for the check: the stack, the layers' folders, size limits |

Later, `integrations/` holds one contract per external system, and `assessment/` holds assessment reports and workshop notes. The concepts behind these files are in [Records in files](../concept/records.md).

## Your first task

1. **Restart Claude Code,** so the new commands, hooks and permissions load.
2. **Look at `TASKS.md`.** The queue starts with the Foundation stage: the layered skeleton, the check passing on a clean clone, and the first domain rule with a test. The order in the file is your priority order; move an item up to build it sooner.
3. **Say "Do the next task"** (or type `/next-task`). The agent builds the first ready item in a fresh context, within the reference architecture, proves it with the check, updates the records and asks you to approve the commit. Use this one-at-a-time mode while you learn what the agent builds. [How do I get things built?](build.md) covers the questions it can ask, and how to ask for a run.
4. **Plan ahead when a stage is nearly done:** say "Plan the next stage", or run `/roadmap`.
5. **Run `/clear`** before the next task. The records hold everything the next session needs.

## What can go wrong

- **The commands are missing.** See [Something isn't there, or doesn't work](trouble.md).
- **The toolchain is missing.** The check exits with 3 until the stack's toolchain is installed. Install it, then run `bash tools/setup-clone.sh`.
- **A build stops and asks about the architecture.** That is the framework doing its job: a build that cannot comply never works around a rule. You get options with "comply" first, and a deviation becomes an ADR you accept.
- **A new clone of the app.** Every new clone needs `bash tools/setup-clone.sh` once; it checks the toolchain, restores dependencies and installs the hook.
- **Another assistant.** Only the core is the same everywhere: rules, procedures, the check and the pre-commit hook. Fresh-context builds, the reviewer, model sizing and the hooks that block risky commands depend on your assistant supporting subagents and hooks.

## Where to go next

- **Settle what the open questions leave:** [How do I decide what gets built, or change how something works?](decide.md). `/design questions` ranks them by what they unblock, and `/architect` settles an architecture call.
- **Need facts first:** [I need facts before I decide](facts.md), for example which Azure service fits, or what your customer's security framework requires.
- **Check it:** [How do I check that what was built works?](check.md)
- **Ship it:** [How do I ship it?](ship.md)
- **See it in use:** the [Azure SaaS worked example](../examples/index.md).

## Related

- The [SaaSAllTheThings page](../frameworks/saasallthethings.md), its [install section](../frameworks/saasallthethings.md#install), and the skill pages [`/next-task`](../skills/next-task.md) and [`/design`](../skills/design.md).
- The concepts [Roles](../concept/roles.md) and [Agent development flow](../concept/agent-flow.md).
- The step-by-step guide on the blog: [Build a B2B SaaS on Azure with Director-Driven Development](https://saemundsson.se/2026/10/09/build-a-b2b-saas-on-azure-with-director-driven-development/).
- The onboarding steps in full: [`ONBOARDING.md`](https://github.com/Freakling/SaaSAllTheThings/blob/v0.11.0/ONBOARDING.md).

<div class="takeaway"><span>Install, settle the stack, answer the interview, approve one commit, then ask for the next task.</span><span class="url"><a href="index.md">All questions</a></span></div>
