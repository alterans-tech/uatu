# Module 04: Success Criteria — You Almost Never Say When It's Done (3.38/10)

**Success Criteria score: 3.38/10 — 2nd weakest dimension**
**Duration: 2 weeks**
**Priority: High**

---

## The Problem

Your implementation specs have success criteria. SC-001 through SC-011 appear in your formal
planning documents with measurable conditions. But those criteria almost never appear in the
prompts you actually send to Claude.

The result: Claude decides when it is done. Sometimes it finishes early (a stub that passes
type-checking but does not work end-to-end). Sometimes it does more than asked (refactoring
scope creep). Almost always, Claude stops at a different point than you expected, requiring
a follow-up prompt to cover what was missed.

This is not Claude's failure. You did not tell it when to stop.

---

## The Data

- Success criteria score: 3.38/10 — second weakest after structure
- Formal specs contain SC-001 to SC-011 with measurable conditions
- Prompts contain near-zero explicit completion criteria
- The gap between your planning quality and your prompting quality is largest here

Your planning documents are good. Your prompts do not reflect them. This module closes that gap.

---

## Why "Done When" Changes Everything

A prompt without a done-when condition is a request without a boundary. Claude fills in the
boundary using its judgment. That judgment is usually based on what is reasonable for a
generic codebase — not your specific project, your specific standards, your specific test
coverage expectations.

**Without done-when:**
Claude interprets "implement the payment retry" as: implement it functionally, in the
obvious location, with what seems like appropriate error handling.

**With done-when:**
Claude interprets "implement the payment retry" as: implement it in processor.go, make sure
the unit tests cover retry-on-network-error and give-up-after-3-attempts, and do not stop
until those tests are green.

The second instruction produces the output you actually want. The first produces output you
have to inspect, correct, and augment.

---

## The Done-When Formula

Every implementation prompt ends with one of these:

```
Done when: [testable condition]
```

```
Done when:
1. [testable condition]
2. [testable condition]
```

"Testable condition" means: you can verify it is true without Claude's help. Not "the code
looks good" but "the tests pass." Not "the feature works" but "I can register with a valid
email and receive a verification email within 60 seconds."

---

## Good vs. Bad Done-When Conditions

| Vague (avoid) | Testable (use) |
|---------------|----------------|
| The feature is implemented | `npm test` passes for auth module |
| The bug is fixed | Registration succeeds with email=test@test.com |
| The API is updated | GET /api/users?page=2 returns 200 with data array |
| The UI looks right | Pagination renders 10 items, next button activates |
| The migration is done | `db.migrations` table shows the new migration as applied |
| Code is clean | No ESLint errors in src/api/auth.ts |
| Performance is better | P95 response time < 200ms on /api/users endpoint |

---

## Before/After Examples

---

### Example 1: Feature Implementation

**Before:**
```
implement user registration with email verification
```

Claude stops when the code compiles. You expected tests. Claude assumed you wanted the
happy path. You expected error cases too. Claude did not configure the email service.
You thought it was obvious.

**After:**
```
Implement user registration with email verification.

Files:
- src/api/auth/register.ts — endpoint handler
- src/services/email.ts — email sending service
- src/api/auth/__tests__/register.test.ts — unit tests

Done when:
1. POST /api/auth/register returns 201 with userId on valid input
2. POST /api/auth/register returns 400 with validation errors on invalid input
3. A verification email is sent to the provided email address after successful registration
4. Unit tests pass for: happy path, duplicate email, invalid email format, missing fields
```

**Score delta: +4.0 points**

---

### Example 2: Bug Fix

**Before:**
```
fix the auth token expiring during file uploads
```

Claude adds a token refresh call. Does it work for chunked uploads? Does it handle the
race condition when multiple chunks arrive simultaneously? Does it have a test? Unknown.

**After:**
```
Fix auth token expiration during large file uploads.

Files:
- src/services/upload-service.ts
- src/services/auth-service.ts (for token refresh logic)

Root cause: access token expires (15 min TTL) during uploads > 5 minutes.

Fix requirements:
1. Check token expiry before each chunk upload
2. Refresh token if < 2 minutes remaining
3. Handle the case where refresh itself fails (propagate error, do not retry infinitely)

Done when:
1. A simulated 10-minute upload completes without auth errors
2. The test in upload-service.test.ts covers the token-refresh-mid-upload path
3. Token refresh failures surface as user-visible errors, not silent drops
```

**Score delta: +3.5 points**

---

### Example 3: Refactoring

**Before:**
```
refactor the payment processing to be cleaner
```

"Cleaner" is not a testable condition. Claude will interpret this through its own aesthetic
lens. You will get code that Claude finds clean, which may or may not match your standards.

**After:**
```
Refactor the payment processing module for maintainability.

File: services/payment/processor.go

Specific changes:
1. Extract the retry logic into a separate retryWithBackoff() function
2. Extract the error classification into a separate isRetryableError() function
3. Reduce processPayment() to under 40 lines

Constraints:
- Do NOT change the function signatures (other code depends on them)
- Do NOT change behavior — only internal organization

Done when:
1. All existing tests still pass without modification
2. processPayment() is under 40 lines
3. retryWithBackoff() and isRetryableError() exist as separate functions
```

**Score delta: +3.5 points** — the "do not change behavior" constraint prevents scope
creep, which is common in refactoring requests.

---

### Example 4: API Endpoint

**Before:**
```
add pagination to the users endpoint
```

Claude adds pagination. Does it use the same pagination contract as your other endpoints?
Does the frontend expect cursor-based or offset-based? Are there tests? Is there documentation
of the new query params? All unknown.

**After:**
```
Add pagination to GET /api/users.

File: src/api/users/users.handler.ts

Pagination contract (match existing /api/transactions endpoint):
- Query params: page (1-indexed), pageSize (default 20, max 100)
- Response: { data: User[], total: number, page: number, pageSize: number }

Done when:
1. GET /api/users?page=1&pageSize=10 returns first 10 users with correct total
2. GET /api/users?page=99&pageSize=10 returns empty data array (not 404)
3. GET /api/users?pageSize=200 returns 400 with "pageSize max is 100"
4. Unit tests cover all three above cases
5. Response shape matches /api/transactions response shape exactly
```

**Score delta: +4.5 points** — "match /api/transactions" is a single constraint that
eliminates an entire design decision and prevents inconsistency.

---

### Example 5: Infrastructure / Configuration

**Before:**
```
set up the staging environment
```

What does "set up" mean? What is the expected end state? How do you know when it is done?
This is the vaguest possible instruction for a high-stakes action.

**After:**
```
Set up the staging environment.

Files:
- infrastructure/terraform/environments/staging/main.tf
- .env.staging (create from .env.example)
- infrastructure/scripts/setup-staging.sh

Expected end state:
1. Staging VPC is provisioned (terraform output shows VPC ID)
2. Staging database is running (connection string in .env.staging)
3. Staging API is deployed and returns 200 on GET /health
4. Environment variables match production format (no dev-only keys)

Done when:
1. `terraform apply` exits with 0 in the staging workspace
2. `curl https://staging-api.example.com/health` returns {"status":"ok"}
3. No secrets appear in git — all values from environment variables
```

**Score delta: +5.0 points** — this is the difference between a "set it up" request and
a complete infrastructure specification.

---

## Connecting to Your Existing Specs

Your formal specs already contain success criteria (SC-001 to SC-011 format). The habit
you need is copying or paraphrasing those criteria into your prompts.

If you have a spec with:
```
SC-003: User can complete registration in under 60 seconds on a standard connection
SC-004: Registration rejects duplicate emails with a 409 response
SC-005: Registration sends a verification email within 30 seconds
```

Your prompt should end with:
```
Done when:
- Registration rejects duplicates with 409 (SC-004)
- Verification email sends within 30 seconds (SC-005)
- Full flow completes in < 60 seconds on a standard connection (SC-003)
```

The SC reference is optional but useful — it links the prompt back to the spec and makes
your session history auditable.

---

## The "I'll Know It When I See It" Trap

Experienced developers often work from intuition about when something is done. That intuition
is real and valuable. It does not translate to Claude.

When you feel "I'll know it when I see it," translate that intuition into words:
- What will you look at to decide?
- What state will the system be in?
- What tests will pass?
- What output will you observe?

That translation is the "Done when:" clause.

---

## Practice Exercises — 2 Weeks

### Week 1: Add Done-When to Every Implementation Prompt

For any prompt that asks Claude to build, change, or fix something, add at least one
"Done when:" clause. Start with a single condition if multi-condition feels like too much.

One condition per prompt is 100% better than zero conditions.

Track: how many of your implementation prompts this week had a done-when clause?
Target: 80% of implementation prompts.

### Week 2: Make Conditions Testable

Review your week 1 done-when clauses. Are they vague ("the feature works") or testable
("POST /api/auth/register returns 201")?

Rewrite any vague conditions into testable ones. If you cannot make it testable, that is a
signal the requirement itself is underspecified — resolve the ambiguity at the spec level,
then write the condition.

---

## Success Signal

After 2 weeks:
- Success criteria in > 30% of implementation prompts (up from near zero)
- Fewer follow-up prompts asking "can you also add tests?" or "what about error cases?"
- Claude stops at the right point more consistently

The downstream effect: with done-when conditions in place, your verification prompts
(Module 02) become trivial. Instead of "did that complete without errors?" you say "run
the tests in the done-when condition." The two modules amplify each other.

---

## Quick Reference Card

```
Implementation → "Done when: [tests pass / endpoint returns / UI shows]"
Bug fix → "Done when: [the specific failure no longer occurs]"
Refactor → "Done when: [existing tests pass, specific metric met]"
Infra → "Done when: [system returns healthy, terraform exits 0]"

Testable: "POST /api/auth/register returns 201"
Not testable: "the registration works"

One condition is enough to start. Three is ideal.
```
