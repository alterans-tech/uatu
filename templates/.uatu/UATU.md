# Uatu - The Watcher

AI orchestration framework.

---

## Before Any Task

1. **Read project config** — `.uatu/config/project.md`
2. **Run Sequential Thinking** — Analyze task before acting
3. **Select package** — Based on task characteristics

---

## Config Files

| File | Purpose | When to Read |
|------|---------|--------------|
| `.uatu/config/project.md` | Project settings, conventions | Every session |
| `.uatu/config/architecture.md` | Tech stack (auto-generated) | When exploring codebase |
| `.uatu/config/constitution.md` | AI behavior principles | When unsure about approach |

---

## Core Rules

| Rule | Action |
|------|--------|
| **Sequential Thinking** | Run for EVERY task. No skipping. |
| **Package Selection** | Choose based on task needs |
| **Artifacts in `.uatu/`** | All deliverables go in `.uatu/delivery/` |
| **Use Speckit** | Run `/speckit.*` commands for specs |

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

## Guides

| Trigger | Read This |
|---------|-----------|
| Every complex task | `.uatu/guides/SEQUENTIAL-THINKING.md` |
| Unsure which tool/package | `.uatu/guides/TOOL-SELECTION.md` |
| Using SQUAD/BRAIN/HIVE | `.uatu/guides/CLAUDE-FLOW-SELECTION.md` |
| Using WATCHER package | `.uatu/guides/WATCHER.md` |
| Spawning agents | `.uatu/guides/AGENTS-GUIDE.md` |
| Jira tasks, naming, specs | `.uatu/guides/WORKFLOW.md` |
| Customizing hooks | `.uatu/guides/HOOKS.md` |

---

## Speckit Commands

| When | Command |
|------|---------|
| New feature request | `/speckit.specify` |
| Spec is unclear | `/speckit.clarify` |
| Ready to plan | `/speckit.plan` |
| Need task breakdown | `/speckit.tasks` |
| Ready to implement | `/speckit.implement` |
| Check consistency | `/speckit.analyze` |

---

## Tools

| Tool | Purpose |
|------|---------|
| `.uatu/tools/architecture-scanner.sh` | Generate tech stack overview |
| `.uatu/tools/worktree-helper.sh` | Git worktree management |
| `.uatu/tools/time-tracking/worklog.py` | Track work sessions |

---

## Hooks

Hooks run automatically at key events. Configured in `.claude/settings.json`:

| Hook | Event | Purpose |
|------|-------|---------|
| `load-project-context.sh` | SessionStart | Load project config |
| `enforce-sequential-thinking.sh` | UserPromptSubmit | Remind to use ST |
| `format-code.sh` | PostToolUse | Auto-format code |
| `update-jira.sh` | Stop | Update Jira status |

See `.uatu/guides/HOOKS.md` for customization.

---

## Folder Structure

```
.uatu/
├── config/
│   ├── project.md         # Project settings
│   ├── architecture.md    # Tech overview (auto-generated)
│   └── constitution.md    # AI principles
├── guides/                 # Framework documentation
├── hooks/                  # Automation scripts
├── tools/                  # Utilities
└── delivery/
    └── sprints/           # Feature specs and tasks
```

---

## MCP Servers

| Server | Required For |
|--------|--------------|
| `sequential-thinking` | Every task |
| `claude-flow` | SQUAD, HIVE, WATCHER |
| `ruv-swarm` | BRAIN, WATCHER |

Run `uatu-setup` to install.
