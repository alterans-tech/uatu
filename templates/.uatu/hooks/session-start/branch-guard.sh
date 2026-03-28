#!/usr/bin/env bash
set -euo pipefail

# Branch Guard — warns if on main/master/develop
# Profile: standard

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/hook-profile.sh" 2>/dev/null || true
check_profile "standard" 2>/dev/null || true

BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")

if echo "$BRANCH" | grep -qE '^(main|master|develop)$'; then
  echo "{\"additionalContext\": \"WARNING: You are on the '$BRANCH' branch. Create a feature branch before making changes: git checkout -b UAT-XX/feat/description\", \"error\": null}"
else
  echo '{"additionalContext": "", "error": null}'
fi
