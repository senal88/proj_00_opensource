# proj_00_opensource

## 1. Identificação e Status
- **ID / Slug:** `proj_00_opensource`
- **Status:** `Em Desenvolvimento`
- **Responsável:** Luiz Sena
- **Repositório:** `https://github.com/senal88/proj_00_opensource.git`
- **Espaço Dev (SSOT):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource`
- **Twin Local (Raw/Não-commitável):** `/Users/luiz.sena88/Projects/opensource/proj_00_opensource__local`
- **Espelho Google Drive (`rclone`):** `gdrive:PROJECTS/proj_00_opensource`
- **Última atualização:** `2026-11-22`

---

## 2. Objetivo e Escopo
- **Problema resolvido:** Catalogar, padronizar (`snake_case`) e auditar repositórios open-source recomendados em vídeos do YouTube e fontes correlatas, mantendo o espaço dev como fonte mestre com espelhamento automatizado no GitHub e Google Drive.
- **Fora de escopo:** Armazenar segredos reais no Git/Drive, baixar arquivos de vídeo completos ou substituir o deployment de apps em produção no Coolify.

---

## 3. Stack e Dependências
| Componente | Tecnologia / Versão | Papel |
| :--- | :--- | :--- |
| Extração YouTube | `yt-dlp`, `jq`, `python3` | Metadados, descrição e legendas VTT |
| Síntese Estruturada | `llm` (`llm-gemini`, padrão `gemini-2.5-flash`) | Geração dos Documentos Mestres |
| Sincronização Drive | `rclone` (`gdrive:PROJECTS/proj_00_opensource`) | Espelhamento unidirecional mestre Dev → Drive |
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
├── scripts/              # Automação operacional (sync_gdrive.sh)
├── triagem/              # Fila de entrada para vídeos sem domínio definido
├── .env.example          # Contrato de variáveis (sem valores reais)
├── .gitignore            # Exclusões Git
├── INDEX.md              # Índice mestre do catálogo
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
| `PROJ_00_OPENSOURCE_GDRIVE_REMOTE_PATH` | Sim | `~/.env.global` (`gdrive:PROJECTS/proj_00_opensource`) |
| `PROJ_00_OPENSOURCE_GDRIVE_FOLDER_ID` | Sim | `~/.env.global` |
| `GEMINI_API_KEY` | Sim | `~/.env.global` (mapeada para `LLM_GEMINI_KEY` em `yt2doc.sh`) |
| `N8N_API_BASE_URL` | Opcional | `~/.env.global` (`https://n8n.senamfo.com.br/api/v1`) |

---

## 6. Operação (Comandos Exatos)

### Processar vídeo unitário ou lote
```bash
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh "https://www.youtube.com/watch?v=Zuj6whVyjNE" claude_code
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh --batch /Users/luiz.sena88/Projects/opensource/proj_00_opensource/urls.txt
```

### Sincronizar Espaço Dev → Google Drive (mestre = Dev)
```bash
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/scripts/sync_gdrive.sh --dry-run
/Users/luiz.sena88/Projects/opensource/proj_00_opensource/scripts/sync_gdrive.sh
```

---

## 7. Validação e Healthcheck
- **Validação sintática:** `bash -n /Users/luiz.sena88/Projects/opensource/proj_00_opensource/yt2doc.sh /Users/luiz.sena88/Projects/opensource/proj_00_opensource/scripts/sync_gdrive.sh`
- **Validação Drive:** `rclone lsf gdrive:PROJECTS/proj_00_opensource`
- **Validação Git:** `git -C /Users/luiz.sena88/Projects/opensource/proj_00_opensource status -sb`

---

## 8. Registro de Decisões (ADR)
| Data | Decisão | Motivo / Trade-off |
| :--- | :--- | :--- |
| `2026-11-22` | Separar `proj_00_opensource` (Git/SSOT) de `proj_00_opensource__local` (raw) | Conformidade com topologia `SYSTEM_CORE.md` §1.1.8 |
| `2026-11-22` | Espelho unidirecional `rclone sync` (Dev → Drive) | Impedir drift de edições paralelas no Google Drive |
| `2026-11-22` | Padrão `gemini-2.5-flash` em `yt2doc.sh` | Evitar erro 429 do default OpenAI do CLI `llm` |

---

## 9. Lacunas e Pendências Técnicas
- [ ] Executar `./yt2doc.sh --batch ./urls.txt` para materializar os 8 vídeos restantes da fila inicial.
- [ ] Implementar atualização automática de `INDEX.md` ao final de cada execução do `yt2doc.sh`.
- [ ] Subir o workflow de descoberta e busca similar no `https://n8n.senamfo.com.br` conforme `docs/audit_opensource_raw_and_n8n_blueprint.md`.
