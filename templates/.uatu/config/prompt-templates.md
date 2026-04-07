# Prompt Templates

Copy-paste starters for common scenarios. Each template targets the dimensions that matter most: Context, Specificity, Scope, and Verifiability.

---

## Bug Fix

```
Problem: [one sentence describing what's broken]

Evidence: [error message, log output, or screenshot description]

Files:
- [file path 1]
- [file path 2]

Action: Diagnose first — do NOT fix yet.

Done when: Root cause identified with evidence pointing to specific file and line.
```

---

## Feature Implementation

```
Feature: [feature name]

Requirements:
1. [specific requirement with measurable outcome]
2. [specific requirement with measurable outcome]

Files:
- [file path 1] — [what changes here]
- [file path 2] — [what changes here]

Constraints:
- Do NOT modify [specific boundary]
- ONLY change [specific scope]

Done when:
1. [testable condition]
2. [testable condition]
3. Tests pass for the modified files

Note: For multi-file features, use `/orch "description" --dry-run` to review the execution plan before any changes run.
```

---

## Code Review Request

```
Review: [file path or PR description]

Focus on:
1. Correctness — does it do what the spec says?
2. Error handling — what breaks if [X] fails?
3. Security — any input that should be validated?

Do NOT refactor or add features. Review only.

Verdict: approve / request changes, with specific line references.
```

---

## Debug Session

```
Problem: [what is broken — one sentence]

Current behavior: [what the system currently does]

Expected behavior: [what it should do instead]

Evidence:
[paste error message, log output, or stack trace]

Files likely involved:
- [file path 1]
- [file path 2]

Action: Investigate the full pipeline from [start] to [end].
Do NOT propose a solution yet — diagnose first and tell me what you find.

Done when: You have identified the specific step where the failure occurs.

Note: If the fix touches auth, payment, migration, or encryption files, enter plan mode (`/plan`) before implementing — these areas require step-by-step approval.
```

---

## Architecture Decision

```
Decision needed: [what architectural choice]

Context:
- [why this decision matters now]
- [constraints: performance, cost, timeline, team size]

Options:
1. [Option A] — pros: [X], cons: [Y]
2. [Option B] — pros: [X], cons: [Y]

Evaluate and recommend with rationale.
Do NOT implement anything — decision only.
```

---

## Session Start

```
Project: [name], Branch: [branch name]

Last session summary:
[paste previous session summary or checkpoint]

Priority: [first task for this session]

Recon first: confirm current state of the branch and any uncommitted changes before taking action.
```

---

## Refactoring

```
Refactor: [what to refactor and why]

Files:
- [file path 1]
- [file path 2]

Constraints:
- Do NOT change external behavior
- Preserve all existing tests
- ONLY restructure [specific aspect]

Done when:
1. All existing tests still pass
2. [specific structural improvement achieved]
3. No new warnings or lint errors
```

---

## Research Before Planning

```
Research: [topic or technology to investigate]

Questions:
1. [specific question about the domain]
2. [specific question about implementation]
3. [specific question about pitfalls]

Context:
- Project uses: [tech stack]
- Relevant files: [paths]

Output: Summary with recommendations, not code.
```

---

## PR / Merge Gate

```
Before merging:
1. Confirm all tests pass (show output)
2. Confirm no lint errors
3. Show the list of files changed and their purpose
4. Identify any risks or areas that need manual verification

Do NOT merge — I will do it manually after reviewing your report.
```

---

## 60-Second Pre-Send Checklist

Before sending any prompt, check:

1. Did I state the constraint before the action? (ONLY, Do NOT)
2. Did I name at least one file path?
3. Did I write a "Done when" condition?
4. Is the structure visible (bullets, numbers, or headers)?
5. Does it include how to verify completion?
6. If review/analysis — did I specify which tool or agent?

If 3+ answers are "no": restructure before sending.
