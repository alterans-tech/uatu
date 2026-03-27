#!/usr/bin/env bash
# load-project-context.sh
# Loads project configuration at session start

set -euo pipefail

# Read hook input (JSON on stdin)
INPUT=$(cat)

source "$(dirname "$0")/../hook-profile.sh"

# Extract working directory from input
WORKING_DIR=$(echo "$INPUT" | jq -r '.working_directory // ""')

if [ -z "$WORKING_DIR" ]; then
    WORKING_DIR="$PWD"
fi

CONTEXT=""

# Load project.md if exists
PROJECT_CONFIG="$WORKING_DIR/.uatu/config/project.md"
if [ -f "$PROJECT_CONFIG" ]; then
    PROJECT_CONTENT=$(cat "$PROJECT_CONFIG")
    CONTEXT="PROJECT CONFIG (.uatu/config/project.md):

$PROJECT_CONTENT

"
fi

# Load framework bootstrap rules (auto-activates Uatu)
BOOTSTRAP="$WORKING_DIR/.uatu/config/bootstrap.md"
if [ -f "$BOOTSTRAP" ]; then
    BOOTSTRAP_CONTENT=$(cat "$BOOTSTRAP")
    CONTEXT="${CONTEXT}UATU FRAMEWORK (active rules — auto-injected):

$BOOTSTRAP_CONTENT

"
fi

# Note other config files that exist
if [ -f "$WORKING_DIR/.uatu/config/architecture.md" ]; then
    CONTEXT="${CONTEXT}NOTE: Tech stack overview available at .uatu/config/architecture.md
"
fi

if [ -f "$WORKING_DIR/.uatu/config/constitution.md" ]; then
    CONTEXT="${CONTEXT}NOTE: AI principles available at .uatu/config/constitution.md
"
fi

# Output JSON
if [ -n "$CONTEXT" ]; then
    jq -n --arg context "$CONTEXT" '{
      "additionalContext": $context,
      "error": null
    }'
else
    echo '{"additionalContext": "", "error": null}'
fi
