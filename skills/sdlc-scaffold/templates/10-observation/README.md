# 10 — Observation

Watching the deployed system (`../9-deploy/`) in production. This **closes the
loop**: signals gathered here feed back into `../1-business-tasks/observation/`,
where they become the next round of planning and work.

Like stage 1's observation, signals are triaged by severity.

## Structure
- `errors/` — production failures and incidents that demand action.
- `warnings/` — risks and degradations worth attention before they become errors.
- `infos/` — neutral signals, metrics, and usage notes.

```
9-deploy/ → 10-observation/ → 1-business-tasks/observation/ → …
                            (loop back into planning)
```
