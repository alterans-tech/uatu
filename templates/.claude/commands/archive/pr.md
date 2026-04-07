---
description: Pull request lifecycle — open, review, or handle feedback. One command for all PR workflows.
---

# PR

## Arguments

$ARGUMENTS

## Mode Detection

Parse $ARGUMENTS to detect the action:

- **No flags or `--open`** → **Open PR** (default — create a new PR)
- **`--review <number|url>`** → **Review PR** (review someone else's PR)
- **`--respond <number|url>`** → **Respond to Feedback** (handle review comments on your PR)
- **`--draft`** → modifier for open mode (create as draft)
- **`--jira <KEY>`** → modifier for open mode (override Jira key detection)

Examples:
```
/pr                              # open PR from current branch
/pr --draft                      # open as draft
/pr --jira ORI-234               # open with specific Jira key
/pr --review 342                 # review PR #342
/pr --respond 338                # handle review comments on PR #338
```

---

## Open PR (default)

Create a well-structured PR with proper title, body, test plan, and Jira link.

### Step 1 — Gather Context

```bash
git branch --show-current
git log --oneline main..HEAD
git diff --stat main..HEAD
git diff main..HEAD
```

Check `.uatu/config/project.md` for Jira key and conventions.
Check `.uatu/delivery/` for related spec, plan, or tasks.

### Step 2 — Extract Jira Key

Detect from (priority order):
1. `--jira <KEY>` flag
2. Branch name (e.g., `ORI-234/feat/trip-pdf` → `ORI-234`)
3. `.uatu/config/project.md` project key

### Step 3 — Build PR Title

Format: `{type}({scope}): {capability delivered} [{JIRA-KEY}]`

**Rules:**
- **type**: Infer from commits (feat, fix, refactor, docs, test, chore)
- **scope**: Domain/component changed — NOT project name
  - Good: `auth`, `payment`, `trip-format`, `ai-planner`
  - Bad: `orion`, `backend`, `services`
- **description**: Capability DELIVERED, not work done
  - Good: `JWT refresh rotation with sliding expiry`
  - Bad: `add auth`, `fix bug`, `full implementation`
- Under 70 characters (excluding Jira key), imperative mood

### Step 4 — Build PR Body

```markdown
## Summary

- [Main capability delivered]
- [Secondary change if any]
- [Design decision if non-obvious]

## Changes

### [Domain/Component 1]
- `path/file.ts` — [what changed]

### [Domain/Component 2]
- `path/file.ts` — [what changed]

## Test Plan

- [ ] [How to verify main feature works]
- [ ] [How to verify edge cases]
- [ ] [How to verify no regressions]
- [ ] All automated tests pass
- [ ] [Manual verification if needed]

## Notes

[Migration steps, breaking changes, follow-up work, screenshots if UI]

## Jira

[JIRA-KEY](https://alterans.atlassian.net/browse/JIRA-KEY)
```

### Step 5 — Generate Test Plan

Read the full diff and generate specific items:
- New endpoint → "Test with valid and invalid input"
- New UI component → "Verify renders on desktop and mobile"
- Bug fix → "Verify original bug no longer occurs"
- Refactor → "Verify existing behavior unchanged"
- Always: "All automated tests pass"

### Step 6 — Push and Create

```bash
git push -u origin $(git branch --show-current)
```

Create via `gh pr create` or `mcp__github__create_pull_request`. Use `--draft` flag if specified.

### Step 7 — Post-Creation

Show PR URL. If Jira key detected: add PR link as comment on Jira issue.

---

## Review PR (`--review <number>`)

Review someone else's PR. Read diff, run two-stage review, post inline comments.

### Step 1 — Fetch PR

```
mcp__github__get_pull_request(owner, repo, pull_number)
mcp__github__get_pull_request_files(owner, repo, pull_number)
```

Read: title, description, linked issues, changed files, full diff.

### Step 2 — Stage 1: Spec Alignment

- Does the code match the PR description and any linked issues?
- Scope drift? Missing requirements? Incomplete implementation?

### Step 3 — Stage 2: Code Quality

For each changed file:
- **CRITICAL**: hardcoded secrets, injection vectors, missing auth, breaking changes
- **HIGH**: missing error handling, missing tests, debug statements, long functions
- **MEDIUM**: naming issues, TODO without ticket, duplicated logic
- **LOW**: style inconsistencies, minor perf opportunities

### Step 4 — Post Inline Comments

Post comments on specific file:line via `mcp__github__create_pull_request_review`:
- Each finding = one inline comment with suggestion
- Summary comment with verdict
- APPROVE if no CRITICAL/HIGH, REQUEST_CHANGES otherwise

**Rules:**
- Be constructive — every criticism includes a suggestion
- Acknowledge what's good, not just problems
- Don't nitpick style without a style guide
- Flag large PRs (>500 lines) for splitting

---

## Respond to Feedback (`--respond <number>`)

Handle review comments on YOUR PR. Read feedback, fix, reply, resolve.

### Step 1 — Fetch Review Comments

```
mcp__github__get_pull_request_reviews(owner, repo, pull_number)
mcp__github__get_pull_request_comments(owner, repo, pull_number)
```

### Step 2 — Present Each Thread

Group by reviewer. For each unresolved thread:

```
────────────────────────────────
Thread 1/N — @reviewer-name
File: src/auth/handler.ts:42
────────────────────────────────

Comment: "Missing rate limiting on this endpoint"

Code:
  router.post('/login', async (req, res) => { ...

Options:
  1. Fix it
  2. Reply (explain why / propose alternative)
  3. Skip
────────────────────────────────
```

### Step 3 — Handle Each Thread

Wait for user decision:

**Fix (1):**
1. Read file, understand context
2. Apply fix
3. Show diff for user approval
4. After approval: commit `fix(scope): address review feedback`, reply confirming fix, resolve thread

**Reply (2):**
1. Ask user what to say (or propose response)
2. Post reply after user approves

**Skip (3):**
Move to next thread.

### Step 4 — Summary

```
════════════════════════════════════════
        REVIEW RESPONSE COMPLETE
════════════════════════════════════════

Threads handled: 5/5
  Fixed: 3  |  Replied: 1  |  Skipped: 1

Files modified: src/auth/handler.ts, src/auth/middleware.ts
Commits: 2

Remaining unresolved: 1
```

If fixes were made, suggest running `/pre-flight-check` before requesting re-review.

**Rules:**
- NEVER auto-resolve threads. Always show and wait for user decision.
- NEVER auto-reply. Always show proposed response first.
- Fix one thread at a time.
- Commit fixes individually: `fix(scope): address review feedback`
