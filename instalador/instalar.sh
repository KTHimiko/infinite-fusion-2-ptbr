#!/usr/bin/env bash
# Instalador da tradução PT-BR do Pokémon Infinite Fusion 2 (Hoenn) - Linux / macOS / Steam Deck
#
#   ./instalar.sh [PASTA_DO_JOGO]              instala ou atualiza a tradução
#   ./instalar.sh --desinstalar [PASTA_DO_JOGO] restaura os arquivos originais
#   --forcar                                    instala mesmo em outra versão do jogo (pode quebrar!)
set -euo pipefail

VERSAO_JOGO="6.8.2"
VERSAO_HOENN="1.2.2"
BACKUP_NOME="PTBR_BACKUPS/original-if2-ptbr"

AQUI="$(cd "$(dirname "$0")" && pwd)"
if [ -d "$AQUI/payload" ]; then PAYLOAD="$AQUI/payload"; else PAYLOAD="$AQUI/../payload"; fi

modo=instalar; forcar=0; jogo=""
for arg in "$@"; do
  case "$arg" in
    --desinstalar) modo=desinstalar ;;
    --forcar) forcar=1 ;;
    *) jogo="$arg" ;;
  esac
done

if [ -z "$jogo" ]; then
  if [ -f "$AQUI/../InfiniteFusion2.exe" ]; then
    jogo="$AQUI/.."
  else
    read -r -p "Arraste aqui a pasta do jogo (a que tem InfiniteFusion2.exe) e aperte Enter: " jogo
    jogo="${jogo%\'}"; jogo="${jogo#\'}"
  fi
fi
jogo="$(cd "$jogo" && pwd)"
settings="$jogo/Data/Scripts/001_Settings.rb"
[ -f "$settings" ] || { echo "ERRO: '$jogo' não parece ser a pasta do Infinite Fusion 2 (falta Data/Scripts/001_Settings.rb)."; exit 1; }

backup="$jogo/$BACKUP_NOME"
manifesto="$backup/manifesto.txt"

if [ "$modo" = desinstalar ]; then
  [ -f "$manifesto" ] || { echo "Nenhum backup da tradução encontrado em $backup."; exit 1; }
  n=0
  while IFS=$'\t' read -r acao rel; do
    case "$acao" in
      restaurar) mkdir -p "$(dirname "$jogo/$rel")"; cp -p "$backup/arquivos/$rel" "$jogo/$rel"; n=$((n+1)) ;;
      apagar) rm -f "$jogo/$rel"; n=$((n+1)) ;;
    esac
  done < "$manifesto"
  rm -rf "$backup"
  echo "Tradução removida: $n arquivo(s) restaurado(s). O jogo voltou ao inglês."
  echo "Dica: se um save estava em Português, escolha Language > English na tela de carregar."
  exit 0
fi

ver_jogo="$(grep -oE 'GAME_VERSION_NUMBER *= *"[^"]+"' "$settings" | head -1 | cut -d'"' -f2)"
ver_hoenn="$(grep -oE 'HOENN_VERSION_NUMBER *= *"[^"]+"' "$settings" | head -1 | cut -d'"' -f2)"
if [ "$ver_jogo" != "$VERSAO_JOGO" ] || [ "$ver_hoenn" != "$VERSAO_HOENN" ]; then
  echo "ATENÇÃO: esta tradução é para Hoenn $VERSAO_HOENN (base $VERSAO_JOGO), mas o seu jogo é Hoenn ${ver_hoenn:-?} (base ${ver_jogo:-?})."
  if [ "$forcar" -ne 1 ]; then
    echo "Instalação cancelada para não quebrar o jogo. Procure uma versão da tradução para a sua versão do jogo."
    echo "(Se souber o que está fazendo, use --forcar.)"
    exit 1
  fi
fi

# um backup de outra versão do jogo não serve mais
if [ -f "$manifesto" ] && ! grep -qx "versao	$ver_jogo-$ver_hoenn" "$manifesto"; then
  echo "Backup antigo de outra versão do jogo encontrado; ele será substituído."
  rm -rf "$backup"
fi
mkdir -p "$backup/arquivos"
[ -f "$manifesto" ] || printf 'versao\t%s\n' "$ver_jogo-$ver_hoenn" > "$manifesto"

copiados=0
while IFS= read -r -d '' arq; do
  rel="${arq#"$PAYLOAD"/}"
  if ! grep -q "	$rel\$" "$manifesto"; then
    if [ -f "$jogo/$rel" ]; then
      mkdir -p "$(dirname "$backup/arquivos/$rel")"
      cp -p "$jogo/$rel" "$backup/arquivos/$rel"
      printf 'restaurar\t%s\n' "$rel" >> "$manifesto"
    else
      printf 'apagar\t%s\n' "$rel" >> "$manifesto"
    fi
  fi
  mkdir -p "$(dirname "$jogo/$rel")"
  cp "$arq" "$jogo/$rel"
  copiados=$((copiados+1))
done < <(find "$PAYLOAD" -type f -print0)

echo "Tradução PT-BR instalada! $copiados arquivo(s) copiado(s)."
echo "Backup dos originais: $backup"
echo "No jogo: tela de carregar > Language > Português (em save novo o jogo pergunta o idioma)."
