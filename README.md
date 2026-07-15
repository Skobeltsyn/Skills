# skills

Open, reusable **skills for AI agents** — self-contained instruction packs that teach an agent how to do a specific task well.

Each skill is a folder with a `SKILL.md` (YAML frontmatter + instructions) plus any supporting files it references. Drop a skill into an agent that supports the [Agent Skills](https://code.claude.com/docs/en/skills) format (Claude Code, the Claude Agent SDK, etc.) and it becomes available on demand.

## Skills

- [`lethal-trifecta-audit`](skills/lethal-trifecta-audit/) — audit a Claude Code agent for the
  lethal trifecta (private data + untrusted content + external communication), then confirm
  which exfiltration paths are live with localhost canary probes.
- [`sdlc-scaffold`](skills/sdlc-scaffold/) — scaffold the numbered agentic SDLC pipeline
  (`0-vibes` → … → `10-observation`) into a repo: stage folders, per-stage README charters,
  and per-stage `CLAUDE.md` convention files. Idempotent; safe to re-run to backfill stages.

## Layout

```
skills/
  <skill-name>/
    SKILL.md          # required: frontmatter (name, description) + instructions
    references/       # optional: docs the skill loads as needed
    scripts/          # optional: helper scripts the skill runs
    assets/           # optional: templates, examples, data

templates/
  example-skill/      # copy this as the starting point for a new skill
```

Only `skills/` ships when the repo is installed as a plugin; `templates/` is scaffolding for authors.

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

**Claude Code, as a plugin** (recommended — you get updates with `/plugin`):

```
/plugin marketplace add Skobeltsyn/Skills
/plugin install skills@skobeltsyn-skills
```

Installed skills are namespaced by the plugin, so `lethal-trifecta-audit` is invoked as
`/skills:lethal-trifecta-audit` (or Claude loads it on its own when a task matches).

**Claude Code, by hand** — copy a skill folder into `~/.claude/skills/` (personal) or
`.claude/skills/` (project).

**Claude Agent SDK** — load the skill directory when configuring your agent.

See [`templates/example-skill/`](templates/example-skill/) for a working template to copy.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) — use them however you like.
