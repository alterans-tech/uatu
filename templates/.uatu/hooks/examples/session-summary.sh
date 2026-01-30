#!/usr/bin/env bash
# session-summary.sh
# Example Stop hook that generates a session summary
#
# Usage: Add to .claude/hooks.json:
# {
#   "event": "Stop",
#   "scripts": [
#     {"path": ".uatu/hooks/examples/session-summary.sh", "enabled": true}
#   ]
# }

set -euo pipefail

# Read hook input
INPUT=$(cat)

WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory // ""')
TIMESTAMP=$(echo "$INPUT" | jq -r '.timestamp // ""')

# Check if we have tool usage logs
METRICS_FILE="$WORKING_DIR/.uatu/cache/tool-usage.log"

if [ ! -f "$METRICS_FILE" ]; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

# Count tool usage
TOTAL_TOOLS=$(wc -l < "$METRICS_FILE" | tr -d ' ')
TOOL_BREAKDOWN=$(awk -F, '{print $2}' "$METRICS_FILE" | sort | uniq -c | sort -rn | head -5)

# Create session summary
SUMMARY_FILE="$WORKING_DIR/.uatu/cache/session-summary-$(date +%Y%m%d-%H%M%S).txt"

cat > "$SUMMARY_FILE" << EOF
Session Summary
===============
Ended: $TIMESTAMP
Total tool calls: $TOTAL_TOOLS

Top tools used:
$TOOL_BREAKDOWN

Session logs saved to: $SUMMARY_FILE
EOF

# Clean up old tool usage log for next session
rm -f "$METRICS_FILE"

# Output session summary location
CONTEXT="Session summary saved to: $(basename "$SUMMARY_FILE")"

jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
