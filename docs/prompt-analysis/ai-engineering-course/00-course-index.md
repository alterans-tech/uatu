# AI Prompt Engineering Course
## Data-Driven from 10,508 Real Prompts

> **Note (2026-03-31):** This course was built on the v2 scoring model (7 dimensions: clarity,
> structure, context, specificity, delegation, success_criteria, tool_awareness). The current
> analyzer uses v3 (5 dimensions: intent, context, specificity, scope, verifiability) with
> outcome correlation. Core lessons still apply — the dimensions were consolidated, not
> invalidated. See `prompt-analysis/README.md` for the current model.

This course is not based on theory. It is based on 10,508 prompts extracted from your actual
`history.jsonl`. Every score, every example, and every exercise targets a real pattern in your
work.

---

## Your Baseline Scores (as of analysis date)

| Dimension | Score | Grade | Status |
|-----------|-------|-------|--------|
| Clarity / Delegation | 5.15/10 | C+ | Strongest — protect it |
| Structure | 2.79/10 | F | #1 weakness — Module 01 |
| Context / File References | 3.40/10 | F | Dropped 44% → 12% — Module 03 |
| Success Criteria | 3.38/10 | F | Near zero in prompts — Module 04 |
| Tool Awareness | 3.30/10 | F | Inconsistently applied — Module 07 |
| Verification Loops | 3.85/10 | D | "next" chains are the problem — Module 02 |
| Session Discipline | 3.60/10 | D | 438-turn sessions — Module 05 |

**Composite score: 4.02/10 (median 3.90)**
**Best prompt ever recorded: 8.75/10**
**Target in 9 weeks: 5.50/10**

The gap is not capability. You have written an 8.75. The gap is consistency.

---

## What the Data Found

### The Distribution Problem

- 16.4% of prompts are ultra-terse: 2 words or fewer ("next", "ok", "continue", "go")
- Those 1,725 ultra-terse prompts drag the average down by roughly 0.4 points on their own
- Removing them, your real working average is closer to 4.35 — still below target but much closer

### The Session Concentration Problem

- 6% of sessions are 50+ turns
- Those sessions account for 35.5% of all prompts
- Context quality degrades after turn 100; you have had sessions with 438 turns
- One Toptal/Globtech session had 43 context resets — the equivalent of starting over 43 times
  without closing the session

### The Learning Signal

- Corrections (you catching Claude's mistakes): dropped from 12% to 5% — good
- Verifications (you asking for confirmation): rose from 16% to 20% — good
- This shows learning is happening. The course accelerates it.

### The Security Event

- Credentials were pasted directly in chat in at least one session
- This is a hard rule violation: never paste API keys, tokens, or passwords into Claude
- Module 06 covers what to do instead

---

## The 7 Modules

| # | Title | Dimension Fixed | Duration | Priority |
|---|-------|-----------------|----------|----------|
| 01 | Structure Is Your #1 Weakness | Structure (2.79) | 3 weeks | Critical |
| 02 | Stop Saying "Next" — Verify First | Verification (3.85) | 3 weeks | Critical |
| 03 | Your File Reference Rate Dropped from 44% to 12% | Context (3.40) | 2 weeks | High |
| 04 | Success Criteria: You Almost Never Say When It's Done | Success Criteria (3.38) | 2 weeks | High |
| 05 | 438 Turns Is 5 Sessions, Not 1 | Session Discipline (3.60) | 2 weeks | High |
| 06 | When Debugging, Slow Down | Failure Response (3.40) | 2 weeks | High |
| 07 | Your Best Prompt Scored 8.75 — Do That Every Time | Synthesis | Ongoing | Ongoing |

Total: 9 weeks of focused practice, then ongoing refinement.

---

## 9-Week Timeline

```
Week 1-3:   Module 01 (Structure)
Week 2-4:   Module 02 (Verification) — overlaps with Module 01
Week 4-5:   Module 03 (File References)
Week 5-6:   Module 04 (Success Criteria)
Week 6-7:   Module 05 (Session Discipline)
Week 7-8:   Module 06 (Failure Response)
Week 8+:    Module 07 (Synthesis — never ends)
```

Modules 01 and 02 overlap by design. Structure and verification are the two biggest levers.
You should be practicing both simultaneously from day one.

---

## Monthly KPI Tracker

Check these numbers at the end of each month. You can re-run the analysis script against
your `history.jsonl` to get fresh data.

### Month 1 Targets (End of Week 4)

| KPI | Baseline | Target | How to Measure |
|-----|----------|--------|----------------|
| Composite score | 4.02 | 4.40 | Re-run analysis |
| Structure score | 2.79 | 3.50 | Re-run analysis |
| Ultra-terse % | 16.4% | 12.0% | Count <=2 word prompts |
| File ref % | 12% | 18% | Count prompts with file paths |
| Verification % | 20% | 24% | Count verify prompts |

### Month 2 Targets (End of Week 8)

| KPI | Month 1 | Target | How to Measure |
|-----|---------|--------|----------------|
| Composite score | 4.40 | 5.00 | Re-run analysis |
| Structure score | 3.50 | 4.50 | Re-run analysis |
| Success criteria % | ~5% | 20% | Count prompts with "Done when:" |
| Ultra-terse % | 12% | 8% | Count <=2 word prompts |
| File ref % | 18% | 25% | Count prompts with file paths |
| 50+ turn sessions | 6% | 4% | Count long sessions |

### Month 3 Targets (End of Week 12)

| KPI | Month 2 | Target | How to Measure |
|-----|---------|--------|----------------|
| Composite score | 5.00 | 5.50 | Re-run analysis |
| Structure score | 4.50 | 5.50 | Re-run analysis |
| Ultra-terse % | 8% | 5% | Count <=2 word prompts |
| File ref % | 25% | 35% | Count prompts with file paths |
| Success criteria % | 20% | 35% | Count prompts with "Done when:" |
| 438-turn sessions | present | zero | Max session length |

---

## How to Use This Course

1. **Read one module per week** — do not skip ahead
2. **Do the practice exercises** — reading without doing changes nothing
3. **Re-run your analysis monthly** — the data tells you if it's working
4. **Keep the worst-prompt examples nearby** — recognition is the first step
5. **Module 07 is permanent** — it is a reference you return to for the rest of your career

---

## The Core Insight

Your best prompt scored 8.75. Your average is 4.02. That 4.73-point gap is not a knowledge
problem — you clearly know how to write excellent prompts. It is a consistency problem.

The prompts that drag you down share three traits:
1. No structure (everything is one run-on thought)
2. No file reference (Claude has to guess what you mean)
3. No completion criteria (Claude has to guess when to stop)

Add those three things to your weakest prompts and most of them jump 3-4 points immediately.
That is the entire course in one sentence.

---

## Files in This Course

```
00-course-index.md          <- You are here
01-structure-your-prompts.md
02-verify-between-steps.md
03-file-anchor-everything.md
04-define-done.md
05-session-discipline.md
06-structured-failure-response.md
07-leverage-your-strengths.md
```
