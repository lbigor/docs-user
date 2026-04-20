# Onboarding — entrevista de 6 blocos

Executar **apenas** quando `docs/MANIFESTO.yml` não existir no projeto. Gera o manifesto a partir de auto-extração do código + perguntas ao usuário.

---

## Fase A — Auto-extração (silenciosa)

Antes de perguntar qualquer coisa, rodar estas leituras e montar o rascunho do manifesto:

1. **Package raiz** → ler `src/` e inferir `br.com.lbi.<modulo>` do primeiro `.java` encontrado.
2. **Entidades customizadas** → parsear `src/**/dd/*.xml` (tags `<entity name="...">`).
3. **Campos + tipos + PKs** → parsear `src/**/datadictionary/metadata.xml` e descriptors individuais.
4. **DDL real** → ler `sql/*.sql`, extrair `CREATE TABLE` e colunas.
5. **Listeners** → `grep -r "implements EventoProgramavelJava" src/`.
6. **Actions** → `grep -r "implements AcaoRotinaJava" src/`.
7. **Mensagens hardcoded** → `grep -r "throw new Exception(\"" src/` e `grep -r "MensagemException" src/`.
8. **Validações internas das actions** → nos arquivos das actions, achar `if (... == null)` + próximo `throw`.
9. **Tabelas nativas tocadas** → `grep -rE "TGF[A-Z]+|TSI[A-Z]+" src/`.

Mostrar ao usuário um resumo enxuto do que foi detectado:

```
Detectei automaticamente:
  • Módulo: br.com.lbi.<nome>
  • 2 entidades: AD_XXX, AD_YYY
  • 3 actions: AcaoA, AcaoB, AcaoC
  • 2 listeners em: CabecalhoNota, Financeiro
  • 4 mensagens de erro hardcoded
  • DDL em sql/criar-tabelas.sql

Faltam N dados que só você sabe. Vou perguntar em 6 blocos curtos.
```

---

## Fase B — 6 blocos de perguntas

Fazer **um bloco por vez**. Esperar resposta antes de ir para o próximo. Se o usuário mandar `pular`, marcar o campo como `TODO:` no manifesto e seguir.

### Bloco 1/6 — Identidade do módulo

```
→ Nome público (aparece no título do manual, em português):
→ Descrição em 1 frase (subtítulo, o problema de negócio):
```

Exemplo de resposta esperada:
> Nome: Bloqueio de Lançamentos por Período
> Descrição: Impede edição de notas e financeiros em períodos fiscais fechados

### Bloco 2/6 — Rótulos visíveis na tela

Pré-preencher com as actions detectadas:

```
Para cada action encontrada, qual o rótulo do botão?
(responda "padrão" se quiser que eu infira do nome da classe)

  AcaoAtivarBloqueio      → ?
  AcaoDesativarBloqueio   → ?
  AcaoLiberarLancamento   → ?

Para cada entidade customizada, qual o caminho de menu?

  BloqueioLancamentoCfg   → ?
  LiberacaoLancamento     → ?
```

### Bloco 3/6 — Perfis de usuário

```
Quem usa este módulo? Liste 2-4 perfis, formato:
  perfil | o que faz

Exemplo:
  Administrador fiscal | cria regras, ativa/desativa, libera
  Faturamento | só sente o efeito — é barrado quando tenta alterar
  Auditor | consulta liberações para auditoria
```

### Bloco 4/6 — Cenários de negócio

```
Liste 2-4 cenários reais do dia a dia. Para cada:
  - Título em 1 linha
  - Gatilho (o que aciona esse cenário)
  - 3-5 passos

Exemplo:
  Título: Fechamento fiscal mensal
  Gatilho: Dia 5 do mês, contador fecha SPED
  Passos:
    1. Admin cria regra com datas do mês anterior
    2. Ativa o bloqueio
    3. Faturamento tenta mexer em nota antiga, é barrado
    4. Se precisar mesmo, supervisor libera a nota específica
```

### Bloco 5/6 — Suporte

```
→ Responsável técnico (nome e e-mail):
→ Canal Slack (se houver):
→ Onde ficam os logs de erro (arquivo, Slack, Sentry etc.):
```

### Bloco 6/6 — Extras (opcionais)

```
→ O módulo tem alguma limitação conhecida? (o que ele NÃO faz)
→ Alguma pergunta já foi feita por usuário real sobre este módulo?
  (se não houver, responder "nenhuma" — §10 da doc vira "Não se aplica")
→ Há regra/convenção específica deste cliente que a doc deve mencionar?
```

---

## Fase C — Gerar `docs/MANIFESTO.yml`

Consolidar Fase A + B no formato do `manifesto-schema.yml`. Gravar em `docs/MANIFESTO.yml`.

Reportar ao usuário:

```
✓ Criado docs/MANIFESTO.yml (N linhas)
✓ M campos marcados TODO: — revisar quando tiver tempo

Posso gerar <nome do doc> agora? (s/n)
```

Se sim, seguir Passo 2 do `SKILL.md`.

---

## Diff mode (manifesto já existe)

Quando `docs/MANIFESTO.yml` já existe, **não** rodar onboarding. Rodar auto-extração (Fase A) e comparar:

```
Diferenças desde a última sync do manifesto:
  + action nova: AcaoEstornar (em src/.../actions/AcaoEstornar.java)
  + campo novo: OBSERVACAO em AD_FECHCONT (VARCHAR 500)
  - action removida: AcaoPlaceholder
  ~ mensagem alterada em AcaoLiberar.java

Posso atualizar o manifesto? Pra cada item novo acima, preciso:
```

Fazer **apenas** as perguntas necessárias para completar o manifesto — não re-perguntar o que já estava preenchido.

Se diff vazio, reportar `✓ Manifesto em dia.` e seguir direto para render.
