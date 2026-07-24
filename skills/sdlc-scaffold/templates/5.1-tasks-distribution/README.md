# 5.1 — Tasks distribution

Who builds what. This stage sits between `../4-tasks/` (what must be built) and
`../5-results/` (what was built), and answers the only question those two stages
leave open: which builder takes which task.

A task leaves this stage when it is assigned to a builder who can actually do
it — one whose capabilities, access, and capacity fit what the task needs. The
result of that work lands in `../5-results/`, citing the task it came from.

## What goes here
- `builders/` — one folder per builder, holding their profile
- the assignment of each implementation task to a builder
