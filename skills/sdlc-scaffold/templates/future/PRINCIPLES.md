# Changing the pipeline

[`AGENTS.md`](../AGENTS.md) is the law. [`RUNBOOK.md`](../RUNBOOK.md) is how to
run one pass under it. This is the discipline for changing the law itself —
adding a stage, a rule, a field, a template.

It exists because the pipeline's failure mode is not disagreement. Every rule
here can be right, every file can read cleanly on its own, and the pipeline can
still be broken — because the rules were written one at a time and the seams
between them were nobody's job.

## The bug class: a rule that reads a fact nobody records

Almost every real defect in this pipeline has one shape. A rule in one file reads
a fact another file was supposed to record, and doesn't:

- A gate requires availability as a percentage; the profile records hours per
  week.
- A rule gives builders a code-title; another rule says builders have no id.
- A rule reads load from a tracker; the profile still has a load field, which is
  now a lie that looks authoritative.
- A stage derives a priority; the stage consuming it sorts by id and ignores it.

None of these is visible in the file where it was introduced. All of them are
fatal at the seam — and because an undecidable check **fails closed**, the pass
does not error. It stops, or it quietly assigns nothing, which reads exactly like
having no work to do.

Everything below is a way of not writing that bug again.

## Every rule names its source

When you add a rule that reads a fact, name the file that records it — in the
same edit that adds the rule. If no file records it, you are adding two things,
not one: the rule, and the field it reads.

A rule whose fact nobody writes is undecidable. It is not a strict rule or a lax
one; it is a rule that never runs, in a pipeline built to fail closed.

This is the single check that catches most of the bug class above. It costs one
question per edit: *what file answers this, and does it exist?*

## Decisions freeze; facts about the world do not

Most artifacts here are frozen on write. The exceptions are not arbitrary, and
the test is not taste:

- An artifact recording **a decision someone made** is frozen — a task, an
  assignment, a result, a requirement. It was true when decided, and it stays
  true as a record of that decision, forever.
- An artifact recording **how the world currently is** is mutable — a person's
  profile, a team's shape. The world moved; the file follows it. Freezing it
  would mean the file is wrong and the tree says so.

The two may live side by side — an assignment is frozen and sits in the same
folder as the mutable profile it cites. When they do, **say which is which in
that folder's `AGENTS.md`**. A reader who mixes them up either edits history or
entombs a living record, and both are silent.

Anything modelling an external system is the second kind, and usually should not
be an artifact at all — see below.

## Derived, never written

If a fact can be computed from the tree, never write it into the tree.

The law states this for staleness: a citation to an entombed id is stale, and
`obsolete/` **is** the marker. The same reasoning has since been needed for
whether an assignment is live, whether a task is built, and how loaded a builder
is. It will be needed again. It is not a rule about obsolescence — it is the
general shape:

**A status you can derive cannot go stale. A status you write into a frozen file
cannot be corrected.**

The tell is a field named `status`, `state`, `done`, `assigned_to`, or
`current_*`. Before adding one, resolve it by glob instead and see whether the
field was ever needed.

## Name every reach outside the repo, and what happens when it is down

The pipeline is closed; the world is not. A pass that reads a tracker, an API, or
a deploy target has left the tree, and outside data does not obey the freeze.

For each such reach, state three things where the rule lives:

1. **What it answers** — and that it is read live, never cached into an artifact.
   A number copied from a tracker into a file is stale the moment it lands, and
   worse, it now looks like a fact somebody checked.
2. **What happens when it is unreachable** — the default is **stop**. Never fall
   back to an estimate, a cached value, or a nearby proxy.
3. **What is recorded** — the observed value and the source queried, so a reader
   can tell a checked figure from a guessed one later.

Point 2 is the one that gets argued with under time pressure. A pass that guesses
produces output identical to a pass that checked. That is the whole problem: the
guess is not marked, so it is not reviewable, so it is not caught.

## Anything that issues artifacts registers itself

A stage is not finished when its folder exists. Adding one means, in the same
change:

- its id (`XXX-{n}`) added to the **id list** in the root `AGENTS.md` — every id
  resolves by glob, and an unregistered id is one nobody can cite or resolve
- the stage added to the **chain** in `README.md`, so a reader can see where it
  sits
- a **step** in `RUNBOOK.md`, or the stage is never reached by a pass

A stage that skips these exists and does nothing. Downstream work will cite ids
that were never allocated, and the citation resolves to nothing — silently,
because a glob that matches no file is not an error.

The same applies smaller: a template field with no rule reading it is decoration,
and a rule reading no field is undecidable. **They ship together, or neither
ships.**

## A rule you cannot check mechanically will drift

The law says rules live in exactly one file. It is broken by people who have read
it — not through disagreement, but while doing something else and copying a
sentence for convenience.

Prefer rules with a cheap mechanical check, and prefer adding the check to
adding the prose:

- the same sentence appearing in two `AGENTS.md` files
- a `{{field}}` in a template that no `AGENTS.md` mentions
- an id cited nowhere, or cited by a glob matching two files
- a `CLAUDE.md` containing anything but `@` imports

Prose scales badly: every rule added makes every existing rule slightly less
likely to be read. A check does not decay.

---

## Open

Known seams in the shipped scaffold. Each is a live instance of a principle
above — left visible rather than quietly patched, because they are decisions a
human owes the pipeline, not defects an agent should guess at.

- **Priority versus order.** `4-tasks/` derives a task priority from the code and
  the existing docs. `5.1-tasks-distribution/principles/BUILDER_CHOOSING.md`
  sorts tasks by id ascending, oldest first, deliberately — so that no pass can
  cherry-pick. As it stands, priority is recorded and ignored. Either the sort
  reads priority first and id second, or priority is not a scheduling signal and
  should say so. *(Every rule names its source.)*

- **5.1 is not in the chain.** `README.md` still reads `4-tasks/ → 5-results/`.
  The stage exists, has law and templates and a procedure, and nothing routes to
  it. *(Anything that issues artifacts registers itself.)*
