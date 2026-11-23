# HANDOFF — `proj_00_opensource`

Atualizado em `2026-11-23`. Leia junto com [`docs/taxonomia.md`](./docs/taxonomia.md)
(norma) e [`INDEX.md`](./INDEX.md) (estado do catálogo).

## 1. Situação

O projeto tinha parado de evoluir por dois motivos concretos, ambos tratados nesta
rodada: o espelho usava `rclone sync` (destrutivo, sem trava nem log, apontando
para um destino antigo) e não havia norma escrita nem verificação automatizada,
então cada nova entrada quebrava a consistência em silêncio.

| Item | Antes | Agora |
| :--- | :--- | :--- |
| Comando do espelho | `rclone sync` (apagava no Drive) | `rclone copy` (nunca apaga) |
| Destino | `gdrive:PROJECTS/proj_00_opensource` (`1joMytZ…`) | ID `1K3J6eAGj31teyfiS00Hd8gT5w5SQkx_I` |
| Concorrência | nenhuma proteção | trava `lockf` |
| Observabilidade | `echo` no terminal | log rotativo em `~/Library/Logs` |
| Segredos | só `.env` e `.env.*` | + chaves/certificados, com `.env.example` preservado |
| Entrada pelo Drive | invisível | `_intake/<data>/` + livro `.triaged` |
| Agendamento | inexistente | LaunchAgent 09:00 e 21:00 |
| Norma | ausente | `docs/taxonomia.md` |
| Verificação | `bash -n` | `make validate` (estrutura, taxonomia, INDEX, fila, segredos, intake) |

## 2. Entregue nesta rodada

- [`scripts/sync_gdrive.sh`](./scripts/sync_gdrive.sh) reescrito: flags separadas por
  comando (`DRIVE_FLAGS`, `LOG_FLAGS`, `FILTER_FLAGS`), porque `--create-empty-src-dirs`
  não é aceito por `rclone check` e `--files-from` não aceita filtros junto.
- [`scripts/validate_repo.py`](./scripts/validate_repo.py) e [`Makefile`](./Makefile).
- [`docs/taxonomia.md`](./docs/taxonomia.md): forma A (vídeo) e forma B (não-vídeo),
  portas de entrada, contrato rclone e livro de triagem.
- LaunchAgent `com.senamfo.proj-00-opensource.gdrive-sync` (09:00 e 21:00) e link
  operacional `~/.local/bin/proj_00_opensource_gdrive_sync.sh`.
- `~/.env.global`: destino novo, `INTAKE_DIR`, `SYNC_LOG_DIR`, `VALIDATE_SCRIPT` e o
  ID legado preservado em `PROJ_00_OPENSOURCE_GDRIVE_LEGACY_FOLDER_ID`.
- Intake triado: `trafego_pago.docx` promovido para
  [`marketing_trafego/ferramentas_trafego_pago_tecnativo_Hi-4c7HDS4M.md`](./marketing_trafego/ferramentas_trafego_pago_tecnativo_Hi-4c7HDS4M.md)
  (canal confirmado via metadados: **Tecnativo**); `buscador_opensource.docx`
  promovido para [`docs/fontes_descoberta_canais.md`](./docs/fontes_descoberta_canais.md).
  Ambos marcados em `_intake/.triaged`, então não são baixados de novo.

## 3. Pendências, em ordem

1. **Fila de 6 vídeos** em [`urls.txt`](./urls.txt) (`vjqJmMIsiR0`, `oV81MNcBfMY`,
   `lnNtwW7R00c`, `_2gC1JBc3XI`, `ZectQ2wUhUQ`, `e0fD5WLCnbU`). Rodar
   `./yt2doc.sh --batch ./urls.txt` exige chave do Gemini e consome cota — decidir o momento.
2. **4 domínios vazios** (`engenharia_reversa`, `ia_produtividade`, `ia_radar`,
   `marketing_trafego` já tem 1 doc). A validação avisa. Ou processar a fila, ou
   remover o domínio da árvore e de `DOMAINS` no validador.
3. **`INDEX.md` manual.** `make channels` pode adicionar vídeos que a validação vai
   acusar por não estarem no índice. Antes de ampliar `channels.txt` com os canais de
   [`docs/fontes_descoberta_canais.md`](./docs/fontes_descoberta_canais.md), implementar
   a atualização automática da seção de pendentes.
4. **Alegações não verificadas** em `marketing_trafego`: licenças do Meta Ads MCP (BSL 1.1)
   e do Dub (AGPL). Conferir `LICENSE` nos repositórios antes de uso comercial.
5. **`yt2doc.sh` não atualiza o `INDEX.md`** ao final da execução (lacuna já registrada
   em `PROJECT.md`).
6. **Workflow n8n** de descoberta, conforme
   [`docs/audit_opensource_raw_and_n8n_blueprint.md`](./docs/audit_opensource_raw_and_n8n_blueprint.md).

## 4. Decisões registradas

- `copy` em vez de `sync`: um `git clean` local não pode virar destruição no Drive.
- `.env.example` é a única exceção de `.env*`, por ser contrato público sem segredo.
- Forma B de nomenclatura criada porque material de curadoria própria não tem ID de vídeo;
  forçar um ID falso seria proveniência inventada.
- `_intake/.triaged` em vez de rebaixar para sempre: promover não remove do Drive.
- `channels.txt` **não** foi ampliado agora, de propósito: sem atualização automática
  do `INDEX.md`, isso criaria falha de validação em cascata.

## 5. Operação segura

```bash
cd ~/Projects/opensource/proj_00_opensource
make validate        # precisa passar sem FAIL
make sync-dry-run    # confere antes de publicar
make sync            # dev -> Drive
```

Diagnóstico:

```bash
launchctl print gui/$(id -u)/com.senamfo.proj-00-opensource.gdrive-sync | grep -E 'state|last exit'
tail -20 ~/Library/Logs/proj_00_opensource_gdrive_sync.log
rclone lsf gdrive: --drive-root-folder-id 1K3J6eAGj31teyfiS00Hd8gT5w5SQkx_I
```

## 6. Regras para não recriar o problema

- Nunca `rclone sync` neste projeto.
- Corrigir conteúdo no dev; o Drive é saída, não entrada.
- Toda entrada nova (`_intake/` ou `triagem/`) precisa de decisão: promover com nome
  da taxonomia **e** linha no `INDEX.md`, ou descartar. E marcar em `.triaged` se veio do Drive.
- WIP não commitado: conferir `git status` antes de mexer.

## 7. OpenSource Forge — Vitrine de Projetos (2026-11-23)

- **Descentralizado (2026-11-23):** o app "OpenSource Forge" (React/Vite) agora vive em repo próprio — [github.com/senal88/opensources](https://github.com/senal88/opensources). O que segue é o histórico de quando era o bloco `skip/` deste repositório.

- **Escopo:** pesquisa de layouts pagos/gratuitos; curadoria de 31 repositórios GitHub verificados por conector; referência visual de 6 screenshots de terceiros sem redistribuição.
- **Dados:** `skip/opensource_forge_catalog.json`; **metodologia:** `docs/opensource_forge_layout_benchmark.md`; **especificação:** `docs/opensource_forge_skip_blueprint.md`.
- **Skip:** projeto `81445`, versão `0.0.3`; prévia em `https://opensource-forge-catalogo-implantacao-db9db--preview.goskip.app`.
- **Funciona:** busca, filtros, detalhes, shortlist, captura local com validação de duplicados, exportação JSON, seleção DEV/GitHub/Coolify, plano de execução dry-run.
- **Não implementado:** persistência Supabase, workflows n8n, enrichment contínuo, validação de licenças, inspeção de Compose/infra e execução de clone/deploy.
- **Limite:** a segunda execução de QA Skip compilou, mas o estágio de análise estática retornou `fetch failed` por erro de rede; a primeira execução da aplicação passou integralmente. A suíte de testes não foi executada pelo Skip.
- **Governança:** não publicar em produção nem provisionar VPS sem validação específica. O catálogo continua no Git dev como fonte mestre; screenshots externos só como referências de estudo.
