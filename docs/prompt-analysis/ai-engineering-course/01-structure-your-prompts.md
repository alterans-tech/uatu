# Module 01: Structure Is Your #1 Weakness (2.79/10)

**Score: 2.79/10 — the lowest dimension in your entire profile**
**Duration: 3 weeks**
**Priority: Critical**

---

## The Problem in One Sentence

When you have more than one thing to say, you write it as a single unbroken paragraph. Claude
reads it left-to-right the same way you wrote it, and the second half of your thought gets
less attention than the first.

Structure is not about making prompts look pretty. It is about signal clarity. A structured
prompt tells Claude: these are separate things, treat them separately. An unstructured prompt
tells Claude: sort this out yourself.

---

## The Data

- Structure is your weakest dimension at 2.79/10
- The median is 3.90, which means your average is pulled down by structured failures, not
  random variance
- The pattern appears most often during: (1) debug sessions, (2) multi-feature requests,
  (3) pivoting mid-thought
- Your BEST prompts — the ones that scored 8.75 — are all structured. You know how to do this.
  You just do not do it consistently.

---

## The Rule

**Any prompt longer than 15 words gets numbered items or bullets. No exceptions.**

This is not a guideline. Apply it mechanically until it becomes automatic. After 3 weeks of
forcing this, you will stop writing wall-of-text prompts because the habit will feel wrong.

---

## Before/After Examples

All "before" examples are quoted directly from your actual sessions.

---

### Example 1: The Markdown Pivot

**Before (actual prompt, scored ~2.0):**
```
the curren screen does not look like the designs mainly because we were unable so far to parse
properly the markdown file, review the full worflow from prompting Ai storing the result in the
databae and showing the screen, maybe change everything to json and have converters to markdown
and from markdown use uatu and tehing the best way of going this
```

**What Claude received:**
- Observation about screen appearance
- Hypothesis about markdown parsing
- Request to review a full workflow
- Suggestion to change data format entirely
- Suggestion to use uatu
- Implied request for a recommendation
- No file references, no scope, no priority order

**After (restructured):**
```
The current screen does not match the designs.

Root cause hypothesis: markdown parsing is failing somewhere in the pipeline.

Tasks:
1. Review the full workflow: AI prompt -> database storage -> screen render
2. Identify where markdown parsing breaks
3. Evaluate whether switching to JSON with markdown converters would fix it

Context:
- Use uatu for the evaluation
- Files involved: [list relevant files]

Done when: You have identified the root cause and recommended one approach with rationale.
```

**Score delta: +3.5 points** — same information, structured delivery.

---

### Example 2: The Garbled Mid-Debug

**Before (actual prompt, scored ~1.5):**
```
no, i told you not to do this, remove rhe test and use the is of the alterans foe testing n8n
and airtable needs to be
```

**What Claude received:**
- Correction (frustration signal)
- Partial instruction (remove the test)
- Partial alternative (use the ID of alterans)
- Incomplete sentence about n8n and airtable

Claude cannot complete an incomplete thought. It will guess, and the guess will be wrong.

**After (restructured):**
```
Stop. Two corrections:

1. Remove the test you just added — we are not using that approach
2. For n8n and airtable testing, use the Alterans organization ID, not a test ID

Confirm you have made both changes before continuing.
```

**Score delta: +4.0 points** — clarity jumps from 1.5 to ~5.5 on structure alone.

---

### Example 3: The Console Error One-Liner

**Before (actual prompt, scored ~2.5):**
```
if thrre is a consile error it sjould alert the user
```

**What Claude received:**
- Implied feature request (alert on console error)
- No file reference
- No scope (which page? which component?)
- No specification of what "alert" means (toast? modal? log?)
- No mention of existing error handling

**After (restructured):**
```
Feature: Alert users on console errors.

Scope: [component or page name]

Requirements:
1. Detect console errors at runtime
2. Display a user-visible alert (prefer toast notification, non-blocking)
3. Do not swallow the original error — still log it

Files to modify: [relevant component files]

Done when: A console.error() in the component triggers a visible toast.
```

**Score delta: +3.5 points** — the restructured version is actionable; the original is a wish.

---

### Example 4: The Multi-Concern Feature Request

**Before (typical unstructured pattern):**
```
we need to add pagination to the api and also the frontend should handle loading states and
make sure errors from the api come back properly formatted and the tests should cover the
new endpoint
```

**What Claude received:** 4 separate tasks run together with no priority, no file context,
no scope boundary, no success criteria.

**After (restructured):**
```
Add pagination to the users API endpoint.

Backend tasks:
1. Add page and pageSize query params to GET /api/users
2. Return { data, total, page, pageSize } in response
3. Ensure API errors return { error, code, message } format

Frontend tasks:
1. Handle loading state during pagination requests
2. Display error state when API returns error

Test requirements:
- Cover: happy path, empty page, out-of-bounds page, API error

Files:
- Backend: src/api/users.ts
- Frontend: src/components/UserList.tsx
- Tests: src/api/__tests__/users.test.ts

Done when: All tests pass and pagination works end-to-end in the browser.
```

**Score delta: +4.0 points**

---

### Example 5: The Context Pivot

**Before (typical mid-session pattern):**
```
actually forget that, the real problem is the auth token is expiring during the upload and
we need to handle that and also the file size validation needs to happen before the upload
not after and the progress bar should show during chunked uploads
```

**What Claude received:** A direction reversal, plus 3 new requirements, with no anchor to
which code is affected.

**After (restructured):**
```
Pivot — discard the previous approach.

The actual problems to solve (in priority order):
1. Auth token expires during large file uploads — add token refresh during upload
2. File size validation happens post-upload — move it to pre-upload client-side
3. Progress bar does not appear during chunked uploads — add progress tracking

Files affected:
- src/services/upload-service.ts (token refresh, chunking)
- src/components/FileUploader.tsx (validation, progress bar)

Done when: A 500MB upload completes with a visible progress bar, no auth expiry error,
and size validation triggers before the upload begins.
```

**Score delta: +4.5 points** — the pivot is now explicit, prioritized, and scoped.

---

## Why This Works

Claude is a token predictor. It generates tokens that are likely given the input. A structured
prompt creates clear anchors — numbered items, file names, headers — that signal "this is a
separate concern." Without those anchors, Claude weights all tokens equally and sometimes
conflates distinct requirements.

More practically: when Claude misunderstands a structured prompt, you can say "re-read item 2."
When Claude misunderstands an unstructured prompt, you have to rewrite the whole thing.

Structure is also a forcing function for you. The act of writing numbered items forces you to
count your concerns. If you are writing item 7, you probably need two prompts, not one.

---

## The Structure Templates

Memorize these. Apply them mechanically.

### For Feature Requests
```
[Feature name].

Requirements:
1. [Requirement]
2. [Requirement]

Files:
- [file path]

Done when: [testable condition]
```

### For Bug Reports
```
Bug: [what is broken]

Expected: [what should happen]
Actual: [what is happening]

Steps to reproduce:
1. [step]
2. [step]

Files: [relevant files]
```

### For Pivots / Corrections
```
Stop. [What to undo].

New direction:
1. [What to do instead]
2. [Any related changes]

Reason: [Why we're pivoting]
```

### For Review Requests
```
Review [what].

Focus on:
1. [Specific concern]
2. [Specific concern]

Context: [any relevant background]
Done when: You have given a verdict with reasoning.
```

---

## The 15-Word Rule in Practice

Count your words before you send. If the count is over 15 and you have not used a bullet or
number, stop and restructure. This sounds tedious. After 10 days it becomes automatic.

Prompts that are always allowed to be unstructured:
- Ultra-short acknowledgments: "ok", "yes", "proceed", "looks good"
- Single-question lookups: "what does this function return?"
- Direct file operations with no ambiguity

Everything else: structure it.

---

## Practice Exercises — 3 Weeks

### Week 1: Recognition

Look at every prompt you write before you send it. Ask: does this have more than one concern?
If yes, structure it. Do not worry about quality yet. Focus on the habit of pausing and looking.

Track daily: how many prompts did you restructure before sending?

### Week 2: Template Application

Pick one template from the list above and use it for every applicable prompt this week.
Rotate to a different template in week 3. The goal is muscle memory on the format.

### Week 3: Retrospective Review

At the end of each day, re-read your last 10 prompts. Mark any that should have been
structured. Rewrite them in your head (or on paper). This trains recognition after the fact,
which feeds forward into prevention.

---

## Success Signal

After 3 weeks, you will notice:
- Fewer clarifying questions from Claude
- Fewer correction prompts from you
- Faster task completion per session

If you are still writing wall-of-text prompts in week 4, repeat week 1. The habit must form
before you move on.

---

## Quick Reference Card

```
> 15 words? → Use bullets or numbers
Multiple concerns? → Separate them
Pivoting? → Say "Stop." first
Correcting? → Be explicit about what to undo
Feature request? → Always include "Files:" and "Done when:"
```

---

## Next Module

When structure feels automatic (approximately week 3), begin Module 02: Verify Between Steps.
The two habits compound — a structured prompt followed by a verification check is the core
loop of high-performance prompting.
