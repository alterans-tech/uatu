---
description: Rewrite a draft prompt with proper structure, file references, constraints, and success criteria.
---

# Prompt Rewrite

## Arguments

$ARGUMENTS

## Execution

You are rewriting the user's draft prompt to follow the 7-dimension framework.

**Input prompt:** $ARGUMENTS

**Rewrite rules:**

1. **Structure** (weakest dimension at 2.79/10): Add bullets, numbers, or headers. If the prompt has multiple concerns, separate them.

2. **Context** (3.40/10): Add file references. If files aren't mentioned, identify the likely files and include them.

3. **Success Criteria** (3.38/10): Add a "Done when:" section with testable conditions.

4. **Specificity**: Replace vague words ("fix the thing", "update it") with concrete descriptions.

5. **Constraints**: Add "Do NOT" and "ONLY" boundaries where appropriate.

6. **Delegation**: If a Uatu command fits, suggest it (e.g., `/debug`, `/orchestrate`, `/tdd`).

7. **Verification**: Add a verification step ("Confirm X before proceeding" or "Show output before continuing").

**Output format:**

```
## Original (Score: X/10)
[user's original prompt]

## Rewritten (Score: Y/10)
[structured rewrite with all 7 dimensions addressed]

## What Changed
- Added: [list what was added]
- Score improvement: X → Y (+Z points)
```

**Reference templates at:** `.uatu/config/prompt-templates.md`
