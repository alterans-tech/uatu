# Uatu - The Watcher

AI orchestration framework for Claude Code. Installs specialized agents, slash commands, skills, hooks, and workflow conventions into any project.

---

## Quick Start

```bash
# 1. Clone and add to PATH (one-time)
git clone https://github.com/YOUR-USERNAME/uatu.git
cd uatu && ./setup.sh && source ~/.zshrc

# 2. Install user-level MCP servers (one-time per machine)
uatu-setup

# 3. Install into a project
cd /path/to/your-project
uatu-install
```

After install, copy `.env.example` to `.env`, fill in your tokens, and run `direnv allow`.

---

## What Uatu Does

**Proactive advisor.** Before every task, Uatu reads the request and suggests the right command — `/debug` for bugs with unknown root cause, `/orchestrate` for multi-file changes, `/speckit.specify` before writing code for a new feature. It also coaches vague prompts before they waste tokens.

**Specification-driven development.** The `/speckit.*` commands walk from raw idea to deployed code: specify → clarify → plan → tasks → implement. Artifacts live in `.uatu/delivery/` and stay in sync across the chain.

**Multi-agent orchestration.** Commands spawn agents automatically. The `orchestrate` command executes wave-based swarms — agents run in parallel within a wave, waves are dependency-ordered. The `squad` command uses Agent Teams with peer messaging for tightly coordinated work.

---

## Commands Reference

### Workflow Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/orchestrate swarm` | Wave-based parallel swarm. Prevents context rot. | `/orchestrate swarm "migrate auth to JWT"` |
| `/orchestrate feature` | End-to-end: plan → code → test → review | `/orchestrate feature "add rate limiting"` |
| `/orchestrate bugfix` | Systematic: debug → fix → test → review | `/orchestrate bugfix "login fails on mobile"` |
| `/squad` | Agent team with peer messaging | `/squad "refactor payment module"` |
| `/debug` | 4-phase: capture → isolate → fix → verify | `/debug "memory leak in worker pool"` |
| `/research` | 4 parallel researchers before planning | `/research "evaluate trpc vs rest for this API"` |
| `/tdd` | Write failing tests first, then implement | `/tdd "order cancellation service"` |
| `/e2e` | Generate and run Playwright E2E tests | `/e2e "checkout flow"` |
| `/code-review` | Two-stage review: spec alignment then quality | `/code-review` |
| `/security-scan` | Graded scan (A-F): secrets, auth, deps, config | `/security-scan` |
| `/verify` | Full gate: build + types + lint + tests + security | `/verify` |
| `/checkpoint` | Save session state to `.uatu/delivery/` | `/checkpoint` |
| `/build-fix` | Diagnose and fix build errors | `/build-fix` |
| `/time` | Time tracking across sprints | `/time --week` |
| `/run-assessment` | Prompt quality assessment with percentile | `/run-assessment` |
| `/prompt-rewrite` | Restructure a draft prompt with file refs and criteria | `/prompt-rewrite "fix the thing"` |
| `/refactor-clean` | Refactor for readability without behavior change | `/refactor-clean src/services/auth.ts` |
| `/test-coverage` | Coverage report with gap analysis | `/test-coverage` |
| `/update-docs` | Sync documentation to current code | `/update-docs` |
| `/skill-create` | Generate a SKILL.md from local git patterns | `/skill-create` |
| `/aside` | Ask a question without affecting session context | `/aside "what does this regex do?"` |

### Speckit Commands

| Command | Description |
|---------|-------------|
| `/speckit.specify` | Create feature specification from natural language |
| `/speckit.clarify` | Ask up to 5 targeted questions to reduce ambiguity |
| `/speckit.plan` | Generate implementation plan (architecture, design) |
| `/speckit.tasks` | Create dependency-ordered task breakdown |
| `/speckit.implement` | Execute tasks — auto-spawns agents for 3+ tasks |
| `/speckit.analyze` | Cross-artifact consistency check (non-destructive) |
| `/speckit.checklist` | Generate validation checklist for the feature |
| `/speckit.constitution` | Define project principles, sync to templates |
| `/speckit.taskstoissues` | Push tasks to Jira or GitHub Issues |
| `/speckit.complete` | Mark feature complete, archive artifacts |

---

## Workflow Conventions

### Branch Naming

```
UAT-{N}/{type}/{short-desc}

UAT-42/feat/rate-limiting
UAT-43/fix/mobile-login-crash
UAT-44/refactor/payment-module
```

### Worktree Naming

```
uatu-UAT-{N}-{short-desc}

uatu-UAT-42-rate-limiting
```

### Commit Format

```
{type}({scope}): {subject}

feat(auth): add JWT refresh token rotation
fix(worker): resolve memory leak in pool cleanup
refactor(payment): extract charge logic into service
```

No Jira key in commit messages. Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `ci`.

### PR Title Format

```
{type}({scope}): {capability delivered} [UAT-{N}]

feat(auth): JWT refresh token rotation with sliding expiry [UAT-42]
fix(worker): resolve memory leak under sustained load [UAT-43]
```

Scope is the domain or component name — not the project name. Description states the capability delivered, not the work done.

---

## Workflow Scenarios

### Bug fix (known location)

```
/debug "NPE in OrderService.cancel when order has no items"
# → fix + tests
/verify
# → commit + PR
```

### Debugging logs (unknown root cause)

```
/debug "intermittent 502 on /api/checkout under load"
# → 4-phase: reproduce → isolate → fix → verify
/checkpoint   # save mid-session state
/verify
```

### New feature (existing system)

```
/speckit.specify "rate limiting per API key"
/speckit.clarify        # answer questions
/speckit.plan
/speckit.tasks
/speckit.implement      # spawns agents
/code-review
/verify
```

### Define new feature (before sprint)

```
/research "evaluate Redis vs in-memory for rate limit counters"
/speckit.specify "rate limiting"
/speckit.clarify
/speckit.plan
/speckit.taskstoissues  # push to Jira
```

### Full new system

```
/speckit.constitution   # define principles
/research "prior art for this domain"
/speckit.specify "system overview"
/speckit.plan
/speckit.tasks
/orchestrate feature "build phase 1"
/e2e "critical user journeys"
/verify
```

---

## Architecture

### Packages

Three execution modes. Sequential Thinking selects the appropriate one based on task complexity.

| Package | Layer | Use For |
|---------|-------|---------|
| **SOLO** | Single agent | Quick fixes, single files, clear scope |
| **SQUAD** | Agent Teams + Claude Flow MCP | Multi-file coordinated features |
| **HIVE** | SQUAD + persistence | Multi-session projects, cross-session memory |

> **The Fundamental Law:** MCP tools coordinate strategy. The Task tool executes with real agents. They work together — not as alternatives.

### Hook System

8 hooks triggered by Claude Code events:

| Hook | Trigger | Purpose |
|------|---------|---------|
| `load-project-context.sh` | SessionStart | Load project config and constitution |
| `session-restore.sh` | SessionStart | Restore last session checkpoint |
| `enforce-sequential-thinking.sh` | UserPromptSubmit | Enforce structured reasoning |
| `prevent-sensitive-writes.sh` | PreToolUse | Block writes to `.env`, credentials, keys |
| `format-code.sh` | PostToolUse | Auto-format after file edits |
| `update-jira.sh` | Stop | Update Jira ticket status |
| `session-checkpoint.sh` | Stop | Save session summary |
| `cost-tracking.sh` | Stop | Log session cost for review |

### Agent System

50 specialized agents across 8 categories. Commands spawn them automatically.

| Category | Count | Key Agents |
|----------|-------|------------|
| Core | 12 | `coder`, `tester`, `reviewer`, `planner`, `researcher`, `orchestrator-task`, `architect-review`, `backend-architect`, `frontend-developer`, `fullstack-developer` |
| Firebase | 12 | `firebase-auth-specialist`, `firebase-firestore-specialist`, `firebase-functions-specialist`, `firebase-crashlytics-specialist` |
| Languages | 7 | `typescript-pro`, `python-pro`, `golang-pro`, `rust-pro`, `java-pro`, `javascript-pro`, `flutter-pro` |
| Data & AI | 6 | `database-admin`, `database-optimizer`, `ml-engineer`, `llm-architect`, `sql-pro`, `data-engineer` |
| Infrastructure | 6 | `cloud-architect`, `kubernetes-architect`, `terraform-specialist`, `deployment-engineer`, `monitoring-specialist`, `sre-engineer` |
| Quality | 5 | `debugger`, `security-auditor`, `performance-engineer`, `test-automator`, `chaos-engineer` |
| GitHub | 5 | `pr-manager`, `issue-tracker`, `release-manager`, `repo-architect`, `workflow-automation` |
| Specialized | 5 | `jira-specialist`, `agile-coach`, `api-documenter`, `prompt-engineer`, `refactoring-specialist` |
| Testing | 2 | `tdd-london-swarm`, `production-validator` |

For the full catalog: `.uatu/guides/AGENTS-GUIDE.md`

---

## Stats

| Component | Count |
|-----------|-------|
| Agents | ~50 across 9 categories |
| Commands | ~30 (`/orchestrate`, `/speckit.*`, workflow commands) |
| Skills | ~20 (react-component, test-file + language/pattern skills) |
| Hooks | ~15 (8 active + examples) |
| Packages | 3 (SOLO, SQUAD, HIVE) |

---

## Attribution

### Foundation (directly adopted)

| Project | Author | What Was Adopted | License |
|---------|--------|-----------------|---------|
| [spec-kit](https://github.com/closedloop-technologies/spec-kit) | ClosedLoop Technologies | Speckit workflow — the full specify → clarify → plan → tasks → implement chain | MIT |
| [claude-flow](https://github.com/ruvnet/claude-flow) | ruvnet | Claude Flow MCP (SQUAD/HIVE coordination, shared memory, DAA agents) | Apache-2.0 |
| [awesome-claude-code-subagents](https://github.com/hesreallyhim/awesome-claude-code-subagents) | hesreallyhim | Curated agent collection — base agent definitions across all categories | MIT |
| [sequential-thinking](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking) | Anthropic / MCP | Sequential Thinking MCP server for structured task analysis | MIT |

### Inspiration (patterns and ideas)

| Project | Author | What Was Learned | License |
|---------|--------|-----------------|---------|
| [claude-mem](https://github.com/grll/claude-mem) | grll | Memory system design — session checkpoints and context restoration patterns | MIT |
| [superpowers](https://github.com/SuperpoweredAI/spRAG) | Superpowered AI | Agent capability extension patterns and tool selection heuristics | Apache-2.0 |
| [get-shit-done](https://github.com/patchy631/ai-engineering-hub) | Patchy631 | Pragmatic task execution flow — commit early, verify often | MIT |
| [ui-ux-pro-max](https://github.com/slamdunc/ui-ux-pro-max) | slamdunc | UX-first agent design — frequency-based hierarchy and header conventions | MIT |
| [n8n-mcp](https://github.com/leonardsellem/n8n-mcp) | leonardsellem | Workflow automation bridge — hook trigger patterns for external integrations | MIT |
| [obsidian-skills](https://github.com/MarkMindCkm/obsidian-markmind) | MarkMindCkm | Knowledge graph patterns for session memory and delivery artifact linking | MIT |
| [LightRAG](https://github.com/HKUDS/LightRAG) | HKUDS | Graph-based retrieval for architecture scanning and cross-artifact analysis | MIT |
| [everything-claude-code](https://github.com/disler/everything-claude-code) | disler | 16 production skills (tdd-workflow, security-review, backend/frontend-patterns, python, golang, api-design) | MIT |
| [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | hesreallyhim | Command organization patterns and slash command naming conventions | MIT |

---

## License

MIT
