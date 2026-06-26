# Plugin GG — Plugin Claude Code do Grupo Gestão

Workflows padronizados do Claude Code para o time de desenvolvimento do Grupo Gestão.

## Instalação

### macOS / Linux

```bash
git clone <repo-url> ~/gg-plugin
cd ~/gg-plugin
bash install.sh
```

Requer `jq` e Claude Code:

```bash
# macOS
brew install jq

# Ubuntu / Debian
sudo apt-get install -y jq
```

### Windows

O `install.sh` é um script Bash — é necessário um ambiente Unix. Há duas opções:

**Opção A — WSL2 (recomendado)**

1. Instale o WSL2 com Ubuntu pelo PowerShell (como Administrador):
   ```powershell
   wsl --install
   ```
2. Abra o terminal Ubuntu e instale as dependências:
   ```bash
   sudo apt-get update && sudo apt-get install -y jq git
   ```
3. Instale o Claude Code no WSL2:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```
4. Clone e instale o plugin:
   ```bash
   git clone <repo-url> ~/gg-plugin
   cd ~/gg-plugin
   bash install.sh
   ```

**Opção B — Git Bash**

1. Instale o [Git for Windows](https://git-scm.com/download/win) (inclui Git Bash)
2. Instale o `jq` via [winget](https://winget.run/pkg/jqlang/jq) ou [Chocolatey](https://chocolatey.org/packages/jq):
   ```powershell
   winget install jqlang.jq
   # ou
   choco install jq
   ```
3. Abra o Git Bash e instale o plugin:
   ```bash
   git clone <repo-url> ~/gg-plugin
   cd ~/gg-plugin
   bash install.sh
   ```

---

Após instalar (em qualquer plataforma), reinicie o Claude Code. Todos os comandos ficam disponíveis imediatamente.

---

## Fluxos

Cinco comandos, um por etapa do ciclo de desenvolvimento:

```
/gg:setup  →  /gg:spec  →  /gg:test  →  /gg:review  →  /gg:ship
(criar         (spec →       (rodar e      (revisar       (commit +
 projeto)       implementar    corrigir      contra os      PR)
                → testar)      testes)       padrões GG)
```

| Comando | Descrição |
|---------|-----------|
| `/gg:setup` | Criar um novo projeto do zero, guiado para pessoas não-técnicas — verifica e instala pré-requisitos, baixa bibliotecas, configura os padrões GG e roda o projeto no navegador |
| `/gg:spec` | Desenvolvimento orientado a spec — escrever spec → implementar → testar |
| `/gg:test` | Rodar testes, analisar falhas, aplicar correções e confirmar que nada regrediu |
| `/gg:review` | Revisão de código com base nos padrões GG (TypeScript, React, qualidade, segurança, testes) |
| `/gg:ship` | Gerar commit convencional a partir das mudanças e, opcionalmente, abrir um PR com o template GG |

---

## Skills

O Claude ativa estas skills automaticamente quando o contexto da tarefa bate com a descrição de cada uma. O `install.sh` as instala em `~/.claude/skills/`.

| Skill | Quando é ativada |
|-------|-----------------|
| `frontend-design` | Ao construir ou reformular interfaces — orienta escolhas de paleta, tipografia e layout para resultados distintivos, não genéricos |
| `grill-me` | Ao rodar `/grilling` — conduz uma sessão de perguntas implacáveis para afiar um plano ou design antes de implementar |
| `mcp-builder` | Ao criar servidores MCP (Model Context Protocol) em TypeScript ou Python — cobre design de ferramentas, transporte, testes e avaliações |
| `supabase-postgres-best-practices` | Ao escrever, revisar ou otimizar queries SQL, schemas ou configurações Postgres/Supabase |

Para adicionar uma nova skill: crie `skills/<nome>/SKILL.md` e rode `bash install.sh`.

---

## Hooks

Dois hooks executam automaticamente após a instalação:

- **Pre-tool-use** — Avisa quando o Claude está prestes a rodar um comando Bash destrutivo (`rm -rf`, `DROP TABLE`, `git reset --hard`, etc.)
- **Post-tool-use** — Registra cada chamada de ferramenta em `~/.claude/gg-audit.log` para rastreabilidade

---

## Convenções de Stack

- **TypeScript** (modo strict, sem `any`)
- **React + Next.js** (App Router, somente named exports, `next/image`, `next/link`)
- **Node.js 20+**
- **Testes**: Jest (unitário) · Playwright (e2e)
- **Commits**: Conventional Commits (`feat(scope): mensagem`)
- **Branches**: `feat/descricao` · `fix/descricao` · `chore/descricao`

---

## Contribuindo

1. Adicione comandos em `commands/` como arquivos `.md` com frontmatter YAML
2. Adicione skills em `skills/<nome>/SKILL.md`
3. Atualize o `README.md` e rode `bash install.sh` para testar localmente
4. Abra um PR — use `/gg:ship` para criá-lo
