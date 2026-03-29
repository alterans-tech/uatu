---
description: Smart multi-agent execution. Analyzes your request, picks the right workflow. Composable with --tdd, --e2e, --review flags.
---

# Orchestrate

## Arguments

$ARGUMENTS

## Execution

Analyze the user's description and AUTOMATICALLY detect the right workflow. Do NOT ask the user to pick a mode — figure it out.

### Detection Logic

Read $ARGUMENTS and classify:

1. **Bug/error keywords** ("fix", "broken", "error", "bug", "fails", "crash", "500", "not working")
   → Use **Bug Workflow**

2. **Refactor keywords** ("refactor", "restructure", "reorganize", "extract", "split", "consolidate", "migrate")
   → Use **Refactor Workflow**

3. **Security keywords** ("security", "audit", "vulnerability", "penetration", "OWASP")
   → Use **Security Workflow**

4. **Everything else** (features, implementation, building)
   → Use **Feature Workflow**

### Flags (Composable)

Parse flags from $ARGUMENTS:
- `--tdd` — Every write agent writes failing tests FIRST, then implements minimal code to pass
- `--e2e` — After all waves complete, spawn tester agent for Playwright E2E tests
- `--review` — Force two-stage review (spec alignment + quality) after each wave

Flags work with ANY detected workflow.

---

## Feature Workflow

### Phase 1 — Research (4 parallel agents)

Spawn 4 researchers in ONE message:

```
Agent(subagent_type="researcher", name="stack", prompt="What libraries/tools does this project use? Check package files.", run_in_background=true)
Agent(subagent_type="researcher", name="feature", prompt="How do similar features work in this codebase?", run_in_background=true)
Agent(subagent_type="researcher", name="architecture", prompt="Where should this hook into existing architecture?", run_in_background=true)
Agent(subagent_type="researcher", name="pitfalls", prompt="What could go wrong? Edge cases, rate limits, known issues?", run_in_background=true)
```

Compress each output to ~500-token brief.

### Phase 2 — Plan

Spawn planner with research briefs:

```
Agent(subagent_type="planner", prompt="Create implementation plan for: $ARGUMENTS. Research context: [briefs]. Break into tasks with dependencies, verify criteria, and file targets.")
```

**Validate the plan:** Check all tasks have verify criteria, dependencies are mapped, referenced files exist. If validation fails, regenerate (max 3 tries).

### Phase 3 — Wave Execution

Group tasks by dependency level into waves. Execute each wave:

1. Spawn ALL agents in the wave in ONE message with `isolation="worktree"`, `run_in_background=true`
2. If `--tdd`: each agent's prompt includes "Write a failing test FIRST, then implement minimal code to pass"
3. Wait for all agents to complete
4. Create atomic git commit per completed task: `feat(scope): description`
5. Compress outputs to ~500-token discovery relay briefs
6. Report progress: "Wave N/M complete. Tasks: X/Y done."
7. Feed briefs as context to next wave

### Phase 4 — Final Review

If `--review` OR if total changes span 5+ files:
- Stage 1: Spec alignment (does code match plan?)
- Stage 2: Code quality (security, error handling, naming)

If `--e2e`:
- Spawn tester agent for Playwright E2E tests after review

---

## Bug Workflow

Automatic 4-phase debugging:

### Phase 1 — Capture
- Collect error messages, stack traces, logs from user description
- Identify entry point (which request/action triggers the bug)
- List affected files

### Phase 2 — Isolate
- Trace from entry point through call chain
- Narrow to specific file, function, line
- Identify root cause type: data/logic/timing/config
- **If root cause unclear → ASK user for more context. Do NOT guess.**

### Phase 3 — Fix
- Apply targeted fix addressing root cause (not symptoms)
- Use `isolation="worktree"` for the fix
- Write regression test that would have caught this bug
- If `--tdd`: write the failing regression test FIRST

### Phase 4 — Verify
- Run regression test — must pass
- Run full test suite — must pass
- Create atomic commit: `fix(scope): description`

---

## Refactor Workflow

### Phase 1 — Architecture Review

```
Agent(subagent_type="architect-review", prompt="Analyze current code for: $ARGUMENTS. Produce target architecture: module boundaries, dependency directions, interface contracts, migration sequence.")
```

### Phase 2 — Wave Execution

Spawn parallel agents with `isolation="worktree"`:
- refactoring-specialist (applies changes)
- tester (updates tests to match new structure)

If `--tdd`: tester writes new tests FIRST, refactoring-specialist makes them pass.

### Phase 3 — Review
- Verify behavior is preserved (all existing tests pass)
- Verify architecture goals met
- Atomic commits per refactored module

---

## Security Workflow

### Phase 1 — Audit

```
Agent(subagent_type="security-auditor", prompt="Full security audit: secrets detection, input validation, auth/authz, dependency vulnerabilities, config security. Grade A-F with file:line references.")
```

### Phase 2 — Review

```
Agent(subagent_type="reviewer", prompt="Review security findings. Validate fix recommendations. Flag incomplete remediation.")
```

### Phase 3 — Architecture Check

```
Agent(subagent_type="architect-review", prompt="Verify proposed security fixes don't introduce architectural regressions or new attack surfaces.")
```

---

## Discovery Relay Brief Format

Between waves, compress each agent's output:

```
BRIEF: [agent-name] (Wave N)
- Status: done / partial / blocked
- Files changed: [list]
- Key decisions: [1-3 bullets]
- Open risks: [for next wave]
- Commit: [hash]
```

Max ~500 tokens per brief. This prevents context rot.

---

## Rules

- Spawn ALL parallel agents in ONE message (true parallelism)
- Write agents MUST use `isolation="worktree"`
- Read-only agents do NOT need worktree
- Create atomic git commit after each completed task
- Show progress after each wave: "Wave N/M complete. Tasks: X/Y done."
- Always include: "Read .uatu/config/project.md for conventions"
- If agents need mid-task coordination (discover things that change other agents' work), auto-escalate to Team coordination with TeamCreate + SendMessage
