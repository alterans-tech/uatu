# Uatu Hooks

Hooks are scripts that run at specific points during Claude Code execution. They allow you to inject custom behavior, enforce policies, and automate workflows.

---

## Overview

Claude Code supports 6 hook events:

| Event | Trigger | Use Cases |
|-------|---------|-----------|
| `SessionStart` | New Claude session begins | Load context, verify config |
| `UserPromptSubmit` | User sends message | Enforce policies, add reminders |
| `PreToolUse` | Before tool execution | Validate, add safeguards |
| `PostToolUse` | After tool execution | Format code, update tracking |
| `Stop` | Session ends normally | Save state, update Jira |
| `SubagentStop` | Subagent completes | Aggregate results, cleanup |

---

## Hook Configuration

Hooks are configured in `.claude/hooks.json` (or `mcp.json` under `hooks` key):

```json
{
  "hooks": [
    {
      "event": "SessionStart",
      "scripts": [
        {
          "path": ".uatu/hooks/session-start/load-project-context.sh",
          "enabled": true
        }
      ]
    }
  ]
}
```

---

## Uatu-Provided Hooks

### session-start/load-project-context.sh

Loads project configuration at session start.

**What it does:**
- Checks for `.uatu/config/project.md`
- Injects project context into Claude's initial prompt
- Non-blocking if config missing

**When to disable:** Never (required for Uatu)

---

### user-prompt-submit/enforce-sequential-thinking.sh

Reminds Claude to use Sequential Thinking for all tasks.

**What it does:**
- Adds reminder about Sequential Thinking requirement
- Injects reference to SEQUENTIAL-THINKING.md guide
- Non-intrusive context injection

**When to disable:** If you want to manage Sequential Thinking manually

---

### post-tool-use/format-code.sh

Automatically formats code after Write/Edit operations.

**What it does:**
- Detects file extension from tool result
- Runs appropriate formatter:
  - `.ts/.tsx/.js/.jsx` → prettier
  - `.py` → black
  - `.go` → gofmt
- Silent failure (doesn't break on missing formatters)
- Non-blocking

**When to disable:** If you have IDE auto-formatting or pre-commit hooks

**Requirements:**
```bash
# Install formatters as needed
npm install -g prettier
pip install black
# gofmt comes with Go
```

---

### stop/update-jira.sh

Updates Jira issue when session ends (placeholder).

**What it does:**
- Detects Jira key from conversation context
- (Future) Posts summary to Jira issue
- Currently a placeholder for future implementation

**When to disable:** If not using Jira integration

---

## Creating Custom Hooks

### Basic Structure

```bash
#!/usr/bin/env bash
# my-hook.sh

# Read stdin (contains hook context)
INPUT=$(cat)

# Parse input (JSON)
# Do your work here

# Output JSON response
cat <<EOF
{
  "additionalContext": "Custom context to inject",
  "error": null
}
EOF
```

### Hook Input Format

Each hook receives JSON on stdin:

```json
{
  "event": "SessionStart",
  "workingDirectory": "/path/to/project",
  "timestamp": "2026-01-30T12:34:56Z",
  "toolResult": { ... }  // Only for PostToolUse
}
```

### Hook Output Format

Hooks output JSON:

```json
{
  "additionalContext": "Text to inject into Claude's context",
  "error": "Error message if something failed (optional)"
}
```

**Important:**
- `additionalContext` is added to Claude's prompt
- `error` stops execution and shows error to user
- Empty `additionalContext` is valid (no-op)
- Missing/malformed JSON causes hook to be skipped

---

## Hook Best Practices

### 1. Make Scripts Executable

```bash
chmod +x .uatu/hooks/session-start/my-hook.sh
```

### 2. Silent Failures for Non-Critical Hooks

```bash
# Don't fail the entire session if formatter missing
if ! command -v prettier &> /dev/null; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi
```

### 3. Fast Execution

Hooks add latency. Keep them under 1 second:
- Avoid network calls
- Cache expensive operations
- Use timeout for external commands

### 4. Idempotent Operations

Hooks may run multiple times (retries, etc):
- Check before creating files
- Use atomic operations
- Don't append to logs blindly

### 5. Proper Error Handling

```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# But catch expected failures
if ! some_command; then
    # Handle gracefully
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi
```

---

## Troubleshooting

### Hook Not Running

1. **Check path in hooks.json:**
   ```bash
   cat .claude/hooks.json
   # Path should be relative to project root
   ```

2. **Verify executable:**
   ```bash
   ls -l .uatu/hooks/session-start/*.sh
   # Should show -rwxr-xr-x
   ```

3. **Test manually:**
   ```bash
   echo '{"event":"SessionStart","workingDirectory":"'$(pwd)'"}' | \
     .uatu/hooks/session-start/load-project-context.sh
   ```

4. **Check JSON output:**
   Hook must output valid JSON or be skipped

### Hook Slowing Down Claude

1. **Profile execution:**
   ```bash
   time .uatu/hooks/post-tool-use/format-code.sh < test-input.json
   ```

2. **Disable non-essential hooks:**
   Set `"enabled": false` in hooks.json

3. **Optimize slow operations:**
   - Cache results
   - Use faster tools
   - Move work to background processes

### Hook Causing Errors

1. **Check stderr:**
   Claude logs hook errors - check terminal output

2. **Validate JSON output:**
   ```bash
   .uatu/hooks/my-hook.sh < input.json | jq .
   ```

3. **Add debug logging:**
   ```bash
   echo "DEBUG: $(date)" >> /tmp/hook-debug.log
   ```

4. **Disable and test:**
   Set `"enabled": false`, confirm Claude works, then debug hook

---

## Advanced: Hook Chaining

Multiple hooks for same event run in order:

```json
{
  "event": "SessionStart",
  "scripts": [
    {"path": ".uatu/hooks/session-start/load-project-context.sh"},
    {"path": ".uatu/hooks/session-start/check-dependencies.sh"},
    {"path": ".uatu/hooks/session-start/verify-env.sh"}
  ]
}
```

Each hook's `additionalContext` is concatenated.

---

## Security Considerations

1. **Hooks run with your user permissions** - be careful with destructive operations
2. **Don't put secrets in hooks** - they may appear in logs/context
3. **Validate input** - don't trust hook input blindly
4. **Review third-party hooks** - only run hooks from trusted sources

---

## Examples

See individual hook scripts in subdirectories:
- `session-start/` - Context loading examples
- `user-prompt-submit/` - Policy enforcement examples
- `post-tool-use/` - Code formatting examples
- `stop/` - Cleanup and tracking examples

---

*For more on Uatu workflows, see `.uatu/guides/WORKFLOW.md`*
