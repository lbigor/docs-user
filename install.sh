#!/usr/bin/env bash
# install.sh — Instalador one-liner da skill docs-user
# © 2026 IBL TEC · Licença dual (ver LICENSE.md)
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/lbigor/docs-user/main/install.sh | bash
#
# O que faz:
#   1. Verifica pré-requisitos (git, gh, claude CLI)
#   2. Clona/atualiza a skill em ~/.claude/skills/docs-user
#   3. Torna scripts executáveis
#   4. Cria chave TRIAL de 14 dias automaticamente
#   5. Exibe instruções de uso

set -euo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
SKILL_DIR="${SKILLS_DIR}/docs-user"
REPO_URL="https://github.com/lbigor/docs-user.git"
TRIAL_DAYS=14

echo ""
echo "════════════════════════════════════════════════════"
echo "  docs-user · Instalador  ·  © 2026 IBL TEC"
echo "════════════════════════════════════════════════════"
echo ""

# ── Pré-requisitos ──────────────────────────────────────
missing=()
command -v git >/dev/null 2>&1 || missing+=("git")
command -v claude >/dev/null 2>&1 || missing+=("Claude Code CLI")

if [ ${#missing[@]} -gt 0 ]; then
  echo "❌ Faltam ferramentas: ${missing[*]}"
  echo ""
  echo "Instalar:"
  echo "  git:    https://git-scm.com"
  echo "  Claude: https://claude.com/claude-code"
  exit 1
fi

echo "✓ git + Claude Code CLI detectados"

# ── Clone ou update ─────────────────────────────────────
mkdir -p "$SKILLS_DIR"

if [ -d "$SKILL_DIR/.git" ]; then
  echo "▶ Atualizando instalação existente..."
  cd "$SKILL_DIR" && git pull --ff-only origin main
else
  echo "▶ Clonando skill..."
  git clone --depth=1 "$REPO_URL" "$SKILL_DIR"
fi

# ── Permissões ──────────────────────────────────────────
chmod +x "$SKILL_DIR/scripts/"*.sh 2>/dev/null || true
chmod +x "$SKILL_DIR/install.sh" 2>/dev/null || true

# ── Chave TRIAL ─────────────────────────────────────────
LICENSE_FILE="$SKILL_DIR/.license"

if [ ! -f "$LICENSE_FILE" ]; then
  FINGERPRINT=$(git config --global user.email 2>/dev/null || echo "anon")
  FINGERPRINT="${FINGERPRINT}@$(hostname)"
  FP_HASH=$(echo "$FINGERPRINT" | shasum -a 256 | cut -c1-8)
  TRIAL_START=$(date -u +%Y-%m-%d)

  cat > "$LICENSE_FILE" <<EOF
# Chave de licença — docs-user
# NÃO compartilhar. Arquivo ignorado pelo git.
key=TRIAL-${FP_HASH}
tier=trial
trial_start=${TRIAL_START}
trial_days=${TRIAL_DAYS}
fingerprint=${FINGERPRINT}
EOF

  echo ""
  echo "🎁  Trial gratuito de ${TRIAL_DAYS} dias ativado!"
  echo "    Início: ${TRIAL_START}"
  echo "    Tier:   commercial (acesso full)"
  echo ""
  echo "    Após o trial, a skill continua funcionando em modo"
  echo "    domiciliar (grátis) com aviso nos docs gerados."
  echo ""
  echo "    Uso empresarial: R\$ 10/mês por usuário."
  echo "    Contratar: (27) 99850-1498 (WhatsApp) · lbigor@icloud.com"
fi

# ── Instalado ───────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════"
echo "  ✓ docs-user instalada em: $SKILL_DIR"
echo "════════════════════════════════════════════════════"
echo ""
echo "Uso:"
echo "  1. Entre num projeto Sankhya:  cd ~/Sankhya/<seu-projeto>"
echo "  2. Abra o Claude Code:          claude"
echo "  3. Gere documentação:           /docs-user manual"
echo ""
echo "Documentação completa:"
echo "  • $SKILL_DIR/README.md"
echo "  • $SKILL_DIR/docs/MANUAL_SKILL.md"
echo "  • $SKILL_DIR/docs/MANUAL_SKILL.pdf"
echo ""
echo "Comunidade & suporte:"
echo "  • GitHub: https://github.com/lbigor/docs-user"
echo "  • WhatsApp IBL TEC: (27) 99850-1498"
echo ""
