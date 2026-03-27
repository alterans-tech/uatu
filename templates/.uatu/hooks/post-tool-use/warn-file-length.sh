#!/bin/bash
# warn-file-length.sh
# Warns when a written/edited file exceeds 400 lines.
# Profile: strict

set -euo pipefail

INPUT=$(cat)

source "$(dirname "$0")/../hook-profile.sh"
check_profile "strict" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")

if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || echo "")

    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        LINE_COUNT=$(wc -l < "$FILE_PATH" 2>/dev/null | tr -d ' ')

        if [[ "$LINE_COUNT" -gt 400 ]]; then
            CONTEXT="WARNING: File '$FILE_PATH' is $LINE_COUNT lines (threshold: 400). Consider splitting into smaller modules."
            jq -n --arg context "$CONTEXT" '{"additionalContext": $context, "error": null}'
            exit 0
        fi
    fi
fi

echo '{"additionalContext": "", "error": null}'
