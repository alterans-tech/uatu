# Uatu Quick Reference

---

## Commands (8)

| Command | When to Use | Example |
|---------|-------------|---------|
| `/status` | Start of session — see what's going on | `/status` |
| `/orchestrate` | Multi-file work, features, bugs, refactors | `/orchestrate "add email notifications"` |
| `/pre-flight-check` | Before merging — full quality gate | `/pre-flight-check` |
| `/review-pr` | Review someone else's PR | `/review-pr 234` |
| `/self-review` | Handle review comments on your PR | `/self-review 234` |
| `/plan-work` | Create Jira cards with proper hierarchy | `/plan-work "password reset feature"` |
| `/prompt-rewrite` | Improve a draft prompt | `/prompt-rewrite "fix the login thing"` |
| `/time-report` | Time tracking | `/time-report --all --week` |

### Orchestrate Flags

| Flag | Effect | Example |
|------|--------|---------|
| `--tdd` | Every agent writes tests first | `/orchestrate "build user dashboard" --tdd` |
| `--e2e` | Playwright E2E tests after completion | `/orchestrate "checkout flow" --e2e` |
| `--review` | Two-stage review after each wave | `/orchestrate "refactor auth" --review` |

Orchestrate auto-detects the right workflow from your description:
- Bug keywords ("fix", "broken", "error") → 4-phase debugging
- Refactor keywords ("refactor", "restructure") → architect review + refactor
- Security keywords ("audit", "vulnerability") → security audit
- Everything else → feature workflow (research → plan → wave execution)

### Speckit Commands

| Command | Phase | Example |
|---------|-------|---------|
| `/speckit.specify` | Define | `/speckit.specify "user can export reports as PDF"` |
| `/speckit.clarify` | Refine | `/speckit.clarify` |
| `/speckit.plan` | Design | `/speckit.plan` |
| `/speckit.tasks` | Decompose | `/speckit.tasks` |
| `/speckit.implement` | Build | `/speckit.implement` |
| `/speckit.analyze` | Validate | `/speckit.analyze` |
| `/speckit.checklist` | Verify | `/speckit.checklist` |
| `/speckit.taskstoissues` | Track | `/speckit.taskstoissues` |
| `/speckit.constitution` | Setup | `/speckit.constitution` |
| `/speckit.complete` | Close | `/speckit.complete` |

---

## Automatic Behaviors (No Commands Needed)

These happen automatically — you don't invoke them:

| What Happens | When |
|---|---|
| Project context loaded | Every session start |
| Branch guard (warns if on main) | Every session start |
| Prompt quality coaching | Every prompt > 15 words |
| Scope detection (suggests /orchestrate) | Large-scope prompts |
| 4-phase debugging | You describe a bug or error |
| Two-stage code review | You ask to review code |
| Security scan suggestion | You modify auth/payment files |
| Build auto-diagnosis | Build command fails |
| Credential writes blocked | Write to .env, .pem, .key |
| Code auto-formatted | After every Write/Edit |
| Self-review checklist | After code writes (TODO/placeholder scan) |
| Agent suggestion | After Write/Edit on auth/db/UI files |
| Review cadence nudge | After 10+ writes without review |
| Commit cadence nudge | After 3+ tasks without commit |
| Missing test warning | Session end |
| Session checkpoint saved | Session end |
| Time auto-logged | Session start + end |

---

## Prompt Templates

Copy-paste starters at `.uatu/config/prompt-templates.md`:

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

## Workflow Conventions

| Element | Format | Example |
|---------|--------|---------|
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
