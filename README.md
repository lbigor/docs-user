# docs-user

[![Discussions](https://img.shields.io/github/discussions/lbigor/docs-user)](https://github.com/lbigor/docs-user/discussions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.md)

> Skill Claude Code que gera e mantém documentação padronizada de projetos **Sankhya ERP** — com rastreio automático no GitHub.

---

## O que faz

Num projeto Sankhya Java, `/docs-user <tipo>` gera:

| Tipo | Arquivo |
|---|---|
| `manual` | `docs/MANUAL_USUARIO.md` |
| `tecnico` | `docs/GUIA_TECNICO.md` |
| `classe` | `docs/classes/<Nome>.md` |
| `runbook` | `docs/RUNBOOK_<tema>.md` |
| `deploy` | `docs/DEPLOY.md` |
| `changelog` | `CHANGELOG.md` |

Todo doc sai com os **mesmos 11 tópicos numerados** (Para que serve, Quem usa, Conceitos-chave, Como funciona, Campos/API, Exemplo, Limitações, Troubleshooting, Cenários, FAQ, Suporte). Mesmo input → mesmo output, sempre.

---

## Como funciona

```
/docs-user manual
  │
  ├─ [1] Se working tree sujo: pede 1 frase, cria PR de código
  ├─ [2] Lê/cria docs/MANIFESTO.yml (entrevista na 1ª vez)
  ├─ [3] Renderiza o .md a partir do manifesto
  └─ [4] Abre PR de documentação
```

Na **primeira execução** em um projeto, a skill faz uma entrevista curta (6 blocos) e grava `docs/MANIFESTO.yml`. Nas execuções seguintes, lê o manifesto e regenera o `.md` automaticamente.

Qualquer alteração manual no código é detectada e vira PR rastreado — nada sobe pro GitHub sem histórico.

---

## Instalação

### Pré-requisitos

| Ferramenta | Para quê |
|---|---|
| [Claude Code CLI](https://claude.com/claude-code) | rodar a skill |
| [GitHub CLI (`gh`)](https://cli.github.com) ≥ 2.40 | abrir PRs automaticamente |
| Git ≥ 2.30 | rastreio local |
| [Pandoc](https://pandoc.org) ≥ 3.1 (opcional) | gerar PDF das docs |
| [Typst](https://typst.app) ≥ 0.12 (opcional) | engine do PDF |

### 1 comando

```bash
curl -fsSL https://raw.githubusercontent.com/lbigor/docs-user/main/install.sh | bash
```

Clona a skill em `~/.claude/skills/docs-user`. Pronto.

### Instalação manual (alternativa)

```bash
git clone https://github.com/lbigor/docs-user.git ~/.claude/skills/docs-user
chmod +x ~/.claude/skills/docs-user/scripts/*.sh
```

Na primeira execução em qualquer projeto, a skill verifica `gh auth` e guia o setup se faltar.

---

## Documentação desta skill

| Formato | Arquivo | Como obter |
|---|---|---|
| Texto | [`docs/MANUAL_SKILL.md`](./docs/MANUAL_SKILL.md) | `cat docs/MANUAL_SKILL.md` |
| PDF | `docs/MANUAL_SKILL.pdf` | `./scripts/gerar-pdf.sh` |

O PDF é gerado via Pandoc + Typst com template fixo — rodar em qualquer PC produz exatamente o mesmo arquivo (mesmo byte-hash, exceto timestamp).

---

## Apoio e consultoria

- **GitHub Sponsors:** https://github.com/sponsors/lbigor
- **Consultoria paga:** (27) 99850-1498 · lbigor@icloud.com

## Licença

MIT — ver [LICENSE.md](./LICENSE.md). Use livremente em qualquer contexto (pessoal, empresarial, educacional). Contribuições via PR — apenas @lbigor aprova merge.
