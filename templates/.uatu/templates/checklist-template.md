# {Checklist Title} - Requirements Quality Validation

**Feature:** {Feature name from spec.md or user input}
**Checklist Type:** {requirements | testing | deployment | security | accessibility | performance | api | integration | custom}
**Purpose:** {1-sentence description of what this checklist validates}
**Created:** {YYYY-MM-DD}
**Total Items:** {Count}

---

## Instructions

This checklist validates the **QUALITY OF REQUIREMENTS**, not implementation or code.

**Key Principle - "Unit Tests for English":**
Each item asks whether requirements are well-defined, clear, complete, and consistent - NOT whether the implementation works.

**How to Use:**
- ✅ Mark item complete when requirement quality aspect is validated
- ❌ Leave unchecked if quality issue found (document in "Issues Identified" section)
- 💬 Add notes with `<!-- comment -->` for additional context
- 🔄 Re-check after making fixes to requirements

**Quality Dimensions:**
- **[Completeness]** - Are all necessary requirements present?
- **[Clarity]** - Are requirements specific and unambiguous?
- **[Consistency]** - Do requirements align without conflicts?
- **[Measurability]** - Can requirements be objectively verified?
- **[Coverage]** - Are all scenarios/edge cases addressed?
- **[Traceability]** - Can requirements be tracked through implementation?

---

## Checklist Items

### {Category 1 - e.g., Requirement Completeness}

- [ ] CHK001 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK002 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK003 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK001 - Are all functional requirements explicitly documented in spec.md? [Completeness, Spec §2]
- [ ] CHK002 - Are non-functional requirements (performance, security, accessibility) defined? [Coverage, Gap]
- [ ] CHK003 - Is the success criteria measurable and testable? [Measurability, Spec §1.3]

### {Category 2 - e.g., Requirement Clarity}

- [ ] CHK004 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK005 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK004 - Are vague terms ("fast", "scalable", "intuitive") quantified with specific metrics? [Clarity, Spec §3.1]
- [ ] CHK005 - Are all acronyms and domain terms defined in context? [Clarity, Gap]

### {Category 3 - e.g., Requirement Consistency}

- [ ] CHK006 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK007 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK006 - Do requirements in spec.md align with technical approach in plan.md? [Consistency, Cross-artifact]
- [ ] CHK007 - Are naming conventions consistent across all requirements? [Consistency, Spec §2]

### {Category 4 - e.g., Acceptance Criteria Quality}

- [ ] CHK008 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK009 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK008 - Does each user story have clear, testable acceptance criteria? [Measurability, Spec §4]
- [ ] CHK009 - Are acceptance criteria aligned with functional requirements? [Traceability, Spec §2 + §4]

### {Category 5 - e.g., Scenario Coverage}

- [ ] CHK010 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK011 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK010 - Are happy path requirements fully documented? [Coverage, Spec §4]
- [ ] CHK011 - Are error/exception scenarios defined with expected behavior? [Coverage, Spec §5]
- [ ] CHK012 - Are recovery/rollback requirements specified for state-changing operations? [Coverage, Gap]

### {Category 6 - e.g., Edge Case Coverage}

- [ ] CHK013 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK014 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK013 - Are boundary conditions documented (max/min values, empty states, null cases)? [Coverage, Spec §5]
- [ ] CHK014 - Are concurrent operation scenarios addressed? [Coverage, Gap]

### {Category 7 - e.g., Non-Functional Requirements}

- [ ] CHK015 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK016 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK015 - Are performance requirements quantified (response time, throughput, latency)? [Clarity, Spec §3.1]
- [ ] CHK016 - Are security requirements defined for all data access points? [Coverage, Spec §3.2]
- [ ] CHK017 - Are accessibility requirements specified (WCAG level, keyboard nav, screen readers)? [Completeness, Spec §3.3]

### {Category 8 - e.g., Dependencies & Assumptions}

- [ ] CHK018 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK019 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK018 - Are all external dependencies documented? [Completeness, Spec §6.1]
- [ ] CHK019 - Are assumptions explicitly stated and validated? [Clarity, Spec §6.2]
- [ ] CHK020 - Are dependency failure scenarios addressed? [Coverage, Gap]

### {Category 9 - e.g., Ambiguities & Conflicts}

- [ ] CHK021 - {Question about requirement quality} [{Quality Dimension}, {Reference}]
- [ ] CHK022 - {Question about requirement quality} [{Quality Dimension}, {Reference}]

**Example Items:**
- [ ] CHK021 - Are there any conflicting requirements between sections? [Consistency, Conflict]
- [ ] CHK022 - Are all placeholder terms (TODO, TBD, ???) resolved? [Completeness, Ambiguity]
- [ ] CHK023 - Are open questions documented and tracked for resolution? [Traceability, Spec §9]

---

## Completion Status

**Last Updated:** {YYYY-MM-DD or "Not yet started"}
**Items Completed:** 0 / {total_count}
**Completion Percentage:** 0%

### Progress by Category

| Category | Completed | Total | Progress |
|----------|-----------|-------|----------|
| {Category 1} | 0 | {count} | 0% |
| {Category 2} | 0 | {count} | 0% |
| {Category 3} | 0 | {count} | 0% |
| {Category 4} | 0 | {count} | 0% |
| {Category 5} | 0 | {count} | 0% |

*Update this table as you complete items*

---

## Issues Identified

*Document issues found during checklist validation. Reference CHK IDs.*

**Example Format:**
1. **CHK003** - Success criteria in §1.3 uses vague term "good user experience"
   - **Severity:** HIGH
   - **Location:** spec.md §1.3
   - **Issue:** Not measurable or testable

2. **CHK012** - No requirements for API timeout scenarios
   - **Severity:** MEDIUM
   - **Location:** spec.md §5 (missing)
   - **Issue:** Coverage gap - error handling incomplete

3. **CHK015** - Performance requirement says "fast loading" without metrics
   - **Severity:** HIGH
   - **Location:** spec.md §3.1 NFR-001
   - **Issue:** Ambiguous - needs quantification (e.g., "< 2 seconds")

---

## Actions Taken

*Document fixes made to address checklist issues.*

**Example Format:**
1. ✅ **CHK003** - Updated spec.md §1.3 with measurable criteria: "User satisfaction score > 4.0/5.0"
   - **Date:** YYYY-MM-DD
   - **Files Changed:** spec.md

2. 🔄 **CHK012** - In progress - drafting timeout requirements
   - **Date:** YYYY-MM-DD
   - **Status:** Draft created, awaiting review

3. ✅ **CHK015** - Quantified NFR-001: "Page load time < 2s on 3G connection"
   - **Date:** YYYY-MM-DD
   - **Files Changed:** spec.md

---

## Next Steps

After completing this checklist:

1. **Address All Issues:**
   - Review all unchecked items
   - Document issues in "Issues Identified" section
   - Prioritize by severity

2. **Make Fixes:**
   - Update spec.md, plan.md, or tasks.md as needed
   - Document changes in "Actions Taken" section
   - Mark checklist items as complete

3. **Validate Improvements:**
   - Run `/speckit.analyze` to verify fixes reflected in artifacts
   - Check for cross-artifact consistency
   - Ensure no new issues introduced

4. **Re-check:**
   - Update completion status
   - Verify all items checked
   - Archive completed checklist or keep as audit trail

5. **Ready for Implementation:**
   - Once 100% complete with zero critical issues
   - Proceed with `/speckit.implement`
   - Use this checklist as quality reference during development

---

## Reference: Quality Dimension Definitions

- **Completeness**: All necessary information is present; nothing important is missing
- **Clarity**: Requirements are specific, unambiguous, and easy to understand
- **Consistency**: Requirements align with each other without conflicts or contradictions
- **Measurability**: Requirements can be objectively tested or verified
- **Coverage**: All scenarios, paths, and edge cases are addressed
- **Traceability**: Requirements can be tracked from spec through plan to tasks to implementation

---

## Checklist Type-Specific Guidance

### Requirements Checklist
Focus on whether requirements themselves are well-written. Ask about presence, clarity, and consistency of requirement statements.

### Testing Checklist
Focus on whether **testing approach and strategy** are well-defined in requirements. NOT about executing tests, but whether test requirements exist and are clear.

### Deployment Checklist
Focus on whether **deployment prerequisites and procedures** are documented. What needs to be in place before deployment?

### Security Checklist
Focus on whether **security requirements** are comprehensive and aligned with threat model. Are security concerns addressed in requirements?

### Accessibility Checklist
Focus on whether **accessibility requirements** meet standards (WCAG). Are a11y needs defined in requirements?

### Performance Checklist
Focus on whether **performance criteria** are quantified and testable. Are performance requirements measurable?

### API Checklist
Focus on whether **API contracts, schemas, and behaviors** are fully specified. Are API requirements complete?

### Integration Checklist
Focus on whether **integration points, contracts, and error handling** are documented. Are integration requirements clear?

---

*Generated by `/speckit.checklist` command - Part of Uatu framework*
