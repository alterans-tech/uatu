# Story Template

## Title Convention

Verb-first, action-oriented, under 60 characters. Describes the user outcome, not the technical approach.
- Good: "Allow users to reset their password"
- Bad: "Backend work for password reset", "Add API for photos"

## Description Template

```
## User Story
As a [role], I want [capability], so that [outcome].

## Acceptance Criteria
- [ ] [User-observable, testable behavior]
- [ ] [Another testable behavior]
- [ ] [Edge case or error state]

## Context
- [Links, constraints, prior decisions]
- [Explicitly out of scope]
```

## Rules

- Each Story = one user-visible outcome
- AC must be testable by a non-developer using the product
- AC describes behavior, not implementation ("User sees error toast" not "API returns 422")
- 3-5 AC per Story
- Links to parent Epic — does NOT repeat Epic goal
- Every Story gets at least one domain Label

## Split the Story When

- More than one user outcome
- Would need more than 6-8 sub-tasks
- AC describe multiple features
- Title has "and" connecting two distinct actions

## Example

**Title:** Allow users to reset their password

**Description:**

```
## User Story
As a user who forgot my password, I want to reset it via email, so that I can
regain access to my account without contacting support.

## Acceptance Criteria
- [ ] User can request a password reset from the login page
- [ ] User receives a reset email within 30 seconds
- [ ] Reset link expires after 24 hours
- [ ] Invalid/expired links show a clear error message

## Context
- Depends on email service being configured
- Out of scope: SMS-based reset
```
