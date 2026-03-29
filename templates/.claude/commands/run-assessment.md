---
description: Run prompt quality assessment. Shows score trajectory toward 99th percentile with dimension breakdown.
---

# Run Assessment

## Arguments

$ARGUMENTS

## Execution

Run the prompt quality assessment tool and present results with trajectory tracking.

### Step 1 — Run the Analysis

```bash
cd /Users/arnaldosilva/Workspace/projects/alterans/uatu/prompt-analysis
python3 analyze-prompts.py
```

If the script doesn't exist at that path, inform the user:
"The analyze-prompts.py script was not found. Ensure the uatu source repo is available at the expected path."

### Step 2 — Present Results

Show the assessment in this format:

```
PROMPT QUALITY ASSESSMENT
═════════════════════════

Current Score: X.XX/10 (Nth percentile)
Target Score:  9.00/10 (99th percentile)
Gap:           Y.YY points

DIMENSION BREAKDOWN
| Dimension        | Score | Target | Gap   | Status |
|------------------|-------|--------|-------|--------|
| Clarity          | X.XX  | 8.50   | Y.YY  | [bar]  |
| Context          | X.XX  | 8.50   | Y.YY  | [bar]  |
| Structure        | X.XX  | 8.50   | Y.YY  | [bar]  |
| Specificity      | X.XX  | 8.50   | Y.YY  | [bar]  |
| Delegation       | X.XX  | 8.50   | Y.YY  | [bar]  |
| Success Criteria | X.XX  | 9.00   | Y.YY  | [bar]  |
| Tool Awareness   | X.XX  | 8.50   | Y.YY  | [bar]  |

TOP 3 FOCUS AREAS:
1. [Weakest dimension] — [specific improvement action]
2. [2nd weakest] — [specific improvement action]
3. [3rd weakest] — [specific improvement action]

TRAJECTORY:
Previous: X.XX/10 → Current: X.XX/10 (±X.XX)
```

### Step 3 — Save Assessment History

Append results to `~/.uatu/assessments/history.jsonl`:
```json
{"date": "2026-03-28", "score": 4.02, "percentile": 55, "dimensions": {...}}
```

### Step 4 — Recommendations

Based on the weakest dimensions, recommend specific modules from the AI Engineering Course:
- Structure < 5.0 → "Practice Module 01: Use bullets/numbers for any prompt > 15 words"
- Context < 5.0 → "Practice Module 03: Name at least one file path in every code prompt"
- Success Criteria < 5.0 → "Practice Module 04: Add 'Done when:' to every implementation prompt"
