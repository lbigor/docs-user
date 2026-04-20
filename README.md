# docs-user

> Skill para o Claude Code que gera e mantém documentação padronizada de projetos **Sankhya ERP** — com rastreio automático no GitHub.

---

## 🎁 Trial grátis de 14 dias

Toda nova instalação ganha **14 dias de acesso full (tier comercial)** automaticamente.

Basta rodar o instalador — nenhuma chave, nenhum cartão de crédito.

Após o trial, a skill continua funcionando em **modo domiciliar gratuito** (com aviso nos docs gerados). Para uso empresarial contínuo, contrate o plano por **R$ 10/mês por usuário**.

---

## ⚠ Aviso de uso

| Cenário | Custo |
|---|---|
| Uso pessoal / estudo | **Grátis** |
| Primeiros 14 dias (qualquer uso) | **Grátis** (trial) |
| Uso empresarial após trial | **R$ 10/mês por usuário ativo** |

Consulte a [LICENSE.md](./LICENSE.md) para termos completos.

| Canal comercial | Contato |
|---|---|
| WhatsApp | **(27) 99850-1498** |
| E-mail | **lbigor@icloud.com** |

---

## O que ela faz

Num projeto Sankhya Java, `/docs-user <tipo>` gera:

| Tipo | Arquivo gerado |
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
  ├─ [0] Valida licença + garante Git/GitHub configurado
  ├─ [1] Se working tree sujo: pede 1 frase, cria PR de código
  ├─ [2] Lê/cria docs/MANIFESTO.yml (entrevista na 1ª vez)
  ├─ [3] Renderiza o .md a partir do manifesto
  └─ [4] Abre PR de documentação
```

Na **primeira execução** em um projeto, a skill faz uma entrevista curta (6 blocos) e grava `docs/MANIFESTO.yml`. Nas execuções seguintes, lê o manifesto e regenera o `.md` automaticamente.

Qualquer alteração manual no código é detectada e vira PR rastreado — nada sobe pro GitHub sem histórico.

---

## Empresas com acesso pleno

As seguintes empresas têm licença comercial liberada em regime de parceria:

- **CPAPS**
- **Litoral**
- **Fotus**
- **Fabmed**

> **Sua empresa também quer documentação Sankhya padronizada e rastreada?**
> Fale com a IBL TEC: **(27) 99850-1498** no WhatsApp.
> Primeira conversa é grátis e dura 15 minutos.

### [Clique aqui para mais informações](#) *em breve*

---

## Empresas que usam a ferramenta

*Em breve — lista dos clientes comerciais ativos.*

Quer aparecer aqui? Contrate o plano empresarial e compartilhe seu case.

---

## Instalação

### Pré-requisitos

| Ferramenta | Versão mín. | Para quê |
|---|---|---|
| [Claude Code CLI](https://claude.com/claude-code) | qualquer | rodar a skill |
| [GitHub CLI (`gh`)](https://cli.github.com) | ≥ 2.40 | abrir PRs automaticamente |
| Git | ≥ 2.30 | rastreio local |
| [Pandoc](https://pandoc.org) | ≥ 3.1 | gerar PDF das docs (opcional) |
| [Typst](https://typst.app) | ≥ 0.12 | engine do PDF (opcional) |

### Instalar a skill (1 linha)

```bash
curl -fsSL https://raw.githubusercontent.com/lbigor/docs-user/main/install.sh | bash
```

O instalador:

1. Valida pré-requisitos
2. Clona a skill em `~/.claude/skills/docs-user`
3. **Ativa o trial de 14 dias automaticamente**
4. Mostra como usar

### Instalação manual (alternativa)

```bash
mkdir -p ~/.claude/skills
cd ~/.claude/skills
git clone https://github.com/lbigor/docs-user.git
chmod +x docs-user/scripts/*.sh docs-user/install.sh
docs-user/install.sh   # ativa o trial
```

Na primeira execução em qualquer projeto, a skill valida a chave de licença e, se for a primeira vez naquele PC, guia o setup do `gh auth login`.

---

## Documentação desta skill

Disponível em dois formatos — **mesmo conteúdo, mesma versão**:

| Formato | Arquivo | Como obter |
|---|---|---|
| Texto (legível no terminal) | [`docs/MANUAL_SKILL.md`](./docs/MANUAL_SKILL.md) | `cat docs/MANUAL_SKILL.md` |
| PDF (imprimível, idêntico em qualquer máquina) | `docs/MANUAL_SKILL.pdf` | `./scripts/gerar-pdf.sh` |

O PDF é gerado via Pandoc + Typst com template fixo — rodar em qualquer PC produz exatamente o mesmo arquivo (mesmo byte-hash, exceto timestamp).

---

## Licença

Dual — uso domiciliar grátis, uso empresarial R$ 10/mês/usuário.

Ver [LICENSE.md](./LICENSE.md) para termos completos.

© 2026 **IBL TEC**. Todos os direitos reservados.
