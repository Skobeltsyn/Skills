# {{PROJECT_NAME}} — Agentic Development Workflow

Work flows through numbered stages, each living in its own folder. An artifact
only advances to the next stage once the previous one is complete.

## Workflow stages

```
0-vibes/ → 1-business-tasks/ → 2-specs/ → 3-design/ → 4-tasks/
 idea/prd    observe & plan      specs      design    implementation
                                                           │
   ┌───────────────────────────────────────────────────────┘
   ▼
5-results/ → 6-eval/ → 7-security-check/ → 8-deploy/ → 9-observation/
  built       quality      security         release      watch → (loops back to 1)
```

The pipeline is a **loop**: `9-observation/` feeds signals back into
`1-business-tasks/observation/` to start the next cycle.

### 0. Vibes — `0-vibes/`
The earliest, pre-planning stage: raw ideas, inspiration, and loose direction —
the **vibe**, before anything is structured. Contains:

- `0-vibes/prd/` — Product Requirements Documents: the first structured
  artifact that turns a vibe into stated product intent, ready to hand off to
  business tasks.

### 1. Business tasks source — `1-business-tasks/`
Where work originates: **observation and planning**. Raw business needs,
research notes, stakeholder input, opportunities, and high-level plans. This is
the "why" — problems worth solving, before they are broken down into concrete
work. Split into two halves:

- `1-business-tasks/observation/` — signals from the running system, users, and
  ops, triaged by severity: `errors/`, `warnings/`, `infos/`.
- `1-business-tasks/planning/` — high-level plans, roadmaps, and priorities
  shaped from what observation surfaces.

### 2. Specs — `2-specs/`
Detailed **specifications** for planning tasks. Each spec expands a task into
concrete requirements: behavior, data, edge cases, API contracts, and acceptance
tests. This is the "how it should work" — the source of truth an implementation
is validated against. Organized by concern:

- `2-specs/actors/` — who/what interacts with the system (roles, personas,
  external systems).
- `2-specs/entities/` — domain objects and their data (fields, relationships,
  invariants).
- `2-specs/events/` — things that happen (domain events, triggers, state
  transitions, side effects).
- `2-specs/modules/` — functional units that compose actors, entities, and
  events into behavior.
- `2-specs/use-cases/` — end-to-end scenarios tying an actor + event + entity
  to a result.

### 3. Design — `3-design/`
**Design components** produced from specs. Organized by target:

- `3-design/figma/` — Figma source of truth. The linked Figma file (see
  `3-design/figma/AGENTS.md`) is the design origin; components are exported /
  synced from here.
- `3-design/react/` — React component implementations.
- `3-design/vue/` — Vue component implementations.

**Rule: every component must have a Storybook story covering all its internal
states.** Each component in `react/` and `vue/` ships with its own Storybook
(`*.stories.*`) so it can be viewed, tested, and reviewed in isolation. A story
per component is not enough — every internal state the component can be in must
appear in it, matching the states of the Figma component it mirrors.

This rule is stated in four places on purpose (here, `3-design/README.md`, and
both framework `AGENTS.md` files) so no agent can miss it. That makes it the one
deliberate exception to *one rule, one home* — change it in all four or it
drifts.

### 4. Tasks — `4-tasks/`
Concrete **implementation/build tasks** derived from the specs and designs. This
is where validated design becomes engineering work ready to be built. Each task
links back to its spec (`2-specs/…`) and/or design (`3-design/…`).

### 5. Results — `5-results/`
The **output of implementation**: what was actually built. Delivered artifacts,
code, and outcomes, each traceable back to the task that produced it.

### 6. Eval — `6-eval/`
**Evaluation** of results against the specs — the quality gate. Test results,
acceptance-criteria checks, and pass/fail verdicts.

### 7. Security check — `7-security-check/`
**Security review** before shipping — the security gate. Vulnerabilities,
secrets, dependency risks, and access concerns caught here, not in production.

### 8. Deploy — `8-deploy/`
**Release** of the security-cleared results to their target environment.
Deployment configs, release notes, rollout/rollback plans.

### 9. Observation — `9-observation/`
**Watching the deployed system** in production, triaged by severity (`errors/`,
`warnings/`, `infos/`). Closes the loop: signals feed back into
`1-business-tasks/observation/` to start the next cycle.

## Conventions

- Stage folders are numbered to reflect the direction of flow.
- Do not skip stages — a spec references a task, a design references a spec.
- Keep each artifact traceable to its upstream source (link back by id/name).
- Each stage's `AGENTS.md` holds its naming and generation rules; its
  `README.md` explains what the stage is for. Read the `AGENTS.md` before
  generating anything into a stage.
- Rules are written **once**, in `AGENTS.md`. The `CLAUDE.md` beside it is a
  stub that does nothing but `@AGENTS.md` — never copy rules into it, and never
  let the two drift.
