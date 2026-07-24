# TSK-{{n}} — {{TITLE}}

<!--
Copy to `4-tasks/TSK-{{n}}-{{TITLE}}.md` and fill in. Delete every comment and
every section that does not apply.

`{{n}}` is one past the highest TSK ever issued, counting entombed ones. Never
reused, never renumbered.

This file is FROZEN the instant it is written. Work that would change its scope
issues a new TSK and entombs this one — see the pipeline law in ../AGENTS.md.
-->

## Implements

The ids this task was derived from, upstream only. Cite the id; never a path —
filenames begin with their id, so any id resolves by glob (`**/UC-12-*.md`),
and a glob survives the file being moved or entombed.

Resolve every id before citing it and confirm it is not in `obsolete/`. A new
artifact may not cite a dead one.

- **Use-cases:** {{UC-n}}, … — the behaviour this task makes real
- **Design:** {{FIG-n}}, … — the components it builds
- **Entities / events / actors:** {{ENT-n}}, {{EVT-n}}, {{ACTOR-n}}, …
- **Module:** {{MOD-n}} — where this lands

<!--
Cite only what this task genuinely derives from. A citation list padded with
every id in the neighbourhood makes the graph useless for the thing it exists
for: answering "what dies if UC-12 dies?"
-->

## Priority

- **Priority:** {{value}}
- **Derived from:** {{the code, docs, or existing tasks this was read off —
  never a feeling}}

<!--
Set this from the code, the existing docs, and the priorities of existing tasks.
If those do not settle it, ASK A HUMAN — do not pick a middle value to keep the
pass moving. An invented priority is indistinguishable from a derived one once
written, and it reorders real work.

Cite what you read it from. A priority nobody can trace back is one nobody can
challenge.
-->

## Domain

{{domain}}

<!--
Load-bearing, not decorative: 5.1 filters builders by domain equality, so a task
whose domain matches no builder's is unassignable — it stops, and no filter is
widened to place it. Name the same domain the builders use.
-->

## Scope

What this task covers. Concretely enough that "is it done?" has one answer.

{{scope}}

**Out of scope:** {{what a reader would reasonably assume is included but is
not, and where it lives instead — or "nothing worth calling out"}}

## Acceptance criteria

Definition of done. Each line observable by someone who did not write the task —
a criterion only its author can evaluate is not a criterion.

- [ ] {{criterion}}

## Touches

What the work reaches. 5.1 checks these against a builder's access, so a task
that understates them gets assigned to someone who cannot do it.

- **Repos:** {{repos}}
- **Environments:** {{dev | staging | prod}}
- **Systems:** {{external services, migrations, secrets}}

<!--
Also priced when weighing load: a builder holding open tasks across several repos
is more loaded than one holding the same number in a single repo. Every repo
listed here is a repo the next assignment counts against whoever takes this.
-->

## Depends on

Other tasks that must land first, by id. Upstream only — a task never lists what
depends on *it*, because recording that would mean editing this frozen file every
time a dependent appeared.

- {{TSK-n}} — {{why}}

## Implementation notes

What the specs and design do not already say, and the builder would otherwise
have to rediscover.

- {{note}}

## Tracker

- **Issue:** {{tracker issue id, or "none — 4-tasks/ is the tracker of record"}}
- **Created in tracker:** {{YYYY-MM-DD, or "n/a"}}

<!--
The one bidirectional link in the pipeline: the issue carries this TSK id, this
file carries the issue id, and neither can drift. It is also the only field here
that may be written after the freeze — the id does not exist until the issue is
created. See RUNBOOK.md step 6.
-->

---

<!--
NOT recorded here, on purpose:

- Who this task is assigned to — that lives in 5.1, in the builder's folder.
  Resolve it by globbing `5.1-tasks-distribution/builders/**/TSK-{{n}}-*.md`.
- Whether it is built — resolve by looking for a result in 5-results/ citing
  TSK-{{n}}. No result means still open.

Both are derivable from the tree, and traceability runs upstream: writing them
here would mean editing a frozen file every time something downstream moved, and
a status that can be edited is a status that can be wrong.
-->
