---
description: Rewrite a draft prompt with proper structure, file references, constraints, and success criteria.
---

# Prompt Rewrite

## Arguments

$ARGUMENTS

## Execution

**FIRST**, use Sequential Thinking (`mcp__sequential-thinking__sequentialthinking`) to analyze the prompt:

- Thought 1: What is the user actually trying to accomplish?
- Thought 2: Score each of the 5 dimensions (1-10) for the original prompt
- Thought 3: What files, context, and constraints are implied but missing?
- Thought 4: What's the best structure for this type of request?
- Thought 5: Write the rewritten prompt with all dimensions addressed
- Thought 6: Which execution path is best? Consider: task complexity, number of files, risk level, Jira tracking, research needs

**THEN** output the rewrite following this EXACT format.

**Input prompt:** $ARGUMENTS

**Rewrite rules (5 research-backed dimensions):**

1. **Intent** (weight: 20%): Clear action verb + identifiable target.
2. **Context** (weight: 25%): File references in backticks, function names, error messages.
3. **Specificity** (weight: 20%): Concrete behavior, assertive language (must/never/exactly).
4. **Scope** (weight: 15%): Decomposition for multi-concern. "Do NOT" / "ONLY" boundaries.
5. **Verifiability** (weight: 20%): "Done when:" with testable conditions.

**Scoring anchors:**
- **2/10**: "fix it" — no verb target, no context, no criteria
- **5/10**: "fix the login bug in auth.ts" — clear intent + file ref, but no verification
- **8/10**: "fix JWT expiry in `auth.ts` — tokens with past `exp` are accepted. Add regression test. Run `npm test`." — all 5 dimensions covered

## Output Format

Present EXACTLY this structure:

---

### Original (Score: X/10)

[user's original prompt]

### Rewritten (Score: Y/10)

[full structured rewrite with all 5 dimensions addressed — headers, bullets, file refs, constraints, done-when]

### Recommended: `[keyword]`

[One sentence explaining WHY this path fits this specific task.]

| Option | What happens |
|--------|-------------|
| `go` | Execute directly in this session |
| `plan` | Enter plan mode — see execution plan before any changes |
| `orch` | Run `/orchestrate` with parallel agents |
| `plan-work` | Create Jira cards, then execute |
| `plan-work` → `orch` | Create Jira cards, then `/orchestrate --jira [KEY]` with parallel agents |
| `spec` | Start `/speckit.specify` pipeline for requirements |
| `spec` → `orch` | Spec pipeline, then orchestrate the implementation |

Bold the recommended row with ← recommended marker.

---

## Recommendation Logic (Thought 6)

Evaluate the task and pick ONE recommendation. Combinations are valid when a task benefits from multiple stages.

| Condition | Recommend | Why |
|-----------|-----------|-----|
| 1 file, clear fix, low risk | `go` | No overhead needed |
| 2-3 files, or risky changes (auth, payments, migrations, deploy) | `plan` | Validate approach before touching files |
| 4+ files, needs research, complex | `orch` | Parallel agents + research phase |
| Should be in Jira, part of sprint | `plan-work` | Creates cards for tracking |
| Jira-tracked AND complex (4+ files) | `plan-work` → `orch` | Cards first, then parallel execution |
| New feature, unclear requirements | `spec` | Needs spec before implementation |
| New feature AND complex implementation | `spec` → `orch` | Spec first, then parallel execution |
| Refactoring across many files | `orch` | Wave execution prevents conflicts |
| Investigation or research only | `go` | No files to change |
| Question or explanation | Skip Recommended section | Nothing to execute |

## Rules

- Always show the FULL options table — user can pick any option
- Bold the recommended row with ← recommended
- Include ONE sentence explaining why BEFORE the table
- Combinations (→) are first-class options, not afterthoughts
- Do NOT show "What Changed" — the score delta in the headers is enough
- Do NOT ask the user to copy-paste — Claude already has context
- If the task is a question, skip the Recommended section entirely

**Reference templates at:** `.uatu/config/prompt-templates.md`
