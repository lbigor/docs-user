#!/usr/bin/env bash
# install.sh — Instalador one-liner da skill docs-user
# MIT · 2026 · Igor Lima (ver LICENSE.md)
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/lbigor/docs-user/main/install.sh | bash
#
# O que faz:
#   1. Verifica pré-requisitos (git, Claude Code CLI)
#   2. Clona/atualiza a skill em ~/.claude/skills/docs-user
#   3. Torna scripts executáveis
#   4. Exibe instruções de uso

set -euo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
SKILL_DIR="${SKILLS_DIR}/docs-user"
REPO_URL="https://github.com/lbigor/docs-user.git"

echo ""
echo "════════════════════════════════════════════════════"
echo "  docs-user · Instalador  ·  MIT 2026 Igor Lima"
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
echo "  • Discussions: https://github.com/lbigor/docs-user/discussions"
echo "  • Consultoria opcional: (27) 99850-1498 (WhatsApp)"
echo ""
