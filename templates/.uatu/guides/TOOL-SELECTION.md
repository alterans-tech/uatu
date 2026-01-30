# Tool Selection Guide

**Purpose:** Choose the right tool for the task. Native tools vs MCP tools vs agents.

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

### Task Agents

| Subagent | When to Use |
|----------|-------------|
| `Explore` | Quick codebase exploration |
| `general-purpose` | Multi-step research |
| `architect-review` | Architecture decisions |
| `debugger` | Error investigation |

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

## Swarm Tools (For Multi-Agent Work)

### Claude Flow (`mcp__claude-flow__`)

**Use when:** Need coordinated multi-agent work (SQUAD/HIVE)

| Tool | Purpose |
|------|---------|
| `swarm_init` | Create swarm |
| `agent_spawn` | Add agent |
| `task_orchestrate` | Distribute work |
| `memory_usage` | Shared state |
| `swarm_destroy` | Clean up |

### Ruv Swarm (`mcp__ruv-swarm__`)

**Use when:** Long-running tasks, learning (BRAIN)

| Tool | Purpose |
|------|---------|
| `swarm_init` | Create swarm (no timeout!) |
| `daa_agent_create` | Learning agent |
| `neural_train` | Train patterns |
| `daa_knowledge_share` | Share learnings |

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
| Coordinated work | Swarm (SQUAD/BRAIN/HIVE) |

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
| Refactor across files | SQUAD |
| Deep investigation | BRAIN |
| Long-running analysis | BRAIN |
| Multi-day project | HIVE |

### By Complexity

| Complexity | Package | Tools |
|------------|---------|-------|
| Trivial | SOLO | Native |
| Simple | SOLO | Native + MCP |
| Medium | SCOUT | Task agents |
| Complex | SQUAD | Claude Flow |
| Very Complex | BRAIN | Ruv Swarm |
| Multi-phase | HIVE | Claude Flow + persist |

---

*Right tool, right job, right time.*
