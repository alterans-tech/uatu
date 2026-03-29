# Agent Selection Guide

> Comprehensive guide for selecting and using specialized agents, especially in swarm scenarios.

> **Load when:** Selecting which agent to spawn, designing multi-agent compositions, or creating custom agents.

---

## Overview

Agents are specialized sub-systems within Uatu that provide focused expertise for specific domains. Each agent has:

- **Name**: Unique identifier for the agent
- **Type**: Category classification (analyst, architect, coder, validator, etc.)
- **Description**: Purpose and capabilities
- **Model**: Recommended Claude model (opus, sonnet, haiku)
- **Capabilities**: List of specialized skills
- **Priority**: Importance level for task selection
- **Hooks**: Pre/post execution scripts (optional)
- **SPARC Phase**: For SPARC methodology agents (optional)

### Agent Location

All agents are located in `~/.claude/agents/` organized by category:
- `core/` - General development and orchestration agents
- `sparc/` - SPARC methodology agents
- `github/` - GitHub integration agents
- `firebase/` - Firebase-specific agents
- `languages/` - Language specialists
- `infrastructure/` - Cloud and DevOps agents
- `quality/` - Testing and review agents
- `testing/` - TDD and production validation specialists
- `data/` - Database and data engineering agents
- `specialized/` - Domain-specific agents
- `orchestration/` - Coordination agents
- `swarm/` - Swarm topology coordinators
- `consensus/` - Distributed consensus agents
- `templates/` - Template generators and patterns

---

## Agent Categories

### Core Development

| Agent | Best For | Model |
|-------|----------|-------|
| `coder` | General code implementation | sonnet |
| `fullstack-developer` | End-to-end features spanning frontend/backend | sonnet |
| `frontend-developer` | React, Vue, UI components, CSS | sonnet |
| `backend-architect` | API design, service architecture | sonnet |
| `microservices-architect` | Distributed systems, service boundaries | opus |
| `architect-review` | Architecture decisions, design patterns | sonnet |
| `ui-ux-designer` | Design systems, accessibility, user flows | sonnet |

### Language Specialists

| Agent | Best For | Model |
|-------|----------|-------|
| `typescript-pro` | TypeScript, advanced types, generics | sonnet |
| `python-pro` | Python 3.11+, async, data science | sonnet |
| `golang-pro` | Go concurrency, performance | sonnet |
| `rust-pro` | Rust, memory safety, systems | sonnet |
| `java-pro` | Java 21+, Spring Boot, enterprise | sonnet |
| `javascript-pro` | Modern JS, Node.js, async patterns | sonnet |
| `flutter-pro` | Flutter, Dart, cross-platform mobile | sonnet |

### Infrastructure & DevOps

| Agent | Best For | Model |
|-------|----------|-------|
| `cloud-architect` | AWS/Azure/GCP, multi-cloud design | opus |
| `kubernetes-architect` | K8s, service mesh, GitOps | opus |
| `terraform-specialist` | IaC, state management, modules | sonnet |
| `deployment-engineer` | CI/CD, GitOps, deployments | sonnet |
| `sre-engineer` | SLOs, observability, reliability | sonnet |
| `monitoring-specialist` | Metrics, logging, alerting | sonnet |

### Data & AI

| Agent | Best For | Model |
|-------|----------|-------|
| `database-expert` | Database administration, query optimization, schema design | sonnet |
| `data-engineer` | ETL pipelines, data warehousing | sonnet |
| `ml-engineer` | ML systems, model serving | opus |
| `llm-architect` | LLM applications, RAG, fine-tuning | opus |

### Quality & Security

| Agent | Best For | Model |
|-------|----------|-------|
| `reviewer` | Code review, best practices | sonnet |
| `tester` | Unit/integration/E2E testing | sonnet |
| `tdd-london-swarm` | London School TDD: mock-driven test-first development | sonnet |
| `production-validator` | Pre-deployment production readiness checklist | sonnet |
| `test-automator` | Test automation frameworks | sonnet |
| `debugger` | Bug investigation, root cause | sonnet |
| `security-auditor` | Security audit, compliance | opus |
| `performance-engineer` | Performance optimization | sonnet |
| `chaos-engineer` | Resilience testing, chaos experiments | sonnet |

### Orchestration

| Agent | Best For | Model |
|-------|----------|-------|
| `planner` | Task decomposition, planning | opus |
| `researcher` | Investigation, codebase exploration | sonnet |
| `orchestrator-task` | Native task decomposition + multi-agent coordination (no MCP) | sonnet |
| `multi-agent-coordinator` | Coordinating multiple agents | opus |
| `swarm-coordinator` | SQUAD/HIVE swarm orchestration | opus |

### Specialized

| Agent | Best For | Model |
|-------|----------|-------|
| `prompt-engineer` | Prompt design, LLM optimization | opus |
| `refactoring-specialist` | Code improvement, tech debt | sonnet |
| `api-documenter` | API documentation, OpenAPI | sonnet |
| `docs-architect` | Technical documentation | sonnet |

---

## Dynamic Scaling

All packages (SOLO, SQUAD, HIVE, WATCHER) support the same scaling tiers. The orchestrator decomposes the task and selects a tier based on work unit count:

| Tier | Agents | When | Worktree |
|------|--------|------|----------|
| **Micro** | 1-2 | Single file, single concern | No |
| **Small** | 3-5 | Feature touching 2-5 files | Write agents only |
| **Medium** | 6-12 | Cross-cutting feature, multi-module | Write agents only |
| **Large** | 13-25 | Major feature, system migration | All write agents |
| **Swarm** | 25+ | Org-wide refactoring, mass changes | Mandatory for all |

Package choice is about **coordination model**, not agent count. See SQUAD-GUIDE.md for details.

---

## Spawning Multiple Agents of the Same Type

You CAN and SHOULD spawn duplicate agents when the task has multiple independent work units of the same kind.

### Naming Convention

```
{agent-type}-{index}
Examples: coder-1, coder-2, coder-3, tester-1, tester-2
```

### When to Duplicate

| Scenario | Pattern |
|----------|---------|
| 8 files need refactoring | 8 `coder-N` agents, one per file |
| 5 modules need tests | 5 `tester-N` agents, one per module |
| 3 areas to investigate | 3 `researcher-N` agents, each with a focus |
| Large codebase audit | 4 `security-auditor-N` agents, each scanning a directory |

### Batch Spawning Rule

Spawn ALL parallel agents in a SINGLE message (multiple `Agent` tool calls in one response). This enables true parallelism:

```
# All three start simultaneously
Agent(subagent_type="coder", name="coder-1", prompt="Refactor src/auth.ts...", isolation="worktree", run_in_background=true)
Agent(subagent_type="coder", name="coder-2", prompt="Refactor src/users.ts...", isolation="worktree", run_in_background=true)
Agent(subagent_type="coder", name="coder-3", prompt="Refactor src/payments.ts...", isolation="worktree", run_in_background=true)
```

---

## Agent Isolation Requirements

| Agent Category | Needs `isolation: "worktree"`? | Reason |
|----------------|-------------------------------|--------|
| coder, fullstack-developer, refactoring-specialist | **YES** | Writes/modifies files |
| tester (creating test files) | **YES** | Creates new test files |
| researcher, Explore, architect-review | No | Read-only |
| reviewer, security-auditor | No | Read-only analysis |
| debugger (investigating) | No | Read-only |
| debugger (applying fix) | **YES** | Writes fix to files |

---

## Swarm Usage Patterns

### SOLO + Orchestrator (Independent Parallel Work)

For tasks where agents work independently — no inter-agent communication needed. Use `orchestrator-task` agent or `/orchestrate swarm`.

```
Sequential Thinking → Independent parallel work → SOLO + orchestrator

Example compositions:
- Refactor 10 files: 10 coder-N agents, each in worktree
- Write tests for 5 modules: 5 tester-N agents
- Research 3 topics: 3 researcher-N agents
```

### SQUAD (Coordinated Parallel Work)

For tasks where agents need to communicate mid-work via SendMessage and shared memory.

```
Sequential Thinking → Agents need to talk → SQUAD

Example compositions:
- Full-stack feature: frontend-dev + backend-architect coordinate API contract
- Design convergence: multiple architects discuss and agree on approach
- Bug investigation: debugger shares findings, coder adapts implementation
```

### HIVE (Multi-Session Persistence)

For multi-phase projects requiring context persistence across sessions.

```
Sequential Thinking → Multi-day work → HIVE

Example compositions:
- Major refactoring: architect-review, refactoring-specialist, coder, tester
- System migration: planner, microservices-architect, data-engineer, sre-engineer
```

### ruv-swarm (Advanced option for SQUAD/HIVE)

For complex analysis requiring cognitive patterns, learning, and no-timeout execution.

```
Sequential Thinking → Deep/long-running analysis → SQUAD or HIVE with ruv-swarm

Typical ruv-swarm uses:
- Architecture analysis: divergent + systems cognitive patterns
- Security audit: critical + convergent patterns
- Performance optimization: convergent + adaptive patterns
```

---

## Routing Table

Deterministic agent selection based on file patterns and task keywords. Use this table when you need a quick match instead of reasoning through the full selection matrix.

### By File Pattern

| File Pattern | Primary Agent | Supporting |
|-------------|---------------|------------|
| `*.test.ts`, `*.spec.ts`, `*.test.js` | `tester` | `tdd-london-swarm` |
| `*.tsx`, `*.jsx`, `*.css`, `*.scss` | `frontend-developer` | `ui-ux-designer` |
| `*.tf`, `*.tfvars`, `terraform/` | `terraform-specialist` | `cloud-architect` |
| `Dockerfile`, `docker-compose.*`, `*.yaml` (k8s) | `deployment-engineer` | `kubernetes-architect` |
| `*.py` (FastAPI/Django/Flask) | `python-pro` | `backend-architect` |
| `*.go` | `golang-pro` | `backend-architect` |
| `*.rs` | `rust-pro` | `performance-engineer` |
| `*.ts` (API routes, services) | `typescript-pro` | `backend-architect` |
| `*.sql`, `migrations/`, `prisma/`, `drizzle/` | `database-expert` | `database-expert` |
| `.github/workflows/`, `ci/` | `deployment-engineer` | `sre-engineer` |
| `openapi.*`, `swagger.*` | `api-documenter` | `backend-architect` |
| `firebase.*`, `firestore.rules` | Use matching `firebase-*` specialist | — |

### By Task Keyword

| Keywords in Request | Primary Agent | Package |
|--------------------|---------------|---------|
| "fix", "bug", "broken", "error", "crash" | `debugger` | SOLO |
| "refactor", "clean up", "restructure" | `refactoring-specialist` | SOLO |
| "security", "vulnerability", "audit", "OWASP" | `security-auditor` | SOLO |
| "performance", "slow", "optimize", "latency" | `performance-engineer` | SOLO |
| "test", "coverage", "TDD" | `tester` | SOLO |
| "deploy", "CI/CD", "pipeline", "release" | `deployment-engineer` | SOLO |
| "design", "architecture", "system design" | `architect-review` | SOLO |
| "API", "endpoint", "REST", "GraphQL" | `backend-architect` | SOLO |
| "UI", "component", "layout", "responsive" | `frontend-developer` | SOLO |
| "database", "query", "migration", "schema" | `database-expert` | SOLO |
| "multi-file", "refactor all", "migrate" | `orchestrator-task` | SOLO (swarm) |
| "coordinate", "negotiate", "co-design" | `/orchestrate` (auto-detects SQUAD) | SQUAD |

### Routing Priority

When multiple patterns match: **task keyword > file pattern > default**. The task keyword captures intent; the file pattern captures scope.

---

## Agent Selection Matrix

### By Task Type

| Task Type | Primary Agent | Supporting Agents |
|-----------|---------------|-------------------|
| Bug fix | `debugger` | `coder`, `tester` |
| New feature | `coder` | `tester`, `reviewer` |
| Refactoring | `refactoring-specialist` | `coder`, `tester` |
| Performance | `performance-engineer` | `database-expert` |
| Security fix | `security-auditor` | `coder`, `tester` |
| API design | `backend-architect` | `api-documenter` |
| UI work | `frontend-developer` | `ui-ux-designer` |
| Data work | `data-engineer` | `database-expert` |
| Infrastructure | `cloud-architect` | `terraform-specialist` |

### By Complexity (Scaling Tiers)

| Complexity | Tier | Package | Agents |
|------------|------|---------|--------|
| Trivial | Micro (1-2) | SOLO | Single best-fit agent |
| Simple feature | Small (3-5) | SOLO + orchestrator | 2-5 agents in parallel |
| Cross-cutting | Medium (6-12) | SOLO + orchestrator or SQUAD | 6-12 agents, write agents in worktrees |
| Major feature | Large (13-25) | SOLO + orchestrator or SQUAD | 13-25 agents, all writers in worktrees |
| Mass refactoring | Swarm (25+) | SOLO + orchestrator | 25+ agents, mandatory worktrees |
| Multi-session | Any tier | HIVE | Any scale + cross-session persistence |
| Deep analysis | Any tier | SQUAD/HIVE + ruv-swarm | Cognitive patterns + no timeout |

### By Risk Level

| Risk | Primary Agent | Required Validation |
|------|---------------|-------------------|
| Low | Any appropriate | Self-review |
| Medium | + `reviewer` | Peer review |
| High | + `security-auditor` | Security + code review |
| Critical | + `architect-review` | Full review chain |

---

## Model Selection

### When to Use `opus`

- Architecture decisions
- Security audits
- Complex planning and decomposition
- Multi-agent coordination
- LLM/AI system design
- High-stakes decisions

### When to Use `sonnet`

- Standard implementation work
- Testing and debugging
- Code review
- Documentation
- Routine operations
- Cost-sensitive tasks

### When to Use `haiku`

- Quick lookups
- Simple transformations
- Validation checks
- Formatting tasks

---

## Best Practices

### 1. Start with Sequential Thinking

Always use Sequential Thinking before selecting agents. It will recommend:
- Whether agents are needed
- Which agents to use
- What package (SOLO, SQUAD, HIVE, WATCHER)

### 2. Match Agent to Task

- Don't use `opus` agents for simple tasks (cost inefficient)
- Don't use `sonnet` for critical security or architecture decisions
- Use specialist agents for domain-specific work

### 3. Coordinate Properly

- In SQUAD: Designate a coordinator agent
- In HIVE: Use hierarchical topology with clear queen
- Always have a reviewer in significant changes

### 4. Validate Results

- Use `reviewer` after significant code changes
- Use `tester` to verify correctness
- Use `security-auditor` for security-sensitive code

### 5. Document Decisions

- Let `planner` document task decomposition
- Use `docs-architect` for significant changes
- Maintain architecture decisions in ADRs

---

## Quick Reference

### Most Common Combinations

```
Bug Fix:        debugger → coder → tester → reviewer
New Feature:    planner → coder → tester → reviewer
Refactoring:    refactoring-specialist → coder → tester
API Work:       backend-architect → coder → api-documenter → tester
Frontend:       ui-ux-designer → frontend-developer → tester
Infrastructure: cloud-architect → terraform-specialist → sre-engineer
Security:       security-auditor → coder → tester
Performance:    performance-engineer → database-expert → tester
```

### Emergency Agents

| Situation | Agent |
|-----------|-------|
| Production bug | `debugger` → `coder` (minimal fix) |
| Security incident | `security-auditor` (assess) → `coder` (fix) |
| Performance crisis | `performance-engineer` → `database-expert` |
| Test failures | `tester` → `debugger` → `coder` |

---

## Agent Frontmatter Format

All agents use YAML frontmatter with the following structure:

### Basic Agent (minimal)
```yaml
---
name: agent-name
description: Brief description of agent purpose
model: sonnet
---
```

### Full Agent Definition
```yaml
---
name: agent-name
type: analyst|architect|coder|validator|coordinator
color: "#HexColor" or "color-name"
description: Detailed description of agent capabilities
capabilities:
  - capability_1
  - capability_2
  - capability_3
priority: low|medium|high|critical
model: opus|sonnet|haiku
tools:
  - Read
  - Write
  - Edit
  - Bash
  - mcp__service__tool_name
sparc_phase: specification|pseudocode|architecture|refinement|completion
hooks:
  pre: |
    echo "Pre-execution script"
    # Validation or setup
  post: |
    echo "Post-execution script"
    # Cleanup or reporting
---
```

### Frontmatter Fields Explained

| Field | Required | Description | Values |
|-------|----------|-------------|--------|
| `name` | Yes | Unique agent identifier | kebab-case string |
| `description` | Yes | Agent purpose and capabilities | Text description |
| `model` | No | Recommended Claude model | opus, sonnet, haiku, inherit (default) |
| `type` | No | Agent category | analyst, architect, coder, validator, coordinator |
| `color` | No | UI/visualization color | Hex code or color name |
| `capabilities` | No | List of specific skills | Array of strings |
| `priority` | No | Selection priority | low, medium, high, critical |
| `tools` | No | Allowed tools (inherits all if omitted) | Array of tool names |
| `disallowedTools` | No | Denylist of tools | Array of tool names |
| `maxTurns` | No | Max agentic turns before agent stops | Number (default: unlimited) |
| `permissionMode` | No | Permission control | default, acceptEdits, dontAsk, bypassPermissions, plan |
| `background` | No | Always run as background task | true/false |
| `isolation` | No | Run in isolated git worktree | `worktree` |
| `memory` | No | Persistent memory scope | user, project, local |
| `skills` | No | Skills injected at startup | Array of skill names |
| `mcpServers` | No | MCP servers scoped to this agent | Array of server names |
| `sparc_phase` | No | SPARC methodology phase | specification, pseudocode, architecture, refinement, completion |
| `hooks` | No | Execution scripts | `pre` and `post` shell scripts |

### Spawn-Time Overrides

Many frontmatter fields can be overridden when spawning an agent. The orchestrator typically provides these at spawn time rather than hardcoding them in the agent definition:

```
Agent(
  subagent_type="coder",
  name="coder-1",              # unique name for this instance
  isolation="worktree",         # worktree isolation for parallel writes
  run_in_background=true,       # non-blocking execution
  model="sonnet",               # model override
  mode="acceptEdits"            # permission mode override
)
```

---

## Creating Custom Agents

### 1. Choose Agent Category

Determine which directory your agent belongs to:
- General development → `core/`
- TDD, production validation → `testing/`
- Language-specific → `languages/`
- GitHub operations → `github/`
- Testing/QA → `quality/`
- Infrastructure → `infrastructure/`
- Specialized domain → `specialized/`

### 2. Create Agent File

```bash
# Navigate to agent directory
cd ~/.claude/agents/{category}/

# Create agent file
touch my-agent.md

# Edit with frontmatter + instructions
```

### 3. Define Agent Instructions

After the frontmatter, write clear instructions for the agent:

```markdown
---
name: my-agent
description: Custom agent for specific task
model: sonnet
---

# My Agent

You are a specialist in [domain]. Your role is to [purpose].

## Capabilities
- Capability 1
- Capability 2

## Approach
1. Analyze requirements
2. Execute specialized task
3. Validate results
4. Report findings

## Best Practices
- Practice 1
- Practice 2
```

### 4. Test Your Agent

```bash
# Test agent by spawning it
Task tool with subagent_type: "my-agent"
```

---

## Agent Selection Decision Tree

```
                         TASK ANALYSIS
                              │
                              ▼
                    ┌─────────┴─────────┐
                    │   Task Domain?    │
                    └─────────┬─────────┘
                              │
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
     DEVELOPMENT           ANALYSIS          INFRASTRUCTURE
          │                   │                   │
     ┌────┴────┐         ┌────┴────┐         ┌────┴────┐
     ▼         ▼         ▼         ▼         ▼         ▼
  Single   Multiple   Code     Security   Cloud    Database
  File     Files      Review   Audit      Arch     Optimize
     │         │         │         │         │         │
     ▼         ▼         ▼         ▼         ▼         ▼
  coder    SQUAD     reviewer  security  cloud-   database-
                              -auditor  architect optimizer
```

---

## Advanced Agent Patterns

### 1. Sequential Agent Chain
```
Task: Complex refactoring

Chain:
  1. architect-review → analyze design
  2. refactoring-specialist → plan refactor
  3. coder → implement changes
  4. tester → validate behavior
  5. reviewer → final review
```

### 2. Parallel Agent Swarm (SQUAD)
```
Task: Full-stack feature

Swarm (parallel):
  - frontend-developer → UI components
  - backend-architect → API design
  - database-expert → schema design
  - tester → test strategy

Coordinator: planner
```

### 3. Hierarchical Agent Network (HIVE)
```
Task: Multi-day migration

Hierarchy:
  Queen: planner
    ├─ Worker: researcher (phase 1)
    ├─ Worker: architect-review (phase 2)
    ├─ Worker: coder (phase 3)
    └─ Worker: tester (phase 4)

Persistence: cross-session memory
```

### 4. Learning Agent System (WATCHER)
```
Task: Codebase pattern learning across sessions

SQUAD with ruv-swarm: Single-session deep learning (no timeout)
  - daa_agent with cognitivePattern: "divergent"
  - neural_train for pattern recognition
  - Extract learnings at session end

WATCHER: Multi-session learning + persistence (Ruflo CLI)
  - ruv-swarm for learning (neural, DAA)
  - HIVE for cross-session persistence
  - Patterns saved and restored across sessions
```

---

## Agent Hooks Deep Dive

### Pre-Hooks (Validation & Setup)

```bash
hooks:
  pre: |
    # Validate environment
    [ -f package.json ] || (echo "No package.json found" && exit 1)

    # Check dependencies
    npm list jest >/dev/null 2>&1 || npm install jest

    # Store context
    memory_store "task_start" "$(date +%s)"

    # Announce
    echo "🚀 Starting agent: $AGENT_NAME"
```

### Post-Hooks (Reporting & Cleanup)

```bash
hooks:
  post: |
    # Generate report
    echo "📊 Task completed in $(($(date +%s) - $task_start))s"

    # Run validation
    npm test || echo "⚠️  Tests failed"

    # Store results
    memory_store "task_result_$(date +%s)" "$RESULT"

    # Cleanup
    rm -f /tmp/agent-temp-*
```

---

## Best Practices for Agent Design

### 1. Single Responsibility
Each agent should focus on ONE domain or task type.

**Good**: `typescript-pro` - TypeScript specialist
**Bad**: `general-coder` - Does everything

### 2. Clear Capabilities
List specific, measurable capabilities.

**Good**:
```yaml
capabilities:
  - react_hooks_optimization
  - state_management_patterns
  - performance_profiling
```

**Bad**:
```yaml
capabilities:
  - frontend_work
  - makes_things_better
```

### 3. Appropriate Model Selection

| Task Complexity | Model | Cost | When to Use |
|----------------|-------|------|-------------|
| Simple transformations | haiku | $ | Quick, routine tasks |
| Standard implementation | sonnet | $$ | Most development work |
| Critical decisions | opus | $$$ | Architecture, security |

### 4. Meaningful Hooks

Use hooks for:
- Environment validation
- Dependency checking
- Progress tracking
- Result reporting
- NOT for core agent logic

### 5. Documentation

Every agent should have:
- Clear purpose statement
- Capability list
- Usage examples
- Best practices
- Common pitfalls

---

*Uatu Agent Guide v2.0*
