---
description: Smart multi-agent execution. Analyzes your request, picks the right workflow. Composable flags for TDD, E2E, verification, Jira, scope control, and more.
---

# Orch

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

### Flags (All Composable)

Parse flags from $ARGUMENTS:

| Flag | Effect |
|------|--------|
| `--tdd` | Every write agent writes failing tests FIRST, then implements minimal code to pass |
| `--e2e` | Run Playwright E2E tests between each wave and at the end. Stop if tests fail. |
| `--review` | Force two-stage review (spec alignment + quality) after each wave |
| `--dry-run` | Show the full plan (waves, tasks, agents, files) but do NOT execute. Wait for user approval. |
| `--verify` | Run unit/integration test suite between each wave and at the end. Stop if tests fail. |
| `--scope <paths>` | Constrain agents to ONLY modify files in the specified paths (comma-separated dirs/files) |
| `--no-commit` | Execute all work but skip atomic commits. Changes staged, user commits manually. |
| `--jira <KEY>` | Link to Jira issue: read description + AC for context, create branch, update status, comment on completion |

Flags work with ANY detected workflow. Examples:
```
/orch "add email notifications" --tdd --verify
/orch "refactor auth" --dry-run --scope src/auth/
/orch "fix payment bug" --jira PAY-123 --verify --no-commit
/orch "build user dashboard" --jira ORI-240 --tdd --e2e --review
```

---

## Model Routing

| Role | Model | Who |
|------|-------|-----|
| **Head / Planner** | `opus` | Planner, architect-review, security-auditor |
| **Workers** | `sonnet` | Coders, testers, researchers, reviewers |

**Rule: any agent making architectural decisions or decomposing work MUST use `model="opus"`. Worker agents executing tasks use `model="sonnet"`.**

---

## Pre-Execution: Flag Processing

### If `--jira <KEY>`:
1. Fetch the Jira issue: `mcp__atlassian__jira_get_issue(issue_key="<KEY>")`
2. Read the summary, description, and acceptance criteria
3. Inject AC into agent prompts as context
4. Create branch: `<KEY>/<type>/<short-desc>` (e.g. `ORI-240/feat/user-dashboard`)
5. Transition issue to "In Progress"

### If `--scope <paths>`:
1. Parse comma-separated paths into a scope list
2. Include in every agent prompt: "You MUST only modify files within: [scope list]. Do NOT touch files outside this scope."

### If `--dry-run`:
1. Run Detection Logic and Phase 1 (Research) only
2. Generate the full plan: waves, tasks, agent assignments, file targets, estimated commits
3. Present to user and STOP. Do NOT execute until user approves.

---

## Feature Workflow

### Phase 1 — Research (4 parallel agents)

Spawn 4 researchers in ONE message:

```
Agent(subagent_type="researcher", name="stack", prompt="What libraries/tools does this project use? Check package files.", model="sonnet", run_in_background=true)
Agent(subagent_type="researcher", name="feature", prompt="How do similar features work in this codebase?", model="sonnet", run_in_background=true)
Agent(subagent_type="researcher", name="architecture", prompt="Where should this hook into existing architecture?", model="sonnet", run_in_background=true)
Agent(subagent_type="researcher", name="pitfalls", prompt="What could go wrong? Edge cases, rate limits, known issues?", model="sonnet", run_in_background=true)
```

Compress each output to ~500-token brief.

### Phase 2 — Plan

Spawn planner with research briefs:

```
Agent(subagent_type="planner", model="opus", prompt="Create implementation plan for: $ARGUMENTS. Research context: [briefs]. Break into tasks with dependencies, verify criteria, and file targets.")
```

**Validate the plan:** Check all tasks have verify criteria, dependencies are mapped, referenced files exist. If validation fails, regenerate (max 3 tries).

**If `--dry-run`:** Show the plan and STOP here. Wait for user approval.

### Phase 3 — Wave Execution

Group tasks by dependency level into waves. Execute each wave:

1. Spawn ALL agents in the wave in ONE message with `model="sonnet"`, `isolation="worktree"`, `run_in_background=true`
2. If `--tdd`: each agent's prompt includes "Write a failing test FIRST, then implement minimal code to pass"
3. If `--scope`: each agent's prompt includes "ONLY modify files within: [scope list]"
4. Wait for all agents to complete
5. If NOT `--no-commit`: create atomic git commit per completed task: `feat(scope): description`
6. If `--verify`: run unit/integration test suite. If tests fail, STOP and report which task broke them.
7. If `--e2e`: run Playwright E2E tests. If tests fail, STOP and report.
8. Compress outputs to ~500-token discovery relay briefs
9. Report progress: "Wave N/M complete. Tasks: X/Y done."
10. Feed briefs as context to next wave

### Phase 4 — Final Review

If `--review` OR if total changes span 5+ files:
- Stage 1: Spec alignment (does code match plan?)
- Stage 2: Code quality (security, error handling, naming)

If `--e2e`:
- Run Playwright E2E tests after final review (in addition to between-wave runs)

### Phase 5 — Completion

If `--jira <KEY>`:
- Add comment to Jira issue with summary of changes, files modified, commits
- Do NOT transition to Done (user does this after merge)

---

## Bug Workflow

Automatic 4-phase debugging:

### Phase 1 — Capture
- Collect error messages, stack traces, logs from user description
- If `--jira`: read the bug ticket description for reproduction steps
- Identify entry point (which request/action triggers the bug)
- List affected files

### Phase 2 — Isolate
- Trace from entry point through call chain
- If `--scope`: only investigate files within scope
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
- If NOT `--no-commit`: create atomic commit: `fix(scope): description`
- If `--verify`: show full test output before proceeding
- If `--jira`: comment on issue with root cause and fix summary

---

## Refactor Workflow

### Phase 1 — Architecture Review

```
Agent(subagent_type="architect-review", model="opus", prompt="Analyze current code for: $ARGUMENTS. Produce target architecture: module boundaries, dependency directions, interface contracts, migration sequence.")
```

**If `--dry-run`:** Show architecture plan and STOP.

### Phase 2 — Wave Execution

Spawn parallel agents with `isolation="worktree"`:
- refactoring-specialist (applies changes)
- tester (updates tests to match new structure)

If `--tdd`: tester writes new tests FIRST, refactoring-specialist makes them pass.
If `--scope`: constrain refactoring to specified paths only.
If `--verify`: run tests between each refactoring step.

### Phase 3 — Review
- Verify behavior is preserved (all existing tests pass)
- Verify architecture goals met
- If NOT `--no-commit`: atomic commits per refactored module

---

## Security Workflow

### Phase 1 — Audit

```
Agent(subagent_type="security-auditor", model="opus", prompt="Full security audit: secrets detection, input validation, auth/authz, dependency vulnerabilities, config security. Grade A-F with file:line references.")
```

### Phase 2 — Review

```
Agent(subagent_type="reviewer", model="sonnet", prompt="Review security findings. Validate fix recommendations. Flag incomplete remediation.")
```

### Phase 3 — Architecture Check

```
Agent(subagent_type="architect-review", model="opus", prompt="Verify proposed security fixes don't introduce architectural regressions or new attack surfaces.")
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
- Unless `--no-commit`: create atomic git commit after each completed task
- Show progress after each wave: "Wave N/M complete. Tasks: X/Y done."
- Always include: "Read .uatu/config/project.md for conventions"
- If agents need mid-task coordination, auto-escalate to Team coordination with TeamCreate + SendMessage
- If `--scope` is set, enforce file boundaries in every agent prompt
- If `--verify` is set, test failures between waves are blocking — stop and report
