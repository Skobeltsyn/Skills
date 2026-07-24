# {{TASK_ID}} → BLDR_{{GITHUB_NICK}}

<!--
Copy this file to the builder's own folder, as
`builders/{{last-first-middle}}/{{TASK_ID}}-BLDR_{{GITHUB_NICK}}.md`, and fill
it in. Delete every comment before committing.

Unlike the BUILDER.md sitting beside it, an assignment is FROZEN once written —
see this folder's AGENTS.md. Reassigning means entombing this file and issuing a
new one, never editing this one.
-->

- **Task:** {{TASK_ID}} — resolve under `4-tasks/` with `**/{{TASK_ID}}-*.md`
- **Builder:** BLDR_{{GITHUB_NICK}} — profile in [`BUILDER.md`](BUILDER.md),
  beside this file
- **Assigned:** {{YYYY-MM-DD}}
- **Supersedes:** {{prior assignment, or omit if this is the first}}

<!--
The task is cited by id and resolved by glob, never by path — a path is a
location and locations change, which is the whole reason ids exist. The builder
link is a real relative link only because the profile lives in this same folder:
if the assignment moves, the profile moves with it.
-->


## Why this builder

The match, stated against the profile — not asserted. Each line is a claim a
reviewer can check against the `BUILDER.md` in this same folder.

- **Domain:** {{the builder's domain, and the task's — these must be the same}}
- **Capability:** {{the profile line covering what this task needs}}
- **Access:** {{the repos and environments the task touches, and where the
  profile grants them}}

## Gate

The four checks that had to pass before this file could exist. State the
observed value, not "ok" — a bare tick records that someone looked, not what
they saw.

- **Open tasks in tracker:** {{what the tracker returned at assign time — must
  be none}}
- **Weighted load:** {{value}} — {{the repos and domains it spanned, and the
  factors applied}}. Show the arithmetic, not the total: a spread-weighted
  figure a reviewer cannot recompute is a figure they have to take on faith.
- **Availability:** {{observed}}% — must exceed 80%, derived from that load,
  read live from the tracker and never from `BUILDER.md`
- **Tracker queried:** {{which tracker, and when}} — the figures above are a
  snapshot; naming the source is what makes them checkable later
- **Domain match:** {{task domain}} = {{builder domain}}

## Why this one, over the others who qualified

Everyone who passed the gate was assignable. This is the arithmetic that put the
task here rather than with them — the ranking, recomputable from the tracker.

- **Experience:** {{their median on this task type}} vs {{the all-builder median
  for the type}} → {{score}}. Write `0 — no comparable history` when the tracker
  holds none; unmeasured is neutral, never a penalty.
- **Delegation:** {{yes | no, from BUILDER.md}} → {{score}}
- **Total:** {{score}} — {{the other survivors and their totals, or "sole
  survivor"}}
- **Tie-break:** {{"not needed", or the alphabetically-first BLDR_ code}}

## Scope handed over

What this builder is taking on, if it is narrower than the task itself. A task
split across builders needs one assignment per builder, each naming its part.

{{scope, or "the whole of {{TASK_ID}}"}}

## Notes

Anything the builder needs that the task and the profile do not already carry —
sequencing against other work, a review requirement, an escalation path.

- {{note}}
