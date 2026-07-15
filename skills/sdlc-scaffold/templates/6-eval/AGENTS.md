Evaluate ../5-results/ against the specs in ../2-specs/ — never against the
implementation's own assumptions.

Every verdict is pass/fail and names the spec or acceptance criterion it checks.
A verdict with no spec link proves nothing.

If the deliverable can be exercised automatically, add an auto/ harness that
runs on every change and writes its evidence back here:
- one output folder per unit under test, each with a machine-readable
  record.json plus whatever artifacts prove the verdict (screenshots, logs)
- a top-level summary.json with the totals
- a non-zero exit code when any check fails, so it works as a CI gate
- committed output, so the repo always holds the latest evidence

Summarize the latest run in the README — counts and pass/fail — so the gate's
state is readable without running it.
