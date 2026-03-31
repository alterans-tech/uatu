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
- Thought 4: What's the best structure for this type of request? (match to a template from `.uatu/config/prompt-templates.md`)
- Thought 5: Write the rewritten prompt with all dimensions addressed

**THEN** rewrite the prompt following the 5-dimension framework.

**Input prompt:** $ARGUMENTS

**Rewrite rules (5 research-backed dimensions):**

1. **Intent** (weight: 20%): Ensure a clear action verb and identifiable target. Replace "the thing" with the specific component/module/file.

2. **Context** (weight: 25%): Add file references, function names in backticks, error messages, or code blocks. If files aren't mentioned, identify the likely files and include them.

3. **Specificity** (weight: 20%): Replace vague words ("fix the thing", "make it better") with concrete behavior descriptions. Use assertive language (must/never/exactly). Include expected values or examples.

4. **Scope** (weight: 15%): For multi-concern prompts, decompose with bullets/numbers/headers. Add "Do NOT" and "ONLY" boundaries. For single-concern prompts, scope is implicit.

5. **Verifiability** (weight: 20%): Add a "Done when:" section with testable conditions. Include verification commands (`npm test`, `pytest`). Describe expected output or behavior.

**Scoring anchors:**
- **2/10**: "fix it" — no verb target, no context, no criteria
- **5/10**: "fix the login bug in auth.ts" — clear intent + file ref, but no verification
- **8/10**: "fix JWT expiry in `auth.ts` — tokens with past `exp` are accepted. Add regression test. Run `npm test`." — all 5 dimensions covered

**Output format:**

```
## Original (Score: X/10)
[user's original prompt]

## Rewritten (Score: Y/10)
[structured rewrite with all 5 dimensions addressed]

## What Changed
- Added: [list what was added per dimension]
- Score improvement: X → Y (+Z points)
- Suggested execution: [/orchestrate, /speckit.specify, or direct execution]
```

**Reference templates at:** `.uatu/config/prompt-templates.md`
