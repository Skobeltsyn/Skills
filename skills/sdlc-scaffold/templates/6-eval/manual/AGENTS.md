Human evaluation. One dated folder per test round, `YYYY-MM-DD`, each holding a
`test_cases/` folder.

## Test cases follow ISO/IEC/IEEE 29119-3

Every manual test case is documented to the ISO/IEC/IEEE 29119-3 test case
specification, so a tester who has never seen this project can execute it and
get the same verdict. At minimum each states:

- **identifier** — `TC-{number}`, permanent, never reused
- **objective** — what this case establishes
- **use-case** — the `UC-{number}` it exercises
- **priority**
- **preconditions** — the state the system must be in before step 1
- **inputs and steps** — numbered, each unambiguous and independently checkable
- **expected result** — per step where it matters, and overall
- **actual result** — recorded at execution, never predicted
- **verdict** — PASS / FAIL / BLOCKED

Verify field names and structure against the standard itself before claiming
conformance — this list is the working set, not a citation of the clause.

## Written for a stranger

A manual test case is executable by someone with no context. "Log in and check it
works" is not a test case: it names no precondition, no input, and no checkable
expected result. If two testers could reasonably reach different verdicts, the
case is underspecified and the fault is the case, not the tester.

## Actual results are recorded, never predicted

Fill **actual result** at execution time from what happened. A case whose actual
result was written before the run is not evidence of anything.

`BLOCKED` when the case could not be run. Never round it to `FAIL` — a test that
did not run has told you nothing about the system.
