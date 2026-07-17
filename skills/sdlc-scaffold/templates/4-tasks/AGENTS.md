TASK naming: `TSK-{number}-{title}.md`, started from
`templates/TASK_TEMPLATE.md`. One task per file.

`TSK-{n}` is the implementation task id. It is not `TC-{n}` — that is a test case
in `6-eval/`. Every id resolves by glob, so a task named `TC-…` would make
`**/TC-12-*.md` return two files and the resolver ambiguous.

Cite the spec ids (`UC-{n}`, `ENT-{n}`, …) and design ids (`FIG-{n}`) the task
implements.

Each task states:
- its scope and acceptance criteria (definition of done)
- implementation notes and dependencies

A task enters only once its spec and design exist upstream. It leaves when what
it describes is built in `5-results/`.

After create please add task to specified tasks tracker.

Try to set priority based on code and existing docs and existing tasks. If you can not - ask human.

<!--TODO: create skill to prioritize tasks-->
