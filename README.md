# skills

Open, reusable **skills for AI agents** — self-contained instruction packs that teach an agent how to do a specific task well.

Each skill is a folder with a `SKILL.md` (YAML frontmatter + instructions) plus any supporting files it references. Drop a skill into an agent that supports the [Agent Skills](https://code.claude.com/docs/en/skills) format (Claude Code, the Claude Agent SDK, etc.) and it becomes available on demand.

## Layout

```
skills/
  <skill-name>/
    SKILL.md          # required: frontmatter (name, description) + instructions
    references/       # optional: docs the skill loads as needed
    scripts/          # optional: helper scripts the skill runs
    assets/           # optional: templates, examples, data
```

## Anatomy of a skill

A `SKILL.md` starts with frontmatter and is followed by Markdown instructions:

```markdown
---
name: my-skill
description: One line the agent uses to decide when to load this skill. State what it does and when to use it.
---

# My skill

Step-by-step guidance for the agent. Keep it focused: one skill, one job.
```

The `description` is the most important line — it's all the agent sees when deciding whether a skill is relevant, so make it specific about *what* the skill does and *when* to reach for it.

## Using these skills

**Claude Code** — copy a skill folder into `~/.claude/skills/` (personal) or `.claude/skills/` (project), or point at this repo as a plugin.

**Claude Agent SDK** — load the skill directory when configuring your agent.

See [`skills/example-skill/`](skills/example-skill/) for a working template to copy.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) — use them however you like.
