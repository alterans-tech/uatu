# Tool Selection Guide

**Purpose:** Choose the right tool for the task. Native tools vs MCP tools vs agents.

> **Load when:** Unsure whether to use a native tool, MCP tool, or spawn an agent.

---

## Decision Tree

```
                              TASK
                                │
                ┌───────────────┼───────────────┐
                ▼               ▼               ▼
           FILE OPS        SEARCH/FIND      COORDINATION
                │               │               │
                ▼               ▼               ▼
         Native Tools     Native Tools    MCP/Agents
```

---

## Native Tools (Always Available)

Use these first. They're fast, reliable, and don't require MCP servers.

### File Operations

| Tool | When to Use | Example |
|------|-------------|---------|
| `Read` | Read file contents | Read a config file |
| `Write` | Create new file | Create new component |
| `Edit` | Modify existing file | Fix a bug |
| `Glob` | Find files by pattern | `**/*.tsx` |
| `Grep` | Search file contents | Find all usages |
| `Bash` | Run commands | `npm test` |

### Task Agents (Native Layer 0 — no MCP needed)

| Subagent | When to Use |
|----------|-------------|
| `Explore` | Quick codebase exploration |
| `general-purpose` | Multi-step research |
| `architect-review` | Architecture decisions |
| `debugger` | Error investigation |
| `researcher` | Deep investigation before implementation |
| `orchestrator-task` | Swarm-scale multi-agent coordination |

**Agent spawning parameters:**

| Parameter | Purpose |
|-----------|---------|
| `isolation: "worktree"` | Give agent its own git worktree — for parallel write agents |
| `run_in_background: true` | Non-blocking execution — agent runs while you continue |
| `maxTurns` | Limit agentic turns — prevents runaway agents and controls cost |
| `model` | Override agent's default model — use haiku for cheap read-only, opus for critical |
| `name` | Unique name — required for duplicate agents (coder-1, coder-2, ...) |

**Agent Teams** (Layer 0C, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"` required):
- `TeamCreate` / `SendMessage` — agents communicate with each other mid-task
- Agents share a TaskList (via `TodoWrite`/`TodoRead`) for coordination
- Use for SQUAD/HIVE where agents must coordinate, not just run in parallel

**Headless Claude (`claude -p`):**
- Native execution primitive for non-interactive agent tasks
- Available without MCP; useful in scripts and batch workflows

---

## MCP Tools (When Native Isn't Enough)

### Sequential Thinking (`mcp__sequential-thinking__`)

**Always use for:** Task analysis, decision making, complex reasoning

```
mcp__sequential-thinking__sequentialthinking({
  thought: "Analyzing task...",
  thoughtNumber: 1,
  totalThoughts: 5,
  nextThoughtNeeded: true
})
```

### Filesystem MCP (`mcp__filesystem__`)

**Use when:** Need advanced file operations native tools don't support

| Tool | Use Case |
|------|----------|
| `read_multiple_files` | Read many files at once |
| `directory_tree` | Get full tree structure |
| `search_files` | Advanced file search |
| `get_file_info` | File metadata |
| `move_file` | Rename/move files |

### GitHub MCP (`mcp__github__`)

**Use when:** Interacting with GitHub API

| Tool | Use Case |
|------|----------|
| `create_pull_request` | Open PR |
| `get_pull_request` | Read PR details |
| `create_issue` | File issues |
| `search_code` | Search across repos |

### Atlassian MCP (`mcp__atlassian__`)

**Use when:** Interacting with Jira

| Tool | Use Case |
|------|----------|
| `getJiraIssue` | Read issue details |
| `searchJiraIssuesUsingJql` | Search issues |
| `addCommentToJiraIssue` | Post updates |
| `transitionJiraIssue` | Change status |

---

## Coordination Tools (For Multi-Agent Work)

### The Fundamental Law
> **MCP tools ONLY COORDINATE strategy. Claude Code's Agent tool EXECUTES with real agents.**
> Claude Flow tells agents what to do. Agent tool agents actually do it.

### Claude Flow (`mcp__claude-flow__`)

**Use when:** Need shared memory/state coordination (SQUAD/HIVE)

| Tool | Purpose |
|------|---------|
| `swarm_init` | Initialize coordination topology |
| `agent_spawn` | Register agent in swarm (Agent tool still executes it) |
| `task_orchestrate` | Distribute and track work |
| `memory_usage` | Shared state across agents |
| `memory_persist` | Cross-session persistence (HIVE) |
| `swarm_destroy` | Clean up |

### Ruv Swarm (`mcp__ruv-swarm__`)

**Advanced option for SQUAD/HIVE when:** Long-running (no timeout), neural pattern training

| Tool | Purpose |
|------|---------|
| `swarm_init` | Create swarm (no timeout!) |
| `daa_agent_create` | Learning agent with cognitive pattern |
| `neural_train` | Train patterns (up to 100 iterations) |
| `daa_knowledge_share` | Share learnings between agents |

---

## Selection Rules

### Rule 1: Start Simple
```
Native tool → MCP tool → Swarm → Ask user
```

### Rule 2: Match Scope to Tool

| Scope | Tool |
|-------|------|
| Single file | Native (Read/Write/Edit) |
| Few files | Native (Glob/Grep) + Read |
| Many files | MCP filesystem |
| External service | MCP (GitHub/Atlassian) |
| Coordinated work | SQUAD (Agent Teams + Claude Flow MCP) |
| Multi-session persistence | HIVE (SQUAD + memory_persist) |

### Rule 3: Consider Context Window

| Files | Strategy |
|-------|----------|
| 1-3 | Read all |
| 4-10 | Read selectively |
| 10+ | Use Task agent to summarize |

---

## Anti-Patterns

### Don't Do This

| Bad | Good |
|-----|------|
| `Bash: cat file.txt` | `Read: file.txt` |
| `Bash: grep -r "foo"` | `Grep: pattern="foo"` |
| `Bash: find . -name "*.ts"` | `Glob: **/*.ts` |
| MCP for single file read | Native Read tool |
| Swarm for single-file fix | SOLO package |

### Watch For

- **Over-engineering:** Using SQUAD for a one-liner fix
- **Under-engineering:** Using SOLO for complex refactor
- **Tool hopping:** Switching tools mid-task without reason
- **Context overflow:** Reading 50 files instead of searching

---

## Quick Reference

### By Task Type

| Task | Primary Tool |
|------|--------------|
| Fix bug in known file | Read → Edit |
| Find where X is defined | Glob → Read |
| Find all usages of X | Grep |
| Create new component | Write |
| Run tests | Bash |
| Explore codebase | SOLO + Explore/researcher agents |
| Refactor across files | SOLO + orchestrator (parallel coders in worktrees) |
| Agents must coordinate mid-task | SQUAD (Agent Teams + Claude Flow) |
| Multi-day project | HIVE (SQUAD + memory_persist) |
| Neural/long-running | WATCHER (Ruflo CLI) |
| Touching auth/payment/security/migration | Plan mode first (`/plan`), then SOLO |

### By Complexity (Scaling Tiers)

| Complexity | Tier | Package | Tools |
|------------|------|---------|-------|
| Trivial | Micro (1-2) | SOLO | Native tools |
| Simple feature | Small (3-5) | SOLO + orchestrator | Agent tool, parallel + worktree |
| Cross-cutting | Medium (6-12) | SOLO/SQUAD | Batch-spawned agents, worktree isolation |
| Major feature | Large (13-25) | SOLO/SQUAD | Mass parallel agents, all writers in worktrees |
| Mass refactoring | Swarm (25+) | SOLO + orchestrator | Maximum parallelism, mandatory worktrees |
| Agents need to talk | Any tier | SQUAD | Agent Teams + Claude Flow MCP |
| Multi-session | Any tier | HIVE | SQUAD + memory_persist |
| Self-learning | Any tier | WATCHER | Ruflo CLI + HIVE |

Package choice is about **coordination model** (do agents need to talk?), not agent count. All packages support dynamic scaling.

---

*Right tool, right job, right time.*
