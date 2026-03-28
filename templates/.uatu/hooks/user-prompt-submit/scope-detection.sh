#!/usr/bin/env bash
set -euo pipefail

# Scope Detection — suggests /orchestrate for large-scope tasks
# Profile: standard

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/hook-profile.sh" 2>/dev/null || true
check_profile "standard" 2>/dev/null || true

INPUT="$(cat)"

PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

if [ -z "$PROMPT" ]; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

# Check for scope indicators
if echo "$PROMPT" | grep -qiE 'all (files|modules|services|components|handlers|endpoints)|refactor (the|all|every)|migrate|across (all|the|every)|every (file|module|service)|entire (codebase|project|module)|restructure|reorganize|rename all'; then
  echo '{"additionalContext": "This looks like a multi-file task. Consider using /orchestrate swarm for parallel execution with context rot prevention.", "error": null}'
else
  echo '{"additionalContext": "", "error": null}'
fi
