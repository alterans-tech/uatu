# Uatu - The Watcher

AI orchestration framework.

---

## Before Any Task

1. **Read project config** — `.uatu/config/project.md`
2. **Select package** — Based on task characteristics
3. **Consider Sequential Thinking** — For complex or ambiguous tasks

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
| **Sequential Thinking** | Optional — use for complex or ambiguous tasks |
| **Package Selection** | Choose based on task needs |
| **Artifacts in `.uatu/`** | All deliverables go in `.uatu/delivery/` |
| **Use Speckit** | Run `/speckit.*` commands for specs |

---

## Package Selection

All packages support dynamic scaling (1 to 25+ agents). Choose by **coordination model**, not agent count:

| Package | Coordination | Use When | Command |
|---------|-------------|----------|---------|
| **SOLO** | Hub-and-spoke (no inter-agent talk) | Independent parallel work at any scale | `/orchestrate` |
| **SQUAD** | Peer messaging + shared memory | Agents need to coordinate mid-task | `/squad` |
| **HIVE** | SQUAD + session persistence (experimental) | Work spans multiple sessions | Manual setup |

```
Can you give each agent everything it needs before it starts?
  YES → SOLO (+ orchestrator-task for multi-agent, any scale)
  NO  → Agents discover things mid-work that other agents need
        → SQUAD → need persistence across sessions? → HIVE
```

---

## Guides

| Trigger | Read This |
|---------|-----------|
| Complex or ambiguous task | `.uatu/guides/SEQUENTIAL-THINKING.md` |
| Unsure which tool/package | `.uatu/guides/TOOL-SELECTION.md` |
| Using SQUAD/HIVE | `.uatu/guides/SQUAD-GUIDE.md` |
| Spawning agents | `.uatu/guides/AGENTS-GUIDE.md` |
| Jira tasks, naming, specs | `.uatu/guides/WORKFLOW.md` |
| Customizing hooks | `.uatu/guides/HOOKS.md` |

---

## Agent Commands

| When | Command | What It Does |
|------|---------|-------------|
| Multi-agent orchestration | `/orchestrate swarm <desc>` | Spawns orchestrator-task agent for decomposition + parallel execution |
| Feature workflow | `/orchestrate feature <desc>` | Chain: planner → [coder + tester] → reviewer |
| Bug fix | `/orchestrate bugfix <desc>` | Chain: debugger → coder → tester → reviewer |
| Agent team (peer coordination) | `/squad <desc>` | Creates Agent Team with TeamCreate + SendMessage |
| Test-driven development | `/tdd <desc>` | Spawns tester agent with TDD workflow |
| End-to-end tests | `/e2e <desc>` | Spawns tester agent with Playwright workflow |
| Code review | `/code-review` | Spawns reviewer agent on uncommitted changes |

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
| Convert tasks to GitHub Issues | `/speckit.taskstoissues` |

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
| `session-restore.sh` | SessionStart | Restore last session checkpoint |
| `enforce-sequential-thinking.sh` | UserPromptSubmit | Remind to use ST |
| `format-code.sh` | PostToolUse | Auto-format code |
| `prevent-sensitive-writes.sh` | PreToolUse | Block writes to sensitive files |
| `update-jira.sh` | Stop | Update Jira status |
| `session-checkpoint.sh` | Stop | Save session summary |
| `cost-tracking.sh` | Stop | Log session end for cost review |

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
| `sequential-thinking` | Complex/ambiguous tasks (optional) |
| `claude-flow` | SQUAD, HIVE (shared memory, strategy coordination) |

Run `uatu-setup` to install.
