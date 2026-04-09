# Uatu Agents

**25 agents** across 6 categories. Minimal set — only agents that add unique value beyond Claude Code's built-in types.

## Categories

| Category | Count | Purpose |
|----------|-------|---------|
| core | 12 | Workflow agents used by /orch — coder, tester, reviewer, planner, etc. |
| languages | 2 | Language-specific expertise (Go, Python) |
| infrastructure | 2 | Cloud + deployment |
| specialized | 5 | Custom agents with unique MCP/convention knowledge |
| quality | 2 | Security + debugging |
| data | 2 | Database + LLM architecture |

## Directory

```
agents/
├── core/                     # Workflow (12)
│   ├── architect-review.md       [opus]
│   ├── backend-architect.md      [sonnet]
│   ├── code-reviewer.md          [sonnet]
│   ├── coder.md                  [sonnet]
│   ├── frontend-developer.md     [sonnet]
│   ├── fullstack-developer.md    [sonnet]
│   ├── orchestrator-task.md      [sonnet]
│   ├── planner.md                [opus]
│   ├── researcher.md             [sonnet]
│   ├── reviewer.md               [sonnet]
│   ├── tester.md                 [sonnet]
│   └── ui-ux-designer.md         [sonnet]
│
├── languages/                # Language pros (2)
│   ├── golang-pro.md             [sonnet]
│   └── python-pro.md             [sonnet]
│
├── infrastructure/           # Ops (2)
│   ├── cloud-architect.md        [sonnet]
│   └── deployment-engineer.md    [sonnet]
│
├── specialized/              # Custom (5)
│   ├── agile-specialist.md       [sonnet]  ← /jira review
│   ├── docs-architect.md         [sonnet]
│   ├── jira-specialist.md        [sonnet]  ← /jira review
│   ├── mermaid-diagrammer.md     [sonnet]  ← Mermaid Chart MCP
│   └── prompt-engineer.md        [sonnet]
│
├── quality/                  # Quality (2)
│   ├── debugger.md               [sonnet]
│   └── security-auditor.md       [opus]
│
└── data/                     # Data (2)
    ├── database-expert.md        [sonnet]
    └── llm-architect.md          [sonnet]
```

## Model routing

Each agent carries its own model — commands do NOT override.

| Model | Role | Agents |
|-------|------|--------|
| **opus** (3) | Judgment | planner, architect-review, security-auditor |
| **sonnet** (22) | Execution | everything else |
