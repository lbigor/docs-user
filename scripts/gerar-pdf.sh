#!/usr/bin/env bash
# gerar-pdf.sh — Gera PDF determinístico do manual da skill docs-user
# © 2026 IBL TEC · Licença dual (ver LICENSE.md)
#
# Uso:
#   ./scripts/gerar-pdf.sh [caminho_md] [caminho_pdf]
#
# Padrão: docs/MANUAL_SKILL.md → docs/MANUAL_SKILL.pdf
#
# Determinístico: mesmo .md produzido pelo mesmo pandoc+typst gera o mesmo PDF
# byte-a-byte (exceto metadata de timestamp PDF, que é fixada via SOURCE_DATE_EPOCH).

set -euo pipefail

# ─────────────────────────────────────────────────────────────
# Caminhos (relativos à raiz da skill)
# ─────────────────────────────────────────────────────────────
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INPUT="${1:-$SKILL_DIR/docs/MANUAL_SKILL.md}"
OUTPUT="${2:-$SKILL_DIR/docs/MANUAL_SKILL.pdf}"

# ─────────────────────────────────────────────────────────────
# Verificar pré-requisitos
# ─────────────────────────────────────────────────────────────
missing=()
command -v pandoc >/dev/null 2>&1 || missing+=("pandoc")
command -v typst >/dev/null 2>&1 || missing+=("typst")

if [ ${#missing[@]} -gt 0 ]; then
  echo "❌ Faltam ferramentas: ${missing[*]}"
  echo ""
  echo "Instalar no Mac:"
  echo "  brew install pandoc typst"
  echo ""
  echo "Instalar no Linux (Debian/Ubuntu):"
  echo "  sudo apt install pandoc"
  echo "  curl -fsSL https://typst.app/install.sh | sh"
  echo ""
  echo "Instalar no Windows:"
  echo "  winget install JohnMacFarlane.Pandoc Typst.Typst"
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo "❌ Arquivo de entrada não encontrado: $INPUT"
  exit 1
fi

# ─────────────────────────────────────────────────────────────
# Determinismo: fixar timestamp e locale
# ─────────────────────────────────────────────────────────────
# SOURCE_DATE_EPOCH = 2026-04-20 00:00:00 UTC (fixo)
export SOURCE_DATE_EPOCH=1776470400
export LC_ALL=C
export TZ=UTC

# ─────────────────────────────────────────────────────────────
# Gerar PDF via pandoc → typst
# ─────────────────────────────────────────────────────────────
echo "▶ Gerando PDF determinístico..."
echo "   Input:    $INPUT"
echo "   Output:   $OUTPUT"
echo "   Template: $SKILL_DIR/template-pdf/template.typ"
echo ""

pandoc "$INPUT" \
  --from markdown \
  --to pdf \
  --pdf-engine=typst \
  --output "$OUTPUT" \
  --metadata lang=pt-BR \
  --variable fontsize=10pt \
  --variable papersize=a4 \
  --variable mainfont="Helvetica Neue" \
  --variable monofont="Menlo" \
  --table-of-contents \
  --toc-depth=2 \
  --number-sections=false

# ─────────────────────────────────────────────────────────────
# Gerar hash SHA-256 para auditoria de integridade
# ─────────────────────────────────────────────────────────────
if [ -f "$OUTPUT" ]; then
  HASH=$(shasum -a 256 "$OUTPUT" | cut -d' ' -f1)
  SIZE=$(wc -c < "$OUTPUT" | tr -d ' ')
  echo ""
  echo "✓ PDF gerado com sucesso"
  echo "   Tamanho:  $SIZE bytes"
  echo "   SHA-256:  $HASH"
  echo ""
  echo "Se o hash for diferente em outra máquina, o conteúdo ou as fontes divergem."
  echo "Fontes instaladas devem ser: Helvetica Neue + Menlo (Mac padrão) ou"
  echo "equivalentes fallback (Helvetica/Arial + Consolas/DejaVu Sans Mono)."
else
  echo "❌ Falha ao gerar PDF"
  exit 1
fi
