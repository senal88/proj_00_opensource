# Auditoria de `opensource_raw.md` e Blueprint de Buscas Similares (`n8n.senamfo.com.br`)

- **Arquivo auditado:** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource__local/opensource_raw.md`
- **Repositório mestre (Espaço Dev):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource`
- **Orquestrador:** `https://n8n.senamfo.com.br`
- **Data da auditoria:** `2026-11-22`

---

## 1. Auditoria Técnica do `opensource_raw.md`

### 1.1 O que está sólido e foi aproveitado
1. **Template `PROJECT.md` e `INDEX.md`:** Estrutura limpa, auditável, compatível com `SYSTEM_CORE.md` (separação entre SSOT Git e segredos em `~/.env.global`).
2. **Catálogo de 50 Apps (`bEIJUykSNIs`, canal NOVA ONDA):** Completo (Top 20 com estrelas coletadas em `2026-11-21` + itens #21 a #50 com timestamps exatos), promovido para `saas_alternativas/apps_github_assinaturas_nova_onda_bEIJUykSNIs.md`.
3. **Classificação corrigida do vídeo `Hi-4c7HDS4M`:** Inicialmente em `triagem/`, foi resolvido no final do raw como *10 Ferramentas de Tráfego Pago de Graça no GitHub* (canal Tecnativo) → movido para `marketing_trafego` em `urls.txt`.
4. **Taxonomia `snake_case` com preservação do `<id_video>`:** Evita colisões e permite reconstrução determinística (`https://youtu.be/<id_video>`).

### 1.2 Falhas e Riscos Encontrados no `opensource_raw.md`
| Severidade | Achado | Impacto | Correção Aplicada / Recomendada |
| :--- | :--- | :--- | :--- |
| **Alta** | Export bruto contém blocos de `<ElicitationsGroup>`, *Thinking steps* e caractere invisível `U+200B` nos fences de código (`\u200b`) | Quebra parsers Markdown e scripts copiados literalmente | Manter `opensource_raw.md` apenas em `proj_00_opensource__local/`; promover apenas artefatos higienizados para `proj_00_opensource/` |
| **Alta** | `yt2doc.sh` original usava `iconv //TRANSLIT` e `llm` sem modelo padrão | No macOS gera slugs quebrados em acentos e falha com `429` no default OpenAI | Corrigido em `yt2doc.sh` com normalização Unicode `NFKD` em Python e default `gemini-2.5-flash` via `~/.env.global` |
| **Média** | `urls.txt` e tabela de taxonomia tinham divergência para `Hi-4c7HDS4M` (`triagem` vs `marketing_trafego`) | Classificação inconsistente no batch | Unificado em `marketing_trafego` no `urls.txt` canônico |
| **Média** | Catálogo dos 50 apps aponta para agregador externo (`ateus.ia.br`) sem URLs diretas `github.com/<org>/<repo>` | Impede auditoria automática de estrelas, licença, último commit e Docker/Coolify | Enriquecer via API do GitHub no pipeline `n8n` |
| **Média** | Referência residual a `Directus` na linha 51 do template bruto | Contraria regra global (Supabase self-hosted `https://supabase.senamfo.com.br` é o backend canônico) | Removido do `PROJECT.md` canônico |
| **Baixa** | `rclone copy PROJECT.docx` no raw não mantinha espelho completo nem removia órfãos | Drift entre Dev e Google Drive | Substituído por `scripts/sync_gdrive.sh` com `rclone sync` unidirecional (mestre = Espaço Dev) |

---

## 2. Próximos Passos Estruturados (Sequência Executável)

1. **Fase 1 — Materialização do Lote Inicial (Local):**
   - Executar `./yt2doc.sh --batch ./urls.txt` para gerar os 7 vídeos pendentes.
   - Adicionar atualização automática do `INDEX.md` no `yt2doc.sh` (evitando manutenção manual).
   - Rodar `./scripts/sync_gdrive.sh` e `git push` ao final do lote.
2. **Fase 2 — Enriquecimento de Metadados GitHub + Triagem Coolify:**
   - Extrair todos os `github.com/<owner>/<repo>` de cada `.md` e consultar `GET https://api.github.com/repos/<owner>/<repo>` para gravar: `stargazers_count`, `license.spdx_id`, `pushed_at`, `archived`, `topics` e presença de `docker-compose.yml` / `Dockerfile`.
   - Marcar automaticamente `coolify_ready: true/false` para os itens `SERVIDOR`.
3. **Fase 3 — Radar Contínuo e Buscas Similares no `https://n8n.senamfo.com.br`:**
   - Implantar os 3 workflows descritos na Seção 3 abaixo, usando Supabase (`https://supabase.senamfo.com.br`) como fila deduplicada por `video_id` e `repo_full_name` e alertas via Telegram (`N8N_TELEGRAM_CHAT_ID`).

---

## 3. Técnicas de Buscas Similares Completas com `https://n8n.senamfo.com.br`

Para não depender apenas de descobrir vídeos manualmente, estruturar **5 técnicas complementares de busca similar** orquestradas no `n8n`:

### Técnica A — Monitoramento RSS de Canais Semente (Custo Zero, Sem Quota YouTube API)
- **Como funciona:** Todo canal do YouTube expõe feed Atom nativo:
  `https://www.youtube.com/feeds/videos.xml?channel_id=<CHANNEL_ID>`
- **Canais semente iniciais:** André Lug (`Zuj6whVyjNE`), NOVA ONDA (`bEIJUykSNIs`), Mente Digital (`ZectQ2wUhUQ`), Tecnativo (`Hi-4c7HDS4M`).
- **No `n8n`:** `Schedule Trigger` (diário) → `RSS Feed Read` → filtro por palavras-chave (`github`, `open source`, `grátis`, `self-hosted`, `claude code`, `mcp`, `substitui`, `assinatura`) → deduplicação por `video_id` → envia para processamento.

### Técnica B — Busca Semântica / Query Expansion no YouTube (Descoberta de Novos Canais)
- **Como funciona:** Consultar `YouTube Data API v3` (`search.list`, `order=relevance` e `order=date`, `publishedAfter=NOW-14d`) ou `yt-dlp "ytsearch15:<query>" --dump-json` com matriz de queries em PT-BR e EN:
  - PT-BR: `"apps open source github" OR "substituir assinaturas github" OR "ferramentas gratis github" OR "self-hosted coolify"`
  - EN: `"self-hosted alternatives github" OR "open source tools replace saas" OR "claude code skills mcp github"`
- **Score de qualidade no `n8n` (Code node):** Filtrar `view_count >= 2000`, `duration >= 180s` (remove Shorts rasos) e presença de pelo menos 1 link `github.com/` ou palavras-chave técnicas na descrição.

### Técnica C — Grafo de Similaridade no GitHub (Repo → Repos Similares)
- **Como funciona:** A partir de qualquer repositório catalogado (`owner/repo`), encontrar automaticamente os concorrentes diretos via 3 vetores da GitHub API:
  1. **Topics combinados:** `GET /search/repositories?q=topic:<t1>+topic:<t2>+stars:>1000+pushed:>2026-01-01&sort=stars`
  2. **Awesome Lists relacionadas:** `GET /search/repositories?q="awesome"+<categoria>+stars:>500` e parser de links `github.com/<org>/<repo>` no `README.md`.
  3. **Alternativas diretas por SaaS:** Para cada SaaS mapeado na coluna `Substitui` (ex.: `Postman`, `Calendly`, `DocuSign`), consultar `GET /search/repositories?q="<saas>+alternative"+stars:>500+archived:false`.

### Técnica D — Sinais de Tendência Multi-Fonte (Antes de Virar Vídeo)
- **Fontes nativas para `HTTP Request` / `RSS` no `n8n`:**
  - **GitHub Trending / OSS Insight API:** repositórios em aceleração semanal por linguagem/tópico.
  - **Hacker News (Algolia API):** `https://hn.algolia.com/api/v1/search_by_date?query=Show+HN+open+source+self-hosted&numericFilters=points>50`
  - **Reddit RSS:** `https://www.reddit.com/r/selfhosted/top/.rss?t=week` e `https://www.reddit.com/r/opensource/top/.rss?t=week`
  - **AlternativeTo / Selfh.st RSS:** `https://selfh.st/rss/`

### Técnica E — Deduplicação e Clusterização Semântica (Embeddings / LLM)
- **Como funciona:** No `n8n`, ao receber um candidato novo (vídeo ou repo):
  1. Normalizar chave canônica (`video_id` para YouTube; `owner/repo` em lowercase para GitHub).
  2. Verificar existência no Supabase (`proj_00_opensource` schema dedicado) ou no `INDEX.md` via GitHub API.
  3. Classificar domínio automaticamente (`saas_alternativas`, `claude_code`, `ia_produtividade`, `ia_radar`, `marketing_trafego`, `triagem`) via nó LLM (`gemini-2.5-flash`).
  4. Gerar PR/commit no `https://github.com/senal88/proj_00_opensource.git` (ou enfileirar no webhook local) + disparar resumo semanal no Telegram com os Top 10 achados validados (estrelas, licença, compatibilidade Coolify).

---

## 4. Arquitetura dos Workflows no `https://n8n.senamfo.com.br`

| Workflow | Trigger | Entrada | Saída |
| :--- | :--- | :--- | :--- |
| `wf_opensource_youtube_radar` | Cron diário (08:00) + Webhook manual | RSS canais semente + matriz de busca YouTube | Fila deduplicada + classificação de domínio + alerta Telegram |
| `wf_opensource_github_enricher` | Webhook / Sub-workflow | Lista de nomes/URLs de projetos extraídos | JSON enriquecido (stars, licença, `pushed_at`, Docker/Coolify, 5 similares) |
| `wf_opensource_similar_hunter` | Cron semanal (Dom 10:00) | Categorias e SaaS da coluna `Substitui` | Relatório `ia_radar/` com novos repos similares (HN + Reddit + GitHub Search) |
