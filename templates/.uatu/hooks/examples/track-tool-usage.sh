#!/usr/bin/env bash
# track-tool-usage.sh
# Example PostToolUse hook that logs tool usage statistics
#
# Usage: Add to .claude/hooks.json:
# {
#   "event": "PostToolUse",
#   "scripts": [
#     {"path": ".uatu/hooks/examples/track-tool-usage.sh", "enabled": true}
#   ]
# }

set -euo pipefail

# Read hook input
INPUT=$(cat)

WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory // ""')
TOOL_RESULT=$(echo "$INPUT" | jq -r '.toolResult // "{}"')
TOOL_NAME=$(echo "$TOOL_RESULT" | jq -r '.toolName // "unknown"')
SUCCESS=$(echo "$TOOL_RESULT" | jq -r '.success // false')

# Create metrics directory if needed
METRICS_DIR="$WORKING_DIR/.uatu/cache"
mkdir -p "$METRICS_DIR"

# Log tool usage
METRICS_FILE="$METRICS_DIR/tool-usage.log"
TIMESTAMP=$(date -Iseconds)

echo "$TIMESTAMP,$TOOL_NAME,$SUCCESS" >> "$METRICS_FILE"

# No additional context needed (silent logging)
echo '{"additionalContext": "", "error": null}'
