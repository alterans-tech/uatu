# Agent Selection Guide

> Comprehensive guide for selecting and using specialized agents, especially in swarm scenarios.

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
- `core/` - General development agents
- `sparc/` - SPARC methodology agents
- `github/` - GitHub integration agents
- `firebase/` - Firebase-specific agents
- `languages/` - Language specialists
- `infrastructure/` - Cloud and DevOps agents
- `quality/` - Testing and review agents
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
| `database-optimizer` | Query optimization, indexing, caching | opus |
| `database-admin` | Database operations, replication | sonnet |
| `sql-pro` | Complex queries, data modeling | sonnet |
| `data-engineer` | ETL pipelines, data warehousing | sonnet |
| `ml-engineer` | ML systems, model serving | opus |
| `llm-architect` | LLM applications, RAG, fine-tuning | opus |

### Quality & Security

| Agent | Best For | Model |
|-------|----------|-------|
| `code-reviewer` | Code review, best practices | sonnet |
| `tester` | Unit/integration/E2E testing | sonnet |
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

## Swarm Usage Patterns

### SQUAD Mode (Quick Coordination)

For tasks requiring 5-8 agents working in parallel on related subtasks.

```
Sequential Thinking → Identify need for coordination → SQUAD

Typical SQUAD compositions:
- Feature development: coder, tester, code-reviewer
- Full-stack: frontend-developer, backend-architect, database-optimizer
- Security audit: security-auditor, code-reviewer, tester
```

**Example: New Feature Implementation**

```json
{
  "swarm": "SQUAD",
  "agents": [
    {"type": "planner", "task": "decompose feature into tasks"},
    {"type": "frontend-developer", "task": "implement UI components"},
    {"type": "backend-architect", "task": "design and implement API"},
    {"type": "tester", "task": "write tests for new feature"},
    {"type": "code-reviewer", "task": "review all changes"}
  ],
  "topology": "star",
  "coordinator": "planner"
}
```

### HIVE Mode (Persistent Sessions)

For multi-phase projects requiring context persistence across sessions.

```
Sequential Thinking → Multi-day work → HIVE

Typical HIVE compositions:
- Major refactoring: architect-review, refactoring-specialist, coder, tester
- System migration: planner, microservices-architect, data-engineer, sre-engineer
```

**Example: System Migration**

```json
{
  "swarm": "HIVE",
  "queen": "planner",
  "workers": [
    {"type": "researcher", "task": "analyze current system"},
    {"type": "microservices-architect", "task": "design target architecture"},
    {"type": "data-engineer", "task": "plan data migration"},
    {"type": "coder", "task": "implement migration scripts"},
    {"type": "tester", "task": "validate migration"}
  ],
  "topology": "hierarchical",
  "persistence": true
}
```

### BRAIN Mode (Learning Agents)

For complex analysis requiring cognitive patterns and learning.

```
Sequential Thinking → Deep analysis needed → BRAIN

Typical BRAIN uses:
- Architecture analysis: divergent + systems cognitive patterns
- Security audit: critical + convergent patterns
- Performance optimization: convergent + adaptive patterns
```

---

## Agent Selection Matrix

### By Task Type

| Task Type | Primary Agent | Supporting Agents |
|-----------|---------------|-------------------|
| Bug fix | `debugger` | `coder`, `tester` |
| New feature | `coder` | `tester`, `code-reviewer` |
| Refactoring | `refactoring-specialist` | `coder`, `tester` |
| Performance | `performance-engineer` | `database-optimizer` |
| Security fix | `security-auditor` | `coder`, `tester` |
| API design | `backend-architect` | `api-documenter` |
| UI work | `frontend-developer` | `ui-ux-designer` |
| Data work | `data-engineer` | `database-optimizer` |
| Infrastructure | `cloud-architect` | `terraform-specialist` |

### By Complexity

| Complexity | Approach | Agents |
|------------|----------|--------|
| Simple | SOLO | Single best-fit agent |
| Medium | SCOUT | 2-3 agents in sequence |
| Complex | SQUAD | 5-8 coordinated agents |
| Long-running | HIVE | Hierarchical with persistence |
| Deep analysis | BRAIN | Learning agents with patterns |

### By Risk Level

| Risk | Primary Agent | Required Validation |
|------|---------------|-------------------|
| Low | Any appropriate | Self-review |
| Medium | + `code-reviewer` | Peer review |
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
- What package (SOLO, SCOUT, SQUAD, BRAIN, HIVE)

### 2. Match Agent to Task

- Don't use `opus` agents for simple tasks (cost inefficient)
- Don't use `sonnet` for critical security or architecture decisions
- Use specialist agents for domain-specific work

### 3. Coordinate Properly

- In SQUAD: Designate a coordinator agent
- In HIVE: Use hierarchical topology with clear queen
- Always have a reviewer in significant changes

### 4. Validate Results

- Use `code-reviewer` after significant code changes
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
Bug Fix:        debugger → coder → tester → code-reviewer
New Feature:    planner → coder → tester → code-reviewer
Refactoring:    refactoring-specialist → coder → tester
API Work:       backend-architect → coder → api-documenter → tester
Frontend:       ui-ux-designer → frontend-developer → tester
Infrastructure: cloud-architect → terraform-specialist → sre-engineer
Security:       security-auditor → coder → tester
Performance:    performance-engineer → database-optimizer → tester
```

### Emergency Agents

| Situation | Agent |
|-----------|-------|
| Production bug | `debugger` → `coder` (minimal fix) |
| Security incident | `security-auditor` (assess) → `coder` (fix) |
| Performance crisis | `performance-engineer` → `database-optimizer` |
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
| `model` | Yes | Recommended Claude model | opus, sonnet, haiku |
| `type` | No | Agent category | analyst, architect, coder, validator, coordinator |
| `color` | No | UI/visualization color | Hex code or color name |
| `capabilities` | No | List of specific skills | Array of strings |
| `priority` | No | Selection priority | low, medium, high, critical |
| `tools` | No | Allowed tools | Array of tool names |
| `sparc_phase` | No | SPARC methodology phase | specification, pseudocode, architecture, refinement, completion |
| `hooks` | No | Execution scripts | `pre` and `post` shell scripts |

---

## Creating Custom Agents

### 1. Choose Agent Category

Determine which directory your agent belongs to:
- General development → `core/`
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
  5. code-reviewer → final review
```

### 2. Parallel Agent Swarm (SQUAD)
```
Task: Full-stack feature

Swarm (parallel):
  - frontend-developer → UI components
  - backend-architect → API design
  - database-optimizer → schema design
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

### 4. Learning Agent System (BRAIN/WATCHER)
```
Task: Codebase pattern learning

BRAIN: Single-session learning
  - daa_agent with cognitivePattern: "divergent"
  - neural_train for pattern recognition
  - Extract learnings at end

WATCHER: Multi-session learning + persistence
  - BRAIN for learning
  - HIVE for persistence
  - Patterns saved across sessions
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
