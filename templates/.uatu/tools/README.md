# Uatu Tools

Utility scripts for the Uatu framework.

---

## Available Tools

### health-check.sh

Verifies all dependencies and configurations are properly set up.

```bash
.uatu/tools/health-check.sh
```

Checks:
- Claude CLI availability
- Node.js version
- MCP servers (sequential-thinking, claude-flow)
- Project configuration files
- Environment variables
- Component counts

---

### architecture-scanner.sh

Auto-generates `architecture.md` by scanning the codebase for frameworks, databases, and project structure.

```bash
# Scan current directory, output to config
.uatu/tools/architecture-scanner.sh

# Scan specific directory
.uatu/tools/architecture-scanner.sh /path/to/project .uatu/config/architecture.md
```

Detects:
- Frontend frameworks (React, Vue, Angular, etc.)
- Backend frameworks (Express, FastAPI, Spring, etc.)
- Databases (PostgreSQL, MongoDB, Redis, etc.)
- Infrastructure (Docker, Kubernetes, Terraform, etc.)
- Directory structure and entry points

---

### worktree-helper.sh

Analyzes git repository state and recommends workflow (direct commits vs. worktrees).

```bash
.uatu/tools/worktree-helper.sh
```

Recommends:
- Git worktrees for mature projects with multiple contributors
- Direct commits for new or single-contributor projects
- Current branch validation against Jira conventions

---

### time-tracking/worklog.py

Analyzes Claude Code session logs to track work time by day.

```bash
# Basic usage
python .uatu/tools/time-tracking/worklog.py --project $(pwd)

# With timezone adjustment
python .uatu/tools/time-tracking/worklog.py --project $(pwd) --tz -3

# Filter to specific day
python .uatu/tools/time-tracking/worklog.py --project $(pwd) --day 2026-01-31
```

---

## Creating New Tools

1. Create script in `.uatu/tools/`:
   ```bash
   touch .uatu/tools/my-tool.sh
   chmod +x .uatu/tools/my-tool.sh
   ```

2. For complex tools, create a directory:
   ```bash
   mkdir .uatu/tools/my-tool
   touch .uatu/tools/my-tool/my-tool.sh
   chmod +x .uatu/tools/my-tool/my-tool.sh
   ```

3. Update this README

4. Update `CLAUDE.md` tools table

---

## Tool Guidelines

- All scripts should have `set -e` for error handling
- Use colored output for user experience
- Provide `--help` flag for usage information
- Follow shell best practices (quote variables, use `[[` for tests)
- Include error messages that guide users to solutions

---

*Uatu Tools - Utilities for AI-assisted development*
