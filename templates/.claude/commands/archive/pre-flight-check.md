---
description: Pre-merge gate — two-stage code review + verification + security scan. Reports everything. Does NOT merge.
---

# Pre-Flight Check

## Arguments

$ARGUMENTS

## Execution

Run all three checks and present a consolidated report. This is the quality gate before any merge.

### Stage 1 — Spec Alignment Review

Spawn a reviewer agent:

```
Agent(subagent_type="reviewer", model="sonnet", prompt="Stage 1: SPEC ALIGNMENT REVIEW.

Run git diff HEAD to see all uncommitted changes. Check for spec context:
1. .uatu/delivery/ — tasks.md, spec.md, plan.md
2. Recent git log for commit messages describing intent
3. PR description if provided: $ARGUMENTS

For each requirement or acceptance criterion found, check if the code covers it.

Report:
- MISSING REQUIREMENTS (spec says X, code doesn't have it)
- SCOPE DRIFT (code does Y, spec doesn't mention it)
- INCOMPLETE (partially implemented)

Verdict: PASS or FAIL with specific gaps.")
```

### Stage 2 — Code Quality Review (only if Stage 1 passes)

```
Agent(subagent_type="reviewer", model="sonnet", prompt="Stage 2: CODE QUALITY REVIEW.

Run git diff HEAD. Check:
CRITICAL: hardcoded secrets, SQL/XSS injection, missing auth
HIGH: functions >50 lines, empty catch blocks, missing tests for new code
MEDIUM: naming issues, TODO without ticket, boolean params
LOW: N+1 patterns, performance opportunities

Report with file:line references.
Verdict: APPROVE or REQUEST CHANGES.")
```

### Stage 3 — Verification

Run automated checks:
```bash
# Detect build system and run appropriate commands
# Build check
# Type check (tsc, mypy, etc.)
# Lint check
# Test suite
```

### Stage 4 — Security Scan (conditional)

Only if changes touch auth, payment, credential, session, token, or encryption files:

```
Agent(subagent_type="security-auditor", model="opus", prompt="Scan the uncommitted changes for:
1. Secrets in code (API keys, tokens, passwords)
2. Input validation gaps (injection vectors)
3. Auth/session issues
4. Dependency vulnerabilities
Report with severity and file:line references.")
```

### Final Report

```
══════════════════════════════════════════════
         PRE-FLIGHT CHECK — [branch name]
══════════════════════════════════════════════

 Stage 1 — Spec Alignment:    PASS / FAIL
 Stage 2 — Code Quality:      APPROVE / REQUEST CHANGES
 Stage 3 — Verification:      PASS / FAIL
 Stage 4 — Security:          PASS / SKIPPED / ISSUES FOUND

 Issues: [critical] critical, [high] high, [medium] medium, [low] low

══════════════════════════════════════════════
 Verdict: READY TO MERGE / NOT READY
══════════════════════════════════════════════
```

If `--fix` flag: auto-fix medium/low issues before reporting.

**CRITICAL: Do NOT merge. Report only. User merges manually.**
