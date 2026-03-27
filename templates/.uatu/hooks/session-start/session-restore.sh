#!/bin/bash
# session-restore.sh
# Restore context from last session checkpoint on session start

set -euo pipefail

source "$(dirname "$0")/../hook-profile.sh"
check_profile "standard" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

CHECKPOINT_DIR=".uatu/delivery/checkpoints"

if [[ -d "$CHECKPOINT_DIR" ]]; then
    LATEST=$(ls -t "$CHECKPOINT_DIR"/session-*.md 2>/dev/null | head -1)
    if [[ -n "$LATEST" ]]; then
        CONTEXT="Last session checkpoint found: $LATEST

$(cat "$LATEST")

Resume from above context if continuing previous work."

        jq -n --arg ctx "$CONTEXT" '{"additionalContext": $ctx, "error": null}'
        exit 0
    fi
fi

echo '{"additionalContext": "", "error": null}'
