#!/bin/bash
# prevent-sensitive-writes.sh
# Prevent writing to sensitive files (env files, credentials, keys)

set -euo pipefail

INPUT=$(cat)

source "$(dirname "$0")/../hook-profile.sh"

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")

if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || echo "")

    # Patterns matched as substrings against the file path.
    # Use suffix form (.pem not *.pem) so substring matching works correctly.
    SENSITIVE_PATTERNS=(".env" ".env.local" ".env.production" ".env.staging" "credentials.json" ".pem" ".key" "id_rsa" "id_ed25519" ".p12" ".pfx")

    for pattern in "${SENSITIVE_PATTERNS[@]}"; do
        if [[ "$FILE_PATH" == *"$pattern"* ]]; then
            jq -n --arg msg "BLOCKED: Writing to sensitive file blocked: $FILE_PATH" \
                '{"additionalContext": "", "error": $msg}'
            exit 2
        fi
    done
fi

echo '{"additionalContext": "", "error": null}'
