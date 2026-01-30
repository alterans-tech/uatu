#!/usr/bin/env bash
# prevent-destructive-ops.sh
# Example PreToolUse hook that blocks dangerous operations
#
# Usage: Add to .claude/hooks.json:
# {
#   "event": "PreToolUse",
#   "scripts": [
#     {"path": ".uatu/hooks/examples/prevent-destructive-ops.sh", "enabled": true}
#   ]
# }

set -euo pipefail

# Read hook input
INPUT=$(cat)

# Parse tool information
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName // ""')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.toolInput // "{}"')

# Check for Bash commands
if [[ "$TOOL_NAME" == "Bash" ]]; then
    COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // ""')

    # Block recursive rm -rf on root or home
    if [[ "$COMMAND" =~ rm[[:space:]]+-rf[[:space:]]+(/|~/|\$HOME) ]]; then
        jq -n '{
          "additionalContext": "",
          "error": "BLOCKED: Dangerous rm -rf command detected targeting root or home directory"
        }'
        exit 1
    fi

    # Block force push to protected branches
    if [[ "$COMMAND" =~ git[[:space:]]+push.*--force.*(main|master) ]]; then
        jq -n '{
          "additionalContext": "",
          "error": "BLOCKED: Force push to protected branch (main/master) is not allowed"
        }'
        exit 1
    fi
fi

# Check for Write operations to sensitive files
if [[ "$TOOL_NAME" == "Write" ]]; then
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // ""')

    # Block writes to .env files (should be edited manually)
    if [[ "$FILE_PATH" =~ \.env$ ]]; then
        jq -n '{
          "additionalContext": "",
          "error": "BLOCKED: Cannot modify .env files via Write tool. Edit manually for security."
        }'
        exit 1
    fi
fi

# Allow operation
echo '{"additionalContext": "", "error": null}'
