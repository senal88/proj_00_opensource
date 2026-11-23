#!/usr/bin/env bash
set -euo pipefail

# Sincronização unidirecional: Espaço Dev (mestre) -> Google Drive (rclone)
if [[ -f "${HOME}/.env.global" ]]; then
  set +u
  set -a
  # shellcheck disable=SC1091
  source "${HOME}/.env.global"
  set +a
  set -u
fi

SRC_DIR="${PROJ_00_OPENSOURCE_ROOT:-/Users/luiz.sena88/Projects/opensource/proj_00_opensource}"
DEST_REMOTE="${PROJ_00_OPENSOURCE_GDRIVE_REMOTE_PATH:-gdrive:PROJECTS/proj_00_opensource}"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Erro: diretório mestre não encontrado: ${SRC_DIR}" >&2
  exit 1
fi

if ! command -v rclone >/dev/null 2>&1; then
  echo "Erro: rclone não encontrado no PATH." >&2
  exit 1
fi

EXTRA_FLAGS=()
if [[ "${1:-}" == "--dry-run" ]]; then
  EXTRA_FLAGS+=(--dry-run)
  echo "[DRY-RUN] Simulando sync: ${SRC_DIR} -> ${DEST_REMOTE}"
else
  echo "Sincronizando (mestre Dev -> Drive): ${SRC_DIR} -> ${DEST_REMOTE}"
fi

rclone sync "$SRC_DIR" "$DEST_REMOTE" \
  --exclude ".git/**" \
  --exclude ".DS_Store" \
  --exclude ".env" \
  --exclude ".env.*" \
  --exclude "__pycache__/**" \
  --exclude "*.tmp" \
  --exclude "*.log" \
  --fast-list \
  --create-empty-src-dirs \
  --stats-one-line \
  --stats 5s \
  "${EXTRA_FLAGS[@]}"

echo "Sync concluído: ${SRC_DIR} -> ${DEST_REMOTE}"
