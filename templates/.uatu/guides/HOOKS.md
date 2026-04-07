# Uatu Hooks Guide

Comprehensive guide to Claude Code hooks and Uatu's hook system.

> **Load when:** Customizing automation hooks, debugging hook failures, or adding new project-specific hooks.

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

**Input (stdin, snake_case):**
```json
{
  "session_id": "abc123",
  "hook_event_name": "SessionStart",
  "working_directory": "/path/to/project"
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

**Input (stdin, snake_case):**
```json
{
  "session_id": "abc123",
  "hook_event_name": "UserPromptSubmit",
  "working_directory": "/path/to/project",
  "prompt": "User's message text"
}
```

**Use Cases:**
- Enforce policies (e.g., require Sequential Thinking)
- Add reminders or constraints
- Inject dynamic context per prompt
- Parse user intent
- Validate user requests

**Example:** `.uatu/hooks/user-prompt-submit/prompt-quality-advisor.sh`

---

### 3. PreToolUse

**Trigger:** Before Claude executes a tool

**Input (stdin, snake_case):**
```json
{
  "session_id": "abc123",
  "hook_event_name": "PreToolUse",
  "working_directory": "/path/to/project",
  "tool_name": "Write",
  "tool_input": {
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

**Input (stdin, snake_case):**
```json
{
  "session_id": "abc123",
  "hook_event_name": "PostToolUse",
  "working_directory": "/path/to/project",
  "tool_name": "Write",
  "tool_input": { "file_path": "...", "content": "..." },
  "tool_response": "..."
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

**Input (stdin, snake_case):**
```json
{
  "session_id": "abc123",
  "hook_event_name": "Stop",
  "working_directory": "/path/to/project"
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

**Input (stdin, snake_case):**
```json
{
  "session_id": "abc123",
  "hook_event_name": "SubagentStop",
  "working_directory": "/path/to/project"
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

Hooks are configured in `.claude/settings.json` (or `settings.local.json` for personal overrides):

### Configuration Format

The `"hooks"` field is an **object** where keys are event names. Each event contains an array of matcher groups, each with a `"hooks"` array of commands.

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": ".uatu/hooks/session-start/load-project-context.sh" },
          { "type": "command", "command": ".uatu/hooks/session-start/session-restore.sh" }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          { "type": "command", "command": ".uatu/hooks/user-prompt-submit/prompt-quality-advisor.sh" }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": ".uatu/hooks/pre-tool-use/prevent-sensitive-writes.sh" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": ".uatu/hooks/post-tool-use/format-code.sh" }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": ".uatu/hooks/stop/session-checkpoint.sh" },
          { "type": "command", "command": ".uatu/hooks/stop/update-jira.sh" },
          { "type": "command", "command": ".uatu/hooks/stop/cost-tracking.sh" }
        ]
      }
    ]
  }
}
```

**Key fields:**
- `"hooks"` (top-level) — object with event names as keys
- `"matcher"` — optional regex to filter by tool name (PreToolUse/PostToolUse only)
- `"type": "command"` — always `"command"` for shell scripts
- `"command"` — path to script (relative from project root)

### Multiple Hooks per Event

Commands in a `"hooks"` array run in order. To run different hooks based on tool, use multiple matcher groups:

```json
"PreToolUse": [
  {
    "matcher": "Write|Edit",
    "hooks": [{ "type": "command", "command": ".uatu/hooks/pre-tool-use/prevent-sensitive-writes.sh" }]
  },
  {
    "matcher": "Bash",
    "hooks": [{ "type": "command", "command": ".uatu/hooks/pre-tool-use/validate-commands.sh" }]
  }
]
```

---

## Uatu-Provided Hooks

Uatu includes 17 active hooks:

### 1. load-project-context.sh

**Event:** SessionStart

**Purpose:** Loads `.uatu/config/project.md` into Claude's context

**Behavior:**
- Checks for `.uatu/config/project.md`
- Injects entire file as critical context
- Silent no-op if file missing

**Required:** Yes (core Uatu functionality)

**Configuration:** Part of the `SessionStart` hooks array in `.claude/settings.json`.

---

### 2. prompt-quality-advisor.sh

**Event:** UserPromptSubmit

**Purpose:** Scores prompts and injects coaching suggestions

**Behavior:**
- Scores prompts against 5 research-backed dimensions: intent, context, specificity, scope, verifiability
- Exempt categories excluded from scoring: slash commands, execution confirmations, follow-ups, continuations, corrections, acknowledgments
- Low-scoring prompts (≤3/5 on prompts >12 words) get improvement suggestions
- References `.uatu/config/prompt-templates.md` for templates and `/frame` for restructuring

**Required:** Recommended (standard profile)

**Configuration:** Part of the `UserPromptSubmit` hooks array in `.claude/settings.json`.

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

**Configuration:** Part of the `PostToolUse` hooks array in `.claude/settings.json` (matcher: `Write|Edit`).

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

**Configuration:** Part of the `Stop` hooks array in `.claude/settings.json`. Remove from config if not using Jira.

**Disable if:** Not using Jira integration

---

### Session Management Hooks

#### 5. session-checkpoint.sh

**Event:** Stop

**Purpose:** Saves a timestamped session summary to `.uatu/delivery/checkpoints/`

**Behavior:**
- Creates `.uatu/delivery/checkpoints/session-TIMESTAMP.md`
- Captures current session context for resume

**Configuration:** Part of the `Stop` hooks array in `.claude/settings.json`.

---

#### 6. session-restore.sh

**Event:** SessionStart

**Purpose:** Injects the last session checkpoint into Claude's context on startup

**Behavior:**
- Finds latest checkpoint in `.uatu/delivery/checkpoints/`
- Displays it to Claude for session continuity

**Configuration:** Part of the `SessionStart` hooks array in `.claude/settings.json`.

---

#### 7. cost-tracking.sh

**Event:** Stop

**Purpose:** Logs session end timestamps to `.uatu/delivery/cost-log.md` for cost review

**Behavior:**
- Appends date/time entry to cost log
- Note: Token counts not exposed by Claude Code hooks; serves as session boundary marker

**Configuration:** Part of the `Stop` hooks array in `.claude/settings.json`.

---

#### 8. prevent-sensitive-writes.sh

**Event:** PreToolUse

**Purpose:** Blocks Write/Edit tool calls targeting sensitive files

**Behavior:**
- Checks file path against sensitive patterns (`.env`, `credentials.json`, `.pem`, `.key`, etc.)
- Returns exit code 2 to block the write if matched

**Configuration:** Part of the `PreToolUse` hooks array in `.claude/settings.json` (matcher: `Write|Edit`).

---

### Agent Teams Hooks (Ruflo CLI only)

`TeammateIdle` and `TaskCompleted` are Agent Teams lifecycle events emitted by the **Ruflo CLI**, not native Claude Code hooks. They are not available in standard Claude Code installations.

If using Ruflo CLI with WATCHER package, refer to Ruflo documentation for these hook events.

---

## Creating Custom Hooks

### Basic Template

```bash
#!/usr/bin/env bash
# my-custom-hook.sh

set -euo pipefail

# Read hook input (JSON on stdin — all fields are snake_case)
INPUT=$(cat)

# Parse input
WORKING_DIR=$(echo "$INPUT" | jq -r '.working_directory // ""')

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
WORKING_DIR=$(echo "$INPUT" | jq -r '.working_directory // ""')

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

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // "{}"')

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
# SessionStart hook
echo '{
  "hook_event_name": "SessionStart",
  "working_directory": "'$(pwd)'"
}' | .uatu/hooks/session-start/load-project-context.sh

# PreToolUse hook
echo '{
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": {"file_path": "/path/.env", "content": "TEST=1"}
}' | .uatu/hooks/pre-tool-use/prevent-sensitive-writes.sh
```

**Validate JSON output:**
```bash
echo '{"hook_event_name":"SessionStart","working_directory":"'$(pwd)'"}' \
  | .uatu/hooks/session-start/load-project-context.sh | jq .
```

**Check exit code:**
```bash
echo '{"hook_event_name":"Stop","working_directory":"'$(pwd)'"}' \
  | .uatu/hooks/stop/session-checkpoint.sh
echo "Exit code: $?"
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
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
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
cat .claude/settings.json | jq '.hooks.SessionStart'
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
echo '{"hook_event_name":"SessionStart","working_directory":"'$(pwd)'"}' | \
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
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "hooks/1-setup.sh" },
          { "type": "command", "command": "hooks/2-verify.sh" },
          { "type": "command", "command": "hooks/3-display.sh" }
        ]
      }
    ]
  }
}
```

If any hook returns a non-null `error`, chain stops.

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
| `session-start/session-restore.sh` | SessionStart | Restore last session checkpoint |
| `user-prompt-submit/prompt-quality-advisor.sh` | UserPromptSubmit | Prompt scoring and coaching |
| `pre-tool-use/prevent-sensitive-writes.sh` | PreToolUse | Block sensitive file writes |
| `post-tool-use/format-code.sh` | PostToolUse | Code formatting |
| `stop/update-jira.sh` | Stop | Tracking integration |
| `stop/session-checkpoint.sh` | Stop | Save session summary |
| `stop/cost-tracking.sh` | Stop | Log session for cost review |

---

*For overall Uatu workflows, see `.uatu/guides/WORKFLOW.md`*
*For Sequential Thinking patterns, see `.uatu/guides/SEQUENTIAL-THINKING.md`*
