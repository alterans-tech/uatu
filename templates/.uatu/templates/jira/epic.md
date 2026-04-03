# Epic Template

## Title Convention

Verb-first imperative or outcome noun-phrase:
- Good: "Enable SSO for Enterprise Customers", "Unified Customer Onboarding Experience"
- Bad: "Epic 0: Foundation", "Authentication", "Phase 1"

## Description Template

```
## Goal
[1-2 sentences: What business change does this initiative deliver? Why does it matter?]

## Hypothesis
If we [deliver this initiative], then [target users/stakeholders] will [expected outcome],
measured by [success metric].

## Scope
**In scope:**
- [Major capability 1]
- [Major capability 2]

**Out of scope:**
- [Explicit exclusion 1]
- [Explicit exclusion 2]

## Success Metrics
- [ ] [Measurable outcome 1 — e.g., "80% of users complete setup without support"]
- [ ] [Measurable outcome 2]

## Dependencies
- [Other Epics, teams, external systems that must exist first]

## Risks & Assumptions
- [What could invalidate the approach]
```

## Rules

- Epic = initiative (time-bounded body of work with a goal), NOT a domain category
- No "As a... I want..." user story format — that's for Stories
- No implementation details — that's for Stories and Sub-tasks
- No functional acceptance criteria — Epic has success METRICS (business outcomes), not AC (functional behavior)
- Done = all stories complete AND success metrics validated (not just story completion)
- Every Epic gets at least one domain Label (e.g., `authentication`, `api`, `infrastructure`)

## Example

**Title:** Enable AI-Powered Trip Planning and Editing

**Description:**

```
## Goal
Deliver the core user experience: type a rough trip idea, AI generates a structured plan,
rendered in web UI, editable with decided/undecided workflow and lock signals.

## Hypothesis
If we provide AI-generated trip plans with an intuitive editing workflow, then users will
create structured trip plans 10x faster than manual planning, measured by
time-to-first-complete-plan.

## Scope
**In scope:**
- AI trip generation from natural language input
- Markdown storage and rendering in web UI
- Decided/undecided item workflow
- Lock signals for finalized items

**Out of scope:**
- Real-price research (separate Epic)
- Sharing and collaboration (separate Epic)

## Success Metrics
- [ ] User can describe a trip and receive a structured plan
- [ ] End-to-end request completes in <2 seconds

## Dependencies
- Platform Foundation Epic must be complete
```
