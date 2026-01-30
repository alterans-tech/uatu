#!/usr/bin/env bash
# update-jira.sh
# Updates Jira issue when session ends (placeholder for future implementation)

set -euo pipefail

# Read hook input
INPUT=$(cat)

# Extract working directory
WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory // ""')

if [ -z "$WORKING_DIR" ]; then
    WORKING_DIR="$PWD"
fi

# TODO: Detect Jira key from conversation context
# This would require parsing conversation history, which isn't available in hook input yet
# Possible approaches:
#   1. Store JIRA_KEY in environment at session start
#   2. Parse branch name (e.g., feature/UT-123-description)
#   3. Read from .uatu/context/current-issue.txt
#   4. Extract from recent commits

# Placeholder: Try to detect from branch name
JIRA_KEY=""
if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "")
    if [[ "$BRANCH" =~ ([A-Z]+-[0-9]+) ]]; then
        JIRA_KEY="${BASH_REMATCH[1]}"
    fi
fi

if [ -z "$JIRA_KEY" ]; then
    # No Jira key detected - silent no-op
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

# TODO: Future implementation would:
#   1. Summarize work done in session
#   2. Call mcp__atlassian__jira_add_comment with summary
#   3. Update issue status if appropriate
#   4. Log time worked

# Placeholder output
CONTEXT="Session ended. Detected Jira issue: $JIRA_KEY
(Jira update placeholder - future implementation will post session summary)"

jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
