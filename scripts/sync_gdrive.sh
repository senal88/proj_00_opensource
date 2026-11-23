#!/bin/bash
# Espelha o dev no Google Drive (dev -> Drive, nunca o contrario).
#
# 1) intake: arquivos que existem no Drive e nao existem no dev sao baixados
#    para <twin>/_intake/<data>/ e depois triados a mao (promover pela taxonomia
#    ou descartar). Destino isolado: nunca toca nem sobrescreve o projeto.
# 2) copy: dev -> Drive. Nao apaga nada no Drive (nunca use `rclone sync` aqui).
#
# Uso: sync_gdrive.sh [--dry-run]        (launchd: 09:00 e 21:00)
set -euo pipefail

ENV_FILE="${HOME}/.env.global"
if [[ -z "${PROJ_00_OPENSOURCE_ROOT:-}" && -f "$ENV_FILE" ]]; then
  set +u
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
  set -u
fi

: "${PROJ_00_OPENSOURCE_ROOT:?Missing PROJ_00_OPENSOURCE_ROOT}"
: "${PROJ_00_OPENSOURCE_GDRIVE_FOLDER_ID:?Missing PROJ_00_OPENSOURCE_GDRIVE_FOLDER_ID}"

ROOT="$PROJ_00_OPENSOURCE_ROOT"
REMOTE="${PROJ_00_OPENSOURCE_GDRIVE_REMOTE:-gdrive}"
FOLDER="$PROJ_00_OPENSOURCE_GDRIVE_FOLDER_ID"
LOCAL_ROOT="${PROJ_00_OPENSOURCE_LOCAL_ROOT:-$(dirname "$ROOT")/proj_00_opensource__local}"
INTAKE_ROOT="${PROJ_00_OPENSOURCE_INTAKE_DIR:-$LOCAL_ROOT/_intake}"
INTAKE="$INTAKE_ROOT/$(date +%F)"
LOG_DIR="${PROJ_00_OPENSOURCE_SYNC_LOG_DIR:-$HOME/Library/Logs}"
LOG="$LOG_DIR/proj_00_opensource_gdrive_sync.log"
LOCK_FILE="$HOME/Library/Caches/proj_00_opensource_gdrive_sync.lock"
RCLONE_BIN="${RCLONE_BIN:-/opt/homebrew/bin/rclone}"

DRY=""
case "${1:-}" in
  ""|--dry-run) DRY="${1:-}" ;;
  *) echo "uso: $(basename "$0") [--dry-run]" >&2; exit 64 ;;
esac

[[ -d "$ROOT" ]] || { echo "Diretorio de origem nao existe: $ROOT" >&2; exit 2; }
[[ -x "$RCLONE_BIN" ]] || { echo "rclone nao encontrado: $RCLONE_BIN" >&2; exit 127; }

mkdir -p "$LOG_DIR" "$(dirname "$LOCK_FILE")"

# Destino sempre por ID: o remote `gdrive:` tem root_folder_id proprio.
# Google Drive guarda symlinks como sidecar reversivel .rclonelink (alvo
# textual, sem copiar o conteudo apontado).
DRIVE_FLAGS=(
  --drive-root-folder-id "$FOLDER"
  --drive-export-formats docx
  --links
)

LOG_FLAGS=(
  --log-level NOTICE
  --log-file-max-size 25M
  --log-file-max-backups 3
  --log-file-max-age 30d
  --log-file-compress
  --log-file "$LOG"
  --stats 1m
  --stats-one-line
)

# `.env.example` e contrato publico (sem segredo) e deve ser espelhado;
# todo o resto da familia `.env*` fica de fora.
FILTER_FLAGS=(
  --exclude '.git'
  --exclude '**/.git'
  --exclude '.git/**'
  --exclude '**/.git/**'
  --exclude '.DS_Store'
  --exclude '**/.DS_Store'
  --exclude '__pycache__'
  --exclude '**/__pycache__/**'
  --filter '+ /.env.example'
  --filter '+ **/.env.example'
  --filter '- .env*'
  --filter '- **/.env*'
  --exclude '**/Chaves Privadas/**'
  --exclude '*.key'
  --exclude '**/*.key'
  --exclude '*.pem'
  --exclude '**/*.pem'
  --exclude '*.p12'
  --exclude '**/*.p12'
  --exclude '*.pfx'
  --exclude '**/*.pfx'
  --exclude '*.p8'
  --exclude '**/*.p8'
  --exclude '*.p7b'
  --exclude '**/*.p7b'
  --exclude '*.p7c'
  --exclude '**/*.p7c'
  --exclude '_intake/**'
  --exclude '**/_intake/**'
  --exclude '*.tmp'
  --exclude '*.log'
)

# Trava atomica: duas execucoes concorrentes sobre o mesmo destino geram drift.
exec 200>"$LOCK_FILE"
if ! /usr/bin/lockf -t 0 200; then
  echo "Sincronizacao ja em andamento em outro processo. Abortando." >&2
  exit 0
fi

MISSING="$(mktemp -t proj00opensource_missing.XXXXXX)"
trap 'rm -f "$MISSING" "$MISSING.new"' EXIT

# 1) intake: o que existe no Drive e nao existe no dev
# rclone check: 0 = sem diferencas, 1 = diferencas, >1 = erro real.
set +e
"$RCLONE_BIN" check "$REMOTE:" "$ROOT" --one-way --missing-on-dst "$MISSING" \
  --size-only "${DRIVE_FLAGS[@]}" "${FILTER_FLAGS[@]}" "${LOG_FLAGS[@]}" >/dev/null 2>&1
CHECK_RC=$?
set -e

# Livro de triagem: nao rebaixar o que ja foi promovido ou descartado.
TRIAGED="$INTAKE_ROOT/.triaged"
if [[ -s "$MISSING" && -s "$TRIAGED" ]]; then
  grep -vxF -f "$TRIAGED" "$MISSING" > "$MISSING.new" || true
  mv -f "$MISSING.new" "$MISSING"
fi

if (( CHECK_RC > 1 )); then
  echo "aviso: rclone check falhou (rc=$CHECK_RC); intake ignorado nesta rodada" >&2
elif [[ -s "$MISSING" ]]; then
  mkdir -p "$INTAKE"
  # --files-from determina a lista e nao aceita filtros junto.
  "$RCLONE_BIN" copy "$REMOTE:" "$INTAKE" --files-from "$MISSING" \
    ${DRY:+"$DRY"} "${DRIVE_FLAGS[@]}" "${LOG_FLAGS[@]}"
  echo "intake: $(wc -l < "$MISSING" | tr -d ' ') item(ns) do Drive em $INTAKE"
  echo "        triar: promover para o dominio da taxonomia, ou descartar"
fi

# 2) dev -> Drive
"$RCLONE_BIN" copy "$ROOT" "$REMOTE:" ${DRY:+"$DRY"} \
  --checksum --create-empty-src-dirs \
  --checkers 8 --transfers 4 --retries 3 --retries-sleep 30s \
  "${DRIVE_FLAGS[@]}" "${FILTER_FLAGS[@]}" "${LOG_FLAGS[@]}"

echo "ok: dev -> Drive (${ROOT} -> ${REMOTE}: id=${FOLDER})"
