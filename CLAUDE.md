# Uatu - Development Reference

This is the **source repository** for the Uatu framework. Use this reference when developing Uatu itself.

---

## Tech Stack

- **Shell Scripts**: Bash (bin/uatu-install, bin/uatu-setup, setup.sh)
- **Python**: Time tracking tool
- **Markdown**: Documentation, agents, skills, guides
- **JSON**: MCP configuration templates

---

## Project Structure

```
uatu/
├── bin/
│   ├── uatu-install              # Per-project installer (main script)
│   └── uatu-setup                # User-level MCP setup
├── setup.sh                      # PATH setup script
├── templates/                    # Files copied to target projects
│   ├── CLAUDE.md                 # Framework instructions template
│   ├── .envrc                    # Direnv template
│   ├── .uatu/
│   │   ├── config/               # Created at install, not in templates
│   │   ├── guides/               # Documentation (8 guides)
│   │   ├── hooks/                # Automation hooks (4 active + 6 examples)
│   │   └── tools/                # Utilities
│   │       ├── architecture-scanner.sh
│   │       ├── worktree-helper.sh
│   │       └── time-tracking/
│   └── .claude/
│       ├── skills/               # 10+ speckit commands
│       └── agents/               # 109 specialized agents
├── mcp.json.template             # MCP config template
├── env.example                   # Environment template
└── README.md                     # User-facing documentation
```

---

## Development Tools

### Test Installation

Always test changes in a clean environment:

```bash
# Create test directory
mkdir /tmp/test-uatu && cd /tmp/test-uatu

# Run installer
/path/to/uatu/bin/uatu-install

# Verify structure
ls -la .uatu/ .claude/
cat CLAUDE.md | head -50

# Test upgrade (preserves config)
/path/to/uatu/bin/uatu-install
```

### Count Assets

```bash
# Count agents
find templates/.claude/agents -name "*.md" -not -name "README.md" | wc -l

# Count skills
ls templates/.claude/skills/*/SKILL.md | wc -l

# Count hooks
find templates/.uatu/hooks -name "*.sh" | wc -l
```

### Validate Templates

```bash
# Check for broken references in CLAUDE.md template
grep -E "\.uatu/|\.claude/" templates/CLAUDE.md

# Verify all guides exist
for guide in WORKFLOW SEQUENTIAL-THINKING TOOL-SELECTION CLAUDE-FLOW-SELECTION WATCHER AGENTS-GUIDE; do
  [ -f "templates/.uatu/guides/${guide}.md" ] && echo "✓ $guide" || echo "✗ $guide missing"
done
```

---

## Adding New Components

### New Guide

```bash
# 1. Create the guide
touch templates/.uatu/guides/NEW-GUIDE.md

# 2. Update references
#    - templates/CLAUDE.md (Guides Reference table)
#    - README.md (if user-facing)
```

### New Skill

```bash
# 1. Create skill directory and SKILL.md
mkdir templates/.claude/skills/new-skill
cat > templates/.claude/skills/new-skill/SKILL.md << 'EOF'
---
name: new-skill
description: What this skill does
---

# Skill Instructions
...
EOF

# 2. Update README.md Skills table
```

### New Agent

```bash
# 1. Create agent in appropriate category
touch templates/.claude/agents/{category}/new-agent.md

# 2. Update README.md agent count if changed significantly
```

### New Hook

```bash
# 1. Create hook script
touch templates/.uatu/hooks/{hook-type}/new-hook.sh
chmod +x templates/.uatu/hooks/{hook-type}/new-hook.sh

# 2. Update templates/.uatu/hooks/README.md
```

### New Tool

```bash
# 1. Create tool in templates/.uatu/tools/
mkdir templates/.uatu/tools/new-tool
touch templates/.uatu/tools/new-tool/new-tool.sh

# 2. Update:
#    - templates/CLAUDE.md Tools section
#    - README.md Tools section
```

---

## Key Files

| File | Purpose | When to Update |
|------|---------|----------------|
| `bin/uatu-install` | Main installer | Adding new directories, changing install behavior |
| `bin/uatu-setup` | User MCP setup | Adding new user-level MCP servers |
| `templates/CLAUDE.md` | Framework instructions | Adding packages, changing workflow |
| `README.md` | User documentation | Any user-facing changes |
| `mcp.json.template` | MCP config | Adding new project-level MCP servers |

---

## Current Stats

- **60 agents** across 9 categories
- **10+ skills** (speckit commands + commit + review-pr)
- **8 guides** (workflow, thinking, tools, packages)
- **4 active hooks** + 6 examples
- **3 tools** (architecture-scanner, worktree-helper, time-tracking)
- **6 packages** (SOLO, SCOUT, SQUAD, BRAIN, HIVE, WATCHER)

## Agent Categories

| Category | Count | Examples |
|----------|-------|----------|
| core | 11 | coder, tester, reviewer, planner, researcher |
| data | 6 | database-admin, ml-engineer, llm-architect |
| firebase | 12 | auth, firestore, functions, hosting, crashlytics |
| github | 5 | pr-manager, issue-tracker, release-manager |
| infrastructure | 6 | cloud-architect, kubernetes, terraform |
| languages | 7 | typescript, python, golang, rust, java |
| quality | 5 | debugger, security-auditor, performance-engineer |
| sparc | 4 | specification, architecture, pseudocode, refinement |
| specialized | 4 | api-documenter, prompt-engineer, refactoring |

---

## Release Checklist

Before releasing:

- [ ] Test `uatu-install` in clean directory
- [ ] Test upgrade preserves config files
- [ ] Verify all guides cross-reference correctly
- [ ] Update README.md with new features
- [ ] Update asset counts if changed
- [ ] Commit with conventional message (`feat:`, `fix:`, `docs:`)

---

## Commit Conventions

```bash
feat: add new feature
fix: correct bug
docs: update documentation
refactor: code cleanup (no behavior change)
chore: maintenance tasks
```

---

*Uatu v1.1.0 - Development Reference*
