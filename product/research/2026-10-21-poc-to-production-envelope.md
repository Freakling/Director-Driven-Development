# From proof of concept to production in an enterprise: the operating envelope, where people and process fail, and what SaaSAllTheThings brings
R6 · Informs: - · Verified as of 2026-10-21 · Size: M

## Question and assumptions
Question as set in R6. Assumptions:
- Pages were read through a fetch tool that summarises them; "not covered" means not found on the page read.
- SaaSAllTheThings (SATT) was read at v0.9.1, marked Latest on its Releases page (17 Oct), as raw files at that tag. `tools/check.sh`, `check.cfg`, `install.sh`, the `assess.md` template and the `compliance/` seeds could not be opened. Whether the installer creates `compliance/` is unconfirmed.
- Not opened: ISF SoGP (paywalled), KICS, Terrascan, the Verizon DBIR full PDF (the executive summary came back as unreadable binary), the Mandiant full report, auditor evidence guidance. Those parts are labelled.
- "Enforced" means the check fails. No run was made. Technical guidance, not legal advice.

## Conclusion
The director's framing mostly holds on the records, with two corrections. Breach reports do put people, process and hygiene (stolen or abused accounts, phishing, third parties, unpatched exploited flaws, misconfiguration) alongside code flaws, but the 2026 DBIR and M-Trends now rank vulnerability exploitation first, so "not code" overstates it. And SATT's workshops cover much of the envelope as questions, but the check enforces only nine architecture and cost rules. Monitoring, backup and DR, PII, private endpoints and egress are partly guidance, partly workshop topics, and in places absent. "Whole supply chain" is not supported: no SATT page read mentions supply chain, dependencies or vendor assessment. "More security", "easier compliance proof" and "than others" need a deployment or an audit. Confidence: high on SATT file content at v0.9.1, medium on breach percentages (secondary coverage), low on auditor expectations (unsourced).

## 1. What the breach reports say
| Report, edition, sample | Finding relevant here | Source state |
|---|---|---|
| Verizon DBIR 2026; breaches Nov 2024 to Oct 2025; more than 22,000 breaches, 31,000 incidents (secondary) | Vulnerability exploitation 31% of initial access, first time ahead of stolen credentials in 19 years (Verizon news page quotes 31%). Phishing 16% and credential abuse 13% from one secondary source; another gave credentials 23%. Unresolved. Third party involved in 48% of breaches (Verizon news page). Human element 62% (secondary; Verizon's page gave no overall figure). Only 26% of CISA known-exploited flaws fully remediated, median time to patch 43 days (Help Net Security). No headline misconfiguration share | Primary page partial; credentials share unverified |
| IBM Cost of a Data Breach 2026 (article dated 30 Jul 2026) | Phishing top initial vector, supply chain compromise second, then valid account abuse; no percentages found. Average cost 4.99 million USD. Malicious attacks 55%, human error 23%, IT failure 22%. 92% of organisations with AI incidents lacked adequate AI access controls | Secondary only; IBM page not opened |
| Microsoft Digital Defense Report 2025 (Jul 2024 to Jun 2025) | More than 97% of identity attacks are password attacks; identity attacks up 32% in H1 2025 (The Record, quoting Microsoft). Phishing-resistant MFA stops over 99% (search snippet of Microsoft text). No 2025 per-second figure found (4,000 identity and 11,000 password attacks per second is the 2023 report). Misconfiguration share not found | Secondary; report PDF not opened |
| Mandiant M-Trends 2026 (2025 investigations, over 500,000 hours) | Exploits 32% (sixth year first), voice phishing 11%, prior compromise 10%, email phishing 6% (Google Cloud blog). Stolen credentials 9% only via SecurityWeek. Cloud: voice phishing 23%, third-party compromise 17%, stolen credentials 16% (SecurityWeek only) | Blog primary; cloud split secondary |
| CSA Top Threats to Cloud Computing 2024 (survey of over 500 experts); 2025 Deep Dive reuses it | Order listed: misconfiguration and inadequate change control, IAM, insecure interfaces and APIs, inadequate cloud security strategy, insecure third-party resources, insecure software development, accidental disclosure, system vulnerabilities, limited visibility, unauthenticated sharing, APTs. The page does not say the order is a rank | CSA page, high |

Reading: credentials, vulnerability exploitation and phishing stay separate categories. Exploitation of unpatched systems (an operations and patching failure, not an application-code bug) leads two reports. Identity, third parties and misconfiguration lead the cloud-specific lists. Software development is sixth in the CSA list. So "code vulnerabilities are not the main risk" is supported only for your own application code; the sources do not split application code from platform and product flaws.

## 2. The envelope, with a source for each part
| Part | Source of the part | Note |
|---|---|---|
| Reliability, recovery, resiliency | Azure Well-Architected, reliability pillar: "Resiliency, availability, recovery" | WAF pillars are five, including performance efficiency |
| Security: data protection, threat detection | WAF security pillar | |
| Operations: observability, safe deployment | WAF operational excellence: "Holistic observability, DevOps practices" | |
| Cost | WAF cost optimization | |
| Identity and access | CAF landing zone design area B: "a primary security boundary in the public cloud" | |
| Network topology and connectivity | CAF design area E | Private endpoints and egress sit here as design choices; the page read does not name them |
| Governance, management baseline (visibility, protect and recover), security, platform automation | CAF compliance design areas F, D, G, H, I | Management "protect and recover" is where backup and DR live |
| Control domains | ISO 27001:2022 Annex A, 93 controls in four themes: organisational 37, people 8, physical 14, technological 34 (isms.online) | Public summary only; ISF SoGP topics not read |
| Evidence an auditor asks for | Not sourced. Common practice: control description, evidence of operation, traceability. Treated as unverified | Needs the customer's auditor |

PII handling, privileged production access, and exfiltration-proof networking are not named in the pages read; they fall under identity, network and security design areas and under the customer's control framework.

## 3. Tools at those layers
R5's code-level table stands. No AI tool page read says anything on infrastructure as code, identity, network or operations, so each is "not covered" (pages as listed in R5). Open gap.

| Tool | What it does | Stage | Blocks? |
|---|---|---|---|
| Azure Policy | Effects include deny, denyAction, audit, auditIfNotExists, deployIfNotExists, modify, append. Evaluates create or update requests before the resource provider; existing resources are assessed for compliance | At deployment, and continuously | Deny blocks; audit reports. Learn page, updated 2025-12-01 |
| Defender for Cloud | Foundational CSPM (free): inventory, Microsoft Cloud Security Benchmark recommendations, secure score. Paid Defender CSPM: attack paths, internet exposure analysis, data security posture, regulatory compliance assessments, PR annotations (page dated 2026-09-11) | Runtime posture; paid tier adds code-to-cloud | Recommends; does not block |
| Checkov | Static IaC scanning (Terraform, ARM, CloudFormation, Helm, Kubernetes, Docker), over 750 built-in checks; CI integrations listed | In CI or pre-commit | Exit and soft-fail behaviour not read |
| tfsec | Terraform static analysis; non-zero exit on findings; engineering attention moved to Trivy | In CI | Yes, by exit code |
| KICS, Terrascan | Not opened | Unknown | Unknown |

Not seen in SATT: no Azure Policy, Defender or IaC scanner reference was found in the pages read. SATT's check runs only on files and never calls Azure. Its Bicep checks are the `cost-sku` rule and Bicep build when the CLI is installed (docs page). So SATT sits at the pull-request and local stage; Azure Policy and Defender sit at deployment and runtime. They complement each other.

## 4. SaaSAllTheThings v0.9.1 against the envelope
| Envelope part | Assessment (`assess.md`) | Workshop | Reference architecture | Check |
|---|---|---|---|---|
| Control framework requirements | Reads the optional director brief; "does not check compliance itself" | Vision lists "compliance, the customer's Azure governance" as a constraint | `architect.md` reads `compliance/` and PRD Data and Compliance; every option is also checked against OWASP, least privilege, zero trust, and any named standard (ISO 27001, SOC 2, GDPR) | Not enforced |
| Identity, roles | "Identity" dimension | Tenancy and identity: roles, "Operator access for our own staff" | OIDC, app roles, local auth keys disabled where Azure allows | Not enforced; `tenant-source` is a code rule |
| Privileged and production access | Not covered | Operations: "groups, just-in-time for production" | Groups only, never individual assignments; production access just-in-time where the customer's governance has it | Not enforced |
| Secrets | Scanned, `file:line` only | Operations: Key Vault, managed identities | No secrets; federated credentials | Enforced: `secrets` |
| Tenant isolation | Data and single-tenant habits | Tenancy | TenantId in every record and partition key; every store has an isolation test | Partly: `tenant-source`, `tenant-branching`; isolation tests are guidance and `/tenant` gate |
| PII | "Whether anything identifies a customer" (tenancy, not PII) | Tenancy: "what's personal"; data map with owner, personal or not, retention | Personal data out of logs and partition keys; the PRD decides which fields | Absent. Director brief: undecided items stay open questions |
| Monitoring | Not covered | Operations asks "who is alerted for what"; does not ask what to monitor | Logs with TenantId, alerts for failed requests, dead letters, reconciliation drift, budget; anonymous `/api/health` | Absent |
| Backup, DR | Not covered | "Recovery point and time" under service levels; backup and DR not named | Cosmos DB continuous backup, 7 days; one region (serverless); no restore steps | Absent |
| Network, private endpoints, egress | Not covered | Not mentioned (integration workshop covers outbound-only connector or VPN) | `infra.md` does not cover them; there is no `networking.md` at v0.9.1 | Absent |
| Deployment control | "Delivery and operations" dimension | Pipelines, workload identity, production approvals | What-if, smoke test, never complete mode; prod from a tag behind approval, deployed by the human | `cost-sku` only; other Bicep checks absent |
| Cost | Not covered | Budgets and alerts | Default SKUs | Enforced: `cost-sku` |
| Supply chain (dependencies, vendors) | Not covered | Not mentioned | Not found | Absent (`layers` blocks external packages in domain and contracts only) |
| Compliance evidence | Report in `assessment/`, untracked until committed | Outputs go to PRD and `product/decisions.md` | ADRs with Decides, Deviates from, Exception line; removal item in `TASKS.md` | Exceptions only apply to accepted ADRs |

The nine enforced rules: `layers`, `domain-purity`, `tenant-source`, `tenant-branching`, `secrets`, `file-size`, `host-size`, `message-version`, `cost-sku`. All fail; no warn level was seen in the pages read (`check.cfg` not read). `release.md` says evidence is to be recorded but not where, and has no separate network or backup check. The ADR template has no field linking a decision to a named control. Onboarding forbids claiming "a control framework satisfied, because the brief names it." This is the framework's own limit, and it supports honest wording.

## 5. Assessment of the claims
| Claim | Verdict | Basis |
|---|---|---|
| Whole supply chain is considered | Does not hold | Not in the blog, README, workshops, or reference pages read. The blog says it does not address supply chain; IBM and Verizon rank third-party and supply chain compromise high |
| Workshops on production readiness | Holds in part | Operations workshop covers environments, delivery, security, service levels, support, cost; tenancy covers data rules. Backup, DR, monitoring design, networking and PII handling are not agenda items |
| Requirements anchored in the control framework | Holds as process | `architect.md` reads `compliance/` and weighs options; the blog says the director audits what the machine does not enforce. Mapping to named controls is absent |
| Evidence a reviewer can read | Holds | ADRs, `decisions.md`, `TASKS.md`, commit history, assessment reports |
| More security | Needs a deployment or audit | Records show intended rules, not outcomes |
| Easier compliance proof | Needs an audit | No auditor has judged these records; evidence of operation (logs, restores, access reviews) is outside the repository |
| Than others | Needs a comparison | R4 and R5 found no evidence either way |

Sentences that hold:
- "The framework reads your security requirements in every architecture session and records each deviation as a decision you accept."
- "Workshops cover environments, delivery, production access, service levels, tenancy and data rules."
- "A check fails the build on nine architecture, secret and cost rules."
- "Every decision and change leaves a record a reviewer can read."

Sentences that do not hold: "considers the whole supply chain", "covers backup, disaster recovery, monitoring and private networking", "more secure than", "easier to prove compliance", "production-ready".

## Options and recommendation
| Option | Means | Risk |
|---|---|---|
| A. Director's framing as stated | Full envelope, supply chain, more secure | Three unsupported claims |
| B. Honest envelope | "Production readiness takes more than code. These are the parts, this is what the framework asks about, enforces and leaves to you" | Holds; invites questions on gaps |
| C. Close the gaps, then claim | Builder items: workshop agenda items and reference pages for backup and DR, monitoring, PII, network and egress, supply chain; Bicep checks for public network access | Costs time; turns guidance into enforcement |
| D. Audit | Pilot deployment plus a reviewer on a real control framework | Only route to the strong claims |

Recommendation: B for the post now, with C items filed first (the largest gaps: backup and DR, private endpoints and egress, PII, supply chain), and D later. Use the breach evidence carefully: identity, third parties, misconfiguration and patching lead, but exploitation also leads, so say "not only code". Pair SATT with Azure Policy and Defender for Cloud at deployment, and say the check does not replace them. This changes if a deployment or audit produces evidence, or if a later release adds the missing topics.

## Sources
| Claim | Source | Type | Tier | Confidence |
|---|---|---|---|---|
| SATT v0.9.1 Latest, 17 Oct | github.com/Freakling/SaaSAllTheThings/releases/latest | Project release | 2 | High |
| Rules, check table, exceptions | raw `framework/.satt/rules.md`, `reference/README.md` at v0.9.1 | Product repo | 2 | High |
| Reference content (identity, data, infra, observability, tenancy) | raw `reference/*.md` at v0.9.1 | Product repo | 2 | High; summarised fetch |
| Workshops (vision, tenancy and identity, operations, integration), file list | raw `workshops/*.md`; GitHub tree | Product repo | 2 | High |
| Assessment scope | raw `procedures/assess.md` | Product repo | 2 | High |
| `architect.md`, ADR template, release runbook | raw `procedures/architect.md`, `templates/adr.md`, `procedures/release.md` | Product repo | 2 | High |
| Onboarding and `compliance/` use | raw `ONBOARDING.md`; README | Product repo | 2 | Medium; installer not read |
| Blog claims | saemundsson.se, 2026-10-13 | Author | 4 | High for content |
| DBIR 2026 exploitation 31%, third party 48% | verizon.com news page | Vendor | 2 | High |
| DBIR phishing 16%, credentials 13% vs 23%, human 62%, patch figures | WebSearch results; helpnetsecurity.com 2026-05-20 | Secondary | 4 | Low to medium; conflict unresolved |
| IBM 2026 ranking and costs | esecurityplanet.com 2026-07-30 | Secondary | 4 | Medium |
| MDDR 2025 identity figures | therecord.media 2025-10-16; search snippet | Secondary | 4 | Medium |
| M-Trends 2026 vectors | cloud.google.com blog m-trends-2026; securityweek (cloud split) | Vendor; secondary | 2; 4 | High; medium |
| CSA threats list | cloudsecurityalliance.org artifacts, 2024 | Standard body | 2 | High on list, rank unconfirmed |
| WAF pillars, CAF design areas | learn.microsoft.com (updated 2025-10-30; 2026-10-13) | Official docs | 2 | High |
| Azure Policy effects | learn.microsoft.com effect-basics (2025-12-01) | Official docs | 2 | High |
| Defender CSPM | learn.microsoft.com (2026-09-11) | Official docs | 2 | High |
| Checkov, tfsec | checkov.io; github.com/aquasecurity/tfsec | Official | 2 | Medium |
| ISO 27001 Annex A counts | isms.online | Interpretation | 4 | Medium |
| R5 code-level table | product/research/2026-10-20-production-readiness-of-ai-coding-tools.md | Project note | 1 | Medium to high |

Not accessible: Verizon executive summary (binary), TechRepublic (403), GitHub code search (sign-in).

## Open gaps
- DBIR credential-abuse share (13% or 23%) and human-element share: read the full report.
- IBM and MDDR primary pages; Mandiant stolen credentials share.
- ISF SoGP topics, auditor evidence expectations, KICS, Terrascan, Checkov exit behaviour.
- `check.sh`, `check.cfg`, `install.sh`, `compliance/` seeds, `observability.md` beyond what the fetch summarised; the fail vs warn split unconfirmed.
- AI tools at the infrastructure layers were not extended beyond R5.
- A builder item could trace each SATT rule and workshop topic to ISO 27001 Annex A controls (labelled partial) and test the rules on the example app.
