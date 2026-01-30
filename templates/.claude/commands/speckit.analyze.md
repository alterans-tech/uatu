---
description: Perform a non-destructive cross-artifact consistency and quality analysis across spec.md, plan.md, and tasks.md after task generation.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Goal

Identify inconsistencies, duplications, ambiguities, and underspecified items across the three core artifacts (`spec.md`, `plan.md`, `tasks.md`) before implementation. This command MUST run only after `/speckit.tasks` has successfully produced a complete `tasks.md`.

## Operating Constraints

**STRICTLY READ-ONLY**: Do **not** modify any files. Output a structured analysis report. Offer an optional remediation plan (user must explicitly approve before any follow-up editing commands would be invoked manually).

**Constitution Authority**: The project constitution (`.specify/memory/constitution.md`) is **non-negotiable** within this analysis scope. Constitution conflicts are automatically CRITICAL and require adjustment of the spec, plan, or tasks—not dilution, reinterpretation, or silent ignoring of the principle. If a principle itself needs to change, that must occur in a separate, explicit constitution update outside `/speckit.analyze`.

## Execution Steps

### 1. Initialize Analysis Context

Run `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks` once from repo root and parse JSON for FEATURE_DIR and AVAILABLE_DOCS. Derive absolute paths:

- SPEC = FEATURE_DIR/spec.md
- PLAN = FEATURE_DIR/plan.md
- TASKS = FEATURE_DIR/tasks.md

Abort with an error message if any required file is missing (instruct the user to run missing prerequisite command).
For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

### 2. Load Artifacts (Progressive Disclosure)

Load only the minimal necessary context from each artifact:

**From spec.md** (see `.uatu/templates/spec-template.md` for expected structure):

- Overview/Context (§1)
- Functional Requirements (§2)
- Non-Functional Requirements (§3)
- User Stories (§4)
- Edge Cases (§5)
- Dependencies & Assumptions (§6)
- Success Criteria (§1.3)
- Open Questions (§9)

**From plan.md:**

- Architecture/stack choices
- Data Model references
- Phases
- Technical constraints
- Integration points

**From tasks.md:**

- Task IDs
- Descriptions
- Phase grouping
- Parallel markers [P]
- Referenced file paths
- Dependencies

**From constitution:**

- Load `.uatu/config/constitution.md` for principle validation
- Extract MUST/SHOULD/MAY normative statements
- Note principle names and enforcement rules

### 3. Build Semantic Models

Create internal representations (do not include raw artifacts in output):

- **Requirements inventory**: Each functional + non-functional requirement with a stable key (derive slug based on imperative phrase; e.g., "User can upload file" → `user-can-upload-file`)
- **User story/action inventory**: Discrete user actions with acceptance criteria
- **Task coverage mapping**: Map each task to one or more requirements or stories (inference by keyword / explicit reference patterns like IDs or key phrases)
- **Constitution rule set**: Extract principle names and MUST/SHOULD normative statements

### 4. Detection Passes (Token-Efficient Analysis)

Focus on high-signal findings. Limit to 50 findings total; aggregate remainder in overflow summary.

#### A. Duplication Detection

- Identify near-duplicate requirements
- Mark lower-quality phrasing for consolidation

#### B. Ambiguity Detection

- Flag vague adjectives (fast, scalable, secure, intuitive, robust) lacking measurable criteria
- Flag unresolved placeholders (TODO, TKTK, ???, `<placeholder>`, etc.)

#### C. Underspecification

- Requirements with verbs but missing object or measurable outcome
- User stories missing acceptance criteria alignment
- Tasks referencing files or components not defined in spec/plan

#### D. Constitution Alignment

- Any requirement or plan element conflicting with a MUST principle
- Missing mandated sections or quality gates from constitution

#### E. Coverage Gaps

- Requirements with zero associated tasks
- Tasks with no mapped requirement/story
- Non-functional requirements not reflected in tasks (e.g., performance, security)

#### F. Inconsistency

- Terminology drift (same concept named differently across files)
- Data entities referenced in plan but absent in spec (or vice versa)
- Task ordering contradictions (e.g., integration tasks before foundational setup tasks without dependency note)
- Conflicting requirements (e.g., one requires Next.js while other specifies Vue)

### 5. Severity Assignment

Use this heuristic to prioritize findings:

- **CRITICAL**: Violates constitution MUST, missing core spec artifact, or requirement with zero coverage that blocks baseline functionality
- **HIGH**: Duplicate or conflicting requirement, ambiguous security/performance attribute, untestable acceptance criterion
- **MEDIUM**: Terminology drift, missing non-functional task coverage, underspecified edge case
- **LOW**: Style/wording improvements, minor redundancy not affecting execution order

### 6. Produce Compact Analysis Report

Output a Markdown report (no file writes) with the following structure:

## Specification Analysis Report

**Feature:** {Feature name from spec.md}
**Analysis Date:** {ISO timestamp}
**Artifacts Analyzed:** spec.md, plan.md, tasks.md, constitution.md

---

### Executive Summary

**Overall Status:** {CRITICAL / NEEDS WORK / READY / EXCELLENT}

{1-3 sentence summary of analysis results. Highlight critical blockers if any.}

**Recommendation:** {BLOCK IMPLEMENTATION / FIX ISSUES FIRST / PROCEED WITH CAUTION / READY TO IMPLEMENT}

---

### Key Findings

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| A1 | Duplication | HIGH | spec.md:L120-134 | Two similar requirements ... | Merge phrasing; keep clearer version |
| B1 | Ambiguity | HIGH | spec.md:L45, plan.md:L67 | "Fast loading" not quantified | Define specific timing threshold (e.g., < 2s) |
| C1 | Constitution | CRITICAL | spec.md:FR-003 | Violates principle "Privacy First" | Remove user tracking requirement or get explicit consent |
| D1 | Coverage Gap | MEDIUM | NFR-002 | Performance requirement has no tasks | Add tasks for performance testing/optimization |
| E1 | Inconsistency | HIGH | spec.md:L89, plan.md:L112 | Spec requires React, plan proposes Vue | Align on single framework |
| F1 | Underspecified | MEDIUM | spec.md:US-002 | Acceptance criteria lacks measurable outcome | Add specific success metric |

(Add one row per finding; generate stable IDs prefixed by category initial.)

---

### Cross-Artifact Consistency

#### Spec ↔ Plan Alignment

{List conflicts, missing items, or misalignments between spec.md and plan.md}

**Example Issues:**
- **Technology Mismatch**: Spec mentions PostgreSQL (FR-020), but plan.md proposes MongoDB
- **Missing Architecture**: Spec requires real-time updates (NFR-005), but plan.md doesn't address WebSocket implementation
- **Scope Creep**: Plan includes "admin dashboard" not mentioned in any spec requirement

**Alignment Score:** {X}% (calculated as: aligned items / total cross-referenced items)

#### Spec ↔ Tasks Coverage

{Map requirements to tasks, identify gaps}

**Example Issues:**
- **Uncovered Requirements**: FR-007, FR-015, NFR-003 have no corresponding tasks
- **Orphan Tasks**: Task T-023 implements feature not in spec
- **Incomplete Coverage**: FR-010 partially covered (only happy path, no error handling tasks)

**Coverage Score:** {X}% (requirements with >= 1 task / total requirements)

#### Plan ↔ Tasks Alignment

{Check if task breakdown matches plan phases and dependencies}

**Example Issues:**
- **Phase Mismatch**: Plan.md defines 3 phases, tasks.md has 5
- **Dependency Conflict**: Task T-015 depends on T-020 which is in later phase
- **Missing Tasks**: Plan phase 2 describes "data migration" but no tasks exist for it

**Alignment Score:** {X}% (tasks aligned with plan / total tasks)

---

### Requirement Coverage Analysis

| Requirement Key | Type | Has Task? | Task IDs | Coverage Status | Notes |
|-----------------|------|-----------|----------|-----------------|-------|
| FR-001 | Functional | ✅ Yes | T-001, T-002, T-008 | Complete | Includes happy path + error handling |
| FR-002 | Functional | ⚠️ Partial | T-003 | Incomplete | Missing edge case tasks |
| FR-003 | Functional | ❌ No | - | Missing | Critical feature with zero coverage |
| NFR-001 | Performance | ✅ Yes | T-015, T-016 | Complete | Testing tasks included |
| NFR-002 | Security | ❌ No | - | Missing | Security requirement not implemented |

**Summary:**
- Total Requirements: {count}
- Fully Covered: {count} ({percent}%)
- Partially Covered: {count} ({percent}%)
- Not Covered: {count} ({percent}%)

---

### Task Traceability

**Orphan Tasks** (tasks not mapped to any requirement):

| Task ID | Description | Severity | Recommendation |
|---------|-------------|----------|----------------|
| T-023 | Add dark mode toggle | MEDIUM | Add to spec as FR-999 or remove as out-of-scope |
| T-031 | Refactor database queries | LOW | Document as technical debt, not a requirement |

**Unmapped Tasks Count:** {count}

---

### Constitution Alignment Issues

{List any conflicts with project principles from constitution.md}

| Principle | Violation | Location | Severity | Required Action |
|-----------|-----------|----------|----------|-----------------|
| Privacy First | Requires user tracking without consent | spec.md:FR-003 | CRITICAL | Remove or add explicit consent flow |
| Accessibility MUST | No ARIA labels specified | spec.md:NFR-020 | HIGH | Add accessibility acceptance criteria |
| Test Coverage | No testing requirements | tasks.md | MEDIUM | Add testing phase and tasks |

**Constitution Compliance:** {X}% (aligned principles / total applicable principles)

---

### Quality Metrics

**Ambiguity Indicators:**
- Vague adjectives (fast, scalable, intuitive): {count} instances
- Unresolved placeholders (TODO, TBD, ???): {count} instances
- Missing acceptance criteria: {count} user stories
- Unquantified non-functional requirements: {count} instances

**Duplication Score:**
- Near-duplicate requirements: {count} pairs
- Redundant phrasing: {count} instances

**Completeness Score:** {X}% (calculated across multiple dimensions)

**Overall Quality Grade:** {A / B / C / D / F}

---

### Detailed Metrics

- **Total Functional Requirements:** {count}
- **Total Non-Functional Requirements:** {count}
- **Total User Stories:** {count}
- **Total Tasks:** {count}
- **Total Edge Cases Documented:** {count}
- **Coverage %:** {percent}% (requirements with >=1 task)
- **Ambiguity Count:** {count}
- **Duplication Count:** {count}
- **Critical Issues Count:** {count}
- **High Issues Count:** {count}
- **Medium Issues Count:** {count}
- **Low Issues Count:** {count}

### 7. Provide Next Actions

At end of report, output a prioritized Next Actions block:

---

### Recommended Next Actions

**Status:** {BLOCK / CAUTION / PROCEED}

#### Immediate Actions (Before Implementation)

{List critical and high-severity issues that must be resolved}

1. **[CRITICAL]** {Issue ID}: {Action description}
   - Command: `/speckit.specify` with focus on {specific area}
   - OR: Manually edit `spec.md` lines {X-Y} to {specific change}

2. **[HIGH]** {Issue ID}: {Action description}
   - Command: `/speckit.plan` to address {specific issue}
   - OR: Add tasks to `tasks.md` for {specific coverage gap}

**Example:**
1. **[CRITICAL] C1**: Resolve constitution violation in FR-003
   - Command: `/speckit.specify` with focus on privacy compliance
   - OR: Manually edit `spec.md` lines 120-134 to add explicit consent requirement

2. **[HIGH] E1**: Align technology choices between spec and plan
   - Command: `/speckit.plan` to update architecture section with React
   - OR: Manually edit `plan.md` section 2.1 to use React instead of Vue

#### Improvements (Can Be Addressed Later)

{List medium and low-severity issues}

3. **[MEDIUM]** {Issue ID}: {Action description}
4. **[LOW]** {Issue ID}: {Action description}

**Example:**
3. **[MEDIUM] D1**: Add performance testing tasks for NFR-002
   - Manually add 2-3 tasks to `tasks.md` Phase 3 for load testing

4. **[LOW] A1**: Merge duplicate requirements FR-012 and FR-015
   - Consolidate during next spec revision

#### Optional Enhancements

{Suggestions for quality improvements}

- Run `/speckit.checklist requirements` to validate requirement quality
- Run `/speckit.checklist testing` to ensure testability
- Consider adding more edge cases to Section 5 of spec.md
- Review constitution.md for any missing principles

---

**Decision Point:**

{If CRITICAL issues exist:}
⛔ **BLOCK IMPLEMENTATION** - Critical issues must be resolved before proceeding with `/speckit.implement`. Continuing with these issues will likely result in rework, failed reviews, or production incidents.

{If only HIGH issues exist:}
⚠️ **PROCEED WITH CAUTION** - High-severity issues should be addressed to avoid significant rework later. You may proceed if time-constrained, but expect refinement during implementation.

{If only MEDIUM/LOW issues exist:}
✅ **READY TO IMPLEMENT** - The specification is solid. Address medium-priority items during implementation if time permits. Low-priority items can be tracked as technical debt.

{If zero issues:}
🎉 **EXCELLENT QUALITY** - No issues found. Specification, plan, and tasks are well-aligned and complete. Proceed confidently with `/speckit.implement`.

### 8. Offer Remediation

Ask the user: "Would you like me to suggest concrete remediation edits for the top N issues?" (Do NOT apply them automatically.)

## Operating Principles

### Context Efficiency

- **Minimal high-signal tokens**: Focus on actionable findings, not exhaustive documentation
- **Progressive disclosure**: Load artifacts incrementally; don't dump all content into analysis
- **Token-efficient output**: Limit findings table to 50 rows; summarize overflow
- **Deterministic results**: Rerunning without changes should produce consistent IDs and counts

### Analysis Guidelines

- **NEVER modify files** (this is read-only analysis)
- **NEVER hallucinate missing sections** (if absent, report them accurately)
- **Prioritize constitution violations** (these are always CRITICAL)
- **Use examples over exhaustive rules** (cite specific instances, not generic patterns)
- **Report zero issues gracefully** (emit success report with coverage statistics)

## Context

$ARGUMENTS
