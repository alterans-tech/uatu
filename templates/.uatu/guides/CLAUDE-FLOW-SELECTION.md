# Claude Flow Selection Guide

**Purpose:** Understand when and why to use SQUAD, BRAIN, or HIVE packages.

---

## Two MCP Implementations

| Implementation | Package | Strength |
|----------------|---------|----------|
| `mcp__claude-flow__` | SQUAD, HIVE | Core orchestration, memory, workflows, persistence |
| `mcp__ruv-swarm__` | BRAIN | No timeout, neural networks, learning agents |

---

## SQUAD — Claude Flow

**When:** Coordinated multi-file work, 5-8 agents, shared state

### Core Tools

```
swarm_init(topology, maxAgents, strategy)
  → topology: hierarchical, mesh, ring, star
  → strategy: balanced, specialized, adaptive

agent_spawn(type, name, capabilities)
  → types: researcher, coder, analyst, optimizer, coordinator, reviewer, tester, documenter, monitor, specialist

task_orchestrate(task, strategy, priority)
  → strategy: parallel, sequential, adaptive
  → priority: low, medium, high, critical

memory_usage(action, key, value, namespace, ttl)
  → actions: store, retrieve, list, delete, search

swarm_destroy(swarmId)
  → Always call when done
```

### Typical Flow

```
1. swarm_init(topology="star", maxAgents=5)
2. agent_spawn × N (one per concern)
3. task_orchestrate(strategy="parallel")
4. memory_usage(action="store", namespace="task-XXX")
5. swarm_destroy()
```

---

## BRAIN — Ruv Swarm

**When:** Long-running (>10 min), learning, pattern recognition, batch processing

### Why BRAIN over SQUAD?

- **No timeout** — Tasks can run for hours
- **Neural networks** — Pattern training and prediction
- **DAA agents** — Self-organizing, learn from feedback
- **Cognitive patterns** — Different thinking styles
- **WASM/SIMD** — 4x faster pattern matching

### Core Tools

```
swarm_init(topology, maxAgents, strategy)
  → Same as SQUAD but NO TIMEOUT

daa_agent_create(id, capabilities, cognitivePattern, learningRate)
  → cognitivePattern: convergent, divergent, lateral, systems, critical, adaptive

daa_cognitive_pattern(agent_id, action, pattern)
  → action: analyze, change

daa_knowledge_share(source_agent, target_agents, knowledgeDomain)
  → Propagate learnings between agents

neural_train(agentId, iterations)
  → Up to 100 iterations, no timeout
```

### Cognitive Patterns

| Pattern | Thinking Style | Best For |
|---------|---------------|----------|
| **convergent** | Focused, analytical | Known problems, debugging |
| **divergent** | Creative, exploratory | Unknown problems, brainstorming |
| **lateral** | Non-linear connections | Creative solutions |
| **systems** | Holistic, interconnected | Architecture, dependencies |
| **critical** | Evaluative, skeptical | Security audit, code review |
| **adaptive** | Context-switching | Mixed tasks |

### Typical Flow

```
1. swarm_init(topology="mesh")
2. daa_agent_create(cognitivePattern="divergent")  # unknown problem
3. task_orchestrate(task, strategy="adaptive")
4. daa_knowledge_share()  # spread learnings
5. daa_cognitive_pattern(action="change", pattern="convergent")  # focus on solution
```

---

## HIVE — Claude Flow (Hierarchical + Persistent)

**When:** Multi-phase projects, need persistence across sessions

### Why HIVE over SQUAD/BRAIN?

- **Hierarchical topology** — Queen coordinator with worker agents
- **Session persistence** — Memory persists via `memory_persist`
- **Namespace isolation** — Project-wide memory namespaces
- **Coordination sync** — State sync across agents

### Core Tools

```
swarm_init(topology="hierarchical", maxAgents, strategy)
  → Hierarchical creates Queen-led structure

agent_spawn(type="coordinator", name="Queen")
  → First agent becomes the Queen coordinator

agent_spawn(type="researcher|coder|analyst", name)
  → Subsequent agents report to Queen

memory_persist(sessionId)
  → Cross-session persistence

memory_namespace(namespace, action)
  → Create/manage project-wide namespaces

coordination_sync(swarmId)
  → Sync agent state
```

### Typical Flow

```
# Multi-phase project
1. swarm_init(topology="hierarchical", maxAgents=8)
2. agent_spawn(type="coordinator", name="Queen")  # Leader
3. agent_spawn(type="researcher") × N  # Workers
4. task_orchestrate(strategy="adaptive")
5. memory_persist(sessionId="project-X")  # Save state
6. # Next session: memory continues from where left off

# Long-running coordinated work
1. swarm_init(topology="hierarchical")
2. memory_namespace(namespace="sprint-2024-01", action="create")
3. task_orchestrate(task, priority="high")
4. coordination_sync()  # Ensure all agents aligned
5. memory_persist()  # Save progress
```

---

## Decision Matrix

| Constraint | Package |
|------------|---------|
| < 10 minutes, standard work | SQUAD |
| > 10 minutes, might timeout | BRAIN |
| Need agents to learn/adapt | BRAIN |
| Unknown problem, need exploration | BRAIN (divergent) |
| Security audit, skeptical review | BRAIN (critical) |
| Multi-session project | HIVE |
| Need central coordinator | HIVE (hierarchical) |
| Cross-session persistence | HIVE |

---

## Common Patterns

### Sprint Review
```
Package: SQUAD
swarm_init(topology="hierarchical")
agent_spawn(type="researcher") × N  # one per Jira issue
task_orchestrate(strategy="parallel")
memory_usage(namespace="sprint-YYYY-MM-DD")
```

### Production Debugging
```
Package: BRAIN
daa_agent_create(cognitivePattern="divergent")  # explore unknowns
task_orchestrate()  # no timeout
daa_cognitive_pattern(pattern="convergent")  # focus once found
```

### Security Audit
```
Package: BRAIN
daa_agent_create(cognitivePattern="critical")  # skeptical evaluation
task_orchestrate()  # long-running scan
daa_knowledge_share()  # propagate found vulnerabilities
```

### Multi-Phase Feature
```
Package: HIVE
swarm_init(topology="hierarchical")
agent_spawn(type="coordinator", name="Queen")
agent_spawn(type="coder") × N
task_orchestrate(task="Implement feature X")
memory_persist()  # Save for next session
```

---

## Tool Reference

### SQUAD Tools (mcp__claude-flow__)

**Swarm Management**
| Tool | Purpose |
|------|---------|
| `swarm_init` | Create swarm (topology, maxAgents, strategy) |
| `swarm_status` | Health metrics, agent count, queue size |
| `swarm_monitor` | Real-time monitoring stream |
| `swarm_scale` | Add/remove agents dynamically |
| `swarm_destroy` | Graceful shutdown, save state |
| `topology_optimize` | Auto-restructure based on task patterns |
| `coordination_sync` | Force sync across agents |

**Agent Management**
| Tool | Purpose |
|------|---------|
| `agent_spawn` | Create agent (researcher, coder, analyst, optimizer, coordinator, reviewer, tester, documenter, monitor, specialist) |
| `agent_list` | List active agents with status |
| `agent_metrics` | Performance metrics per agent |
| `agents_spawn_parallel` | **10-20x faster** batch spawn |
| `load_balance` | Distribute tasks by capability |

**Task Orchestration**
| Tool | Purpose |
|------|---------|
| `task_orchestrate` | Main entry (task, strategy, priority, dependencies) |
| `task_status` | Progress, current step, errors |
| `task_results` | Final output from completed task |

**Memory**
| Tool | Purpose |
|------|---------|
| `memory_usage` | Store/retrieve/list/delete/search with namespace and TTL |
| `memory_search` | Pattern-based search |
| `memory_persist` | Cross-session persistence |
| `memory_namespace` | Create/delete/list namespaces |
| `memory_backup` | Backup to file |
| `memory_restore` | Restore from backup |

**Workflow**
| Tool | Purpose |
|------|---------|
| `workflow_create` | Custom workflow with triggers |
| `workflow_execute` | Run predefined workflow |
| `parallel_execute` | Execute multiple tasks in parallel |
| `batch_process` | Batch processing |

---

### BRAIN Tools (mcp__ruv-swarm__)

**All SQUAD-equivalent tools but NO TIMEOUT, plus:**

**DAA (Decentralized Autonomous Agents)**
| Tool | Purpose |
|------|---------|
| `daa_init` | Initialize DAA service (persistenceMode, enableLearning) |
| `daa_agent_create` | Create with cognitivePattern and learningRate |
| `daa_agent_adapt` | Trigger adaptation from feedback |
| `daa_workflow_create` | Autonomous workflow with dependencies |
| `daa_workflow_execute` | Execute with agent selection |
| `daa_knowledge_share` | Propagate learnings between agents |
| `daa_learning_status` | Check learning progress |
| `daa_cognitive_pattern` | Analyze or change thinking style |
| `daa_meta_learning` | Transfer learning across domains |
| `daa_performance_metrics` | Comprehensive DAA metrics |

**Neural**
| Tool | Purpose |
|------|---------|
| `neural_status` | Model status |
| `neural_train` | Train patterns (up to 100 iterations) |
| `neural_patterns` | Analyze cognitive patterns |

**Performance**
| Tool | Purpose |
|------|---------|
| `benchmark_run` | Run benchmarks (wasm, swarm, agent, task) |
| `features_detect` | Detect capabilities (wasm, simd, memory) |
| `memory_usage` | Detailed memory stats |

---

### HIVE Tools (mcp__claude-flow__ with hierarchical topology)

**HIVE uses the same `mcp__claude-flow__` tools as SQUAD but with different configuration:**

| Tool | HIVE Usage |
|------|------------|
| `swarm_init` | topology: `hierarchical` (creates Queen-led structure) |
| `agent_spawn` | First agent as `coordinator` (Queen), then workers |
| `memory_persist` | Cross-session persistence |
| `memory_namespace` | Project-wide namespace management |
| `coordination_sync` | Sync agent state across hierarchy |
| `memory_backup` | Backup to file for disaster recovery |
| `memory_restore` | Restore from backup |

**Key Difference from SQUAD:**
- SQUAD uses `star` or `mesh` topology for flat coordination
- HIVE uses `hierarchical` topology with Queen coordinator
- HIVE emphasizes `memory_persist` for cross-session state

---

*Match package capabilities to task constraints.*
