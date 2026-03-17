# Orchestrate Command

Agent workflow for complex tasks — sequential chains, parallel execution, or full swarm orchestration.

## Usage

`/orchestrate [workflow-type] [task-description]`

## Workflow Types

### swarm
**Full swarm orchestration** — decomposes the task, selects a scaling tier, and batch-spawns parallel agents (including multiple of the same type) with worktree isolation for writers.

```
/orchestrate swarm "Refactor all services to use new error handling pattern"
```

Execution:
1. Invoke `orchestrator-task` agent with the full task description
2. Orchestrator decomposes → selects tier → batch-spawns agents
3. Agents work in parallel (write agents get worktree isolation)
4. Results synthesized into final report

Use for: multi-file features, refactoring, migrations, any task benefiting from parallel execution.

### feature
Full feature implementation workflow:
```
planner → [parallel: coder + tester] → code-reviewer → security-reviewer
```

### bugfix
Bug investigation and fix workflow:
```
debugger → coder → tester → code-reviewer
```

### refactor
Safe refactoring workflow:
```
architect-review → [parallel: refactoring-specialist + tester] → code-reviewer
```

### security
Security-focused review:
```
security-auditor → code-reviewer → architect-review
```

## Execution Patterns

### Sequential (default for feature/bugfix/refactor/security)

For each agent in the workflow:

1. **Invoke agent** with context from previous agent
2. **Collect output** as structured handoff document
3. **Pass to next agent** in chain
4. **Aggregate results** into final report

### Parallel Phases (swarm and parallel steps within chains)

When a workflow step shows `[parallel: ...]`, spawn all listed agents simultaneously in ONE message:

```
# Example: feature workflow parallel phase
Agent(subagent_type="coder", prompt="Implement...", isolation="worktree", run_in_background=true)
Agent(subagent_type="tester", prompt="Write tests...", isolation="worktree", run_in_background=true)
# Both execute in parallel, results collected when both complete
```

### Full Swarm (swarm workflow)

The `swarm` workflow delegates entirely to the `orchestrator-task` agent, which handles:
- Task decomposition into work units
- Scaling tier selection (micro 1-2, small 3-5, medium 6-12, large 13-25, swarm 25+)
- Batch spawning with worktree isolation and background execution
- Progress tracking and result synthesis

## Handoff Document Format

Between sequential agents, create handoff document:

```markdown
## HANDOFF: [previous-agent] → [next-agent]

### Context
[Summary of what was done]

### Findings
[Key discoveries or decisions]

### Files Modified
[List of files touched]

### Open Questions
[Unresolved items for next agent]

### Recommendations
[Suggested next steps]
```

## Examples

### Swarm: Multi-File Refactoring

```
/orchestrate swarm "Add error handling middleware and update all route handlers to use it"
```

Orchestrator will:
1. Scan all route files (Explore agents in parallel)
2. Design error middleware (architect-review)
3. Spawn N coder agents — one per route file — each in its own worktree
4. Spawn tester agents for new tests
5. Run code review and test suite

### Feature: Standard Implementation

```
/orchestrate feature "Add user authentication with JWT"
```

Executes:
1. **Planner** — analyzes requirements, creates implementation plan
2. **[Parallel]** Coder (implements) + Tester (writes tests) — both in worktrees
3. **Code Reviewer** — reviews all changes
4. **Security Reviewer** — security audit for auth code

### Custom Workflow

```
/orchestrate custom "architect-review,coder,tester,code-reviewer" "Redesign caching layer"
```

Runs the specified agents in sequence, with handoff documents between each.

## Final Report Format

```
ORCHESTRATION REPORT
====================
Workflow: [type]
Task: [description]
Agents: [list or tier summary]

SUMMARY
-------
[One paragraph summary]

AGENT OUTPUTS
-------------
[Per-agent summary]

FILES CHANGED
-------------
[List all files modified]

TEST RESULTS
------------
[Test pass/fail summary]

RECOMMENDATION
--------------
[SHIP / NEEDS WORK / BLOCKED]
```

## Arguments

$ARGUMENTS:
- `swarm <description>` - Full swarm orchestration (dynamic scaling, parallel agents)
- `feature <description>` - Feature workflow with parallel implementation phase
- `bugfix <description>` - Bug fix workflow
- `refactor <description>` - Refactoring workflow with parallel refactor+test
- `security <description>` - Security review workflow
- `custom <agents> <description>` - Custom agent sequence

## Tips

1. **Use `swarm` for multi-file work** — it auto-scales agent count to task size
2. **Use `feature`/`bugfix`/`refactor` for standard workflows** — predictable agent chains
3. **Always include code-reviewer** before merge
4. **Use security-reviewer** for auth/payment/PII
5. **Keep handoffs concise** — focus on what next agent needs
6. **Write agents get worktree isolation** — no git conflicts in parallel work
