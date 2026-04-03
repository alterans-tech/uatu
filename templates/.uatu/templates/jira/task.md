# Task Template

## Title Convention

Verb-first technical action. Names the artifact being created or changed.
- Good: "Migrate session storage to Redis", "Set up Datadog monitoring pipeline"
- Bad: "Backend work", "Infrastructure stuff"

## Description Template

```
## Objective
[What technical outcome does this task deliver?]

## Context
Part of [EPIC-KEY]: [one-sentence epic summary]

## Approach
- [Step 1]
- [Step 2]

## Done Criteria
- [ ] [Code-level verification — tests pass, types correct, deployed]
- [ ] [Measurable technical outcome]

## Files / Systems Affected
- [file path or system name]
```

## Rules

- No user story format — Tasks are internal technical work with no user-facing outcome
- Must have clear done criteria (code-level, not behavioral)
- Include context anchor linking to parent Epic
- Every Task gets at least one domain Label

## Example

**Title:** Migrate session storage from in-memory to Redis

**Description:**

```
## Objective
Replace in-memory session storage with Redis to enable horizontal scaling
and session persistence across deployments.

## Context
Part of UAT-89: Deliver Production-Ready Installation and Activation System

## Approach
- Add Redis client dependency
- Create session store adapter implementing existing interface
- Update configuration to read Redis connection from environment
- Add health check for Redis connectivity

## Done Criteria
- [ ] Sessions persist across server restarts
- [ ] Session TTL enforced by Redis (not application code)
- [ ] Health check reports Redis status
- [ ] All existing session tests pass with Redis backend

## Files / Systems Affected
- src/session/store.ts
- src/config/redis.ts
- docker-compose.yml (add Redis service)
```
