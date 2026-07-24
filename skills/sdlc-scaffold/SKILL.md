---
name: sdlc-scaffold
description: Scaffold the numbered agentic SDLC pipeline (0-vibes → 1-business-tasks → 2-specs → 3-design → 4-tasks → 5-results → 6-eval → 7-security-check → 8-deploy → 9-observation) into a repo — stage folders, per-stage README charters, and per-stage AGENTS.md convention files (each with a CLAUDE.md stub that imports it). Use when starting a new project on this workflow, backfilling missing stages in an existing one, or when asked to "set up the pipeline / the stage folders / an SDLC scaffold".
---

# SDLC pipeline scaffold

Builds the numbered stage skeleton that this workflow runs on. The scaffold is
**structure and conventions only** — no domain content. Domain artifacts (PRDs,
specs, components) are authored later, in-stage, by following each stage's
`AGENTS.md`. Each folder has to contain also `CLAUDE.md` with import of `AGENTS.md`.

**The structure is meant to transfer; the defaults are not.** The stage sequence
and the README/AGENTS/CLAUDE pattern are the transferable part — they hold for
any project on this workflow. Everything concrete the scaffold ships is an
opinionated seed from the origin project: the Roboto / min-14px design
constraints, the `xs md lg xl xxl` size set, the framework folders, the ID
schemes. They exist so a new pipeline starts from something real rather than
blank, and the adaptation pass is where they get overwritten. Never mistake a
default for a law.

## Run it

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/scaffold.sh" <target-dir> --project "Name"
```

`${CLAUDE_SKILL_DIR}` resolves to this skill's own directory, so the command is
identical whether the skill is installed as a plugin, sits in `~/.claude/skills/`,
or is vendored into a project's `.claude/skills/`. Do not rewrite it as a
literal path.

- The pipeline lands in a **container folder** inside `<target-dir>` — default
  `sdlc/` — so it does not spill the ten numbered stages across a real repo's
  root and collide with the project's own files. `<target-dir>` is the repo;
  `<target-dir>/sdlc/` is the pipeline.
- `--into <name>` renames the container (e.g. `--into pipeline`). `--into .`
  writes the stages at the target root — the old flat behaviour, for a directory
  that *is* the pipeline and nothing else.
- With a container, a short marked pointer is added to the **host repo's own
  `CLAUDE.md`** (created if absent, appended if present, skipped if already
  there) so an agent working at the repo root discovers the pipeline and knows to
  read `<container>/RUNBOOK.md`. Without it the container hides the pipeline from
  the host — walk-up loading never descends into a subdirectory. `--no-host-pointer`
  leaves the host `CLAUDE.md` untouched. Flat mode (`--into .`) skips it: the
  pipeline *is* the root there.
- The runbook itself is **referenced, never `@import`ed**. Claude Code loads
  every ancestor `CLAUDE.md` in full via walk-up, so importing a multi-step
  procedure at the pipeline root would load it into every stage-scoped agent. The
  root `AGENTS.md` names `RUNBOOK.md` in three lines; the procedure loads only
  when an agent opens it to run a pass.
- Idempotent: existing files are **skipped**, never clobbered. Safe to re-run to
  backfill stages added later.
- Run `--dry-run` first when the target already has content, so the skip list is
  visible before anything lands.
- `--force` overwrites — and **always copies the container first**, to
  `<container>.bak-<n>`, before the first file is overwritten. Stage rules get
  hand-adapted after scaffolding and that work is unrecoverable, so a clobber
  must always be undoable. The copy is lazy: a `--force` run that overwrites
  nothing leaves no backup behind, and an existing `.bak-1` is never reused.
- `--project` fills `{{PROJECT_NAME}}` in the root `AGENTS.md`.
- `--dry-run` lists what would be written, including the backup it would take.

Then do the **adaptation pass** below — an unadapted scaffold is a template, not
a pipeline.

## The pattern being reproduced

### 1. Number encodes flow direction

```
0-vibes/ → 1-business-tasks/ → 2-specs/ → 3-design/ → 4-tasks/
                                                          │
   ┌──────────────────────────────────────────────────────┘
   ▼
5-results/ → 6-eval/ → 7-security-check/ → 8-deploy/ → 9-observation/
                                                            │
                        └─ loops back to 1-business-tasks/observation/
```

It is a **loop**, not a line. Stage 9 feeds stage 1. Stages are never skipped:
a spec references a task, a design references a spec.

Numbers are contiguous, 0–9. They are load-bearing identifiers — baked into
cross-links (`../2-specs/…`), README index tables, and every artifact's upstream
trace — so a stage added or removed means rewriting all of them in lockstep, and
a broken link anywhere is a severed audit trail.

### 2. Two files govern every stage — this is the core rule

| File | Audience | Contains |
|------|----------|----------|
| `README.md` | humans | The stage charter: what it's for, its structure, what goes here, and the **exit criterion** — one line in the form *"An item leaves this stage when …"* |
| `AGENTS.md` | agents | The hard rules: ID naming schemes, required variant/size sets, generation instructions. Terse and imperative. |

Keep them separate. A `README.md` that explains a naming scheme gets ignored by
agents; an `AGENTS.md` that waxes about purpose wastes context.

**Every *structure* folder has both — all 30, no exceptions to remember.** The
tree holds two kinds of folder and only one carries convention files:

- **structure folders** — the numbered stages and their subfolders. `README.md`,
  `AGENTS.md`, and a `CLAUDE.md` stub, every one.
- **content folders** — `obsolete/`, `raw/<date>/`, and the folder an oversized
  file splits into. They hold data, not rules, and carry nothing. A new dated
  raw folder appears every time someone drops data; demanding three convention
  files in each is a rule nobody would follow past week two.

A folder with no
naming scheme still has rules worth stating: `5-results/` owes a link back to the
task that produced it, `8-deploy/` owes a rollback plan, `9-observation/errors/`
owes its severity on the far side of the loop. But never write a hollow
`AGENTS.md` to satisfy the pattern — if a folder truly has nothing to say, that's
evidence the folder shouldn't exist, not that it needs a placeholder.

Agent rules go in `AGENTS.md`, not `CLAUDE.md`. `AGENTS.md` is the tool-neutral
convention: any coding agent that reads it gets the stage's rules, not just
Claude Code. A pipeline whose rules only one vendor's agent can find is a
pipeline with a single point of failure.

### 2a. Every folder carries a `CLAUDE.md` — a one-line import, never a second copy

Claude Code does not read `AGENTS.md` by default, so **every folder** ships a
`CLAUDE.md` that imports the `AGENTS.md` governing it and holds nothing else:

```markdown
<!-- Conventions live in AGENTS.md (tool-neutral). Edit them there, not here. -->

@AGENTS.md
```

Every folder, without exception. An agent that opens
`2-specs/actors/ACTOR-1-FARMER.md` lands in `2-specs/actors/` — with no
`CLAUDE.md` there, the naming scheme never enters context and the file gets
written against a guessed convention. A stub in every folder is what makes the
rules unmissable regardless of where work starts.

**A nested folder imports its own rules *and* inherits its ancestors'**, each
from that rule's one home:

```markdown
@AGENTS.md
@../AGENTS.md
```

| Folder | Imports | Gets |
|--------|---------|------|
| `2-specs/` | `@AGENTS.md` | the cross-cutting spec rules |
| `2-specs/actors/` | `@AGENTS.md` + `@../AGENTS.md` | the `ACTOR-{n}` scheme **and** the spec rules |
| `1-business-tasks/observation/errors/` | `@AGENTS.md` + `@../AGENTS.md` + `@../../AGENTS.md` | `TYPE is ERROR`, the `BT-{n}-{TYPE}-{TITLE}` scheme, the origination rules |

**The chain runs all the way to the root**, which is where the pipeline law
lives — the cross-cutting rules no single stage can enforce: artifacts are
frozen, ids are permanent, citations are by id, obsolescence is a move to
`obsolete/` plus a tombstone.

An earlier version of this scaffold stopped the chain one level below the root,
reasoning that the root `CLAUDE.md` already loads for every session so importing
it again would duplicate it in context. That was wrong twice over. It made the
law reachable only through a **Claude-Code-specific** session-loading behaviour —
in a scaffold whose entire reason for using `AGENTS.md` is that rules only one
vendor's agent can find are a single point of failure. And it left the law
unreachable for a spawned agent that never loads the root at all.

The tell was already on disk: the traceability rule had been restated in four
stage files, and the Storybook rule in eight. Nobody chose that redundancy —
each author sensed the agent wouldn't see the root and restated the rule
defensively. **Duplication is what a missing import looks like from the inside.**
Both collapsed back to one home the moment the chain reached the root.

Keep the root law short — it lands in every folder's context. Its charter and
stage descriptions belong in the root `README.md`, not here.

This is what lets each rule live in exactly one file. The `ACTOR-{n}-NAME` scheme
is stated only in `2-specs/actors/AGENTS.md`; `2-specs/AGENTS.md` holds only what
spans all five subfolders. Neither restates the other, and an agent in `actors/`
still sees both. **Never solve inheritance by copying a parent's rule into a
child** — that's two homes for one rule, and they will drift.

The `../` depth is load-bearing: move a folder and its chain must be recomputed.
The invariant to hold is that every `@` path resolves to a file that exists — an
import of a deleted `AGENTS.md` is a broken import, not a no-op.

**One rule, one home.** The moment a rule is written into a `CLAUDE.md`, the two
files drift and agents start disagreeing about the naming scheme. If you catch
yourself editing a `CLAUDE.md`, you are editing the wrong file. The stub is
append-only in one direction: content moves *out* to `AGENTS.md`, never in.

**The one sanctioned exception, and what it costs.** A rule important enough
that no agent may miss it — in this scaffold, the Storybook rule — may be
restated in several `AGENTS.md` files rather than left to the import chain. Buy
that insurance deliberately and rarely, and know the premium: the Storybook rule
was duplicated across the root, `3-design/README.md`, and both framework files,
and it *had already drifted* before anyone noticed — the root asked for a story
per component, the leaves asked for a story covering every internal state. Two
different bars for one rule, and which one an agent obeyed depended on where it
entered the tree. If you duplicate a rule, enumerate its homes in the copy that
governs (see the root `AGENTS.md`) and change them together. Everything else —
naming schemes above all — gets exactly one home and reaches its children
through `@../AGENTS.md`.

Same rule at the repo root: the pipeline charter is the root `AGENTS.md`; the
root `CLAUDE.md` is the same stub, importing `@AGENTS.md` and nothing else.

### 3. Every artifact type gets an ID scheme

Scaffolded schemes, verbatim from the origin pipeline:

| Stage | Artifact | Scheme |
|-------|----------|--------|
| `1-business-tasks/` | business task | `BT-{n}-{TYPE}-{TITLE}.md` |
| `2-specs/modules/` | module | `MOD-{n}-{NAME}` (NAME becomes the `-IN-{MODULE}` suffix) |
| `2-specs/actors/` | actor | `ACTOR-{n}-{NAME}-IN-{MODULE}` |
| `2-specs/entities/` | entity | `ENT-{n}-{NAME}-IN-{MODULE}` |
| `2-specs/events/` | event | `EVT-{n}-{NAME}-IN-{MODULE}` |
| `2-specs/use-cases/` | use-case | `UC-{n}-ACTOR-{n}-EVT-{n}-ENT-{n}-{RESULT}-IN-{MODULE}` |
| `6-eval/manual/` | test case | `TC-{n}` |
| `3-design/` | component | `FIG-{n}-{TYPE}-{VARIANT1-name}-{value}-…` |

Two properties worth preserving when inventing new schemes:

- **Composite IDs encode relationships in the filename.** `UC-1-ACTOR-1-EVT-2-ENT-3-SESSION-ESTABLISHED`
  states its actor, trigger, entity, and outcome before the file is opened —
  the directory listing *is* the traceability matrix.
- **One artifact per file.** Not one file listing many events. This is why
  `2-specs/events/` holds 26 separate `EVT-*.md` files.

### 4. Traceability runs upstream, always

Every artifact cites the id(s) it was derived from — **by id, never by path**. A
path is a location and locations change; an id is the artifact itself. That is
what lets an artifact be entombed in `obsolete/` without breaking a single
citation pointing at it, and filenames start with their id so any id resolves by
glob (`**/ACTOR-1-*.md`). Every subfolder
`README.md` carries an **index table** of its artifacts with those links — see
the `Source` / `PT` columns in the scaffolded spec READMEs. When the origin repo
lists `| BT-1 | Authentication | R1, R13, R16 |`, that row is the audit trail
from a PRD requirement to a module.

### 5. Severity triage appears at both ends of the loop

`1-business-tasks/observation/` and `9-observation/` both split into
`errors/` · `warnings/` · `infos/`. Same three folders, same meaning, because
stage 9's output becomes stage 1's input — a signal keeps its severity as it
crosses the loop boundary.

## Adaptation pass (do this after running the script)

Every edit below lands in an `AGENTS.md`. The `CLAUDE.md` stubs are finished the
moment they're written — if one shows up in your diff, you edited the wrong file.

1. **Root `AGENTS.md`** — confirm the project name and that the stage list
   matches what you actually scaffolded.
2. **Prune what doesn't apply.** No design surface? Drop `3-design/` and say so
   in the root `AGENTS.md`. Better to remove a stage than leave it hollow. Delete
   a stage **whole** — folder and all — never just its `AGENTS.md`: the stubs
   below it import upward, so removing `3-design/AGENTS.md` while keeping
   `3-design/react/` leaves that folder importing a file that no longer exists.
3. **Pick the design targets.** The scaffold ships `figma/`, `react/`, and
   `vue/`. Delete the frameworks the project won't use — each carries a "every
   component ships a Storybook story" rule that must stay true.
4. **Paste the Figma file URL** into `3-design/figma/AGENTS.md` (it scaffolds as
   a `TODO`).
5. **Set the design constraints** in `3-design/AGENTS.md` — it scaffolds with
   the origin's Roboto / min-14px / `xs md lg xl xxl` size set. These are that
   project's choices, not laws.
6. **Leave index tables empty until artifacts exist.** An index promising specs
   that were never written is worse than no index.

## Deliberately not scaffolded

Project-specific machinery, not pipeline structure:

- `3-design/ground_truth/` — one project's design system (color tokens, core
  principles, per-component and per-page ground truth). Its `pages/CLAUDE.md`
  rule ("folders reflect URLs, generated from use-cases, one per size") is a
  good pattern to copy **if** the project has a page surface.
- The eval **harness** — `6-eval/auto/` scaffolds the shape (dated runs split
  into `unit/`, `integration/`, `llm/`) but not the runner. The origin's was a
  Playwright Storybook screenshot/error harness wired to one specific Vue design
  system; build the one that fits the actual deliverable.
- **Eval run output** — `record.json`, `summary.json`, screenshots, and a
  driver's `node_modules/`. This is regenerated evidence, not scaffold. Gitignore
  the harness's dependencies (one run pulled in 29 MB of `node_modules`); commit
  only what proves a verdict.

## What running eval taught the design

Two rules in `6-eval/AGENTS.md` exist because a real run surfaced the gap, not
because they were foreseen:

- **A defective case is not a `FAIL`.** A manual case asserted a submit button
  was disabled until a title was entered; the form enables it from render and
  enforces the title on submit. The system was healthy; the *expectation* was
  written from assumption. `PASS`/`FAIL`/`BLOCKED` has no verdict for "the case
  was wrong", so the run was forced to record `FAIL` against a working system —
  which reads on the dashboard as an unsatisfied use-case. The fix is structural,
  not a new verdict: supersede the case (a new `TC-{n}` that `reproduces` it with
  the expectation corrected), entomb the defective one, and roll up **live cases
  only**. Ground every expected result in observed behaviour, never assumption.
- **`BLOCKED` earns its place.** An integration run against a signed-out headless
  browser correctly recorded `BLOCKED`, not `FAIL`, on every step, and said how
  to unblock it. A run that had scored `FAIL` there would have invented a defect
  in a system it never reached.

## Related

- Load `stage-conventions` before generating artifacts **into** a scaffolded
  stage. This skill writes the convention files; that one makes sure they get
  read (they're edited live and go stale fast).


## Obsidian-friendly

- Always create links please so data can be easily viewed in obsidian.
