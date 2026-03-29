---
description: Create properly structured Jira cards — Epics (domain), Stories (user outcomes), Subtasks (implementation). Enforces hierarchy and writing quality rules.
---

# Plan Work

## Arguments

$ARGUMENTS

## Execution

Take the user's feature description and produce a properly structured Jira hierarchy. Every card must follow the writing rules below.

### Step 1 — Identify the Epic

Check existing Epics in the project:
```
mcp__atlassian__jira_search(jql="project = <KEY> AND issuetype = Epic ORDER BY created DESC", fields="summary,status")
```

- If the feature fits an existing Epic domain → use it
- If it's a new product domain → propose a new Epic

**Epic naming:** `[DOMAIN] — Short descriptor`
- Good: `AUTH — User Authentication and Access`
- Bad: `Phase 1`, `Backend Work`, `Tech Debt Cleanup`

An Epic is a long-lived domain container, NOT a phase or project.

### Step 2 — Break Into Stories

Each Story = one user-visible outcome. Apply these rules:

**Story title rules:**
- Verb-first, action-oriented
- Under 60 characters
- Describes the outcome, not the technical approach
- Good: "Allow users to reset their password"
- Bad: "Backend work for password reset", "Add API for photos"

**Story description template:**
```markdown
## User Story
As a [role], I want [capability], so that [outcome].

## Acceptance Criteria
- [ ] [User-observable, testable behavior]
- [ ] [Another testable behavior]
- [ ] [Edge case or error state]

## Context (optional)
- [Links, constraints, prior decisions]
- [Explicitly out of scope]
```

**Acceptance Criteria rules:**
- Must be testable by a non-developer using the product
- Must describe behavior, not implementation
- 3-5 per Story
- Good: "User sees an error toast when upload fails"
- Bad: "API returns 422 with validation errors"

**Split the Story when:**
- More than one user outcome
- Would need more than 6-8 subtasks
- AC describe multiple features
- Title has "and" connecting two distinct actions

### Step 3 — Create Subtasks

Each Subtask = one concrete implementation step.

**Subtask title rules:**
- Describes one technical action
- Names the artifact being created or changed
- Good: "Create password reset request endpoint"
- Bad: "Work on password feature"

**Subtask rules:**
- Completable in less than one day
- 3-6 per Story (split Story if more than 8)
- Ordered by build sequence: data layer → API → UI
- Include technical details: files, APIs, DB tables, patterns
- Reference existing code patterns to follow

### Step 4 — Validate

Before creating anything, validate the hierarchy:

| Check | Rule |
|-------|------|
| Epic | Is it a product domain, not a phase? |
| Story title | Verb-first? Under 60 chars? No technical terms? |
| Story | One user-visible outcome? Demoable? |
| AC | Testable by non-developer? No implementation details? |
| Subtasks | Under 1 day each? 3-6 per Story? Ordered by build sequence? |

If any check fails, fix it before presenting to the user.

### Step 5 — Present for Approval

Show the full hierarchy:

```
Epic: AUTH — User Authentication and Access (existing UAT-XX)

  Story: Allow users to reset their password
    As a user, I want to reset my password via email, so that I can
    regain access to my account when I forget my credentials.

    Acceptance Criteria:
    - [ ] User can request a password reset from the login page
    - [ ] User receives a reset email within 30 seconds
    - [ ] Reset link expires after 24 hours
    - [ ] Invalid/expired links show a clear error message

    Subtasks:
    1. Create password reset request endpoint (POST /auth/reset-request)
    2. Add email template for reset instructions
    3. Write migration for password_reset_tokens table
    4. Build reset password form component
    5. Add rate limiting to prevent abuse (max 3 requests per hour)
```

Wait for user approval before creating in Jira.

### Step 6 — Create in Jira

After user approves, create all cards:

```
# Create Story under Epic
mcp__atlassian__jira_create_issue(
  project_key="<KEY>",
  summary="Allow users to reset their password",
  issue_type="Story",
  description="## User Story\nAs a user...\n\n## Acceptance Criteria\n...",
  additional_fields='{"parent": "<EPIC-KEY>"}'
)

# Create Subtasks under Story
mcp__atlassian__jira_create_issue(
  project_key="<KEY>",
  summary="Create password reset request endpoint",
  issue_type="Subtask",
  description="Technical details...",
  additional_fields='{"parent": "<STORY-KEY>"}'
)
```

### Special Issue Types

**If the user describes a bug:**
- Create as Bug under the relevant Epic
- Title = symptom, not cause ("Estimate total doesn't update after deleting a line item")
- Description: current behavior, expected behavior, steps to reproduce

**If the user describes an investigation:**
- Create as Spike
- Title: "Spike: [investigation topic]"
- Set time-box (1-2 days)
- AC = a written recommendation, not working code

**If the user describes internal improvement:**
- Create as Tech Debt Story
- User story: "As a developer, I want [X], so that [Y]"
- Still needs testable AC beyond "tests pass"
