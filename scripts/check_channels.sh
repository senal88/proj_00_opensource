#!/usr/bin/env bash
set -euo pipefail

# Monitora os últimos N vídeos de canais YouTube (sem baixar mídia) e adiciona novos IDs em urls.txt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHANNELS_FILE="${1:-${SCRIPT_DIR}/channels.txt}"
URLS_FILE="${2:-${SCRIPT_DIR}/urls.txt}"
LIMIT="${CHECK_CHANNELS_LIMIT:-3}"

if [[ ! -f "$CHANNELS_FILE" ]]; then
  echo "Erro: arquivo '${CHANNELS_FILE}' não encontrado." >&2
  exit 1
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "Erro: yt-dlp não encontrado no PATH." >&2
  exit 1
fi

touch "$URLS_FILE"
NOVOS=0

while read -r domain channel_url _rest; do
  [[ -z "${domain:-}" || "$domain" == \#* ]] && continue

  video_ids="$(yt-dlp --flat-playlist --playlist-end "$LIMIT" \
    --print "%(id)s" --no-warnings "$channel_url" 2>/dev/null || true)"

  if [[ -z "$video_ids" ]]; then
    echo "[AVISO] Nenhum vídeo obtido de: ${channel_url}" >&2
    continue
  fi

  while IFS= read -r vid; do
    [[ -z "$vid" ]] && continue
    if ! grep -Fq "watch?v=${vid}" "$URLS_FILE"; then
      echo "${domain} https://www.youtube.com/watch?v=${vid}" >> "$URLS_FILE"
      echo "[NOVO] ${domain} - https://www.youtube.com/watch?v=${vid}"
      NOVOS=$((NOVOS + 1))
    fi
  done <<< "$video_ids"
done < "$CHANNELS_FILE"

echo "Concluído. Novos vídeos adicionados em ${URLS_FILE}: ${NOVOS}"
