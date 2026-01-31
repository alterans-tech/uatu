# Uatu - Development Reference

This is the **source repository** for the Uatu AI orchestration framework. This CLAUDE.md enables the framework to understand and improve itself.

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
for g in WORKFLOW SEQUENTIAL-THINKING TOOL-SELECTION CLAUDE-FLOW-SELECTION WATCHER AGENTS-GUIDE HOOKS; do
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
├── templates/                    # Copied to target projects
│   ├── CLAUDE.md                 # Framework instructions
│   ├── .envrc                    # Direnv template
│   ├── .uatu/
│   │   ├── config/               # Created at install
│   │   ├── guides/               # 7 guides
│   │   ├── hooks/                # 4 active + 6 examples
│   │   └── tools/                # 3 tools
│   └── .claude/
│       ├── skills/               # 9 skills
│       └── agents/               # 62 agents
└── README.md                     # User documentation
```

---

## Components Reference

### Tools (3)
| Tool | Path | Purpose |
|------|------|---------|
| architecture-scanner | `.uatu/tools/architecture-scanner.sh` | Auto-generate architecture.md |
| worktree-helper | `.uatu/tools/worktree-helper.sh` | Git worktree management |
| time-tracking | `.uatu/tools/time-tracking/worklog.py` | Work session tracking |

### Skills (9)
| Skill | Purpose |
|-------|---------|
| `/speckit.specify` | Create feature specification |
| `/speckit.clarify` | Reduce spec ambiguity |
| `/speckit.plan` | Generate implementation plan |
| `/speckit.tasks` | Create task breakdown |
| `/speckit.implement` | Execute implementation |
| `/speckit.analyze` | Cross-artifact consistency |
| `/commit` | Smart git commit |
| `/review-pr` | PR review |

### Guides (7)
| Guide | Purpose |
|-------|---------|
| WORKFLOW.md | Naming, folders, Jira, Speckit |
| SEQUENTIAL-THINKING.md | Task analysis patterns |
| TOOL-SELECTION.md | Tool/package selection |
| CLAUDE-FLOW-SELECTION.md | SQUAD/BRAIN/HIVE details |
| WATCHER.md | Learning + persistence |
| AGENTS-GUIDE.md | Agent selection |
| HOOKS.md | Hook system |

### Hooks (4 active)
| Hook | Trigger | Purpose |
|------|---------|---------|
| load-project-context.sh | SessionStart | Load project config |
| enforce-sequential-thinking.sh | UserPromptSubmit | Enforce thinking |
| format-code.sh | PostToolUse | Format code |
| update-jira.sh | Stop | Update Jira status |

### Agents (62 across 9 categories)
| Category | Count | Key Agents |
|----------|-------|------------|
| core | 11 | coder, tester, reviewer, planner, researcher |
| firebase | 12 | auth, firestore, functions, hosting, crashlytics |
| languages | 7 | typescript, python, golang, rust, java, flutter |
| data | 6 | database-admin, ml-engineer, llm-architect |
| infrastructure | 6 | cloud-architect, kubernetes, terraform |
| specialized | 6 | agile-coach, jira-specialist, api-documenter |
| github | 5 | pr-manager, issue-tracker, release-manager |
| quality | 5 | debugger, security-auditor, performance-engineer |
| sparc | 4 | specification, architecture, pseudocode, refinement |

### Packages (6)
| Package | Use Case |
|---------|----------|
| SOLO | Single file, clear task |
| SCOUT | Investigation, exploration |
| SQUAD | Multi-file coordinated work |
| BRAIN | Pattern learning (no timeout) |
| HIVE | Multi-session persistence |
| WATCHER | Learning + persistence combined |

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
| Sequential Thinking | `mcp__sequential-thinking__` | Task analysis |
| Claude Flow | `mcp__claude-flow__` | SQUAD/HIVE swarms |
| Ruv Swarm | `mcp__ruv-swarm__` | BRAIN (no timeout) |

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

- **62 agents** across 9 categories
- **9 skills** (speckit commands + commit + review-pr)
- **7 guides**
- **4 active hooks** + 6 examples
- **3 tools**
- **6 packages**

---

## For Claude Code Questions

Use the built-in `claude-code-guide` subagent_type:
```
Task(subagent_type="claude-code-guide", prompt="How do I...")
```

Or use `/help` for CLI commands.

---

*Uatu Framework - Self-referential development reference*
