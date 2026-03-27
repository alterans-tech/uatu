# Uatu - The Watcher

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/alterans/uatu)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

AI orchestration framework for software development. Combines Sequential Thinking, multi-agent swarms, specification-driven workflows, and project management integration.

## What is Uatu?

Uatu transforms Claude Code into a structured development environment with:

- **Task Analysis** - Sequential Thinking MCP for structured reasoning before action
- **Execution Packages** - SOLO, SQUAD, HIVE, WATCHER for different task complexities
- **65 Specialized Agents** - Covering development, testing, quality, infrastructure, and platform-specific needs
- **Speckit Workflows** - Specification-driven development with `/speckit.*` commands
- **Hooks System** - Automated actions on session events (8 built-in hooks)
- **Jira/GitHub Integration** - Project management automation

## Quick Start

```bash
# 1. Clone and setup PATH (one-time)
git clone https://github.com/YOUR-USERNAME/uatu.git  # Replace with your fork
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
    ├── commands/                       # Speckit slash commands
    ├── skills/                         # react-component, test-file
    └── agents/                         # 65 specialized agents
```

## Packages

Packages are execution modes selected by Sequential Thinking based on task characteristics:

| Package | Layer | Use For |
|---------|-------|---------|
| **SOLO** | Single agent | Quick fixes, single files, exploration |
| **SQUAD** | Agent Teams + Claude Flow MCP | Multi-file coordinated features |
| **HIVE** | SQUAD + persistence | Multi-session projects, cross-session memory |
| **WATCHER** | HIVE + Ruflo CLI | Self-learning, background workers, neural training |

> **The Fundamental Law:** MCP tools coordinate strategy. The Task tool executes with real agents. These work together, not as alternatives.

## Commands (Slash Commands)

Speckit commands for specification-driven development:

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
| `/speckit.taskstoissues` | Convert tasks.md to GitHub Issues |

Utility commands:

| Command | Purpose |
|---------|---------|
| `/commit` | Smart commit with context |
| `/review-pr` | Comprehensive PR review |

## Skills

Component generation skills available in `.claude/skills/`:

| Skill | Purpose |
|-------|---------|
| `react-component` | Generate TypeScript React component with tests |
| `test-file` | Generate test file for any source file (language-agnostic) |

## Agents (65)

### Core (12)
| Agent | Purpose |
|-------|---------|
| `coder` | General code implementation |
| `tester` | Testing and test writing |
| `reviewer` | Code review |
| `planner` | Task planning and breakdown |
| `researcher` | Investigation and research |
| `orchestrator-task` | Task decomposition and multi-agent coordination |
| `architect-review` | Architecture review |
| `backend-architect` | Backend/API design |
| `frontend-developer` | Frontend/React development |
| `fullstack-developer` | End-to-end features |
| `microservices-architect` | Distributed systems |
| `ui-ux-designer` | Design and UX |

### Testing (2)
| Agent | Purpose |
|-------|---------|
| `tdd-london-swarm` | London School TDD with mock-driven development |
| `production-validator` | Pre-deployment production readiness validation |

### Data & AI (6)
| Agent | Purpose |
|-------|---------|
| `database-admin` | Database administration |
| `database-optimizer` | Query optimization |
| `sql-pro` | SQL expertise |
| `data-engineer` | Data pipelines |
| `ml-engineer` | Machine learning |
| `llm-architect` | LLM/AI systems |

### Firebase (12)
| Agent | Purpose |
|-------|---------|
| `firebase-auth-specialist` | Authentication |
| `firebase-firestore-specialist` | NoSQL database |
| `firebase-functions-specialist` | Cloud Functions |
| `firebase-hosting-specialist` | Hosting/deployment |
| `firebase-storage-specialist` | File storage |
| `firebase-analytics-specialist` | Analytics |
| `firebase-crashlytics-specialist` | Crash reporting |
| `firebase-messaging-specialist` | Push notifications |
| `firebase-performance-specialist` | Performance monitoring |
| `firebase-remote-config-specialist` | Feature flags |
| `firebase-appcheck-specialist` | App attestation |
| `firebase-testlab-specialist` | Device testing |

### GitHub (5)
| Agent | Purpose |
|-------|---------|
| `pr-manager` | Pull request management |
| `issue-tracker` | Issue tracking |
| `release-manager` | Release automation |
| `repo-architect` | Repository structure |
| `workflow-automation` | GitHub Actions |

### Infrastructure (6)
| Agent | Purpose |
|-------|---------|
| `cloud-architect` | Cloud architecture |
| `kubernetes-architect` | K8s orchestration |
| `terraform-specialist` | Infrastructure as Code |
| `deployment-engineer` | CI/CD |
| `monitoring-specialist` | Observability |
| `sre-engineer` | Site reliability |

### Languages (7)
| Agent | Purpose |
|-------|---------|
| `typescript-pro` | TypeScript |
| `javascript-pro` | JavaScript |
| `python-pro` | Python |
| `golang-pro` | Go |
| `rust-pro` | Rust |
| `java-pro` | Java |
| `flutter-pro` | Flutter/Dart |

### Quality (5)
| Agent | Purpose |
|-------|---------|
| `debugger` | Debugging |
| `security-auditor` | Security review |
| `performance-engineer` | Performance optimization |
| `test-automator` | Test automation |
| `chaos-engineer` | Resilience testing |

### SPARC Methodology (4)
| Agent | Purpose |
|-------|---------|
| `specification` | Requirements analysis |
| `architecture` | System design |
| `pseudocode` | Algorithm design |
| `refinement` | Iterative improvement |

### Specialized (6)
| Agent | Purpose |
|-------|---------|
| `agile-coach` | Scrum/Kanban, sprint planning, story writing |
| `jira-specialist` | Jira workflows, JQL, issue management |
| `api-documenter` | API documentation |
| `docs-architect` | Documentation design |
| `prompt-engineer` | LLM prompts |
| `refactoring-specialist` | Code refactoring |

## Hooks

8 automated hooks triggered by Claude Code events:

| Hook | Trigger | Purpose |
|------|---------|---------|
| `load-project-context.sh` | SessionStart | Load project config |
| `session-restore.sh` | SessionStart | Restore last session checkpoint |
| `enforce-sequential-thinking.sh` | UserPromptSubmit | Enforce thinking |
| `prevent-sensitive-writes.sh` | PreToolUse | Block writes to .env, credentials, keys |
| `format-code.sh` | PostToolUse | Auto-format code |
| `update-jira.sh` | Stop | Update Jira status |
| `session-checkpoint.sh` | Stop | Save session summary |
| `cost-tracking.sh` | Stop | Log session for cost review |

## Tools

### Health Check

Verifies framework installation and dependencies.

```bash
.uatu/tools/health-check.sh
```

Checks: Claude CLI, Node.js, MCP servers, configuration files, environment variables.

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
| Claude Flow | SQUAD/HIVE coordination + shared memory | `uatu-setup` |
| Ruv Swarm | Advanced SQUAD/HIVE (no-timeout, neural) | `uatu-setup` |
| Atlassian | Jira integration | `uatu-install` |
| GitHub | PR/issue management | `uatu-install` |
| Filesystem | File operations | `uatu-install` |

## Post-Install Checklist

1. Copy `.env.example` to `.env` and fill in your tokens
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
