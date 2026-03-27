---
description: Generate and run end-to-end tests — spawn a tester agent that creates Playwright test journeys, runs them, and captures artifacts.
---

# E2E

## Arguments

$ARGUMENTS

## Execution

You MUST spawn the tester agent NOW with an e2e-specific prompt:

```
Agent(subagent_type="tester", prompt="Generate and run end-to-end tests using Playwright for: $ARGUMENTS

E2E Workflow:
1. ANALYZE: Identify the user journey and test scenarios (happy path + error states)
2. GENERATE: Create Playwright tests using Page Object Model pattern
   - Use data-testid attributes for selectors (never CSS classes)
   - Wait for API responses, not arbitrary timeouts
   - Capture screenshots at key checkpoints
3. RUN: Execute tests across browsers (Chromium at minimum)
4. ARTIFACTS: Capture screenshots/videos/traces on failures
5. REPORT: Summarize results with pass/fail counts and artifact locations
6. FLAKY: Identify any flaky tests and recommend fixes

Rules:
- Use Page Object Model for maintainability
- Never test against production (staging/testnet only for financial tests)
- Test critical user journeys, not implementation details
- Keep tests independent (no shared state between tests)

Read .uatu/config/project.md for project conventions, test URLs, and framework setup.", isolation="worktree")
```

Wait for the agent to complete, then report results.

## When to Use

- Testing critical user journeys (login, payments, core flows)
- Verifying multi-step flows work end-to-end
- Validating frontend-backend integration
- Preparing for production deployment

## Related

- `/e2e-testing` skill — detailed Playwright patterns and CI/CD integration reference
- `/tdd` — for unit/integration tests (faster, more granular)
- `/code-review` — review test quality
