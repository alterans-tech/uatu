---
description: Review someone else's PR — read the diff, run two-stage review, post inline comments on GitHub. Approve or request changes.
---

# Review PR

## Arguments

$ARGUMENTS

## Execution

Parse PR identifier from $ARGUMENTS. Accept: PR number, full URL, or "owner/repo#number".

### Step 1 — Fetch PR Context

```
mcp__github__get_pull_request(owner="<owner>", repo="<repo>", pull_number=<number>)
mcp__github__get_pull_request_files(owner="<owner>", repo="<repo>", pull_number=<number>)
```

Read: PR title, description, linked issues, changed files, full diff.

### Step 2 — Spec Alignment Review

Check if the implementation matches the PR description and any linked issues:
- Does every claimed change exist in the diff?
- Is there scope drift (changes not mentioned in the description)?
- Are there missing changes (description promises X but diff doesn't include it)?

### Step 3 — Code Quality Review

For each changed file, review:

**CRITICAL (block merge):**
- Hardcoded credentials, API keys, tokens
- SQL injection, XSS, command injection vectors
- Missing auth on new endpoints
- Breaking changes without migration

**HIGH (must fix):**
- Missing error handling on new code paths
- Missing tests for new functionality
- Console.log/print left in production code
- Functions exceeding 50 lines

**MEDIUM (should fix):**
- Naming that doesn't describe intent
- TODO/FIXME without ticket reference
- Duplicated logic that should be extracted

**LOW (suggestion):**
- Style inconsistencies
- Minor performance opportunities

### Step 4 — Post Inline Comments

For each finding, post an inline comment on the specific file and line:

```
mcp__github__create_pull_request_review(
  owner="<owner>",
  repo="<repo>",
  pull_number=<number>,
  event="COMMENT" or "REQUEST_CHANGES" or "APPROVE",
  body="## Review Summary\n\n[summary]",
  comments=[
    {"path": "src/auth.ts", "line": 42, "body": "CRITICAL: API key hardcoded..."},
    {"path": "src/handler.ts", "line": 17, "body": "MEDIUM: Consider extracting..."}
  ]
)
```

### Step 5 — Submit Review

- If any CRITICAL or HIGH findings → submit as REQUEST_CHANGES
- If only MEDIUM/LOW or no findings → submit as APPROVE

**Review summary format:**
```
## Review Summary

**Verdict:** APPROVE / REQUEST CHANGES

### Findings
| Severity | File | Line | Issue |
|----------|------|------|-------|
| ... | ... | ... | ... |

### What's Good
- [positive observations about the PR]
```

### Rules

- Be constructive — every criticism includes a suggestion
- Acknowledge good patterns, not just problems
- Don't nitpick style if the project has no style guide
- Focus on behavior and correctness over personal preference
- If the PR is large (>500 lines), note that it should be split in the summary
