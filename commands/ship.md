---
description: Ship your changes — conventional commit, then optionally push and open a PR with the GG template
argument-hint: "[optional extra context about the change]"
allowed-tools: ["Bash", "AskUserQuestion"]
---

# /gg:ship

Take the current changes from working tree to commit — and optionally to an open PR — in one flow.

## Steps

### 1 — Gather changes

Run `git status` and `git diff --cached`. If nothing is staged, show the modified files and ask the user which ones to include, then stage them.

### 2 — Draft the commit message

Analyze the staged diff and determine:

- **type**: `feat` (new feature), `fix` (bug fix), `chore` (tooling/deps), `docs`, `refactor`, `test`, `perf`
- **scope**: The affected module, component, or area (e.g., `auth`, `dashboard`, `api`)
- **subject**: Imperative, lowercase, no period — describes WHAT changed in < 72 chars
- **body** (optional): WHY the change was made, or any non-obvious context

If $ARGUMENTS is provided, use it as extra context when writing the body.

```
type(scope): subject

body (if needed)
```

### 3 — Confirm and commit

Present the message to the user and confirm before committing. Offer to edit if needed. Then run `git commit -m "..."` with the approved message.

### 4 — Commit only, or open a PR?

Ask: **"Só commit, ou commit + PR?"**

If the user wants a PR:

1. **Branch check**: if currently on the default branch (`main`/`master`), create a branch named after the commit type — `feat/<description>`, `fix/<description>`, or `chore/<description>` — and move the commit there.
2. **Push**: `git push -u origin <branch>`
3. **Create the PR** with `gh pr create`. Title must match the Conventional Commit format (`type(scope): subject`). Body uses the GG template:

```markdown
## Resumo
O que este PR faz e por quê, em 1–3 frases.

## Mudanças
- Lista das mudanças principais

## Como testar
1. Passos para verificar o comportamento

## Checklist GG
- [ ] Sem `any` / `console.log`
- [ ] Named exports apenas
- [ ] Testes acompanham o novo comportamento
- [ ] Convenções de nomes (kebab-case / PascalCase)
```

4. Report the PR URL.

## GG Commit Examples

```
feat(auth): add JWT refresh token rotation

Prevents token reuse after logout by rotating the refresh token on each use.

fix(dashboard): correct weekly totals calculation when month spans two periods

chore(deps): upgrade next.js from 14.1 to 14.2

refactor(api): extract pagination logic into shared utility
```
