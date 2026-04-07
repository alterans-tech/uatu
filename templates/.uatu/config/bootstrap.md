# Uatu Framework — Active Rules

These rules are auto-injected every session. Full docs: `.uatu/UATU.md` | Quick ref: `.uatu/QUICKSTART.md`

---

## Before Any Task

1. Check `.claude/rules/uatu-core.md` — behavioral rules are auto-loaded
2. For complex/multi-file tasks, use `/orch` to spawn agents
3. For complex or ambiguous tasks, consider **Sequential Thinking**

---

## Package Selection

| Package | When | How |
|---------|------|-----|
| **SOLO** | Independent parallel work (90% of tasks) | `/orch` with wave execution |
| **SQUAD** | Agents need to coordinate mid-task | Auto-detected by `/orch` |
| HIVE | SQUAD + cross-session persistence (experimental) | Manual setup |
| WATCHER | HIVE + ruv-swarm DAA learning agents | Ruflo CLI |

```
Can you give each agent everything it needs before it starts?
  YES → SOLO (orchestrate handles parallelism)
  NO  → SQUAD (auto-escalates when agents need mid-task coordination)
        → Need persistence? → HIVE
```

---

## Commands

| Task | Command |
|------|---------|
| Session recon | `/status` |
| Multi-agent execution | `/orch "description"` |
| Create Jira cards | `/jira "description"` |
| Organize a prompt | `/frame "draft"` |
| Session effectiveness dashboard | `/prompt-analyzer --compare YYYY-MM-DD` |
| Time tracking | `/time-report --week` |
| Spec-driven workflow | `/speckit.specify`, `.plan`, `.tasks`, `.implement` |

**Orchestrate flags:** `--tdd`, `--e2e`, `--review`, `--dry-run`, `--verify`, `--scope`, `--no-commit`, `--jira`

---

## Agent Usage

53 specialized agents available. Commands spawn them automatically.

Key agents: `coder`, `tester`, `reviewer`, `planner`, `researcher`, `debugger`, `architect-review`, `security-auditor`, `database-expert`

Full catalog: `.uatu/guides/AGENTS-GUIDE.md`

---

## Artifacts

All deliverables go in `.uatu/delivery/`. Use `/speckit.*` commands for specs.
