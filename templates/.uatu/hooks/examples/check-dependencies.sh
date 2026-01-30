#!/usr/bin/env bash
# check-dependencies.sh
# Example SessionStart hook that checks for required development tools
#
# Usage: Add to .claude/hooks.json:
# {
#   "event": "SessionStart",
#   "scripts": [
#     {"path": ".uatu/hooks/examples/check-dependencies.sh", "enabled": true}
#   ]
# }

set -euo pipefail

# Read hook input
INPUT=$(cat)

# Define required tools (customize this list for your project)
REQUIRED_TOOLS=(
    "git"
    "jq"
    "node"
)

# Optional tools (warn but don't error)
OPTIONAL_TOOLS=(
    "prettier"
    "black"
)

# Check for missing required tools
MISSING=()
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING+=("$tool")
    fi
done

# Check for missing optional tools
MISSING_OPTIONAL=()
for tool in "${OPTIONAL_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_OPTIONAL+=("$tool")
    fi
done

# Build context message
CONTEXT=""
if [ ${#MISSING[@]} -gt 0 ]; then
    CONTEXT="ERROR: Missing required tools: ${MISSING[*]}. Please install them before continuing."
elif [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
    CONTEXT="INFO: Missing optional tools: ${MISSING_OPTIONAL[*]}. Some features may not work."
fi

# Output JSON response
jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
