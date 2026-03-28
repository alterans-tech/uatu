---
description: Spawn agents for complex tasks — wave-based swarm execution, feature chains, bugfixes, refactoring, or security audits. Prevents context rot with fresh agent context per wave.
---

# Orchestrate

## Arguments

$ARGUMENTS

## Execution

Parse the workflow type from the first word of $ARGUMENTS. If no type specified, default to `swarm`.

### swarm `<description>`

Execute using WAVE-BASED EXECUTION to prevent context rot:

**Step 1 — Decompose:**
Break the task into discrete work units. For each unit identify:
- Description (what to do)
- Files involved
- Dependencies (which other units must complete first)
- Agent type (coder, tester, researcher, etc.)
- READ or WRITE classification

**Step 2 — Group into waves:**
- Wave 1: all units with NO dependencies
- Wave 2: units whose dependencies are ALL in Wave 1
- Wave N: units whose dependencies are ALL in prior waves

**Step 3 — Execute wave by wave:**

For each wave:
1. Spawn ALL agents in the wave in a SINGLE message:
   ```
   Agent(subagent_type="<type>", name="<task-name>", prompt="<task + context from prior waves>", isolation="worktree", run_in_background=true)
   ```
2. Wait for all agents in the wave to complete
3. Compress each agent's output into a ~500-token discovery relay brief:
   ```
   BRIEF: <agent-name> (Wave N)
   - Findings: <key outcomes>
   - Files modified: <list>
   - Decisions: <choices made>
   - Open: <unresolved questions>
   ```
4. After each successfully completed task, create an atomic git commit:
   ```
   feat(scope): task description
   ```
5. Report progress: "Wave N/M complete. Tasks: X/Y done."
6. Feed briefs as context to next wave's agents

**Step 4 — Synthesize:**
After all waves complete, produce a unified summary of all changes, decisions, and any open questions.

### feature `<description>`

Execute this chain with wave execution for parallel steps:

1. **planner** — analyze requirements, create implementation plan
2. **Plan validation** — review the plan for completeness:
   - All tasks have verify criteria
   - Dependencies are mapped
   - Referenced files exist
   - If validation fails, regenerate (max 3 iterations)
3. **[parallel wave]** coder (implements) + tester (writes tests):
   ```
   Agent(subagent_type="coder", prompt="Implement: <desc>. Plan: <plan>", isolation="worktree", run_in_background=true)
   Agent(subagent_type="tester", prompt="Write tests for: <desc>. Plan: <plan>", isolation="worktree", run_in_background=true)
   ```
4. **reviewer** — two-stage review (spec alignment + quality)
5. Atomic commit per completed task

### bugfix `<description>`

Execute sequentially with the /debug 4-phase process:

1. **debugger** — Phase 1 (capture) + Phase 2 (isolate root cause)
2. **coder** — Phase 3 (apply fix), use `isolation="worktree"`, pass debugger findings
3. **tester** — write regression test, use `isolation="worktree"`
4. **reviewer** — review fix and test
5. Atomic commit: `fix(scope): description`

### refactor `<description>`

1. **architect-review** — analyze current code, design target architecture
2. **[parallel wave]** refactoring-specialist + tester — spawn BOTH with `isolation="worktree"`, `run_in_background=true`
3. **reviewer** — review all changes
4. Atomic commit per refactored module

### security `<description>`

1. **security-auditor** — full security audit (same as /security-scan)
2. **reviewer** — review findings and proposed fixes
3. **architect-review** — verify fixes don't introduce architectural issues

### custom `<agent-list> <description>`

Parse comma-separated agent list. Execute sequentially with handoff context:
```
/orchestrate custom "architect-review,coder,tester,reviewer" "Redesign caching layer"
```

## Discovery Relay Brief Format

Between waves, compress each agent's output:

```
BRIEF: <agent-name> (Wave N)
- Findings: <key outcomes, max 3 bullets>
- Files: <modified files>
- Decisions: <choices made with rationale>
- Open: <unresolved questions for next wave>
```

This prevents context rot by keeping inter-wave context under 500 tokens per agent.

## Rules

- Spawn ALL parallel agents in a SINGLE message (true parallelism)
- Write agents MUST use `isolation="worktree"`
- Read-only agents do NOT need worktree
- Use `run_in_background=true` for parallel agents
- Create atomic git commit after each completed task
- Always include project context: "Read .uatu/config/project.md for conventions"
- Show progress after each wave: "Wave N/M complete. Tasks: X/Y done."
