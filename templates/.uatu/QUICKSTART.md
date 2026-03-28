# Uatu Quick Reference

Everything you can do with Uatu at a glance.

---

## Automatic (No Action Required)

These fire automatically via hooks:

| What Happens | When |
|---|---|
| Project context loaded | Every session start |
| Last checkpoint restored | Every session start |
| Branch guard (warns if on main) | Every session start |
| Prompt quality scored + coaching | Every prompt > 15 words |
| Scope detection (suggests /orchestrate) | Large-scope prompts |
| Credential writes blocked | Write to .env, .pem, .key |
| Config file writes blocked | Write to tsconfig, eslint configs |
| Code auto-formatted | After every Write/Edit |
| Agent suggestion (context-aware) | After Write/Edit on auth/db/UI files |
| Review cadence nudge | After 10+ writes without review |
| Commit cadence nudge | After 3+ tasks without commit |
| Missing test warning | Session end |
| Session checkpoint saved | Session end |
| Time auto-logged | Session start + end |
| Cost logged | Session end |

---

## Commands

### Orchestration

| Command | When to Use | Example |
|---|---|---|
| `/orchestrate swarm` | Multi-file work, 3+ tasks | `/orchestrate swarm "refactor auth module"` |
| `/orchestrate feature` | New feature end-to-end | `/orchestrate feature "add email notifications"` |
| `/orchestrate bugfix` | Bug with unknown root cause | `/orchestrate bugfix "login 500 after deploy"` |
| `/squad` | Agents must coordinate mid-task | `/squad "frontend + backend co-design API"` |

### Development

| Command | When to Use | Example |
|---|---|---|
| `/tdd` | Test-first development | `/tdd "add retry logic to payment processor"` |
| `/e2e` | Generate + run Playwright tests | `/e2e "test checkout flow"` |
| `/debug` | Systematic 4-phase debugging | `/debug "users see stale data after cache clear"` |
| `/research` | Investigate before planning | `/research "best approach for real-time collab"` |
| `/build-fix` | Build is broken | `/build-fix` |

### Quality

| Command | When to Use | Example |
|---|---|---|
| `/code-review` | Before commit/merge | `/code-review` |
| `/security-scan` | Before deploy, after auth changes | `/security-scan` |
| `/verify` | Full verification loop | `/verify` |

### Workflow

| Command | When to Use | Example |
|---|---|---|
| `/checkpoint` | Save session state | `/checkpoint` |
| `/refactor-clean` | Code cleanup with quality gates | `/refactor-clean "extract shared error handling"` |
| `/test-coverage` | Analyze + improve coverage | `/test-coverage` |
| `/update-docs` | Sync docs with code changes | `/update-docs` |
| `/time` | Check time tracking | `/time --all --week` |
| `/run-assessment` | Prompt quality assessment | `/run-assessment` |
| `/prompt-rewrite` | Improve a prompt | `/prompt-rewrite "fix the login thing"` |

### Speckit (Specification Workflow)

| Command | Phase | Example |
|---|---|---|
| `/speckit.specify` | Define | `/speckit.specify "user can export reports as PDF"` |
| `/speckit.clarify` | Refine | `/speckit.clarify` |
| `/speckit.plan` | Design | `/speckit.plan` |
| `/speckit.tasks` | Decompose | `/speckit.tasks` |
| `/speckit.implement` | Build | `/speckit.implement` |
| `/speckit.analyze` | Validate | `/speckit.analyze` |
| `/speckit.checklist` | Verify | `/speckit.checklist` |
| `/speckit.taskstoissues` | Track | `/speckit.taskstoissues` |
| `/speckit.constitution` | Setup | `/speckit.constitution` |

---

## Skills (Auto-Triggered)

Skills activate automatically when Claude detects matching context:

| Skill | Triggers When |
|---|---|
| `react-component` | Creating a new React component |
| `test-file` | Creating tests for existing code |
| `tdd-workflow` | TDD-related work |
| `backend-patterns` | Backend API work |
| `frontend-patterns` | React/Next.js UI work |
| `api-design` | REST API design |
| `coding-standards` | TypeScript/JavaScript code |
| `python-patterns` | Python code |
| `golang-patterns` | Go code |
| `docker-patterns` | Docker/compose work |
| `database-migrations` | Schema changes |
| `deployment-patterns` | CI/CD, deploy work |
| `security-review` | Auth, secrets, user input |
| `e2e-testing` | Playwright tests |
| `verification-loop` | Running verifications |

---

## Key Agents

You rarely invoke agents directly — commands select them. But you CAN request by name:

| Agent | When to Request |
|---|---|
| `researcher` | "I need deep research on X" |
| `debugger` | "Investigate this, don't fix yet" |
| `security-auditor` | "Audit this for vulnerabilities" |
| `architect-review` | "Review this architecture decision" |
| `database-expert` | "Review this schema/migration" |
| `prompt-engineer` | "Help me write a better prompt" |

---

## Prompt Templates

Copy-paste starters in `.uatu/config/prompt-templates.md`. Key patterns:

**Bug fix:**
```
Problem: [one sentence]
Evidence: [error/log]
Files: [paths]
Action: Diagnose first, do NOT fix yet.
Done when: Root cause identified with evidence.
```

**Feature:**
```
Feature: [name]
Requirements:
1. [requirement]
Files: [paths]
Constraints: [ONLY/Do NOT]
Done when: [testable conditions]
```

**Session start:**
```
Project: [name], Branch: [branch]
Last session: [paste summary]
Priority: [first task]
Recon first: confirm state before acting.
```

---

## Package Selection

```
Can you give each agent everything it needs before it starts?
  YES → SOLO (use /orchestrate)
  NO  → SQUAD (use /squad — agents coordinate mid-work)
        → Need persistence? → HIVE (experimental)
```

---

## Workflow Conventions

| Element | Format | Example |
|---|---|---|
| Branch | `UAT-{N}/{type}/{desc}` | `UAT-61/feat/wave-execution` |
| Worktree | `uatu-UAT-{N}-{desc}` | `uatu-UAT-61-wave-execution` |
| Commit | `{type}({scope}): {subject}` | `feat(orchestrate): add wave execution` |
| PR | `{type}({scope}): {desc} [UAT-{N}]` | `feat(orchestrate): wave execution [UAT-61]` |

---

## Config Files

| File | Purpose |
|---|---|
| `.uatu/config/project.md` | Project settings, Jira key |
| `.uatu/config/architecture.md` | Tech stack (auto-generated) |
| `.uatu/config/constitution.md` | AI behavior principles |
| `.uatu/config/prompt-templates.md` | Copy-paste prompt starters |
| `.claude/rules/uatu-core.md` | Framework behavior rules (auto-loaded) |

---

*Full documentation: `.uatu/UATU.md` | Guides: `.uatu/guides/`*
