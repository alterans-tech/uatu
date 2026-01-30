# Uatu Hooks Guide

Comprehensive guide to Claude Code hooks and Uatu's hook system.

---

## Table of Contents

1. [Overview](#overview)
2. [Hook Events](#hook-events)
3. [Configuration](#configuration)
4. [Uatu-Provided Hooks](#uatu-provided-hooks)
5. [Creating Custom Hooks](#creating-custom-hooks)
6. [Hook Development](#hook-development)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)
9. [Advanced Topics](#advanced-topics)

---

## Overview

Hooks are scripts that Claude Code executes at specific points during operation. They enable:

- **Context injection** - Load project-specific information
- **Policy enforcement** - Ensure standards are followed
- **Automation** - Format code, update tracking systems
- **Integration** - Connect with external tools and services

### How Hooks Work

```
┌─────────────────┐
│  Claude Code    │
│  Execution      │
└────────┬────────┘
         │
    Event occurs
    (e.g., SessionStart)
         │
         ▼
┌─────────────────┐
│  Hook Runner    │
│  - Load config  │
│  - Find scripts │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      stdin: {"event": "...", ...}
│  Hook Script    │◄─────────────────────────────────
│  (.sh, .py, etc)│
└────────┬────────┘
         │
         ▼
    stdout: {"additionalContext": "...", "error": null}
         │
         ▼
┌─────────────────┐
│  Claude Context │
│  + Hook Output  │
└─────────────────┘
```

---

## Hook Events

Claude Code provides 6 hook events:

### 1. SessionStart

**Trigger:** New Claude session begins

**Input:**
```json
{
  "event": "SessionStart",
  "workingDirectory": "/path/to/project",
  "timestamp": "2026-01-30T12:34:56Z"
}
```

**Use Cases:**
- Load project configuration
- Verify environment setup
- Check dependencies
- Initialize session state
- Display welcome messages

**Example:** `.uatu/hooks/session-start/load-project-context.sh`

---

### 2. UserPromptSubmit

**Trigger:** User sends a message to Claude

**Input:**
```json
{
  "event": "UserPromptSubmit",
  "workingDirectory": "/path/to/project",
  "timestamp": "2026-01-30T12:34:56Z",
  "prompt": "User's message text"
}
```

**Use Cases:**
- Enforce policies (e.g., require Sequential Thinking)
- Add reminders or constraints
- Inject dynamic context per prompt
- Parse user intent
- Validate user requests

**Example:** `.uatu/hooks/user-prompt-submit/enforce-sequential-thinking.sh`

---

### 3. PreToolUse

**Trigger:** Before Claude executes a tool

**Input:**
```json
{
  "event": "PreToolUse",
  "workingDirectory": "/path/to/project",
  "timestamp": "2026-01-30T12:34:56Z",
  "toolName": "Write",
  "toolInput": {
    "file_path": "/path/to/file.ts",
    "content": "..."
  }
}
```

**Use Cases:**
- Validate tool parameters
- Add safety checks
- Backup files before modification
- Check permissions
- Rate limiting

**Example Use Case:**
```bash
# Prevent writes to sensitive files
if [[ "$FILE_PATH" == *".env"* ]]; then
    echo '{"error": "Cannot modify .env files"}'
    exit 1
fi
```

---

### 4. PostToolUse

**Trigger:** After Claude executes a tool

**Input:**
```json
{
  "event": "PostToolUse",
  "workingDirectory": "/path/to/project",
  "timestamp": "2026-01-30T12:34:56Z",
  "toolResult": {
    "toolName": "Write",
    "input": {"file_path": "...", ...},
    "output": "...",
    "success": true
  }
}
```

**Use Cases:**
- Format code after writes
- Run linters
- Update indexes
- Track changes
- Trigger builds

**Example:** `.uatu/hooks/post-tool-use/format-code.sh`

---

### 5. Stop

**Trigger:** Session ends normally (user exits, task completes)

**Input:**
```json
{
  "event": "Stop",
  "workingDirectory": "/path/to/project",
  "timestamp": "2026-01-30T12:34:56Z"
}
```

**Use Cases:**
- Save session state
- Update Jira/GitHub
- Generate reports
- Cleanup temporary files
- Archive logs

**Example:** `.uatu/hooks/stop/update-jira.sh`

---

### 6. SubagentStop

**Trigger:** Subagent completes work (Task tool finishes)

**Input:**
```json
{
  "event": "SubagentStop",
  "workingDirectory": "/path/to/project",
  "timestamp": "2026-01-30T12:34:56Z",
  "subagentResult": {
    "type": "coder",
    "output": "...",
    "success": true
  }
}
```

**Use Cases:**
- Aggregate subagent results
- Validate subagent output
- Update coordination state
- Cleanup subagent artifacts

---

## Configuration

### Location

Hooks are configured in `.claude/hooks.json` or `mcp.json`:

**Option 1: Separate file (recommended)**
```json
// .claude/hooks.json
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

**Option 2: In mcp.json**
```json
// mcp.json
{
  "mcpServers": { ... },
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

### Configuration Format

```json
{
  "hooks": [
    {
      "event": "SessionStart|UserPromptSubmit|PreToolUse|PostToolUse|Stop|SubagentStop",
      "scripts": [
        {
          "path": "relative/path/to/script.sh",
          "enabled": true,
          "timeout": 5000,
          "description": "Optional description"
        }
      ]
    }
  ]
}
```

**Fields:**
- `event` - Hook event name (required)
- `scripts` - Array of scripts to run (required)
  - `path` - Relative path from project root (required)
  - `enabled` - Whether to run this hook (default: true)
  - `timeout` - Max execution time in ms (default: 5000)
  - `description` - Human-readable description (optional)

### Multiple Scripts per Event

Scripts run in order, `additionalContext` is concatenated:

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

---

## Uatu-Provided Hooks

Uatu includes 4 pre-built hooks:

### 1. load-project-context.sh

**Event:** SessionStart

**Purpose:** Loads `.uatu/config/project.md` into Claude's context

**Behavior:**
- Checks for `.uatu/config/project.md`
- Injects entire file as critical context
- Silent no-op if file missing

**Required:** Yes (core Uatu functionality)

**Configuration:**
```json
{
  "event": "SessionStart",
  "scripts": [
    {"path": ".uatu/hooks/session-start/load-project-context.sh"}
  ]
}
```

---

### 2. enforce-sequential-thinking.sh

**Event:** UserPromptSubmit

**Purpose:** Reminds Claude to use Sequential Thinking MCP

**Behavior:**
- Adds critical reminder on every user prompt
- References `.uatu/guides/SEQUENTIAL-THINKING.md` if present
- Non-intrusive context injection

**Required:** Strongly recommended

**Configuration:**
```json
{
  "event": "UserPromptSubmit",
  "scripts": [
    {"path": ".uatu/hooks/user-prompt-submit/enforce-sequential-thinking.sh"}
  ]
}
```

**Disable if:** You want to manage Sequential Thinking manually

---

### 3. format-code.sh

**Event:** PostToolUse

**Purpose:** Auto-formats code after Write/Edit

**Behavior:**
- Detects file extension
- Runs formatter:
  - `.ts/.tsx/.js/.jsx` → prettier
  - `.py` → black
  - `.go` → gofmt
- Silent failure (non-blocking)
- Only runs on Write/Edit tools

**Required:** No (convenience feature)

**Configuration:**
```json
{
  "event": "PostToolUse",
  "scripts": [
    {"path": ".uatu/hooks/post-tool-use/format-code.sh"}
  ]
}
```

**Dependencies:**
```bash
npm install -g prettier
pip install black
# gofmt comes with Go
```

**Disable if:**
- You have IDE auto-formatting
- You have pre-commit hooks
- You prefer manual formatting

---

### 4. update-jira.sh

**Event:** Stop

**Purpose:** Updates Jira issue on session end (placeholder)

**Behavior:**
- Detects Jira key from git branch
- Currently a placeholder
- Future: Posts session summary to Jira

**Required:** No (future feature)

**Configuration:**
```json
{
  "event": "Stop",
  "scripts": [
    {"path": ".uatu/hooks/stop/update-jira.sh"}
  ]
}
```

**Disable if:** Not using Jira integration

---

## Creating Custom Hooks

### Basic Template

```bash
#!/usr/bin/env bash
# my-custom-hook.sh

set -euo pipefail

# Read hook input (JSON on stdin)
INPUT=$(cat)

# Parse input
EVENT=$(echo "$INPUT" | jq -r '.event')
WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory // ""')

# Do your work here
# ...

# Output JSON response
jq -n --arg context "Your context message" '{
  "additionalContext": $context,
  "error": null
}'
```

### Example: Verify Git Branch

```bash
#!/usr/bin/env bash
# verify-branch.sh - Ensure work is on feature branch

set -euo pipefail

INPUT=$(cat)
WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory')

cd "$WORKING_DIR"

if ! command -v git &> /dev/null; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

BRANCH=$(git branch --show-current)

if [[ "$BRANCH" == "main" ]] || [[ "$BRANCH" == "master" ]]; then
    CONTEXT="WARNING: You are on branch '$BRANCH'. Consider creating a feature branch."
else
    CONTEXT=""
fi

jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
```

### Example: Check Dependencies

```bash
#!/usr/bin/env bash
# check-deps.sh - Verify required tools are installed

set -euo pipefail

MISSING=()

command -v node &> /dev/null || MISSING+=("node")
command -v jq &> /dev/null || MISSING+=("jq")
command -v git &> /dev/null || MISSING+=("git")

if [ ${#MISSING[@]} -eq 0 ]; then
    CONTEXT=""
else
    CONTEXT="WARNING: Missing dependencies: ${MISSING[*]}"
fi

jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
```

### Example: Prevent Destructive Operations

```bash
#!/usr/bin/env bash
# prevent-rm-rf.sh - Block dangerous deletions

set -euo pipefail

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName // ""')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.toolInput // "{}"')

if [[ "$TOOL_NAME" == "Bash" ]]; then
    COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // ""')

    if [[ "$COMMAND" =~ rm[[:space:]]+-rf[[:space:]]+/ ]]; then
        jq -n '{
          "additionalContext": "",
          "error": "BLOCKED: Dangerous rm -rf command detected"
        }'
        exit 1
    fi
fi

echo '{"additionalContext": "", "error": null}'
```

---

## Hook Development

### Input/Output Contract

**Input (stdin):** JSON object with event-specific fields

**Output (stdout):** JSON object with:
```json
{
  "additionalContext": "Text to inject (string, optional)",
  "error": "Error message (string, null = no error)"
}
```

**Rules:**
- Must output valid JSON
- `additionalContext` is added to Claude's prompt
- `error` stops execution and shows user the message
- Empty string for `additionalContext` is valid (no-op)
- `error: null` means success

### Language Support

Hooks can be written in any language with executable shebang:

**Bash:**
```bash
#!/usr/bin/env bash
```

**Python:**
```python
#!/usr/bin/env python3
import json
import sys

input_data = json.load(sys.stdin)
# ... your logic ...
print(json.dumps({"additionalContext": "...", "error": None}))
```

**Node.js:**
```javascript
#!/usr/bin/env node
const input = JSON.parse(require('fs').readFileSync(0, 'utf-8'));
// ... your logic ...
console.log(JSON.stringify({additionalContext: "...", error: null}));
```

**Go:**
```go
#!/usr/bin/env -S go run
package main
import ("encoding/json"; "fmt"; "os")
// ... your logic ...
```

### Testing Hooks

**Manual test:**
```bash
# Create test input
echo '{
  "event": "SessionStart",
  "workingDirectory": "'$(pwd)'"
}' | .uatu/hooks/session-start/my-hook.sh
```

**Validate JSON output:**
```bash
echo '{...}' | .uatu/hooks/session-start/my-hook.sh | jq .
```

**Check exit code:**
```bash
echo '{...}' | .uatu/hooks/session-start/my-hook.sh
echo "Exit code: $?"
```

**Profile performance:**
```bash
time echo '{...}' | .uatu/hooks/session-start/my-hook.sh
```

---

## Best Practices

### 1. Fast Execution

Hooks add latency. Keep under 1 second:

```bash
# Good: Direct check
if [ -f ".env" ]; then
    # ...
fi

# Bad: Slow external call
curl -s https://api.example.com/check  # May take seconds
```

**Optimization strategies:**
- Cache expensive operations
- Use timeouts for external commands
- Avoid network calls
- Process large files incrementally

### 2. Graceful Degradation

Don't break Claude if tool missing:

```bash
# Good: Silent fallback
if ! command -v prettier &> /dev/null; then
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi

# Bad: Hard failure
prettier --version  # Errors if not installed
```

### 3. Idempotent Operations

Hooks may run multiple times:

```bash
# Good: Check before create
if [ ! -f ".uatu/cache/session.log" ]; then
    echo "Session start" > ".uatu/cache/session.log"
fi

# Bad: Blind append
echo "Session start" >> ".uatu/cache/session.log"  # Duplicates on retry
```

### 4. Proper Error Handling

```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# But catch expected failures
if ! some_command; then
    # Handle gracefully
    echo '{"additionalContext": "", "error": null}'
    exit 0
fi
```

### 5. Minimal Context Injection

Only inject what Claude needs:

```bash
# Good: Concise
CONTEXT="Project uses TypeScript. See tsconfig.json."

# Bad: Verbose
CONTEXT="This project is a TypeScript project which means you should use TypeScript and follow TypeScript conventions and check tsconfig.json for configuration..."
```

### 6. Security

```bash
# Good: Validate input
FILE_PATH=$(echo "$INPUT" | jq -r '.toolInput.file_path // ""')
if [[ ! "$FILE_PATH" =~ ^[a-zA-Z0-9/_.-]+$ ]]; then
    echo '{"error": "Invalid file path"}'
    exit 1
fi

# Bad: Direct eval
eval "$(echo "$INPUT" | jq -r '.command')"  # Code injection risk
```

### 7. Logging for Debugging

```bash
# Development: log to file
echo "DEBUG: $(date) - Event: $EVENT" >> /tmp/hook-debug.log

# Production: silent or minimal logging
# (logs may expose sensitive info)
```

---

## Troubleshooting

### Hook Not Running

**Check 1: Enabled in config**
```bash
cat .claude/hooks.json | jq '.hooks[] | select(.event=="SessionStart")'
```

**Check 2: Executable permissions**
```bash
ls -l .uatu/hooks/session-start/*.sh
# Should show: -rwxr-xr-x
```

**Fix:**
```bash
chmod +x .uatu/hooks/session-start/my-hook.sh
```

**Check 3: Path correctness**
```json
// Paths are relative to project root
{
  "path": ".uatu/hooks/session-start/my-hook.sh"  // ✓ Correct
  "path": "hooks/session-start/my-hook.sh"         // ✗ Wrong
  "path": "/absolute/path/my-hook.sh"              // ✗ Avoid
}
```

**Check 4: Valid JSON output**
```bash
.uatu/hooks/session-start/my-hook.sh < test-input.json | jq .
# Should parse without errors
```

---

### Hook Causing Errors

**Symptom:** Claude shows hook error message

**Debug steps:**

1. **Check stderr:**
```bash
.uatu/hooks/my-hook.sh < input.json 2>&1
```

2. **Validate JSON:**
```bash
.uatu/hooks/my-hook.sh < input.json | jq .
# Error? Fix JSON output
```

3. **Test manually:**
```bash
echo '{"event":"SessionStart","workingDirectory":"'$(pwd)'"}' | \
    .uatu/hooks/my-hook.sh
```

4. **Add debug output:**
```bash
# In hook script
echo "DEBUG: INPUT=$INPUT" >&2
```

5. **Disable and isolate:**
```json
// Set enabled: false
{"path": ".uatu/hooks/my-hook.sh", "enabled": false}
```

---

### Hook Slowing Down Claude

**Symptom:** Noticeable delay before Claude responds

**Measure execution time:**
```bash
time .uatu/hooks/my-hook.sh < input.json
```

**Optimization strategies:**

1. **Profile bottlenecks:**
```bash
# Add timestamps
echo "Start: $(date +%s%N)" >&2
# ... expensive operation ...
echo "End: $(date +%s%N)" >&2
```

2. **Cache results:**
```bash
CACHE_FILE=".uatu/cache/deps-check.cache"
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE"))) -lt 3600 ]; then
    cat "$CACHE_FILE"
    exit 0
fi
# ... run check, save to cache ...
```

3. **Disable non-essential hooks:**
```json
{"path": ".uatu/hooks/post-tool-use/format-code.sh", "enabled": false}
```

4. **Move work to background:**
```bash
# Non-critical work
(update_index &)  # Run in background
```

---

### Hook Output Not Appearing

**Cause 1: Empty `additionalContext`**
```bash
# Hook returns empty string
echo '{"additionalContext": "", "error": null}'
```

**Cause 2: Claude truncates long context**
- Keep context under 500 words
- Summarize instead of dumping files

**Cause 3: Context not visible in UI**
- Check Claude's system message section
- Some contexts are invisible but affect behavior

---

## Advanced Topics

### Context Priority

Multiple sources inject context, priority order:

1. System instructions (highest)
2. Session-start hooks
3. User-prompt-submit hooks
4. Tool output
5. User messages (lowest)

Hooks cannot override system instructions.

---

### Hook Chaining

Same-event hooks chain in order:

```json
{
  "event": "SessionStart",
  "scripts": [
    {"path": "hooks/1-setup.sh"},      // Runs first
    {"path": "hooks/2-verify.sh"},     // Runs second
    {"path": "hooks/3-display.sh"}     // Runs third
  ]
}
```

If any hook returns `error`, chain stops.

---

### Stateful Hooks

Store state between invocations:

```bash
#!/usr/bin/env bash
STATE_FILE=".uatu/cache/session-state.json"

# Read previous state
if [ -f "$STATE_FILE" ]; then
    PREV_STATE=$(cat "$STATE_FILE")
else
    PREV_STATE='{"count": 0}'
fi

COUNT=$(echo "$PREV_STATE" | jq '.count')
COUNT=$((COUNT + 1))

# Save new state
echo "{\"count\": $COUNT}" > "$STATE_FILE"

# Use state
jq -n --arg count "$COUNT" '{
  "additionalContext": ("Prompt #" + $count),
  "error": null
}'
```

**Cleanup on Stop:**
```bash
# In Stop hook
rm -f .uatu/cache/session-state.json
```

---

### Conditional Hook Execution

**Based on environment:**
```bash
if [ "$UATU_ENV" = "production" ]; then
    # Strict checks in prod
    CONTEXT="CRITICAL: Production environment - extra caution required"
else
    CONTEXT=""
fi
```

**Based on git branch:**
```bash
BRANCH=$(git branch --show-current)
if [[ "$BRANCH" == release/* ]]; then
    CONTEXT="Release branch - ensure all tests pass before merging"
fi
```

**Based on file type:**
```bash
if [[ "$FILE_PATH" == *.security.ts ]]; then
    CONTEXT="Security-sensitive file - requires security-auditor review"
fi
```

---

### Hook Composition

Reusable hook functions:

```bash
# lib/common.sh
check_git_repo() {
    command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null 2>&1
}

get_jira_key() {
    if check_git_repo; then
        BRANCH=$(git branch --show-current)
        if [[ "$BRANCH" =~ ([A-Z]+-[0-9]+) ]]; then
            echo "${BASH_REMATCH[1]}"
        fi
    fi
}

# In hook script
source "$(dirname "$0")/../../lib/common.sh"
JIRA_KEY=$(get_jira_key)
```

---

### Performance Monitoring

Track hook performance:

```bash
#!/usr/bin/env bash
METRICS_FILE=".uatu/cache/hook-metrics.log"

START=$(date +%s%N)

# ... hook logic ...

END=$(date +%s%N)
DURATION=$(( (END - START) / 1000000 ))  # Convert to ms

echo "$(date -Iseconds),$EVENT,$DURATION" >> "$METRICS_FILE"
```

Analyze:
```bash
# Average execution time per event
awk -F, '{sum[$2]+=$3; count[$2]++} END {for (event in sum) print event, sum[event]/count[event]}' \
    .uatu/cache/hook-metrics.log
```

---

## Security Considerations

### 1. Input Validation

Never trust hook input:

```bash
# Validate paths
if [[ ! "$FILE_PATH" =~ ^[a-zA-Z0-9/_.-]+$ ]]; then
    echo '{"error": "Invalid file path"}'
    exit 1
fi

# Escape for shell
FILE_PATH=$(printf '%q' "$FILE_PATH")
```

### 2. Secrets Handling

Never log or expose secrets:

```bash
# Bad: Secret in context
CONTEXT="API_KEY=$API_KEY loaded"

# Good: Generic message
CONTEXT="API credentials loaded from environment"
```

### 3. Permissions

Hooks run with user permissions:

```bash
# Check before destructive ops
if [ ! -w "$FILE_PATH" ]; then
    echo '{"error": "No write permission"}'
    exit 1
fi
```

### 4. Code Injection

Avoid eval or unescaped execution:

```bash
# Bad
eval "$(echo "$INPUT" | jq -r '.command')"

# Good
SAFE_COMMAND=$(echo "$INPUT" | jq -r '.command')
if [[ "$SAFE_COMMAND" =~ ^(allowed|commands)$ ]]; then
    "$SAFE_COMMAND"
fi
```

### 5. Third-Party Hooks

Review before using:

```bash
# Check hook source
cat third-party-hook.sh

# Test in isolation
./third-party-hook.sh < test-input.json

# Monitor behavior
strace -e open,write ./third-party-hook.sh < input.json
```

---

## Examples Repository

See `.uatu/hooks/` for working examples:

| Hook | Event | Purpose |
|------|-------|---------|
| `session-start/load-project-context.sh` | SessionStart | Load project config |
| `user-prompt-submit/enforce-sequential-thinking.sh` | UserPromptSubmit | Policy enforcement |
| `post-tool-use/format-code.sh` | PostToolUse | Code formatting |
| `stop/update-jira.sh` | Stop | Tracking integration |

---

*For overall Uatu workflows, see `.uatu/guides/WORKFLOW.md`*
*For Sequential Thinking patterns, see `.uatu/guides/SEQUENTIAL-THINKING.md`*
