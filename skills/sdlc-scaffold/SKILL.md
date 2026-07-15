---
name: sdlc-scaffold
description: Scaffold the numbered agentic SDLC pipeline (0-vibes → 1-business-tasks → 3-specs → 4-design → 5-tasks → 6-results → 7-eval → 8-security-check → 9-deploy → 10-observation) into a repo — stage folders, per-stage README charters, and per-stage CLAUDE.md convention files. Use when starting a new project on this workflow, backfilling missing stages in an existing one, or when asked to "set up the pipeline / the stage folders / an SDLC scaffold".
---

# SDLC pipeline scaffold

Builds the numbered stage skeleton that this workflow runs on. The scaffold is
**structure and conventions only** — no domain content. Domain artifacts (PRDs,
specs, components) are authored later, in-stage, by following each stage's
`CLAUDE.md`.

## Run it

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/scaffold.sh" <target-dir> --project "Name"
```

`${CLAUDE_SKILL_DIR}` resolves to this skill's own directory, so the command is
identical whether the skill is installed as a plugin, sits in `~/.claude/skills/`,
or is vendored into a project's `.claude/skills/`. Do not rewrite it as a
literal path.

- Idempotent: existing files are **skipped**, never clobbered. Safe to re-run to
  backfill stages added later. Pass `--force` to overwrite.
- `--project` fills `{{PROJECT_NAME}}` in the root `CLAUDE.md`.
- `--dry-run` lists what would be written.
- Run `--dry-run` first when the target already has content, so the skip list is
  visible before anything lands.

Then do the **adaptation pass** below — an unadapted scaffold is a template, not
a pipeline.

## The pattern being reproduced

### 1. Number encodes flow direction

```
0-vibes/ → 1-business-tasks/ → 3-specs/ → 4-design/ → 5-tasks/
                                                          │
   ┌──────────────────────────────────────────────────────┘
   ▼
6-results/ → 7-eval/ → 8-security-check/ → 9-deploy/ → 10-observation/
                                                            │
                        └─ loops back to 1-business-tasks/observation/
```

It is a **loop**, not a line. Stage 10 feeds stage 1. Stages are never skipped:
a spec references a task, a design references a spec.

**On the gap at 2:** the origin repo has a `2-tasks/` backlog stage that went
unused — its `CLAUDE.md` is empty and specs traced straight from
`1-business-tasks/planning/` (PT-*) to `3-specs/`. The scaffold omits it and
keeps the gap, because stage numbers are load-bearing identifiers baked into
cross-links (`../3-specs/…`) across every stage. If a project wants a distinct
backlog stage between "why" and "how it should work", add `2-tasks/` back rather
than renumbering.

### 2. Two files govern every stage — this is the core rule

| File | Audience | Contains |
|------|----------|----------|
| `README.md` | humans | The stage charter: what it's for, its structure, what goes here, and the **exit criterion** — one line in the form *"An item leaves this stage when …"* |
| `CLAUDE.md` | agents | The hard rules: ID naming schemes, required variant/size sets, generation instructions. Terse and imperative. |

Keep them separate. A `README.md` that explains a naming scheme gets ignored by
agents; a `CLAUDE.md` that waxes about purpose wastes context. Only stages that
actually **generate ID'd artifacts** need a `CLAUDE.md` — stages 5–10 ship with
`README.md` alone, and that's deliberate.

### 3. Every artifact type gets an ID scheme

Scaffolded schemes, verbatim from the origin pipeline:

| Stage | Artifact | Scheme |
|-------|----------|--------|
| `1-business-tasks/observation/` | observation task | `OT-{n}-{TYPE}.md` |
| `1-business-tasks/planning/` | planning task | `PT-{n}.md` |
| `3-specs/actors/` | actor | `ACTOR-{n}-NAME-IN-MODULE` |
| `3-specs/entities/` | entity | `ENT-{n}-NAME-IN-MODULE` |
| `3-specs/events/` | event | `EVT-{n}-NAME-IN-MODULE` |
| `3-specs/use-cases/` | use-case | `UC-{n}-ACTOR-{n}-EVT-{n}-ENT-{n}-RESULT-IN-MODULE` |
| `4-design/` | component | `FIG-{n}-{TYPE}-{VARIANT1-name}-{value}-…` |

Two properties worth preserving when inventing new schemes:

- **Composite IDs encode relationships in the filename.** `UC-1-ACTOR-1-EVT-2-ENT-3-SESSION-ESTABLISHED`
  states its actor, trigger, entity, and outcome before the file is opened —
  the directory listing *is* the traceability matrix.
- **One artifact per file.** Not one file listing many events. This is why
  `3-specs/events/` holds 26 separate `EVT-*.md` files.

### 4. Traceability runs upstream, always

Every artifact links back to what produced it, by relative link. Every subfolder
`README.md` carries an **index table** of its artifacts with those links — see
the `Source` / `PT` columns in the scaffolded spec READMEs. When the origin repo
lists `| PT-1 | Authentication | R1, R13, R16 |`, that row is the audit trail
from a PRD requirement to a module.

### 5. Severity triage appears at both ends of the loop

`1-business-tasks/observation/` and `10-observation/` both split into
`errors/` · `warnings/` · `infos/`. Same three folders, same meaning, because
stage 10's output becomes stage 1's input — a signal keeps its severity as it
crosses the loop boundary.

## Adaptation pass (do this after running the script)

1. **Root `CLAUDE.md`** — confirm the project name and that the stage list
   matches what you actually scaffolded.
2. **Prune what doesn't apply.** No design surface? Drop `4-design/` and say so
   in the root `CLAUDE.md`. Better to remove a stage than leave it hollow.
3. **Pick the design targets.** The scaffold ships `figma/`, `react/`, and
   `vue/`. Delete the frameworks the project won't use — each carries a "every
   component ships a Storybook story" rule that must stay true.
4. **Paste the Figma file URL** into `4-design/figma/CLAUDE.md` (it scaffolds as
   a `TODO`).
5. **Set the design constraints** in `4-design/CLAUDE.md` — it scaffolds with
   the origin's Roboto / min-14px / `xs md lg xl xxl` size set. These are that
   project's choices, not laws.
6. **Leave index tables empty until artifacts exist.** An index promising specs
   that were never written is worse than no index.

## Deliberately not scaffolded

Project-specific machinery, not pipeline structure:

- `4-design/ground_truth/` — one project's design system (color tokens, core
  principles, per-component and per-page ground truth). Its `pages/CLAUDE.md`
  rule ("folders reflect URLs, generated from use-cases, one per size") is a
  good pattern to copy **if** the project has a page surface.
- `7-eval/auto/` — a Playwright Storybook screenshot/error harness wired to one
  specific Vue design system. Build the eval harness that fits the actual
  deliverable.

## After scaffolding

This skill only *writes* the convention files. Before generating artifacts
**into** a stage, re-read that stage's `CLAUDE.md` from disk — they are edited
live once a project is running, so the version scaffolded here is the starting
point, not the current truth.
