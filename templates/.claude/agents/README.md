# Claude Code Agents Directory

Specialized agent definitions for the Uatu framework. Agents provide domain-specific expertise and can be spawned individually or coordinated in swarms.

---

## Quick Reference

**Total Agents**: 53 specialized agents across 10 categories

| Category | Count | Purpose |
|----------|-------|---------|
| core | 12 | General development (coder, tester, reviewer, planner, etc.) |
| languages | 7 | Language specialists (typescript, python, golang, rust, java, etc.) |
| infrastructure | 6 | Cloud & DevOps (cloud-architect, kubernetes, terraform, etc.) |
| specialized | 5 | Domain-specific (jira-specialist, api-documenter, etc.) |
| quality | 5 | Testing & QA (debugger, security-auditor, etc.) |
| github | 5 | GitHub integration (pr-manager, issue-tracker, etc.) |
| firebase | 4 | Firebase platform (auth, firestore, functions, hosting) |
| data | 4 | Data & databases (database-expert, ml-engineer, etc.) |
| build-resolvers | 3 | Build error specialists (typescript, python, golang) |
| testing | 2 | Testing swarms (tdd-london-swarm, production-validator) |

---

## Directory Structure

```
.claude/agents/
├── README.md
│
├── core/                     # General development (12)
│   ├── architect-review.md
│   ├── backend-architect.md
│   ├── coder.md
│   ├── frontend-developer.md
│   ├── fullstack-developer.md
│   ├── microservices-architect.md
│   ├── orchestrator-task.md
│   ├── planner.md
│   ├── researcher.md
│   ├── reviewer.md
│   ├── tester.md
│   └── ui-ux-designer.md
│
├── languages/                # Language specialists (7)
│   ├── flutter-pro.md
│   ├── golang-pro.md
│   ├── java-pro.md
│   ├── javascript-pro.md
│   ├── python-pro.md
│   ├── rust-pro.md
│   └── typescript-pro.md
│
├── infrastructure/           # Cloud & DevOps (6)
│   ├── cloud-architect.md
│   ├── deployment-engineer.md
│   ├── kubernetes-architect.md
│   ├── monitoring-specialist.md
│   ├── sre-engineer.md
│   └── terraform-specialist.md
│
├── specialized/              # Domain-specific (5)
│   ├── api-documenter.md
│   ├── docs-architect.md
│   ├── jira-specialist.md
│   ├── prompt-engineer.md
│   └── refactoring-specialist.md
│
├── quality/                  # Testing & QA (5)
│   ├── chaos-engineer.md
│   ├── debugger.md
│   ├── performance-engineer.md
│   ├── security-auditor.md
│   └── test-automator.md
│
├── github/                   # GitHub integration (5)
│   ├── issue-tracker.md
│   ├── pr-manager.md
│   ├── release-manager.md
│   ├── repo-architect.md
│   └── workflow-automation.md
│
├── firebase/                 # Firebase platform (4)
│   ├── firebase-auth-specialist.md
│   ├── firebase-firestore-specialist.md
│   ├── firebase-functions-specialist.md
│   └── firebase-hosting-specialist.md
│
├── data/                     # Data & AI (4)
│   ├── data-engineer.md
│   ├── database-expert.md
│   ├── llm-architect.md
│   └── ml-engineer.md
│
├── build-resolvers/          # Build error specialists (3)
│   ├── golang-build-resolver.md
│   ├── python-build-resolver.md
│   └── typescript-build-resolver.md
│
└── testing/                  # Testing swarms (2)
    ├── production-validator.md
    └── tdd-london-swarm.md
```

---

## Agent Selection

### By Task Type

| Task | Primary Agent | Supporting |
|------|---------------|------------|
| Code implementation | `coder` | `reviewer`, `tester` |
| Bug investigation | `debugger` | `coder` |
| Architecture design | `architect-review` | `backend-architect` |
| API development | `backend-architect` | `api-documenter` |
| UI development | `frontend-developer` | `ui-ux-designer` |
| Database work | `database-optimizer` | `sql-pro` |
| Cloud infrastructure | `cloud-architect` | `terraform-specialist` |
| Security audit | `security-auditor` | `code-reviewer` |
| Performance tuning | `performance-engineer` | `database-optimizer` |
| Testing | `test-automator` | `chaos-engineer` |

### By Package

| Package | Approach |
|---------|----------|
| SOLO | Spawn one agent (or 2-3 in sequence for exploration) |
| SQUAD | Spawn agents coordinated via Agent Teams + Claude Flow MCP |
| HIVE | SQUAD with hierarchical topology + memory_persist |
| WATCHER | HIVE + ruv-swarm DAA learning agents (Ruflo CLI) |

---

## Usage Examples

### Single Agent (SOLO)
```
Task tool with subagent_type: "coder"
prompt: "Implement user authentication"
```

### Sequential Agents (SOLO — exploration mode)
```
1. Task with subagent_type: "researcher"
2. Task with subagent_type: "coder"
3. Task with subagent_type: "reviewer"
```

### SPARC Workflow
```
1. Task with subagent_type: "specification"
2. Task with subagent_type: "pseudocode"
3. Task with subagent_type: "architecture"
4. Task with subagent_type: "refinement"
```

---

## Creating Custom Agents

1. Choose category directory
2. Create markdown file with YAML frontmatter:

```markdown
---
name: my-agent
description: What this agent does
tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
---

# Agent Instructions

You are a specialist in...
```

3. Test: `Task tool with subagent_type: "my-agent"`

---

## Best Practices

- **Single Responsibility** - One domain per agent
- **Match Model to Task** - Use haiku for simple, sonnet for complex
- **Always Review** - Use `reviewer` after significant code changes
- **Spawn Proactively** - Use agents before being asked when task matches

---

*Uatu Agent System - 62 specialized agents ready for deployment*
