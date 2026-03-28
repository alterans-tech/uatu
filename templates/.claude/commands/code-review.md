---
description: Two-stage code review — Stage 1 checks spec alignment, Stage 2 checks code quality. Stage 2 only runs if Stage 1 passes.
---

# Code Review

## Arguments

$ARGUMENTS

## Execution

You MUST run a two-stage review. Each stage spawns a dedicated reviewer agent. Stage 2 only runs if Stage 1 returns PASS.

---

### Stage 1 — Spec Alignment Review

Spawn the first reviewer agent:

```
Agent(subagent_type="reviewer", prompt="You are performing Stage 1 of a two-stage code review: SPEC ALIGNMENT.

Your job is to determine whether the implementation matches the stated requirements.

STEP 1 — Gather context:
- Run: git diff HEAD to see all uncommitted changes
- Check for spec sources (in priority order):
  1. .uatu/delivery/ — look for tasks.md, spec.md, plan.md
  2. A PR description or context passed as input: $ARGUMENTS
  3. Recent git log (git log --oneline -10) for commit messages describing intent

STEP 2 — Evaluate spec alignment:
For each requirement or acceptance criterion found, check whether the code covers it.

Look for:
- MISSING REQUIREMENTS: criteria in the spec with no corresponding code
- SCOPE DRIFT: code changes not mentioned in the spec or task list
- INCOMPLETE IMPLEMENTATION: partially implemented requirements
- WRONG BEHAVIOR: logic that contradicts the spec

STEP 3 — Report in this format:

## Stage 1 — Spec Alignment Review

**Spec source:** [which file or input was used, or 'no spec found']

| Status | Requirement | Finding |
|--------|-------------|---------|
| PASS | [requirement] | Correctly implemented |
| FAIL | [requirement] | [what is missing or wrong] |

**Stage 1 Verdict: PASS** (all requirements met) or **FAIL** (gaps found)

If FAIL: list every gap clearly. Do NOT proceed further.")
```

Wait for Stage 1 to complete.

**If Stage 1 verdict is FAIL:** Report the gaps to the user and STOP. Do not run Stage 2.

**If Stage 1 verdict is PASS:** Proceed to Stage 2.

---

### Stage 2 — Code Quality Review

```
Agent(subagent_type="reviewer", prompt="You are performing Stage 2 of a two-stage code review: CODE QUALITY.
Stage 1 (spec alignment) already passed.

Run git diff HEAD to see all uncommitted changes. Read .uatu/config/project.md for conventions.

Review across these dimensions:

CRITICAL (block merge):
- Hardcoded credentials, API keys, tokens, secrets
- SQL injection, XSS, command injection vulnerabilities
- Missing auth on protected endpoints
- Insecure dependencies

HIGH (must fix):
- Functions > 50 lines, files > 800 lines
- Nesting depth > 4 levels
- Missing error handling, empty catch blocks
- console.log/print debug statements left in
- Missing tests for new code paths

MEDIUM (should fix):
- Naming that doesn't describe intent
- TODO/FIXME without ticket reference
- Boolean parameters requiring caller knowledge

LOW (informational):
- N+1 query patterns
- Performance opportunities

Report format:

## Stage 2 — Code Quality Review

| Severity | File | Line(s) | Issue | Suggested Fix |
|----------|------|---------|-------|---------------|
| CRITICAL | path | 42 | desc | fix |

**Stage 2 Verdict: APPROVE** (no CRITICAL/HIGH) or **REQUEST CHANGES** (CRITICAL/HIGH found)")
```

---

### Final Report

Present combined results:

```
══════════════════════════════════════════
        CODE REVIEW — FINAL REPORT
══════════════════════════════════════════
 Stage 1 — Spec Alignment:   PASS / FAIL
 Stage 2 — Code Quality:     APPROVE / REQUEST CHANGES
══════════════════════════════════════════
```

Followed by the full findings from each stage.
