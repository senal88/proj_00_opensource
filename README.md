# Catálogo Open-Source (`proj_00_opensource`)

- **Espaço Dev (SSOT / Mestre):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource`
- **Twin Local (Raw / Não-commitável):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource__local`
- **Repositório GitHub:** `https://github.com/senal88/proj_00_opensource.git`
- **Espelho Google Drive (`rclone`):** `gdrive:PROJECTS/proj_00_opensource`

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

## Pipeline (`yt2doc.sh`)

```bash
# Unitário
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh "https://www.youtube.com/watch?v=Zuj6whVyjNE" claude_code

# Lote
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh --batch /Users/luiz.sena88/Projects/opensource/proj_00_opensource/urls.txt
```

Por padrão o script carrega `~/.env.global` e usa `gemini-2.5-flash` via plugin `llm-gemini` (sobrescrevível via `YT2DOC_MODEL`).

## Sincronização Espaço Dev → Google Drive (`rclone`)

O espaço dev (`/Users/luiz.sena88/Projects/opensource/proj_00_opensource`) é a referência mestre. O Google Drive é atualizado de forma unidirecional:

```bash
# Simulação
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/scripts/sync_gdrive.sh --dry-run

# Sync efetivo
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/scripts/sync_gdrive.sh
```

## Referências
- [PROJECT.md](./PROJECT.md)
- [INDEX.md](./INDEX.md)
- [docs/audit_opensource_raw_and_n8n_blueprint.md](./docs/audit_opensource_raw_and_n8n_blueprint.md)
