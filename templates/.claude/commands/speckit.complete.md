---
description: Verify implementation completeness — tests pass, no hardcoded secrets, docs updated, changelog entry. Closes the speckit loop.
---

# Speckit Complete

## Arguments

$ARGUMENTS

## Execution

This is the final phase of the speckit workflow. Run ALL checks below and report pass/fail for each.

### 1. Test Suite

Run the project's test suite:
- `npm test`, `pytest`, `go test ./...`, or equivalent
- ALL tests must pass
- Report: total tests, passed, failed

### 2. Hardcoded Secrets Scan

Search for hardcoded credentials in all modified files:
```bash
git diff --name-only HEAD~5 | xargs grep -l -i -E "(password|secret|api_key|token|credential).*=.*['\"][^'\"]{8,}" 2>/dev/null
```
- Zero matches required
- Flag any suspicious patterns

### 3. File Length Check

Check all modified files:
```bash
git diff --name-only HEAD~5 | while read f; do [ -f "$f" ] && wc -l "$f"; done | sort -rn
```
- Warn on any file > 400 lines
- Flag any file > 800 lines as requiring split

### 4. Documentation Check

Verify documentation is current:
- README.md mentions new features (if user-facing)
- API endpoints are documented (if API changes)
- CHANGELOG.md has entry for this work (if it exists)

### 5. Spec Compliance

Read the original spec.md and tasks.md:
- Every acceptance criterion in spec.md is satisfied
- Every task in tasks.md is marked [X]
- No spec requirements were skipped

### 6. Report

```
COMPLETION REPORT
=================
Tests:          [PASS/FAIL] (N passed, M failed)
Secrets scan:   [PASS/FAIL] (N suspicious patterns)
File lengths:   [PASS/WARN/FAIL] (N files over threshold)
Documentation:  [PASS/WARN] (checked/missing)
Spec compliance: [PASS/FAIL] (N/M criteria met)

VERDICT: [READY TO SHIP / NEEDS WORK]
```

If NEEDS WORK, list the specific items to fix.
