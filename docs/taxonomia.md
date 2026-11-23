# Taxonomia e Contrato Operacional — `proj_00_opensource`

Norma única do repositório. Em caso de divergência entre este documento e um
script, o script é o defeito — exceto quando este documento for atualizado junto.

## 1. Fonte de verdade

| Espaço | Papel | Pode editar? |
| :--- | :--- | :--- |
| `proj_00_opensource` (dev) | SSOT: catálogo curado, versionado no Git | Sim, via commit |
| `proj_00_opensource__local` (twin) | Material bruto, incluindo `_intake/` | Sim, mas não versionado |
| Google Drive (`1K3J6…`) | Espelho unidirecional do dev | Não — correções nascem no dev |

Regra dura: **nunca corrigir conteúdo direto no Drive**. O que nascer lá é
baixado para `_intake/` e triado; o dev sobrescreve o Drive, jamais o contrário.

## 2. Árvore canônica

```text
proj_00_opensource/
├── claude_code/            # Claude Code: skills, ferramentas, fluxos
├── engenharia_reversa/     # RE, binários, análise de baixo nível
├── ia_produtividade/       # IA aplicada a estudo e documentos
├── ia_radar/               # radar de repositórios e modelos
├── marketing_trafego/      # aquisição, anúncios, growth
├── saas_alternativas/      # substitutos open-source de SaaS pagos
├── triagem/                # fila: material recebido sem domínio decidido
├── docs/                   # normas, auditorias, blueprints
├── raw/                    # export bruto de referência histórica
├── skip/                   # artefatos do workspace Skip
├── scripts/                # sync_gdrive.sh, validate_repo.py, check_channels.sh
├── INDEX.md                # índice mestre (precisa citar todo .md de domínio)
├── PROJECT.md              # identificação, stack, operação, ADR
├── HANDOFF.md              # estado atual e próximos passos
├── urls.txt                # fila canônica de vídeos
└── channels.txt            # canais monitorados
```

Domínio sem conteúdo é permitido, mas a validação emite aviso. Se um domínio
ficar vazio por mais de um ciclo de curadoria, remova-o da árvore e da lista
`DOMAINS` em `scripts/validate_repo.py`.

## 3. Nomenclatura

Duas formas, ambas `snake_case` em ASCII, sem acento e sem prefixo numérico:

**Forma A — documento derivado de vídeo:**

```text
<dominio>/<assunto_principal>_<canal>_<id_video>.md
```

`<id_video>` preserva o *case* original do YouTube (11 caracteres). Um arquivo
por vídeo; consolidar vários vídeos em um documento exige o campo `Consolida`
no cabeçalho.

**Forma B — material que não vem de vídeo:**

```text
<dominio>/<assunto_principal>_<origem>_<slug>.md
```

`<origem>` ∈ `drive`, `skip`, `manual`, `site`, `doc`. `<slug>` é um resumo curto
do conteúdo. Use esta forma para listas curadas, notas próprias e artefatos
recebidos. Material de referência sobre o próprio projeto (normas, fontes de
descoberta) vai em `docs/`, fora da regra de domínio.

## 4. Portas de entrada

| Origem | Caminho | Destino final |
| :--- | :--- | :--- |
| URL de vídeo | `urls.txt` → `yt2doc.sh --batch` | domínio correspondente |
| Arquivo criado no Drive | `_intake/<data>/` (via `sync_gdrive.sh`) | domínio ou descarte |
| Arquivo recebido manualmente | `triagem/` | domínio ou descarte |

Toda entrada precisa de decisão registrada: promovida (mover com nome da
taxonomia + linha no `INDEX.md`) ou descartada (remover). Permanecer parado em
`triagem/` ou `_intake/` é dívida, e a validação acusa.

### 4.1 Livro de triagem (intake)

Promover um arquivo não o remove do Drive. Para o intake não baixar o mesmo
arquivo a cada execução, registre o caminho relativo original em
`proj_00_opensource__local/_intake/.triaged`, um por linha:

```bash
make intake-done FILE=buscador_opensource.docx
```

O sincronizador ignora o que estiver nesse livro. Material já promovido pode ser
removido de `_intake/<data>/`; o Drive permanece como origem histórica.

## 5. Contrato de sincronização (`scripts/sync_gdrive.sh`)

Norma vinculante para qualquer espelho Drive deste projeto:

1. **`rclone copy`, nunca `rclone sync`.** `sync` apaga no destino o que não
   existe na origem; um `git clean` local viraria destruição no Drive.
2. **Destino por ID** (`--drive-root-folder-id`). O remote `gdrive:` tem raiz
   própria; caminho textual não é endereço confiável.
3. **Trava atômica** (`lockf`) — duas execuções simultâneas geram drift.
4. **Log rotativo** em `~/Library/Logs`, com retenção e compressão.
5. **Exclusões de segurança:** `.git`, `.env*` (exceto `.env.example`),
   `Chaves Privadas`, `*.key`, `*.pem`, `*.p12`, `*.pfx`, `*.p8`, `*.p7b`, `*.p7c`.
6. **`--links`**: symlink vira sidecar `.rclonelink` reversível (alvo textual);
   o conteúdo apontado não é copiado.
7. **`--checksum`** na subida e `rclone check` one-way na descida.
8. **Intake isolado:** o que só existe no Drive desce para `_intake/`, nunca
   por cima do projeto.
9. Agendamento por LaunchAgent (`com.senamfo.proj-00-opensource.gdrive-sync`),
   09:00 e 21:00.

`.env.example` é a única exceção da família `.env*`: é contrato público, sem
segredo real, e deve ser espelhado.

## 6. Verificação antes de publicar

```bash
make validate      # estrutura, taxonomia, INDEX, fila, segredos, intake
make sync-dry-run  # simula dev -> Drive
make sync          # aplica
```

`make validate` precisa passar sem falhas. Avisos exigem decisão registrada no
`HANDOFF.md`, não silêncio.
