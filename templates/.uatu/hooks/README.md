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

Hooks are configured in `.claude/settings.json` using an **event-keyed object**:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "test -f .uatu/hooks/session-start/load-project-context.sh && .uatu/hooks/session-start/load-project-context.sh || exit 0"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "test -f .uatu/hooks/pre-tool-use/prevent-sensitive-writes.sh && .uatu/hooks/pre-tool-use/prevent-sensitive-writes.sh || exit 0"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "test -f .uatu/hooks/stop/session-checkpoint.sh && .uatu/hooks/stop/session-checkpoint.sh || exit 0"
          }
        ]
      }
    ]
  }
}
```

> **Note:** Use the conditional `test -f ... && ... || exit 0` pattern to prevent failures in non-uatu directories.

---

## Hook Input Format

Each hook receives JSON on stdin. Fields use **snake_case**:

```json
{
  "hook_event_name": "SessionStart",
  "working_directory": "/path/to/project",
  "timestamp": "2026-01-30T12:34:56Z",
  "tool_name": "Write",
  "tool_input": { ... }
}
```

**Important:** Fields are snake_case — `working_directory`, NOT `workingDirectory`.

---

## Hook Output Format

Hooks output JSON to stdout (stdout must be ONLY valid JSON):

```json
{
  "additionalContext": "Text to inject into Claude's context",
  "error": null
}
```

- Use `>&2` for informational/debug output — `echo "..." >&2`
- `additionalContext` is added to Claude's prompt
- Non-null `error` stops execution and shows message to user
- Empty `additionalContext` is valid (no-op)

---

## Active Hooks (17)

### session-start/ (3)

| Hook | Purpose |
|------|---------|
| `load-project-context.sh` | Loads `.uatu/config/project.md` into context |
| `session-restore.sh` | Restores last session checkpoint |
| `branch-guard.sh` | Warns if session starts on main/master |

### user-prompt-submit/ (2)

| Hook | Purpose |
|------|---------|
| `prompt-quality-advisor.sh` | Scores prompts on 5 dimensions, suggests improvements |
| `scope-detection.sh` | Detects large scope → suggests `/orch`; detects risky keywords (auth/payment/migration) → suggests plan mode |

### pre-tool-use/ (2)

| Hook | Purpose |
|------|---------|
| `prevent-sensitive-writes.sh` | Blocks writes to sensitive files (.env, credentials, secrets) |
| `protect-config-files.sh` | Blocks modifications to config files |

### post-tool-use/ (5)

| Hook | Purpose |
|------|---------|
| `format-code.sh` | Auto-formats after Write/Edit (new files) — prettier/black/gofmt |
| `self-review-checklist.sh` | Scans for TODOs, placeholders after code writes |
| `smart-agent-suggestion.sh` | Suggests relevant agents by file pattern |
| `warn-file-length.sh` | Warns if file exceeds 400 lines |
| `event-log.sh` | Logs tool usage (strict profile only) |

### stop/ (5)

| Hook | Purpose |
|------|---------|
| `session-checkpoint.sh` | Saves session summary to JSONL |
| `cost-tracking.sh` | Logs session for cost review |
| `missing-test-warning.sh` | Warns about modified files without tests |
| `update-jira.sh` | Updates Jira status at session end |
| `desktop-notification.sh` | macOS notification (strict profile only) |

---

## Creating Custom Hooks

### Basic Structure

```bash
#!/usr/bin/env bash
# my-hook.sh

# Read stdin (contains hook context)
INPUT=$(cat)

# Parse input (JSON) — fields are snake_case
WORKING_DIR=$(echo "$INPUT" | jq -r '.working_directory // ""')

# Write informational output to stderr (NOT stdout)
echo "Hook running in: $WORKING_DIR" >&2

# Output JSON response to stdout (ONLY valid JSON)
echo '{"additionalContext": "Custom context to inject", "error": null}'
```

---

## Hook Best Practices

### 1. Make Scripts Executable

```bash
chmod +x .uatu/hooks/session-start/my-hook.sh
```

### 2. Silent Failures for Non-Critical Hooks

```bash
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

### 4. stdout Must Be Pure JSON

Any non-JSON on stdout breaks hook parsing:
```bash
# WRONG — breaks parsing
echo "Running hook..."
echo '{"additionalContext": "", "error": null}'

# CORRECT — debug to stderr
echo "Running hook..." >&2
echo '{"additionalContext": "", "error": null}'
```

---

## Troubleshooting

### Hook Not Running

1. **Check path in settings.json:**
   ```bash
   cat .claude/settings.json | jq '.hooks'
   ```

2. **Verify executable:**
   ```bash
   ls -l .uatu/hooks/session-start/*.sh
   # Should show -rwxr-xr-x
   ```

3. **Test manually:**
   ```bash
   echo '{"hook_event_name":"SessionStart","working_directory":"'$(pwd)'"}' | \
     .uatu/hooks/session-start/load-project-context.sh
   ```

4. **Check JSON output:**
   Hook must output valid JSON or be skipped.

### Hook Slowing Down Claude

1. **Profile execution:**
   ```bash
   time .uatu/hooks/post-tool-use/format-code.sh < test-input.json
   ```

2. **Remove from settings.json** to disable a specific hook.

### Hook Causing Errors

1. **Check stderr:**
   ```bash
   .uatu/hooks/my-hook.sh < input.json 2>&1
   ```

2. **Validate JSON output:**
   ```bash
   .uatu/hooks/my-hook.sh < input.json | jq .
   ```

3. **Add debug logging:**
   ```bash
   echo "DEBUG: $(date)" >&2
   ```

---

## Hook Chaining

Multiple hooks for the same event use an array of hook entries in `settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": ".uatu/hooks/session-start/load-project-context.sh" },
          { "type": "command", "command": ".uatu/hooks/session-start/session-restore.sh" },
          { "type": "command", "command": ".uatu/hooks/session-start/branch-guard.sh" }
        ]
      }
    ]
  }
}
```

Each hook's `additionalContext` is concatenated. If any hook returns a non-null `error`, the chain stops.

---

## Security Considerations

1. **Hooks run with your user permissions** — be careful with destructive operations
2. **Don't put secrets in hooks** — they may appear in logs/context
3. **Validate input** — don't trust hook input blindly
4. **Review third-party hooks** — only run hooks from trusted sources

---

*For comprehensive hook documentation, see `.uatu/guides/HOOKS.md`*
*For more on Uatu workflows, see `.uatu/guides/WORKFLOW.md`*
