# Uatu - The Watcher

AI orchestration framework for software development. Combines Sequential Thinking, multi-agent swarms, specification-driven workflows, and project management integration.

## What is Uatu?

Uatu transforms Claude Code into a structured development environment with:

- **Task Analysis** - Sequential Thinking MCP for structured reasoning before action
- **Execution Packages** - SOLO, SCOUT, SQUAD, BRAIN, HIVE, WATCHER for different task complexities
- **109 Specialized Agents** - From code review to Firebase, security to performance
- **Speckit Workflows** - Specification-driven development with `/speckit.*` commands
- **Hooks System** - Automated actions on session events
- **Jira/GitHub Integration** - Project management automation

## Quick Start

```bash
# 1. Clone and setup PATH (one-time)
git clone https://github.com/your-org/uatu.git
cd uatu && ./setup.sh && source ~/.zshrc

# 2. Install user-level MCP servers (one-time per machine)
uatu-setup

# 3. Install in any project
cd /path/to/your-project
uatu-install
```

## What Gets Installed

```
your-project/
├── CLAUDE.md                           # Framework instructions
├── .mcp.json                           # MCP server config
├── .env                                # Your tokens (gitignored)
├── .uatu/
│   ├── config/
│   │   ├── project.md                  # Project settings
│   │   ├── constitution.md             # AI behavior principles
│   │   └── architecture.md             # Auto-generated tech overview
│   ├── guides/                         # Reference documentation
│   ├── hooks/                          # Automation hooks
│   └── tools/                          # Utilities
└── .claude/
    ├── skills/                         # Speckit slash commands
    └── agents/                         # 109 specialized agents
```

## Packages

Packages are execution modes selected by Sequential Thinking based on task characteristics:

| Package | Agents | Use For |
|---------|--------|---------|
| **SOLO** | 0 | Quick fixes, single files |
| **SCOUT** | 1-3 | Investigation, codebase exploration |
| **SQUAD** | 5-8 | Multi-file coordinated features |
| **BRAIN** | 5-8+ | Long-running tasks, pattern learning (no timeout) |
| **HIVE** | Distributed | Multi-phase projects, persistent memory |
| **WATCHER** | Combined | BRAIN + HIVE: learning with cross-session persistence |

## Skills (Slash Commands)

| Command | Purpose |
|---------|---------|
| `/speckit.specify` | Create feature specification |
| `/speckit.clarify` | Reduce ambiguity in spec |
| `/speckit.plan` | Generate implementation plan |
| `/speckit.tasks` | Create task breakdown |
| `/speckit.implement` | Execute implementation |
| `/speckit.analyze` | Cross-artifact consistency check |
| `/speckit.checklist` | Requirements validation |
| `/speckit.constitution` | Define project principles |
| `/speckit.taskstoissues` | Convert tasks to GitHub issues |
| `/commit` | Smart commit with context |
| `/review-pr` | Comprehensive PR review |

## Agents

109 specialized agents organized by domain:

| Category | Examples |
|----------|----------|
| **Core** | frontend-developer, backend-architect, fullstack-developer |
| **Languages** | typescript-pro, python-pro, rust-pro, golang-pro, java-pro |
| **Infrastructure** | cloud-architect, kubernetes-architect, terraform-specialist |
| **Quality** | security-auditor, debugger, performance-engineer, test-automator |
| **Firebase** | auth, firestore, functions, hosting, crashlytics (12 specialists) |
| **GitHub** | pr-manager, release-swarm, code-review-swarm, workflow-automation |
| **SPARC** | specification, architecture, pseudocode, refinement |

## Hooks

Automated actions triggered by Claude Code events:

| Hook Type | Runs When | Example Use |
|-----------|-----------|-------------|
| `SessionStart` | Session begins | Load project context |
| `UserPromptSubmit` | User sends message | Enforce Sequential Thinking |
| `PostToolUse` | After tool execution | Format code |
| `Stop` | Session ends | Update Jira status |

## Tools

### Architecture Scanner

Auto-generates `.uatu/config/architecture.md` by analyzing your codebase.

```bash
.uatu/tools/architecture-scanner.sh
```

Detects: project type, frameworks, databases, infrastructure, entry points.

### Worktree Helper

Manages git worktrees for feature isolation.

```bash
.uatu/tools/worktree-helper.sh
```

### Time Tracking

Tracks work sessions across sprints.

```bash
python .uatu/tools/time-tracking/worklog.py --project $(pwd) --tz -3
```

## MCP Servers

| Server | Purpose | Installed By |
|--------|---------|--------------|
| Sequential Thinking | Task analysis | `uatu-setup` |
| Claude Flow | SQUAD/HIVE swarms | `uatu-setup` |
| Ruv Swarm | BRAIN (no timeout) | `uatu-setup` |
| Atlassian | Jira integration | `uatu-install` |
| GitHub | PR/issue management | `uatu-install` |
| Filesystem | File operations | `uatu-install` |

## Post-Install Checklist

1. Edit `.env` with your tokens (Jira, GitHub)
2. Edit `.uatu/config/project.md` with project settings
3. Review `.uatu/config/architecture.md` (auto-generated)
4. Run `direnv allow`

## Requirements

- Node.js 18+
- Claude Code CLI (`npm install -g @anthropic-ai/claude-code`)
- direnv (optional but recommended)

## Upgrade

Re-run `uatu-install` to upgrade. Your config files and delivery artifacts are preserved.

## License

MIT
