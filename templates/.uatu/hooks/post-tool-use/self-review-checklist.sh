#!/usr/bin/env bash
# self-review-checklist.sh
# Scans written/edited files for common oversights after Write/Edit operations.
# Profile: standard
#
# Checks:
#   - TODO/FIXME/HACK/XXX comments
#   - Debug statements (console.log, print(), fmt.Println, etc.)
#   - Placeholder values (lorem, example.com, test@test, PLACEHOLDER)
#   - Hardcoded secrets/IDs (sk-, ghp_, AKIA prefixes)

set -euo pipefail

INPUT=$(cat)

source "$(dirname "$0")/../hook-profile.sh"
check_profile "standard" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")

# Only run for Write and Edit tools
if [[ "$TOOL_NAME" != "Write" ]] && [[ "$TOOL_NAME" != "Edit" ]]; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || echo "")

if [[ -z "$FILE_PATH" ]] || [[ ! -f "$FILE_PATH" ]]; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

FINDINGS=()

# 1. TODO/FIXME/HACK/XXX comments
if grep -qE '\b(TODO|FIXME|HACK|XXX)\b' "$FILE_PATH" 2>/dev/null; then
    COUNT=$(grep -cE '\b(TODO|FIXME|HACK|XXX)\b' "$FILE_PATH" 2>/dev/null || echo "0")
    FINDINGS+=("$COUNT unresolved TODO/FIXME/HACK/XXX comment(s)")
fi

# 2. Debug statements (JS/TS console.*, Python print(), Go fmt.Println)
if grep -qE '^\s*(console\.(log|error|warn|debug|info)|print\(|fmt\.Print(ln|f)?\()' "$FILE_PATH" 2>/dev/null; then
    COUNT=$(grep -cE '^\s*(console\.(log|error|warn|debug|info)|print\(|fmt\.Print(ln|f)?\()' "$FILE_PATH" 2>/dev/null || echo "0")
    FINDINGS+=("$COUNT debug statement(s) (console.log / print / fmt.Println)")
fi

# 3. Placeholder values
if grep -qiE '\b(lorem|PLACEHOLDER)\b|example\.com|test@test' "$FILE_PATH" 2>/dev/null; then
    COUNT=$(grep -ciE '\b(lorem|PLACEHOLDER)\b|example\.com|test@test' "$FILE_PATH" 2>/dev/null || echo "0")
    FINDINGS+=("$COUNT placeholder value(s) (lorem / example.com / test@test / PLACEHOLDER)")
fi

# 4. Hardcoded secrets/IDs
if grep -qE '["'"'"'`](sk-|ghp_|AKIA)[A-Za-z0-9]' "$FILE_PATH" 2>/dev/null; then
    COUNT=$(grep -cE '["'"'"'`](sk-|ghp_|AKIA)[A-Za-z0-9]' "$FILE_PATH" 2>/dev/null || echo "0")
    FINDINGS+=("$COUNT potential hardcoded secret(s) (sk- / ghp_ / AKIA prefix)")
fi

# Build output
if [[ ${#FINDINGS[@]} -gt 0 ]]; then
    # Join findings into a single message
    MESSAGE="Self-review checklist for ${FILE_PATH}:"
    for FINDING in "${FINDINGS[@]}"; do
        MESSAGE+=" | $FINDING"
    done
    jq -n --arg context "$MESSAGE" '{"additionalContext": $context, "error": null}'
else
    echo '{"additionalContext": "", "error": null}'
fi
