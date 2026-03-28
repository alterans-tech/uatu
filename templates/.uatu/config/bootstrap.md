# Uatu Framework — Active Rules

These rules are auto-injected every session. Full docs: `.uatu/UATU.md`

---

## Before Any Task

1. Select **package** based on coordination needs (see below)
2. For complex/multi-file tasks, use `/orchestrate` to spawn agents
3. For complex or ambiguous tasks, consider **Sequential Thinking** (`mcp__sequential-thinking__sequentialthinking`)

---

## Package Selection

| Package | When | Command |
|---------|------|---------|
| **SOLO** | Independent parallel work (90% of tasks) | `/orchestrate swarm` or `/orchestrate feature` |
| **SQUAD** | Agents must coordinate mid-task | `/squad` |
| HIVE | SQUAD + cross-session persistence (experimental) | Manual setup |

```
Can you give each agent everything it needs before it starts?
  YES → SOLO (use /orchestrate)
  NO  → SQUAD → need persistence across sessions? → HIVE
```

---

## Key Commands

| Task | Command |
|------|---------|
| Multi-agent orchestration | `/orchestrate swarm <description>` |
| Feature workflow (plan→code→test→review) | `/orchestrate feature <description>` |
| Bug fix workflow | `/orchestrate bugfix <description>` |
| Agent team with peer messaging | `/squad <description>` |
| Spec-driven implementation | `/speckit.implement` (auto-spawns agents for 3+ tasks) |
| Test-driven development | `/tdd <description>` |
| End-to-end tests | `/e2e <description>` |
| Code review | `/code-review` |

---

## Agent Usage

You have 65+ specialized agents available. Commands spawn them automatically.
For manual spawning: `Agent(subagent_type="<type>", prompt="...", isolation="worktree", run_in_background=true)`

Common agents: `coder`, `tester`, `reviewer`, `planner`, `researcher`, `debugger`, `architect-review`, `security-auditor`

Full catalog: `.uatu/guides/AGENTS-GUIDE.md`

---

## Artifacts

All deliverables go in `.uatu/delivery/`. Use `/speckit.*` commands for specs.
