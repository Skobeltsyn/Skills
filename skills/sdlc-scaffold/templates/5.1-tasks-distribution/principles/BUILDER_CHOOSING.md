# Choosing a builder

The procedure for assigning tasks. [`AGENTS.md`](AGENTS.md) says what is always
true; this says in what order to do it.


Applied here: an agent never decides who is *best* for a task. It filters, it
sorts, and it takes the first row. Same tree in, same assignment out — which is
the same property the rest of the pipeline gets from freezing artifacts.

Two rules govern every step:

- **No judgment at the station.** Every step below is a filter or a sort with a
  stated rule. If a step ever requires an agent to weigh, prefer, or estimate,
  the step is wrong — replace it with a rule or hand it to a human.
- **Stop the line.** A task with no qualifying builder halts and is surfaced. It
  is never assigned to the closest match. A burger that came off wrong does not
  get sold because the line was busy.

---

## 0 — Mise en place: refuse to run on stale prep

Before assigning anything, read every `BUILDER.md` and check its **Last
confirmed** date. A profile nobody has confirmed recently is not evidence, and
every gate below is checked against it.

Stale profiles are surfaced for a human to refresh. Do not assign against them,
and do not refresh them yourself by guessing.

## 1 — Take tasks in order, first in first out

Collect every task in `4-tasks/` with no live assignment. Sort by task id,
ascending. Work them in that order, one at a time.

Ascending id means oldest first. This is the step that stops cherry-picking: no
pass gets to do the appealing task first and leave the awkward one to rot, and
the order does not depend on which agent ran the pass.

## 2 — Filter to the station

For the current task, keep only builders whose **Domain** equals the task's
domain. This is a filter, not a preference — a builder outside the domain is not
a worse candidate, they are not a candidate.

The grill does not make fries when the grill is idle. Cross-domain assignment is
how a station stops meaning anything.

## 3 — Apply the gate

From what survives step 2, drop every builder failing any check:

- **Active** is `no`
- **Availability** is 80% or less — the threshold is a number, not a mood
- Holds a **live assignment** — an assignment exists with no result in
  `5-results/` citing its task
- **Capability** does not cover what the task needs
- **Access** does not cover the repos and environments the task touches

Each is pass/fail against a line in the profile. If a check cannot be decided
from the profile, it fails — an undecidable check is a stale profile, which is
step 0's problem, not something to reason around.

## 4 — Break the tie by rule

If more than one builder survives step 3, they are all qualified, and the
pipeline does not rank qualified builders. Take the one whose `BLDR_` code sorts
first alphabetically.

This tie-break looks arbitrary because it is: that is the point. Any rule that
tried to pick the *best* survivor would import judgment, and two agents given the
same tree would hand the same task to different people. An arbitrary rule applied
consistently beats a smart rule applied inconsistently.

Uneven load is not this step's problem to fix — it is **Availability** moving in
the profile, which changes step 3's result on the next pass without anyone
tuning the algorithm.

## 5 — Zero survivors: stop the line

If nothing survives, the task is **unassignable**. Record it as such, with which
step emptied the list and what would have to change:

- Emptied at step 2 → no builder owns this domain
- Emptied at step 3 → name the check and the observed value

Never widen a filter to produce a match. An unassignable task is a real finding
about the team — a missing domain, or everyone at capacity — and forcing an
assignment converts that finding into a task that quietly never ships.

## 6 — Write the assignment

Copy `builders/templates/BUILDER_ASSIGNMENT.md` into the chosen builder's folder
and fill it in, recording the **observed values** the gate saw — not that it
passed. The next pass reads those values back.

Then return to step 1 for the next task. The builder just assigned now holds a
live assignment, so step 3 will exclude them — which is why tasks are worked one
at a time rather than matched in a batch.

---

## Propose, then apply

Steps 1–6 compute the whole distribution: every assignment, every unassignable
task and why. **Present that before writing anything.** One reviewable decision
per pass, not one per task — the same gate the runbook puts on a pipeline pass.

The output is fully determined by the tree, so a human reviews a plan they could
have derived themselves. That is the property worth protecting: if a reviewer is
ever surprised by an assignment, the algorithm has drifted, not their intuition.

---

**Above all else:** when assigning a task to a builder, the Agent has to be sure
that no current tasks are assigned to them and that their availability is more
than 80%. Every step above exists to make those two checks decidable from the
tree. If a pass ever produces an assignment that violates either, the pass is
wrong — not the rule.
