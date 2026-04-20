# Setup Git/GitHub — 1ª vez no PC / no projeto

Este arquivo guia a instalação e configuração mínima para a skill `docs-user` operar com rastreio. Executar na ordem. Cada check que falhar, **parar e guiar o usuário** — não seguir em frente sem o pré-requisito.

---

## Check 1 — GitHub CLI (`gh`) instalado

```bash
gh --version
```

**Se falhar:**

| SO | Comando |
|---|---|
| macOS | `brew install gh` |
| Windows | `winget install --id GitHub.cli` |
| Linux (Debian/Ubuntu) | `sudo apt install gh` |

Mostrar o comando do SO do usuário e **parar**. Pedir pra rodar e re-chamar `/docs-user`.

---

## Check 2 — GitHub CLI autenticado

```bash
gh auth status
```

**Se falhar** (retornar "not logged in"):

Instruir o usuário a rodar:

```bash
gh auth login
```

Escolher:
- GitHub.com (não GitHub Enterprise, salvo exceção)
- HTTPS
- Autenticar via browser

O `gh` abre o navegador com um código curto. Usuário cola, autoriza. Depois, a skill pode re-chamar.

**Parar** até `gh auth status` retornar sucesso.

---

## Check 3 — Projeto é repo Git

```bash
git rev-parse --is-inside-work-tree
```

**Se falhar:**

Perguntar ao usuário:
> *"Este projeto ainda não é repositório Git. Posso inicializar?* (s/n)*"*

Se sim:

```bash
git init -b main
```

Depois gerar `.gitignore` padrão Sankhya (se ainda não existir):

```gitignore
# IDE
.idea/
.vscode/
*.iml

# Build
bin/
out/
target/

# Sistema
.DS_Store
Thumbs.db

# Secrets
*.token
.env
.env.local

# Logs
*.log
```

Commit inicial:

```bash
git add -A
git commit -m "chore: inicializa projeto"
```

Se usuário disser **não**, abortar com mensagem: *"Sem Git não tem rastreio. Rode `/docs-user --sem-git` se quiser gerar doc local sem histórico."*

---

## Check 4 — Projeto tem remote GitHub

```bash
git remote -v | grep github.com
```

**Se falhar** (nenhum remote GitHub configurado):

Perguntar ao usuário:
> *"Criar repositório no GitHub? Nome sugerido: `<nome da pasta atual>`. Público ou privado?* (pub/priv/não)*"*

Se privado:

```bash
gh repo create <nome> --private --source=. --remote=origin --push
```

Se público:

```bash
gh repo create <nome> --public --source=. --remote=origin --push
```

Se usuário disser **não**, abortar como em Check 3.

---

## Check 5 — Nome e e-mail de commit configurados

```bash
git config user.name
git config user.email
```

**Se qualquer um estiver vazio:**

Perguntar ao usuário:
> *"Git não tem nome/e-mail configurados neste PC. Qual nome e e-mail usar nos commits?"*

```bash
git config --global user.name "<nome>"
git config --global user.email "<email>"
```

---

## Check 6 — Branch principal existe no remote

```bash
git ls-remote --heads origin main
```

**Se vazio:**

```bash
git push -u origin main
```

---

## Depois de todos os checks

Retornar `✓ Setup OK` e deixar o fluxo normal da skill continuar (Passo 0 → checar working tree).

---

## Cache de setup

Depois que um PC passou em todos os 6 checks uma vez, pular direto para o check de working tree (`git status --porcelain`). Só re-rodar os checks se:
- `gh` retornar erro de auth (token expirou)
- Pasta atual **não for** o repo da última invocação (novo projeto)
