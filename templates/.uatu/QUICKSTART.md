# Uatu Quick Reference

---

## Commands (6 + Speckit)

| Command | When to Use | Example |
|---------|-------------|---------|
| `/status` | Start of session — what's going on | `/status` |
| `/orch` | Multi-file work, features, bugs, refactors | `/orch "add notifications" --tdd` |
| `/jira` | Create Jira cards with proper hierarchy | `/jira "password reset"` |
| `/frame` | Organize + sharpen a draft prompt | `/frame "fix the login thing"` |
| `/prompt-analyzer` | Session effectiveness + prompt dashboard | `/prompt-analyzer --compare 2026-03-31` |
| `/time-report` | Time tracking | `/time-report --all --week` |

---

## `/status`

Full situational awareness. Run at the start of every session.

```
/status
/status --all           # all projects
```

**What you get:**
```
════════════════════════════════════
      PROJECT STATUS — Orion
════════════════════════════════════

Sprint: ORI Sprint 12 (ends Apr 4)
  In Progress: ORI-234 Trip PDF renderer
  To Do: ORI-240 Budget calculator
  Done: 3 this sprint

Branch: ORI-234/feat/trip-pdf-renderer
  Uncommitted: 3 files
  Ahead of main: 7 commits

Worktrees:
  ../orion-ORI-234-trip-pdf (current)
  ../orion-ORI-237-hotel-parser (stale)

Last Checkpoint: 2026-03-28 14:30
Time This Week: 12h 30m
```

---

## `/orch`

Smart multi-agent execution. Auto-detects the right workflow from your description:
- Bug keywords → 4-phase debugging
- Refactor keywords → architect review + refactor
- Security keywords → security audit
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
| `--e2e` | Playwright E2E tests after all waves complete |
| `--review` | Two-stage review (spec + quality) after each wave |
| `--dry-run` | Show plan without executing — wait for your approval |
| `--verify` | Run test suite between each wave — stop on failure |
| `--scope <paths>` | Constrain agents to specified files/directories only |
| `--no-commit` | Execute but don't commit — you review and commit manually |
| `--jira <KEY>` | Link to Jira: read AC, create branch, update status |

All flags composable. Example: `--tdd --verify --jira ORI-240`

**What you see during execution:**
```
Phase 1 — Research: 4 parallel researchers spawned...
Phase 2 — Plan: Validated (3/3 checks pass)
Phase 3 — Waves:
  Wave 1/3: T1, T2 — spawning...
  Wave 1/3 complete. Tasks: 2/6 done. Commits: 2.
  Verification: 47/47 tests PASS ✓
  Wave 2/3: T3, T4 — spawning...
  ...
Phase 4 — Review: Spec alignment PASS. Quality APPROVE.
```

---

## `/jira`

Create Jira cards with proper Epic → Story → Subtask hierarchy. Uses Sequential Thinking.

```
/jira "users need to reset their password via email"
```

**What you get:**
```
Epic: AUTH — User Authentication (existing)

  Story: Allow users to reset their password
    As a user, I want to reset via email,
    so that I can regain access.

    Acceptance Criteria:
    - [ ] User can request reset from login page
    - [ ] Reset email arrives within 30 seconds
    - [ ] Link expires after 24 hours

    Subtasks:
    1. Create password reset endpoint
    2. Add email template
    3. Write migration for tokens table
    4. Build reset form component
    5. Add rate limiting

Create in Jira? (y/n)
```

Enforces: verb-first titles, user-observable AC, technical subtasks < 1 day, 3-6 subtasks per story.

---

## `/frame`

Rewrite a draft prompt with structure, file refs, constraints, and done-conditions. Uses Sequential Thinking.

```
/frame "fix the login bug it broke after the last deploy"
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

**Workflow:** Review the rewrite → correct if needed → say "go" or run the suggested command. No copy-pasting needed — Claude already has the full context.

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

| Tier | Model | When | Savings vs Opus |
|------|-------|------|-----------------|
| **Planning** | Opus | Architecture, decomposition, security audit | — |
| **Execution** | Sonnet | Code gen, tests, file ops, research | **40%** |
| **Simple** | Haiku | Status, formatting, lookups | **80%** |

Default: **Sonnet** for 80% of subagent calls. Opus only for planning/architecture/security.
Typical `/orch` run saves ~37% vs all-Opus default.

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

**Start your day:**
```
/status
```

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

**Check your prompting:**
```
/prompt-analyzer
```

---

*Full docs: `.uatu/UATU.md` | Guides: `.uatu/guides/` | Prompt templates: `.uatu/config/prompt-templates.md`*
