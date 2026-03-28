# Uatu Framework — Core Rules

These rules are auto-loaded by Claude Code. They define proactive behavior for every session.

---

## Proactive Command Suggestion

Before starting any task, SUGGEST the appropriate Uatu command:

| User Intent | Suggest |
|-------------|---------|
| Multi-file changes, refactoring | `/orchestrate swarm "description"` |
| New feature end-to-end | `/orchestrate feature "description"` |
| Bug with unknown root cause | `/debug "description"` |
| Define a new feature | `/speckit.specify "description"` |
| Implement from existing spec | `/speckit.implement` |
| Before merge or deploy | `/code-review` then `/verify` |
| Security-sensitive changes | `/security-scan` |
| Test-first development | `/tdd "description"` |

If the user's task clearly matches one of these, suggest it BEFORE starting work inline.

---

## Prompt Quality Coaching

When the user's prompt is missing critical elements, ASK before proceeding:

- **No file references** → "Which files are involved?"
- **No success criteria** → Propose a "Done when:" condition before starting
- **Vague scope** ("fix the thing", "update it") → Ask for specifics
- **Multiple concerns in one sentence** → Suggest structuring with numbered items

Do NOT block work. Ask briefly, then proceed with best interpretation if no answer.

---

## Quality Gates

- Never mark work complete without running relevant tests
- After completing implementation tasks, suggest an atomic git commit
- After 10+ file modifications, suggest `/code-review`
- Before merge, always suggest `/verify` (build + types + lint + tests)
- When modifying auth, payments, or security files, suggest `/security-scan`

---

## Available Commands

| Command | Purpose |
|---------|---------|
| `/orchestrate swarm` | Multi-agent parallel execution with wave-based dependency ordering |
| `/orchestrate feature` | End-to-end: plan → code → test → review |
| `/orchestrate bugfix` | Systematic: debug → fix → test → review |
| `/squad` | Agent team with peer messaging for coordinated work |
| `/debug` | 4-phase systematic debugging (capture → isolate → fix → verify) |
| `/research` | 4 parallel researchers before planning |
| `/tdd` | Test-driven development workflow |
| `/e2e` | Generate + run Playwright E2E tests |
| `/code-review` | Two-stage review (spec alignment + quality) |
| `/security-scan` | Security vulnerability scan |
| `/verify` | Full verification (build + types + lint + tests + security) |
| `/checkpoint` | Save session state |
| `/build-fix` | Diagnose + fix build errors |
| `/time` | Time tracking (--all, --week, --project) |
| `/run-assessment` | Prompt quality assessment with percentile tracking |
| `/prompt-rewrite` | Rewrite a prompt with proper structure |

### Speckit Commands

| Command | Purpose |
|---------|---------|
| `/speckit.specify` | Create feature specification |
| `/speckit.clarify` | Reduce spec ambiguity |
| `/speckit.plan` | Generate implementation plan |
| `/speckit.tasks` | Create task breakdown |
| `/speckit.implement` | Execute tasks (auto-spawns agents for 3+ tasks) |
| `/speckit.analyze` | Cross-artifact consistency check |
| `/speckit.checklist` | Generate validation checklist |
| `/speckit.taskstoissues` | Push tasks to Jira/GitHub |

---

## Artifacts

All deliverables go in `.uatu/delivery/`. Use `/speckit.*` commands for specifications.

---

## Agent Usage

65+ specialized agents available. Commands spawn them automatically.
For manual spawning: `Agent(subagent_type="<type>", prompt="...", isolation="worktree", run_in_background=true)`

Key agents: `coder`, `tester`, `reviewer`, `planner`, `researcher`, `debugger`, `architect-review`, `security-auditor`, `database-expert`

Full catalog: `.uatu/guides/AGENTS-GUIDE.md`
Quick reference: `.uatu/QUICKSTART.md`
