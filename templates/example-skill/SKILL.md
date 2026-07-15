---
name: example-skill
description: Template skill showing the SKILL.md format. Not a real capability —
  copy this folder as the starting point for a new skill, then replace the body.
---

# Example skill

This is a template. Copy this folder into `skills/`, rename it, and rewrite
everything below the frontmatter for your actual task. It lives outside
`skills/` on purpose — only real skills ship to users.

## When to use

Describe the trigger precisely — the situations where an agent should reach for
this skill. This mirrors the `description` but with room for detail and edge
cases ("use this for X, but NOT for Y — use `other-skill` instead").

## Steps

1. State the first concrete action.
2. Then the next. Keep steps imperative and verifiable.
3. Point to supporting files only when needed, e.g. see
   [`references/details.md`](references/details.md) for the full option list, or
   run [`scripts/run.sh`](scripts/run.sh) to do the mechanical part.

## Notes

- Keep the main instructions short; push depth into `references/`.
- Prefer a script over prose whenever a step is deterministic.
