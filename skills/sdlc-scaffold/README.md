# sdlc-scaffold

A numbered, agentic software-development pipeline you scaffold into a repo, then
work through with coding agents. Ten stages carry an idea from a raw vibe to a
running system and back again — each stage a folder, each folder governed by
rules an agent reads before it writes anything.

This README is the orientation. [`SKILL.md`](SKILL.md) is the operational guide
the agent loads to scaffold and adapt the tree.

## The loop

```
0-vibes/ → 1-business-tasks/ → 2-specs/ → 3-design/ → 4-tasks/
 idea/prd    observe & plan      specs      design    implementation
                                                           │
   ┌───────────────────────────────────────────────────────┘
   ▼
5-results/ → 6-eval/ → 7-security-check/ → 8-deploy/ → 9-observation/
  built       quality      security         release      watch → (back to 1)
```

It is a **loop, not a line**. Stage 9 feeds stage 1: what you observe in
production becomes the next cycle's business tasks. Stages are never skipped — a
spec cites a business task, a design cites a spec, an eval cites a use-case — so
every artifact traces upstream to the need that produced it.

| Stage | Holds |
|-------|-------|
| `0-vibes/` | raw ideas, the `raw/` data that arrives, and the single `PRD.md` |
| `1-business-tasks/` | why: signals observed and plans shaped from them |
| `2-specs/` | how it should work: modules, actors, entities, events, use-cases |
| `3-design/` | how it looks: Figma source and framework components |
| `4-tasks/` | the implementation work |
| `5-results/` | what got built, traced to its task |
| `6-eval/` | whether it works: auto + manual test runs, a dashboard |
| `7-security-check/` | whether it is safe to ship |
| `8-deploy/` | releasing it, and how to roll back |
| `9-observation/` | watching it run — which reopens the loop |

## The idea

The pipeline is applied **over and over** — new real-world data lands, the PRD
absorbs it, and everything downstream adjusts. Making that safe to repeat is the
whole design, and it rests on a handful of rules (the full set is the root
[`AGENTS.md`](templates/AGENTS.md), which every folder imports):

- **Artifacts are frozen.** Once written, an artifact's content, id, and
  citations never change. Change means issuing a *new* artifact, not editing an
  old one — so re-running the pipeline over an unchanged tree does nothing. It is
  closed for modification, open for extension.
- **Ids are permanent, and citations use them, not paths.** Every artifact has an
  id (`R7`, `UC-12`, `MOD-3-AUTH`…) that is allocated once and never renumbered,
  and everything cites by that id. Because filenames begin with the id, any id
  resolves by glob — which lets a superseded artifact be moved aside without
  breaking a single citation pointing at it.
- **Obsolete artifacts are entombed, not deleted.** They move to `obsolete/` with
  a header saying when they died, why, and what superseded them. The audit trail
  stays whole; nothing is ever lost.
- **A human approves each pass.** An agent computes the delta — what to issue,
  what to entomb, and the change driving it — and nothing moves until that plan
  is approved. Change the top, and the bottom adjusts, under review.

The payoff: the ID prefix of a use-case like
`UC-1-ACTOR-1-EVT-2-ENT-3-SESSION-ESTABLISHED-IN-AUTH` states its actor, trigger,
entity, and outcome before you open the file. A directory listing *is* the
traceability matrix.

## Two files govern every folder

- **`README.md`** — for humans: what the stage is for and the one condition an
  item must meet to leave it.
- **`AGENTS.md`** — for agents: the hard rules — ID schemes, required sets,
  generation instructions. Tool-neutral, so any coding agent finds them, and each
  folder's `CLAUDE.md` is a one-line stub importing the `AGENTS.md` chain up to
  the root law (Claude Code does not read `AGENTS.md` on its own).

Every rule lives in exactly one file. Edit `AGENTS.md`, never the `CLAUDE.md`
stub beside it.

## Use it

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/scaffold.sh" <target-dir> --project "Name"
```

Idempotent — existing files are skipped, so it is safe to re-run to backfill
stages. Then do the **adaptation pass** in [`SKILL.md`](SKILL.md): an unadapted
scaffold is a template, not yet a pipeline. The scaffold ships structure and
conventions only; the domain content — PRDs, specs, components — is authored
later, in-stage, by following each stage's `AGENTS.md`.
