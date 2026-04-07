#!/usr/bin/env bash
set -euo pipefail

# Scope Detection — suggests /orch for large-scope tasks
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
  echo '{"additionalContext": "This looks like a multi-file task. Consider using /orch swarm for parallel execution with context rot prevention.", "error": null}'
  exit 0
fi

# Check for risky-area indicators — suggest plan mode
if echo "$PROMPT" | grep -qiE '(auth|payment|migration|deploy|credential|secret|encrypt|ssl|certificate|database schema|drop table|delete all|force push)'; then
  echo '{"additionalContext": "This touches a sensitive area. Consider entering plan mode (/plan) to review your approach before execution, or /orch --dry-run for multi-file work.", "error": null}'
  exit 0
fi

echo '{"additionalContext": "", "error": null}'
