# Prompt Analysis

Prompt quality scoring, outcome correlation, and improvement tracking.

## Contents

| File | Purpose | Status |
|------|---------|--------|
| `analyze-prompts.py` | 5-dimension prompt scorer with outcome correlation | **Current (v3)** |
| `run-assessment.md` | Copy-paste prompt to run a full assessment | Updated for v3 |
| `prompt-engineering-assessment.md` | Historical assessment (v2 scores, 2026-03-27) | Reference |
| `ai-engineering-course/` | 13-module personalized study course | Reference (uses v2 dimensions) |

## Scoring Model (v3)

5 research-backed dimensions, no signal overlap, base score = 1:

| Dimension | Weight | What It Measures |
|-----------|--------|------------------|
| Intent | 20% | Clear action verb + identifiable target |
| Context | 25% | File refs, code blocks, function names, error messages |
| Specificity | 20% | Assertive language, concrete values, absence of vague words |
| Scope | 15% | Constraints, decomposition for multi-concern prompts |
| Verifiability | 20% | Expected output, done-conditions, verification commands |

Exempt categories (not scored): execution confirmations, slash commands, follow-ups, continuations, corrections, acknowledgments.

Outcome correlation joins prompt scores with `/insights` session data (session-meta + facets).

## Running the Analyzer

```bash
cd uatu/
python3 prompt-analysis/analyze-prompts.py
```

Output includes:
- Composite score (mean/median/stdev)
- Per-dimension breakdown with weights
- Monthly trend
- Project comparison
- Top/bottom prompts
- **Outcome correlation** (prompt quality → session success, friction, tool errors)

## Key Findings (2026-03-31)

- **Intent** is the #1 predictor of friction reduction (r=+0.425)
- **Scope** (constraints) is the strongest predictor of outcome success (r=+0.383)
- Sessions with intent > 6 had **2.1 avg friction** vs **4.4 when ≤ 6**

## Assessment History

| Date | Model | Score | Key Change |
|------|-------|-------|-----------|
| 2026-03-27 | v2 (7-dim) | 4.02/10 | Baseline |
| 2026-03-30 | v3 (5-dim) | 3.52/10 | New model, wider range (1.65-9.80), exempt categories |
| 2026-03-31 | v3 + outcomes | 3.52/10 | Added outcome correlation from /insights data |
