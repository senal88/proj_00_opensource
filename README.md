# Catálogo Open-Source (`proj_00_opensource`)

- **Espaço Dev (SSOT / Mestre):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource`
- **Twin Local (Raw / Não-commitável):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource__local`
- **Repositório GitHub:** `https://github.com/senal88/proj_00_opensource.git`
- **Norma do projeto:** [`docs/taxonomia.md`](./docs/taxonomia.md)
- **Espelho Google Drive (`rclone`):** https://drive.google.com/drive/folders/1K3J6eAGj31teyfiS00Hd8gT5w5SQkx_I

## Taxonomia `snake_case`

Padrão de caminho:

```text
<dominio>/<assunto_principal>_<canal>_<id_video>.md
```

- Subpastas de domínio:
  - `saas_alternativas/`
  - `claude_code/`
  - `ia_produtividade/`
  - `ia_radar/`
  - `marketing_trafego/`
  - `triagem/`
- `<assunto_principal>` e `<canal>` em ASCII minúsculo `snake_case`, sem acentos e sem número de quantidade inicial no título.
- `<id_video>` preserva o *case* original do YouTube para deduplicação exata (`https://youtu.be/<id_video>`).
- Material que não vem de vídeo usa a **forma B**: `<dominio>/<assunto_principal>_<origem>_<slug>.md`
  (`origem` ∈ `drive`, `skip`, `manual`, `site`, `doc`).

## Pipeline (`yt2doc.sh`)

```bash
# Unitário
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh "https://www.youtube.com/watch?v=Zuj6whVyjNE" claude_code

# Lote
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh --batch /Users/luiz.sena88/Projects/opensource/proj_00_opensource/urls.txt
```

Por padrão o script carrega `~/.env.global` e usa `gemini-2.5-flash` via plugin `llm-gemini` (sobrescrevível via `YT2DOC_MODEL`).

## Validação e sincronização

O espaço dev (`/Users/luiz.sena88/Projects/opensource/proj_00_opensource`) é a
referência mestre. O Google Drive é espelho unidirecional.

```bash
make validate      # estrutura, taxonomia, INDEX, fila, segredos e intake
make sync-dry-run  # simula dev -> Drive
make sync          # aplica dev -> Drive
```

`make sync` usa `rclone copy`: **não apaga nada no Drive**. O que existir só no
Drive desce para `proj_00_opensource__local/_intake/<data>/` e é triado à mão;
depois de decidir, registre com `make intake-done FILE=<nome>`.

## Referências
- [docs/taxonomia.md](./docs/taxonomia.md) — norma de nomenclatura e contrato rclone
- [HANDOFF.md](./HANDOFF.md) — estado atual e próximos passos
- [PROJECT.md](./PROJECT.md)
- [INDEX.md](./INDEX.md)
- [docs/fontes_descoberta_canais.md](./docs/fontes_descoberta_canais.md)
- [docs/audit_opensource_raw_and_n8n_blueprint.md](./docs/audit_opensource_raw_and_n8n_blueprint.md)
