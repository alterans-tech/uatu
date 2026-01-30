#!/usr/bin/env bash
# enforce-sequential-thinking.sh
# Reminds Claude to use Sequential Thinking MCP for all tasks

set -euo pipefail

# Read hook input
INPUT=$(cat)

# Extract working directory
WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory // ""')

if [ -z "$WORKING_DIR" ]; then
    WORKING_DIR="$PWD"
fi

# Check if Sequential Thinking guide exists
SEQ_GUIDE="$WORKING_DIR/.uatu/guides/SEQUENTIAL-THINKING.md"

if [ ! -f "$SEQ_GUIDE" ]; then
    # Guide missing - inject basic reminder
    CONTEXT="CRITICAL REMINDER: Every task MUST start with Sequential Thinking analysis (mcp__sequential-thinking__ tool). No exceptions."
else
    # Guide exists - reference it
    CONTEXT="CRITICAL REMINDER: Every task MUST start with Sequential Thinking analysis (mcp__sequential-thinking__ tool).

Refer to .uatu/guides/SEQUENTIAL-THINKING.md for patterns and depth guidelines.

Do NOT skip this step or use heuristic shortcuts."
fi

# Output JSON with context
jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
