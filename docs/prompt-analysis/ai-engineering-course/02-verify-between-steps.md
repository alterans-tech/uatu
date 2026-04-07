# Module 02: Stop Saying "Next" — Verify First

**Verification score: 3.85/10**
**Duration: 3 weeks (overlaps with Module 01)**
**Priority: Critical**

---

## The Problem

Your history.jsonl contains chains of 15 consecutive "next" prompts. In one documented PR
merge sequence, you stepped through multiple merges, deployments, and environment changes
with a single word between each action: "next."

This is not a bad habit in the casual sense. It is a structural risk. Each "next" is implicit
trust that the previous step completed correctly, without degradation, and without side effects.
Over a 15-step chain, that accumulated trust is almost always wrong somewhere.

The data shows your verification rate is rising (16% → 20%), which is a positive signal. This
module locks in that trend and makes verification systematic rather than occasional.

---

## The Data

- 15 consecutive "next" prompts documented in a single PR merge session
- Verification rate: 20% of prompts (up from 16%) — good trend, not yet a habit
- Correction rate: 5% (down from 12%) — you are catching fewer mistakes, which could mean
  Claude is making fewer, or it could mean you are catching them later
- You already have one habitual verification behavior: the verify-before-merge gate
  (see below) — this module extends that gate to every step, not just the final one

---

## The Model You Already Use

You have already internalized one verification pattern. Here is the actual prompt from your
sessions:

```
is this ready to merge? give a final check look at all angles, use uatu and a team of agents
to review everything, dont limit yourself by the number of agents specified in uatu, use as
many as you think it will be best, dont merge it i will do it manually
```

This prompt has:
- A specific trigger (before merge)
- A defined scope ("all angles")
- Tool delegation (uatu + agent team)
- An explicit boundary (don't merge — I will)

This is a 7.5/10 prompt. You wrote it instinctively. The goal of this module is to apply
the same logic to every step, not just the final one.

---

## The 15-"Next" Chain — What Actually Happened

In the PR merge session, the chain looked approximately like this:

```
Turn N:    [Claude describes merge plan for PR #1]
Turn N+1:  next
Turn N+2:  [Claude merges PR #1, describes PR #2]
Turn N+3:  next
Turn N+4:  [Claude merges PR #2, starts deployment]
Turn N+5:  next
...
Turn N+14: next
Turn N+15: next
```

At turn N+14, did PR #3 actually merge cleanly? Did the deployment start? Were there
conflicts? You do not know. You moved to the next action without verifying the previous one
completed as expected.

The risk is not that Claude lies. The risk is that Claude reports completion confidently
even when edge cases arise that it handles silently or suboptimally. "Next" gives it no
opportunity to surface those issues.

---

## The Fix: The 5-10 Word Verification

After every Claude action in a multi-step sequence, add one verification before the next
"next." It takes 5-10 words. It costs 30 seconds. It saves the 20-minute debugging session
that happens when you catch the problem at step 12 instead of step 2.

### The Verification Templates

**Status check (5 words):**
```
Did that complete without errors?
```

**Output check (8 words):**
```
Show me the output from that last step.
```

**Gate check (10 words):**
```
Confirm [specific thing] before we move to the next step.
```

**Diff check (7 words):**
```
What changed since the previous step?
```

**Risk check (9 words):**
```
Any issues I should know about before continuing?
```

---

## Before/After Examples

### Example 1: The PR Merge Chain

**Before:**
```
Turn 1: [Claude describes merge plan for 6 PRs]
Turn 2: next
Turn 3: next
Turn 4: next
Turn 5: next
Turn 6: next
Turn 7: next
```

**After:**
```
Turn 1: [Claude describes merge plan for 6 PRs]
Turn 2: Merge PR #1. Show me the merge output before continuing.
Turn 3: [Claude merges PR #1, shows output]
Turn 4: Output looks clean. Any merge conflicts on PR #2 before you proceed?
Turn 5: [Claude confirms no conflicts, merges PR #2]
Turn 6: Good. Did the CI pipeline start for PR #2?
Turn 7: [Claude confirms CI status]
Turn 8: Merge PR #3. Same pattern — show output first.
```

This is more turns. Each turn is 5-10 words. The total time is longer by 2 minutes. The
probability of catching a problem at step 2 instead of step 12 is dramatically higher.

---

### Example 2: Implementation Steps

**Before (typical pattern):**
```
Turn 1: Implement the user registration endpoint
Turn 2: next
Turn 3: next (Claude adds email verification)
Turn 4: next (Claude adds rate limiting)
Turn 5: next (Claude adds tests)
```

Turn 5 has no idea if the endpoint from turn 1 is working. If registration is broken, the
email verification, rate limiting, and tests are all built on a broken foundation.

**After:**
```
Turn 1: Implement the user registration endpoint in src/api/auth.ts.
         Done when: the endpoint returns 201 on valid input and 400 on invalid.

Turn 2: Run the unit tests for the registration endpoint. Show results.

Turn 3: [Claude shows test output — all passing]
         Tests are green. Now add email verification. Files: src/services/email.ts.
         Done when: a verification email is sent after successful registration.

Turn 4: [Claude implements email verification]
         Confirm the email service is called on registration. Show the relevant code path.

Turn 5: [Claude shows code path — confirmed]
         Good. Now add rate limiting: max 5 registration attempts per IP per hour.
```

Each step is verified before the next builds on it. Foundation errors surface at step 2,
not step 12.

---

### Example 3: Environment Configuration

**Before:**
```
Turn 1: Set up the staging environment
Turn 2: next
Turn 3: next
Turn 4: deploy to staging
```

**After:**
```
Turn 1: Set up the staging environment. What config files will you touch?

Turn 2: [Claude lists config files]
         Proceed. After each file change, confirm the change and why.

Turn 3: [Claude updates configs]
         Before deploying — does staging match the expected environment variables?
         Run a diff against production config (excluding secrets).

Turn 4: [Claude shows diff — one unexpected variable found]
         That variable difference needs review. Hold deployment until we resolve it.
```

The unexpected variable in turn 4 would have been a production incident if the "next" chain
had continued to deployment without the gate at turn 3.

---

## Extending the Verify-Before-Merge Gate

Your existing verify-before-merge prompt is a gate. Gates are insertion points where you
pause the "next" chain and apply scrutiny. The pattern works. The extension is:

**Current gates you use:**
- Before merge: explicit multi-agent review

**Gates to add:**
- Before deployment: "What changed since last deploy? Any risk I should know about?"
- After a long implementation session: "Run all tests. Show pass/fail before I review."
- Before moving to a new feature: "Is the current feature complete by the success criteria?"
- After a pivot: "Confirm what was removed and what replaced it."

You do not need to apply maximum scrutiny at every gate. A 5-word check is enough between
steps. Save the full agent-review gate for high-stakes actions (merge, deploy, data migration).

---

## The Verification Spectrum

Not all verifications require the same depth. Use the right level for the risk.

| Risk Level | When | Verification |
|------------|------|--------------|
| Low | Routine implementation step | "Did that complete?" (5 words) |
| Medium | Multi-file change | "Show me what changed" (5 words) |
| High | Before build/deploy | "Run tests, show results" (6 words) |
| Critical | Before merge to main | Full multi-agent review (your current pattern) |

The mistake in the "next" chain is applying Level 0 (no verification) to Level Medium and
High risk steps.

---

## The "I Can See the Output" Trap

Claude shows output in its response. It is tempting to read that output as verification.
The distinction:

- **Output is not verification.** Claude describing what it did is not the same as you
  confirming it worked.
- **Tool execution output is verification.** When Claude runs a test command and shows the
  actual results, that is verification.

The difference in a prompt:
```
# Not verification:
Claude: "I've updated the database migration."
You: "next"  ← you are trusting Claude's description

# Verification:
Claude: "I've updated the database migration."
You: "Run the migration against the staging database and show me the output."
Claude: [shows actual migration output]
You: "Migration succeeded. Proceed."  ← now you are moving on verified ground
```

---

## Practice Exercises — 3 Weeks

### Week 1: Count Your "Nexts"

Keep a tally. Every time you type "next" or "ok" or "continue" in response to a Claude
action, mark it. At the end of the week, count how many you had and how many you could have
replaced with a 5-word verification.

Target: identify at least 5 "next" prompts per day that should have been verifications.

### Week 2: Replace Every "Next" in Multi-Step Work

During any multi-step sequence (3 or more consecutive actions), do not type "next." Replace
it with one of the verification templates. Even the 5-word version counts.

Exception: if Claude's output is literally just confirming a trivial ack (e.g., "Understood,
proceeding with step 2"), a "next" is fine. The target is substantive steps.

### Week 3: Add Gates

Identify the 3 highest-risk actions in your current projects (merge, deploy, migration,
environment change). Write a gate prompt for each — what you will ask before that action
proceeds. Use them every time for the rest of the course.

---

## Success Signal

After 3 weeks:
- Your verification rate should be above 25% of prompts
- You should have zero "next"-only chains longer than 3 steps
- You should have 3-5 gate prompts memorized for your highest-risk actions

The compound effect: when combined with Module 01 structure, a structured prompt followed
by a 5-word verification is the baseline loop. That loop, applied consistently, is the
difference between a 4.02 composite and a 5.50.

---

## Quick Reference Card

```
Before "next" → ask one of:
  "Did that complete without errors?"
  "Show me the output from that last step."
  "Confirm [X] before we continue."
  "Any issues I should know about?"

Before high-risk action → gate prompt:
  "Before we [action]: [multi-point review request]"

The verify-before-merge pattern → extend to:
  verify-before-deploy
  verify-before-migration
  verify-before-new-feature-start
```
