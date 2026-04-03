# Sub-task Template

## Title Convention

One technical action. Names the artifact being created or changed.
- Good: "Create password reset request endpoint (POST /auth/reset-request)"
- Bad: "Work on password feature"

## Description Template

```
## Context
Part of [PARENT-KEY]: [one-sentence parent summary]

## Task
[Imperative verb — what exactly to build/change]

## Inputs / Dependencies
- [What must exist before this can start]
- [Files, APIs, or data this depends on]

## Acceptance (code-level)
- [ ] [Tests pass]
- [ ] [Types correct]
- [ ] [Specific technical verification]

## Technical Notes
- [Patterns to follow, files to reference]
```

## Rules

- Completable in less than one day
- 3-6 per parent Story/Task (split parent if >8)
- Ordered by build sequence: data layer → API → UI
- Context anchor line — sub-task MUST be self-contained enough for an AI agent to execute without opening the parent
- Acceptance is CODE-LEVEL (tests pass, types correct), not behavioral (that's the Story's job)
- Does NOT repeat parent's acceptance criteria
- Every Sub-task gets at least one domain Label

## Example

**Title:** Create password reset request endpoint (POST /auth/reset-request)

**Description:**

```
## Context
Part of VLR-17: Implement self-service password reset via email

## Task
Create the POST /auth/reset-request endpoint that accepts an email address,
generates a secure reset token, and triggers the reset email.

## Inputs / Dependencies
- User model with email field (exists)
- Email service configured (VLR-13)
- password_reset_tokens table (created in previous sub-task)

## Acceptance (code-level)
- [ ] Endpoint returns 200 for both existing and non-existing emails (no enumeration)
- [ ] Reset token stored with SHA-256 hash, 1-hour expiry
- [ ] Email service called with correct template and token
- [ ] Rate limited: max 3 requests per email per hour
- [ ] Unit tests cover: valid email, invalid email, rate limit hit, email service failure

## Technical Notes
- Follow the pattern in POST /auth/register for request validation
- Use crypto.randomBytes(32) for token generation
- Store hash, not plaintext token
```
