# Plugin GG — Grupo Gestão Claude Code Plugin

## Overview

This plugin provides standardized workflows for the Grupo Gestão development team. When this plugin is active, follow GG conventions at all times.

## Stack Conventions

- **Language**: TypeScript (strict mode, no `any`)
- **Frontend**: React + Next.js (App Router preferred)
- **Runtime**: Node.js 20+
- **Package manager**: npm or pnpm (check `package.json` for which one is in use)
- **Testing**: Jest (unit), Playwright (e2e)
- **Linting**: ESLint + Prettier (respect existing `.eslintrc` and `.prettierrc`)

## Code Standards

- Always use named exports (never default exports for components)
- File names: `kebab-case.ts`, component files: `PascalCase.tsx`
- No `console.log` in production code — use a logger utility if available
- All async functions must have proper error handling
- Prefer composition over inheritance
- Co-locate tests with source files (`foo.test.ts` next to `foo.ts`)

## Git Conventions

- Branches: `feat/description`, `fix/description`, `chore/description`
- Commits follow Conventional Commits: `type(scope): message`
  - Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`
- PR titles must match the commit format

## Spec-Driven Development

When working on a new feature:
1. Write or confirm a spec first (acceptance criteria, data shapes, edge cases)
2. Implement only what the spec requires
3. Write tests that reflect the spec
4. Review against the spec before considering done

## Available Commands

One command per stage of the development cycle:

| Command | Description |
|---------|-------------|
| `/gg:setup` | Create a new project with GG standards — guided end-to-end for non-technical users (installs prerequisites, downloads libraries, runs the project) |
| `/gg:spec` | Spec-driven development: spec → implement → test |
| `/gg:test` | Run tests, analyze failures, apply fixes, confirm nothing regressed |
| `/gg:review` | Code review against GG standards |
| `/gg:ship` | Conventional commit + optional PR with GG template |

## Behavior

- When reviewing code, always check against GG standards above
- When generating code, match the existing file's style exactly
- Never silently ignore TypeScript errors or ESLint warnings
- Ask for clarification before making architectural decisions
