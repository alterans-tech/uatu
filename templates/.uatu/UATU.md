# Uatu - The Watcher

AI orchestration framework.

---

## Before Any Task

1. **Read `.uatu/config/project.md`** — Project context and conventions
2. **Run Sequential Thinking MCP** — Analyze task before acting
3. **Select package** — See Package Selection below

---

## Core Rules

| Rule | Action |
|------|--------|
| **Sequential Thinking** | Run for EVERY task. No skipping. |
| **Package Selection** | Choose based on task needs, not assumptions |
| **Artifacts in `.uatu/`** | All deliverables go in `.uatu/delivery/` |
| **Use Speckit** | Run `/speckit.*` commands, never create specs manually |

---

## Package Selection

| Package | Use When |
|---------|----------|
| **SOLO** | Single file, clear task, low risk |
| **SCOUT** | Need to explore/investigate first |
| **SQUAD** | Multiple coordinated subtasks |
| **BRAIN** | Learning patterns (single session) |
| **HIVE** | Multi-session, need to persist context |
| **WATCHER** | Learning + persistence combined |

---

## Guides — Read When Needed

| Trigger | Read This Guide |
|---------|-----------------|
| Every complex task | `SEQUENTIAL-THINKING.md` |
| Unsure which tool/package | `TOOL-SELECTION.md` |
| Using SQUAD/BRAIN/HIVE | `CLAUDE-FLOW-SELECTION.md` |
| Using WATCHER package | `WATCHER.md` |
| Spawning agents | `AGENTS-GUIDE.md` |
| Jira tasks, naming, specs | `WORKFLOW.md` |

All guides in `.uatu/guides/`

---

## Speckit Commands — Use For Specifications

| When | Command |
|------|---------|
| New feature request | `/speckit.specify` |
| Spec is unclear | `/speckit.clarify` |
| Ready to plan implementation | `/speckit.plan` |
| Need task breakdown | `/speckit.tasks` |
| Ready to implement | `/speckit.implement` |
| Check consistency | `/speckit.analyze` |

---

## Folder Structure

```
.uatu/
├── config/
│   ├── project.md         # READ THIS — Project settings
│   ├── architecture.md    # Tech overview (auto-generated)
│   └── constitution.md    # AI behavior principles
├── guides/                 # Read when needed (see table above)
├── tools/                  # Utilities
└── delivery/
    └── sprints/           # All specs, tasks, plans go here
```

---

## Tools

| When | Tool |
|------|------|
| Need project tech overview | `.uatu/tools/architecture-scanner.sh` |
| Check work time | `.uatu/tools/time-tracking/worklog.py` |

---

## MCP Servers

| Server | Required For |
|--------|--------------|
| `sequential-thinking` | Every task (required) |
| `claude-flow` | SQUAD, HIVE, WATCHER |
| `ruv-swarm` | BRAIN, WATCHER |

Run `uatu-setup` to install.
