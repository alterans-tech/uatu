---
name: review-pr
description: Comprehensive pull request review with code analysis, security checks, and actionable feedback
allowed_tools:
  - Read
  - Bash
  - Grep
  - Glob
  - LSP
hooks:
  pre:
    - command: "gh pr view --json number,title,author,state,headRefName"
      description: "Get PR metadata"
  post:
    - command: "gh pr checks"
      description: "Show CI/CD status"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This skill assists with conducting thorough pull request reviews using the GitHub CLI and code analysis tools.

### Review Flow

1. **Identify Pull Request**:
   - If user provided PR number: use it directly
   - If user provided URL: extract PR number
   - If no PR specified: list open PRs and ask user to select
   - Commands:
     - `gh pr list` - List open PRs
     - `gh pr view <number>` - Get PR details

2. **Fetch PR Information**:
   - Get PR metadata: `gh pr view <number> --json title,body,author,headRefName,baseRefName,mergeable,reviews,files`
   - Get PR diff: `gh pr diff <number>`
   - Get changed files: `gh pr view <number> --json files --jq '.files[].path'`
   - Check CI status: `gh pr checks <number>`

3. **Analyze Changes**:
   - Read all changed files using Read tool
   - Identify change categories:
     - New features (new files, new functions)
     - Bug fixes (changed logic, error handling)
     - Refactoring (structural changes)
     - Documentation (comments, README, docs)
     - Tests (new test files, test changes)
   - Note file types: backend, frontend, config, infrastructure
   - Check for large files or binary changes

4. **Code Quality Review**:
   - **Readability**: Clear naming, appropriate comments, consistent style
   - **Maintainability**: SOLID principles, DRY, separation of concerns
   - **Complexity**: Cyclomatic complexity, nesting depth, function length
   - **Error Handling**: Try-catch blocks, validation, edge cases
   - **Testing**: Test coverage, test quality, edge case coverage
   - **Documentation**: Inline comments for complex logic, updated README if needed

5. **Security Analysis**:
   - Check for common vulnerabilities:
     - SQL injection risks (unsanitized inputs in queries)
     - XSS risks (unescaped user content)
     - Authentication/authorization issues
     - Sensitive data exposure (hardcoded secrets, logging PII)
     - Insecure dependencies
   - Verify input validation
   - Check for proper error handling (no stack traces to users)
   - Review permission checks

6. **Performance Considerations**:
   - Database queries (N+1 queries, missing indexes)
   - Algorithm efficiency (O(n²) loops, unnecessary iterations)
   - Resource usage (memory leaks, file handles, connections)
   - Caching opportunities
   - API call efficiency

7. **Architecture & Design**:
   - Adherence to project patterns
   - Separation of concerns
   - Dependency injection
   - Interface usage
   - Module boundaries

8. **Generate Review Comments**:
   - Categorize findings:
     - **Critical**: Security issues, breaking changes, data loss risks
     - **Major**: Bugs, performance issues, maintainability problems
     - **Minor**: Style issues, optimization opportunities, suggestions
     - **Praise**: Highlight good practices, clever solutions
   - Format comments with:
     - File path and line number
     - Issue description
     - Suggested fix (if applicable)
     - Code example (if helpful)

9. **Post Review**:
   - Summarize findings by severity
   - Overall recommendation: APPROVE, REQUEST CHANGES, COMMENT
   - If posting review:
     ```bash
     gh pr review <number> --approve -b "Review summary"
     # or
     gh pr review <number> --request-changes -b "Issues found"
     # or
     gh pr review <number> --comment -b "General feedback"
     ```

10. **Report Results**:
    - Show summary of findings
    - List critical and major issues
    - Provide actionable next steps
    - If review posted, confirm with review URL

## Usage Patterns

### Review by PR Number
```
/review-pr 123
```

### Review Current Branch's PR
```
/review-pr
```
(will detect PR for current branch)

### Review with Specific Focus
```
/review-pr 123 --focus security
```
(emphasize security analysis)

### List PRs and Review
```
/review-pr --list
```
(show open PRs, ask which to review)

## Review Checklist

For each PR, verify:

### Functionality
- [ ] Code does what PR description claims
- [ ] Edge cases handled
- [ ] Error conditions handled gracefully
- [ ] No obvious bugs

### Code Quality
- [ ] Clear, descriptive naming
- [ ] Functions have single responsibility
- [ ] No code duplication
- [ ] Appropriate abstraction level
- [ ] Comments explain WHY, not WHAT

### Testing
- [ ] Tests included for new functionality
- [ ] Tests cover edge cases
- [ ] Existing tests still pass
- [ ] Test names are descriptive

### Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation present
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Proper authentication/authorization

### Performance
- [ ] No obvious performance issues
- [ ] Database queries optimized
- [ ] No memory leaks
- [ ] Efficient algorithms used

### Documentation
- [ ] PR description is clear
- [ ] Complex logic has comments
- [ ] README updated if needed
- [ ] API documentation updated if needed

## Safety Rules

1. **Never approve without reading code**:
   - Must read at least all changed files
   - Understand what each change does
   - Verify no obvious issues

2. **Always flag**:
   - Hardcoded secrets, API keys, passwords
   - Missing input validation
   - SQL queries with unsanitized input
   - Authentication/authorization bypasses
   - Error messages exposing sensitive info

3. **Request changes for**:
   - Security vulnerabilities
   - Breaking changes without migration plan
   - Missing tests for critical functionality
   - Code that doesn't match PR description

4. **Comment (not block) for**:
   - Style suggestions
   - Optimization opportunities
   - Alternative approaches
   - Nitpicks and preferences

## Review Comment Templates

### Critical Issue
```
🚨 **Critical**: [Brief description]

**Issue**: [Detailed explanation]

**Risk**: [Security/data loss/breaking change]

**Suggested fix**:
```[language]
[code example]
```
```

### Major Issue
```
⚠️ **Major**: [Brief description]

**Problem**: [What's wrong]

**Impact**: [How it affects users/system]

**Suggestion**:
[How to fix]
```

### Minor Suggestion
```
💡 **Suggestion**: [Brief description]

**Current**:
```[language]
[current code]
```

**Alternative**:
```[language]
[suggested code]
```

**Why**: [Benefit of change]
```

### Praise
```
✨ **Nice work**: [What was done well]

[Why it's good]
```

## Example Session

```
User: /review-pr 123

Claude:
Fetching PR #123 details...

PR: feat(auth): Add OAuth2 login support
Author: @developer
Files changed: 8 files (+320 -45)
Status: Checks passing

Reading changed files...
- src/auth/oauth.py (new)
- src/auth/providers/google.py (new)
- src/auth/providers/github.py (new)
- src/models/user.py (modified)
- tests/test_oauth.py (new)
- requirements.txt (modified)
- README.md (modified)
- config/settings.py (modified)

Analyzing changes...

FINDINGS SUMMARY:
✅ Strengths:
- Good test coverage for OAuth flow
- Clear separation of provider implementations
- Proper error handling in most paths

⚠️ Major Issues (2):
1. src/auth/oauth.py:45 - Missing CSRF protection on OAuth callback
2. config/settings.py:12 - OAuth secrets in version control

💡 Minor Suggestions (3):
1. src/auth/oauth.py:78 - Consider adding rate limiting
2. src/models/user.py:23 - DB migration script needed
3. tests/test_oauth.py:15 - Add edge case for expired tokens

REVIEW POSTED: Requesting changes due to security issues
View review: https://github.com/org/repo/pull/123#pullrequestreview-123456789

Next steps for author:
1. Move OAuth secrets to environment variables
2. Implement CSRF token validation
3. Address minor suggestions if time permits
```

## Notes

- **Focus on actionable feedback**: Don't just identify problems, suggest solutions
- **Balance criticism with praise**: Highlight good practices to encourage them
- **Prioritize issues**: Not everything needs to block the PR
- **Be specific**: Quote code, provide line numbers, show examples
- **Consider context**: Review holistically, not just line-by-line
- **Respect the author**: Be constructive, not condescending