# Module 03: Your File Reference Rate Dropped From 44% to 12%

**Context/File References score: 3.40/10**
**Duration: 2 weeks**
**Priority: High**

---

## The Problem

When you started working with Claude on code, you referenced files in 44% of your prompts.
As your work shifted from debugging (where you naturally point at the broken file) to
higher-level tasks (architecture, planning, delegation), that rate dropped to 12%.

The work became more abstract. The prompts became vaguer. Claude started making assumptions
about which files to touch instead of being told. Some of those assumptions were wrong.

File references are not just about convenience. They are about precision. When you name a
file, you constrain Claude's action space from "anywhere in the codebase" to "this file."
That constraint eliminates entire categories of wrong answers.

---

## The Data

- File reference rate: dropped from 44% to 12% over the analyzed period
- The 44% baseline (early period) coincides with your highest structure scores in the data
- The 12% rate (recent period) coincides with more abstract, planning-level work
- Root cause: higher-level tasks feel like they do not need file references — but they do

The good news: this is one of the easiest dimensions to improve. You already know how to
reference files. You did it at 44%. You just stopped doing it.

---

## Why File References Matter More as Work Gets Abstract

When you are debugging, the file is obvious — you are staring at the stack trace. When you
are planning a feature, the files are not in front of you, which is exactly when naming them
matters most.

Abstract prompt without file anchor:
```
Add rate limiting to the API
```

Claude has to decide: which API? Which files? Which layer (middleware, handler, service)?
It will make a choice, often a reasonable one, and sometimes the wrong one for your
specific codebase structure.

Same prompt with file anchors:
```
Add rate limiting to the registration endpoint.

Files:
- Middleware: src/middleware/rate-limit.ts (create if not exists)
- Handler: src/api/auth/register.ts (apply middleware here)
- Config: src/config/rate-limits.ts (store limits here)
```

Claude now has zero ambiguity about where to work. Every line of output is in scope.

---

## The "At Least One File" Rule

**Every code-modification prompt must name at least one file path.**

Not a folder. Not "the auth module." An actual file path relative to the project root.

If you do not know the exact file name:
1. First prompt: "What files handle user authentication in this project?"
2. Claude responds with file paths
3. Second prompt: names those specific files

The two-step is acceptable. Proceeding without a file reference is not.

---

## Before/After Examples

---

### Example 1: Webconnex — Payment Processing Feature

**Project context:** Webconnex payment platform, TypeScript/Go

**Before:**
```
the payment processor should retry failed transactions up to 3 times with exponential backoff
```

Claude has to decide: is this a backend service? A frontend handler? A webhook processor?
Which language? Go or TypeScript? It will guess.

**After:**
```
Add retry logic to the payment processor.

File: services/payment/processor.go

Requirements:
1. Retry failed transactions up to 3 times
2. Use exponential backoff: 1s, 2s, 4s
3. Only retry on network errors (not on validation failures)
4. Log each retry attempt with transaction ID and attempt number

Done when: unit tests cover the retry path including final failure after 3 attempts.
```

**Score delta: +3.0 points** — file anchor alone eliminates a category of wrong answers.

---

### Example 2: Globtech — Infrastructure Change

**Project context:** Toptal/Globtech infra, Terraform or similar

**Before:**
```
we need to update the timeout settings for the load balancer before the next deployment
```

Which load balancer config? Which environment? Which timeout (connection? idle? request?)?

**After:**
```
Update load balancer timeout settings before deployment.

File: infrastructure/terraform/modules/alb/main.tf

Changes:
1. connection_timeout: 60 → 120 seconds
2. idle_timeout: 300 → 600 seconds

Environment: staging first, then production (separate PRs)

Done when: terraform plan shows only these two changes, no unexpected diffs.
```

**Score delta: +3.5 points** — "terraform plan shows only these two changes" is also a
built-in verification gate (connects to Module 02).

---

### Example 3: Orion — Travel Planner Data Change

**Project context:** Alterans/Orion travel planner, markdown-based trip files

**Before:**
```
update the world tour chapter 5 budget to reflect the new hotel in Bangkok
```

Claude has to find the right file, the right chapter, the right section. If there are
multiple world-tour files or multiple Bangkok entries, it will guess.

**After:**
```
Update World Tour Chapter 5 budget — Bangkok hotel change.

File: orion/trips/world-tour/ch5-southeast-asia.md

Change:
- Old: Bangkok Marriott, $180/night x 3 nights = $540
- New: Bangkok Rosewood, $220/night x 3 nights = $660

Update:
1. Line item in the accommodation table
2. Running total for Chapter 5
3. Grand total budget summary at the top of the file

Do NOT modify any locked/executed items. Only update this one pending entry.
```

**Score delta: +4.0 points** — the file anchor, the explicit line items, and the "do not
modify locked items" constraint together prevent three separate failure modes.

---

### Example 4: Uatu — Framework Configuration

**Project context:** Alterans/Uatu AI orchestration framework

**Before:**
```
add the new skill to the uatu templates
```

There are 18 skills in the templates directory. "The new skill" is ambiguous.

**After:**
```
Add the new rate-limit-check skill to the Uatu template library.

Target file: uatu/templates/.claude/skills/rate-limit-check/SKILL.md

Content to create:
---
name: rate-limit-check
description: Analyze API endpoints for missing or misconfigured rate limiting
---

[Skill content follows...]

After creating the skill file, verify the skill appears in the skills directory listing.
```

**Score delta: +3.0 points**

---

### Example 5: BrutoAI — AI Measurement

**Project context:** Toptal/BrutoAI AI measurement platform

**Before:**
```
the measurement dashboard is missing some metrics, add the token cost per request
```

Which dashboard component? Which data source? Which API endpoint feeds the dashboard?

**After:**
```
Add token cost per request metric to the measurement dashboard.

Files to modify:
1. src/components/Dashboard/MetricsPanel.tsx — add TokenCostCard component
2. src/api/metrics.ts — add tokenCostPerRequest field to MetricsResponse type
3. src/hooks/useMetrics.ts — fetch the new field

Data source: the /api/v1/usage endpoint already returns token_cost_usd per request.
Map that field directly.

Done when: the dashboard shows token cost per request with the same styling as the
existing latency metric card.
```

**Score delta: +4.0 points** — the data source note alone saves a round-trip of "where
does this data come from?"

---

## The Two-Step Pattern for Unknown Files

When you do not know the file paths:

**Step 1 — Reconnaissance (acceptable ultra-short prompt):**
```
What files handle [X] in this project?
```

**Step 2 — Anchor the actual request:**
```
Good. Now [actual task].

Files: [the paths Claude just gave you]
```

This is slightly more turns but much higher quality per turn. The alternative — asking Claude
to find and modify files without guidance — compounds errors across discovery and implementation
in a single context.

---

## Path Format Conventions

Use relative paths from the project root. This matches how your codebase is organized and
how Claude Code reads files.

```
# Good — relative to project root
src/api/auth/register.ts
services/payment/processor.go
uatu/templates/.claude/skills/rate-limit-check/SKILL.md

# Acceptable — when you are unsure of exact path
src/api/ directory — find the auth handler
infrastructure/terraform/modules/

# Avoid — too vague to constrain Claude
"the auth module"
"somewhere in services"
"the config file"
```

---

## When File References Are Optional

Some prompts genuinely do not need file references:
- Pure explanation requests: "Explain how exponential backoff works"
- Architecture questions: "What is the best pattern for retry logic in Go?"
- Process questions: "What is the merge strategy for this PR?"

All code-modification prompts need file references. All configuration prompts need file
references. All review prompts benefit from file references.

When in doubt: include the file. The downside of an unnecessary file reference is zero.
The downside of a missing file reference is an answer about the wrong file.

---

## Practice Exercises — 2 Weeks

### Week 1: Tag Every Modification Prompt

Before sending any prompt that involves modifying code or configuration, add a "Files:"
section. Even if you write:

```
Files: [TODO — find and add before sending]
```

...do the lookup, then send. The act of pausing to find the file name builds the habit.

Track daily: what percentage of your code-modification prompts included at least one
file path?

Target: 40% by end of week 1 (baseline is 12%).

### Week 2: Track Weekly File Ref %

At the end of each day this week, scan your prompts and count the ratio of code prompts
that included file references. You should be at 50%+ by end of week 2.

Keep a simple tally:
```
Day 1: 4/8 prompts had file refs = 50%
Day 2: 5/9 prompts had file refs = 55%
```

---

## Success Signal

After 2 weeks:
- File reference rate above 35% (targeting 25% in KPI tracker by month 1)
- Zero code-modification prompts without at least one file path
- Noticeably fewer follow-up questions from Claude about "which file?"

The compound effect: a structured prompt (Module 01) + file anchors (this module) + a
done-when condition (Module 04) is a complete implementation prompt. Those three elements
together routinely produce 7.0+ scores.

---

## Quick Reference Card

```
Code modification? → "Files: [path]"
Config change? → "File: [path]"
Don't know paths? → 2-step: ask first, then anchor
Multiple files? → List all of them
Locked data? → Add "Do NOT modify [X]"
```
