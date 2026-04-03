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

### Next Step

[Pick ONE based on task complexity. Evaluate each case — not every task needs a command.]

**Simple task** (single file, quick fix):
> Say **"go"** to execute directly.

**Multi-file task** (needs research + parallel agents):
> Say **"go"** or run `/orchestrate` to use parallel agents.

**Jira-tracked task** (needs cards + execution):
> 1. Run `/plan-work` to create Jira cards from the rewrite above
> 2. After cards are approved, run `/orchestrate --jira [KEY]`

**Research or spec work:**
> Run `/speckit.specify` to start the spec pipeline.

---

## Rules

- Show ONLY ONE next step — the one that fits the task
- Do NOT show "What Changed" — the score delta in the headers is enough
- Do NOT ask the user to copy-paste the rewrite — Claude already has the full context
- Slash commands go on their own line, never embedded mid-sentence
- If the task is a question or investigation, skip the Next Step
- Evaluate case by case — not every task needs `/orchestrate` or `/plan-work`

**Reference templates at:** `.uatu/config/prompt-templates.md`
