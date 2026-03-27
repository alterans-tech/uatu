#!/bin/bash
# event-log.sh
# Appends each tool call as a JSONL line to .uatu/logs/session.jsonl
# Profile: strict

set -euo pipefail

INPUT=$(cat)

source "$(dirname "$0")/../hook-profile.sh"
check_profile "strict" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

WORKING_DIR=$(echo "$INPUT" | jq -r '.working_directory // ""' 2>/dev/null || echo "$PWD")
LOG_DIR="$WORKING_DIR/.uatu/logs"
LOG_FILE="$LOG_DIR/session.jsonl"

mkdir -p "$LOG_DIR" 2>/dev/null || true

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Log tool name and timestamp (not full input to avoid sensitive data)
jq -n --arg tool "$TOOL_NAME" --arg ts "$TIMESTAMP" \
    '{"timestamp": $ts, "tool": $tool}' >> "$LOG_FILE" 2>/dev/null || true

echo '{"additionalContext": "", "error": null}'
