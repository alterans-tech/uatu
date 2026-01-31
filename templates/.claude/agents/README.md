# Claude Code Agents Directory

Specialized agent definitions for the Uatu framework. Agents provide domain-specific expertise and can be spawned individually or coordinated in swarms.

---

## Quick Reference

**Total Agents**: 62 specialized agents across 9 categories

| Category | Count | Purpose |
|----------|-------|---------|
| core | 11 | General development |
| firebase | 12 | Firebase platform |
| languages | 7 | Language specialists |
| data | 6 | Data & databases |
| infrastructure | 6 | Cloud & DevOps |
| specialized | 6 | Domain-specific |
| quality | 5 | Testing & QA |
| github | 5 | GitHub integration |
| sparc | 4 | SPARC methodology |

---

## Directory Structure

```
.claude/agents/
├── README.md
│
├── core/                     # General development (11)
│   ├── architect-review.md
│   ├── backend-architect.md
│   ├── coder.md
│   ├── debugger.md
│   ├── frontend-developer.md
│   ├── fullstack-developer.md
│   ├── microservices-architect.md
│   ├── planner.md
│   ├── refactoring-specialist.md
│   ├── researcher.md
│   └── reviewer.md
│
├── firebase/                 # Firebase platform (12)
│   ├── firebase-analytics-specialist.md
│   ├── firebase-appcheck-specialist.md
│   ├── firebase-auth-specialist.md
│   ├── firebase-crashlytics-specialist.md
│   ├── firebase-firestore-specialist.md
│   ├── firebase-functions-specialist.md
│   ├── firebase-hosting-specialist.md
│   ├── firebase-messaging-specialist.md
│   ├── firebase-performance-specialist.md
│   ├── firebase-remote-config-specialist.md
│   ├── firebase-storage-specialist.md
│   └── firebase-testlab-specialist.md
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
├── data/                     # Data & databases (6)
│   ├── data-engineer.md
│   ├── database-admin.md
│   ├── database-optimizer.md
│   ├── llm-architect.md
│   ├── ml-engineer.md
│   └── sql-pro.md
│
├── infrastructure/           # Cloud & DevOps (6)
│   ├── cloud-architect.md
│   ├── deployment-engineer.md
│   ├── kubernetes-architect.md
│   ├── monitoring-specialist.md
│   ├── sre-engineer.md
│   └── terraform-specialist.md
│
├── specialized/              # Domain-specific (6)
│   ├── agile-coach.md
│   ├── api-documenter.md
│   ├── docs-architect.md
│   ├── jira-specialist.md
│   ├── prompt-engineer.md
│   └── ui-ux-designer.md
│
├── quality/                  # Testing & QA (5)
│   ├── chaos-engineer.md
│   ├── code-reviewer.md
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
└── sparc/                    # SPARC methodology (4)
    ├── architecture.md
    ├── pseudocode.md
    ├── refinement.md
    └── specification.md
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
| SOLO | Spawn one agent directly |
| SCOUT | Spawn 2-3 agents sequentially |
| SQUAD | Spawn 5-8 agents coordinated via claude-flow |
| BRAIN | Spawn learning agents via ruv-swarm |
| HIVE | Hierarchical swarm with persistence |
| WATCHER | Combined BRAIN + HIVE |

---

## Usage Examples

### Single Agent (SOLO)
```
Task tool with subagent_type: "coder"
prompt: "Implement user authentication"
```

### Sequential Agents (SCOUT)
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
