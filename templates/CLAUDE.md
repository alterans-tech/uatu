# Project Instructions

## MANDATORY - Uatu Framework (DO NOT SKIP)

**You MUST use the Uatu framework for ALL tasks. No exceptions.**

### Hard Rules

1. **Read guides first** - Before any work, read `.uatu/guides/SEQUENTIAL-THINKING.md` and `.uatu/guides/TOOL-SELECTION.md`
2. **Sequential Thinking** - ALWAYS use Sequential Thinking MCP for every task, even "simple" ones
3. **Package Selection** - Select appropriate package based on task characteristics:
   - SOLO → Single file, clear task
   - SCOUT → Need to investigate/explore first
   - SQUAD → Multiple coordinated subtasks
   - BRAIN → Pattern learning (single session)
   - HIVE → Multi-session, persist context
   - WATCHER → Learning + persistence combined
4. **All artifacts in `.uatu/`** - NEVER create files in random places. All deliverables, specs, configs go in `.uatu/` folder
5. **Use Speckit commands** - For specifications, use `/speckit.*` commands, never create spec files manually

### Folder Structure

```
.uatu/
├── config/          # Project configuration
├── guides/          # Framework documentation
├── tools/           # Utilities (time-tracking, etc.)
└── delivery/        # All deliverables
    └── sprints/     # Feature specs, tasks, plans
```

---

## Session Start Protocol

**If this is a new session and the project is not yet configured:**

1. Ask the user: "What are you building? Please describe your project briefly."
2. Based on their response, update this CLAUDE.md with:
   - Project name and description
   - Tech stack
   - Key conventions
3. Read `.uatu/config/project.md` and update if needed

**If this is an existing configured project:**

1. Read `.uatu/config/project.md` for project context
2. Read mandatory guides:
   - `.uatu/guides/SEQUENTIAL-THINKING.md`
   - `.uatu/guides/TOOL-SELECTION.md`
3. Proceed with user's task using Sequential Thinking

---

## Project Info

<!-- FILL THIS SECTION AFTER ASKING THE USER -->

- **Name:** [Ask user]
- **Description:** [Ask user]
- **Tech Stack:** [Ask user]
- **Repository:** [Detect from git]

---

## Conventions

<!-- FILL THIS SECTION BASED ON USER'S PROJECT -->

- **Branch naming:** `{type}/{description}` (e.g., `feat/user-auth`, `fix/login-bug`)
- **Commit format:** Angular convention (`feat:`, `fix:`, `docs:`, etc.)

---

## Quick Reference

| Task Type | Package | First Action |
|-----------|---------|--------------|
| Fix bug | SOLO | Sequential Thinking → identify scope |
| Explore codebase | SCOUT | Sequential Thinking → spawn Explore agents |
| Multi-file refactor | SQUAD | Sequential Thinking → swarm_init |
| Learn patterns | BRAIN | Sequential Thinking → daa_agent_create |
| Multi-day work | HIVE | Sequential Thinking → memory_namespace |
| Learn + remember | WATCHER | Sequential Thinking → both systems |

---

## Tools

### Time Tracking

Ask "How much time have I worked?" to see work sessions.

**Manual usage:**
```bash
python .uatu/tools/time-tracking/worklog.py --project $(pwd) --tz -3
```

---

## Guides Reference

| Guide | Purpose |
|-------|---------|
| `.uatu/guides/SEQUENTIAL-THINKING.md` | Task analysis patterns |
| `.uatu/guides/TOOL-SELECTION.md` | Choosing right tools |
| `.uatu/guides/WORKFLOW.md` | Naming, Jira, Speckit |
| `.uatu/guides/CLAUDE-FLOW-SELECTION.md` | SQUAD/BRAIN/HIVE details |
| `.uatu/guides/WATCHER.md` | Learning + persistence |
| `.uatu/guides/AGENTS-GUIDE.md` | Agent selection |

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
| `/speckit.checklist` | Requirements quality check |
| `/speckit.constitution` | Define project principles |
