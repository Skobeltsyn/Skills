Human execution of the shared test-case fields (see `../AGENTS.md`). One dated
folder per test round, `YYYY-MM-DD`, each holding a `test_cases/` folder.

What is specific to manual runs:

## Documented to ISO/IEC/IEEE 29119-3

Each case is written to the ISO/IEC/IEEE 29119-3 test case specification so a
tester who has never seen this project can execute it and reach the same
verdict. Verify field names and structure against the standard itself before
claiming conformance — the field set in `../AGENTS.md` is the working set, not a
citation of the clause.

## Written for a stranger

"Log in and check it works" is not a test case: no precondition, no input, no
checkable expected result. If two testers could reasonably reach different
verdicts, the case is underspecified — and the fault is the case, not the
tester.

## The human records the actual result

Filled at execution from what happened, never before. `BLOCKED` when the case
could not be run — a person's judgment that setup failed is still a recorded
verdict, not a `FAIL`.
