# Git Flow — convenções de branch, commit e PR

Referência operacional do Passo 0 e Passo 3 do `SKILL.md`.

---

## Escopo rastreado

A skill distingue dois tipos de arquivo:

**Rastreado** (exige resumo do usuário antes de commitar):
- `src/**/*.java`
- `sql/**/*.sql`
- `src/**/dd/*.xml`
- `src/**/datadictionary/*.xml`
- `docs/**/*.md`
- `CLAUDE.md`
- `pom.xml`, `build.gradle`, `.classpath` (quando mudam dependências reais)

**Não-rastreado** (commit silencioso `chore: ambiente local`):
- `.idea/`, `.vscode/`, `*.iml`
- `bin/`, `out/`, `target/`
- `.DS_Store`, `Thumbs.db`
- `*.log`, `*.tmp`

---

## Capturando mudança manual (working tree sujo)

Quando `git status --porcelain` não retorna vazio e há arquivos rastreados modificados:

### 1. Mostrar ao usuário

```
⚠ Você tem mudanças sem rastreio:
  M  src/br/com/lbi/.../AcaoX.java
  A  sql/migracao-v2.sql

Antes de gerar a doc, preciso criar a task.
Em 1 frase, o que foi essa mudança?
```

### 2. Esperar 1 frase

Se o usuário mandar mais de 1 linha, usar a primeira linha como título e o resto como corpo do commit.

### 3. Inferir tipo da frase

Classificar o commit por palavra-chave na frase do usuário:

| Palavras-chave | Tipo |
|---|---|
| "adiciona", "cria", "nova", "implementa" | `feat` |
| "corrige", "arruma", "fix", "bug" | `fix` |
| "refatora", "limpa", "renomeia" | `refactor` |
| "ajusta", "melhora", "muda" | `chore` |
| "documenta", "readme", "manual" | `docs` |

Se ambíguo, perguntar: *"Isso é feat, fix ou chore?"*

### 4. Gerar slug da branch

Slug = primeiras 5 palavras da frase, minúsculas, sem acento, hífen entre palavras.

```
"ajustei validação de liberação pra aceitar múltiplas empresas"
→ feat/ajustei-validacao-de-liberacao-pra
```

Limitar a 50 caracteres no total.

### 5. Criar branch, commitar, push

```bash
git checkout -b <tipo>/<slug>
git add <arquivos-rastreados>
git commit -m "<tipo>: <frase do usuário>"
git add <arquivos-nao-rastreados>
git commit -m "chore: ambiente local"   # só se existirem
git push -u origin <tipo>/<slug>
```

Os dois commits separados preservam o histórico limpo.

### 6. Segue fluxo

Depois destes commits, a skill continua com Passo 1 (sync manifesto) e Passo 2 (render) **na mesma branch**. Os novos commits de doc entram como commits adicionais antes do PR final.

---

## Commit de documentação

Depois do Passo 2 (render), a skill gera/atualiza:
- `docs/MANIFESTO.yml` (se mudou)
- O `.md` final (`MANUAL_USUARIO.md`, `GUIA_TECNICO.md`, etc.)

Commits separados, nesta ordem:

```bash
git add docs/MANIFESTO.yml
git commit -m "docs: atualiza manifesto com <mudança curta>"

git add docs/<arquivo gerado>.md
git commit -m "docs: regenera <nome do doc>"
```

Se **só** doc mudou (working tree estava limpo no Passo 0), criar branch nova:

```bash
git checkout -b docs/<slug-do-tipo>
# ex: docs/manual-usuario, docs/guia-tecnico, docs/classe-nome
```

---

## Abertura do PR

Um PR por sessão da skill. Título curto, corpo estruturado.

```bash
gh pr create \
  --title "<tipo>: <frase curta>" \
  --body "$(cat <<'EOF'
## Resumo
<1-3 linhas>

## Mudanças
- <arquivo 1>: <o que mudou>
- <arquivo 2>: <o que mudou>

## Doc atualizada
- <caminho/do/arquivo.md>

## Pendências marcadas
- [ ] Seção N: "Não se aplica" — validar se realmente não se aplica

---
Gerado com **docs-user** (MIT · 2026 · Igor Lima) · https://github.com/lbigor/docs-user
EOF
)"
```

O footer de atribuição é cortesia — facilita rastrear qual ferramenta gerou cada doc.

**Não fazer merge automático.** Capturar a URL retornada por `gh pr create` e devolver ao usuário.

---

## Convenção de nome de branch

| Prefixo | Quando |
|---|---|
| `feat/` | Funcionalidade nova (código ou doc) |
| `fix/` | Correção de bug |
| `refactor/` | Refatoração sem mudança de comportamento |
| `chore/` | Tarefa de manutenção, sem impacto funcional |
| `docs/` | Mudança exclusivamente em `docs/` ou `CLAUDE.md` |

---

## Convenção de mensagem de commit

```
<tipo>: <descrição no imperativo, minúscula, <= 72 chars>

<corpo opcional, explicando o porquê — não o quê>
```

Exemplos válidos:

```
feat: adiciona estorno de fechamento contábil
fix: corrige data de negociação null no listener financeiro
docs: regenera manual após adicionar estorno
chore: atualiza gitignore com .idea/
```

Rodapé opcional quando o commit é assistido pela skill:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

---

## Escape `--sem-git`

Se o usuário passar `--sem-git` em qualquer invocação:

- Pular Passo 0 inteiro.
- Gerar docs localmente, sem criar branch nem PR.
- Avisar claramente no início:

```
⚠ Rodando sem rastreio. Essa doc não terá histórico auditável.
   Para rastrear, rode /docs-user <tipo> sem --sem-git.
```

**Não tratar isso como default silencioso.** A skill sempre tenta rastrear primeiro.

---

## Quando abortar sem dano

Se o usuário se recusar a instalar/configurar `gh`, ou se recusar a criar repo GitHub: **não forçar**. Retornar mensagem única:

```
Sem GitHub não tem rastreio, então não posso gerar doc rastreada agora.
Opções:
  1. Rodar o setup: /docs-user e responder os 6 checks
  2. Rodar sem rastreio: /docs-user <tipo> --sem-git
```

Não deixar o usuário em loop de perguntas.
