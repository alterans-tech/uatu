---
description: Spawn agents for complex tasks — swarm orchestration, feature chains, bugfixes, refactoring, or security audits.
---

# Orchestrate

## Arguments

$ARGUMENTS

## Execution

Parse the workflow type from the first word of $ARGUMENTS. If no type specified, default to `swarm`.

### swarm `<description>`

You MUST spawn the orchestrator-task agent NOW:

```
Agent(subagent_type="orchestrator-task", prompt="<full task description>. Read .uatu/config/project.md for project conventions.")
```

The orchestrator handles all decomposition, tier selection, batch-spawning, and synthesis. Do NOT decompose the task yourself.

### feature `<description>`

Execute this agent chain. Spawn each step, collect output, pass as context to the next:

1. **planner** — analyze requirements, create implementation plan
2. **[parallel]** coder (implements) + tester (writes tests) — spawn BOTH in ONE message:
   ```
   Agent(subagent_type="coder", prompt="Implement: <description>. Plan: <planner output>", isolation="worktree", run_in_background=true)
   Agent(subagent_type="tester", prompt="Write tests for: <description>. Plan: <planner output>", isolation="worktree", run_in_background=true)
   ```
3. **reviewer** — review all changes from step 2

### bugfix `<description>`

Execute this agent chain sequentially:

1. **debugger** — investigate root cause
2. **coder** — implement fix (pass debugger findings as context), use `isolation="worktree"`
3. **tester** — write regression test, use `isolation="worktree"`
4. **reviewer** — review fix and test

### refactor `<description>`

1. **architect-review** — analyze current code, design target architecture
2. **[parallel]** refactoring-specialist + tester — spawn BOTH in ONE message with `isolation="worktree"`, `run_in_background=true`
3. **reviewer** — review all changes

### security `<description>`

Execute sequentially:

1. **security-auditor** — full security audit
2. **reviewer** — review findings and proposed fixes
3. **architect-review** — verify fixes don't introduce architectural issues

### custom `<agent-list> <description>`

Parse comma-separated agent list. Execute sequentially, passing handoff context between each:

```
/orchestrate custom "architect-review,coder,tester,reviewer" "Redesign caching layer"
```

## Handoff Between Sequential Agents

Between agents, pass this context to the next agent's prompt:

```
Previous agent (<name>) output:
<summary of findings, files modified, decisions made, open questions>
```

## Rules

- Spawn ALL parallel agents in a SINGLE message (true parallelism)
- Write agents (coder, tester, refactoring-specialist) MUST use `isolation="worktree"`
- Read-only agents (researcher, reviewer, security-auditor) do NOT need worktree
- Use `run_in_background=true` for parallel agents
- Always include project context: "Read .uatu/config/project.md for conventions"
