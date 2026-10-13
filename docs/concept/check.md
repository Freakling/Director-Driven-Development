# The check

One check defines done. Each framework ships it as `bash tools/check.sh`, and each enforces its own rules.

## What the check covers

| Framework | The check |
|---|---|
| Godot-Director | Godot's import pass; loads every script, scene and resource; fails screen scripts that hold game rules; runs the tests; scans Godot's output for errors |
| App-Director | UI purity (UI files may not import the data layer); secrets with gitleaks; the stack's type check, lint and tests |
| SaaSAllTheThings | The architecture rules (layers, tenant source, secrets, file sizes, cost SKUs and more); the backend build and tests; the Bicep files |

All three also run `tools/check.local.sh` when a project has one.

## Exit codes

The check exits 0 on pass, 1 on fail and 3 when it cannot run, so "it could not run" is never read as a pass.

## The pre-commit hook

The git pre-commit hook runs the check before any commit that touches code. A failing task cannot land.

## Reviews

The check runs for every task, every time. It is fast and mechanical, and it never gets tired. Large changes, and medium ones that cross a risky boundary, also get an independent review before the commit. See [Reviews](reviews.md).

<div class="takeaway" markdown><span>Enforce what's critical, audit the rest.</span><span class="url" markdown="span">[Reviews](reviews.md)</span></div>
