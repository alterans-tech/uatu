# Uatu - The Watcher

AI orchestration framework for software development combining Sequential Thinking, multi-agent swarms, Speckit workflows, and Jira/GitHub integration.

## Quick Start

```bash
# One-time setup (adds uatu-install to PATH)
./setup.sh
source ~/.zshrc

# Install user-level MCP servers (once per machine)
uatu-setup

# Install in any project
cd /path/to/your-monorepo
uatu-install
```

## What Gets Installed

```
your-monorepo/
├── CLAUDE.md                           # Framework instructions
├── .mcp.json                           # MCP server config
├── .env                                # Your tokens (gitignored)
├── .envrc                              # Direnv auto-load
├── .uatu/
│   ├── config/
│   │   ├── project.md                  # Project settings (markdown)
│   │   ├── constitution.md             # AI behavior principles
│   │   └── architecture.md             # Auto-generated overview
│   ├── guides/
│   │   ├── WORKFLOW.md                 # Naming, folders, Jira, Speckit
│   │   ├── SEQUENTIAL-THINKING.md      # Task analysis patterns
│   │   ├── TOOL-SELECTION.md           # Tool selection guide
│   │   └── CLAUDE-FLOW-SELECTION.md    # Swarm tool details
│   ├── tools/
│   │   ├── architecture-scanner.sh     # Auto-generate architecture.md
│   │   └── time-tracking/              # Work session tracking
│   └── delivery/
│       └── sprints/                    # Feature specs by sprint
└── .claude/
    ├── commands/
    │   └── speckit.*.md                # Speckit slash commands
    └── agents/                         # Agent definitions
        ├── core/                       # Core agents
        ├── github/                     # GitHub specialists
        ├── sparc/                      # SPARC methodology
        └── ...                         # More agent categories
```

## MCP Servers

### User-Level (installed by `uatu-setup`)

| Server | Purpose | Prefix |
|--------|---------|--------|
| Sequential Thinking | Task analysis | `mcp__sequential-thinking__` |
| Claude Flow | SQUAD swarms | `mcp__claude-flow__` |
| Ruv Swarm | BRAIN swarms (no timeout) | `mcp__ruv-swarm__` |
| Browser MCP | Web automation | `mcp__browsermcp__` |
| Context7 | Documentation lookup | `mcp__context7__` |

### Project-Level (installed by `uatu-install`)

| Server | Purpose | Prefix |
|--------|---------|--------|
| Filesystem | File operations | `mcp__filesystem__` |
| GitHub | PR/issue management | `mcp__github__` |
| Atlassian | Jira integration | `mcp__atlassian__` |

## Packages

| Package | Agents | Use For |
|---------|--------|---------|
| **SOLO** | 0 | Quick fixes, single files |
| **SCOUT** | 1-3 | Investigation, research |
| **SQUAD** | 5-8 | Multi-file features |
| **BRAIN** | 5-8+ | Long-running, learning |
| **HIVE** | Distributed | Multi-phase, risky code |

## Agents

Agents are natural language triggered AI assistants. They replace slash commands with conversational activation:

**Before:** `/sparc orchestrator "build auth system"`
**After:** "Orchestrate the development of the authentication system"

Agent categories:
- **core/** - Fundamental agents (orchestrator, coordinator)
- **github/** - GitHub specialists (PR manager, reviewer)
- **sparc/** - SPARC methodology (coder, tester, designer)
- **analysis/** - Code analysis (performance, compliance)
- **optimization/** - Performance optimization
- **swarm/** - Multi-agent coordination

## Speckit Commands

| Command | Purpose |
|---------|---------|
| `/speckit.specify` | Create feature specification |
| `/speckit.clarify` | Reduce ambiguity |
| `/speckit.plan` | Generate implementation plan |
| `/speckit.tasks` | Create task breakdown |
| `/speckit.implement` | Execute implementation |
| `/speckit.analyze` | Cross-artifact consistency |
| `/speckit.checklist` | Requirements validation |

## Tools

### Architecture Scanner

Auto-generates `.uatu/config/architecture.md` by scanning your codebase.

**What it detects:**
- Project type (Node.js, Python, Rust, Go, etc.)
- Frameworks (React, Next.js, Django, Flask, etc.)
- Databases (PostgreSQL, MySQL, MongoDB, Redis)
- Infrastructure (Docker, Kubernetes, GitHub Actions)
- Entry points and directory structure

**Usage:**
```bash
.uatu/tools/architecture-scanner.sh
```

The scanner runs automatically during `uatu-install` and can be rerun anytime.

### Time Tracking

Tracks work sessions across sprints and features.

**Usage:**
```bash
python .uatu/tools/time-tracking/worklog.py --project $(pwd) --tz -3
```

## Post-Install

1. Edit `.env` with your tokens
2. Edit `.uatu/config/project.md` with project settings
3. Review `.uatu/config/architecture.md` (auto-generated, can be updated manually or regenerated)
4. Run `direnv allow`

## Requirements

- Node.js 18+
- Claude Code CLI (`npm install -g @anthropic-ai/claude-code`)
- direnv (optional but recommended)
