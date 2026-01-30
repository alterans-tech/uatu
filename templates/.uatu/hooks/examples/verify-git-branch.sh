#!/usr/bin/env bash
# verify-git-branch.sh
# Example SessionStart hook that warns if on main/master branch
#
# Usage: Add to .claude/hooks.json:
# {
#   "event": "SessionStart",
#   "scripts": [
#     {"path": ".uatu/hooks/examples/verify-git-branch.sh", "enabled": true}
#   ]
# }

set -euo pipefail

# Read hook input (JSON on stdin)
INPUT=$(cat)
WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory // ""')

# Check if we're in a git repository
if [ -z "$WORKING_DIR" ] || ! command -v git &> /dev/null; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

cd "$WORKING_DIR"

if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

# Get current branch
BRANCH=$(git branch --show-current 2>/dev/null || echo "")

# Warn if on protected branches
if [[ "$BRANCH" == "main" ]] || [[ "$BRANCH" == "master" ]]; then
    CONTEXT="WARNING: You are currently on branch '$BRANCH'. Consider creating a feature branch before making changes."
else
    CONTEXT=""
fi

# Output JSON response
jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
