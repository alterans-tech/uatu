---
name: commit
description: Smart git commit with conventional commit format, staging assistance, and message generation
allowed_tools:
  - Read
  - Bash
  - Grep
  - Glob
hooks:
  pre:
    - command: "git status --porcelain"
      description: "Check working directory status"
  post:
    - command: "git log -1 --oneline"
      description: "Show the commit just created"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This skill assists with creating well-formatted git commits following conventional commit standards.

### Commit Flow

1. **Analyze Repository State**:
   - Run `git status --porcelain` to see all changes
   - Run `git diff --staged` to see staged changes
   - Run `git diff` to see unstaged changes
   - Run `git log --oneline -5` to see recent commit style

2. **Parse User Intent**:
   - If user provided specific files: stage only those files
   - If user provided message: use it (validate format)
   - If user said "all" or no specific files: show all changes and ask for confirmation
   - If no message provided: generate one based on changes

3. **Stage Files**:
   - For specified files: `git add <file1> <file2> ...`
   - For all changes (after confirmation): `git add -A`
   - Never stage sensitive files (.env, credentials, secrets, tokens, keys)
   - Warn if detecting large files (>1MB) or binary files

4. **Generate Commit Message**:
   - Follow conventional commit format: `<type>(<scope>): <subject>`
   - Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build
   - Scope is optional but recommended
   - Subject: imperative mood, no period, lowercase start
   - Body (optional): explain WHY, not WHAT
   - Footer (optional): breaking changes, issue references

   **Examples**:
   - `feat(auth): add OAuth2 login support`
   - `fix(api): handle null response from payment gateway`
   - `docs(readme): update installation instructions`
   - `refactor(user-service): extract validation logic`

5. **Validate Commit Message**:
   - Check type is valid
   - Check subject line is 50 chars or less
   - Check subject doesn't end with period
   - Check body lines are wrapped at 72 chars (if present)
   - Warn about unclear or generic messages like "fix bug" or "update code"

6. **Create Commit**:
   - Use heredoc for multi-line messages
   - Always include co-author line: `Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>`
   - Format:
   ```bash
   git commit -m "$(cat <<'EOF'
   <type>(<scope>): <subject>

   <body>

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   EOF
   )"
   ```

7. **Report Results**:
   - Show commit hash and message
   - Show `git log -1 --stat` to confirm changes
   - Remind user to push if needed

## Usage Patterns

### Explicit Files and Message
```
/commit src/auth.py src/models/user.py -m "feat(auth): add user authentication"
```

### Auto-detect Changes and Generate Message
```
/commit
```
(will analyze changes and suggest message)

### All Changes with Custom Message
```
/commit --all -m "refactor: simplify error handling"
```

### Interactive Staging
```
/commit --interactive
```
(will show all changes and ask which to stage)

## Safety Rules

1. **Never commit**:
   - .env files
   - credential files (credentials.json, secrets.yaml, etc.)
   - private keys (.pem, .key, id_rsa, etc.)
   - API tokens or passwords in any file
   - Large binary files without confirmation

2. **Always warn about**:
   - Commits with more than 10 files
   - Commits with files larger than 1MB
   - Generic commit messages
   - Commits to main/master branch directly
   - Uncommitted changes left after partial staging

3. **Always validate**:
   - Conventional commit format
   - No empty commit messages
   - Subject line length
   - No implementation details in feat commits (should be in body)

## Message Generation Guidelines

When generating commit messages automatically:

1. **Analyze the diff**: Look at what changed, not just file names
2. **Determine type**:
   - New files + new functionality = feat
   - Fixing bugs or errors = fix
   - Changing existing code structure = refactor
   - Documentation only = docs
   - Tests only = test
3. **Identify scope**: Use component/module name if clear
4. **Write subject**: Focus on user impact, not implementation
5. **Add body if needed**: Explain WHY for non-obvious changes

**Good auto-generated messages**:
- `feat(auth): add password reset flow`
- `fix(payment): prevent duplicate charge on retry`
- `refactor(api): extract validation middleware`

**Bad auto-generated messages**:
- `fix: bug fix` (too generic)
- `feat: add new code` (no context)
- `update: changes` (meaningless)

## Example Session

```
User: /commit