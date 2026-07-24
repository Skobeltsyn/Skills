An assignment names one task from `../4-tasks/` and one builder from
`builders/`. Cite the task by its id and the builder by their folder name.

Assign against the builder's profile, not against a guess. A task whose
capabilities, access, or capacity the profile does not cover is not assignable —
either the profile is stale and a human updates it, or the task goes to someone
else.

A task with no fitting builder stays unassigned and is surfaced as such. Never
assign it anyway; an assignment nobody can execute reads as distributed work
while the task sits dead.

When assigning a task for the builder, use the builder choosing principle:
[`principles/BUILDER_CHOOSING.md`](principles/BUILDER_CHOOSING.md). This file is
the law that holds across every assignment; that one is the order to apply it in.
Open it when you start a distribution pass — it is not loaded for you, by design.

How to know availability:
Go to specified tracker MCP or endpoint, learn about open tasks on checked builder and make decision based on that.

Availability is never read from `BUILDER.md`. Load changes every time anyone is
assigned anything, so a number written into a profile is stale before it is read.
If the tracker cannot be reached, the pass stops — it does not fall back to an
estimate.

Load is weighted, not counted. Open tasks spread across several repos or domains
cost the builder more than the same number held in one, because every switch
rebuilds context. Set the two factors here, once, for the whole project:

- `repo_factor` = {{value}} — applied per additional distinct repo a builder
  holds open work in
- `domain_factor` = {{value}} — applied per additional distinct domain

These are project constants and never chosen per pass. A factor picked to suit
one assignment makes two builders' load figures incomparable, which is the one
thing the number exists to do.

Also tasks have to be relative to the domains of the workers. 

Each builder has to have following internal code-title: BLDR_{github_nick_name}

Each task assignment has to create an assignment artifact, which has some number with a template in the assign folder and modify the builders file.
