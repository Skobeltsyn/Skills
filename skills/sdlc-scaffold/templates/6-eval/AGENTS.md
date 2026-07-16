Evaluate `5-results/` against the **use-cases** in `2-specs/use-cases/` — never
against requirements directly, and never against the implementation's own
assumptions.

A use-case is the only spec that is executable: it names an actor, a trigger, an
entity, and an outcome, which is a test. Actors, entities, and events are
definitions — there is nothing to run. A requirement is intent, and is satisfied
only through the use-cases that realize it.

## Structure

```
6-eval/
├── auto/<date>/{integration,unit,llm}/   machine-run evidence
├── manual/<date>/test_cases/             human-run test cases
└── DASHBOARD.md                          the roll-up
```

`<date>` is `YYYY-MM-DD`, one folder per run, so lexical order is chronological.

Everything below `auto/` and `manual/` is a **content folder** — no `README.md`,
`AGENTS.md`, or `CLAUDE.md` inside a dated folder or a type folder. The rules for
`integration/`, `unit/`, `llm/`, and `test_cases/` live in the `AGENTS.md` of the
last fixed level above them: `auto/AGENTS.md` and `manual/AGENTS.md`.

## Every file carries a test-case table

Every file in this stage — automated or manual, evidence or verdict — opens with
a table of the test cases it covers:

| Test case | Use-case | Objective | Expected result | Verdict |
|-----------|----------|-----------|-----------------|---------|
| `TC-1` | `UC-12` | … | … | PASS / FAIL / BLOCKED |

Cite the use-case by id, never by path. A row with no use-case id proves
nothing: it is an assertion about the system that nothing in the pipeline asked
for.

`BLOCKED` is a real verdict and is not `FAIL` — a test that could not run has
told you nothing about the system, and collapsing it into `FAIL` invents
evidence.

## The dashboard

`DASHBOARD.md` is the roll-up, and the only place "is `R7` satisfied?" is
answerable by looking. The trace from a requirement to its use-cases otherwise
runs through business tasks and specs — two hops, both by search.

It states, per requirement: every use-case serving it, that use-case's latest
verdict, and the date and run that produced it.

A requirement with no test cases is **untested**, which is not the same as
passing. Say so on its row. Absence of a failure is not evidence of a pass, and
a dashboard that renders "no results" as green is worse than no dashboard.

Regenerate the dashboard on every run. It is a **view**, not a frozen artifact —
it is overwritten, and the freeze does not apply to it. The durable records are
the dated run folders it reads.
