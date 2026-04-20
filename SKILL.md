---
name: docs-user
description: Gera e mantém documentação de projetos Sankhya com rastreio Git/GitHub obrigatório. Toda execução garante que código e docs acabem em PR no GitHub — código sem PR é detectado e o usuário fornece um resumo curto antes de subir. Dispara quando o usuário pedir para criar/atualizar manual do usuário, guia técnico, doc de classe, runbook, guia de deploy ou release notes em projeto Sankhya Java. Exemplos de gatilho: "gera o manual", "documenta essa classe", "cria runbook para X", "escreve o guia técnico", "release notes", "atualiza a doc". Também invocável via /docs-user <tipo> [alvo]. Tipos: manual, tecnico, classe, runbook, deploy, changelog. Garante mesmo estilo, mesma ordem de 11 tópicos numerados e histórico auditável em toda doc entregue.
---

> **© 2026 IBL TEC · Licença dual** — uso domiciliar grátis, uso empresarial **R$ 10/mês por usuário**.
> Contato: **(27) 99850-1498** (WhatsApp) · lbigor@icloud.com · ver `LICENSE.md`.

## Quando usar

- Usuário pede para **criar** ou **atualizar** qualquer doc em `docs/` de um projeto Sankhya.
- Usuário pede para **revisar** doc existente quanto à conformidade com o padrão.
- Usuário digita `/docs-user [tipo] [alvo]` explicitamente.

Tipos suportados: `manual`, `tecnico`, `classe`, `runbook`, `deploy`, `changelog`.

Saída por tipo:

| Tipo | Arquivo |
|---|---|
| `manual` | `docs/MANUAL_USUARIO.md` |
| `tecnico` | `docs/GUIA_TECNICO.md` |
| `classe` | `docs/classes/<NomeDaClasse>.md` |
| `runbook` | `docs/RUNBOOK_<tema>.md` |
| `deploy` | `docs/DEPLOY.md` |
| `changelog` | `CHANGELOG.md` (raiz) |

## Regra de ouro

**Sempre os mesmos 11 tópicos, sempre na mesma ordem, sempre numerados.** Se um tópico não se aplica, NÃO omitir — escrever `> Não se aplica.` no corpo. Pular número quebra referência cruzada.

Os 11 tópicos (preencher nesta ordem):

1. Para que serve
2. Quem usa / Quem mantém
3. Conceitos-chave
4. Como funciona / Fluxo
5. Campos / Parâmetros / API
6. Exemplo concreto
7. O que NÃO faz / Limitações
8. Mensagens de erro / Troubleshooting
9. Cenários completos
10. Perguntas frequentes
11. Suporte / Referências

> Exceção documentada: se o projeto já tiver `docs/MANUAL_USUARIO.md` com rótulos customizados nas seções 3–7 (ex.: *"Cadastro de uma regra de bloqueio"*, *"O que é efetivamente bloqueado"*), **preservar esses rótulos** ao regenerar. Numeração e conteúdo semântico das seções 1, 2, 8–11 são inegociáveis.

## Fluxo de alto nível

```
/docs-user <tipo>
  │
  ├─ [0] Guardião Git/GitHub  → ver git-setup.md + git-flow.md
  ├─ [1] Sync do manifesto     → ver onboarding.md
  ├─ [2] Render do doc
  └─ [3] Commit + PR           → ver git-flow.md
```

Cada passo é obrigatório e executa nesta ordem. Nenhum pode ser pulado, exceto com `--sem-git` (escape raro, documentado em `git-flow.md`).

---

## Passo -1 — Validação de licença (obrigatório)

Antes de qualquer ação, verificar chave de licença. Sem chave válida, abortar.

### Tiers suportados

| Tier | Duração | O que libera | Marca nos docs |
|---|---|---|---|
| `trial` | 14 dias a partir da instalação | Acesso full (igual commercial) | `Gerado durante trial (faltam N dias)` |
| `commercial` | Enquanto paga (verificado mensalmente) | Acesso full, sem aviso promocional | Só `Gerado com docs-user v1.0` |
| `domestic` | Permanente | Acesso full com aviso promocional em cada doc | `Gerado com versão doméstica. Uso empresarial: R$ 10/mês/usuário.` |

### Fluxo

1. **Ler chave local** em `~/.claude/skills/docs-user/.license` (formato `key=...`, `tier=...`, `trial_start=...`, `trial_days=...`, `fingerprint=...`).
   - Se arquivo não existir: rodar `install.sh` ou criar chave TRIAL manualmente com `tier=trial`, `trial_start=<hoje>`, `trial_days=14`.
2. **Se `tier=trial`:** calcular dias decorridos desde `trial_start`.
   - Se `<= 14` dias: prosseguir como commercial. No footer de PR adicionar: `Trial: faltam <N> dias`.
   - Se `> 14` dias: rebaixar automaticamente para `tier=domestic` (atualizar o arquivo `.license`). Avisar o usuário na tela:
     ```
     🎁 Seu trial de 14 dias terminou. A skill continua funcionando em modo doméstico (grátis).
     Uso empresarial: R$ 10/mês/usuário — (27) 99850-1498 (WhatsApp) · lbigor@icloud.com
     ```
3. **Se `tier=commercial`:** tentar validar chave no servidor (passo 4 abaixo). Fallback: usar cache se disponível.
4. **Se `tier=domestic`:** prosseguir direto — não precisa validar chave (é grátis). Footer dos docs gerados **deve** conter aviso promocional.
2. **Ler cache** em `~/.claude/skills/docs-user/.license-cache` (JSON: `{key, valid, tier, expira, validado_em}`).
   - Se `validado_em` ≤ 7 dias: cache válido, prosseguir com `tier` cacheado.
3. **Se cache expirado ou inexistente:** validar contra servidor IBL TEC.
   - Endpoint: `https://docs-user.ibltec.workers.dev/validate` (em breve — usar MOCK por enquanto)
   - MOCK: responder sempre `{"valid": true, "tier": "domestic"}` até o Worker estar no ar.
   - Em produção: `curl -s -H "X-Key: $KEY" -H "X-Fingerprint: $(git config user.email)@$(hostname)" <URL>`
4. **Se `valid=false`:** abortar com mensagem:
   ```
   ❌ Licença inválida ou expirada.
   Contate IBL TEC: (27) 99850-1498 (WhatsApp) · lbigor@icloud.com
   ```
5. **Se `valid=true`:** atualizar cache, prosseguir. Adicionar ao contexto global desta execução:
   - `license.tier` (`domestic` ou `commercial`)
   - `license.empresa` (se commercial)
   - `license.fingerprint` (usado no footer do PR)

**Fingerprint format:** `<email>@<hostname>` — ex.: `lbigor@icloud.com@igors-mac.local`. Usado tanto na validação quanto no footer de cada PR gerado.

**Modo offline:** se `curl` falhar (sem rede) e houver cache de qualquer idade, usar cache com aviso: `⚠ Validando em modo offline. Conecte-se ao menos a cada 7 dias.`. Após 7 dias sem conexão, abortar.

---

## Passo 0 — Guardião Git/GitHub

**Objetivo:** nenhum doc é gerado sem que o estado do repo esteja rastreado no GitHub.

1. **Checar pré-requisitos do PC** (apenas na 1ª vez — cacheado depois):
   - `gh --version` instalado
   - `gh auth status` autenticado
   - projeto é repo git (se não: `git init`)
   - tem remote GitHub (se não: `gh repo create`)

   Se qualquer um faltar, seguir `git-setup.md` antes de prosseguir.

2. **Checar working tree**: `git status --porcelain`.
   - **Limpo** → seguir para Passo 1.
   - **Sujo** → rodar fluxo "mudança manual não rastreada" em `git-flow.md`:
     - Mostrar arquivos modificados (filtrar por escopo rastreado: `src/`, `sql/`, `dd/`, `datadictionary/`, `docs/`, `CLAUDE.md`).
     - Pedir 1 frase descrevendo o que foi feito.
     - Criar branch `<tipo>/<slug>`, commitar, push.
     - Commitar arquivos fora do escopo como `chore: ambiente local` em commit separado (silencioso).

3. Seguir para Passo 1 **na mesma branch** criada acima (ou nova branch `docs/<slug>` se working tree estava limpo).

Escape: se o usuário passou `--sem-git`, pular Passo 0 com aviso explícito: `⚠ Rodando sem rastreio. Essa doc não terá histórico auditável.`

---

## Passo 1 — Sync do manifesto

O `docs/MANIFESTO.yml` é a **fonte única de verdade** do conteúdo de negócio do módulo. Todo doc gerado consome ele. Ver `manifesto-schema.yml` para o contrato.

1. **Se `docs/MANIFESTO.yml` não existe:** rodar o onboarding completo descrito em `onboarding.md` — 6 blocos de perguntas, gera o YAML. Depois seguir para Passo 2.

2. **Se existe:** rodar auto-extração do código atual e comparar com o manifesto:
   - Mesma lista de actions, listeners, entidades, campos? → manifesto em dia, seguir Passo 2.
   - Diferenças? → mostrar o diff, perguntar **apenas** o que não dá pra inferir (ex.: rótulo de botão novo, cenário de uso de feature nova), atualizar o YAML, seguir Passo 2.

Auto-extração (sem perguntar):

- **Nome do módulo** → do `package` raiz
- **Entidades customizadas** → `src/**/dd/*.xml` + `datadictionary/metadata.xml`
- **Campos + PKs + FKs + tipos** → dos descriptors XML
- **DDL** → `sql/*.sql`
- **Listeners** → classes que implementam `EventoProgramavelJava`
- **Actions** → classes que implementam `AcaoRotinaJava`
- **Mensagens de erro** → grep de `throw new Exception(` e `MensagemException`
- **Tabelas nativas tocadas** → grep de `TGF*`, `TSI*` no código

**Nunca inventar** nome de tabela, campo, método, PK ou FK. Se não está no código ou no manifesto, **perguntar ao usuário** — não preencher com palpite.

---

## Passo 2 — Render do doc

Usar `template.md` como esqueleto. Preencher os 11 tópicos lendo **apenas** do manifesto + leitura complementar do código-fonte para tipo `classe`.

Referências externas opcionais (se existirem no PC):

- `~/Documents/Claude/sankhya_core.md` — verificar tabelas nativas Sankhya citadas
- `~/Documents/Claude/sankhya_api.md` — verificar métodos Java do framework JAPE/DWF

Essas referências **não são obrigatórias** para a skill funcionar em outro PC — são checagens a mais quando estão disponíveis.

### Regras de estilo inegociáveis

- **Idioma:** português no corpo; identificadores de código no original (`TGFCAB`, `DynamicVO`).
- **Acentuação:** sempre correta (`não`, `período`, `liberação`). Revisar antes de entregar.
- **Títulos:** `#` só no topo; `##` em seções numeradas; nunca pular nível.
- **Callouts:** `> ⚠` atenção, `> ℹ` dica, `> ✅` ok, `> ❌` anti-padrão. Emoji só em callout ou ícone de tabela — nunca em título ou corpo.
- **Blocos de código:** sempre com linguagem declarada (` ```java `, ` ```sql `, ` ```xml `).
- **Separadores:** `---` entre seções `##`, nunca dentro.
- **Tabelas:** cabeçalho obrigatório; chave de leitura na coluna esquerda; evitar >7 colunas.

### Checklist antes de avançar para Passo 3

- [ ] Os 11 tópicos presentes e numerados (ou marcados `Não se aplica`).
- [ ] Toda tabela nativa citada é real (cross-check com código ou `sankhya_core.md` quando disponível).
- [ ] Toda tabela customizada citada existe no DDL/descriptors do projeto.
- [ ] Nenhum campo/coluna inventado.
- [ ] Seção 6 tem pelo menos 1 exemplo concreto com valores realistas.
- [ ] Seção 7 (limitações) não está vazia.
- [ ] Seção 11 tem responsável técnico + versão (tag + commit + data) + link para `CLAUDE.md`.
- [ ] Blocos de código com linguagem declarada.

---

## Passo 3 — Commit + PR

1. **Mesma branch** do Passo 0 (se houve mudança de código) ou nova `docs/<slug>` (se só doc mudou).
2. Commitar cada artefato separadamente:
   - `docs: atualiza MANIFESTO.yml com <mudança>` (se manifesto mudou)
   - `docs: regenera <nome do doc>` (o `.md` final)
3. Push, criar PR via `gh pr create` com título curto e corpo mencionando:
   - O que foi atualizado
   - Seções do doc que mudaram
   - Se usuário marcou algo como `Não se aplica`
4. **Não fazer merge automático**. Devolver URL do PR ao usuário.

Ver `git-flow.md` para comandos exatos e convenções de mensagem.

---

## Passo 4 — Entregar e aguardar aprovação

Reportar ao usuário no chat:

1. URL do PR criado.
2. Versão registrada (tag + commit + data).
3. Caminho do arquivo gerado/atualizado.
4. Resumo de 2–3 linhas do que cobre.
5. Itens marcados `> Não se aplica.` para usuário validar.
6. Pedir aprovação explícita antes de partir para próximo doc.

---

## Observações finais

- A skill **não cria CLAUDE.md, README genérico nem doc fora do padrão**. Se o usuário pedir algo que não encaixa nos 6 tipos, perguntar antes.
- Para tipo `classe`, espelhar resumo no Javadoc do `.java` fonte — `.md` é a versão longa, Javadoc é a enxuta. Compatível com a skill `code-review`.
- Quando o projeto tiver `docs/PADRAO_DOCUMENTACAO.md` local, esse arquivo **tem precedência** sobre este template em divergências — é customização do projeto.
- Arquivos de referência desta skill (ler quando a situação exigir):
  - `template.md` — esqueleto dos 11 tópicos
  - `onboarding.md` — entrevista em 6 blocos (1ª vez no projeto)
  - `manifesto-schema.yml` — contrato do `docs/MANIFESTO.yml`
  - `git-setup.md` — setup Git/GitHub 1ª vez no PC
  - `git-flow.md` — branch naming, commit, PR, captura de mudança manual
