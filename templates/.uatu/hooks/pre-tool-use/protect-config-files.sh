#!/bin/bash
# protect-config-files.sh
# Prevents Claude from modifying linter/formatter config files.
# When Claude encounters a lint/format error, it should fix the CODE, not weaken the rules.

set -euo pipefail

INPUT=$(cat)

source "$(dirname "$0")/../hook-profile.sh"
check_profile "minimal" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")

if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || echo "")
    BASENAME=$(basename "$FILE_PATH" 2>/dev/null || echo "")

    PROTECTED_FILES=(".eslintrc" ".eslintrc.js" ".eslintrc.json" ".eslintrc.yml" "eslint.config.js" "eslint.config.mjs" "eslint.config.ts" "biome.json" "biome.jsonc" ".prettierrc" ".prettierrc.js" ".prettierrc.json" "prettier.config.js" "prettier.config.mjs" ".stylelintrc" ".stylelintrc.json" "stylelint.config.js" "tsconfig.json" "tslint.json" ".rubocop.yml" ".pylintrc" "pyproject.toml" ".flake8" "ruff.toml" ".golangci.yml" ".golangci.yaml")

    for protected in "${PROTECTED_FILES[@]}"; do
        if [[ "$BASENAME" == "$protected" ]]; then
            jq -n --arg msg "BLOCKED: Do not modify linter/formatter config '$BASENAME'. Fix the code to satisfy the rules instead of weakening the rules. If you believe the config genuinely needs updating, ask the user first." \
                '{"additionalContext": "", "error": $msg}'
            exit 2
        fi
    done
fi

echo '{"additionalContext": "", "error": null}'
