# Remediation

To break a closed path, cut **one** leg. You rarely want to cut leg 1 (the
agent needs its data to be useful) or leg 2 (untrusted input is the job for a
web or mail agent), so most fixes gate or remove **leg 3**. Recommend the
cheapest cut that holds for each path; list options in preference order.

## Gate the egress (usual first choice)

- Remove broad egress from `permissions.allow`: drop `Bash(curl:*)`,
  `Bash(wget:*)`, `WebFetch(*)`, and any `Bash(*)` wildcard. Egress then prompts
  a human, which reintroduces the missing gate.
- Never run an agent that holds legs 1 and 2 with
  `--dangerously-skip-permissions` or `defaultMode: bypassPermissions`.
- Prefer an explicit allowlist of *safe* commands over a denylist of dangerous
  ones — you cannot enumerate every exfil primitive (`curl`, `nc`, `ssh`, `dig`,
  `git push`, a Python one-liner…), so default-deny and add back what you need.
- Constrain `WebFetch` to a domain allowlist if the platform supports it; an
  agent that only needs internal docs should not reach arbitrary hosts.

## Cut leg 2 (isolate untrusted input)

- Process untrusted content in a **subagent that has no leg-1 and no leg-3
  tools**, and return only a structured, minimal result to the parent. This is
  the strongest structural fix: the summarizer literally cannot reach private
  data or the network.
- Do not connect a public issue tracker or shared mailbox to the same session
  that holds credentials or private source.
- Treat all tool output — page text, issue comments, error strings, subagent
  results — as data, never as instructions. Injection resistance in the prompt
  helps but is not a control you can rely on.

## Cut leg 1 (reduce reachable data)

- Run the agent in a scratch workspace without `.env`, `~/.aws`, `~/.ssh`, or
  credential files in reach. Inject only the specific secrets a task needs, via
  environment, at the moment of use.
- Scope MCP servers to least privilege: a read-only token, a single project, a
  narrow mailbox label — not the whole account.
- Keep the memory directory out of sessions that also carry legs 2 and 3.

## Harden the gate you keep

If a path must keep all three legs (e.g. an agent that reads mail and can reply):

- Make egress approvals **legible** — a human cannot meaningfully approve a
  `curl` to a plausible-looking domain with 400 characters of base64 in the
  query. Log outbound payloads and destinations for review.
- Alert on new outbound destinations rather than trusting per-call approval.
- Re-run this audit after any change that adds a tool, an MCP server, or an
  allowlist entry — one new entry can close a path that three others left open.

## What does not work

- **"Just tell the model to ignore injected instructions."** Prompt-level
  defenses reduce but do not eliminate the risk; they are not a control you can
  certify. Keep them, but never count them as the cut leg.
- **Denylisting egress commands.** The set of ways to send bytes off a machine
  is open-ended; a denylist always misses one.
