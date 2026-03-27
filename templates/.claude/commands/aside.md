---
description: Answer a side question without losing the current task context. Resumes the original task automatically after answering.
---

# Aside

## Arguments

$ARGUMENTS

## Execution

The user has a side question while working on a task. Answer it without disrupting the current work.

### Format

```
ASIDE: $ARGUMENTS

[Your concise answer here — keep it brief, 2-5 sentences max]

--- Back to task ---
```

### Rules

1. Answer the side question concisely (2-5 sentences)
2. Do NOT explore the codebase extensively for the aside — use existing context
3. Do NOT modify any files for the aside
4. After answering, resume the previous task exactly where you left off
5. If the aside requires significant work, say so and suggest running it as a separate task instead
