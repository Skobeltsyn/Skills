#!/usr/bin/env bash
# Read-only collector for a Claude Code agent's reachable surface.
# Prints the settings, MCP servers, hooks, skills, agents, and CLAUDE.md files
# that determine which tools an agent can reach and whether egress is gated.
# It never writes, never executes an agent, and never sends anything anywhere.
set -euo pipefail

PROJECT_DIR="${1:-$PWD}"
USER_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

section() { printf '\n===== %s =====\n' "$1"; }
show() {
  # show <label> <path>
  if [ -e "$2" ]; then
    printf -- '--- %s (%s) ---\n' "$1" "$2"
    cat "$2"
    printf '\n'
  else
    printf -- '--- %s (%s): not present ---\n' "$1" "$2"
  fi
}

printf 'Lethal-trifecta config collection\n'
printf 'project: %s\n' "$PROJECT_DIR"
printf 'user config dir: %s\n' "$USER_DIR"

section "Settings (permissions, defaultMode, hooks live here)"
show "user settings"            "$USER_DIR/settings.json"
show "project settings"         "$PROJECT_DIR/.claude/settings.json"
show "project settings (local)" "$PROJECT_DIR/.claude/settings.local.json"

section "MCP server definitions (each server = potential legs 1/2/3)"
show "project .mcp.json" "$PROJECT_DIR/.mcp.json"
show "user .mcp.json"    "$USER_DIR/.mcp.json"
if command -v claude >/dev/null 2>&1; then
  printf -- '--- claude mcp list ---\n'
  claude mcp list 2>&1 || printf '(claude mcp list failed)\n'
fi

section "Permission allowlist quick-scan (ungated egress candidates)"
# Surface the entries that most often remove the human gate on leg 3.
grep -REhno \
  'curl|wget|nc |netcat|ssh |git push|WebFetch|dig |nslookup|bypassPermissions|dangerously-skip-permissions|Bash\(\*\)|"Bash"' \
  "$USER_DIR/settings.json" \
  "$PROJECT_DIR/.claude/settings.json" \
  "$PROJECT_DIR/.claude/settings.local.json" 2>/dev/null \
  || printf '(no obvious ungated-egress tokens found — still verify manually)\n'

section "Hooks (unattended egress + tampering surface)"
for d in "$USER_DIR" "$PROJECT_DIR/.claude"; do
  if [ -d "$d/hooks" ]; then
    printf -- '--- hooks in %s ---\n' "$d/hooks"
    ls -la "$d/hooks"
  fi
done

section "Installed skills (each may add tools or instructions)"
for d in "$USER_DIR/skills" "$PROJECT_DIR/.claude/skills"; do
  [ -d "$d" ] && { printf -- '--- %s ---\n' "$d"; ls -1 "$d"; }
done

section "Subagents (agent files can carry their own tool grants)"
for d in "$USER_DIR/agents" "$PROJECT_DIR/.claude/agents"; do
  [ -d "$d" ] && { printf -- '--- %s ---\n' "$d"; ls -1 "$d"; }
done

section "CLAUDE.md (standing instructions the agent always loads)"
show "project CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
show "user CLAUDE.md"    "$USER_DIR/CLAUDE.md"

section "Done"
printf 'Read the above before classifying. Do not audit from memory of defaults.\n'
