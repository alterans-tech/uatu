# WATCHER Package Guide

> Pattern learning with persistent memory across sessions

---

## Overview

WATCHER is the most powerful package in Uatu, combining:
- **BRAIN** (ruv-swarm): Neural patterns, DAA learning, cognitive diversity
- **HIVE** (claude-flow): Persistent memory, hierarchical coordination

Use WATCHER when you need patterns learned in one session to be remembered and applied in future sessions.

---

## When to Use WATCHER

### Selection Criteria (Based on Task Needs)

Use WATCHER when your task requires BOTH:
1. **Pattern Learning** - Need to understand and learn patterns
2. **Cross-Session Persistence** - Need those patterns available in future sessions

| Task Characteristic | Use WATCHER? |
|---------------------|--------------|
| Learning patterns for future sessions | Yes |
| Onboarding to a codebase long-term | Yes |
| Building institutional knowledge | Yes |
| Single-session deep analysis | No → Use BRAIN |
| Multi-session but no learning | No → Use HIVE |
| Quick investigation | No → Use SCOUT |

### Combining with Thinking Keywords

Thinking keywords (think, think harder, ultrathink) are **orthogonal** to package selection. Combine them for deeper analysis:

```
ultrathink + WATCHER = Maximum depth learning with persistence
think harder + WATCHER = Thorough learning with persistence
```

### Use Cases

1. **Multi-Day Feature Development**
   ```
   Day 1: Analyze codebase, learn patterns
   Day 2: Continue with learned patterns
   Day 3: Complete with pattern-informed review
   ```

2. **Recurring Project Work**
   ```
   Week 1: Work on Project A, learn its patterns
   Week 3: Return to Project A, patterns remembered
   ```

3. **Cross-Project Pattern Transfer**
   ```
   Project A: Learn "how this team writes code"
   Project B: Apply learned patterns to similar project
   ```

---

## Architecture

```
                    WATCHER
                       │
         ┌─────────────┴─────────────┐
         │                           │
    claude-flow                  ruv-swarm
    (PERSISTENCE)                (LEARNING)
         │                           │
    ┌────┴────┐              ┌───────┴───────┐
    │         │              │               │
  Memory   Queen          Neural          DAA
  Store   Coord          Patterns       Agents
         │                               │
    ┌────┴────┐                    cognitivePattern:
    │    │    │                    - convergent
   W1   W2   W3                    - divergent
  (workers)                        - systems
                                   - critical
                                   - adaptive
```

**Key Principle**: claude-flow is the **memory of record**, ruv-swarm is the **learning engine**

---

## Orchestration Protocol

### Session Start

```bash
# 1. Initialize persistence layer (HIVE component)
mcp__claude-flow__swarm_init(topology="hierarchical")

# 2. Create project namespace
mcp__claude-flow__memory_namespace(namespace="watcher-{project}", action="create")

# 3. Retrieve prior learnings (if any)
prior_patterns = mcp__claude-flow__memory_usage(
    action="retrieve",
    namespace="watcher-{project}",
    key="learned_patterns"
)

# 4. Initialize learning layer (BRAIN component) - NO TIMEOUT
mcp__ruv-swarm__swarm_init(topology="mesh", strategy="adaptive")

# 5. Create DAA agents with restored cognitive patterns
mcp__ruv-swarm__daa_agent_create(
    id="pattern-learner",
    cognitivePattern=prior_patterns.effective_pattern or "adaptive",
    enableMemory=true
)
```

### Active Work

```bash
# Queen (claude-flow) coordinates task delegation
mcp__claude-flow__agent_spawn(type="coordinator", name="Queen")
mcp__claude-flow__task_orchestrate(task="{task}", strategy="adaptive")

# DAA agents (ruv-swarm) execute and learn
mcp__ruv-swarm__neural_train(iterations=25)
mcp__ruv-swarm__daa_knowledge_share(
    sourceAgentId="pattern-learner",
    targetAgentIds=["worker-1", "worker-2"]
)

# Periodic sync: learnings → persistence
learnings = mcp__ruv-swarm__daa_learning_status(detailed=true)
mcp__claude-flow__memory_usage(
    action="store",
    namespace="watcher-{project}",
    key="checkpoint",
    value=learnings
)
```

### Session End

```bash
# 1. Extract final learnings
final_learnings = mcp__ruv-swarm__daa_learning_status(detailed=true)
cognitive_state = mcp__ruv-swarm__daa_cognitive_pattern(
    agentId="pattern-learner",
    action="analyze"
)

# 2. Store learnings with metadata
mcp__claude-flow__memory_usage(
    action="store",
    namespace="watcher-{project}",
    key="learned_patterns",
    value={
        "patterns": final_learnings,
        "effective_pattern": cognitive_state.current_patterns[0],
        "effectiveness": cognitive_state.pattern_effectiveness,
        "timestamp": now()
    }
)

# 3. Persist to disk (survives restart)
mcp__claude-flow__memory_persist(sessionId="watcher-{project}")
```

---

## Cognitive Patterns

WATCHER inherits all cognitive patterns from BRAIN:

| Pattern | Thinking Style | Best For | When to Switch |
|---------|---------------|----------|----------------|
| convergent | Focused, analytical | Debugging, known problems | Need precise solution |
| divergent | Creative, exploratory | Unknown problems, brainstorm | Need new ideas |
| lateral | Non-linear connections | Creative solutions | Stuck on approach |
| systems | Holistic, interconnected | Architecture, dependencies | Big picture needed |
| critical | Evaluative, skeptical | Security audit, code review | Need validation |
| adaptive | Context-switching | Mixed tasks | Varied workload |

### Pattern Selection Strategy

```
1. Start with ADAPTIVE for new projects
2. Switch to SYSTEMS when understanding architecture
3. Switch to CONVERGENT when implementing specific features
4. Switch to CRITICAL before code review
5. Store the most effective pattern for next session
```

---

## Memory Namespaces

WATCHER uses structured namespaces for organization:

```
watcher-{project}/
├── learned_patterns     # Cognitive patterns that worked
├── codebase_patterns    # Code style, architecture patterns
├── checkpoint           # Mid-session state
├── session_history      # Past session summaries
└── agent_configs        # Effective agent configurations
```

### Namespace Commands

```bash
# Create namespace
mcp__claude-flow__memory_namespace(namespace="watcher-myproject", action="create")

# List contents
mcp__claude-flow__memory_usage(action="list", namespace="watcher-myproject")

# Search across sessions
mcp__claude-flow__memory_search(pattern="*patterns*", namespace="watcher-myproject")
```

---

## Example: Full WATCHER Session

```bash
# === SESSION START ===

# Initialize both systems
mcp__claude-flow__swarm_init(topology="hierarchical")
mcp__ruv-swarm__swarm_init(topology="mesh", strategy="adaptive")

# Setup namespace and check for prior learnings
mcp__claude-flow__memory_namespace(namespace="watcher-my-project", action="create")
prior = mcp__claude-flow__memory_usage(action="retrieve", key="learned_patterns")

# Create learning agent with prior context
mcp__ruv-swarm__daa_agent_create(
    id="deep-analyzer",
    cognitivePattern=prior?.effective_pattern || "systems",
    capabilities=["code-analysis", "pattern-recognition", "architecture"]
)

# === ACTIVE WORK ===

# User: "ultrathink about the authentication system"

# Train on the codebase patterns
mcp__ruv-swarm__neural_train(agentId="deep-analyzer", iterations=50)

# Analyze with systems thinking
mcp__ruv-swarm__daa_cognitive_pattern(agentId="deep-analyzer", action="analyze")

# Share knowledge to other agents if needed
mcp__ruv-swarm__daa_knowledge_share(
    sourceAgentId="deep-analyzer",
    targetAgentIds=["coder-1"],
    knowledgeDomain="auth-patterns"
)

# Periodic checkpoint
mcp__claude-flow__memory_usage(
    action="store",
    key="auth_analysis_checkpoint",
    value=mcp__ruv-swarm__daa_learning_status()
)

# === SESSION END ===

# Persist everything
final_state = mcp__ruv-swarm__daa_learning_status(detailed=true)
mcp__claude-flow__memory_usage(action="store", key="learned_patterns", value=final_state)
mcp__claude-flow__memory_persist()

# Next session will restore from this state
```

---

## Comparison: BRAIN vs HIVE vs WATCHER

| Capability | BRAIN | HIVE | WATCHER |
|------------|-------|------|---------|
| Pattern Learning | Yes | No | Yes |
| Neural Networks | Yes | No | Yes |
| Cognitive Patterns | Yes | No | Yes |
| Session Persistence | No | Yes | Yes |
| Memory Namespaces | No | Yes | Yes |
| Cross-Session Recall | No | Yes | Yes |
| No Timeout | Yes | No | Yes |
| Best For | Single deep session | Multi-session memory | Deep learning + memory |

---

## Troubleshooting

### Patterns Not Persisting

```bash
# Check if memory was persisted
mcp__claude-flow__memory_usage(action="list", namespace="watcher-{project}")

# Force persist
mcp__claude-flow__memory_persist(sessionId="watcher-{project}")
```

### Learning Not Effective

```bash
# Check pattern effectiveness
mcp__ruv-swarm__daa_cognitive_pattern(agentId="...", action="analyze")

# If effectiveness < 0.7, try different pattern
mcp__ruv-swarm__daa_cognitive_pattern(
    agentId="...",
    action="change",
    pattern="systems"  # or try divergent, lateral
)
```

### Session Restore Failed

```bash
# Check available backups
mcp__claude-flow__memory_backup()

# Restore from backup
mcp__claude-flow__memory_restore(backupPath="...")
```

---

*WATCHER: The full power of Uatu - learning patterns that persist across sessions.*
