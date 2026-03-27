---
description: Enforce test-driven development — spawn a tester agent that writes failing tests FIRST, then implements minimal code to pass. Targets 80%+ coverage.
---

# TDD

## Arguments

$ARGUMENTS

## Execution

You MUST spawn the tester agent NOW with a TDD-specific prompt:

```
Agent(subagent_type="tester", prompt="Apply strict TDD (Red-Green-Refactor) to implement: $ARGUMENTS

TDD Cycle — follow this EXACTLY:
1. SCAFFOLD: Define interfaces/types for inputs and outputs
2. RED: Write failing tests FIRST (happy path, edge cases, error scenarios)
3. RUN: Execute tests, verify they FAIL for the right reason
4. GREEN: Write MINIMAL code to make tests pass — nothing more
5. RUN: Execute tests, verify they PASS
6. REFACTOR: Improve code while keeping tests green
7. COVERAGE: Check coverage, add tests if below 80% (100% for critical code)

Rules:
- NEVER write implementation before tests
- NEVER write more code than needed to pass
- Run tests after EVERY change
- Test behavior, not implementation details

Read .uatu/config/project.md for project conventions and test framework.", isolation="worktree")
```

Wait for the agent to complete, then report results.

## When to Use

- Implementing new features or functions
- Fixing bugs (write test that reproduces bug first)
- Refactoring existing code
- Building critical business logic

## Related

- `/tdd-workflow` skill — detailed TDD patterns and methodology reference
- `/e2e` — for end-to-end user journey tests (use `/tdd` for unit/integration)
- `/code-review` — review implementation after TDD
