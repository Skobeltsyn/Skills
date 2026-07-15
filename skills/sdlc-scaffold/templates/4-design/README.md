# 4 — Design

Design components built from the specs in `../3-specs/`, organized by target.

An item leaves this stage when its implementation task is written in
`../5-tasks/`.

## Structure
- `figma/` — Figma source of truth (design origin). See `figma/CLAUDE.md`.
- `react/` — React component implementations.
- `vue/` — Vue component implementations.

Naming and size conventions in [`CLAUDE.md`](CLAUDE.md).

## Rule: every component ships with a Storybook story
Each component in `react/` and `vue/` must have its own Storybook
(`*.stories.*`) so it can be viewed, tested, and reviewed in isolation.
