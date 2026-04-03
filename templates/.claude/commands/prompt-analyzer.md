---
description: Session effectiveness dashboard — combines prompt quality with session outcomes from /insights. Shows percentile, friction analysis, and actionable improvements.
---

# Prompt Analyzer

## Arguments

$ARGUMENTS

Supported flags:
- `--since YYYY-MM-DD` — only analyze after this date (default: all time)
- `--compare YYYY-MM-DD` — before/after comparison using this date as split
- `--project NAME` — filter to a specific project
- `--brief` — one-page summary only

## Execution

Follow these steps IN ORDER. Present each section as you go.

### Step 1 — Collect Data

Run a Python script via Bash that:
1. Loads prompts from `~/.claude/history.jsonl`
2. Scores them via `analyze-prompts.py` (try `uatu/prompt-analysis/analyze-prompts.py` then `prompt-analysis/analyze-prompts.py`)
3. Loads session outcomes from `~/.claude/usage-data/facets/*.json` and `session-meta/*.json`
4. Computes session effectiveness scores via `compute_session_scores()`
5. Outputs all metrics as JSON

Apply flags: `--since` filters by date, `--compare` splits into before/after, `--project` filters by project.

### Step 2 — Session Effectiveness Score (HEADLINE)

This is the PRIMARY metric. Formula:
**Session Score = (Prompt Quality × 0.3) + (Outcome × 0.4) + (Efficiency × 0.3)**

**If `--compare`:**
```
SESSION EFFECTIVENESS — Before vs After [date]
═══════════════════════════════════════════════════
BEFORE                                  AFTER
X.X/10 — Nth pctl (Label)      →    X.X/10 — Nth pctl (Label)  (+X.X)
N sessions                           N sessions

  Component         Before  After   Weight
  ─────────         ──────  ─────   ──────
  Prompt Quality    X.XX    X.XX    × 0.3
  Outcome           X.XX    X.XX    × 0.4
  Efficiency        X.XX    X.XX    × 0.3
```

**If normal:**
```
SESSION EFFECTIVENESS: X.X/10 — Nth percentile (Label)
═══════════════════════════════════════════════════
Sessions: N | Period: start to end

  Component         Score   Weight
  ─────────         ─────   ──────
  Prompt Quality    X.XX    × 0.3
  Outcome           X.XX    × 0.4
  Efficiency        X.XX    × 0.3
```

Percentile labels: <15%="Needs work", 15-50%="Below average", 50-75%="Average", 75-90%="Above average", 90-97%="Strong", >97%="Excellent"

### Step 3 — Prompt Dimensions (supporting detail)

Sorted worst to best, markdown table:

| Dimension | Score | Status |
|-----------|-------|--------|
| [weakest] | X.XX | [specific interpretation] |
| ... | ... | ... |
| [strongest] | X.XX | [specific interpretation] |
| **Composite** | **X.XX** | **~Nth percentile** |

Status examples:
- context 2.20 → "Weakest — rarely references files"
- verifiability 2.33 → "Weak — almost never defines done conditions"
- specificity 4.10 → "Below average — improving with assertive language"
- intent 5.76 → "Good — clear action verbs"

### Step 4 — Session Outcomes

```
SESSION OUTCOMES
  Fully achieved:    N (XX%)   avg friction: X.X
  Mostly achieved:   N (XX%)   avg friction: X.X
  Partially/Not:     N (XX%)   avg friction: X.X

  Top friction: [type] ([N] sessions)
  Dimension that reduces it: [dim] ([strong/moderate/weak])
```

### Step 5 — Trend (if --compare or 2+ months)

```
TREND: [improving | stable | declining]
  Session score: X.X → X.X (+X.X)
  Biggest gain:  [dimension] +X.XX
  Biggest drop:  [dimension] -X.XX
```

### Step 6 — Top Improvement

```
#1 IMPROVEMENT: [dimension]
  Current: X.XX/10
  Impact: [strong/moderate/weak] correlation with reduced friction
  Fix: [specific actionable advice]
```

### Step 7 — Score Distribution (skip if --brief)

```
SCORE DISTRIBUTION
  1-2 ██░░░░░░░░ X%   bad
  2-3 ████░░░░░░ X%   weak
  3-4 ██████████ X%   average
  4-5 ██████░░░░ X%   decent
  5-7 ██░░░░░░░░ X%   good
  7+  ░░░░░░░░░░ X%   excellent
```

### Step 8 — Best & Worst (skip if --brief)

```
BEST PROMPT (X.XX/10):
  "[120 chars]"

WORST SCORED PROMPT (X.XX/10):
  "[120 chars]"
  Fix: [what dimension to improve + how]
```

## Key Rules

- Session Effectiveness is the HEADLINE — show first, biggest
- Prompt dimensions are SUPPORTING DETAIL
- Say "strong/moderate/weak" not r=+0.425
- Keep it concise — dashboard, not data dump
