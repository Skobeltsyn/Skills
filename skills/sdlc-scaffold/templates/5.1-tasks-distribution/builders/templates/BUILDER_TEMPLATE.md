# {{LAST_NAME}}, {{FIRST_NAME}} {{MIDDLE_NAME}}

<!--
Copy this file to `builders/{{last-first-middle}}/BUILDER.md` and fill it in.
Delete every comment and every section that does not apply. An empty heading
left behind reads as "we have nothing here", which is rarely what you mean.

This profile is mutable — see this folder's AGENTS.md. Edit it in place as the
builder changes. Do not freeze it, do not version it, do not entomb it.
-->

## Identity

- **Code:** BLDR_{{GITHUB_NICK}}
- **Kind:** human | agent
- **GitHub:** {{GITHUB_NICK}}
- **Contact:** {{EMAIL_OR_CHANNEL}}
- **Timezone:** {{TZ}}
- **Active:** yes | no

<!-- For an agent builder, also state: -->
- **Model / runtime:** {{MODEL_OR_RUNTIME}}
- **Invoked by:** {{COMMAND_OR_ENTRYPOINT}}

## Domain

The one area this builder owns. A task outside it is not assignable to them, so
this is the first thing a distribution pass reads — name it narrowly enough that
it excludes something.

{{domain}}

## Capabilities

What this builder can be handed within that domain. Name the modules (`MOD-{n}`)
and the technologies — a distribution pass matches a task against this list, so
vagueness here costs you a bad assignment later.

- {{MOD-n}} — {{what they can do in it}}
- {{technology / language / surface}}

## Limits

What this builder must not be handed, and why. A limit is as load-bearing as a
capability: it is the reason a task went elsewhere.

- {{area}} — {{reason: no access, no context, no authority}}

## Access

What the builder can actually reach. A task that needs an environment the
builder cannot touch is a task that will stall.

- **Repositories:** {{repos}}
- **Environments:** {{dev | staging | prod, and what they may do there}}
- **Systems:** {{issue tracker, design tool, secrets, CI}}

## Capacity

<!--
Do NOT record an availability figure here. Availability is read live from the
tracker at assign time, never from this file — see ../AGENTS.md. A percentage
typed here would be stale the moment anyone is assigned anything, and worse, it
would look authoritative.
-->

- **Tracker identity:** {{the id/handle this builder is known by in the tracker}}
  — how a distribution pass finds their open and closed tasks. Without it their
  load and history are both undecidable, and an undecidable check fails.
- **Can delegate to an AI agent:** yes | no — whether this builder can hand work
  to an agent rather than doing all of it themselves. Scored when ranking, so
  state it as a fact; a pass must never infer it from how they have worked.
- **Concurrent-task ceiling:** {{n}} — the most this builder may hold at once.
  A standing limit, not a live figure. Leave blank for the default of one.
- **Committed until:** {{date, if the builder is spoken for elsewhere}}

## Working notes

Anything a distribution pass needs that the fields above do not carry — review
requirements, pairing constraints, escalation path, standing preferences.

- {{note}}
