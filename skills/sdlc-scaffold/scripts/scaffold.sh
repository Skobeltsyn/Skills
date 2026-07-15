#!/usr/bin/env bash
#
# Scaffold the numbered agentic SDLC pipeline into a target repo.
#
#   bash scripts/scaffold.sh <target-dir> [--project "Name"] [--force] [--dry-run]
#
# Idempotent: existing files are skipped unless --force. See SKILL.md for the
# adaptation pass that must follow.

set -euo pipefail

# Resolve everything from the script's own location, never the caller's cwd, so
# the skill works installed as a plugin, in ~/.claude/skills, or in a project.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATES="$SKILL_DIR/templates"

TARGET=""
PROJECT_NAME="Project"
FORCE=0
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --project)
      [ $# -ge 2 ] || { echo "error: --project needs a value" >&2; exit 2; }
      PROJECT_NAME="$2"; shift 2 ;;
    --force)   FORCE=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help)
      # Print the leading comment block, whatever length it grows to.
      awk 'NR==1 {next} /^#/ {sub(/^# ?/, ""); print; next} {exit}' "${BASH_SOURCE[0]}"
      exit 0 ;;
    -*)
      echo "error: unknown option $1" >&2; exit 2 ;;
    *)
      [ -z "$TARGET" ] || { echo "error: target given twice ($TARGET, $1)" >&2; exit 2; }
      TARGET="$1"; shift ;;
  esac
done

[ -n "$TARGET" ] || TARGET="."
[ -d "$TEMPLATES" ] || { echo "error: templates not found at $TEMPLATES" >&2; exit 1; }

if [ ! -d "$TARGET" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "would create target dir $TARGET"
  else
    mkdir -p "$TARGET"
  fi
fi
TARGET="$(cd "$TARGET" 2>/dev/null && pwd || echo "$TARGET")"

created=0
skipped=0

# Sorted for deterministic, readable output.
while IFS= read -r src; do
  rel="${src#"$TEMPLATES"/}"
  dest="$TARGET/$rel"

  if [ -e "$dest" ] && [ "$FORCE" -eq 0 ]; then
    echo "  skip    $rel (exists)"
    skipped=$((skipped + 1))
    continue
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  would write $rel"
    created=$((created + 1))
    continue
  fi

  mkdir -p "$(dirname "$dest")"
  # Only {{PROJECT_NAME}} is substituted; templates are otherwise verbatim.
  PROJECT_NAME="$PROJECT_NAME" perl -pe 's/\{\{PROJECT_NAME\}\}/$ENV{PROJECT_NAME}/g' "$src" > "$dest"
  echo "  create  $rel"
  created=$((created + 1))
done < <(find "$TEMPLATES" -type f ! -name '.DS_Store' | sort)

echo
if [ "$DRY_RUN" -eq 1 ]; then
  echo "dry run: $created file(s) would be written, $skipped skipped."
  exit 0
fi

echo "Scaffolded into $TARGET — $created created, $skipped skipped."
echo
echo "Next: the adaptation pass in $SKILL_DIR/SKILL.md"
echo "  1. set the project name + stage list in CLAUDE.md"
echo "  2. drop stages/design targets the project won't use"
echo "  3. paste the Figma URL into 4-design/figma/CLAUDE.md"
echo "  4. set the design constraints in 4-design/CLAUDE.md"
