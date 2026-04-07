# Module 06: When Debugging, Slow Down — Your Worst Prompts Are All Mid-Debug

**Failure response score: 3.40/10 (estimated from prompt quality in debug contexts)**
**Duration: 2 weeks**
**Priority: High**

---

## The Problem

When things break, your prompt quality collapses. The analysis shows your worst prompts —
the garbled, typo-heavy, incomplete-thought prompts — are concentrated in debugging sessions.
This is the opposite of what you need. Debugging requires more precision, not less.

The pressure of a broken system triggers a reactive mode: you type fast, you think out loud,
you send half-formed thoughts. Claude receives instructions that are literally incomplete
sentences and tries to reconstruct intent from fragments.

The result: Claude patches the most obvious surface symptom, you see it is wrong, you type
another frantic half-sentence, Claude patches again, and you spend 45 minutes on a problem
that a 3-minute structured analysis would have solved in one shot.

---

## The Data

Worst prompts in your history.jsonl (quoted directly):

```
"the curren screen does not look like the designs mainly because we were unable so far to parse
properly the markdown file, review the full worflow from prompting Ai storing the result in the
databae and showing the screen, maybe change everything to json and have converters to markdown
and from markdown use uatu and tehing the best way of going this"
```

```
"no, i told you not to do this, remove rhe test and use the is of the alterans foe testing n8n
and airtable needs to be"
```

```
"if thrre is a consile error it sjould alert the user"
```

These prompts share four traits:
1. Written under pressure (typos, truncation, run-ons)
2. Multiple concerns collapsed into one sentence
3. No file reference
4. No completion criteria

They are all debugging or correction contexts. That is not coincidence.

---

## The Good Pattern You Already Use

You already have the correct escalation instinct. From your sessions:

```
stop trying just to patch do a full review of the worflow and find all the problems at once
```

This prompt scored much higher than the individual patch prompts that preceded it. It
contains the correct insight: stop patching and diagnose the root cause.

The problem: you apply this insight after 5-10 failed patch attempts. The goal of this
module is to apply it before the first patch attempt. Diagnose first, fix second. Always.

---

## The Debug Template

Before sending any debugging prompt, fill in this template:

```
Problem: [what is broken — one sentence]

Current: [what the system currently does]

Expected: [what it should do]

Evidence: [error message, screenshot description, or log output]

Files involved: [file paths]

Action: [what you want Claude to do — diagnose / investigate / fix]
```

This is not bureaucracy. It is the minimum information required for Claude to give you
a non-patch answer. Without it, Claude will patch. With it, Claude will diagnose.

---

## Before/After Examples

---

### Example 1: The Markdown Parsing Problem

**Before (actual prompt):**
```
the curren screen does not look like the designs mainly because we were unable so far to parse
properly the markdown file, review the full worflow from prompting Ai storing the result in the
databae and showing the screen, maybe change everything to json and have converters to markdown
and from markdown use uatu and tehing the best way of going this
```

This is 7 different concerns in one sentence. Claude cannot address all of them coherently.
It will pick the most actionable fragment and run with it.

**After (structured):**
```
Problem: Screen does not match design — markdown is not rendering correctly.

Current: Markdown content is stored in the database but displays as raw text on screen.

Expected: Formatted markdown renders as styled HTML in the UI component.

Evidence: [paste one example of the raw markdown stored vs. what the screen shows]

Files:
- src/components/ContentDisplay.tsx — rendering component
- src/services/ai-prompt-service.ts — where AI response is generated
- src/api/content.ts — where content is stored

Action: Investigate the full pipeline from AI response → database storage → screen render.
        Identify which step is not transforming the markdown correctly.
        Do NOT propose a solution yet — diagnose first and tell me what you find.

Done when: You have identified the specific step where markdown transformation breaks.
```

**Score delta: +5.0 points** — the "diagnose first, no solution yet" constraint is the
critical addition. It forces Claude into analysis mode instead of patch mode.

---

### Example 2: The N8N / Airtable Testing Mix-Up

**Before (actual prompt):**
```
no, i told you not to do this, remove rhe test and use the is of the alterans foe testing n8n
and airtable needs to be
```

This is a correction prompt that trails off mid-sentence. Claude has to guess what
"airtable needs to be" means. It will guess wrong.

**After (structured):**
```
Stop. Two corrections to the previous approach:

1. Remove the test configuration you just added
   Reason: we do not use that test ID

2. For n8n and Airtable integration testing, use the Alterans organization ID
   File: .env.test (update AIRTABLE_ORG_ID to the Alterans value)

3. The Airtable configuration also needs [complete this sentence before sending]

Confirm both changes before continuing.
```

Note: item 3 is explicitly incomplete in the "after" — because the original prompt was
incomplete. The discipline of writing the template forces you to notice the incomplete
thought and finish it before sending.

**Score delta: +3.5 points** (even with the incomplete item 3, structure is a major
improvement over the raw prompt)

---

### Example 3: The Console Error Alert

**Before (actual prompt):**
```
if thrre is a consile error it sjould alert the user
```

Feature request or bug fix? Which component? What kind of alert? This is a 10-word prompt
with 3 typos and zero context.

**After (structured):**
```
Problem: Console errors are not surfaced to users — they fail silently.

Expected: When a console error occurs, the user sees a visible notification.

Files:
- src/components/ErrorBoundary.tsx — primary location for error handling
- src/hooks/useErrorAlert.ts — create this hook if it does not exist

Requirements:
1. Intercept console.error calls
2. Display a non-blocking toast notification with a generic message
3. Still log the original error (do not suppress it)
4. Do not alert on warnings — errors only

Done when: Calling console.error('test') in the browser triggers a visible toast.
```

**Score delta: +4.5 points**

---

### Example 4: The Typical Patch Spiral

**The spiral (typical debug session pattern):**
```
Turn 1:  "the login is broken"
Turn 2:  [Claude patches the obvious thing]
Turn 3:  "still broken"
Turn 4:  [Claude patches another thing]
Turn 5:  "no that made it worse"
Turn 6:  [Claude reverts and patches differently]
Turn 7:  "what is actually wrong here"
Turn 8:  [Claude finally does the analysis that should have been turn 1]
Turn 9:  "oh so we need to..."
```

8 turns of patches and reversions. The analysis in turn 8 is what turn 1 should have
requested.

**The diagnostic approach (turns 1-2 only):**
```
Turn 1:
Problem: Login is broken.

Current: POST /api/auth/login returns 500.

Expected: Returns 200 with JWT token on valid credentials.

Evidence: [error from browser console or server logs]

Files:
- src/api/auth/login.ts
- src/services/auth-service.ts

Action: Diagnose the root cause. Do not patch yet. Show me what you find.

Turn 2:  [Claude provides root cause analysis]
Turn 3:  [You confirm and ask for the fix]
Turn 4:  [Fix is applied correctly]
```

4 turns instead of 8. The fix is correct on the first attempt because it addresses the root
cause, not a symptom.

---

### Example 5: The "Stop Patching" Escalation — Applied Earlier

**Your existing pattern (good but applied too late):**
```
[After 5 failed patches]
stop trying just to patch do a full review of the worflow and find all the problems at once
```

**The same pattern applied at turn 1:**
```
Before patching anything: do a full review of the [X] workflow.
Find all the problems at once.
List them with severity (critical / significant / minor).
Do not fix anything yet — just diagnose.

After you have the list, I will prioritize and we will fix in order.
```

This is your escalation instinct codified as a first-turn debug prompt. You developed this
instinct through experience — the module is making it explicit so you apply it immediately
rather than after frustration.

---

## The Credential Security Issue

At least one session in your history.jsonl contained credentials pasted directly in chat.
This is a hard rule violation.

**Why it matters:**
- Claude Code sessions may be logged for safety review
- Conversation history is stored locally and may sync
- Any credentials pasted in chat should be considered compromised

**What to do instead:**

For API keys and secrets:
```
# Good — reference by name, not value
Set the AIRTABLE_API_KEY environment variable using the value from 1Password under
"Airtable Development Key". Do not paste the value here.
```

```
# Good — for configuration work
The config file should read the key from process.env.AIRTABLE_API_KEY.
The actual key value is in .env.local (already set, do not print it).
```

```
# Good — for debugging auth issues
The auth is failing. The token format is [describe format, not value].
Investigate why the auth header is being rejected.
```

Never paste:
- API keys (sk-, pk-, xoxb-, etc.)
- Database connection strings with passwords
- OAuth tokens
- JWT secrets
- SSH private keys

If a Claude session already has credentials in it, rotate those credentials immediately.

---

## The Typo Signal

When you notice you have typed a prompt with multiple typos, treat it as a signal:
- You are under cognitive pressure
- The thought is not fully formed
- Sending it will produce a patch, not a solution

Stop. Take 30 seconds. Fill in the debug template. Then send.

This is not about grammar. It is about the cognitive state that typos signal. When debugging
is going badly, the worst thing you can do is type faster. The best thing is to slow down
and write a structured diagnosis request.

---

## The "Full Review" Pattern

Your escalation prompt contains a pattern worth making explicit:

```
stop trying just to patch do a full review of the worflow and find all the problems at once
```

The "find all problems at once" instruction is high-quality prompting. It tells Claude to
perform exhaustive analysis rather than stopping at the first issue found. This pattern is
worth formalizing:

```
Full review: [component or workflow name]

Do not stop at the first problem found. Identify ALL issues.
After identifying all issues:
1. List them by category (logic errors, missing error handling, performance, security)
2. Rate each: critical / significant / minor
3. Do not fix anything yet

After the full list, I will choose which to fix and in what order.
```

This is the correct approach to complex debugging — not the escalation of last resort.

---

## Practice Exercises — 2 Weeks

### Week 1: Debug Template Discipline

Every time you start a debugging session, fill in the template before sending the first
prompt. No exceptions. If you cannot fill in the "Current" and "Expected" fields, you do
not understand the problem well enough to ask Claude to fix it.

Track: how many debug sessions this week started with a structured template?
Target: 100% of debugging sessions.

### Week 2: Diagnose First, Fix Second

Add "Do not fix yet — diagnose first" to every debug opening prompt. This forces Claude into
analysis mode. It also prevents the patch spiral by decoupling the diagnosis conversation
from the fix conversation.

Track: how many sessions avoided the patch spiral (more than 2 fix-and-revert cycles)?
Target: Zero patch spirals.

---

## Success Signal

After 2 weeks:
- Zero garbled debug prompts (the typo-heavy, incomplete-thought prompts disappear)
- Zero patch spirals longer than 2 cycles
- Debug sessions resolve in fewer total turns
- No credentials appear in chat

The compound effect: structured debug prompts naturally include file references (Module 03)
and done-when conditions (Module 04). The debugging context is where all the modules
converge — it is the hardest test of every habit simultaneously.

---

## Quick Reference Card

```
Debug template:
  Problem: [one sentence]
  Current: [what system does]
  Expected: [what it should do]
  Evidence: [error / log / screenshot]
  Files: [paths]
  Action: diagnose / investigate / fix

First action in debugging: diagnose, not patch
Typos in your prompt = slow down signal
"full review" > "fix this" when system is broken

Security rules:
  Never paste API keys in chat
  Reference by name: "the STRIPE_API_KEY in .env.local"
  If pasted → rotate immediately
```
