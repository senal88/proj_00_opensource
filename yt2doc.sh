#!/usr/bin/env bash
set -euo pipefail

# Carrega segredos e configurações globais se disponíveis
if [[ -f "${HOME}/.env.global" ]]; then
  set +u
  set -a
  # shellcheck disable=SC1091
  source "${HOME}/.env.global"
  set +a
  set -u
fi

# Mapeia chaves padrão do ~/.env.global para variáveis esperadas pelos plugins do llm
if [[ -z "${LLM_GEMINI_KEY:-}" && -n "${GEMINI_API_KEY:-}" ]]; then
  export LLM_GEMINI_KEY="${GEMINI_API_KEY}"
fi
if [[ -z "${LLM_ANTHROPIC_KEY:-}" && -n "${ANTHROPIC_API_KEY:-}" ]]; then
  export LLM_ANTHROPIC_KEY="${ANTHROPIC_API_KEY}"
fi
if [[ -z "${LLM_OPENROUTER_KEY:-}" && -n "${OPENROUTER_API_KEY:-}" ]]; then
  export LLM_OPENROUTER_KEY="${OPENROUTER_API_KEY}"
fi
if [[ -z "${LLM_DEEPSEEK_KEY:-}" && -n "${DEEPSEEK_API_KEY:-}" ]]; then
  export LLM_DEEPSEEK_KEY="${DEEPSEEK_API_KEY}"
fi

usage() {
  cat <<EOF
Uso:
  $0 <youtube_url> <dominio>
  $0 --batch <arquivo_urls.txt>

Variáveis opcionais:
  YT2DOC_MODEL   Modelo do CLI 'llm' (ex.: gemini-2.5-pro, gemini-2.5-flash, ollama/qwen2.5:14b)
  YT2DOC_OUT_ROOT Diretório raiz de saída (padrão: diretório atual '.')

Exemplos:
  $0 'https://www.youtube.com/watch?v=Zuj6whVyjNE' claude_code
  $0 --batch ./urls.txt
EOF
}

if [[ $# -lt 2 ]]; then
  usage
  exit 1
fi

# Modo batch: arquivo com linhas "<dominio> <url>"
if [[ "$1" == "--batch" ]]; then
  BATCH_FILE="$2"
  if [[ ! -f "$BATCH_FILE" ]]; then
    echo "Erro: arquivo batch não encontrado: ${BATCH_FILE}" >&2
    exit 1
  fi
  FAILED=0
  while read -r domain url _rest; do
    [[ -z "${domain:-}" || "$domain" == \#* ]] && continue
    echo "==> Processando [${domain}] ${url}"
    if ! "$0" "$url" "$domain"; then
      echo "Erro ao processar: ${url} (${domain})" >&2
      FAILED=$((FAILED + 1))
    fi
  done < "$BATCH_FILE"
  if [[ "$FAILED" -gt 0 ]]; then
    echo "Concluído com ${FAILED} falha(s)." >&2
    exit 1
  fi
  exit 0
fi

for bin in yt-dlp jq llm python3; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "Erro: dependência ausente no PATH: ${bin}" >&2
    exit 1
  fi
done

URL="$1"
DOMAIN="$2"
OUT_ROOT="${YT2DOC_OUT_ROOT:-.}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# 1. Extrair metadados em JSON
yt-dlp --skip-download --dump-json "$URL" > "${TMP_DIR}/meta.json"

VIDEO_ID="$(jq -r '.id // empty' "${TMP_DIR}/meta.json")"
TITLE="$(jq -r '.title // "video_sem_titulo"' "${TMP_DIR}/meta.json")"
CHANNEL="$(jq -r '.channel // .uploader // "canal_desconhecido"' "${TMP_DIR}/meta.json")"
UPLOAD_DATE="$(jq -r '.upload_date // "desconhecida"' "${TMP_DIR}/meta.json")"
DESCRIPTION="$(jq -r '.description // ""' "${TMP_DIR}/meta.json")"

if [[ -z "$VIDEO_ID" ]]; then
  echo "Erro: não foi possível extrair VIDEO_ID de ${URL}" >&2
  exit 1
fi

# 2. Normalizar slug em snake_case (ASCII puro, sem acentos, sem número inicial no título)
slugify() {
  local input="$1"
  local strip_leading_num="${2:-0}"
  python3 - "$input" "$strip_leading_num" <<'PY'
import re, sys, unicodedata

text = sys.argv[1]
strip_num = sys.argv[2] == "1"
norm = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode("ascii").lower()
if strip_num:
    norm = re.sub(r"^\s*\d+\s+", "", norm)
slug = re.sub(r"[^a-z0-9]+", "_", norm).strip("_")
print(slug[:45].rstrip("_"))
PY
}

SLUG_TITLE="$(slugify "$TITLE" 1)"
SLUG_CHANNEL="$(slugify "$CHANNEL" 0)"
[[ -z "$SLUG_TITLE" ]] && SLUG_TITLE="video"
[[ -z "$SLUG_CHANNEL" ]] && SLUG_CHANNEL="canal"

OUT_DIR="${OUT_ROOT}/${DOMAIN}"
OUT_FILE="${OUT_DIR}/${SLUG_TITLE}_${SLUG_CHANNEL}_${VIDEO_ID}.md"
mkdir -p "$OUT_DIR"

# 3. Extrair legenda/transcrição (PT preferencial, fallback auto-sub e EN)
yt-dlp --skip-download --write-subs --write-auto-subs \
  --sub-langs "pt,pt-BR,en" --sub-format "vtt" \
  -o "${TMP_DIR}/subs.%(ext)s" "$URL" >/dev/null 2>&1 || true

TRANSCRIPT=""
SUB_FILE="$(find "$TMP_DIR" -name 'subs.*.vtt' | sort | head -n 1 || true)"
if [[ -n "$SUB_FILE" ]]; then
  TRANSCRIPT="$(python3 - "$SUB_FILE" <<'PY'
import re, sys
from pathlib import Path

lines = Path(sys.argv[1]).read_text(encoding="utf-8", errors="ignore").splitlines()
seen = set()
out = []
for raw in lines:
    line = raw.strip()
    if not line:
        continue
    if line.startswith(("WEBVTT", "Kind:", "Language:", "NOTE")):
        continue
    if "-->" in line or re.fullmatch(r"\d+", line):
        continue
    clean = re.sub(r"<[^>]*>", "", line).strip()
    if clean and clean not in seen:
        seen.add(clean)
        out.append(clean)
print("\n".join(out))
PY
)"
fi

if [[ -z "$TRANSCRIPT" ]]; then
  TRANSCRIPT="[Legenda/transcrição indisponível via yt-dlp; basear-se nos metadados e registrar lacuna.]"
fi

# 4. Gerar Documento Mestre via LLM
PROMPT="Gere um Documento Mestre em Markdown estritamente técnico e objetivo contendo:
1. Identificação (Título, Canal, URL completa, ID ${VIDEO_ID}, Data ${UPLOAD_DATE})
2. Critérios/Contexto do vídeo
3. Tabela completa com todos os repositórios/ferramentas citados (Nome, Substitui/Categoria, Função técnica e limitações/letra miúda)
4. Seção de Lacunas/Pendências para validação local.

--- METADADOS ---
Título: ${TITLE}
Canal: ${CHANNEL}
URL: ${URL}
ID: ${VIDEO_ID}
Data: ${UPLOAD_DATE}
Descrição:
${DESCRIPTION}

--- TRANSCRIÇÃO ---
${TRANSCRIPT}"

LLM_MODEL="${YT2DOC_MODEL:-gemini-2.5-flash}"
LLM_ARGS=(-m "$LLM_MODEL")

printf '%s' "$PROMPT" | llm "${LLM_ARGS[@]}" > "${TMP_DIR}/doc.md"
mv "${TMP_DIR}/doc.md" "$OUT_FILE"

echo "Documento gerado em: ${OUT_FILE}"
