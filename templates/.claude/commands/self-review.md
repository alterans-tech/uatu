---
description: Handle review comments on YOUR PR — read feedback, fix issues, reply to threads, resolve after your approval.
---

# Self Review

## Arguments

$ARGUMENTS

## Execution

Parse PR identifier from $ARGUMENTS. Accept: PR number, full URL, or "owner/repo#number".

### Step 1 — Fetch All Review Comments

```
mcp__github__get_pull_request_reviews(owner="<owner>", repo="<repo>", pull_number=<number>)
mcp__github__get_pull_request_comments(owner="<owner>", repo="<repo>", pull_number=<number>)
```

### Step 2 — Group and Present

Group comments by reviewer and thread. For each unresolved thread, show:

```
────────────────────────────────────
Thread 1/N — [reviewer name]
File: src/auth/handler.ts:42
────────────────────────────────────

[Reviewer comment]:
"This endpoint is missing rate limiting. We should add express-rate-limit
before this goes to production."

[The code in question]:
```typescript
router.post('/login', async (req, res) => {
  // ... login logic
```

────────────────────────────────────
Options:
  1. Fix it (apply the suggested change)
  2. Reply (explain why it's intentional or propose alternative)
  3. Skip (move to next thread)
────────────────────────────────────
```

### Step 3 — Handle Each Thread

Wait for the user's decision on each thread:

**If "fix it" or "1":**
1. Read the file and understand the context
2. Apply the fix
3. Show the diff to the user for approval
4. After approval: commit the fix, reply to the thread confirming the fix
5. Mark as resolved (if GitHub API supports it)

**If "reply" or "2":**
1. Ask the user what to say (or propose a response)
2. Post the reply to the thread:
```
mcp__github__add_issue_comment(owner="<owner>", repo="<repo>", issue_number=<number>, body="<reply>")
```

**If "skip" or "3":**
1. Move to next thread without action

### Step 4 — Summary

After all threads are handled, show:

```
════════════════════════════════════════
        SELF-REVIEW COMPLETE
════════════════════════════════════════

Threads handled: N/M
  Fixed: X
  Replied: Y
  Skipped: Z

Files modified: [list]
Commits: [count]

Remaining unresolved: [count]
```

If fixes were made, suggest running `/pre-flight-check` before requesting re-review.

### Rules

- **NEVER auto-resolve threads.** Always show the comment and wait for user decision.
- **NEVER auto-reply.** Always show proposed response and wait for user approval.
- Fix one thread at a time — don't batch fixes (user needs to validate each).
- If a fix touches multiple files, show the full diff before committing.
- Commit fixes individually with message: `fix(scope): address review feedback`
