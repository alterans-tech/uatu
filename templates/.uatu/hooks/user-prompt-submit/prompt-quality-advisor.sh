#!/usr/bin/env bash
set -euo pipefail

# Prompt Quality Advisor — scores prompts and injects coaching
# Profile: standard

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/hook-profile.sh" 2>/dev/null || true
check_profile "standard" 2>/dev/null || true

INPUT="$(cat)"

PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# Skip if no prompt
if [ -z "$PROMPT" ]; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

# Skip slash commands — they're tool usage, not prompts to score
if echo "$PROMPT" | grep -qE '^\s*/'; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

WORD_COUNT=$(echo "$PROMPT" | wc -w | tr -d ' ')

# Skip ultra-short confirmations (yes, no, go, next, ok, continue, do it)
if [ "$WORD_COUNT" -le 5 ]; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

# For longer prompts, score against key dimensions
SCORE=5
MISSING=""

# Check for file references (paths with / or . extensions)
if ! echo "$PROMPT" | grep -qE '[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+|\.tsx?|\.py|\.go|\.rs|\.java|\.md'; then
  SCORE=$((SCORE - 1))
  MISSING="${MISSING}file references, "
fi

# Check for success criteria
if ! echo "$PROMPT" | grep -qiE 'done when|done:|success|should (pass|work|return|render)|expect'; then
  SCORE=$((SCORE - 1))
  MISSING="${MISSING}success criteria (done when), "
fi

# Check for structure (bullets, numbers, headers)
if ! echo "$PROMPT" | grep -qE '^\s*[-*1-9#]|^[0-9]+\.' && [ "$WORD_COUNT" -gt 15 ]; then
  SCORE=$((SCORE - 1))
  MISSING="${MISSING}structure (use bullets/numbers), "
fi

# Check for constraints
if ! echo "$PROMPT" | grep -qiE 'do not|don.t|only|must not|never|avoid|constraint'; then
  SCORE=$((SCORE - 1))
  MISSING="${MISSING}constraints (ONLY/Do NOT), "
fi

# Clean trailing comma
MISSING=$(echo "$MISSING" | sed 's/, $//')

if [ "$SCORE" -lt 4 ] && [ "$WORD_COUNT" -gt 15 ]; then
  CONTEXT="Prompt score: ${SCORE}/10. Missing: ${MISSING}. Suggest structuring with the templates in .uatu/config/prompt-templates.md. Ask the user for the missing elements before proceeding."
  echo "{\"additionalContext\": $(echo "$CONTEXT" | jq -Rs .), \"error\": null}"
else
  echo '{"additionalContext": "", "error": null}'
fi
