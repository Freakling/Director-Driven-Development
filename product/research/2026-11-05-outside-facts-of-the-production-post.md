# Do the outside facts in the production post still hold on 5 November 2026?
R9 · Informs: - · Verified as of 2026-11-05 · Size: M

## Question and assumptions
Question as asked: do sixteen outside statements from the post of 21 October 2026, "From proof of concept to production: the part that is not code", still hold today? The DDD frameworks are out of scope; the post's SaaSAllTheThings content was read separately from the release copy at v0.16.1.

Assumptions:
- Pages were read through fetch tools that summarise them. Quotes are what the tool returned from the page.
- A figure is primary when the owner's own page states it, and secondary when only a news or vendor write-up gives it.
- The full PDFs of DBIR, M-Trends, IBM and the Digital Defense Report were not opened.

## Conclusion
Twelve of sixteen statements hold as worded, three hold with small caveats, and one needs correcting. The Microsoft link had moved, and the working page carries all three figures; the orchestrating session confirmed them in a browser. A 2026 Cloud Security Alliance edition reorders the ranking. IBM's sample is organisations rather than breaches, and one Azure Policy name was incomplete. Confidence is high where a vendor or docs page states the figure, and medium where only a secondary summary does.

## The sixteen statements
| # | Verdict | Evidence |
|---|---|---|
| 1 Verizon DBIR 2026 | Holds. 22,000 and 62 percent are secondary only | Primary: the Verizon news release gives 31 percent, first above stolen credentials in 19 years, and third party at 48 percent, "up 60%". Secondary: eSecurityPlanet gives more than 22,000 confirmed breaches, 62 percent human element, and "up from 30%". One analysis says Verizon widened the third-party measure in 2024, so year-on-year isn't strictly like for like |
| 2 Mandiant M-Trends 2026 | Holds. "25 days" is secondary only | Primary: the Google Cloud blog gives 32 percent, sixth year, voice phishing second at 11 percent, dwell 14 days, more than 500,000 hours. Secondary: Help Net Security gives 25 days for external notification |
| 3 Microsoft Digital Defense Report 2026 | Changed: new URL | https://www.microsoft.com/en-us/security/security-insider/threat-landscape/2026-digital-defense-report quotes "Nearly 40,000 CVEs were published in the first half of 2026", weaponisation "well below 24 hours", and remediation that "can take 30 to 60 days" |
| 4 IBM Cost of a Data Breach 2026 | Holds, fix the sample wording | Primary: 4.99 million dollars, up 12 percent. IBM India newsroom: "602 organizations". Secondary: Baker Donelson gives 17 industries, 247 days, "First Time in Five Years", and 53 percent on encryption. No "16 countries" found. "At rest or in transit" against "and" is unsettled, so the post no longer uses the figure |
| 5 Cloud Security Alliance | 2024 facts hold; a newer edition is out | Press release 2026-08-13: more than 500 experts; 1 IAM, 2 AI-Enhanced Attacks, 3 Third-Party Resources, 4 Interfaces and APIs, 5 Misconfiguration, 6 AI System Compromise, 9 Insecure Software Development. Opinion, not incident data |
| 6 CodeQL | Holds | The supported languages page doesn't list Bicep, Terraform or ARM |
| 7 Cursor Bugbot | Holds | "Bugbot doesn't read the contents of files whose path looks like a credential file", including Terraform state |
| 8 Codex Security | Holds | "A scan that reports no findings can still miss vulnerabilities." |
| 9 Azure Policy | Holds, fix a name | "Azure Cosmos DB should disable public network access"; "Azure Key Vault should disable public network access". Deny "prevents the request before being sent to the Resource Provider"; existing resources "are marked as non-compliant" |
| 10 Microsoft Security DevOps | Holds | The IaC page (updated 2026-08-10) names Template Analyzer, Checkov and Terrascan. No retirement found in the release notes of 2026-10-29 |
| 11 Defender for Cloud | Holds | It "continually assesses" compliance controls that can be automatically assessed; the rest show as greyed out. ISO IEC 27001:2022 and NIST SP 800 53 R5.1.1 are listed |
| 12 GitHub SBOM | Holds | Export from the dependency graph in SPDX format |
| 13 Service Bus private endpoints | Holds | "This feature is supported with the premium tier" |
| 14 Cosmos DB continuous backup | Holds | Tiers of 7, 30 and 35 days; the page names the "continuous 7-day tier" |
| 15 GDPR | Holds | Article 33(1), 72 hours; Article 32(1)(c) and (d). Read on gdpr-info.eu, a reproduction |
| 16 ISF Standard of Good Practice | Link works; 2026 edition not public yet | The 2026 edition is for ISF members; the full framework is promised to the public "later this year" |

## New since the post
- CSA Top Threats 2026 was published on 2026-08-13, before the post, which used the 2024 edition.
- The Digital Defense Report page has other headline figures, not used in the post.
- Claude Code Security is reported as renamed Claude Security, with conflicting reports on its status. The post now says "the newer scans from OpenAI and Anthropic".
- No newer edition of DBIR, M-Trends or IBM was found.

## Sources
| Claim | Source | Type | Tier | Confidence |
|---|---|---|---|---|
| 1 | verizon.com/about/news/breach-industry-wide-dbir-finds; verizon.com/business/resources/reports/dbir/; eSecurityPlanet, 2026 Verizon DBIR | Vendor; secondary | 3, 4 | High; medium |
| 2 | cloud.google.com/blog/topics/threat-intelligence/m-trends-2026; Help Net Security 2026-03-24 | Vendor; secondary | 3, 4 | High; medium |
| 3 | microsoft.com/en-us/security/security-insider/threat-landscape/2026-digital-defense-report | Vendor | 3 | High |
| 4 | ibm.com/reports/data-breach; in.newsroom.ibm.com; Baker Donelson, ten takeaways | Vendor; secondary | 3, 4 | High; medium |
| 5 | cloudsecurityalliance.org/press-releases/2026/08/13/ai-emerges-as-an-attack-enabler-and-target-in-csa-2026-top-threats-report | Standards body | 3 | High |
| 6 to 8, 12 | codeql.github.com; cursor.com/docs/bugbot; learn.chatgpt.com/docs/security/faq; docs.github.com | Docs | 2 | High |
| 9 to 11, 13, 14 | Microsoft Learn: policy references, deny effect, IaC scanning, Defender release notes, regulatory compliance, Service Bus Private Link, Cosmos DB continuous backup | Docs | 2 | High |
| 15 | gdpr-info.eu Articles 32 and 33 | Reproduction | 2 | Medium to high |
| 16 | securityforum.org Standard of Good Practice page | Publisher | 2 | High |

## Open gaps
- The full reports were not read. The 22,000 breaches, the human element share, 25 days, 17 industries and 247 days stay secondary, and the post says so.
- The exact IBM encryption wording is unsettled.
- Whether Terrascan's upstream repository is archived was not checked, nor any Microsoft Security DevOps retirement planned after 2026-10-29.
- The status of Anthropic's security product was not verified on its own page.
