#!/usr/bin/env bash
set -euo pipefail

# Prompt Quality Advisor — scores prompts on 5 research-backed dimensions
# and injects coaching for low-scoring prompts.
# Dimensions: intent, context, specificity, scope, verifiability
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

# --- Exempt categories (not scored) ---

# Slash commands and shell commands
if echo "$PROMPT" | grep -qE '^\s*[/!]'; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

WORD_COUNT=$(echo "$PROMPT" | wc -w | tr -d ' ')

# Execution confirmations (yes, go, do it, lgtm, proceed, etc.)
if [ "$WORD_COUNT" -le 4 ]; then
  LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  case "$LOWER" in
    yes|yeah|yep|y|ok|okay|sure|go|"go ahead"|"do it"|"run it"|"ship it"|"looks good"|lgtm|proceed|continue|approved|confirm|confirmed|"let's go"|"send it"|"merge it"|"push it"|"deploy it"|"commit it"|"that's correct"|correct|"that works"|perfect|exactly|agreed|"go for it"|"make it so"|"sounds good"|right|yup|"please do"|execute|thanks|"thank you"|"got it"|understood|"i see"|noted|cool|great|awesome|nice)
      echo '{"additionalContext": "", "error": null}'
      exit 0
      ;;
  esac
fi

# Short follow-up questions (context is in the conversation)
if [ "$WORD_COUNT" -le 8 ] && echo "$PROMPT" | grep -q '?'; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

# Short continuations ("now do the same for...", "also for the other files")
if [ "$WORD_COUNT" -le 12 ] && echo "$PROMPT" | grep -qiE '^(now )?(do )?the same |^(and )?(now )?(the )?(other|rest|remaining)|^also (for|do|add)|^next\b'; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

# Skip very short prompts (terse but not necessarily bad — not enough signal to coach on)
if [ "$WORD_COUNT" -le 5 ]; then
  echo '{"additionalContext": "", "error": null}'
  exit 0
fi

# --- Score against 5 dimensions ---

MISSING=""
SCORE=5

# 1. Context — file refs, backtick refs, code blocks
if ! echo "$PROMPT" | grep -qE '[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+|\.tsx?|\.py|\.go|\.rs|\.java|\.md|`.+`|```'; then
  SCORE=$((SCORE - 1))
  MISSING="${MISSING}context (name files, use backticks for \`functions()\`), "
fi

# 2. Verifiability — done-conditions, expected output, test commands
if ! echo "$PROMPT" | grep -qiE 'done when|done:|should (pass|work|return|render|show|produce)|expect|run .+ test|npm test|pytest|go test|verify|confirm that'; then
  SCORE=$((SCORE - 1))
  MISSING="${MISSING}verifiability (add 'done when:' or expected output), "
fi

# 3. Scope — constraints or decomposition for multi-concern prompts
if [ "$WORD_COUNT" -gt 15 ]; then
  if ! echo "$PROMPT" | grep -qiE "do not|don.t|only|must not|never|avoid" && ! echo "$PROMPT" | grep -qE '^\s*[-*1-9#]|^[0-9]+\.'; then
    SCORE=$((SCORE - 1))
    MISSING="${MISSING}scope (add constraints or decompose with bullets), "
  fi
fi

# 4. Specificity — vague words without concrete details
VAGUE_COUNT=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]' | grep -oiE '\b(some|maybe|probably|something|stuff|things|better|improve|properly)\b' | wc -l | tr -d ' ')
if [ "$VAGUE_COUNT" -ge 2 ]; then
  SCORE=$((SCORE - 1))
  MISSING="${MISSING}specificity (replace vague words with concrete details), "
fi

# Clean trailing comma
MISSING=$(echo "$MISSING" | sed 's/, $//')

# Only inject coaching for low scores on prompts with enough words to improve
if [ "$SCORE" -le 3 ] && [ "$WORD_COUNT" -gt 12 ]; then
  CONTEXT="Prompt quality: ${SCORE}/5. Consider adding: ${MISSING}. Run /prompt-rewrite to restructure, or add the missing elements before proceeding."
  echo "{\"additionalContext\": $(echo "$CONTEXT" | jq -Rs .), \"error\": null}"
else
  echo '{"additionalContext": "", "error": null}'
fi
