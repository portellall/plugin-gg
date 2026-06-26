---
description: Create a new project with GG standards — guided end-to-end for non-technical users (installs prerequisites, downloads libraries, runs the project)
argument-hint: "[optional: project name or description of what you want to build]"
allowed-tools: ["Bash", "Read", "Write", "AskUserQuestion"]
---

# /gg:setup

Create a new project following Grupo Gestão standards, from zero to running in the browser.

**Audience: extremely non-technical users.** Assume the person has never used a terminal, doesn't know what Node.js or git are, and may not have anything installed. They should never need to type a command themselves. Speak in simple Portuguese, avoid jargon, and explain each step in one plain sentence as you go.

## Etapa 1 — Entender o que a pessoa quer (sem jargão)

If $ARGUMENTS describes the project, use it as a starting point. Otherwise, use AskUserQuestion with plain-language options:

> **"O que você quer criar?"**
> - **Um site ou aplicativo web** — algo que as pessoas acessam pelo navegador *(internally: Next.js)*
> - **Um serviço de bastidores / API** — algo que processa dados, sem tela *(internally: Node.js + TypeScript)*
> - **Um pacote de código reutilizável** — para outros desenvolvedores usarem *(internally: TypeScript library with tsup)*

Then ask the project name. Convert it to a valid folder name yourself (e.g., "Painel de Vendas" → `painel-de-vendas`) — never ask the user to format it.

Then decide the location: suggest `~/Projetos/` (create it if it doesn't exist) and confirm. **Never overwrite an existing folder** — if the name is taken, say so and ask for another name.

## Etapa 2 — Diagnóstico do computador

First, detect the operating system — this decides how prerequisites get installed in Etapa 3 and how the browser opens in Etapa 5:

```bash
uname -s   # "Darwin" = macOS; "MINGW"/"MSYS"/"CYGWIN" = Windows (Git Bash); "Linux" = Linux
```

On Windows, Claude Code runs the Bash tool through **Git Bash**, so the diagnostic commands below work the same — only the install commands (Etapa 3) and the "open browser" command (Etapa 5) differ per OS.

Then silently check prerequisites:

```bash
command -v git && git --version
command -v node && node --version   # need >= 20
command -v npm && npm --version
```

Show a simple status board:

```
Verificando seu computador...
  ✅ Git — instalado
  ❌ Node.js — não encontrado (necessário para rodar o projeto)
  ✅ npm — vem junto com o Node
```

## Etapa 3 — Instalar o que falta (com confirmação explícita por item)

For EACH missing tool, explain what it is in one sentence and ask permission BEFORE installing. Example:

> "Seu computador não tem o **Node.js**, que é o motor que faz o projeto funcionar. Posso instalá-lo agora? Leva uns 2–5 minutos e não afeta nada que você já tem instalado."

Use the install commands for the OS detected in Etapa 2.

### macOS

1. **Homebrew** (only if missing) — the official installer (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`). Warn first: *"vai aparecer um pedido de senha — é a senha do seu Mac, e ela não fica salva em lugar nenhum."* After install, make sure `brew` is on PATH for the current session.
2. **Node.js 20+** — `brew install node@20` (and link it). If an older Node exists, install/upgrade rather than failing.
3. **Git** — `brew install git` (rare; macOS usually has it via Xcode CLT).

### Windows (via winget)

`winget` comes built into Windows 10/11 — no extra installer needed. Check it exists with `winget --version`; if it's missing (older Windows), point the user to install "App Installer" from the Microsoft Store.

1. **Node.js 20+** — `winget install OpenJS.NodeJS.LTS`
2. **Git** — `winget install Git.Git`

After installing, the new tools may only be on PATH in a fresh shell — tell the user that if a command isn't found right after install, you'll pick it up automatically (re-detect with `command -v`), and as a last resort they can reopen the project.

Rules (both OSes):
- One confirmation per tool — never batch-install silently.
- Install only via the OS package manager (Homebrew on macOS, winget on Windows) plus the official Homebrew installer itself. No other `curl | bash` or arbitrary script sources.
- If the user declines an install, stop gracefully and give clear manual instructions (links to nodejs.org etc.) for later.

## Etapa 4 — Criar o projeto com os padrões GG

All technical flags are pre-decided — ask the user nothing technical here. Narrate progress in plain language (e.g., *"Baixando as bibliotecas que o projeto precisa... é como baixar os ingredientes antes de cozinhar."*).

1. Scaffold by type:
   - **Site/app web**: `npx create-next-app@latest <name> --typescript --eslint --tailwind --app --src-dir --import-alias "@/*" --use-npm --yes`
   - **API/serviço**: create the folder, `npm init -y`, install `typescript tsx @types/node` + ESLint + Prettier as devDependencies, generate `tsconfig.json` (strict), a `src/index.ts` hello-world HTTP server, and `dev`/`build`/`start` scripts.
   - **Pacote/biblioteca**: `npm init -y`, install `typescript tsup vitest` (or jest) + ESLint + Prettier, generate `tsconfig.json` (strict), `src/index.ts` with one exported example function and a co-located test, and `build`/`test` scripts.

2. Ensure all libraries are downloaded (`npm install` — create-next-app already does this; guarantee it for the other types).

3. Create or update GG files at the project root:
   - `CLAUDE.md` — GG standards (template below)
   - `.gitignore` — must include `node_modules`, `.env*`, `.next`, `dist`
   - `.eslintrc.json` — strict TS, React hooks rules (web only)
   - `.prettierrc` — single quotes, no semicolons, 100 chars

4. Initialize history: `git init && git add . && git commit -m "chore: initial project setup"`

## Etapa 5 — Rodar e mostrar funcionando

The proof for a non-technical person is seeing it work:

- **Site/app web**: start `npm run dev` in the background, wait until `http://localhost:3000` responds (if the port is busy, use 3001), then open the browser using the right command for the OS detected in Etapa 2 — `open http://localhost:<port>` on macOS, `start http://localhost:<port>` on Windows (Git Bash), `xdg-open` on Linux. Confirm: *"Seu projeto está no ar! Essa página que abriu é ele rodando no seu computador."*
- **API/serviço**: start the server in the background, make a test request (`curl`), and show the response in plain terms.
- **Pacote/biblioteca**: run the example test (`npm test`) and show it passing.

## Etapa 6 — Resumo em linguagem humana

End with a summary like:

```
✅ Projeto "painel-de-vendas" criado em ~/Projetos/painel-de-vendas

O que você tem agora:
  • Um site funcionando em http://localhost:3000
  • Código organizado nos padrões do Grupo Gestão
  • Histórico de versões iniciado (git)

Próximos passos:
  • Para pedir mudanças: descreva o que quer aqui mesmo no Claude
  • Para construir uma funcionalidade nova: use /gg:spec
  • Para desligar o projeto: me peça "pare o servidor"
```

## Tratamento de erros

Never end with a raw stack trace. On any failure: diagnose, try to fix it yourself first (network failure on `npm install` → retry; port busy → switch port; permission issue → explain), and only if you can't, explain in ONE plain sentence what happened and what the person can do — e.g., *"O download falhou porque a rede bloqueou o acesso. Você está numa rede corporativa com proxy? Se sim, me diga e eu configuro."*

## GG CLAUDE.md template to inject

```markdown
# [Project Name]

## Stack
- TypeScript (strict)
- [framework]

## Conventions
- Named exports only
- kebab-case files, PascalCase components
- Co-locate tests with source files
- No console.log in production code
- All async functions must handle errors
```
