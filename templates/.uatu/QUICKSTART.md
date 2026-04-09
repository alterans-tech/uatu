# Uatu Quick Reference

---

## Commands (5 core + Speckit)

| Command | When to Use | Example |
|---------|-------------|---------|
| `/shape` | Organize + sharpen a draft prompt | `/shape "fix the login thing"` |
| `/orch` | Multi-file work, features, bugs, refactors | `/orch "add notifications" --tdd` |
| `/jira` | Create Jira cards with proper hierarchy | `/jira "password reset"` |
| `/ask` | Delegate questions to sonnet (saves opus tokens) | `/ask "how does the auth middleware work?"` |
| `/time-report` | Time tracking | `/time-report --all --week` |

---

## `/shape`

Organize and sharpen a draft prompt. Sonnet only, no research — structures what you wrote, fills implied gaps, recommends what to run next.

```
/shape "fix the login bug it broke after the last deploy"
```

**What you get:**
```
### Original (Score: 2/10)
fix the login bug it broke after the last deploy

### Rewritten (Score: 8/10)
[Full structured version with headers, file refs, constraints, done-when]

### Next Step
Say "go" or run /orch to use parallel agents.
```

**Workflow:** Review the rewrite → correct if needed → say "go" or run the suggested command.

---

## `/orch`

Smart multi-agent execution. Auto-detects the right workflow from your description:
- Bug keywords → 4-phase debugging
- Refactor keywords → architect review + refactor
- Security keywords → security audit
- AI/LLM keywords → prompt-engineer + llm-architect
- Everything else → feature (research → plan → wave execution)

```
/orch "add email notifications for shipped orders"
/orch "add email notifications" --tdd
/orch "refactor auth into microservices" --dry-run
/orch "fix login 500 error" --jira ORI-234 --verify
/orch "build dashboard" --tdd --e2e --jira ORI-240
```

### Flags

| Flag | Effect |
|------|--------|
| `--tdd` | Every agent writes failing tests first, then implements |
| `--e2e` | Playwright E2E tests between each wave and at the end — stops on failure |
| `--review` | Two-stage review (spec + quality) after each wave |
| `--dry-run` | Show plan without executing — wait for your approval |
| `--verify` | Unit/integration tests between each wave and at the end — stops on failure |
| `--scope <paths>` | Constrain agents to specified files/directories only |
| `--no-commit` | Execute but don't commit — you review and commit manually |
| `--jira <KEY>` | Link to Jira: read AC, create branch, update status |

All flags composable. Example: `--tdd --verify --jira ORI-240`

---

## `/jira`

Create Jira cards with proper Epic → Story → Subtask hierarchy. Reviewed by agile-specialist + jira-specialist agents before presenting.

```
/jira "users need to reset their password via email"
```

Enforces: verb-first titles, user-observable AC, technical subtasks < 1 day, 3-6 subtasks per story.

---

## `/time-report`

Time tracking across projects. Sessions auto-logged by hooks.

```
/time-report                    # current project
/time-report --all              # all projects
/time-report --week             # this week
/time-report --month            # this month
/time-report --project orion    # specific project
```

---

## Speckit Commands

Specification-driven development. Enter when you want structured planning before building.

| Command | Phase | What It Does |
|---------|-------|-------------|
| `/speckit.constitution` | Setup | Define project principles |
| `/speckit.specify` | Define | Create feature spec from description |
| `/speckit.clarify` | Refine | Ask questions to reduce ambiguity |
| `/speckit.plan` | Design | Generate implementation plan |
| `/speckit.tasks` | Decompose | Break into dependency-ordered tasks |
| `/speckit.implement` | Build | Execute tasks (auto-spawns agents for 3+) |
| `/speckit.analyze` | Validate | Cross-artifact consistency check |
| `/speckit.checklist` | Verify | Generate validation checklist |
| `/speckit.complete` | Close | Verify completion, archive |

**Typical flow:**
```
/speckit.specify "user can export reports as PDF"
/speckit.clarify
/speckit.plan
/speckit.tasks
/speckit.implement
```

---

## Automatic Behaviors

These happen without commands — driven by hooks and rules:

| Behavior | When | What Happens |
|----------|------|-------------|
| 4-phase debugging | You describe a bug | Capture → isolate → fix → verify |
| Two-stage code review | You ask "review this" | Spec alignment, then quality |
| Security scan | Edit auth/payment files | Suggests running audit |
| Build auto-diagnosis | Build fails | Reads errors, finds root cause, fixes |
| Prompt coaching | Every prompt > 5 words | Scores and suggests improvements |
| Scope detection | Large-scope prompt | Suggests `/orch` |
| Risk detection | Auth/payment/migration prompt | Suggests plan mode or `--dry-run` |
| Agent suggestion | Edit auth/db/UI files | Suggests relevant agent |
| Branch guard | Session on main | Warns, suggests feature branch |
| Code formatting | After Write/Edit (new files) | Runs prettier/black/gofmt |
| Plan mode guard | `/orch` while in plan mode | Warns to exit plan mode first |
| Self-review scan | After code writes | Checks for TODOs, placeholders |
| Commit nudge | 3+ tasks without commit | Suggests committing |
| Review nudge | 10+ writes without review | Suggests reviewing |
| Missing tests | Session ends | Warns about untested files |
| Checkpoint | Session ends | Auto-saves to JSONL |
| Time logging | Session start + end | Auto-logged |

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

More templates: debug, architecture decision, code review, refactoring, research, PR gate — all in the file.

---

## Workflow Conventions

| Element | Format | Example |
|---------|--------|---------|
| Branch | `{KEY}-{N}/{type}/{desc}` | `ORI-234/feat/trip-pdf` |
| Worktree | `{project}-{KEY}-{N}-{desc}` | `orion-ORI-234-trip-pdf` |
| Commit | `{type}({scope}): {subject}` | `feat(export): add PDF cover page` |
| PR title | `{type}({scope}): {desc} [{KEY}]` | `feat(export): PDF export [ORI-234]` |

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `ci`
Scope = domain/component, NOT project name.

---

## Model Routing (Cost Optimization)

Commands route subagents to the cheapest model that can do the job:

| Tier | Model | When | Agents | Savings vs Opus |
|------|-------|------|--------|-----------------|
| **Judgment** | Opus | Task decomposition, arch review, security audit | planner, architect-review, security-auditor | — |
| **Execution** | Sonnet | Everything else — code, tests, research, docs, design, infra | All other agents (22) | **40%** |
| **Simple** | Haiku | Status, formatting, lookups, validation | Ad-hoc | **80%** |

Default: **Sonnet** for 90% of subagent calls. Only 3 agents use opus.
Typical `/orch` run saves ~50% vs all-Opus default.

**Token conservation:** Always set `model="sonnet"` explicitly. Use `run_in_background=true`. Compress relay briefs to ≤500 tokens.

---

## Jira Issue Templates

Templates at `.uatu/templates/jira/`:

| File | Issue Type | Key Rule |
|------|-----------|----------|
| `epic.md` | Epic (initiative) | Goal/Hypothesis/Scope — NOT "As a..." |
| `story.md` | Story | "As a... I want..." + behavioral AC |
| `task.md` | Task | Technical work, code-level done criteria |
| `bug.md` | Bug | Title = symptom, not cause |
| `subtask.md` | Sub-task | Self-contained for AI agent execution |

All issues get domain **Labels** (lowercase kebab-case: `authentication`, `api`, `ui-ux`).

---

## Config Files

| File | Purpose |
|------|---------|
| `.uatu/config/project.md` | Project settings, Jira key |
| `.uatu/config/architecture.md` | Tech stack (auto-generated) |
| `.uatu/config/constitution.md` | AI behavior principles |
| `.uatu/config/prompt-templates.md` | Copy-paste prompt starters |
| `.uatu/templates/jira/*.md` | Jira issue templates (epic, story, task, bug, subtask) |
| `.claude/rules/uatu-core.md` | Framework behavior rules + model routing (auto-loaded) |

---

## Workflow Scenarios

**Build a feature:**
```
/orch "add email notifications" --tdd --jira ORI-240
```

**Fix a bug:**
```
"the checkout fails with 500 when cart has 10+ items"
→ Uatu auto-uses 4-phase debugging
```

**Plan sprint work:**
```
/jira "users need document sharing with permissions"
```

---

*Full docs: `.uatu/UATU.md` | Guides: `.uatu/guides/` | Prompt templates: `.uatu/config/prompt-templates.md`*
