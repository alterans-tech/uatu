# SQUAD Guide

**Purpose:** Understand and use the SQUAD, HIVE, and WATCHER packages for multi-agent coordinated work.

---

## Package Selection: Coordination Model, Not Agent Count

All packages support dynamic scaling (1 to 25+ agents). The choice is about **how agents coordinate**, not how many you need.

| | SOLO | SQUAD | HIVE | WATCHER |
|---|---|---|---|---|
| **Coordination** | Hub-and-spoke only | Peer-to-peer messaging | Peer + state sync | Peer + learning |
| **Communication** | Agent → orchestrator → agent | Agent ↔ Agent (SendMessage) | Same + session resume | Same + knowledge sharing |
| **Memory** | None (stateless) | Shared volatile (within session) | Persistent (across sessions) | Learning (patterns evolve) |
| **Scaling** | Dynamic (all tiers) | Dynamic (all tiers) | Dynamic (all tiers) | Dynamic (all tiers) |
| **Infrastructure** | Nothing extra | Agent Teams env var + Claude Flow MCP | + memory_persist | + Ruflo CLI |

### Decision Tree

```
Need multiple agents?
  NO  → SOLO (single agent)
  YES → Do agents need to communicate with EACH OTHER mid-task?
          NO  → SOLO + orchestrator-task (hub-and-spoke, any scale)
          YES → Do you need state to persist across sessions?
                  NO  → SQUAD (peer messaging + shared memory)
                  YES → Do you need learning/neural patterns?
                          NO  → HIVE (SQUAD + persistence)
                          YES → WATCHER (HIVE + Ruflo CLI)
```

### The Decision Rule

> **Can the orchestrator give each agent everything it needs before it starts?**
>
> YES → SOLO. NO → SQUAD.

90% of tasks are SOLO. Agents with clear scope and full upfront context don't need to talk to each other.

### SOLO Examples (independent work — orchestrator carries all context)

**Refactor 10 files with same pattern:** 10 coders, each gets "apply this pattern to this file." No agent needs information from another. Orchestrator gave them everything.

**Build auth feature with known contracts:** Batch 1 researches patterns. Orchestrator passes findings to Batch 2: coder-1 (middleware), coder-2 (routes), coder-3 (service). Each has full context.

**Write tests for 5 modules:** 5 testers, each gets module path + expected behavior. Completely independent.

**Code review + security audit + performance check:** 3 reviewers analyzing the same code independently. Results combined by orchestrator.

**Migrate 20 API endpoints v1→v2:** 20 coders, same transformation pattern, different files. Assembly line.

### SQUAD Examples (agents discover things that change what other agents do)

**Frontend + backend building a feature where the API contract doesn't exist yet:** Backend decides response shape mid-work, sends to frontend via SendMessage. Frontend requests an extra field. They converge on the contract together.

**Cross-service debugging:** Debugger-1 finds "service A sends malformed payload at 14:32." Sends message to debugger-2: "check service B logs around that time." One agent's discovery redirects the other.

**Design negotiation:** Two architects propose different approaches, discuss trade-offs via messaging, converge on a hybrid. Output is a negotiated consensus.

### HIVE Examples (same as SQUAD but across multiple sessions)

**Multi-day migration:** Day 1 research + design (save state). Day 2 implementation phase 1 (restore, continue). Day 3 testing + cleanup.

### WATCHER Examples (learning accumulates over time)

**Repeated code reviews across sprints:** Patterns from past reviews improve future ones. The system learns your codebase conventions.

---

## The Three-Layer Model

```
Layer 0: Claude Code Native (always available)
  ├─ Mode A: Single Agent (default)
  ├─ Mode B: Subagents via Agent tool (orchestrator-task pattern)
  └─ Mode C: Agent Teams (TeamCreate/SendMessage)
             Enabled by: CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS="1"

Layer 1: MCP Coordination (requires .claude/settings.json)
  ├─ Claude Flow MCP (shared memory, swarm topology)
  └─ Ruv Swarm MCP (neural patterns, no-timeout execution)

Layer 2: Ruflo CLI (requires npm install npx claude-flow@v3alpha)
  ├─ Background workers
  ├─ Neural pattern training
  └─ Session tracking & self-learning
```

**Packages map to layers:**

| Package | Layers |
|---------|--------|
| SOLO | 0A or 0B (orchestrator-task) |
| SQUAD | 0C + 1 |
| HIVE | 0C + 1 + persistence |
| WATCHER | 0C + 1 + 2 |

---

## The Fundamental Law

> **MCP tools ONLY COORDINATE strategy. Claude Code's Agent tool EXECUTES with real agents.**

Claude Flow (`mcp__claude-flow__`) tells agents what to do and stores shared memory.
The `Agent` tool actually spawns real agents that do the work.

These are designed to work together, not as alternatives.

---

## Dynamic Scaling

All packages use the same scaling tier system. The orchestrator (or lead agent) decomposes the task and selects a tier:

| Tier | Agents | When | Worktree Isolation |
|------|--------|------|-------------------|
| **Micro** | 1-2 | Single file, single concern | No |
| **Small** | 3-5 | Feature touching 2-5 files | Write agents only |
| **Medium** | 6-12 | Cross-cutting feature, multi-module | Write agents only |
| **Large** | 13-25 | Major feature, system migration | All write agents |
| **Swarm** | 25+ | Org-wide refactoring, mass changes | Mandatory for all |

### Tier Selection

```
1. Decompose task into work units
2. Count independent units, classify as READ or WRITE
3. read_agents  = count(READ units)
   write_agents = count(WRITE units)
   review_agents = ceil(write_agents / 4)
   total = read_agents + write_agents + review_agents
4. Select tier from total
```

---

## Duplicate Agent Spawning

You CAN and SHOULD spawn multiple agents of the same type when the task calls for it.

### Naming Convention

```
{agent-type}-{index}
```

Examples: `coder-1`, `coder-2`, `coder-3`, `tester-1`, `tester-2`

### When to Duplicate

| Scenario | Pattern |
|----------|---------|
| 8 files need refactoring | 8 `coder-N` agents, one per file |
| 5 modules need tests | 5 `tester-N` agents, one per module |
| 3 areas to investigate | 3 `researcher-N` agents, each with a focus |
| Large codebase audit | 4 `security-auditor-N` agents, each scanning a directory |

### Example: 6 Coders in Parallel

```
Agent(subagent_type="coder", name="coder-1", prompt="Refactor src/services/auth.ts to use new error pattern...", isolation="worktree", run_in_background=true)
Agent(subagent_type="coder", name="coder-2", prompt="Refactor src/services/user.ts to use new error pattern...", isolation="worktree", run_in_background=true)
Agent(subagent_type="coder", name="coder-3", prompt="Refactor src/services/payment.ts to use new error pattern...", isolation="worktree", run_in_background=true)
Agent(subagent_type="coder", name="coder-4", prompt="Refactor src/services/notification.ts to use new error pattern...", isolation="worktree", run_in_background=true)
Agent(subagent_type="coder", name="coder-5", prompt="Refactor src/routes/api.ts to use new error pattern...", isolation="worktree", run_in_background=true)
Agent(subagent_type="coder", name="coder-6", prompt="Refactor src/routes/admin.ts to use new error pattern...", isolation="worktree", run_in_background=true)
```

All 6 spawn in a SINGLE message and execute in parallel. Each gets its own worktree — no conflicts.

---

## Worktree Isolation

### What It Does

`isolation: "worktree"` gives each agent an isolated copy of the repository via `git worktree`. Agents can edit files in parallel without conflicts.

### Which Agents Need It

| Agent Category | Needs Worktree? | Reason |
|----------------|----------------|--------|
| coder, fullstack-developer, refactoring-specialist | **YES** | Writes/modifies files |
| tester (creating test files) | **YES** | Creates new test files |
| researcher, Explore, architect-review | No | Read-only |
| code-reviewer, security-auditor | No | Read-only analysis |
| debugger (investigating) | No | Read-only |
| debugger (applying fix) | **YES** | Writes fix to files |

### How It Works

- Worktree auto-created at agent start
- If agent makes no changes → worktree auto-cleaned up
- If agent makes changes → worktree persists, changes available for merge
- Multiple worktrees can exist simultaneously (one per write agent)

---

## Batch Spawning

**CRITICAL:** Spawn all parallel agents in a SINGLE message. Multiple `Agent` tool calls in one response execute truly in parallel.

### Anti-Pattern (slow)
```
# DON'T: One agent per turn
Turn 1: Agent(name="coder-1", ...)
Turn 2: Agent(name="coder-2", ...)   # waits for coder-1 to finish!
Turn 3: Agent(name="coder-3", ...)   # waits for coder-2 to finish!
```

### Correct Pattern (fast)
```
# DO: All agents in one turn
Agent(name="coder-1", ..., run_in_background=true)
Agent(name="coder-2", ..., run_in_background=true)
Agent(name="coder-3", ..., run_in_background=true)
# All three start simultaneously
```

---

## SQUAD — Peer-to-Peer Coordination

**Use when:** agents need to communicate with each other mid-task, not just report to the orchestrator.

### Setup (settings.json)

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### Typical SQUAD Flow

```
1. Sequential Thinking → identify subtasks and agent roles
2. swarm_init(topology="star", strategy="specialized") → register coordination
3. TeamCreate(team=[agentA, agentB]) → agents can now message each other
4. Agent(agentA, "implement service X", team_name="my-team", run_in_background=true)
   Agent(agentB, "implement tests for X", team_name="my-team", run_in_background=true)
5. agentA sends SendMessage to agentB when service interface is ready
6. memory_usage(action="store", key="service-X-complete") → shared state
7. swarm_destroy() → cleanup
```

### Claude Flow Tools for SQUAD

**Swarm Management:**

| Tool | Purpose |
|------|---------|
| `swarm_init` | Create swarm (topology, strategy) |
| `swarm_status` | Health metrics, agent count, queue size |
| `task_orchestrate` | Main entry (task, strategy, priority) |
| `swarm_destroy` | Graceful shutdown |

**Memory (shared state):**

| Tool | Purpose |
|------|---------|
| `memory_usage` | Store/retrieve/list/delete with namespace and TTL |
| `memory_search` | Pattern-based search |

**Agent Coordination:**

| Tool | Purpose |
|------|---------|
| `agent_spawn` | Register agent type in swarm |
| `agent_list` | List active agents with status |
| `load_balance` | Distribute tasks by capability |
| `parallel_execute` | Execute multiple tasks simultaneously |

---

## HIVE — Persistent Multi-Session Work

**Use when:** Project spans multiple sessions; agents must resume where they left off.

### What HIVE Adds to SQUAD

- `memory_persist` — state survives session end
- `memory_namespace` — project-wide named memory areas
- `coordination_sync` — sync agent state across hierarchy
- Hierarchical topology (Queen coordinator pattern)

### Typical HIVE Flow

```
# Session 1
1. swarm_init(topology="hierarchical")
2. agent_spawn(type="coordinator", name="Queen")
3. memory_namespace(namespace="project-X", action="create")
4. task_orchestrate(task="Phase 1: implement auth")
5. memory_persist(sessionId="project-X-session-1") → save state
# Session ends

# Session 2
1. swarm_init(topology="hierarchical")
2. memory_restore(sessionId="project-X-session-1") → resume state
3. task_orchestrate(task="Phase 2: implement dashboard")
4. memory_persist(sessionId="project-X-session-2")
```

### What Persists, What Doesn't

| Persists (via memory_persist) | Does NOT persist |
|-------------------------------|-----------------|
| Shared memory values | Agent instances |
| Task completion state | Running processes |
| Project namespace data | Tool call results |
| Session notes (via checkpoint hook) | Claude's context window |

### Additional HIVE Tools

| Tool | Purpose |
|------|---------|
| `memory_persist` | Cross-session persistence |
| `memory_namespace` | Create/manage project-wide namespaces |
| `coordination_sync` | Sync agent state |
| `memory_backup` | Backup to file |
| `memory_restore` | Restore from backup |

---

## WATCHER — Self-Learning + Background Workers

**Use when:** Need neural pattern training, background workers, or full Ruflo CLI capabilities.

WATCHER = HIVE + Ruflo CLI features:
- `neural_train` — up to 100 iterations, no timeout
- `daa_agent_create` — learning agents with cognitive patterns
- `daa_knowledge_share` — propagate learnings between agents
- Background worker processes (Ruflo CLI manages these)

For WATCHER setup, refer to Ruflo CLI documentation.

---

## TMUX Display (Optional)

TMUX enables side-by-side agent monitoring in terminal split panes.

### Requirements

1. **Running inside tmux** — start a session first (`tmux new -s mysession`)
2. **Agent Teams enabled** — env var in settings

### Configuration (.claude/settings.json)

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "teammateMode": "tmux"
}
```

Alternatively, use the older format:
```json
{
  "preferences": {
    "tmuxSplitPanes": true
  }
}
```

Valid `teammateMode` values: `auto` (default — tmux if available), `in-process`, `tmux`.

### Important Notes

- TMUX panes only work for **teammates** (Agent with `team_name`), NOT for subagents (Agent tool without `team_name`)
- Only enable in standalone terminal sessions — breaks in IDE terminals and CI environments
- Without TMUX, agents run normally — TMUX is display-only, not functional

---

## ruv-swarm: Advanced Option

`mcp__ruv-swarm__` is an advanced option inside SQUAD/HIVE (not a separate package).

**Use ruv-swarm when:**
- Tasks exceed 10 minutes (no timeout constraint)
- Need neural pattern training (`neural_train`)
- Need DAA learning agents (`daa_agent_create`)
- Need WASM/SIMD performance acceleration

**ruv-swarm cognitive patterns:**

| Pattern | Thinking Style | Best For |
|---------|---------------|----------|
| `convergent` | Focused, analytical | Known problems, debugging |
| `divergent` | Creative, exploratory | Unknown problems, brainstorming |
| `lateral` | Non-linear connections | Creative solutions |
| `systems` | Holistic, interconnected | Architecture, dependencies |
| `critical` | Evaluative, skeptical | Security audit, code review |
| `adaptive` | Context-switching | Mixed tasks |

---

## Cost Management

### Agent Model Selection

Use cheaper models for routine work, expensive models for critical decisions:

| Agent Role | Recommended Model | Cost |
|------------|------------------|------|
| Explore, researcher | haiku | $ |
| coder, tester, code-reviewer | sonnet | $$ |
| architect-review, security-auditor | opus | $$$ |

### Scaling Safety Caps

If your project has budget concerns, document caps in `.uatu/config/project.md`:

```markdown
## Scaling Limits
- Max total agents per task: 25
- Max write agents per task: 12
- Max turns per agent: 30
- Default worker model: sonnet
```

The orchestrator should respect these limits during tier selection.

---

## Quick Reference

| Situation | Package | Coordination |
|-----------|---------|--------------|
| Single file, clear task | **SOLO** | None |
| Multi-file, independent work units | **SOLO + orchestrator** | Hub-and-spoke |
| Agents need to talk mid-task | **SQUAD** | Peer messaging |
| Work spans multiple sessions | **HIVE** | Peer + persistence |
| Neural learning, background workers | **WATCHER** | Peer + learning |

---

*MCP coordinates. Agent tool executes. Both together = SQUAD.*
