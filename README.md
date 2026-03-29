# Uatu - The Watcher

AI orchestration framework for Claude Code. Proactive advisor, multi-agent execution, specification-driven development, and prompt quality coaching — installed into any project with one command.

---

## Installation

### New Machine (One-Time Setup)

```bash
# 1. Clone and add to PATH
git clone git@github.com:alterans-tech/uatu.git
cd uatu && ./setup.sh && source ~/.zshrc

# 2. Install user-level MCP servers
uatu-setup
```

This installs Sequential Thinking, Claude Flow, and Context7 MCP servers globally.

### New Project

```bash
cd /path/to/your-project
uatu-install
```

That's it. Uatu creates `.uatu/`, `.claude/rules/`, `.claude/commands/`, hooks, and config files. Claude Code starts using the framework immediately — no manual CLAUDE.md editing needed.

**Installation profiles:**
```bash
uatu-install                           # standard (hooks + rules + commands + skills)
uatu-install --profile minimal         # hooks + rules only (lightest)
uatu-install --profile full            # everything including agents
uatu-install --languages typescript,python  # only install rules for these languages
```

### Existing Project (Already Has CLAUDE.md)

Same command. Uatu prepends a header to your existing CLAUDE.md (never overwrites), creates `.claude/rules/uatu-core.md` (auto-loaded by Claude Code), and installs hooks. Your existing project configuration is preserved.

```bash
cd /path/to/existing-project
uatu-install
```

### Upgrading

```bash
cd /path/to/project-with-uatu
uatu-install
# Detects existing installation, backs up configs, updates framework files
```

### After Install

```bash
cp .env.example .env        # fill in your tokens (GH_TOKEN, JIRA_URL, etc.)
direnv allow                 # auto-load env vars
```

---

## How Uatu Works

Uatu operates on three layers:

1. **Rules** (`.claude/rules/uatu-core.md`) — Auto-loaded every session. Tells Claude to suggest commands proactively, coach on prompt quality, and use structured debugging/review automatically.

2. **Hooks** — Fire on Claude Code lifecycle events. Score your prompts, suggest agents based on file patterns, warn about missing tests, guard branches, auto-format code, save checkpoints.

3. **Commands** — 7 slash commands you type when you need explicit control. Everything else is automatic.

---

## Commands (7 + Speckit)

### `/status`

Full situational awareness. Run at the start of every session.

```
/status
```

**What you get:**
```
════════════════════════════════════════
        PROJECT STATUS — Orion
════════════════════════════════════════

Sprint: ORI Sprint 12 (ends Apr 4)
  In Progress: ORI-234 Trip PDF renderer
  To Do: ORI-240 Budget calculator, ORI-241 Flight search
  Done: 3 issues completed this sprint

Branch: ORI-234/feat/trip-pdf-renderer
  Uncommitted: 3 files
  Ahead of main: 7 commits

Worktrees:
  ../orion-ORI-234-trip-pdf (current)
  ../orion-ORI-237-hotel-parser (stale — 3 days)

Last Checkpoint: 2026-03-28 14:30
  Worked on: PDF renderer layout, fixed header alignment

Time This Week: 12h 30m
```

Use `--all` to see all projects.

---

### `/orchestrate`

Smart multi-agent execution. Analyzes your description and picks the right workflow automatically — you don't choose modes.

```
/orchestrate "add email notifications for shipped orders"
/orchestrate "add email notifications" --tdd
/orchestrate "refactor auth into separate services"
/orchestrate "fix the login 500 error after deploy"
```

**Auto-detection:**
- Bug keywords ("fix", "broken", "error", "500") → 4-phase debugging (capture → isolate → fix → verify)
- Refactor keywords ("refactor", "restructure", "migrate") → architect review → parallel refactoring → tests → review
- Security keywords ("audit", "vulnerability") → security audit → review → architecture check
- Everything else → feature workflow (research → plan → wave execution → review)

**Composable flags:**
| Flag | Effect |
|------|--------|
| `--tdd` | Every agent writes failing tests first, then implements |
| `--e2e` | Playwright E2E tests generated after all waves complete |
| `--review` | Two-stage review (spec alignment + quality) after each wave |
| `--dry-run` | Show plan without executing, wait for approval |
| `--verify` | Run test suite between each wave, stop on failure |
| `--scope <paths>` | Constrain agents to specified files/directories only |
| `--no-commit` | Execute but don't commit — you review and commit manually |
| `--jira <KEY>` | Link to Jira: read AC, create branch, update status on completion |

**What you see during execution:**
```
Phase 1 — Research: 4 parallel researchers spawned...
Phase 2 — Plan: Implementation plan validated (3/3 checks pass)
Phase 3 — Wave Execution:
  Wave 1/3: T1 (email service), T2 (notification template) — spawning...
  Wave 1/3 complete. Tasks: 2/6 done. Commits: 2.
  Wave 2/3: T3 (order lifecycle hook), T4 (email trigger) — spawning...
  Wave 2/3 complete. Tasks: 4/6 done. Commits: 4.
  Wave 3/3: T5 (integration test), T6 (E2E test) — spawning...
  Wave 3/3 complete. Tasks: 6/6 done. Commits: 6.
Phase 4 — Review: Spec alignment PASS. Code quality APPROVE.
```

---

### `/pre-flight-check`

Your merge gate. Runs everything: two-stage code review + verification (build/types/lint/tests) + security scan on sensitive files. Reports results. Does NOT merge.

```
/pre-flight-check
```

**What you get:**
```
══════════════════════════════════════════════
         PRE-FLIGHT CHECK — ORI-234
══════════════════════════════════════════════

 Stage 1 — Spec Alignment:    PASS
 Stage 2 — Code Quality:      APPROVE
   0 CRITICAL, 0 HIGH, 2 MEDIUM, 1 LOW
 Stage 3 — Verification:      PASS
   Build: PASS | Types: PASS | Lint: PASS | Tests: 47/47 PASS
 Stage 4 — Security:          SKIPPED (no auth files modified)

══════════════════════════════════════════════
 Verdict: READY TO MERGE
══════════════════════════════════════════════
```

Use `--fix` to auto-fix medium/low issues before reporting.

---

### `/pr`

Full PR lifecycle — open, review, or respond to feedback. One command, three modes.

```
/pr                              # open PR from current branch
/pr --draft                      # open as draft
/pr --jira ORI-234               # open with Jira link
/pr --review 342                 # review someone else's PR
/pr --respond 338                # handle review comments on your PR
```

**Open mode (default):**
- Builds title following conventions: `feat(scope): capability [JIRA-KEY]`
- Generates structured body: Summary, Changes, Test Plan, Notes, Jira link
- Auto-detects Jira key from branch name
- Pushes branch and creates PR

**Review mode (`--review`):**
- Fetches diff, runs two-stage review (spec alignment + quality)
- Posts inline comments on specific lines
- Submits APPROVE or REQUEST_CHANGES

**Respond mode (`--respond`):**
- Shows each unresolved thread with the comment and code
- You choose: fix / reply / skip for each
- Fixes are committed, replies posted, threads resolved after your approval
- Never auto-resolves — always waits for your decision

---

### `/plan-work`

Create properly structured Jira cards. Enforces Epic (domain) → Story (user outcome) → Subtask (implementation step) hierarchy with strict writing rules.

```
/plan-work "users need to reset their password via email"
```

**What you get:**
```
Epic: AUTH — User Authentication and Access (existing UAT-XX)

  Story: Allow users to reset their password
    As a user, I want to reset my password via email,
    so that I can regain access when I forget my credentials.

    Acceptance Criteria:
    - [ ] User can request a reset from the login page
    - [ ] User receives a reset email within 30 seconds
    - [ ] Reset link expires after 24 hours
    - [ ] Invalid links show a clear error message

    Subtasks:
    1. Create password reset request endpoint
    2. Add email template for reset instructions
    3. Write migration for password_reset_tokens table
    4. Build reset password form component
    5. Add rate limiting (max 3 requests per hour)

Create in Jira? (y/n)
```

**Rules enforced:**
- Epic = product domain, never a phase or technical layer
- Story title = verb-first, under 60 chars, describes outcome not implementation
- AC = testable by a non-developer, no implementation details
- Subtasks = technical, concrete, under 1 day each, ordered by build sequence
- 3-6 subtasks per story (splits story if more than 8)

Also handles Bugs (symptom as title), Spikes (time-boxed investigation), and Tech Debt.

---

### `/prompt-rewrite`

Rewrite a draft prompt with proper structure. Uses Sequential Thinking to analyze each dimension before rewriting.

```
/prompt-rewrite "fix the login bug it broke after the last deploy"
```

**What you get:**
```
## Original (Score: 2/10)
fix the login bug it broke after the last deploy

## Rewritten (Score: 8/10)
Problem: Login is broken after the last deploy.

Evidence: [what error do you see? paste error message or logs]

Files:
- src/auth/login.ts
- src/middleware/session.ts

Action: Diagnose first — do NOT fix yet.

Done when: Root cause identified with evidence pointing to specific file and line.

## What Changed
- Added: structure (sections), file references, success criteria, constraints
- Score improvement: 2 → 8 (+6 points)
```

Not scored by the prompt quality hook — `/prompt-rewrite` and all slash commands are excluded from scoring.

---

### `/time-report`

Time tracking across projects. Sessions auto-logged by hooks.

```
/time-report                          # current project
/time-report --all                    # all projects
/time-report --week                   # this week
/time-report --project orion          # specific project
/time-report --all --week             # all projects, this week
```

---

## Speckit Commands (Specification Workflow)

A deliberate workflow for spec-driven development. Enter it when you want structured planning before building.

| Command | Phase | What It Does |
|---------|-------|-------------|
| `/speckit.constitution` | Setup | Define project principles |
| `/speckit.specify` | Define | Create feature spec from description |
| `/speckit.clarify` | Refine | Ask targeted questions to reduce ambiguity |
| `/speckit.plan` | Design | Generate implementation plan with data model and contracts |
| `/speckit.tasks` | Decompose | Break plan into dependency-ordered tasks |
| `/speckit.implement` | Build | Execute tasks (auto-spawns agents for 3+ tasks) |
| `/speckit.analyze` | Validate | Cross-artifact consistency check |
| `/speckit.checklist` | Verify | Generate validation checklist |
| `/speckit.taskstoissues` | Track | Push tasks to Jira/GitHub |
| `/speckit.complete` | Close | Verify completion, archive artifacts |

**Typical flow:**
```
/speckit.specify "user can export reports as PDF"
/speckit.clarify                    # answer questions about format, permissions, etc.
/speckit.plan                       # generates plan.md, data-model.md, contracts/
/speckit.tasks                      # generates tasks.md with dependencies
/speckit.implement                  # executes tasks with agents
/pre-flight-check                   # before merge
```

---

## Automatic Behaviors (No Commands Needed)

These happen without you typing anything — driven by hooks and rules in `uatu-core.md`:

| Behavior | When It Activates | What Happens |
|----------|-------------------|--------------|
| 4-phase debugging | You describe a bug or error | Capture → isolate → fix → verify (never skips to fix) |
| Two-stage code review | You ask "review this" | Spec alignment check, then quality check |
| Security scan suggestion | You modify auth/payment files | Hook suggests running security audit |
| Build auto-diagnosis | Build command fails | Reads errors, identifies root cause, applies fix |
| Prompt quality coaching | Every prompt > 5 words | Scores against structure/context/criteria, suggests improvements |
| Scope detection | Large-scope prompt | Suggests `/orchestrate` for multi-file work |
| Agent suggestion | Edit auth/db/UI files | Suggests relevant specialized agent |
| Branch guard | Session starts on main | Warns, suggests creating feature branch |
| Code auto-formatting | New files only | Runs prettier/black/gofmt (skips existing files to avoid noisy diffs) |
| Self-review checklist | After code writes | Scans for TODO, placeholders, debug statements |
| Commit cadence | 3+ tasks without commit | Nudges to commit |
| Review cadence | 10+ writes without review | Nudges to review |
| Missing test warning | Session ends | Warns about source files without test changes |
| Session checkpoint | Session ends | Auto-saves to `.uatu/delivery/checkpoints/` |
| Time logging | Session start + end | Auto-logged to `~/.uatu/time-tracking/` |

---

## Workflow Scenarios

### "Fix this bug"

Just describe it. Uatu auto-uses 4-phase debugging:
```
You: "The checkout fails with a 500 error when the cart has more than 10 items"
Claude: [Phase 1 — Capture] Collecting error details...
Claude: [Phase 2 — Isolate] Root cause: cart.items.length check uses > instead of >=
Claude: [Phase 3 — Fix] Applied fix + regression test
Claude: [Phase 4 — Verify] All tests pass. Commit: fix(cart): handle boundary at 10 items
```

### "Build a new feature" (existing system)

```
/orchestrate "add email notifications when orders are shipped" --tdd
```

Uatu runs: research (4 parallel agents) → plan → validate plan → wave execution (TDD per task) → review

### "Plan work for the sprint"

```
/plan-work "users need to be able to upload and share documents with their team"
```

Uatu creates: Epic (if new domain) → Stories (upload, share, permissions) → Subtasks (API endpoint, storage service, UI component, tests) — all in Jira.

### "Review a teammate's PR"

```
/review-pr 342
```

Uatu reads diff, checks spec alignment, reviews quality, posts inline comments on GitHub.

### "Handle review feedback on my PR"

```
/self-review 338
```

Uatu shows each comment, you decide: fix / reply / skip. Fixes are committed, replies posted, threads resolved.

### "Before I merge"

```
/pre-flight-check
```

Two-stage review + build/types/lint/tests + security scan. Shows verdict: READY or NOT READY.

### "Start my day"

```
/status
```

Sprint state, branches, worktrees, last checkpoint, time this week.

---

## Workflow Conventions

| Element | Format | Example |
|---------|--------|---------|
| Branch | `UAT-{N}/{type}/{desc}` | `UAT-61/feat/wave-execution` |
| Worktree | `uatu-UAT-{N}-{desc}` | `uatu-UAT-61-wave-execution` |
| Commit | `{type}({scope}): {subject}` | `feat(orchestrate): add wave execution` |
| PR title | `{type}({scope}): {desc} [UAT-{N}]` | `feat(orchestrate): wave execution [UAT-61]` |

Commit types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `ci`

Scope = domain or component (not project name). PR includes Jira key, commits do not.

---

## CLI Dependencies

All checked during `uatu-setup` and `uatu-install`. Installation blocks if any are missing.

### Required (all projects)

| Tool | Purpose | Install |
|------|---------|---------|
| git | Version control | https://git-scm.com |
| jq | JSON parsing (all hooks) | `brew install jq` |
| node 18+ | Runtime | https://nodejs.org |
| npx | Package runner | Comes with npm |
| gh | GitHub CLI (`/pr` command) | `brew install gh` |
| prettier | Code formatting (format hook) | `npm i -g prettier` |
| playwright-cli | E2E testing (`--e2e` flag) | `npm i -g @playwright/cli@latest` |

### Language-specific (checked with `--languages` flag)

| Language | Tools | Install |
|----------|-------|---------|
| typescript | vitest or jest | `npm i -D vitest` |
| python | black, pytest | `pip install black pytest` |
| golang | gofmt | Bundled with Go |

---

## Architecture

### Packages

| Package | When | How |
|---------|------|-----|
| **SOLO** | Independent parallel work (90% of tasks) | `/orchestrate` with wave execution |
| **SQUAD** | Agents need to coordinate mid-task | Auto-detected by `/orchestrate` when needed |
| **HIVE** | Work spans multiple sessions (experimental) | Manual setup with memory persistence |

### Project Structure (After Install)

```
your-project/
├── .claude/
│   ├── rules/uatu-core.md          # Behavioral rules (auto-loaded)
│   ├── rules/typescript.md          # Language rules (auto-loaded)
│   ├── commands/                    # 7 slash commands + speckit
│   └── skills/                      # 20 auto-triggered skills
├── .uatu/
│   ├── QUICKSTART.md                # User manual (this reference)
│   ├── UATU.md                      # Framework overview
│   ├── config/
│   │   ├── project.md               # Project settings, Jira key
│   │   ├── architecture.md          # Tech stack (auto-generated)
│   │   ├── constitution.md          # AI behavior principles
│   │   └── prompt-templates.md      # Copy-paste prompt starters
│   ├── hooks/                       # Lifecycle hooks
│   ├── guides/                      # Reference documentation
│   ├── tools/                       # Utilities (time tracking, etc.)
│   └── delivery/                    # Specs, plans, tasks, checkpoints
├── .mcp.json                        # Project-level MCP servers
└── .env                             # Tokens (gitignored)
```

---

## Stats

| Component | Count |
|-----------|-------|
| Commands | 7 + 10 speckit |
| Agents | 53 across 8 categories |
| Skills | 20 (auto-triggered by context) |
| Rules | 5 (uatu-core + 4 language rules) |
| Hooks | 17 active (session, prompt, tool, stop) |
| Packages | 3 (SOLO, SQUAD, HIVE) |

---

## Attribution

### Foundation (Directly Adopted)

| Project | Author | What Was Adopted | License |
|---------|--------|-----------------|---------|
| [spec-kit](https://github.com/anthropics/spec-kit) | GitHub, Inc. | Speckit command suite — specify, clarify, plan, tasks, implement, analyze, constitution | MIT |
| [claude-flow](https://github.com/ruvnet/claude-flow) | @ruvnet | SQUAD/HIVE package model, swarm coordination MCP tools, memory persistence | MIT |
| [awesome-claude-code-subagents](https://github.com/anthropics/awesome-claude-code-subagents) | VoltAgent Contributors | Agent library structure, YAML+frontmatter format, category organization | MIT |
| [@anthropic-ai/sequential-thinking](https://www.npmjs.com/package/@anthropic-ai/sequential-thinking) | Anthropic | Pre-analysis structured reasoning, used in `/prompt-rewrite` and `/plan-work` | — |

### Inspiration (Patterns & Ideas)

| Project | Author | What We Learned | License |
|---------|--------|-----------------|---------|
| [claude-mem](https://github.com/thedotmack/claude-mem) | @thedotmack | Cross-session memory patterns, 3-layer progressive search | AGPL-3.0 |
| [superpowers](https://github.com/obra/superpowers) | @obra | Two-stage code review, systematic 4-phase debugging, self-review checklists | MIT |
| [get-shit-done](https://github.com/gsd-build/get-shit-done) | @gsd-build | Wave-based execution, context rot prevention, atomic commits, plan validation | — |
| [ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | @nextlevelbuilder | Design intelligence knowledge base, pre-delivery UX checklist | — |
| [n8n-mcp](https://github.com/czlonkowski/n8n-mcp) | @czlonkowski | MCP server integration patterns for external tools | MIT |
| [obsidian-skills](https://github.com/kepano/obsidian-skills) | @kepano | Agent Skills specification, modular skill architecture | MIT |
| [LightRAG](https://github.com/hkuds/lightrag) | @hkuds | Graph-based knowledge retrieval concepts | MIT |
| [everything-claude-code](https://github.com/affaan-m/everything-claude-code) | @affaan-m | Language rule ecosystems, AgentShield security scanning, build-error-resolver agents | — |
| [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | @hesreallyhim | Ecosystem curation, resource validation patterns | CC-BY-NC-ND-4.0 |

---

## License

MIT
