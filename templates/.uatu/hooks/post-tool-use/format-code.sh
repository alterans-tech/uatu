#!/usr/bin/env bash
# format-code.sh
# Formats code after Write/Edit operations
# NEW files: format the whole file
# EXISTING files: skip auto-formatting (don't reformat untouched code)

set -euo pipefail

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // "{}"')

source "$(dirname "$0")/../hook-profile.sh"
check_profile "standard" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

# Only run for Write and Edit tools
if [[ "$TOOL_NAME" != "Write" ]] && [[ "$TOOL_NAME" != "Edit" ]]; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // ""')

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

# Check if file is tracked by git (existing file in the project)
IS_EXISTING=false
if git ls-files --error-unmatch "$FILE_PATH" &>/dev/null 2>&1; then
    IS_EXISTING=true
fi

# For existing files: do NOT auto-format (avoids noisy diffs on untouched code)
# For new files: format the whole file
if [ "$IS_EXISTING" = true ]; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

EXT="${FILE_PATH##*.}"
FORMAT_RESULT=""

case "$EXT" in
    ts|tsx|js|jsx)
        if command -v prettier &> /dev/null; then
            if prettier --write "$FILE_PATH" &> /dev/null; then
                FORMAT_RESULT="Formatted with prettier"
            fi
        fi
        ;;
    py)
        if command -v black &> /dev/null; then
            if black -q "$FILE_PATH" &> /dev/null; then
                FORMAT_RESULT="Formatted with black"
            fi
        fi
        ;;
    go)
        if command -v gofmt &> /dev/null; then
            if gofmt -w "$FILE_PATH" &> /dev/null; then
                FORMAT_RESULT="Formatted with gofmt"
            fi
        fi
        ;;
    *)
        echo '{"additionalContext": "", "error": null}'
        exit 0
        ;;
esac

if [ -n "$FORMAT_RESULT" ]; then
    CONTEXT="$FORMAT_RESULT: $FILE_PATH"
else
    CONTEXT=""
fi

jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
