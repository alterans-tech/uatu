---
description: Create an Agent Team where agents communicate mid-task via SendMessage. Use when agents need to discover and share information during execution.
---

# Squad

## Arguments

$ARGUMENTS

## When to Use

Use `/squad` ONLY when agents need to discover and share information during execution.
For independent parallel work, use `/orchestrate` instead.

**SQUAD examples** (agents discover things mid-work that change what others do):
- Frontend + backend co-designing an API contract that doesn't exist yet
- Cross-service debugging where one agent's findings redirect another
- Design negotiation where agents converge on a consensus

**NOT SQUAD** (use `/orchestrate` instead):
- Refactoring N files with the same pattern (independent work)
- Writing tests for separate modules (no inter-agent dependency)
- Code review + security audit (independent analyses)

## Execution

### Step 1: Analyze the task

From $ARGUMENTS, identify:
- Which agents need to coordinate (2-4 agents typical)
- What information agents will discover and share mid-task
- Agent names for the team (e.g., "backend-dev", "frontend-dev")

### Step 2: Create the team

```
TeamCreate(team=["<agent-name-1>", "<agent-name-2>", ...])
```

### Step 3: Spawn all team members in ONE message

For each agent, spawn with `team_name` and include SendMessage instructions:

```
Agent(subagent_type="<type>", name="<agent-name-1>", team_name="<team>", prompt="<task>. You are part of a SQUAD team. Communicate with your teammates via SendMessage(to='<other-agent>', message='<info>'). Share discoveries that affect other agents' work. Read .uatu/config/project.md for conventions.", run_in_background=true)

Agent(subagent_type="<type>", name="<agent-name-2>", team_name="<team>", prompt="<task>. You are part of a SQUAD team. Communicate with your teammates via SendMessage(to='<other-agent>', message='<info>'). Wait for information from teammates when needed.", run_in_background=true)
```

### Step 4: Wait and report

Wait for all team members to complete. Collect and synthesize their outputs into a final report.

## Rules

- Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` (already set by Uatu)
- Spawn ALL team members in a SINGLE message
- Each agent prompt MUST include SendMessage instructions
- Write agents MUST use `isolation="worktree"`
- Keep teams small (2-4 agents) — larger teams use `/orchestrate`
