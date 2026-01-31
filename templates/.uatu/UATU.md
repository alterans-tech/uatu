# Uatu - The Watcher

AI orchestration framework. Read this before any task.

---

## Core Rules

1. **Sequential Thinking first** - Every task starts with Sequential Thinking MCP. No exceptions.
2. **Select the right package** - Based on task characteristics, not complexity assumptions
3. **All artifacts in `.uatu/`** - Deliverables, specs, configs go in `.uatu/` folder
4. **Use Speckit commands** - For specifications use `/speckit.*`, never create spec files manually
5. **Read config before work** - Check `.uatu/config/project.md` for project context

---

## Session Start

1. Read `.uatu/config/project.md` - Project settings and conventions
2. Read `.uatu/config/architecture.md` - Tech stack overview (auto-generated)
3. If task is complex, read relevant guide from `.uatu/guides/`
4. Start Sequential Thinking for the task

---

## Package Selection

Sequential Thinking determines the package. Select based on task needs:

| Package | When to Use |
|---------|-------------|
| **SOLO** | Single file, clear task, low risk |
| **SCOUT** | Need to investigate/explore first |
| **SQUAD** | Multiple coordinated subtasks |
| **BRAIN** | Pattern learning (single session) |
| **HIVE** | Multi-session, persist context |
| **WATCHER** | Learning + persistence combined |

**Quick reference:**

| Task Type | Package | First Action |
|-----------|---------|--------------|
| Fix bug | SOLO | Identify scope |
| Explore codebase | SCOUT | Spawn Explore agents |
| Multi-file refactor | SQUAD | swarm_init |
| Learn patterns | BRAIN | daa_agent_create |
| Multi-day work | HIVE | memory_namespace |
| Learn + remember | WATCHER | Both systems |

---

## Folder Structure

```
.uatu/
├── config/
│   ├── project.md         # Project settings (edit this)
│   ├── architecture.md    # Tech overview (auto-generated)
│   └── constitution.md    # AI behavior principles
├── guides/                 # Framework documentation
├── tools/                  # Utilities
└── delivery/
    └── sprints/           # Feature specs, tasks, plans
```

---

## Guides

| Guide | Purpose |
|-------|---------|
| `SEQUENTIAL-THINKING.md` | Task analysis patterns |
| `TOOL-SELECTION.md` | Choosing right tools |
| `WORKFLOW.md` | Naming, Jira, Speckit |
| `CLAUDE-FLOW-SELECTION.md` | SQUAD/BRAIN/HIVE details |
| `WATCHER.md` | Learning + persistence |
| `AGENTS-GUIDE.md` | Agent selection |

---

## Speckit Commands

| Command | Purpose |
|---------|---------|
| `/speckit.specify` | Create feature specification |
| `/speckit.clarify` | Reduce ambiguity in spec |
| `/speckit.plan` | Generate implementation plan |
| `/speckit.tasks` | Create task breakdown |
| `/speckit.implement` | Execute implementation |
| `/speckit.analyze` | Cross-artifact consistency |

---

## Tools

**Architecture Scanner** - Auto-generates tech overview:
```bash
.uatu/tools/architecture-scanner.sh
```

**Time Tracking** - See work sessions:
```bash
python .uatu/tools/time-tracking/worklog.py --project $(pwd)
```

---

## MCP Servers Required

| Server | Purpose |
|--------|---------|
| `sequential-thinking` | Task analysis (required) |
| `claude-flow` | SQUAD/HIVE swarms |
| `ruv-swarm` | BRAIN (learning, no timeout) |

Run `uatu-setup` to install user-level MCPs.
