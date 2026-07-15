# 7 — Eval

Evaluation of the results (`../6-results/`) against the specs (`../3-specs/`).
Did what we built do what it was supposed to? The **quality gate**.

An item passes this stage when it meets its acceptance criteria and moves on to
`../8-security-check/`.

## What goes here
- Test results and acceptance-criteria checks
- Evaluation reports (functional, quality, performance)
- Pass/fail verdicts linked back to specs

## Automated eval

If the deliverable can be exercised automatically, add an `auto/` harness here
that runs on every change and writes its evidence back into this folder:

- One output folder per unit under test, each with a machine-readable
  `record.json` plus whatever artifacts prove the verdict (screenshots, logs).
- A top-level `summary.json` with the totals.
- A non-zero exit code when any check fails, so it works as a CI gate.
- Committed output, so the repo always holds the latest evidence traceable back
  to `../3-specs/`.

Summarize the latest run here — counts and pass/fail — so the gate's state is
readable without running it.
