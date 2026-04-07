# Module 07: Your Best Prompt Scored 8.75 — Do That Every Time

**Clarity/Delegation score: 5.15/10 — your strongest dimension**
**Duration: Ongoing**
**Priority: Ongoing**

---

## The Premise

You are not learning to write better prompts from scratch. You have already written an 8.75.
You have already written prompts that contain every element this course teaches. The skill
exists. The gap is applying it consistently — especially in the moments when you are under
pressure, moving fast, or context-switching between tasks.

This final module analyzes what your best prompts do and builds a system for applying those
same elements to every prompt, not just the formal ones.

---

## Your Best Prompts — Anatomy of an 8.75

The highest-scoring prompts from your sessions share a structure. Here are two documented
examples:

**Best prompt #1:**
```
Implement the following plan: # Implementation Plan: Safeguard for Missing transactionVolume...
```

This prompt references a pre-written plan document. The plan document (not shown in full)
contains:
- Clear scope definition
- File paths
- Explicit constraints
- Success criteria

The prompt scored 8.75 because it delegated structured information to Claude in the form
of a complete, organized document. Claude received a plan, not a wish.

**Best prompt #2:**
```
You are updating documentation ONLY. Do NOT modify any code, deployment scripts, .env,
or .mcp files. Your task: Update 3 documentation files...
```

This prompt scored high because:
1. Explicit constraint first: "ONLY" and "Do NOT" appear in the first line
2. Complete exclusion list: code, deployment scripts, .env, .mcp — nothing ambiguous
3. Numbered task list follows
4. Scope is bounded before any action begins

---

## The Five Elements of Your Best Prompts

Analyze every high-scoring prompt in your history and five elements appear consistently:

### Element 1: Explicit Constraints Before Actions

High-scoring: "You are updating documentation ONLY. Do NOT modify any code..."
Low-scoring: "update the docs"

The constraint appears before the instruction. This is architectural. When you lead with
the constraint, Claude's entire response generation operates within that boundary. When you
add the constraint at the end (or not at all), Claude has already committed to an approach
that may violate it.

**The formula:**
```
[What you must NOT do] + [What you must ONLY do] + [The actual task]
```

---

### Element 2: File References in the First Third

High-scoring prompts name files in the setup, not as an afterthought. The documentation
prompt immediately establishes which 3 files. The implementation plan includes paths
throughout.

Low-scoring prompts name files at the end (after the vague instruction), or not at all.

**The formula:**
```
[Task] — Files: [list] — [Details]
```

Not:
```
[Vague task with lots of context] — oh and also the file is [path]
```

---

### Element 3: Structured Plan Documents as Payload

The 8.75 prompt reads "Implement the following plan:" and attaches a complete plan document.
This is your highest-leverage pattern. A plan document as payload means:
- The structure lives in the document, not the prompt
- Claude receives complete context in a single shot
- You can reuse the plan document across sessions

When you have a complex implementation, write the plan first as a document, then your prompt
is one sentence: "Implement the following plan: [document]"

This is the pattern behind pre-written resume prompts with dense context front-loading. You
already know this works. The application is to extend it beyond high-stakes tasks.

---

### Element 4: Verification Loop Built Into the Prompt

High-scoring prompts often include a self-contained verification:
- "Confirm you have made both changes before continuing."
- "Show me the output before proceeding."
- "Do not merge — I will do it manually."

The verification is inside the prompt, not a separate follow-up. This means Claude
completes the task AND provides verification in one response.

**The formula:**
```
[Task] — [Constraints] — [Done when] — Confirm [X] before continuing.
```

---

### Element 5: Tool Delegation with Explicit Scope

From your verify-before-merge gate:
```
use uatu and a team of agents to review everything, dont limit yourself by the number of
agents specified in uatu, use as many as you think it will be best
```

This prompt delegates to a specific tool (uatu), specifies the scope (agent team), removes
a limitation that would otherwise apply (agent count), and defines the boundary (don't merge).
That is four dimensions of delegation precision in 30 words.

High-scoring prompts specify which tool to use, not just "review this." "Use uatu" produces
a different (better) result than "review this."

---

## Applying the 8.75 Pattern to Everyday Prompts

The documentation prompt and implementation plan prompts are formal, pre-written artifacts.
The everyday challenge is applying the same elements to quick, in-the-moment prompts.

### The 60-Second Pre-Send Check

Before sending any implementation or debugging prompt, run this 5-question check:

```
1. Did I state the constraint before the action? (ONLY, Do NOT)
2. Did I name at least one file path?
3. Did I write a "Done when" condition?
4. Is the structure visible (bullets, numbers, or headers)?
5. Does it include how to verify completion?
```

If you answer "no" to 3 or more: restructure before sending.
If you answer "no" to 1 or 2: add what is missing and send.

This check costs 60 seconds. It prevents 20-minute correction cycles.

---

## Extending Your Good Habits

You have three strong habits that appear consistently in your sessions. This module extends
each one from its current scope to a broader application.

---

### Habit 1: Verify-Before-Merge Gate

**Current scope:** You apply thorough multi-agent review before every merge.

**Extended scope:** Apply the same gate logic (not the same intensity) to every high-risk
action:

```
Before-deploy gate:
"Before deploying: confirm tests pass in staging, environment vars match
production format (excluding secrets), and rollback plan is documented."

Before-migration gate:
"Before running the migration: show me the SQL that will execute,
confirm it is reversible, and identify which tables are affected."

Before-close gate:
"Before I close this task: confirm the done-when conditions are met and
summarize what was changed."
```

The merge gate works because it forces a pause before an irreversible action. Deploy,
migration, and task-close are equally irreversible.

---

### Habit 2: Escalation After Failure

**Current scope:** After multiple failed patches, you escalate to full workflow review.

**Extended scope:** Set a lower threshold for escalation. One failed patch attempt is enough
to trigger the full-review prompt. You do not need to spend 5 attempts to earn the right
to ask for a real analysis.

**The new threshold rule:**
```
If the same problem persists after one fix attempt → escalate immediately.

Escalation prompt:
"Stop. The patch did not work. Do a full review of [component/workflow].
Find all the problems. List them by severity. Do not fix anything yet."
```

You have this pattern. Use it at turn 2, not turn 7.

---

### Habit 3: Board-First Reconnaissance

**Current scope:** You do board-first reconnaissance before starting work on a task.

**Extended scope:** Apply the same reconnaissance to session starts, not just task starts.

```
Session start reconnaissance:
"We are starting a new session on [project].
Before I give any instructions:
1. Summarize the last session's outcomes from [paste summary]
2. What is the current state of the codebase on the [branch] branch?
3. What is the highest-risk incomplete item from last session?

I will direct from there."
```

The board-first habit prevents "jumping in without context." The session-start recon
prevents "resuming work on stale assumptions."

---

## Pre-Written Prompt Library

Your best prompts are pre-written. The implementation plan is pre-written. The resume
context prompts are pre-written. This is not coincidence — writing prompts in advance,
outside the pressure of a live session, produces structurally better prompts.

Build a personal prompt library for your most frequent prompt types. Store in a file:
`.claude/prompt-library.md`

Suggested entries:

```markdown
## Debug: Full Workflow Review
stop patching. do a full review of [component/workflow].
find all problems. list by severity: critical / significant / minor.
do not fix anything — diagnose only.
files: [...]

## Before Deploy Gate
before deploying to [environment]:
1. confirm tests pass in staging
2. confirm environment vars match expected values (show diff vs. production format)
3. confirm rollback steps are documented
do not deploy until I confirm.

## Session Start
new session on [project].
context from last session: [paste summary]
board status: [link or description]
first priority: [task]
board-first recon: confirm you understand the current state before taking any action.

## Code Review Request
review [file or component].
focus on:
1. correctness — does it do what it claims?
2. error handling — what breaks if [X] fails?
3. security — any input that should be validated or sanitized?
do not refactor. do not add features. review only.
verdict: approve / request changes, with specific line references.

## Feature Handoff
implement [feature name] per the attached plan.
files: [...]
constraints: [...]
done when: [conditions]
confirm the done-when conditions are met before reporting complete.
```

---

## The Compound Effect

Each module in this course targets one dimension. Applied together, they compound:

```
Module 01 (Structure) + Module 03 (File References) + Module 04 (Done When)
= A complete implementation prompt

Module 02 (Verification) + Module 04 (Done When)
= A self-verifying implementation loop

Module 05 (Session Discipline) + Module 06 (Debug Template)
= Clean, focused debugging sessions

Module 07 (Strengths) = Apply the 8.75 pattern to all of the above
```

A prompt that is structured (01), verified (02), file-anchored (03), done-when bounded (04),
delivered in a focused session (05), with a diagnostic first pass if it breaks (06), using
your pre-written plan pattern (07) — that prompt routinely scores 7.5-8.5.

You have written that prompt. You have scored that high. The course teaches nothing new.
It teaches consistency.

---

## The Consistency Model

Your score distribution (from the analysis) is not a bell curve centered at 4.02. It is
bimodal: clusters of good prompts (6.0+) and clusters of bad prompts (2.0 and below), with
the bad cluster pulling the average down.

The goal is not to make every prompt an 8.75. The goal is to eliminate the 2.0 cluster.
When your worst prompts become 4.0 instead of 2.0, your composite score reaches 5.5+
without changing your best prompts at all.

That shift happens through habits, not heroics. The 60-second pre-send check is a habit.
The file-reference rule is a habit. The done-when formula is a habit. The "no next without
verify" rule is a habit.

Habits do not require motivation. They require repetition. This course is a 9-week
repetition program.

---

## The Remaining Gap: Tool Awareness (3.30/10)

Tool awareness is your second weakest non-structure dimension. You use uatu effectively
when you remember to — the verify-before-merge gate with multi-agent review is evidence.
The issue is inconsistent application.

Every time you would naturally say "review this" or "analyze this": specify the tool.
- "Review this using uatu's code-review skill"
- "Analyze this with a team of agents — use the security-review skill on the auth component"
- "Run the tdd-workflow skill against this feature before I sign off"

Tool awareness is the difference between "review this" (Claude defaults) and "review this
using [specific tool]" (you direct). You already know the tools. You just forget to name them.

Add tool specification to the 60-second pre-send check:
```
6. If this is a review/analysis task — did I specify which tool or agent pattern?
```

---

## Ongoing Practice

This module has no time limit. The exercises are permanent.

**Daily:**
- Run the 60-second pre-send check on every implementation prompt
- Add one file path if you forgot
- Add one done-when condition if you forgot

**Weekly:**
- Review 10 prompts from the week
- Identify the lowest-scoring one
- Rewrite it using the 8.75 pattern
- Note what was missing

**Monthly:**
- Re-run the prompt analysis against your updated history.jsonl
- Check your KPI metrics from Module 00
- Identify which dimension moved least — that is the next focus area

**When you write an especially good prompt:**
- Add it to your `.claude/prompt-library.md`
- Note what made it work
- Use it as a template

---

## The Standard

Your best prompt scored 8.75. That is your standard. Not 5.5 — that is the 9-week target.
The long-term standard is consistent performance above 7.0, with your best work in the 8-9
range.

That standard is achievable. You have already hit it. The course is the path to hitting it
every day.

---

## Quick Reference Card

```
The 5 elements of your best prompts:
1. Constraint before action (ONLY / Do NOT)
2. File references in first third
3. Plan document as payload
4. Verification loop inside the prompt
5. Tool delegation with explicit scope

Extend your 3 good habits:
- Verify-before-merge → verify-before-all-high-risk-actions
- Escalate-after-failure → escalate after ONE failure, not five
- Board-first-recon → session-start recon every time

60-second pre-send check:
1. Constraint stated?
2. File path named?
3. Done-when present?
4. Structure visible?
5. Verification included?
6. Tool specified (if review/analysis)?

Your standard: 8.75 exists in your history.
The goal: make it the baseline, not the exception.
```
