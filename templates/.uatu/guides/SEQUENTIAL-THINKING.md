# Sequential Thinking Guide

**Purpose:** Understand tasks before acting. Choose the right package.

---

## The Tool

```
mcp__sequential-thinking__sequentialthinking
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `thought` | string | Yes | Your current thinking step |
| `thoughtNumber` | int | Yes | Current step (1, 2, 3...) |
| `totalThoughts` | int | Yes | Estimated total steps needed |
| `nextThoughtNeeded` | bool | Yes | True if more thinking needed |
| `isRevision` | bool | No | True if revising a previous thought |
| `revisesThought` | int | No | Which thought number being revised |
| `branchFromThought` | int | No | Start a new reasoning branch |
| `branchId` | string | No | Label for the branch |
| `needsMoreThoughts` | bool | No | Realized you need more steps |

---

## When to Use

**Always use Sequential Thinking FIRST when:**

1. Task is ambiguous or complex
2. Multiple approaches are possible
3. You need to understand before acting
4. Risk is medium or higher
5. You're unsure which package to use

**Skip for:**
- Single-line fixes with clear instructions
- Simple file reads or searches
- Tasks you've done many times before

---

## Core Pattern

Every task should start with this thought sequence:

```
Thought 1: What is being asked? (Parse the request)
Thought 2: What context do I need? (Files, history, constraints)
Thought 3: What could go wrong? (Risk assessment)
Thought 4: Which package fits? (SOLO/SCOUT/SQUAD/BRAIN/HIVE)
Thought 5: What's my execution plan? (Concrete steps)
```

Then set `nextThoughtNeeded: false` and execute.

---

## Package Selection Logic

Use Sequential Thinking to decide:

| If you determine... | Select |
|---------------------|--------|
| Simple, 1-3 steps, low risk | **SOLO** |
| Need to find/investigate first | **SCOUT** |
| Multi-file, needs coordination | **SQUAD** |
| Pattern learning, long-running | **BRAIN** |
| Multi-phase, risky, needs isolation | **HIVE** |

---

## Thinking Patterns

### Bug Investigation
```
1. What are the symptoms?
2. What changed recently?
3. Where does the error originate?
4. What's the minimal reproduction?
5. What's the fix and what could it break?
→ Package: Usually SOLO or SCOUT
```

### Feature Implementation
```
1. What exactly needs to be built?
2. What existing code is affected?
3. What are the edge cases?
4. How will this be tested?
5. What's the implementation order?
→ Package: Usually SCOUT then SQUAD
```

### Refactoring
```
1. Why is this refactor needed?
2. What depends on this code?
3. What's the safe transformation path?
4. How do I verify nothing broke?
5. What's the rollback plan?
→ Package: SCOUT to understand, SQUAD to execute
```

### Architecture Decision
```
1. What problem are we solving?
2. What are the constraints?
3. What options exist?
4. What are the trade-offs of each?
5. What's the recommendation and why?
→ Package: BRAIN if learning needed, SCOUT otherwise
```

---

## Branching and Revision

**When to branch:**
- Exploring two different approaches
- "What if X?" vs "What if Y?" reasoning

```
Thought 5 (branchFromThought: 3, branchId: "approach-a"): ...
Thought 6 (branchFromThought: 3, branchId: "approach-b"): ...
Thought 7: Compare branches, select winner
```

**When to revise:**
- New information invalidates earlier thinking
- Realized a mistake in reasoning

```
Thought 4 (isRevision: true, revisesThought: 2):
Actually, after reading the file, the assumption in thought 2 was wrong...
```

---

## Integration with Packages

### SOLO
```
Sequential Thinking → Direct execution
(Thinking decides you can do it directly)
```

### SCOUT
```
Sequential Thinking → Task subagent → More thinking if needed
(Thinking identifies what to investigate)
```

### SQUAD
```
Sequential Thinking → swarm_init → agent_spawn → task_orchestrate
(Thinking determines topology and agent roles)
```

### BRAIN
```
Sequential Thinking → daa_agent_create → neural_train → knowledge_share
(Thinking defines learning objectives)
```

### HIVE
```
Sequential Thinking → seraphina_chat → sandbox_create → workflow
(Thinking scopes the multi-phase plan)
```

---

## Common Mistakes

1. **Skipping thinking for "obvious" tasks**
   - Often not obvious; 2 minutes of thinking saves 20 minutes of rework

2. **Too many thoughts**
   - If you're past 10 thoughts, break into sub-problems

3. **Not revising when wrong**
   - Use `isRevision` when you learn something that changes earlier conclusions

4. **Thinking without acting**
   - Set `nextThoughtNeeded: false` and execute when you have enough

---

## Quick Reference

```
Start: thoughtNumber: 1, totalThoughts: 5, nextThoughtNeeded: true
Continue: thoughtNumber: 2, totalThoughts: 5, nextThoughtNeeded: true
Realize need more: needsMoreThoughts: true, totalThoughts: 7
Branch: branchFromThought: 3, branchId: "alternative"
Revise: isRevision: true, revisesThought: 2
Done: nextThoughtNeeded: false
```

---

*Think first. Act with confidence.*
