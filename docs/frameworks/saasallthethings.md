# SaaSAllTheThings

<div class="kicker">Multi-tenant B2B SaaS on Azure</div>

Build a B2B SaaS from scratch, or turn a working proof of concept or an existing app into a mature, multi-tenant SaaS, with an AI assistant doing the building. You own the product: what it does, for whom and in what order. The framework owns the architecture and enforces it. The AI builds within that architecture, tests and keeps the records.

The architecture: an event-driven Azure Functions backend, separate Windows and mobile clients, OIDC sign-in with Entra ID and federated identity, pooled multi-tenancy that can move a customer to its own deployment later, and enterprise integrations starting with Navision (Dynamics NAV and Business Central). The product is anchored in the customer's own security framework: architecture sessions read the security and compliance requirements kept in the app's `compliance/` folder, and weigh every option against them.

[Repository](https://github.com/Freakling/SaaSAllTheThings){ .md-button .md-button--primary } [README](https://github.com/Freakling/SaaSAllTheThings#readme){ .md-button } [Procedures](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures){ .md-button } [Reference architecture](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/reference){ .md-button }

## What the check enforces

`bash tools/check.sh` runs four steps:

1. The architecture rules (`tools/archcheck.awk`).
2. The backend stack's build and tests (`dotnet`, `typescript`, `python` or `none`).
3. The Bicep files in `infra/`, when the Bicep CLI is installed.
4. `tools/check.local.sh`, if the app has one (client builds, emulator tests).

`bash tools/check.sh --architecture` runs step 1 alone in seconds, with no toolchain. The check never calls Azure, the network or an external system.

| Rule | Fails when |
|---|---|
| `layers` | A layer depends on a layer it may not, or the domain or contracts take an external package |
| `domain-purity` | Domain code reads the clock, makes ids or random numbers, reads the environment, or does I/O |
| `tenant-source` | A host reads the tenant from a header, query, route or form, or an API contract carries a tenant id |
| `tenant-branching` | Code compares a tenant with a literal |
| `secrets` | A file holds something that looks like a key, password, connection secret or private key |
| `file-size` | A source file is longer than `max_lines` (300 by default) |
| `host-size` | A host or platform file is longer than `host_max_lines` (80 by default) |
| `message-version` | An event or command type isn't named `…V<n>` |
| `cost-sku` | Bicep asks for a premium, isolated or dedicated SKU, or provisioned Cosmos DB throughput |

### Deviation is an ADR

The only way past a rule is an architecture decision record that you accept. An exception is one line in an accepted ADR, naming a rule and a path pattern:

```
- Exception: domain-purity src/OrderDesk.Domain/Legacy/**
```

`/architect` runs the session that produces the ADR, with "comply" always as the first option. A hook asks you before an ADR is marked accepted or a framework file changes.

## Install

You need git with no uncommitted changes, bash (on Windows it comes with Git for Windows), and the toolchain of your backend stack: the .NET SDK 8 or newer for the default. Every option installs the latest release, tagged `v` followed by its version, not `main`.

=== "Claude Code plugin"

    ```
    /plugin marketplace add Freakling/SaaSAllTheThings
    /plugin install saasallthethings@saasallthethings
    ```

    Then open a new session in the app's folder and run `/saasallthethings:saas-all-the-things`.

=== "Manual"

    Clone the latest release into the app's root folder as `SaaSAllTheThings`, using the release's tag from the [Releases page](https://github.com/Freakling/SaaSAllTheThings/releases):

    ```
    git clone --branch <tag> --depth 1 https://github.com/Freakling/SaaSAllTheThings.git SaaSAllTheThings
    ```

    Then ask your assistant:

    > Read SaaSAllTheThings/ONBOARDING.md and follow it to install SaaSAllTheThings into this project.

=== "Skill"

    ```
    npx skills add Freakling/SaaSAllTheThings
    ```

    Then ask your assistant to "SaaS all the things" in the app's folder.

Onboarding works out whether this is a new app, an existing app or an upgrade, settles the backend stack with you, interviews you or reads the app (including its single-tenant habits and secrets), writes the first stages of the roadmap into `TASKS.md`, and ends with one commit for you to approve. Restart Claude Code afterwards so the commands load. Each new clone later needs `bash tools/setup-clone.sh`.

## Skills you can use without installing

| Skill | What it does |
|---|---|
| `saas-all-the-things` | Installs or upgrades SaaSAllTheThings in the app open in the session |
| `saas-assessment` | Analyses an existing app without changing it: readiness with evidence, the roadmap by stage with rough effort, and the workshops to hold |
| `saas-design-session` | Runs architecture and product sessions, integration contracts and workshops in Claude Code, Cowork or the Claude apps, with or without the repository |

## Commands

| Command | What it does |
|---|---|
| `/next-task` | Builds the next ready item in a fresh context within the reference architecture, proves it with the check, updates the records and commits it once you approve. A run you ask for, such as "grab tasks until you're blocked", commits each item without pausing |
| `/assess` | A read-only assessment report; "process the workshop notes" turns a workshop's decisions into records |
| `/roadmap` | Plans the next stage of the move to SaaS as small items |
| `/design` | A product design session on a topic, or `/design questions` to rank the open questions |
| `/research` | A read-only researcher answers one question in a fresh context and writes a dated note with its sources to `product/research/`. It informs; you decide. Procedure: [`research.md`](https://github.com/Freakling/SaaSAllTheThings/tree/v0.8.0/framework/.satt/procedures/research.md) |
| `/architect` | An architecture session that ends in an ADR you accept |
| `/integrate` | Works out an integration contract with you (direction, system of record, conflicts), then plans it in stages |
| `/tenant` | Checks readiness for a new customer and hands you the consent and setup steps |
| `/acceptance` | Prepares or processes a checklist of built behaviour for you to tick Works or Broken |
| `/feedback` | Turns a customer or pilot session into bugs, score trends and product proposals |
| `/release` | Check, what-if, deploy and smoke test, each Azure step with your approval. Production is yours to run |
| `/align` | Consistency pass across the PRD, decisions, ADRs, integration contracts, tasks, `AGENTS.md`, settings and code |
| `/drift-reset` | Product design drift reset, started only by you; `/drift-reset postmortem` after the rebuild |
| `/prune` | Moves done items to `TASKS-archive.md` |
| `/refresh-model-sizing` | Sets or updates the model for each task size |

## Read more

- [Build a B2B SaaS on Azure with Director-Driven Development](https://saemundsson.se/2026/10/09/build-a-b2b-saas-on-azure-with-director-driven-development/), the step-by-step guide
- [The concept](../concept/index.md) and [agent development flow](../concept/agent-flow.md)

<div class="takeaway"><span>You own the product. The framework owns the architecture.</span><span class="url"><a href="https://github.com/Freakling/SaaSAllTheThings">Freakling/SaaSAllTheThings</a></span></div>
