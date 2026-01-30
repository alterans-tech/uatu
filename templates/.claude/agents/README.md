# Claude Code Agents Directory

This directory contains specialized agent definitions for the Uatu framework. Agents provide domain-specific expertise and can be spawned individually or coordinated in swarms.

---

## Quick Reference

**Total Agents**: 114 specialized agents across 22 categories

**Primary Categories**:
- Core development (11 agents)
- GitHub integration (13 agents)
- Firebase operations (12 agents)
- Language specialists (7 agents)
- Quality assurance (7 agents)
- Data engineering (7 agents)
- Infrastructure (6 agents)
- SPARC methodology (4 agents)

---

## Directory Structure

```
.claude/agents/
├── README.md                    # This file
├── MIGRATION_SUMMARY.md         # Migration history
│
├── core/                        # General development agents (11)
│   ├── coder.md
│   ├── tester.md
│   ├── reviewer.md
│   ├── debugger.md
│   ├── architect-review.md
│   ├── backend-architect.md
│   ├── frontend-developer.md
│   ├── fullstack-developer.md
│   ├── microservices-architect.md
│   ├── refactoring-specialist.md
│   └── researcher.md
│
├── sparc/                       # SPARC methodology (4)
│   ├── specification.md         # Requirements analysis
│   ├── pseudocode.md           # Algorithm design
│   ├── architecture.md         # System design
│   └── refinement.md           # Optimization
│
├── github/                      # GitHub integration (13)
│   ├── pr-manager.md
│   ├── issue-tracker.md
│   ├── release-manager.md
│   ├── repo-architect.md
│   ├── workflow-automation.md
│   ├── swarm-pr.md
│   ├── swarm-issue.md
│   ├── code-review-swarm.md
│   ├── release-swarm.md
│   ├── multi-repo-swarm.md
│   ├── project-board-sync.md
│   ├── sync-coordinator.md
│   └── github-modes.md
│
├── firebase/                    # Firebase operations (12)
│   ├── auth-specialist.md
│   ├── firestore-specialist.md
│   ├── functions-specialist.md
│   ├── hosting-specialist.md
│   ├── storage-specialist.md
│   ├── analytics-specialist.md
│   ├── crashlytics-specialist.md
│   ├── messaging-specialist.md
│   ├── performance-specialist.md
│   ├── remote-config-specialist.md
│   ├── security-rules-specialist.md
│   └── emulator-specialist.md
│
├── languages/                   # Language specialists (7)
│   ├── typescript-pro.md
│   ├── python-pro.md
│   ├── golang-pro.md
│   ├── rust-pro.md
│   ├── java-pro.md
│   ├── javascript-pro.md
│   └── flutter-pro.md
│
├── quality/                     # Testing & QA (7)
│   ├── code-reviewer.md
│   ├── security-auditor.md
│   ├── performance-engineer.md
│   ├── test-automator.md
│   ├── chaos-engineer.md
│   ├── accessibility-auditor.md
│   └── compliance-auditor.md
│
├── data/                        # Data engineering (7)
│   ├── database-optimizer.md
│   ├── database-admin.md
│   ├── sql-pro.md
│   ├── data-engineer.md
│   ├── ml-engineer.md
│   ├── llm-architect.md
│   └── etl-specialist.md
│
├── infrastructure/              # Cloud & DevOps (6)
│   ├── cloud-architect.md
│   ├── kubernetes-architect.md
│   ├── terraform-specialist.md
│   ├── deployment-engineer.md
│   ├── sre-engineer.md
│   └── monitoring-specialist.md
│
├── orchestration/               # Coordination (3)
│   ├── planner.md
│   ├── multi-agent-coordinator.md
│   └── swarm-coordinator.md
│
├── swarm/                       # Swarm topologies (3)
│   ├── hierarchical-coordinator.md
│   ├── mesh-coordinator.md
│   └── adaptive-coordinator.md
│
├── consensus/                   # Distributed consensus (7)
│   ├── raft-manager.md
│   ├── gossip-coordinator.md
│   ├── quorum-manager.md
│   ├── crdt-synchronizer.md
│   ├── byzantine-coordinator.md
│   ├── performance-benchmarker.md
│   └── security-manager.md
│
├── specialized/                 # Domain-specific (6)
│   ├── prompt-engineer.md
│   ├── api-documenter.md
│   ├── docs-architect.md
│   ├── blockchain-specialist.md
│   ├── mobile-architect.md
│   └── embedded-specialist.md
│
├── optimization/                # Performance (5)
│   ├── algorithm-optimizer.md
│   ├── cache-optimizer.md
│   ├── query-optimizer.md
│   ├── bundle-optimizer.md
│   └── memory-optimizer.md
│
├── templates/                   # Template generators (10)
│   ├── base-template-generator.md
│   ├── coordinator-swarm-init.md
│   ├── github-pr-manager.md
│   ├── implementer-sparc-coder.md
│   ├── memory-coordinator.md
│   ├── migration-plan.md
│   ├── orchestrator-task.md
│   ├── performance-analyzer.md
│   ├── sparc-coordinator.md
│   └── automation-smart-agent.md
│
├── analysis/                    # Code analysis (2)
│   ├── static-analyzer.md
│   └── dependency-analyzer.md
│
├── architecture/                # System architecture (1)
│   └── system-architect.md
│
├── development/                 # Development tools (1)
│   └── ide-integrator.md
│
├── devops/                      # CI/CD (1)
│   └── ci-cd/
│       └── ops-cicd-github.md
│
├── documentation/               # Documentation (1)
│   └── api-docs/
│       └── docs-api-openapi.md
│
└── testing/                     # Testing frameworks (2)
    ├── e2e-tester.md
    └── integration-tester.md
```

---

## Agent File Format

Each agent is a Markdown file with YAML frontmatter:

```markdown
---
name: agent-name
type: analyst|architect|coder|validator|coordinator
description: Agent purpose and capabilities
model: opus|sonnet|haiku
capabilities:
  - capability_1
  - capability_2
priority: low|medium|high|critical
tools:
  - Read
  - Write
  - Bash
hooks:
  pre: |
    # Pre-execution script
  post: |
    # Post-execution script
---

# Agent Instructions

Your detailed agent instructions here...
```

---

## Agent Selection

### By Task Type

| Task | Primary Agent | Supporting |
|------|---------------|------------|
| Code implementation | `coder` | `code-reviewer`, `tester` |
| Bug investigation | `debugger` | `coder`, `tester` |
| Architecture design | `architect-review` | `system-architect` |
| API development | `backend-architect` | `api-documenter` |
| UI development | `frontend-developer` | `ui-ux-designer` |
| Database work | `database-optimizer` | `sql-pro` |
| Cloud infrastructure | `cloud-architect` | `terraform-specialist` |
| Security audit | `security-auditor` | `compliance-auditor` |
| Performance tuning | `performance-engineer` | `algorithm-optimizer` |
| Testing | `tester` | `test-automator` |

### By Complexity

| Complexity | Approach | Package |
|------------|----------|---------|
| Simple, single file | Spawn one agent | SOLO |
| Investigation needed | Spawn 2-3 agents | SCOUT |
| Coordinated work | Spawn 5-8 agents | SQUAD |
| Multi-session | Hierarchical swarm | HIVE |
| Pattern learning | Learning agents | BRAIN |
| Learn + persist | Combined system | WATCHER |

---

## Usage Examples

### 1. Single Agent (SOLO)
```bash
# Spawn a single specialist
Task tool with subagent_type: "coder"
prompt: "Implement user authentication"
```

### 2. Sequential Agents (SCOUT)
```bash
# Investigation → Implementation
1. Task with subagent_type: "researcher"
2. Task with subagent_type: "coder"
3. Task with subagent_type: "tester"
```

### 3. Parallel Swarm (SQUAD)
```javascript
// Multi-agent coordination
mcp__claude-flow__swarm_init({ topology: "star" })
mcp__claude-flow__agent_spawn({ type: "frontend-developer" })
mcp__claude-flow__agent_spawn({ type: "backend-architect" })
mcp__claude-flow__agent_spawn({ type: "database-optimizer" })
mcp__claude-flow__task_orchestrate({ strategy: "parallel" })
```

### 4. SPARC Workflow
```bash
# Specification → Pseudocode → Architecture → Refinement
1. Task with subagent_type: "specification"
2. Task with subagent_type: "pseudocode"
3. Task with subagent_type: "architecture"
4. Task with subagent_type: "refinement"
```

---

## Creating Custom Agents

### 1. Choose Category
Determine which directory fits your agent's domain.

### 2. Create File
```bash
cd ~/.claude/agents/{category}/
touch my-agent.md
```

### 3. Define Agent
```markdown
---
name: my-agent
type: specialist
description: Custom agent for specific domain
model: sonnet
capabilities:
  - domain_expertise
  - specialized_analysis
priority: medium
---

# My Custom Agent

You are a specialist in [domain]...
```

### 4. Test
```bash
Task tool with subagent_type: "my-agent"
```

---

## Best Practices

### 1. Agent Design
- **Single Responsibility** - One domain per agent
- **Clear Capabilities** - Specific, measurable skills
- **Appropriate Model** - Match complexity to cost

### 2. Agent Spawning
- **Direct Match** - Spawn immediately for clear tasks
- **Sequential Thinking** - Use for ambiguous or complex decisions
- **Always Review** - Use `code-reviewer` after significant code changes

### 3. Swarm Coordination
- **Star Topology** - One coordinator, multiple workers (SQUAD)
- **Hierarchical** - Queen-led, persistent (HIVE)
- **Mesh** - Peer-to-peer collaboration (BRAIN)

### 4. Tool Restrictions
- Development agents: Full file system access
- Testing agents: Test runners, limited write
- Architecture agents: Read-only, analysis tools
- Documentation agents: Markdown tools, docs/ write access

---

## Further Reading

- **AGENTS-GUIDE.md** - Comprehensive agent selection guide
- **SPARC methodology** - Specification-driven development
- **CLAUDE-FLOW-SELECTION.md** - Package and swarm patterns
- **SEQUENTIAL-THINKING.md** - Task analysis framework

---

*Uatu Agent System - 114 specialized agents ready for deployment*