---
description: Create properly structured Jira cards — Epics (initiatives), Stories (user outcomes), Tasks/Bugs, Subtasks. Auto-assigns Jira Labels as domain tags.
---

# Plan Work

## Arguments

$ARGUMENTS

## Issue Templates

Read the templates before creating any issues:
- **Epic:** `.uatu/templates/jira/epic.md`
- **Story:** `.uatu/templates/jira/story.md`
- **Task:** `.uatu/templates/jira/task.md`
- **Bug:** `.uatu/templates/jira/bug.md`
- **Sub-task:** `.uatu/templates/jira/subtask.md`

Each template defines: title convention, description template, rules, and examples. Follow them exactly.

## Execution

**FIRST**, use Sequential Thinking (`mcp__sequential-thinking__sequentialthinking`) to analyze the work:

- Thought 1: What is the initiative? Is this big enough for an Epic, or does it fit under an existing one? (Epic = spans multiple Stories)
- Thought 2: What domain Labels apply? (e.g., `authentication`, `payments`, `infrastructure`, `ui-ux`)
- Thought 3: What are the distinct user-visible outcomes? (Story boundaries)
- Thought 4: For each outcome — what does the user see, do, or get? (AC that a non-developer can verify)
- Thought 5: What are the implementation steps to build each outcome? (Subtasks — technical, ordered by build sequence)
- Thought 6: Validate — any Story mixing multiple outcomes? Any AC with implementation details? Any Subtask > 1 day? Labels assigned to every issue?

**THEN** produce a properly structured Jira hierarchy following the templates.

---

## Issue Hierarchy

```
Epic (initiative spanning multiple stories)
├── Story (user-visible outcome)
│   ├── Sub-task (implementation step)
│   └── Sub-task
├── Story
│   ├── Sub-task
│   └── Sub-task
├── Task (technical work, no user story)
│   └── Sub-task
└── Bug (defect)
```

**Every issue** (Epic, Story, Task, Bug, Sub-task) gets a **Jira Label** tag identifying its domain.

---

### Step 1 — Identify or Create the Epic

Check existing Epics in the project:
```
mcp__atlassian__jira_search(jql="project = <KEY> AND issuetype = Epic ORDER BY created DESC", fields="summary,status")
```

- If the feature fits under an existing Epic initiative → use it
- If this is a new initiative spanning multiple stories → create a new Epic

Read `.uatu/templates/jira/epic.md` for the full template. Key rules:
- **Epic = initiative, NOT a domain category**
- Title: verb-first imperative or outcome noun-phrase
- Description: Goal → Hypothesis → Scope (in/out) → Success Metrics → Dependencies → Risks
- No "As a... I want..." — that's for Stories
- No implementation details — that's for Sub-tasks

### Step 2 — Identify Labels

Check existing Labels in the project:
```
mcp__atlassian__jira_search(jql="project = <KEY> ORDER BY created DESC", fields="labels", limit=50)
```

Labels are **domain tags** — free-form strings that categorize issues by area, not by initiative. Examples:
- `authentication`, `payments`, `infrastructure`, `ui-ux`, `api`, `database`, `notifications`

Labels are created automatically when first used — no project-level setup needed. Use lowercase kebab-case.

**Label rule:** Every issue gets the Label matching its domain. A single issue can have multiple Labels if it spans domains.

### Step 3 — Break Into Stories

Read `.uatu/templates/jira/story.md` for the full template. Key rules:
- Each Story = one user-visible outcome
- Title: verb-first, under 60 chars, describes outcome not approach
- Description: User Story (As a/I want/So that) → Acceptance Criteria → Context
- AC: testable by non-developer, 3-5 per Story, behavior not implementation
- Split when: >1 outcome, >6-8 subtasks, title has "and"

### Step 4 — Create Subtasks

Read `.uatu/templates/jira/subtask.md` for the full template. Key rules:
- Each Subtask = one concrete implementation step, completable in <1 day
- Title: one technical action, names the artifact
- Description: Context anchor → Task → Inputs/Dependencies → Acceptance (code-level) → Technical Notes
- 3-6 per Story (split Story if >8)
- Ordered by build sequence: data layer → API → UI
- MUST be self-contained for AI agent execution without opening parent

### Step 5 — Validate

Before creating anything, validate the hierarchy:

| Check | Rule |
|-------|------|
| Epic | Initiative with goal + hypothesis? Not a domain category? |
| Labels | Every issue has at least one Label? |
| Story title | Verb-first? Under 60 chars? No technical terms? |
| Story | One user-visible outcome? Demoable? |
| AC | Testable by non-developer? No implementation details? |
| Subtasks | Under 1 day each? 3-6 per Story? Ordered by build sequence? |
| Sub-task | Has context anchor? Self-contained for AI agent? |

If any check fails, fix it before presenting to the user.

### Step 6 — Present for Approval

Show the full hierarchy with Label assignments:

```
Epic: Password Reset Feature
  Labels: authentication, notifications

  Story: Allow users to reset their password [authentication]
    As a user, I want to reset my password via email, so that I can
    regain access to my account when I forget my credentials.

    Acceptance Criteria:
    - [ ] User can request a password reset from the login page
    - [ ] User receives a reset email within 30 seconds
    - [ ] Reset link expires after 24 hours
    - [ ] Invalid/expired links show a clear error message

    Subtasks:
    1. Create password reset request endpoint (POST /auth/reset-request) [authentication, api]
    2. Add email template for reset instructions [notifications]
    3. Write migration for password_reset_tokens table [database]
    4. Build reset password form component [ui-ux, authentication]
    5. Add rate limiting to prevent abuse (max 3 requests per hour) [api]
```

Wait for user approval before creating in Jira.

### Step 7 — Create in Jira

After user approves:

1. **Create Epic** (if new):
```
mcp__atlassian__jira_create_issue(
  project_key="<KEY>",
  summary="Password Reset Feature",
  issue_type="Epic",
  description="## Goal\n...\n\n## Hypothesis\n...\n\n## Scope\n...\n\n## Success Metrics\n...",
  additional_fields='{"labels": ["authentication", "notifications"]}'
)
```

2. **Create Stories under Epic** with Labels:
```
mcp__atlassian__jira_create_issue(
  project_key="<KEY>",
  summary="Allow users to reset their password",
  issue_type="Story",
  description="## User Story\nAs a user...\n\n## Acceptance Criteria\n...",
  additional_fields='{"parent": "<EPIC-KEY>", "labels": ["authentication"]}'
)
```

3. **Create Subtasks under Story** with Labels:
```
mcp__atlassian__jira_create_issue(
  project_key="<KEY>",
  summary="Create password reset request endpoint",
  issue_type="Subtask",
  description="## Context\nPart of...\n\n## Task\n...\n\n## Acceptance (code-level)\n...",
  additional_fields='{"parent": "<STORY-KEY>", "labels": ["authentication", "api"]}'
)
```

### Special Issue Types

**If the user describes a bug:**
- Read `.uatu/templates/jira/bug.md` for the full template
- Create as Bug under the relevant Epic (or standalone)
- Title = symptom, not cause
- Description: current behavior, expected behavior, steps to reproduce
- Assign Label(s)

**If the user describes an investigation:**
- Create as Spike (Task with time-box)
- Title: "Spike: [investigation topic]"
- Set time-box (1-2 days)
- AC = a written recommendation, not working code
- Assign Label(s)

**If the user describes internal improvement:**
- Read `.uatu/templates/jira/task.md` for the full template
- Create as Task (not Story — no user-facing outcome)
- Must have clear done criteria
- Assign Label(s)

---

## Writing Rules (One Truth Per Level)

| Level | Answers | Content |
|-------|---------|---------|
| Epic | **WHY + WHAT** — initiative goal, hypothesis, scope, success metrics | No implementation details |
| Story | **WHAT** — user outcome + behavioral acceptance criteria | Links to Epic, does NOT repeat Epic goal |
| Task | **WHAT** — technical outcome + done criteria | Links to Epic, self-contained |
| Sub-task | **HOW** — technical steps + code-level done criteria | Context anchor line, does NOT repeat parent AC |

### Anti-patterns to Avoid
- Creating Epics as domain categories ("Authentication") — use Labels
- Using "As a..." format for Epics — use Goal/Hypothesis/Scope
- Copying epic goal into every story
- Same AC at both story and sub-task level
- Sub-task with no context line (agent must open parent)
- Story written as a task ("Add endpoint POST /trips")
- Vague AC ("should look good", "should work correctly")
- Forgetting to assign Labels to issues
