# {{PROJECT_NAME}}

Work flows through ten numbered stages, from raw idea to running system and back
again. This README orients a human arriving cold. The agent-facing charter — the
rules any coding agent must follow — is [`AGENTS.md`](AGENTS.md).

## The pipeline

```
0-vibes/ → 1-business-tasks/ → 2-specs/ → 3-design/ → 4-tasks/
 idea/prd    observe & plan      specs      design    implementation
                                                           │
   ┌───────────────────────────────────────────────────────┘
   ▼
5-results/ → 6-eval/ → 7-security-check/ → 8-deploy/ → 9-observation/
  built       quality      security         release      watch → (loops back to 1)
```

It is a **loop**, not a line: `9-observation/` feeds signals back into
`1-business-tasks/observation/` to start the next cycle. Stages are never
skipped — a spec references a planning task, a design references a spec — so
every artifact traces upstream to the need that produced it.

## Finding your way

| Stage | Holds |
|-------|-------|
| [`0-vibes/`](0-vibes/) | Raw ideas and direction, and the PRDs they harden into |
| [`1-business-tasks/`](1-business-tasks/) | Why: signals observed, and plans shaped from them |
| [`2-specs/`](2-specs/) | How it should work: actors, entities, events, modules, use-cases |
| [`3-design/`](3-design/) | What it looks like: Figma source, and framework components |
| [`4-tasks/`](4-tasks/) | The implementation work itself |
| [`5-results/`](5-results/) | What got built, linked back to the task |
| [`6-eval/`](6-eval/) | Whether it is any good |
| [`7-security-check/`](7-security-check/) | Whether it is safe to ship |
| [`8-deploy/`](8-deploy/) | Releasing it, and how to roll back |
| [`9-observation/`](9-observation/) | Watching it run — which reopens the loop |

Each folder carries its own `README.md` explaining what it is for and stating
the one condition an item must meet to leave it.

## Two files govern every folder

- **`README.md`** — for humans. The charter: purpose, structure, exit criterion.
- **`AGENTS.md`** — for agents. The hard rules: ID schemes, required sets,
  generation instructions.

A `CLAUDE.md` stub sits beside them importing the `AGENTS.md`, because Claude
Code does not read `AGENTS.md` by default. It holds nothing else. **Every rule
lives in exactly one file** — if you find yourself editing a `CLAUDE.md`, you are
editing the wrong file.
