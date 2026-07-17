One folder per builder, named `{last-name}-{first-name}-{middle-name}`, holding
that builder's `BUILDER.md`. Omit the middle name from the folder if there is
none — never a placeholder.

Start every profile from `templates/BUILDER_TEMPLATE.md`. Its headings are the
fields a distribution pass reads; a profile that drops one is a profile that
cannot be matched against a task.

Each builder's assignments live in that same folder, one file per assignment,
named `{task-id}-BLDR_{github-nick}.md` and started from
`templates/BUILDER_ASSIGNMENT.md`. One task to one builder — a task split across
builders gets one assignment each, every one naming its own scope.

## An assignment is frozen; the profile is not

The two kinds of file in a builder's folder obey opposite rules, and mixing them
up loses the audit trail:

- `BUILDER.md` is a living record, edited in place — see below.
- An assignment is a normal frozen artifact: written once, never edited. It
  records a decision made on a date against the profile as it read *that day*.

So reassignment is entombment, not an edit. Move the old assignment to
`obsolete/` with a header saying when, why, and superseded by which assignment;
the new one cites `supersedes:`. An edited assignment would erase the history of
who held the task — exactly what you want when a result goes wrong.

## Live is derived, never written

An assignment is **live** when it exists and `../../5-results/` holds no result
citing its task. Never write a status field into the assignment. Status derived
from the tree cannot go stale; status written into a frozen file cannot be
corrected.

The no-live-assignment gate is checked against this, so it has to come from one
place.

## Record the observation, not the verdict

The gate checks belong in the assignment as **observed values** — the
availability figure, the two domains, the date the profile was last confirmed. A
file saying only "checks passed" proves an agent ran, not that a human can audit
it.

## A builder profile is mutable

People and agents change — capabilities grow.
A profile is a **living record, edited in place**, and is the one thing in this
stage the freeze does not touch.

Every builder carries the code-title `BLDR_{github_nick_name}`, stated in their
profile. Assignments cite that code, never the folder path — the folder is named
for a person, and people are renamed; the code is stable.

The code is an address, not a version. It points at whatever the profile says
today, which is exactly what a distribution pass wants: the current builder, not
the builder as they were when the assignment was written.

A builder who leaves is marked `Active: no` in place. Never entomb a profile —
`obsolete/` is for artifacts that were frozen, and this was never one. The
profile has to stay readable, because the assignments and results they produced
still name them.
