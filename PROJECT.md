# proj_00_opensource

## 1. Identificação e Status
- **ID / Slug:** `proj_00_opensource`
- **Status:** `Em Desenvolvimento`
- **Responsável:** Luiz Sena
- **Repositório:** `https://github.com/senal88/proj_00_opensource.git`
- **Espaço Dev (SSOT):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource`
- **Twin Local (Raw/Não-commitável):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource__local`
- **Espelho Google Drive (`rclone`):** `gdrive:` com `--drive-root-folder-id 1K3J6eAGj31teyfiS00Hd8gT5w5SQkx_I`
- **URL do Drive:** https://drive.google.com/drive/folders/1K3J6eAGj31teyfiS00Hd8gT5w5SQkx_I
- **Última atualização:** `2026-11-23`

---

## 2. Objetivo e Escopo
- **Problema resolvido:** Catalogar, padronizar (`snake_case`) e auditar repositórios open-source recomendados em vídeos do YouTube e fontes correlatas, mantendo o espaço dev como fonte mestre com espelhamento automatizado no GitHub e Google Drive.
- **Norma vinculante:** [`docs/taxonomia.md`](./docs/taxonomia.md).
- **Fora de escopo:** Armazenar segredos reais no Git/Drive, baixar arquivos de vídeo completos ou substituir o deployment de apps em produção no Coolify.

---

## 3. Stack e Dependências
| Componente | Tecnologia / Versão | Papel |
| :--- | :--- | :--- |
| Extração YouTube | `yt-dlp`, `jq`, `python3` | Metadados, descrição e legendas VTT |
| Síntese Estruturada | `llm` (`llm-gemini`, padrão `gemini-2.5-flash`) | Geração dos Documentos Mestres |
| Sincronização Drive | `rclone` v1.72+ (`copy` + `--drive-root-folder-id`) | Espelho unidirecional Dev → Drive, sem deleção no destino |
| Verificação | `python3` (stdlib) | `make validate`: estrutura, taxonomia, INDEX, fila, segredos, intake |
| Agendamento | `launchd` | `com.senamfo.proj-00-opensource.gdrive-sync`, 09:00 e 21:00 |
| Automação e Radar | `https://n8n.senamfo.com.br` | Descoberta contínua e buscas similares |
| Persistência futura | `https://supabase.senamfo.com.br` | Catálogo estruturado e deduplicação por `video_id`/`repo_url` |

---

## 4. Estrutura de Diretórios (Factual)
```text
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/
├── claude_code/          # Ferramentas e skills ligadas a Claude Code
├── docs/                 # Auditorias e blueprints de automação (n8n)
├── ia_produtividade/     # Ferramentas de IA para estudo e documentos
├── ia_radar/             # Radar mensal de repositórios de IA
├── marketing_trafego/    # Ferramentas open-source de tráfego e marketing
├── saas_alternativas/    # Alternativas open-source a SaaS pagos
├── scripts/              # sync_gdrive.sh, validate_repo.py, check_channels.sh
├── triagem/              # Fila de entrada para material sem domínio definido
├── .env.example          # Contrato de variáveis (sem valores reais)
├── .gitignore            # Exclusões Git
├── HANDOFF.md            # Estado atual e próximos passos
├── INDEX.md              # Índice mestre do catálogo
├── Makefile              # validate / sync / sync-dry-run / channels / intake-done
├── PROJECT.md            # Este documento
├── README.md             # Guia rápido operacional
├── urls.txt              # Fila em lote canônica
└── yt2doc.sh             # Pipeline URL -> Documento Mestre
```

---

## 5. Configuração e Variáveis de Ambiente
*Segredos e caminhos canônicos residem exclusivamente em `~/.env.global`.*

| Variável | Obrigatória | Origem / Observação |
| :--- | :--- | :--- |
| `PROJ_00_OPENSOURCE_ROOT` | Sim | `~/.env.global` |
| `PROJ_00_OPENSOURCE_LOCAL_ROOT` | Sim | `~/.env.global` |
| `PROJ_00_OPENSOURCE_GIT_URL` | Sim | `~/.env.global` |
| `PROJ_00_OPENSOURCE_GDRIVE_FOLDER_ID` | Sim | `~/.env.global` (destino canônico; sempre por ID) |
| `PROJ_00_OPENSOURCE_INTAKE_DIR` | Sim | `~/.env.global` (`<twin>/_intake`, material vindo do Drive) |
| `PROJ_00_OPENSOURCE_SYNC_LOG_DIR` | Opcional | `~/.env.global` (default `~/Library/Logs`) |
| `PROJ_00_OPENSOURCE_GDRIVE_LEGACY_FOLDER_ID` | Não | Destino antigo `1joMytZ…`, mantido só para rastreio |
| `GEMINI_API_KEY` | Sim | `~/.env.global` (mapeada para `LLM_GEMINI_KEY` em `yt2doc.sh`) |
| `DEEPSEEK_API_KEY` | Opcional | `~/.env.global` (mapeada para `LLM_DEEPSEEK_KEY` em `yt2doc.sh`) |
| `OPENCODE_API_KEY` | Opcional | `~/.env.global` (orquestração/agentes OpenCode) |
| `N8N_API_BASE_URL` | Opcional | `~/.env.global` (`https://n8n.senamfo.com.br/api/v1`) |

### Referências Plataforma Adapta / Skip
- **Maestro:** `https://maestro.adapta.one/`
- **Adapta Agent (Projeto):** `https://agent.adapta.one/chat?projectId=01a2064f-2a9a-7703-97a3-1cbbcbf32c98`
- **Adapta Agent (Chat):** `https://agent.adapta.one/chat/01a20648-716d-779c-85cf-255873b37458`
- **Skip Workspace:** `https://goskip.dev/luizfernandomoreirasena-6f51d/workspace/projects`
- **Artefatos Skip no repositório:** `skip/radar_osre.html` e `skip/radar_osre_completo_raw.txt`
- **Raw consolidado no repositório:** `raw/opensource_raw.md`

---

## 6. Operação (Comandos Exatos)

### Processar vídeo unitário ou lote
```bash
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh "https://www.youtube.com/watch?v=Zuj6whVyjNE" claude_code
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh --batch /Users/luiz.sena88/Projects/opensource/proj_00_opensource/urls.txt
```

### Sincronizar Espaço Dev → Google Drive (mestre = Dev)
```bash
cd /Users/luiz.sena88/Projects/opensource/proj_00_opensource
make validate        # precisa passar sem FAIL
make sync-dry-run    # simula dev -> Drive
make sync            # aplica (nunca apaga no destino)
```

O que existe no Drive e não existe no dev desce para `<twin>/_intake/<data>/`.
Após promover ou descartar, registrar em `_intake/.triaged` (`make intake-done FILE=...`)
para não baixar de novo.

---

## 7. Validação e Healthcheck
- **Estrutural:** `make validate` (arquivos obrigatórios, taxonomia, INDEX, fila, segredos, intake)
- **Sintática:** `bash -n yt2doc.sh scripts/sync_gdrive.sh && shellcheck scripts/sync_gdrive.sh`
- **Drive:** `rclone lsf gdrive: --drive-root-folder-id "$PROJ_00_OPENSOURCE_GDRIVE_FOLDER_ID"`
- **Agendamento:** `launchctl print gui/$(id -u)/com.senamfo.proj-00-opensource.gdrive-sync | grep -E 'state|last exit'`
- **Git:** `git status -sb`

---

## 8. Registro de Decisões (ADR)
| Data | Decisão | Motivo / Trade-off |
| :--- | :--- | :--- |
| `2026-11-22` | Separar `proj_00_opensource` (Git/SSOT) de `proj_00_opensource__local` (raw) | Conformidade com topologia `SYSTEM_CORE.md` §1.1.8 |
| `2026-11-22` | Espelho unidirecional Dev → Drive | Impedir drift de edições paralelas no Google Drive |
| `2026-11-23` | `rclone copy` substitui `rclone sync` | `sync` apagava no Drive o que não existisse local; `copy` preserva o destino |
| `2026-11-23` | Destino por `--drive-root-folder-id` (`1K3J6…`) | Caminho textual não é endereço confiável; o remote tem raiz própria |
| `2026-11-23` | Forma B de nomenclatura (`<assunto>_<origem>_<slug>.md`) | Material de curadoria própria não tem ID de vídeo; inventar ID seria proveniência falsa |
| `2026-11-23` | Livro `_intake/.triaged` | Promover não remove do Drive; sem livro o intake rebaixaria o mesmo arquivo sempre |
| `2026-11-23` | `.env.example` exceção em `.env*` | É contrato público sem segredo e precisa ser espelhado |
| `2026-11-22` | Padrão `gemini-2.5-flash` em `yt2doc.sh` | Evitar erro 429 do default OpenAI do CLI `llm` |

---

## 9. Lacunas e Pendências Técnicas
Detalhamento e ordem de execução em [`HANDOFF.md`](./HANDOFF.md).
- [ ] Executar `./yt2doc.sh --batch ./urls.txt` para materializar os 6 vídeos restantes da fila.
- [ ] Implementar atualização automática de `INDEX.md` (pré-requisito para ampliar `channels.txt`).
- [ ] Preencher os domínios vazios (`engenharia_reversa`, `ia_produtividade`, `ia_radar`) ou removê-los da taxonomia.
- [ ] Subir o workflow de descoberta e busca similar no `https://n8n.senamfo.com.br` conforme `docs/audit_opensource_raw_and_n8n_blueprint.md`.
