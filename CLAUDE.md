# Uatu - Development Reference

This is the **source repository** for the Uatu AI orchestration framework. This CLAUDE.md enables the framework to understand and improve itself.

> **Note:** This project does NOT have `.uatu/` installed — it's the source, not a target. Templates live in `templates/`.

---

## Project Rules

@.claude/rules/framework-development.md

---

## Tech Stack

- **Shell**: Bash scripts (bin/uatu-install, bin/uatu-setup, tools)
- **Python**: Time tracking, worklog
- **Markdown**: Agents, skills, guides, documentation
- **JSON**: MCP configuration

---

## Self-Improvement Commands

When working on Uatu itself, use these commands:

```bash
# Test installation in clean environment
mkdir /tmp/test-uatu && cd /tmp/test-uatu && uatu-install && ls -la .uatu/ .claude/

# Count agents
find templates/.claude/agents -name "*.md" -not -name "README.md" | wc -l

# Count skills
ls -d templates/.claude/skills/*/ | wc -l

# Validate guides exist
for g in WORKFLOW SEQUENTIAL-THINKING TOOL-SELECTION SQUAD-GUIDE WATCHER AGENTS-GUIDE HOOKS; do
  [ -f "templates/.uatu/guides/${g}.md" ] && echo "✓ $g" || echo "✗ $g MISSING"
done

# Check for empty directories
find templates -type d -empty

# Run architecture scanner on self
./templates/.uatu/tools/architecture-scanner.sh
```

---

## Project Structure

```
uatu/
├── bin/
│   ├── uatu-install              # Per-project installer
│   └── uatu-setup                # User-level MCP setup
├── setup.sh                      # PATH setup
├── .mcp.json                     # MCP config (uses ${WORKSPACE_PATH})
├── env.example                   # Environment template
├── docs/                         # Reference material (not shipped)
│   ├── claude-code-memory.md
│   ├── mcp.json.template
│   └── prompt-analysis/
├── templates/                    # Copied to target projects
│   ├── CLAUDE.md                 # Framework instructions
│   ├── .envrc                    # Direnv template
│   ├── .uatu/
│   │   ├── config/               # Created at install
│   │   ├── guides/               # 7 guides
│   │   ├── hooks/                # 17 active hooks
│   │   └── tools/                # 4 tools
│   └── .claude/
│       ├── commands/             # 13 active + 3 archived
│       ├── skills/               # 20 skills
│       └── agents/               # 25 agents across 7 categories
└── README.md                     # User documentation
```

---

## Components Reference

### Tools (4)
| Tool | Path | Purpose |
|------|------|---------|
| health-check | `.uatu/tools/health-check.sh` | Verify framework installation |
| architecture-scanner | `.uatu/tools/architecture-scanner.sh` | Auto-generate architecture.md |
| worktree-helper | `.uatu/tools/worktree-helper.sh` | Git worktree management |
| time-tracking | `.uatu/tools/time-tracking/worklog.py` | Work session tracking |

### Commands (4 core + 9 speckit = 13 active)

**Core Commands:**
| Command | Purpose |
|---------|---------|
| `/orch` | Smart multi-agent (--tdd, --e2e, --verify, --dry-run, --jira, --scope, --no-commit, --review) |
| `/frame` | Organize + sharpen a draft prompt (sonnet only, no research) |
| `/jira` | Create Jira cards (Epic/Story/Subtask) |
| `/time-report` | Time tracking across projects |

**Archived** (in `commands/archive/`): status, pr, pre-flight-check

**Speckit Commands:** specify, clarify, plan, tasks, implement, analyze, checklist, constitution, complete

### Skills (21 — in `.claude/skills/`)
| Skill | Purpose |
|-------|---------|
| `react-component` | Generate TypeScript React component with tests |
| `test-file` | Generate test file for any source file (language-agnostic) |
| `api-design` | REST API design patterns |
| `backend-patterns` | Backend architecture patterns |
| `coding-standards` | Universal coding standards |
| `database-migrations` | Database migration best practices |
| `deployment-patterns` | Deployment workflows and CI/CD |
| `docker-patterns` | Docker and Docker Compose patterns |
| `e2e-testing` | Playwright E2E testing patterns |
| `frontend-patterns` | Frontend development patterns |
| `golang-patterns` | Idiomatic Go patterns |
| `golang-testing` | Go testing patterns |
| `python-patterns` | Pythonic idioms and best practices |
| `python-testing` | Python testing with pytest |
| `security-review` | Security checklist and patterns |
| `security-scan` | Scan config for vulnerabilities |
| `storybook` | Storybook story generation |
| `tdd-workflow` | Test-driven development enforcement |
| `ui-ux-design` | Design intelligence for UI/UX |
| `verification-loop` | Verification system for sessions |

### Guides (7)
| Guide | Purpose |
|-------|---------|
| WORKFLOW.md | Naming, folders, Jira, Speckit |
| SEQUENTIAL-THINKING.md | Task analysis patterns (optional, for complex tasks) |
| TOOL-SELECTION.md | Tool/package selection |
| SQUAD-GUIDE.md | SQUAD/HIVE: Agent Teams + Claude Flow MCP |
| WATCHER.md | Reference: learning + persistence patterns |
| AGENTS-GUIDE.md | Agent selection |
| HOOKS.md | Hook system |

### Hooks (17 active)
| Hook | Trigger | Purpose |
|------|---------|---------|
| load-project-context.sh | SessionStart | Load project config |
| session-restore.sh | SessionStart | Restore last session checkpoint |
| branch-guard.sh | SessionStart | Warn if on main/master |
| prompt-quality-advisor.sh | UserPromptSubmit | Score prompts on 5 dimensions (intent, context, specificity, scope, verifiability), suggest improvements |
| scope-detection.sh | UserPromptSubmit | Suggest `/orch` for large scope |
| prevent-sensitive-writes.sh | PreToolUse | Block sensitive file writes |
| protect-config-files.sh | PreToolUse | Block config file modifications |
| format-code.sh | PostToolUse | Auto-format code |
| self-review-checklist.sh | PostToolUse | Scan for TODOs, placeholders |
| smart-agent-suggestion.sh | PostToolUse | Suggest agents by file pattern |
| warn-file-length.sh | PostToolUse | Warn if file > 400 lines |
| event-log.sh | PostToolUse | Log tool usage (strict profile) |
| session-checkpoint.sh | Stop | Save session summary (JSONL) |
| cost-tracking.sh | Stop | Log session for cost review |
| missing-test-warning.sh | Stop | Warn about untested modifications |
| update-jira.sh | Stop | Update Jira status |
| desktop-notification.sh | Stop | macOS notification (strict profile) |

### Agents (25 — minimal set, 7 categories)
| Category | Count | Agents |
|----------|-------|--------|
| core | 11 | coder, tester, reviewer, code-reviewer, planner, researcher, debugger, architect-review, backend-architect, fullstack-developer, orchestrator-task |
| languages | 2 | golang-pro, python-pro |
| infrastructure | 2 | cloud-architect, deployment-engineer |
| specialized | 5 | jira-specialist, agile-specialist, mermaid-diagrammer, docs-architect, prompt-engineer |
| quality | 1 | security-auditor |
| data | 2 | database-expert, llm-architect |
| ui | 2 | frontend-developer, ui-ux-designer |

### Packages (4)
| Package | Layer | Use Case |
|---------|-------|----------|
| SOLO | 0A: Single agent | Single file, clear task, low risk |
| SQUAD | 0B+1: Agent Teams + Claude Flow MCP | Multi-file coordinated work |
| HIVE | 0B+1 + persistence | Multi-session, context must persist |
| WATCHER | HIVE + ruv-swarm DAA | Learning agents, no timeout |

---

## Adding Components

### New Agent
```bash
# 1. Create agent
cat > templates/.claude/agents/{category}/new-agent.md << 'EOF'
---
name: new-agent
description: What this agent does
tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
---

You are a specialist in...
EOF

# 2. Update README.md agent count if changed
```

### New Skill
```bash
# 1. Create skill directory
mkdir templates/.claude/skills/new-skill

# 2. Create SKILL.md
cat > templates/.claude/skills/new-skill/SKILL.md << 'EOF'
---
name: new-skill
description: What this skill does
---

# Instructions
...
EOF
```

### New Guide
```bash
# 1. Create guide
touch templates/.uatu/guides/NEW-GUIDE.md

# 2. Update templates/CLAUDE.md guides table
# 3. Update README.md if user-facing
```

### New Hook
```bash
# 1. Create hook script
cat > templates/.uatu/hooks/{trigger}/new-hook.sh << 'EOF'
#!/bin/bash
# Hook description
echo "Hook executed"
EOF
chmod +x templates/.uatu/hooks/{trigger}/new-hook.sh

# 2. Update templates/.uatu/guides/HOOKS.md
```

### New Tool
```bash
# 1. Create tool
mkdir templates/.uatu/tools/new-tool
touch templates/.uatu/tools/new-tool/new-tool.sh
chmod +x templates/.uatu/tools/new-tool/new-tool.sh

# 2. Update README.md tools section
# 3. Update templates/CLAUDE.md tools section
```

---

## MCP Servers

### User-Level (uatu-setup)
| Server | Prefix | Purpose |
|--------|--------|---------|
| Sequential Thinking | `mcp__sequential-thinking__` | Optional task analysis for complex problems |
| Claude Flow | `mcp__claude-flow__` | SQUAD/HIVE swarms |

### Project-Level (uatu-install)
| Server | Prefix | Purpose |
|--------|--------|---------|
| Filesystem | `mcp__filesystem__` | File operations |
| GitHub | `mcp__github__` | PR/issue management |
| Atlassian | `mcp__mcp-atlassian__` | Jira integration |

---

## Key Files

| File | Purpose | When to Update |
|------|---------|----------------|
| `bin/uatu-install` | Main installer | New directories, install behavior |
| `bin/uatu-setup` | User MCP setup | New user-level MCPs |
| `templates/CLAUDE.md` | Framework instructions | Packages, workflow changes |
| `README.md` | User documentation | Any user-facing changes |
| `.mcp.json` | MCP config | New project-level MCPs |
| `env.example` | Env template | New environment variables |

---

## Release Checklist

- [ ] Test `uatu-install` in clean directory
- [ ] Test upgrade preserves config files
- [ ] Verify guide cross-references
- [ ] Update README.md with new features
- [ ] Update component counts
- [ ] Commit with conventional message

---

## Commit Conventions

```
feat: new feature
fix: bug fix
docs: documentation only
refactor: code change without behavior change
chore: maintenance
```

---

## Current Stats

- **25 agents** across 7 categories
- **13 commands** (4 core + 9 speckit.*) — 3 archived (status, pr, pre-flight-check)
- **20 skills** (react-component, test-file, ui-ux-design + language/pattern skills)
- **7 guides**
- **17 active hooks**
- **5 rules** (uatu-core + 4 language rules)
- **4 tools**
- **4 packages** (SOLO, SQUAD, HIVE, WATCHER)

---

## For Claude Code Questions

Use the built-in `claude-code-guide` subagent_type:
```
Agent(subagent_type="claude-code-guide", prompt="How do I...")
```

Or use `/help` for CLI commands.

---

*Uatu Framework - Self-referential development reference*