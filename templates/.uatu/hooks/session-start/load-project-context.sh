#!/usr/bin/env bash
# load-project-context.sh
# Loads project configuration at session start

set -euo pipefail

# Read hook input (JSON on stdin)
INPUT=$(cat)

# Extract working directory from input
WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory // ""')

if [ -z "$WORKING_DIR" ]; then
    # Fallback to PWD if not provided
    WORKING_DIR="$PWD"
fi

# Check for project config
PROJECT_CONFIG="$WORKING_DIR/.uatu/config/project.md"

if [ ! -f "$PROJECT_CONFIG" ]; then
    # No project config - silent no-op
    cat <<EOF
{
  "additionalContext": "",
  "error": null
}
EOF
    exit 0
fi

# Read project config
PROJECT_CONTENT=$(cat "$PROJECT_CONFIG")

# Inject as additional context
# Use jq to safely escape content for JSON
CONTEXT=$(jq -n --arg content "$PROJECT_CONTENT" \
    'CRITICAL: Project configuration loaded from .uatu/config/project.md

$content

This configuration MUST be followed for all naming conventions, folder structures, and project-specific rules.')

# Output JSON
jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
