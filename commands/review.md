---
description: Review code against Grupo Gestão standards (TypeScript, React, security, performance)
argument-hint: "[file or directory path — defaults to git diff]"
allowed-tools: ["Read", "Bash", "Grep", "Glob", "Skill"]
---

# /gg:review

Review code against GG standards. If $ARGUMENTS is provided, review that path. Otherwise, review the current git diff (`git diff HEAD`).

## Review Checklist

### TypeScript
- [ ] No `any` types (use `unknown` with type guards instead)
- [ ] No non-null assertions (`!`) without comment explaining why it's safe
- [ ] Interfaces preferred over type aliases for object shapes
- [ ] Return types declared on all exported functions

### React / Next.js
- [ ] Named exports only — no default exports for components
- [ ] Hooks called at top level only (no conditional hooks)
- [ ] `useEffect` has correct dependency array
- [ ] Server vs Client components correctly separated (no `"use client"` unless needed)
- [ ] No direct DOM manipulation — use refs
- [ ] Images use `next/image`, links use `next/link`

### Code Quality
- [ ] No `console.log` in production code
- [ ] All async/await wrapped in try/catch or using a Result pattern
- [ ] No magic numbers or strings — use named constants
- [ ] Functions do one thing (< 40 lines as a guideline)
- [ ] File naming: `kebab-case.ts`, `PascalCase.tsx`

### Security
- [ ] No secrets or tokens hardcoded
- [ ] User input sanitized before use in queries, HTML, or shell commands
- [ ] `dangerouslySetInnerHTML` flagged if present

### Tests
- [ ] New behavior has accompanying tests
- [ ] Tests are co-located with source files

## Output Format

For each issue found, report:
- **File**: `path/to/file.ts:line`
- **Severity**: `error` | `warning` | `suggestion`
- **Issue**: What's wrong
- **Fix**: What to do instead

End with a summary: total errors, warnings, suggestions, and whether the code is ready to merge.
