# Module 05: 438 Turns Is 5 Sessions, Not 1

**Session score: 3.60/10**
**Duration: 2 weeks**
**Priority: High**

---

## The Problem

Your longest sessions reach 438 turns. One Toptal/Globtech session had 43 context resets —
the equivalent of losing your working memory 43 times while trying to finish a single task.

The context window is not a limitation to work around. It is a hard boundary. When context
fills, Claude's recall of early decisions, early files, and early constraints degrades. You
continue working as if all that context is still active. It is not.

The result: contradictions between early and late session decisions, re-implementation of
work that was already done, and the cognitive load of managing an ever-growing context window
instead of focusing on the work.

---

## The Data

- 6% of sessions are 50+ turns
- Those sessions account for 35.5% of all prompts
- Maximum documented session: 438 turns
- One session: 43 context resets (context_window_reached events)
- Ultra-terse prompt rate increases in long sessions — degraded context leads to degraded prompts
- Mid-debug garbled prompts (Module 06) almost exclusively occur in long sessions

The concentration problem: 6% of sessions generate 35.5% of your prompts. These are not
productive marathons. They are context-exhaustion events that look like work.

---

## The 43 Context Resets Session

A single Toptal/Globtech session triggered 43 context resets. What this means in practice:

```
Turn 1:    Start working on feature X
Turn 50:   Context reset #1 — Claude summarizes what it knows
Turn 100:  Context reset #2 — earlier files are less accessible
Turn 150:  Context reset #3 — early decisions are paraphrased, not precise
...
Turn 400:  Context reset #20
Turn 438:  End of session
```

At context reset #20, Claude's understanding of early architectural decisions is based on
its own summaries of summaries of summaries — not the actual content. You are effectively
pairing with someone who has read the meeting notes from the meeting notes from the original
meeting, 20 times over.

This is why you ended up doing 43 resets in one session. Each reset triggers another
reset-prompt, which triggers more work, which fills context faster, which triggers the
next reset sooner.

---

## The Fix: Session Budget Rules

### Rule 1: New Task = New Session

A new task is anything that would require a different context to understand. Not a different
sub-step of the same task — a different task.

**Same task (continue in same session):**
- Implementing feature X, step 1 → step 2 → step 3
- Debugging issue Y, investigating cause → implementing fix → writing test

**Different task (new session):**
- Feature X implementation → switching to Bug Y fix
- Code review → starting new feature
- Infrastructure work → switching to API development

The rule is: if you have to re-explain a significant amount of background to continue,
start a new session.

### Rule 2: 100+ Turns = /clear

When your session reaches 100 turns without a natural break point:

1. Write a session summary (see template below)
2. Run `/clear`
3. Open with the summary as your first prompt

This is not starting over. It is resetting your shared working memory to a clean, accurate
state — instead of the degraded, recursive-summary state that forms naturally.

### Rule 3: Write Summary Before Ending

Before ending any session longer than 30 turns, write a summary prompt:

```
Summarize this session:
1. What we built / changed
2. What files were modified
3. What decisions were made and why
4. What is left to do
5. Any open questions or risks

Format: bullet points, I will use this as context for the next session.
```

Save Claude's response. Open the next session with it.

---

## Session Summary Template

Use this before `/clear` or before ending a session:

```
Session summary for [task name]:

Completed:
- [what was built/fixed]

Files modified:
- [file path] — [what changed]

Decisions made:
- [decision] — reason: [why]

Remaining:
- [what is left]

Open questions:
- [anything unresolved]

Next session should start with: [specific first action]
```

---

## The Context Window Is a Working Memory Limit

Think of the context window as working memory. A person can hold 7 ± 2 items in working
memory. When you exceed that, you start forgetting earlier items.

Claude's context window is larger but the same principle applies. Early files, early
decisions, and early constraints become progressively less available as more content enters
the window. The context reset events in the 43-reset session are Claude's equivalent of
"I forgot what you said at the start."

The difference from human working memory: you can see the exact symptom. It is called a
context reset. When you see one, treat it as a hard signal that the session needs a
summary-and-clear.

---

## Session Length Guidelines by Task Type

| Task Type | Recommended Session Length | Notes |
|-----------|---------------------------|-------|
| Focused implementation (1 feature) | 30-50 turns | End when feature is done |
| Bug investigation + fix | 20-40 turns | End when fix is verified |
| Code review | 15-25 turns | End when review is complete |
| Architecture / planning | 20-30 turns | End with summary doc |
| Multi-feature work | Split across sessions | One session per feature |
| Infrastructure changes | 30-50 turns | High-risk = shorter sessions |

438 turns covers approximately 8-15 of these tasks. Run them as separate sessions.

---

## Scope Creep in Long Sessions

The 438-turn sessions often start as one task and accumulate adjacent tasks. The pattern:

```
Turn 1:    "Implement user registration"
Turn 30:   Registration done. "Also fix the login bug I noticed"
Turn 60:   Login fixed. "While we're here, update the auth tests"
Turn 90:   Tests updated. "The token refresh is also broken"
Turn 120:  Token refresh fixed. "The email templates need updating too"
...
Turn 438:  [Everything has drifted, original task is buried, context is exhausted]
```

Each pivot is reasonable in isolation. Collectively they create a session where no single
concern received full context-window focus.

The fix: when you notice a pivot opportunity ("while we're here..."), write it down instead
of pursuing it. Start a new session for it after the current one is complete.

---

## The Board-First Reconnaissance Pattern

You already practice board-first reconnaissance before starting work. This is a strong
habit. It belongs at the start of every session:

```
Before we start: give me a reconnaissance summary.

Project: [name]
Board: [link or description]
Last session: [paste summary from previous session]

Tell me:
1. What was the state when we left off
2. What tickets are active
3. What is the highest priority right now

I will direct from there.
```

This 3-minute investment prevents the 30-minute "where were we?" reconstruction that
happens when you jump back into a long-running session without a clean start.

---

## The Globtech Lesson

The 43 context resets in one Globtech session represent the worst-case outcome of the no-
session-discipline approach. In that session, the accumulated cost was:
- 43 context reset prompts (overhead turns)
- Degraded architectural recall by reset #15
- Increasing prompt incoherence in later turns (the garbled mid-debug prompts in Module 06
  are concentrated in these long sessions)
- Total context budget consumed for one task that could have been 3 clean sessions

Three clean sessions of 40-50 turns each, with summaries between them, would have produced
better output in less wall-clock time.

---

## Practice Exercises — 2 Weeks

### Week 1: Session Awareness

Track your session lengths daily. At the end of each day, answer:
- How many sessions did I run?
- What was the longest session (in turns)?
- Did I write a session summary before ending it?
- Did any session cross the 100-turn mark without a `/clear`?

No behavioral change required yet. Pure awareness. You need to know what is happening
before you can change it.

### Week 2: Apply the Rules

Apply all three session rules:
1. New task = new session (track how often you actually start a new session for a new task)
2. 100+ turns = `/clear` after writing a summary
3. Write session summary before every session end > 30 turns

Track: average session length this week vs. last week.
Target: maximum session length under 150 turns by end of week 2.

---

## The Long-Term Target

The monthly KPI tracker targets "zero 438-turn sessions" by month 3. The intermediate
milestone is "maximum 150 turns per session" by end of module 5 (week 7).

Reaching 150-turn maximum means:
- Sessions are focused on one task or task cluster
- Context quality is maintained throughout
- Prompt quality in later turns does not degrade
- No context resets disrupting the flow

---

## Success Signal

After 2 weeks:
- No sessions longer than 150 turns
- At least 80% of sessions > 30 turns have a written summary
- Zero "where were we?" reconstruction prompts at session starts
- Board-first reconnaissance prompt used at the start of every new session

The indirect benefit: shorter sessions produce higher-quality prompts throughout. The
garbled, ultra-terse prompts that appear in your 200+ turn sessions disappear when sessions
are focused and bounded.

---

## Quick Reference Card

```
New task? → New session
100+ turns? → Write summary, /clear, continue clean
Before ending 30+ turn session? → Write session summary
Session start? → Board-first reconnaissance
Scope creep appearing? → Write it down, new session

Session summary includes:
- What was completed
- Files modified
- Decisions made + reasons
- What remains
- Next first action
```
