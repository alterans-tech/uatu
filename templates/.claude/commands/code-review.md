---
description: Comprehensive security and quality review — spawn a reviewer agent to analyze all uncommitted changes.
---

# Code Review

## Arguments

$ARGUMENTS

## Execution

You MUST spawn the reviewer agent NOW:

```
Agent(subagent_type="reviewer", prompt="Review all uncommitted changes (run git diff HEAD to see them).

Check for:

CRITICAL (block merge):
- Hardcoded credentials, API keys, tokens
- SQL injection, XSS, command injection
- Missing input validation on user-facing endpoints
- Insecure dependencies

HIGH (must fix):
- Functions > 50 lines, files > 800 lines
- Nesting depth > 4 levels
- Missing error handling
- console.log/print statements left in
- Missing tests for new code

MEDIUM (should fix):
- Mutation patterns (prefer immutable)
- Missing accessibility attributes
- TODO/FIXME without ticket reference

Report format:
- Severity: CRITICAL / HIGH / MEDIUM / LOW
- File path and line numbers
- Issue description
- Suggested fix

Final verdict: APPROVE (no CRITICAL/HIGH) or BLOCK (CRITICAL/HIGH found).

Read .uatu/config/project.md for project conventions.")
```

Report the review results. If CRITICAL or HIGH issues are found, list them clearly.
