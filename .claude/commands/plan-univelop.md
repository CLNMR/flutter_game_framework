---
description: Interactive planning from research. TDD-driven phased plan with automated + manual success criteria.
model: opus
---

# Plan

Create a phased implementation plan through interactive research and iteration. Every phase follows TDD: tests are written first, then implementation makes them pass.

## Process

### 1. Gather context

If a file path or GitHub issue was provided, read it fully. Otherwise ask:

```
What are we building? Provide a task description, GitHub issue, or link to research.
```

After receiving the task:
- Read all mentioned files fully (no limit/offset)
- Spawn **code-finder**, **code-analyzer**, and **code-pattern-finder** agents in parallel to research related code
- Wait for all agents to complete
- Read key files they identify
- Research existing test patterns (test helpers, mocks, fixtures) used in the relevant packages

### 2. Present understanding and ask questions

```
Based on the ticket and codebase research:
- [Current implementation with file:line refs]
- [Patterns and constraints discovered]
- [Existing test coverage and test patterns]

Questions my research couldn't answer:
- [Technical question requiring human judgment]
- [Business logic clarification]
```

Only ask questions you cannot answer through code investigation.

### 3. Research design options

If the user corrects a misunderstanding, verify the correction with new research tasks before proceeding.

Present design options with trade-offs. Get alignment on approach before writing the plan.

### 4. Write the plan

Get structure approval first, then write to `knowledge/shared/plans/YYYY-MM-DD-description.md`:

```markdown
# [Feature] Implementation Plan

## Overview
[What and why]

## Current State Analysis
[What exists, what's missing, constraints]
[Existing test coverage for affected code]

## Desired End State
[Specification and how to verify it]

## What We're NOT Doing
[Out-of-scope items]

## Implementation Approach
[High-level strategy — TDD: write failing tests first, then implement to make them pass]

## Phase 1: [Name]

### Overview
[What this phase accomplishes]

### Step 1: Write Tests
Define the expected behavior through tests before writing any implementation code.

#### 1. [Test for Component]
**File**: `path/to/test_file_test.dart`
**Tests**:
- [Test case: expected behavior]
- [Test case: edge case]
- [Test case: error handling]

### Step 2: Implement
Make the failing tests pass with the simplest correct implementation.

#### 1. [Component]
**File**: `path/to/file.ext`
**Changes**: [Summary]

### Step 3: Refactor
Clean up implementation while keeping all tests green.

### Success Criteria

#### Automated Verification
- [ ] New tests written and failing before implementation
- [ ] All tests pass after implementation: `melos run test`
- [ ] Analysis clean: `melos run lint`

#### Manual Verification
- [ ] [UI/UX check]
- [ ] [Edge case to test]

---

## Phase 2: [Name]
[Same structure: Tests first → Implement → Refactor]

---

## Testing Strategy
[Unit tests per phase, integration tests, manual steps]
[Test patterns to follow from existing codebase]
[Mock/fixture setup needed]

## References
- Research: `knowledge/shared/research/[relevant].md`
- Similar: `[file:line]`
- Test patterns: `[test file:line]`
```

### 5. Review and iterate

Present the plan location. Iterate until the user is satisfied. Resolve all open questions before finalizing — the plan must be complete and actionable.

## Guidelines

- TDD is mandatory: every phase must define tests before implementation. No code without a failing test first.
- Be skeptical: question vague requirements, verify with code, don't assume.
- Be interactive: get buy-in at each step, don't write the full plan in one shot.
- Be practical: incremental testable changes, consider migration and rollback.
- No open questions in the final plan. If blocked, stop and ask.
- Separate success criteria into automated (can run in CI) and manual (requires human).
- Research existing test helpers and patterns in the codebase — reuse them, don't reinvent.
