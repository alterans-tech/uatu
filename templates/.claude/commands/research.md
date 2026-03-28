---
description: Spawn 4 parallel researchers to investigate a topic before planning. Covers stack, features, architecture, and pitfalls.
---

# Research

## Arguments

$ARGUMENTS

## Execution

Spawn 4 parallel researcher agents, each investigating a different dimension of "$ARGUMENTS":

```
Agent(subagent_type="researcher", name="stack-researcher", prompt="Research the TECHNOLOGY STACK for: $ARGUMENTS

Investigate:
1. What libraries, frameworks, and tools does this project already use? (check package.json, requirements.txt, go.mod, etc.)
2. What existing patterns in this codebase are relevant?
3. What external libraries or APIs would be needed?

Output a brief (max 500 tokens): tech stack findings, recommendations, constraints.", run_in_background=true)

Agent(subagent_type="researcher", name="feature-researcher", prompt="Research EXISTING FEATURES related to: $ARGUMENTS

Investigate:
1. How do similar features already work in this codebase?
2. What patterns, utilities, or shared code can be reused?
3. Are there precedents for this type of feature?

Output a brief (max 500 tokens): existing patterns found, reuse opportunities, gaps.", run_in_background=true)

Agent(subagent_type="researcher", name="architecture-researcher", prompt="Research ARCHITECTURE implications for: $ARGUMENTS

Investigate:
1. Where should this hook into the existing architecture?
2. What components, services, or modules are affected?
3. What data flow changes are needed?
4. Are there architectural constraints or standards to follow?

Output a brief (max 500 tokens): integration points, affected components, data flow.", run_in_background=true)

Agent(subagent_type="researcher", name="pitfall-researcher", prompt="Research RISKS AND PITFALLS for: $ARGUMENTS

Investigate:
1. What could go wrong? (race conditions, edge cases, scaling issues)
2. Are there rate limits, quotas, or external dependencies to consider?
3. What security implications exist?
4. What are common mistakes when implementing this type of feature?

Output a brief (max 500 tokens): risks, pitfalls, mitigations.", run_in_background=true)
```

Wait for all 4 to complete, then consolidate:

```
## Research Summary: $ARGUMENTS

### Stack: [stack-researcher findings]
### Existing Patterns: [feature-researcher findings]
### Architecture: [architecture-researcher findings]
### Risks & Pitfalls: [pitfall-researcher findings]

### Recommendation
[synthesized recommendation based on all 4 dimensions]
```

Save the consolidated brief to `.uatu/delivery/research/` for use in subsequent `/speckit.plan`.
