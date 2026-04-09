---
description: Delegate a question to a sonnet agent. Saves opus tokens by offloading research and Q&A to a cheaper model. Use for "how does X work?", "what's the best approach for Y?", or any knowledge question.
---

# Ask

## Arguments

$ARGUMENTS

## Purpose

The main conversation runs on opus (1M context). Questions that require reading files, searching code, or explaining concepts don't need opus-level reasoning. This command spawns a sonnet researcher to do the heavy lifting and returns a concise answer.

## Execution

### Step 1 — Classify the question

Before spawning the agent, determine if the question needs conversation context:

- **Codebase question** ("how does X work?", "where is Y defined?", "what pattern does Z use?") → No context needed. Proceed to Step 2.
- **Context-dependent question** ("based on what we discussed...", "given the plan we made...", references to earlier decisions) → Extract a brief context summary (3-5 sentences max) of the relevant conversation context. Include it in the agent prompt as `CONTEXT:`.

### Step 2 — Spawn the agent

```
Agent(
  subagent_type="researcher",
  model="sonnet",
  prompt="Answer this question about the current project:

QUESTION: $ARGUMENTS

[If context-dependent, include:]
CONTEXT: <brief summary of relevant conversation context — decisions made, files discussed, constraints established>

Read whatever files you need. Search the codebase. Be thorough but concise.

Rules:
- Read the project's CLAUDE.md first for context
- Search relevant source files to ground your answer in actual code
- If the question is about architecture, read multiple related files
- Answer in under 500 words
- Include file:line references for any code you cite
- If you can't find the answer in the codebase, say so clearly"
)
```

### Step 3 — Relay

Relay the agent's answer to the user verbatim. Do NOT re-process, re-summarize, or add commentary. The agent's response IS the response.

## Context Briefing Cost

Even when context is needed, the savings are significant:
- **Without `/ask`**: Opus reads 5-10 files (20K+ tokens at opus pricing)
- **With `/ask`**: Opus writes a 100-token context brief, sonnet reads 5-10 files (20K tokens at sonnet pricing)
- **Net savings**: ~80% on the research tokens, at the cost of ~100 opus output tokens for the brief

## When to answer directly on opus instead

- The answer is already known from conversation context (no research needed)
- Follow-up clarifications on a previous answer
- Questions that are one sentence to answer

## Model

**Always use `sonnet`** for this command. The entire point is to avoid opus token consumption on research and Q&A.
