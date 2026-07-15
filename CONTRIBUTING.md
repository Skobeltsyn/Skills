# Contributing

Thanks for wanting to add a skill! The bar is simple: **one skill, one job, done well.**

## Adding a skill

1. Copy [`templates/example-skill/`](templates/example-skill/) to a folder under `skills/`
   named in `kebab-case` (e.g. `pdf-fill`, `git-triage`).
2. Rewrite `SKILL.md`, starting with the frontmatter:
   ```markdown
   ---
   name: pdf-fill
   description: Fill and flatten PDF forms from a data file. Use when the user
     needs to populate a fillable PDF or merge data into a template.
   ---
   ```
3. Write focused instructions below the frontmatter. Put anything long or
   optional (reference docs, examples, scripts) in subfolders and link to them
   so the agent loads them only when needed.
4. Add a one-line entry to the skill list in [README.md](README.md).

Everything under `skills/` ships to users when the repo is installed as a plugin, so put
scaffolding and examples in `templates/`, never in `skills/`.

## Guidelines

- **Description is everything.** It's the only text an agent sees when deciding
  to load the skill. Say what it does *and* when to use it. Avoid vague verbs.
- **Keep `SKILL.md` lean.** Move deep detail into `references/`. Agents read the
  main file every time the skill loads; keep the token cost low.
- **Make it self-contained.** A skill should not assume files outside its folder.
- **Prefer scripts for determinism.** If a step is mechanical, ship a script in
  `scripts/` rather than describing it in prose.
- **Test it.** Run the skill end-to-end in an agent before opening a PR, and run
  `claude plugin validate .` from the repo root — it checks the marketplace manifest and
  every skill's frontmatter.

## Naming

- Folder and `name:` must match, both `kebab-case`.
- Names should read as an action or capability, not a brand.
