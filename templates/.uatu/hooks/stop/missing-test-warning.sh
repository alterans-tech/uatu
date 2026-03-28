#!/usr/bin/env bash
set -euo pipefail

# Missing Test Warning — warns if source files changed without test files
# Profile: standard

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/hook-profile.sh" 2>/dev/null || true
check_profile "standard" 2>/dev/null || true

# Get modified source files (not test files)
MODIFIED_SOURCES=$(git diff --name-only HEAD 2>/dev/null | grep -E '\.(ts|tsx|js|jsx|py|go|rs|java)$' | grep -vE '(test|spec|_test)\.' || true)

if [ -z "$MODIFIED_SOURCES" ]; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

UNTESTED=""
while IFS= read -r src; do
  [ -z "$src" ] && continue
  # Check if a corresponding test file was also modified
  BASE=$(echo "$src" | sed -E 's/\.(ts|tsx|js|jsx|py|go|rs|java)$//')
  if ! git diff --name-only HEAD 2>/dev/null | grep -qE "${BASE}[._](test|spec)\."; then
    UNTESTED="${UNTESTED}${src}, "
  fi
done <<< "$MODIFIED_SOURCES"

UNTESTED=$(echo "$UNTESTED" | sed 's/, $//')

if [ -n "$UNTESTED" ]; then
  echo "{\"additionalContext\": $(echo "Missing test coverage: $UNTESTED were modified but their test files were not. Consider adding/updating tests." | jq -Rs .), \"error\": null}"
else
  echo '{"additionalContext": "", "error": null}'
fi
