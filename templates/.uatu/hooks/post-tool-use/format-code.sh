#!/usr/bin/env bash
# format-code.sh
# Automatically formats code after Write/Edit operations

set -euo pipefail

# Read hook input
INPUT=$(cat)

# Extract tool name and result
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolResult.toolName // ""')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.toolResult.input // "{}"')

# Only run for Write and Edit tools
if [[ "$TOOL_NAME" != "Write" ]] && [[ "$TOOL_NAME" != "Edit" ]]; then
    # Not a file operation - no-op
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

# Extract file path from tool input
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // ""')

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    # No file or file doesn't exist - no-op
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

# Determine file extension
EXT="${FILE_PATH##*.}"

# Format based on extension
FORMAT_RESULT=""

case "$EXT" in
    ts|tsx|js|jsx)
        # JavaScript/TypeScript - use prettier
        if command -v prettier &> /dev/null; then
            if prettier --write "$FILE_PATH" &> /dev/null; then
                FORMAT_RESULT="Formatted with prettier"
            fi
        fi
        ;;

    py)
        # Python - use black
        if command -v black &> /dev/null; then
            if black -q "$FILE_PATH" &> /dev/null; then
                FORMAT_RESULT="Formatted with black"
            fi
        fi
        ;;

    go)
        # Go - use gofmt
        if command -v gofmt &> /dev/null; then
            if gofmt -w "$FILE_PATH" &> /dev/null; then
                FORMAT_RESULT="Formatted with gofmt"
            fi
        fi
        ;;

    *)
        # Unknown extension - no-op
        echo '{"additionalContext": "", "error": null}'
        exit 0
        ;;
esac

# Output result (or empty if formatting failed/not available)
if [ -n "$FORMAT_RESULT" ]; then
    CONTEXT="$FORMAT_RESULT: $FILE_PATH"
else
    CONTEXT=""
fi

jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
