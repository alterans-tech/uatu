#!/usr/bin/env bash
set -euo pipefail

# Smart Agent Suggestion — suggests relevant commands based on file patterns
# Profile: standard

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/hook-profile.sh" 2>/dev/null || true
check_profile "standard" 2>/dev/null || true

INPUT="$(cat)"

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

# Only trigger on Write/Edit
if [ "$TOOL_NAME" != "Write" ] && [ "$TOOL_NAME" != "Edit" ]; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

SUGGESTION=""

# Auth/security files
if echo "$FILE_PATH" | grep -qiE 'auth|security|login|password|token|session|credential|oauth|jwt|encrypt'; then
  SUGGESTION="Security-sensitive file modified. Consider running /security-scan before merging."
fi

# Database/migration files
if echo "$FILE_PATH" | grep -qiE 'migration|schema|database|model\.ts|model\.py|prisma|sequelize|typeorm|knex'; then
  SUGGESTION="Database file modified. Consider having the database-expert agent review this change."
fi

# UI/component files
if echo "$FILE_PATH" | grep -qiE 'component|\.tsx$|\.vue$|\.svelte$|pages/|views/|ui/'; then
  SUGGESTION="UI component modified. The ui-ux-design skill has design rules and a pre-delivery checklist."
fi

# Test files
if echo "$FILE_PATH" | grep -qiE '\.test\.|\.spec\.|__tests__|_test\.'; then
  SUGGESTION="Test file modified. Consider /tdd for test-driven development workflow."
fi

# CI/CD files
if echo "$FILE_PATH" | grep -qiE 'dockerfile|docker-compose|\.github/workflows|jenkins|\.gitlab-ci|deploy'; then
  SUGGESTION="Infrastructure file modified. Consider /verify before merging deployment changes."
fi

if [ -n "$SUGGESTION" ]; then
  echo "{\"additionalContext\": $(echo "$SUGGESTION" | jq -Rs .), \"error\": null}"
else
  echo '{"additionalContext": "", "error": null}'
fi
