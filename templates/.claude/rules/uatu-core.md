# Uatu Framework — Core Rules

These rules are auto-loaded by Claude Code every session. They define proactive behavior and automatic workflows.

---

## Commands Available

| Command | Purpose | Example |
|---------|---------|---------|
| `/status` | Sprint board + branches + worktrees + checkpoint | `/status` |
| `/orchestrate` | Smart multi-agent execution | `/orchestrate "add email notifications" --tdd` |
| `/pre-flight-check` | Pre-merge gate: review + verify + security | `/pre-flight-check` |
| `/review-pr` | Review someone else's PR, post inline comments | `/review-pr 234` |
| `/self-review` | Handle review comments on your PR | `/self-review 234` |
| `/plan-work` | Create Jira cards (Epic/Story/Subtask) | `/plan-work "password reset feature"` |
| `/prompt-rewrite` | Rewrite a prompt with proper structure | `/prompt-rewrite "fix the login thing"` |
| `/time-report` | Time tracking across projects | `/time-report --week` |

**Orchestrate flags:** `--tdd` (test-first), `--e2e` (Playwright tests), `--review` (two-stage review per wave)

---

## Sequential Thinking

Use `mcp__sequential-thinking__sequentialthinking` for structured reasoning.

**Mandatory for:** `/prompt-rewrite`, `/plan-work` (hardcoded in command)

**Use when:**
- Decomposing complex tasks in `/orchestrate` (multi-file, unclear scope)
- Reviewing large PRs in `/review-pr` (architectural impact assessment)
- Debugging non-obvious bugs (root cause isolation)
- Any task where the first approach might be wrong

**Skip when:**
- Simple data gathering (`/status`, `/time-report`)
- Procedural checks (`/pre-flight-check`)
- Interactive workflows (`/self-review` — read comment, propose fix, wait)
- Clear single-file tasks

---

## Proactive Behavior

Before starting any task, SUGGEST the appropriate approach:

| User Intent | Suggest |
|-------------|---------|
| Multi-file work, complex feature | `/orchestrate "description"` |
| Feature with test discipline | `/orchestrate "description" --tdd` |
| Define a new feature | `/speckit.specify "description"` |
| Implement from existing spec | `/speckit.implement` |
| Create Jira cards for new work | `/plan-work "description"` |
| Before merge | `/pre-flight-check` |
| Review a teammate's PR | `/review-pr <number>` |
| Handle review comments on your PR | `/self-review <number>` |

If the user's task clearly matches one of these, suggest it BEFORE starting work.

---

## Prompt Quality Coaching

When the user's prompt is missing critical elements, ASK briefly before proceeding:

- **No file references** → "Which files are involved?"
- **No success criteria** → Propose a "Done when:" condition
- **Vague scope** ("fix the thing") → Ask for specifics
- **Multiple concerns in one sentence** → Suggest numbered items

Do NOT block work. Ask, then proceed with best interpretation.

---

## Automatic Behaviors

These replace explicit commands — Claude does them automatically based on context.

### Bug Detection → 4-Phase Debugging

When the user describes a bug, error, or broken behavior, automatically use:

1. **Capture** — Collect error messages, stack traces, reproduction steps
2. **Isolate** — Trace to specific file/function/line, identify root cause
3. **Fix** — Apply targeted fix addressing root cause, not symptoms
4. **Verify** — Run tests, write regression test, confirm fix

**Rules:** Never skip Phase 2. Never apply "try this" patches. If root cause is unclear, ASK for more context.

### Code Review → Two-Stage

When the user asks to review code (not via `/review-pr` or `/pre-flight-check`):

1. **Stage 1 — Spec alignment:** Does the code match the task/spec/PR description?
2. **Stage 2 — Quality:** Security, error handling, naming, tests (only if Stage 1 passes)

### Security → Context-Aware

When modifying auth, payment, credential, session, or encryption files:
- Suggest running a security check
- If user agrees, spawn security-auditor agent

### Build Failure → Auto-Diagnose

When a build command fails:
1. Read the FULL error output (not just the first error)
2. Identify the ROOT error (later errors are often cascading)
3. Apply fix and re-run build
4. If fix introduces more errors, stop and explain the situation

### Verification → Before Merge

Before any merge suggestion, run: build + type check + lint + tests. Report results.

### Research → Part of Orchestrate

Research is Phase 1 of `/orchestrate` feature workflow. Not a standalone action.
When the user asks to "research X" outside orchestrate, spawn researchers and present findings.

### Test Coverage → On Request

When the user asks about test coverage or the missing-test-warning hook fires:
- Detect test framework, run coverage report
- Identify uncovered files, generate missing tests
- Target 80%+ on business logic

### Documentation → On Completion

After significant code changes, suggest updating relevant docs. Don't do it automatically — suggest and wait for confirmation.

---

## Quality Gates

- Never mark work complete without running relevant tests
- After completing implementation, suggest an atomic git commit
- When modifying auth/payment/security files, mention security implications
- Before merge, always suggest `/pre-flight-check`

---

## Artifacts

All deliverables go in `.uatu/delivery/`. Use `/speckit.*` commands for specifications.

---

## Agent Usage

50+ specialized agents available. Commands spawn them automatically.

Key agents: `coder`, `tester`, `reviewer`, `planner`, `researcher`, `debugger`, `architect-review`, `security-auditor`, `database-expert`

Full catalog: `.uatu/guides/AGENTS-GUIDE.md`
Quick reference: `.uatu/QUICKSTART.md`
