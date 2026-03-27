#!/bin/bash
# session-checkpoint.sh
# Save a timestamped session checkpoint on session end

set -euo pipefail

source "$(dirname "$0")/../hook-profile.sh"
check_profile "standard" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

CHECKPOINT_DIR=".uatu/delivery/checkpoints"
mkdir -p "$CHECKPOINT_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
CHECKPOINT_FILE="$CHECKPOINT_DIR/session-$TIMESTAMP.md"

# Capture session notes if they exist
SESSION_NOTES=""
if [[ -f ".uatu/delivery/current-session.md" ]]; then
    SESSION_NOTES=$(cat ".uatu/delivery/current-session.md")
fi

cat > "$CHECKPOINT_FILE" << CHECKPOINT
# Session Checkpoint: $TIMESTAMP

## Session End: $(date)

## What was worked on

${SESSION_NOTES:-No session notes found. Claude: summarize the session work here on next session restore.}

## Next Steps

<!-- Claude: list what remains to be done -->
CHECKPOINT

echo "Session checkpoint saved: $CHECKPOINT_FILE" >&2
echo '{"additionalContext": "", "error": null}'
