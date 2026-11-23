# Índice Mestre — Catálogo Open-Source (`proj_00_opensource`)

- **Espaço Dev (SSOT):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource`
- **Repositório GitHub:** `https://github.com/senal88/proj_00_opensource.git`
- **Espelho Google Drive:** `gdrive:` com `--drive-root-folder-id 1K3J6eAGj31teyfiS00Hd8gT5w5SQkx_I`
- **URL do Drive:** https://drive.google.com/drive/folders/1K3J6eAGj31teyfiS00Hd8gT5w5SQkx_I
- **Última atualização:** `2026-11-23`
- **Norma:** [`docs/taxonomia.md`](./docs/taxonomia.md)

## 1. Documentos Processados

| Domínio | Arquivo | Vídeo ID | Status |
| :--- | :--- | :--- | :--- |
| `claude_code` | [ferramentas_gratis_pra_editar_video_com_claud_andre_lug_autoridade_com_ia_Zuj6whVyjNE.md](./claude_code/ferramentas_gratis_pra_editar_video_com_claud_andre_lug_autoridade_com_ia_Zuj6whVyjNE.md) | `Zuj6whVyjNE` | Processado via `yt2doc.sh` |
| `saas_alternativas` | [apps_github_assinaturas_nova_onda_bEIJUykSNIs.md](./saas_alternativas/apps_github_assinaturas_nova_onda_bEIJUykSNIs.md) | `bEIJUykSNIs` | Consolidado de `opensource_raw.md` (50 apps) |
| `marketing_trafego` | [ferramentas_trafego_pago_tecnativo_Hi-4c7HDS4M.md](./marketing_trafego/ferramentas_trafego_pago_tecnativo_Hi-4c7HDS4M.md) | `Hi-4c7HDS4M` | Promovido do intake do Drive (2026-11-23) |

## 2. Fila Pendente (`urls.txt`)

| Domínio | Vídeo ID | URL Canônica | Status |
| :--- | :--- | :--- | :--- |
| `saas_alternativas` | `vjqJmMIsiR0` | https://www.youtube.com/watch?v=vjqJmMIsiR0 | Pendente batch |
| `saas_alternativas` | `oV81MNcBfMY` | https://www.youtube.com/watch?v=oV81MNcBfMY | Pendente batch |
| `claude_code` | `lnNtwW7R00c` | https://www.youtube.com/watch?v=lnNtwW7R00c | Pendente batch |
| `ia_produtividade` | `_2gC1JBc3XI` | https://www.youtube.com/watch?v=_2gC1JBc3XI | Pendente batch |
| `ia_produtividade` | `ZectQ2wUhUQ` | https://www.youtube.com/watch?v=ZectQ2wUhUQ | Pendente batch |
| `ia_radar` | `e0fD5WLCnbU` | https://www.youtube.com/watch?v=e0fD5WLCnbU | Pendente batch |

## 3. Normas, Auditoria, Raw, Skip e Automação
- [`docs/taxonomia.md`](./docs/taxonomia.md) — norma de nomenclatura, portas de entrada e contrato rclone
- [`HANDOFF.md`](./HANDOFF.md) — estado atual e próximos passos
- [PROJECT.md](./PROJECT.md) — Documento mestre do repositório
- [docs/audit_opensource_raw_and_n8n_blueprint.md](./docs/audit_opensource_raw_and_n8n_blueprint.md) — Auditoria de `opensource_raw.md`, próximos passos e arquitetura de buscas similares no `https://n8n.senamfo.com.br`
- [docs/fontes_descoberta_canais.md](./docs/fontes_descoberta_canais.md) — Curadoria de canais, diretórios e feeds primários de descoberta
- [raw/opensource_raw.md](./raw/opensource_raw.md) — Export bruto de referência histórica
- [skip/radar_osre.html](./skip/radar_osre.html) — Cockpit Skip autocontido (**Radar OS/RE**)
- [skip/radar_osre_completo_raw.txt](./skip/radar_osre_completo_raw.txt) — Briefing e especificação completa do app Skip
- [channels.txt](./channels.txt) e [scripts/check_channels.sh](./scripts/check_channels.sh) — Monitoramento de novos vídeos por canal

## 4. Comandos

```bash
make validate      # estrutura, taxonomia, INDEX, fila, segredos e intake
make sync-dry-run  # simula dev -> Drive
make sync          # espelha dev -> Drive (não apaga no destino)
make channels      # busca novos vídeos dos canais
```

## 5. OpenSource Forge — Vitrine Skip (2026-11-23)

- [docs/opensource_forge_layout_benchmark.md](./docs/opensource_forge_layout_benchmark.md) — pesquisa de layouts, modelos free/paid e padrões de UX
- [docs/opensource_forge_skip_blueprint.md](./docs/opensource_forge_skip_blueprint.md) — arquitetura, entidades, fluxos e critérios de aceitação
- [skip/opensource_forge_catalog.json](./skip/opensource_forge_catalog.json) — 31 repositórios verificados no GitHub com fontes rastreáveis
- [skip/opensource_forge_image_references.json](./skip/opensource_forge_image_references.json) — manifesto de referências visuais externas
- [skip/opensource_forge_preview.png](./skip/opensource_forge_preview.png) e [skip/opensource_forge_preview_mobile.png](./skip/opensource_forge_preview_mobile.png) — screenshots originais da prévia Skip
- [Prévia Skip](https://opensource-forge-catalogo-implantacao-db9db--preview.goskip.app) — projeto 81445, catálogo e planejamento sem deploy
- [docs/opensource_forge_agent_prompt.md](./docs/opensource_forge_agent_prompt.md) — prompt operacional para auditoria, ingestão e integração por agentes CLI
