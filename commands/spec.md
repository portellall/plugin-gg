---
description: Spec-driven development — write a spec, implement it, test it
argument-hint: "[feature name or description]"
allowed-tools: ["Read", "Write", "Bash", "AskUserQuestion", "Skill"]
---

# /gg:spec

Drive a feature from spec to working, tested code. Use $ARGUMENTS as the feature name or description.

## Workflow

### Phase 1 — Spec

1. If $ARGUMENTS is provided, use it as the starting point. Otherwise, ask the user what they want to build.

2. Draft a spec document with the following sections:
   - **Goal**: One sentence describing what this feature does and why
   - **Acceptance criteria**: Bullet list of observable behaviors (testable)
   - **Data shapes**: TypeScript interfaces/types for inputs and outputs
   - **Edge cases**: What should happen when inputs are invalid, missing, or unexpected
   - **Out of scope**: What this feature explicitly does NOT do

3. Present the spec to the user and ask for confirmation before proceeding.

### Phase 2 — Implementation

4. Implement only what the spec requires. No extras.
5. Follow GG conventions: named exports, strict TypeScript, no `any`, kebab-case files.
6. Add JSDoc only where the WHY is non-obvious.

### Phase 3 — Tests

7. Write tests that reflect each acceptance criterion (one test per criterion minimum).
8. Use Jest for unit tests. Place test files next to source (`foo.test.ts`).
9. Run tests: `npx jest --testPathPattern=<file>` and confirm they pass. If any fail, follow the `/gg:test` flow (analyze root cause → fix → re-run) until green.

### Phase 4 — Review

10. Verify the implementation against each acceptance criterion in the spec.
11. Report: ✓ criteria met, any gaps, and whether the feature is ready.
