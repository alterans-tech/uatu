# Uatu - The Watcher

AI orchestration framework for Claude Code.

---

## Before Any Task

1. **Read project config** — `.uatu/config/project.md`
2. **Check `.claude/rules/uatu-core.md`** — behavioral rules are auto-loaded
3. **Consider Sequential Thinking** — For complex or ambiguous tasks

---

## Config Files

| File | Purpose | When to Read |
|------|---------|--------------|
| `.uatu/config/project.md` | Project settings, conventions | Every session |
| `.uatu/config/architecture.md` | Tech stack (auto-generated) | When exploring codebase |
| `.uatu/config/constitution.md` | AI behavior principles | When unsure about approach |
| `.uatu/config/prompt-templates.md` | Copy-paste prompt starters | When crafting prompts |
| `.claude/rules/uatu-core.md` | Framework behavior rules | Auto-loaded every session |

---

## Commands (8 + Speckit)

| Command | Purpose | Example |
|---------|---------|---------|
| `/status` | Sprint board + branches + worktrees + checkpoint | `/status` |
| `/orchestrate` | Smart multi-agent execution | `/orchestrate "add notifications" --tdd` |
| `/pre-flight-check` | Pre-merge gate: review + verify + security | `/pre-flight-check` |
| `/review-pr` | Review someone else's PR | `/review-pr 234` |
| `/self-review` | Handle review comments on your PR | `/self-review 234` |
| `/plan-work` | Create Jira cards (Epic/Story/Subtask) | `/plan-work "password reset"` |
| `/prompt-rewrite` | Rewrite + Quick Version for /orchestrate | `/prompt-rewrite "fix the thing"` |
| `/prompt-analyzer` | Session effectiveness + prompt dashboard | `/prompt-analyzer --compare 2026-03-31` |
| `/time-report` | Time tracking across projects | `/time-report --week` |

**Orchestrate flags:** `--tdd` (test-first), `--e2e` (Playwright), `--review` (two-stage review)

### Speckit Commands

| When | Command |
|------|---------|
| New feature request | `/speckit.specify` |
| Spec is unclear | `/speckit.clarify` |
| Ready to plan | `/speckit.plan` |
| Need task breakdown | `/speckit.tasks` |
| Ready to implement | `/speckit.implement` |
| Check consistency | `/speckit.analyze` |
| Validation checklist | `/speckit.checklist` |
| Project principles | `/speckit.constitution` |
| Push to Jira/GitHub | `/speckit.taskstoissues` |
| Mark complete | `/speckit.complete` |

---

## Package Selection

| Package | When | How |
|---------|------|-----|
| **SOLO** | Independent parallel work (90% of tasks) | `/orchestrate` with wave execution |
| **SQUAD** | Agents need to coordinate mid-task | Auto-detected by `/orchestrate` |
| **HIVE** | Work spans multiple sessions (experimental) | Manual setup with persistence |

```
Can you give each agent everything it needs before it starts?
  YES → SOLO (orchestrate handles parallelism)
  NO  → SQUAD (auto-escalates when agents need mid-task coordination)
        → Need persistence? → HIVE
```

---

## Automatic Behaviors

These happen without commands — driven by hooks and rules:

| Behavior | When |
|----------|------|
| 4-phase debugging | You describe a bug or error |
| Two-stage code review | You ask to review code |
| Security scan suggestion | You modify auth/payment files |
| Build auto-diagnosis | Build command fails |
| Prompt quality coaching | Every prompt > 5 words |
| Branch guard | Session starts on main |
| Missing test warning | Session ends |
| Session checkpoint | Session ends (JSONL) |

---

## Guides

| Guide | When to Read |
|-------|-------------|
| `.uatu/guides/SEQUENTIAL-THINKING.md` | Complex or ambiguous task |
| `.uatu/guides/TOOL-SELECTION.md` | Unsure which approach |
| `.uatu/guides/SQUAD-GUIDE.md` | Using SQUAD/HIVE |
| `.uatu/guides/AGENTS-GUIDE.md` | Selecting agents |
| `.uatu/guides/WORKFLOW.md` | Jira, naming, specs |
| `.uatu/guides/HOOKS.md` | Customizing hooks |

---

## Quick Reference

Full user manual: `.uatu/QUICKSTART.md`

---

## MCP Servers

| Server | Required For |
|--------|--------------|
| `sequential-thinking` | `/prompt-rewrite`, `/plan-work`, complex tasks |
| `claude-flow` | SQUAD/HIVE coordination |

Run `uatu-setup` to install.
