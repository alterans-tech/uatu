# Hook Examples

This directory contains example hooks that demonstrate various capabilities. These are **reference implementations** - not automatically enabled.

---

## Available Examples

### SessionStart Hooks

**verify-git-branch.sh**
- Warns if working on main/master branch
- Suggests creating feature branch
- Use case: Prevent accidental commits to protected branches

**check-dependencies.sh**
- Verifies required development tools are installed
- Checks for optional tools (non-blocking)
- Use case: Ensure consistent development environment

**python-example.py**
- Example hook written in Python
- Shows language flexibility (any language with shebang works)
- Use case: Template for Python-based hooks

### PreToolUse Hooks

**prevent-destructive-ops.sh**
- Blocks dangerous Bash commands (rm -rf /, etc.)
- Prevents force push to protected branches
- Blocks .env file modifications
- Use case: Safety guardrails during automated sessions

### PostToolUse Hooks

**track-tool-usage.sh**
- Logs tool usage to `.uatu/cache/tool-usage.log`
- Tracks tool name, success/failure, timestamp
- Use case: Session analytics, debugging tool patterns

### Stop Hooks

**session-summary.sh**
- Generates end-of-session summary
- Reports tool usage statistics
- Cleans up session logs
- Use case: Session documentation, analytics

---

## How to Use Examples

### 1. Choose an Example

Decide which example hook fits your needs.

### 2. Copy to Appropriate Directory

```bash
# For SessionStart hooks
cp examples/verify-git-branch.sh session-start/

# For PreToolUse hooks
cp examples/prevent-destructive-ops.sh pre-tool-use/

# For PostToolUse hooks
cp examples/track-tool-usage.sh post-tool-use/

# For Stop hooks
cp examples/session-summary.sh stop/
```

Or create a new directory for a different event:

```bash
mkdir -p pre-tool-use
cp examples/prevent-destructive-ops.sh pre-tool-use/
```

### 3. Make Executable

```bash
chmod +x session-start/verify-git-branch.sh
```

### 4. Add to Configuration

Edit `.claude/hooks.json`:

```json
{
  "hooks": [
    {
      "event": "SessionStart",
      "scripts": [
        {
          "path": ".uatu/hooks/session-start/verify-git-branch.sh",
          "enabled": true
        }
      ]
    }
  ]
}
```

### 5. Test the Hook

```bash
# Test manually
echo '{"event":"SessionStart","workingDirectory":"'$(pwd)'"}' | \
  .uatu/hooks/session-start/verify-git-branch.sh

# Validate JSON output
echo '{"event":"SessionStart","workingDirectory":"'$(pwd)'"}' | \
  .uatu/hooks/session-start/verify-git-branch.sh | jq .
```

---

## Customizing Examples

All examples are templates - customize them for your project:

1. **check-dependencies.sh** - Update `REQUIRED_TOOLS` array for your stack
2. **prevent-destructive-ops.sh** - Add project-specific safety rules
3. **python-example.py** - Replace logic with your project checks

---

## Creating Your Own Hooks

### Basic Template

```bash
#!/usr/bin/env bash
# my-hook.sh

set -euo pipefail

# Read input
INPUT=$(cat)
EVENT=$(echo "$INPUT" | jq -r '.event')
WORKING_DIR=$(echo "$INPUT" | jq -r '.workingDirectory // ""')

# Your logic here
CONTEXT="Your message to Claude"

# Output JSON
jq -n --arg context "$CONTEXT" '{
  "additionalContext": $context,
  "error": null
}'
```

### Best Practices

1. **Fast execution** - Keep under 1 second
2. **Silent failures** - Use graceful fallbacks
3. **Valid JSON output** - Always output proper JSON
4. **Error handling** - Use `set -euo pipefail`
5. **Idempotent** - Handle multiple invocations safely

---

## Hook Events Reference

| Event | When It Runs | Common Use Cases |
|-------|-------------|------------------|
| SessionStart | New session begins | Load config, verify environment |
| UserPromptSubmit | User sends message | Enforce policies, add context |
| PreToolUse | Before tool executes | Validate, add safety checks |
| PostToolUse | After tool executes | Format code, update tracking |
| Stop | Session ends | Save state, generate reports |
| SubagentStop | Subagent completes | Aggregate results, cleanup |

---

*For comprehensive documentation, see `../.uatu/guides/HOOKS.md`*
