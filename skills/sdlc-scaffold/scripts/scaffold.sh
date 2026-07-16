#!/usr/bin/env bash
#
# Scaffold the numbered agentic SDLC pipeline into a target repo.
#
#   bash scripts/scaffold.sh <target-dir> [--into <name>] [--project "Name"] [--force] [--dry-run]
#
# The pipeline lands in a container folder inside <target-dir>, not spilled
# across its root — default `sdlc/`, so dropping this into a real codebase does
# not collide with the project's own files. Override the name with --into <name>,
# or pass --into . to write the stages at the target root (the old behaviour).
#
# Idempotent: existing files are skipped unless --force. See SKILL.md for the
# adaptation pass that must follow.
#
# --force overwrites, but never without a net: the container is copied to
# <container>.bak-<n> before the first overwrite. Adapted stage rules are
# hand-written and unrecoverable, so a clobber must always be undoable.

set -euo pipefail

# Resolve from the script's own location, never the caller's cwd, so the skill
# works installed as a plugin, in ~/.claude/skills, or vendored in a project.
# Layout-agnostic on purpose: templates/ sits next to this script when it lives at
# the skill root, one level up when it lives in scripts/. Two copies of this file
# once drifted apart over exactly that difference — don't reintroduce it.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/templates" ]; then
  SKILL_DIR="$SCRIPT_DIR"
else
  SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
fi
TEMPLATES="$SKILL_DIR/templates"

TARGET=""
CONTAINER="sdlc"          # the pipeline's home inside TARGET; --into . opts out
PROJECT_NAME="Project"
FORCE=0
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --into)
      [ $# -ge 2 ] || { echo "error: --into needs a value (a folder name, or . for the target root)" >&2; exit 2; }
      CONTAINER="$2"; shift 2 ;;
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

# Where files actually land. `--into .` (or an empty name) writes at the target
# root; any other name nests the whole pipeline in that one container folder.
if [ -z "$CONTAINER" ] || [ "$CONTAINER" = "." ]; then
  DEST_ROOT="$TARGET"
else
  DEST_ROOT="$TARGET/$CONTAINER"
fi

created=0
skipped=0
backup_dir=""

# --force clobbers hand-adapted files, so copy the container aside before the
# first overwrite. Lazy: a --force run that overwrites nothing leaves no backup.
make_backup() {
  [ -z "$backup_dir" ] || return 0          # already backed up this run
  local n=1
  while [ -e "$DEST_ROOT.bak-$n" ]; do n=$((n + 1)); done
  backup_dir="$DEST_ROOT.bak-$n"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  would back up $DEST_ROOT -> $backup_dir"
    return 0
  fi
  cp -R "$DEST_ROOT" "$backup_dir"
  echo "  backup  $DEST_ROOT -> $backup_dir"
}

# Sorted for deterministic, readable output.
while IFS= read -r src; do
  rel="${src#"$TEMPLATES"/}"
  dest="$DEST_ROOT/$rel"

  if [ -e "$dest" ] && [ "$FORCE" -eq 0 ]; then
    echo "  skip    $rel (exists)"
    skipped=$((skipped + 1))
    continue
  fi

  # Only an existing file is at risk; a brand-new one needs no net.
  if [ -e "$dest" ]; then make_backup; fi

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
  echo "dry run: $created file(s) would be written into $DEST_ROOT, $skipped skipped."
  [ -n "$backup_dir" ] && echo "         $DEST_ROOT would be backed up to $backup_dir first."
  exit 0
fi

echo "Scaffolded into $DEST_ROOT — $created created, $skipped skipped."
[ "$DEST_ROOT" != "$TARGET" ] && echo "The pipeline lives in $CONTAINER/ so it stays clear of the rest of $TARGET."
[ -n "$backup_dir" ] && echo "Overwrote existing files; the originals are in $backup_dir"
echo
echo "Next: the adaptation pass in $SKILL_DIR/SKILL.md"
echo "  1. set the project name + stage list in AGENTS.md"
echo "  2. drop stages/design targets the project won't use"
echo "  3. paste the Figma URL into 3-design/figma/AGENTS.md"
echo "  4. set the design constraints in 3-design/AGENTS.md"
echo
echo "Rules live in AGENTS.md. Each CLAUDE.md is a stub that imports it — leave them alone."
