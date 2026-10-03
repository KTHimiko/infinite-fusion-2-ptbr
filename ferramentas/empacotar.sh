#!/usr/bin/env bash
# Monta o .zip da release em dist/ (payload + instaladores + LEIA-ME).
set -euo pipefail
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
VERSAO="$(grep -m1 -oE '^## [0-9]+\.[0-9]+\.[0-9]+' "$RAIZ/CHANGELOG.md" | cut -d' ' -f2)"
NOME="InfiniteFusion2-PTBR-v$VERSAO"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/$NOME" "$RAIZ/dist"
cp -r "$RAIZ/payload" "$TMP/$NOME/"
cp "$RAIZ/instalador/instalar.ps1" "$RAIZ/instalador/instalar.sh" \
   "$RAIZ/instalador/Instalar (Windows).bat" "$RAIZ/instalador/Desinstalar (Windows).bat" "$TMP/$NOME/"
cp "$RAIZ/instalador/LEIA-ME.txt" "$RAIZ/AVISO.md" "$TMP/$NOME/"
chmod +x "$TMP/$NOME/instalar.sh"

rm -f "$RAIZ/dist/$NOME.zip"
(cd "$TMP" && zip -qr -X "$RAIZ/dist/$NOME.zip" "$NOME")
echo "Gerado: dist/$NOME.zip"
