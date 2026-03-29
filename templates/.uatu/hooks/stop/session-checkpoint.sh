#!/bin/bash
# session-checkpoint.sh
# Save structured JSONL checkpoint + markdown summary on session end

set -euo pipefail

source "$(dirname "$0")/../hook-profile.sh"
check_profile "standard" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

CHECKPOINT_DIR=".uatu/delivery/checkpoints"
mkdir -p "$CHECKPOINT_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ISO_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Collect modified files
MODIFIED_FILES=$(git diff --name-only HEAD 2>/dev/null | head -20 | tr '\n' ',' | sed 's/,$//' || echo "unknown")

# Collect session notes if they exist
SESSION_NOTES=""
if [[ -f ".uatu/delivery/current-session.md" ]]; then
  SESSION_NOTES=$(cat ".uatu/delivery/current-session.md")
fi

# Get project name
PROJECT_NAME="unknown"
if [[ -f ".uatu/config/project.md" ]]; then
  PROJECT_NAME=$(grep -m1 'name:' ".uatu/config/project.md" 2>/dev/null | sed 's/.*name:\s*//' || echo "unknown")
fi

# Write JSONL entry (structured, searchable)
JSONL_FILE="$CHECKPOINT_DIR/sessions.jsonl"
jq -nc \
  --arg ts "$ISO_TIMESTAMP" \
  --arg project "$PROJECT_NAME" \
  --arg files "$MODIFIED_FILES" \
  --arg notes "$SESSION_NOTES" \
  '{timestamp: $ts, project: $project, files_modified: $files, notes: $notes}' \
  >> "$JSONL_FILE" 2>/dev/null || true

# Also write human-readable markdown (backwards compatible)
CHECKPOINT_FILE="$CHECKPOINT_DIR/session-$TIMESTAMP.md"
cat > "$CHECKPOINT_FILE" << CHECKPOINT
# Session Checkpoint: $TIMESTAMP

## Session End: $(date)

## Files Modified
$MODIFIED_FILES

## What was worked on
${SESSION_NOTES:-No session notes found. Claude: summarize the session work here on next session restore.}

## Next Steps
<!-- Claude: list what remains to be done -->
CHECKPOINT

echo "Session checkpoint saved: $CHECKPOINT_FILE (JSONL: $JSONL_FILE)" >&2
echo '{"additionalContext": "", "error": null}'
