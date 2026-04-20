---
title: "docs-user — Manual Oficial"
subtitle: "Geração padronizada de documentação para projetos Sankhya ERP"
author: "IBL TEC"
date: "2026-04-20"
lang: pt-BR
version: "1.0.0"
---

# docs-user — Manual Oficial

> **⚠ Aviso de licença** — Esta skill é gratuita para uso domiciliar. Uso empresarial: **R$ 10/mês por usuário**.
> Contato comercial: **(27) 99850-1498** (WhatsApp) · **lbigor@icloud.com** · IBL TEC.

---

## 1. Para que serve

A `docs-user` é uma skill do Claude Code que **padroniza a documentação** de projetos de customização Sankhya ERP. Em cada projeto onde é instalada, produz:

- Manual do usuário final
- Guia técnico de arquitetura
- Documentação de classes Java
- Runbooks de incidente
- Guia de deploy
- Release notes (changelog)

Todos os documentos seguem o **mesmo padrão de 11 tópicos numerados**, o que elimina divergência entre projetos e entre desenvolvedores.

Além disso, força **rastreio no GitHub**: nenhum código ou documento sai do PC do desenvolvedor sem virar Pull Request com histórico auditável.

---

## 2. Quem usa / Quem mantém

| Perfil | O que faz |
|---|---|
| **Desenvolvedor Sankhya** | Roda `/docs-user <tipo>` no final de cada entrega. Responde 6 blocos de perguntas na 1ª vez em cada projeto. |
| **Líder técnico / arquiteto** | Revisa os PRs de documentação, garante que o manifesto reflete o produto. |
| **Usuário final (cliente)** | Lê o manual gerado para operar o módulo no Sankhya W. |
| **Auditor / contador** | Consulta runbooks e release notes para fins de compliance. |
| **IBL TEC (mantenedora)** | Evolui o template, valida chaves comerciais, presta suporte. |

---

## 3. Conceitos-chave

| Termo | Significado |
|---|---|
| **Manifesto** | Arquivo `docs/MANIFESTO.yml` do projeto. Fonte única da verdade: nome do módulo, perfis, telas, botões, campos, cenários, FAQ. Todo doc é gerado a partir dele. |
| **11 tópicos** | Estrutura fixa de toda doc: 1-Para que serve, 2-Quem usa, 3-Conceitos, 4-Como funciona, 5-Campos/API, 6-Exemplo, 7-Limitações, 8-Troubleshooting, 9-Cenários, 10-FAQ, 11-Suporte. |
| **Guardião Git** | Passo obrigatório antes de qualquer geração: garante que código e docs estão rastreados no GitHub. Detecta alterações manuais e cria PR com resumo fornecido pelo usuário. |
| **Fingerprint** | Identificador único da instalação: `e-mail do git + hostname da máquina`. Usado para telemetria e validação de licença. |
| **Chave de licença** | Token emitido pela IBL TEC para uso empresarial. Armazenada em `~/.claude/skills/docs-user/.license` com cache de 7 dias. |
| **Onboarding** | Entrevista em 6 blocos rodada apenas na 1ª vez em cada projeto. Gera o manifesto. |

---

## 4. Como funciona

### Fluxo de 4 passos

```
/docs-user <tipo>
  │
  ├─ [0] Guardião de licença + Git
  │     ├─ Valida chave via API IBL TEC (cache 7 dias)
  │     ├─ Checa gh + git + remote GitHub
  │     └─ Se working tree sujo: pede resumo, cria PR de código
  │
  ├─ [1] Sync do manifesto
  │     ├─ Se não existe: entrevista de 6 blocos → grava YAML
  │     └─ Se existe: diff código vs manifesto → pergunta só o novo
  │
  ├─ [2] Render do .md
  │     ├─ Lê manifesto + template dos 11 tópicos
  │     └─ Aplica regras de estilo (acentuação, códigos, callouts)
  │
  └─ [3] Commit + PR
        └─ Branch docs/<slug> → commits separados → PR no GitHub
```

### Tipos de documento

| Tipo | Comando | Saída |
|---|---|---|
| Manual do usuário | `/docs-user manual` | `docs/MANUAL_USUARIO.md` |
| Guia técnico | `/docs-user tecnico` | `docs/GUIA_TECNICO.md` |
| Doc de classe | `/docs-user classe <Nome>` | `docs/classes/<Nome>.md` |
| Runbook | `/docs-user runbook <tema>` | `docs/RUNBOOK_<tema>.md` |
| Guia de deploy | `/docs-user deploy` | `docs/DEPLOY.md` |
| Changelog | `/docs-user changelog` | `CHANGELOG.md` |

---

## 5. Campos / Parâmetros / API

### Comando CLI

```
/docs-user <tipo> [alvo] [--sem-git]
```

| Parâmetro | Tipo | Obrigatório | Significado |
|---|---|---|---|
| `<tipo>` | string | Sim | Um dos 6 tipos acima |
| `[alvo]` | string | Só para `classe` e `runbook` | Nome da classe ou tema do runbook |
| `--sem-git` | flag | Não | Escape raro. Roda sem rastreio no GitHub. Apenas para offline/POC. |

### Arquivos da skill (globais ao PC)

Localização: `~/.claude/skills/docs-user/`

| Arquivo | Função |
|---|---|
| `SKILL.md` | Orquestrador — fluxo de alto nível |
| `onboarding.md` | Roteiro da entrevista inicial (6 blocos) |
| `template.md` | Esqueleto dos 11 tópicos |
| `manifesto-schema.yml` | Contrato do `docs/MANIFESTO.yml` |
| `git-setup.md` | Checklist de setup Git/GitHub (1ª vez) |
| `git-flow.md` | Convenções de branch, commit, PR |
| `scripts/gerar-pdf.sh` | Gera PDF determinístico deste manual |
| `template-pdf/template.typ` | Template Typst para PDF consistente |
| `LICENSE.md` | Termos de licença dual (domiciliar/empresarial) |
| `.license` | Chave de licença instalada (criada na 1ª execução) |

### Arquivo por projeto

Localização: `<projeto>/docs/MANIFESTO.yml`

Seções obrigatórias: `modulo`, `perfis`, `telas`, `efeitos`, `mensagens`, `cenarios`, `limitacoes`, `suporte`. Ver `manifesto-schema.yml` na skill para o contrato completo.

---

## 6. Exemplo concreto

### Primeira execução em projeto novo

```bash
$ cd ~/Sankhya/snk-novo-modulo
$ claude
> /docs-user manual

✓ Licença validada: HOME-9f3a (uso domiciliar)
✓ Setup Git/GitHub OK
⚠ Working tree limpo

Detectei automaticamente:
  • Módulo: br.com.lbi.novomodulo
  • 2 entidades: AD_XXX, AD_YYY
  • 3 actions
  • 1 listener

Primeira vez neste projeto. Vou perguntar em 6 blocos.

[BLOCO 1/6] Identidade do módulo
→ Nome público: Gerenciador de Ordens Especiais
→ Descrição: Controla ordens de produção com prioridade alta...

...

✓ docs/MANIFESTO.yml criado (178 linhas)
✓ docs/MANUAL_USUARIO.md gerado (11 seções)
✓ PR aberto: https://github.com/cliente/snk-novo-modulo/pull/12
```

### Regeneração após feature nova

```bash
> /docs-user manual

✓ Licença validada (cache local)
⚠ Working tree sujo:
  M  src/br/com/lbi/novomodulo/actions/AcaoCancelar.java
  A  sql/migracao-v3.sql

Em 1 frase, o que foi essa mudança?
> adicionei cancelamento de ordem com estorno automático

✓ Branch feat/adicionei-cancelamento-de-ordem criada
✓ Commit: "feat: adicionei cancelamento de ordem com estorno automático"

Manifesto desatualizado: detectei action nova AcaoCancelar.
→ Qual o rótulo do botão na tela para AcaoCancelar?
> Cancelar Ordem

✓ MANIFESTO.yml atualizado
✓ MANUAL_USUARIO.md regenerado
✓ PR aberto: https://github.com/cliente/snk-novo-modulo/pull/18
```

---

## 7. O que NÃO faz / Limitações

- **Não gera CLAUDE.md nem README.md genérico** — a skill só produz os 6 tipos padronizados.
- **Não faz merge automático de PR** — sempre deixa aberto para revisão humana.
- **Não rastreia projetos fora do GitHub** (GitLab, Bitbucket, Azure DevOps) — planejado para v2.
- **Não detecta mudanças feitas fora do diretório `src/`, `sql/`, `dd/`, `datadictionary/`, `docs/`** — essas contam como `chore: ambiente local`.
- **Não suporta projetos em outras linguagens** além de Java Sankhya.
- **Não substitui documentação manual profunda** em casos excepcionais — é um piso comum, não teto.
- **Não funciona offline por mais de 7 dias** — cache de licença expira e exige reconexão com servidor IBL TEC.

---

## 8. Mensagens de erro / Troubleshooting

| Mensagem | Causa | Como resolver |
|---|---|---|
| `Chave inválida. Contate IBL TEC...` | Licença expirada, revogada ou nunca ativada | WhatsApp (27) 99850-1498 para regularizar |
| `gh não instalado` | GitHub CLI ausente no PC | `brew install gh` (Mac) ou equivalente |
| `gh não autenticado` | Token do GitHub não configurado | `gh auth login` |
| `Este projeto ainda não é repositório Git` | Falta `git init` | Skill oferece inicializar — responder `s` |
| `Você tem mudanças sem rastreio` | Working tree sujo com arquivos rastreados | Responder com 1 frase descrevendo o que foi feito |
| `Não consigo inferir o tipo (feat/fix/chore)` | Frase do usuário ambígua | Responder com a palavra do tipo |
| `Manifesto corrompido` | YAML inválido após edição manual | Restaurar backup em `docs/MANIFESTO.yml.bak` |
| `Cache de licença expirado e sem rede` | Offline há mais de 7 dias | Conectar à internet e rodar `/docs-user <tipo>` uma vez |

---

## 9. Cenários completos

### Cenário A — Empresa nova contrata o plano

1. Empresa paga primeira mensalidade via Pix na conta IBL TEC.
2. IBL TEC gera chave: `ACME-2026-05` com expiração em 30 dias.
3. Chave enviada via WhatsApp.
4. Dev da empresa roda `echo "ACME-2026-05" > ~/.claude/skills/docs-user/.license`.
5. Próximo `/docs-user <tipo>` valida a chave contra servidor, libera uso e registra fingerprint.
6. Mensalmente, IBL TEC consulta dashboard para cobrar renovação.

### Cenário B — Onboarding em projeto legado

1. Projeto antigo tem `src/` completo, `sql/` com DDL, sem documentação.
2. Dev roda `/docs-user manual`.
3. Skill roda auto-extração: lê descriptors, actions, listeners, DDL.
4. Faz 6 blocos de perguntas ao dev (~10 minutos).
5. Grava `docs/MANIFESTO.yml` e `docs/MANUAL_USUARIO.md`.
6. Abre PR. Líder técnico revisa, sugere ajustes no manifesto.
7. Dev corrige o YAML, roda `/docs-user manual` de novo — regenera alinhado.
8. Merge.

### Cenário C — Auditoria de uso não licenciado

1. IBL TEC percebe PRs com footer `docs-user v1.0 • Lic. <fingerprint desconhecido>` em repositório público de empresa não licenciada.
2. Cruza fingerprint com base de licenças ativas → não encontra.
3. Contata empresa via WhatsApp solicitando regularização.
4. Empresa tem 15 dias para assinar plano ou parar de usar.
5. Se persistir uso sem licença: cobrança retroativa conforme LICENSE §3.

---

## 10. Perguntas frequentes

**Funciona para projetos que não são Sankhya?**
Não. O template dos 11 tópicos e o onboarding assumem conceitos Sankhya (entidades `AD_*`, listeners JAPE, descriptors DWF). Para outros ERPs ou linguagens, abrir solicitação via WhatsApp.

**Posso editar o `.md` gerado direto?**
Pode, mas **perde a idempotência**. Próxima regeneração sobrescreve. O correto é editar `docs/MANIFESTO.yml` e regenerar.

**E se meu projeto está em repositório privado?**
Funciona igual — PRs são abertos no mesmo repositório. A única diferença: auditoria externa de PRs só enxerga repos públicos, então uso indevido em repo privado é confiado na honra da licença.

**Preciso de internet sempre?**
Não. Cache de licença dura 7 dias. Depois disso, exige 1 ping ao servidor IBL TEC para revalidar.

**A skill envia código-fonte para a IBL TEC?**
Não. O servidor de validação recebe apenas: chave de licença, fingerprint (e-mail do git + hostname), timestamp e tipo de comando. Nenhum conteúdo de código, doc ou configuração é transmitido.

**Qual o limite de usuários por empresa?**
Não há limite fixo — cobrança é por usuário ativo no mês. Empresa com 50 desenvolvedores paga R$ 500/mês se todos usarem; paga R$ 100/mês se apenas 10 usarem no período.

**Como cancelar o plano?**
WhatsApp (27) 99850-1498. Cancelamento tem efeito no fim do ciclo vigente.

**Existe versão gratuita para startups?**
Atualmente não. Consulte a IBL TEC para condições especiais de acordo com a realidade da empresa.

---

## 11. Suporte / Referências

### Contato comercial e técnico

| Canal | Contato |
|---|---|
| WhatsApp | **(27) 99850-1498** |
| E-mail | **lbigor@icloud.com** |
| Razão social | **IBL TEC** |

### Referências internas

- [`../SKILL.md`](../SKILL.md) — instruções que o Claude executa
- [`../onboarding.md`](../onboarding.md) — roteiro da entrevista de 6 blocos
- [`../template.md`](../template.md) — esqueleto dos 11 tópicos
- [`../manifesto-schema.yml`](../manifesto-schema.yml) — contrato do manifesto
- [`../git-setup.md`](../git-setup.md) — setup Git/GitHub
- [`../git-flow.md`](../git-flow.md) — convenções de branch/commit/PR
- [`../LICENSE.md`](../LICENSE.md) — termos de licença

### Metadados

- **Versão da skill:** 1.0.0
- **Versão deste manual:** 1.0.0
- **Última atualização:** 2026-04-20
- **Responsável:** Igor (IBL TEC)

---

© 2026 **IBL TEC**. Todos os direitos reservados. Distribuído sob licença dual — ver `LICENSE.md`.
