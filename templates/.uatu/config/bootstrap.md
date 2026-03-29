# Uatu Framework — Active Rules

These rules are auto-injected every session. Full docs: `.uatu/UATU.md` | Quick ref: `.uatu/QUICKSTART.md`

---

## Before Any Task

1. Check `.claude/rules/uatu-core.md` — behavioral rules are auto-loaded
2. For complex/multi-file tasks, use `/orchestrate` to spawn agents
3. For complex or ambiguous tasks, consider **Sequential Thinking**

---

## Package Selection

| Package | When | How |
|---------|------|-----|
| **SOLO** | Independent parallel work (90% of tasks) | `/orchestrate` with wave execution |
| **SQUAD** | Agents need to coordinate mid-task | Auto-detected by `/orchestrate` |
| HIVE | SQUAD + cross-session persistence (experimental) | Manual setup |

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
| Multi-agent execution | `/orchestrate "description"` |
| Pre-merge gate | `/pre-flight-check` |
| Open / review / respond to PRs | `/pr`, `/pr --review N`, `/pr --respond N` |
| Create Jira cards | `/plan-work "description"` |
| Improve a prompt | `/prompt-rewrite "draft"` |
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
