---
description: Organize and sharpen a draft prompt. Structures what you wrote, fills gaps from context, and recommends an execution path.
---

# Shape

## Arguments

$ARGUMENTS

## Model

**Always use `sonnet`** for this command. Do NOT use opus or sequential thinking. This is a quick organization pass, not a research task.

## Execution

Take what the user wrote in `$ARGUMENTS` and:
1. **Score** the original on 5 dimensions (1–10)
2. **Organize** the intent — don't invent requirements, extrapolate only from what was written
3. **Fill gaps** that are implied by context (files likely involved, obvious constraints)
4. **Score** the rewrite
5. **Recommend** an execution path + relevant flags

Do NOT: search the codebase, spawn agents, call MCPs, or do research.
Do: structure what was written, add format, infer the obvious.

---

## Dimensions (guide for scoring + structuring)

1. **Intent** (20%) — Clear action verb + identifiable target
2. **Context** (25%) — File references in backticks, function names, error messages
3. **Specificity** (20%) — Concrete behavior, assertive language (must/never/exactly)
4. **Scope** (15%) — "Do NOT" / "ONLY" boundaries, decomposition for multi-concern
5. **Verifiability** (20%) — "Done when:" with testable conditions

**Scoring anchors:**
- **2/10**: "fix it" — no verb, no context, no criteria
- **5/10**: "fix the login bug in auth.ts" — clear intent + file, but no verification
- **8/10**: "fix JWT expiry in `auth.ts` — tokens with past `exp` accepted. Add regression test. Run `npm test`." — all 5 covered

---

## Output Format

---

### Original (Score: X/10)

[user's original prompt]

### Rewritten (Score: Y/10)

[structured rewrite — headers, bullets, file refs, constraints, done-when]

[If the task would use /orch, append relevant flags at the end:
`Suggested flags: --tdd --verify` or `--jira KEY-123 --dry-run` etc.]

### Recommended: `[keyword]`

[One sentence explaining WHY this path fits this specific task.]

| Option | What happens |
|--------|-------------|
| `go` | Execute directly in this session |
| `plan` | Enter plan mode — review approach before any tool runs |
| `orch` | Run `/orch` with parallel agents |
| `orch --dry-run` | Run `/orch`, see the plan first, then approve execution |
| `pw` | Create Jira cards with `/jira`, then execute |
| `pw` → `orch` | Cards first, then `/orch --jira [KEY]` |
| `spec` | Start `/speckit.specify` pipeline |
| `spec` → `orch` | Spec pipeline, then orchestrate |

Bold the recommended row with ← recommended.

---

## Recommendation Logic

| Condition | Recommend |
|-----------|-----------|
| 1 file, clear fix, low risk | `go` |
| Risky area (auth/payments/migration/deploy) | `plan` |
| 4+ files or needs parallel agents | `orch` |
| Multi-file but want to review plan first | `orch --dry-run` |
| Should be tracked in Jira | `pw` |
| Jira-tracked AND complex | `pw` → `orch` |
| New feature, unclear requirements | `spec` |
| New feature AND complex implementation | `spec` → `orch` |
| Read-only investigation | `go` |
| Question or explanation | *(skip Recommended section)* |

## Rules

- Show the FULL options table — user picks any option
- Bold the recommended row with ← recommended
- ONE sentence explaining why BEFORE the table
- If `orch` is recommended, append relevant flags to the rewrite
- Do NOT ask user to copy-paste — Claude already has context
- Do NOT do research — organize only
