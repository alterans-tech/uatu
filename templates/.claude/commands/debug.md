---
description: Systematic 4-phase debugging — capture, isolate, fix, verify. Prevents patch-and-pray loops.
---

# Debug

## Arguments

$ARGUMENTS

## Execution

You MUST follow all 4 phases in order. Do NOT skip to Phase 3 without completing Phase 2.

---

### Phase 1 — CAPTURE

Gather evidence about the bug before forming any hypothesis.

1. Read the user's bug description: $ARGUMENTS
2. Identify the entry point — which request, action, or trigger causes the bug
3. Collect evidence:
   - Error messages and stack traces (from logs, console, or user report)
   - Expected behavior vs actual behavior
   - Steps to reproduce (if available)
4. List all files likely involved in the affected code path

**Output before proceeding:**
```
CAPTURE COMPLETE
- Error: [error message or symptom]
- Entry point: [file:line or endpoint]
- Expected: [what should happen]
- Actual: [what happens instead]
- Files involved: [list]
```

---

### Phase 2 — ISOLATE

Trace the bug to its root cause. Do NOT propose fixes yet.

1. Starting from the entry point, trace the execution path
2. Read each file in the call chain
3. Identify where behavior diverges from expectation
4. Determine the root cause category:
   - **Data**: Wrong input, corrupted state, missing data
   - **Logic**: Incorrect condition, off-by-one, wrong operator
   - **Timing**: Race condition, async ordering, timeout
   - **Config**: Wrong environment variable, missing dependency, version mismatch
5. Confirm root cause with evidence (not guessing)

**If you cannot identify root cause:** STOP and ask the user for more context. Do NOT guess.

**Output before proceeding:**
```
ROOT CAUSE IDENTIFIED
- Cause: [specific description]
- Location: [file:line]
- Type: [data/logic/timing/config]
- Evidence: [what confirms this is the root cause]
```

---

### Phase 3 — FIX

Apply a targeted fix addressing the root cause, not symptoms.

1. Fix ONLY the root cause identified in Phase 2
2. Do not refactor surrounding code — minimal change
3. Write a regression test that:
   - Reproduces the original bug scenario
   - Would have FAILED before the fix
   - PASSES after the fix
4. If the fix touches multiple files, use worktree isolation

**Output before proceeding:**
```
FIX APPLIED
- Change: [what was changed and why]
- Files modified: [list]
- Regression test: [test file:test name]
```

---

### Phase 4 — VERIFY

Confirm the fix works and nothing else broke.

1. Run the regression test — must pass
2. Run the full test suite for affected modules — must pass
3. Manually verify the original bug scenario is fixed (if applicable)
4. Check for side effects in related functionality
5. Create atomic commit:
   ```
   fix(scope): description of what was fixed
   ```

**Final output:**
```
VERIFIED
- Regression test: PASS
- Test suite: PASS (X tests, 0 failures)
- Original bug: FIXED
- Side effects: NONE DETECTED
- Commit: [hash]
```

---

## Critical Rules

- **Never skip phases.** Phase 3 requires Phase 2 output. Phase 4 requires Phase 3 output.
- **Diagnose before fixing.** If you find yourself writing "try this" — stop, go back to Phase 2.
- **One fix per bug.** If you discover additional issues during debugging, note them but don't fix them in this session.
- **Ask when stuck.** If Phase 2 cannot isolate the root cause after reading all involved files, ask the user for more context rather than guessing.
