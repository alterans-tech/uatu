# Uatu - The Watcher

AI orchestration framework for software development. This is the **source repository** for the Uatu framework itself.

---

## Project Overview

Uatu is an AI orchestration framework that provides:
- **Sequential Thinking** - Task analysis and structured reasoning
- **Multi-agent swarms** - SQUAD, BRAIN, and HIVE packages
- **Speckit workflows** - Specification-driven development
- **Jira/GitHub integration** - Project management automation

---

## Project Structure

```
uatu/
├── bin/
│   ├── uatu-install       # Per-project installer
│   └── uatu-setup         # User-level MCP setup
├── setup.sh               # PATH setup script
├── templates/
│   ├── CLAUDE.md          # Template for target projects
│   ├── .envrc             # Direnv template
│   └── .uatu/
│       ├── config/        # Config templates (not in source)
│       ├── guides/
│       └── tools/         # Utility tools (time-tracking, etc.)
│           ├── WORKFLOW.md
│           ├── SEQUENTIAL-THINKING.md
│           ├── TOOL-SELECTION.md
│           └── CLAUDE-FLOW-SELECTION.md
│   └── .claude/
│       ├── commands/      # Speckit slash commands
│       │   └── speckit.*.md
│       └── agents/        # Agent definitions
│           ├── core/
│           ├── github/
│           ├── sparc/
│           └── ...
├── mcp.json.template      # MCP config template
├── env.example            # Environment template
└── README.md
```

---

## Key Files

| File | Purpose |
|------|---------|
| `bin/uatu-install` | Main installer - creates `.uatu/` structure in target projects |
| `bin/uatu-setup` | One-time user-level MCP installation |
| `setup.sh` | Adds `bin/` to PATH |
| `templates/CLAUDE.md` | Framework instructions template |
| `templates/.uatu/guides/` | Guide documents |
| `templates/.claude/` | Commands and agents |

---

## Development Guidelines

### When Modifying Scripts

1. **uatu-install** creates the `.uatu/` folder structure
2. All path references should use `.uatu/` (not `repository/`)
3. Test changes by running `uatu-install` in a test project

### When Adding Guides

1. Place in `templates/.uatu/guides/`
2. Update references in `templates/CLAUDE.md`
3. Update the README.md structure diagram

### When Adding Agents

1. Place in `templates/.claude/agents/{category}/`
2. Follow naming conventions in existing agents
3. Update the agents README if adding new categories

### When Adding Commands

1. Place in `templates/.claude/commands/`
2. Follow `speckit.{name}.md` naming convention

### When Adding Tools

1. Place in `templates/.uatu/tools/{tool-name}/`
2. Include a README or GUIDE.md with usage instructions
3. Update `templates/CLAUDE.md` Tools section

---

## Testing Changes

```bash
# Create a test directory
mkdir /tmp/test-project
cd /tmp/test-project

# Run the installer
uatu-install

# Verify structure
ls -la .uatu/
ls -la .claude/
cat CLAUDE.md
```

---

## Release Process

1. Test all scripts locally
2. Update version references if applicable
3. Update README.md with any new features
4. Commit with descriptive message

---

*Uatu development reference*
