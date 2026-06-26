---
description: Run tests, analyze failures, and suggest fixes
argument-hint: "[test file pattern or component name]"
allowed-tools: ["Bash", "Read", "Write", "Edit", "AskUserQuestion"]
---

# /gg:test

Run tests and help fix failures. Uses $ARGUMENTS as a file/pattern filter if provided.

## Steps

### 1 — Detect the framework and run tests

Read `package.json` (scripts and devDependencies) to determine which framework is in use — Jest, Vitest, and/or Playwright. Do not guess by trial and error.

If $ARGUMENTS is provided, use it as a filter:
```bash
npx jest --testPathPattern="$ARGUMENTS" --no-coverage 2>&1
# or: npx vitest run "$ARGUMENTS" 2>&1
```

Otherwise run the full suite of the detected framework:
- Jest: `npx jest --no-coverage 2>&1`
- Vitest: `npx vitest run 2>&1`
- Playwright: `npx playwright test 2>&1`

### 2 — Analyze results

For each failing test:
- **Test name**: What test failed
- **Expected vs received**: What the test expected vs what it got
- **Root cause**: Most likely reason (logic bug, wrong mock, stale snapshot, missing setup)
- **Fix**: Specific code change to make the test pass

### 3 — Apply fixes

For each failure with a clear fix:
1. Read the relevant source file
2. Apply the fix, following GG conventions (no `any`, named exports, tests co-located with source)
3. Re-run only that test to confirm it passes

If a fix is ambiguous, ask the user before changing code.

After all fixes are applied, re-run the FULL suite once to confirm nothing regressed.

### 4 — Coverage check (optional)

If the user asks for coverage or $ARGUMENTS includes `--coverage`:
```bash
npx jest --coverage 2>&1
```
Report uncovered lines for files changed in the current branch.

### 5 — Summary

Report: total tests, passed, failed, skipped. List any tests still failing and why.
