# Prompt Engineering Assessment v2

**Date:** 2026-03-27 (v2), updated 2026-03-30 (v3 scoring model)
**Scope:** Prompt quality and interaction patterns ONLY (not CLAUDE.md, not infrastructure)
**Data:** 10,508 prompts from history.jsonl + 5 sampled full conversations (1,165 turns)
**Period:** 2025-09-30 to 2026-03-27 (178 days)
**Projects:** 101 across 5 workspaces (alterans, webconnex, toptal, mettel, wavework)

---

## Methodology

> **Note:** v3 scoring model (2026-03-30) replaced the 7-dimension model below with
> a 5-dimension research-backed model. See `analyze-prompts.py` for the current scorer.
> Historical scores in this document use the v2 model. Re-run the analyzer for v3 scores.

### v3 Scoring Model (current)

5 research-backed dimensions with no signal overlap. Base score = 1 (wider dynamic range).
Exempt categories (execution, command, followup, continuation, correction, acknowledgment)
are excluded from scoring.

| Dimension | Weight | Signals |
|-----------|--------|---------|
| **Intent** | 20% | Action verbs, identifiable target, word count |
| **Context** | 25% | File paths, code blocks, backtick refs, error messages, function refs |
| **Specificity** | 20% | Assertive language, concrete values, absence of vague words |
| **Scope** | 15% | Constraints (don't/only), decomposition (bullets/numbers), multi-concern handling |
| **Verifiability** | 20% | Expected output, done-conditions, verification commands, format requests |

Research basis: PEEM (arXiv 2603.10477), arXiv 2601.13118 (code generation guidelines),
arXiv 2508.03678 (prompt specificity impact), Cursor best practices.

### v2 Scoring Model (historical, used for scores below)

7 dimensions (1-10) via heuristic analysis:
- **Clarity** — action verbs, file references, word count, specificity markers
- **Structure** — numbered items, bullets, headers, multi-line formatting
- **Context** — file refs, paths, error messages, URLs, code blocks
- **Specificity** — concrete vs vague language, decisive vs permissive words
- **Delegation** — verification requests, constraints, sequencing words
- **Success criteria** — expected output, format requests, verification commands
- **Tool awareness** — agent/orchestrate/worktree/speckit/mcp mentions

Composite = weighted average (clarity 20%, context 20%, structure 15%, specificity 15%, delegation 10%, success criteria 10%, tool awareness 10%).

### Qualitative (1,165 turns across 5 sessions)

5 largest conversation JSONL files sampled across alterans, webconnex, and toptal. Analyzed for: opening patterns, delegation style, correction patterns, failure handling, verification habits, session scope, quality variance.

### Exclusions

- CLAUDE.md quality (user doesn't always control these)
- Rules files and memory files (infrastructure, not prompts)
- Slash commands (/mcp, /exit, /resume) counted but not penalized — they're appropriate tool usage

---

## Overall Score

```
OVERALL PROMPT QUALITY: 4.02 / 10 (composite mean)
                        3.90 / 10 (composite median)

Adjusted (excluding slash commands + system): ~4.35 / 10
```

### Dimension Breakdown

| Dimension | Mean | Median | Stdev | Interpretation |
|-----------|------|--------|-------|----------------|
| Clarity | 5.15 | 5.00 | 1.79 | Moderate — action verbs present but scope often missing |
| Delegation | 5.15 | 5.00 | 1.39 | Moderate — some constraints and sequencing |
| Specificity | 4.74 | 5.00 | 0.95 | Below average — leans on vague language |
| Context | 3.40 | 3.00 | 0.78 | Weak — rarely references files or provides error context |
| Success criteria | 3.38 | 3.00 | 0.77 | Weak — almost never defines "done" |
| Tool awareness | 3.30 | 3.00 | 0.82 | Weak — tools used but rarely referenced in prompts |
| **Structure** | **2.79** | **3.00** | **0.96** | **Weakest — prompts are almost never structured** |

### Prompt Type Distribution

| Type | Count | % | Interpretation |
|------|-------|---|----------------|
| Questions | 2,177 | 20.7% | Collaborative interrogation — healthy |
| General | 1,914 | 18.2% | Uncategorized instructions |
| Ultra-terse (<=2 words) | 1,726 | 16.4% | "yes", "go", "continue", "next" |
| Feature requests | 1,160 | 11.0% | "add", "create", "implement" |
| Terse (3-5 words) | 1,149 | 10.9% | Short commands |
| Bug fixes | 743 | 7.1% | "fix", "broken", "error" |
| Reviews | 659 | 6.3% | "review", "check", "look at" |
| Testing | 396 | 3.8% | "test", "coverage" |
| Deploy | 278 | 2.6% | "push", "merge", "commit" |
| Commands | 170 | 1.6% | Slash commands |
| Research | 92 | 0.9% | "research", "explore" |
| Refactor | 44 | 0.4% | "refactor", "restructure" |

### Length Statistics

```
Characters: mean=178, median=64, stdev=3,285
Words:      mean=22,  median=11, stdev=71
```

**The median of 11 words tells the real story.** Half of all prompts are 11 words or fewer. The mean of 22 is pulled up by occasional long prompts (context dumps, implementation plans).

---

## Monthly Scores

| Month | Prompts | Mean | Median | Stdev | Trend | Key Signal |
|-------|---------|------|--------|-------|-------|-----------|
| 2025-09 | 10 | 3.78 | 3.70 | 0.54 | — | Baseline (too few for significance) |
| 2025-10 | 1,028 | 4.12 | 3.90 | 0.74 | +0.34 | Veylor + Webconnex ramp-up |
| **2025-11** | **739** | **4.21** | **4.00** | **0.89** | **+0.09** | **Peak — framework design period** |
| 2025-12 | 1,136 | 4.14 | 4.00 | 0.77 | -0.08 | Uatu design + webconnex features |
| 2026-01 | 2,572 | 4.04 | 4.00 | 0.66 | -0.09 | Volume spike — more routine work |
| 2026-02 | 2,371 | 3.92 | 3.85 | 0.57 | -0.12 | Lowest — high volume, short prompts |
| 2026-03 | 2,652 | 3.95 | 3.90 | 0.64 | +0.03 | Slight recovery — uatu/globtech work |

### Monthly Behavioral Metrics

| Month | Corrections | Verifications | Questions | Ultra-terse | File Refs |
|-------|-------------|---------------|-----------|-------------|-----------|
| 2025-10 | 8.1% | 15.9% | 4.8% | 28.0% | 37.4% |
| 2025-11 | 11.8% | 14.0% | 6.2% | 30.4% | 44.4% |
| 2025-12 | 10.5% | 16.6% | 7.2% | 18.9% | 26.6% |
| 2026-01 | 6.7% | 17.6% | 10.8% | 16.9% | 17.5% |
| 2026-02 | 5.0% | 17.9% | 15.2% | 17.5% | 11.6% |
| 2026-03 | 5.8% | 19.5% | 12.6% | 20.8% | 16.1% |

**Three healthy trends:**
1. Corrections halved (12% -> 5%) — fewer mistakes to correct
2. Verifications rising (14% -> 20%) — proactive quality checking
3. Questions tripled (5% -> 15%) — more collaborative, less command-issuing

**Two concerning trends:**
1. File references dropped (44% -> 12%) — prompts became less grounded in code
2. Prompt quality score slightly declined (4.21 -> 3.95) despite behavioral improvements

**Interpretation:** The behavioral metrics improved but prompt STRUCTURE degraded. You got better at working WITH Claude but worse at writing CLEAR INSTRUCTIONS for Claude. You compensated for weaker prompts with more interactive dialogue.

---

## Project Scores

### All Projects (>=10 prompts)

| Rank | Project | Prompts | Mean | Median | Period |
|------|---------|---------|------|--------|--------|
| 1 | alterans/veylor | 86 | 4.38 | 4.30 | Oct 2025 |
| 2 | mettel/warehouse_2025 | 78 | 4.31 | 4.25 | Oct 2025 |
| 3 | webconnex/platform (core) | 281 | 4.23 | 4.05 | Sep-Oct 2025 |
| 4 | alterans/uatu | 143 | 4.20 | 4.10 | Dec 2025-Mar 2026 |
| 5 | webconnex (workspace) | 4,199 | 4.02 | 3.90 | Sep 2025-Mar 2026 |
| 6 | alterans/finance-master | 241 | 4.07 | 4.00 | Jan-Mar 2026 |
| 7 | mettel (workspace) | 250 | 4.07 | 3.90 | Oct-Dec 2025 |
| 8 | toptal/globtech | 1,951 | 3.99 | 3.90 | Dec 2025-Mar 2026 |
| 9 | toptal/brutoai | 335 | 3.95 | 3.90 | Jan-Mar 2026 |
| 10 | alterans (workspace) | 1,828 | 3.94 | 3.90 | Oct 2025-Mar 2026 |

### Workspace Scores

| Workspace | Prompts | Mean | Interpretation |
|-----------|---------|------|----------------|
| mettel | 374 | 4.16 | Highest — focused warehouse work, specific domain |
| webconnex | 5,429 | 4.04 | Largest volume — microservice features |
| alterans | 2,298 | 3.99 | Framework + personal projects — mixed |
| toptal | 2,331 | 3.99 | Client consulting — routine implementation |

### Project x Month Matrix (>=10 prompts in a month)

```
Project                    Oct-25  Nov-25  Dec-25  Jan-26  Feb-26  Mar-26
─────────────────────────  ──────  ──────  ──────  ──────  ──────  ──────
alterans/veylor             4.38     —       —       —       —       —
mettel/warehouse_2025       4.31     —       —       —       —       —
webconnex/platform          4.31    3.36     —       —       —       —
alterans/uatu                —       —      4.47    4.16     —       —
webconnex (bulk)            4.13    4.15    4.17    4.02    3.93    3.96
toptal/globtech              —       —      4.06    4.06    3.88    3.99
alterans (bulk)              —       —      4.15    4.00    3.86    3.93
toptal/brutoai               —       —       —      4.03    3.85    3.97
alterans/finance-master      —       —       —      4.15    4.03    4.01
```

**Key observations:**
- **Uatu Dec 2025 (4.47)** is the highest project-month — framework design demands precise prompts
- **Feb 2026 is the low point across ALL projects** — high volume, routine work, attention fatigue
- **Every project trends slightly downward** — not project-specific, it's behavioral

---

## Qualitative Analysis

### What You Do Well

#### 1. Escalation After Failure
After 2-3 retries you escalate to root-cause analysis:
> "stop trying just to patch do a full review of the worflow and find all the problems at once"

This phrase appears verbatim in multiple sessions — habitual and correct.

#### 2. Verify-Before-Merge Gate
Habitual prompt before merging:
> "is this ready to merge? give a final check look at all angles, use uatu and a team of agents to review everything... dont merge it i will do it manually"

Appears in every session with a merge milestone.

#### 3. Manufactured Resume Prompts
Pre-written dense context for new sessions:
> "You are in the Orion project worktree at ... Read these files first: .uatu/config/constitution.md, CLAUDE.md..."

Deliberate session design — front-loading context.

#### 4. Structural Resets
Complete resets when approach is wrong:
> "We should nuke this branch and get back to master I didn't allow to start epic 0 we should keep only the Claude and uatu doc changes"

#### 5. Board-First Reconnaissance
Some sessions open with state assessment:
> "can you go to the board and check all the issues in the sprint, check the local worktrees and documentation and create a summary"

### What You Do Poorly

#### 1. Structure Is Almost Always Missing (2.79/10)
Multi-concern requests as run-on sentences:
> "the curren screen does not look like the designs mainly because we were unable so far to parse properly the markdown file, review the full worflow from prompting Ai storing the result in the databae and showing the screen, maybe change everything to json and have converters to markdown and from markdown use uatu and tehing the best way of going this"

#### 2. No Post-Action Verification
After Claude completes a task, you move to the next without verifying. The verify-before-merge gate only fires at milestones — between milestones, zero verification.

#### 3. "Next" Chains — Blind Trust
15 consecutive "next" to step through PR merges with zero verification between steps.

#### 4. Mid-Debug Prompt Degradation
Under pressure, prompts degrade to garbled reactions:
> "no, i told you not to do this, remove rhe test and use the is of the alterans foe testing n8n and airtable needs to be" [truncated]

#### 5. Session Scope Creep
438-turn session: started with "write a constitution", ended with live UI debugging. Should have been 5 separate sessions.

#### 6. Credentials in Chat
API keys, AWS credentials, and passwords pasted directly into prompts. These persist in JSONL files on disk.

---

## The Core Pattern

```
1. Dense context dump                    (GOOD)
2. "do it" / "yes" / "next"             (RISKY — no verification)
3. Something breaks
4. "stop patching, do a full review"     (GOOD — correct escalation)
5. "do it" / "yes" / "next"             (RISKY — same pattern repeats)
6. Milestone reached
7. "is this ready to merge? full check"  (GOOD — habitual gate)
```

Steps 2 and 5 are where quality is lost. Steps 1, 4, and 7 show you know what good looks like.

---

## Score Comparison: Best vs Average

| Metric | Your Best | Your Average | Gap |
|--------|-----------|-------------|-----|
| Composite score | 8.75/10 | 4.02/10 | 4.73 |
| Word count | 200+ words | 11 words (median) | 189 |
| Structure | Numbered, tagged, multi-section | Single sentence | Total |
| File references | Specific paths with @ refs | None | Total |
| Success criteria | "Done when: X, Y, Z" | Absent | Total |

**Your best prompts prove you can operate at 8.75. Your median is 3.90. The gap is consistency, not capability.**

---

## Estimated Percentile

```
Raw prompt quality:              ~45th percentile
Behavioral compensation:         +15 (verify gates, escalation, resets)
Session management penalty:      -5  (scope creep, no post-action verification)
────────────────────────────────
Adjusted percentile:             ~55th
```

---

## Study Plan (From Scratch)

### Priority 1: Structure Every Multi-Concern Prompt (Weeks 1-3)

**Your #1 weakness (2.79/10).** Before hitting enter on any prompt >15 words, add line breaks and numbers.

Before:
> "the curren screen does not look like the designs mainly because we were unable so far to parse properly the markdown file, review the full worflow from prompting Ai storing the result in the databae and showing the screen"

After:
> "Three issues with the current screen:
> 1. Doesn't match designs — markdown parsing is broken
> 2. Workflow needs review: AI prompt -> DB storage -> screen render
> 3. Consider JSON with markdown converters
>
> Start with #2 — review the workflow end-to-end first."

**Metric:** Structure dimension from 2.79 to 4.50+

### Priority 2: Post-Action Verification (Weeks 2-4)

After Claude reports completing a task, verify before the next task:
> "run the tests before continuing"
> "show me the diff"
> "does the page load correctly?"

**Metric:** Verification % from 19.5% to 30%+

### Priority 3: File-Anchor Your Prompts (Weeks 3-5)

Every code-modification prompt must name the file:

Before: "add error handling to the payment service"
After: "add error handling to src/services/payment-service.ts — wrap chargeCard in try/catch"

**Metric:** File reference % from 16.1% to 30%+

### Priority 4: Replace "next" With Checkpoint Prompts (Weeks 4-6)

Never send bare "next". Add a 5-word verification clause:

Before: "next" / "next" / "next"
After: "merge PR #1. Confirm deploy health before proceeding."

**Metric:** Ultra-terse % from 20.8% to 12%

### Priority 5: New Session at Task Boundary (Weeks 5-7)

438-turn sessions degrade context. Rules:
- New task = new session
- 100+ turns = /clear and restart
- Write 3-line summary before ending

### Priority 6: Define "Done" (Weeks 6-8)

Every implementation prompt ends with success criteria:
> "Done when: renders all sections, outputs PDF with cover page, all tests pass"

**Metric:** Success criteria dimension from 3.38 to 5.00+

### Priority 7: Structure Failure Responses (Weeks 7-9)

When debugging, use the template:
> "Problem: [one sentence]
> Current: [what's happening]
> Expected: [what should happen]
> Action: [what to do]"

---

## How to Track Progress

Run monthly:
```bash
cd /Users/arnaldosilva/Workspace/projects/alterans/uatu/prompt-analysis
python3 analyze-prompts.py
```

| KPI | Current | 1-Month | 3-Month | 6-Month |
|-----|---------|---------|---------|---------|
| Composite mean | 4.02 | 4.50 | 5.50 | 6.50 |
| Structure dim | 2.79 | 4.00 | 5.50 | 7.00 |
| File ref % | 16.1% | 25% | 35% | 40% |
| Verification % | 19.5% | 25% | 30% | 35% |
| Correction % | 5.8% | 4.0% | 3.0% | 2.0% |
| Ultra-terse % | 20.8% | 15% | 12% | 10% |

### Assessment History

| Date | Score | Percentile | Method |
|------|-------|-----------|--------|
| 2026-03-27 | 4.02/10 | ~55th | Automated: 10,508 prompts, 7 dimensions |

---

*Analysis: Claude Opus 4.6 using Python heuristic scoring (10,508 prompts) + qualitative sampling (1,165 turns across 5 sessions). Framework: Anthropic docs, arXiv 2601.13118, PEEM (arXiv 2603.10477), Self-Refine (arXiv 2303.17651).*
