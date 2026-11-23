# PROMPT MESTRE — Executor OpenSource Forge (Codex / Claude Code / Gemini CLI)

> Contexto base em 2026-11-23, mas este prompt é parametrizável e exige coleta atual. Não assumir estado atual a partir deste documento.

## OBJETIVO
Evoluir a vitrine OpenSource Forge para uma plataforma verificável de descoberta, comparação, preparação de clones e avaliação de implantação de projetos abertos recomendados em YouTube, GitHub, diretórios e outras fontes.

## CONTEXTO LOCAL DOCUMENTADO (VALIDAR ANTES DE AGIR)
- SSOT Git dev: `/Users/luiz.sena88/Projects/opensource/proj_00_opensource`
- Twin raw: `/Users/luiz.sena88/Projects/opensource/proj_00_opensource__local`
- Repositório: `https://github.com/senal88/proj_00_opensource.git`
- Skip Project: `81445`; URL de prévia: `https://opensource-forge-catalogo-implantacao-db9db--preview.goskip.app`
- Supabase proposto: `https://supabase.senamfo.com.br` (não assumir esquema nem API)
- Orquestração proposta: `https://n8n.senamfo.com.br` (não assumir workflows ativos)
- Produção alvo: Coolify na VPS (não assumir UUID, hostname de app, projeto, credenciais ou recursos)
- Governança obrigatória: ler `docs/taxonomia.md`, `PROJECT.md`, `INDEX.md`, `HANDOFF.md`.
- Pesquisa atual: `docs/opensource_forge_layout_benchmark.md`, `docs/opensource_forge_skip_blueprint.md`.
- Dados iniciais: `skip/opensource_forge_catalog.json`; imagens externas apenas como referência em `skip/opensource_forge_image_references.json`.

## PAPÉIS
- PLANNER/AUDITOR (GPT/Claude): coleta contexto real, identifica gaps, estabelece evidência, arquitetura e validação.
- EXECUTOR (Codex): implementa mudanças aprovadas, aplica testes, registra logs, rollback e impacto.
- ORQUESTRADOR (n8n): descoberta agendada, deduplicação, enriquecimento e eventos.
- GROUNDING: fontes oficiais, README/LICENSE/GitHub API, docs internas e evidências datadas.
- BACKEND: Supabase somente após inspecionar o estado real e validar contrato com a governança.

## ETAPA 1 — AUDITORIA SOMENTE LEITURA (NÃO OMITIR)
1. Confirmar dispositivo/OS/shell, cwd, árvore do projeto, `git status`, branches/remotes, HEAD e upstream.
2. Ler norma, scripts, catálogo, blueprint, screenshots e estado atual do projeto Skip.
3. Inspecionar conexões habilitadas para GitHub, n8n, Supabase, Coolify, Skip e Drive por ferramentas disponíveis, somente leitura.
4. Comparar o estado local, Skip e GitHub; não supor sincronização porque uma URL responde.
5. Enumerar URLs de vídeo em `urls.txt`, documentos já processados, pendências e dados duplicados.
6. Registrar lacunas com `evidence_url`, `checked_at` e motivo objetivo.
7. Não exibir valor de variável secreta; validar existência somente se necessário.

## ETAPA 2 — INGESTÃO CONTÍNUA
1. Coletar URLs de YouTube e fontes primárias, preservando IDs e timestamps originais.
2. Separar documentos raw de dados normalizados; seguir taxonomia de `docs/taxonomia.md`.
3. Extrair repositórios `owner/repo` das descrições, links, transcrições autorizadas e fontes correlatas.
4. Deduplicar por URL canônica / ID de vídeo e preservar relação muitos-para-muitos entre projeto e fonte.
5. Registrar erros de extração e URLs indisponíveis; não preenchê-los por inferência.
6. Descobertas via n8n devem ser idempotentes e registradas com origem, última verificação e status.
7. Continuar em lotes longos quando houver evidência suficiente, sem interromper por microconfirmações.

## ETAPA 3 — ENRIQUECIMENTO E AVALIAÇÃO
Para cada GitHub repo, verificar atualmente:
- owner/repo, URL canônica, redirects, nome, descrição, topics, branch default;
- licença SPDX com leitura de LICENSE/NOTICE e restrições de uso;
- README e documentação de instalação, releases, data de atualização, issues/commits;
- Dockerfile/Compose, tags e imagens, plataforma CPU e requisitos de runtime;
- bibliotecas, serviços externos, banco, dados persistentes, portas, domínio, variáveis e volumes;
- APIs/webhooks/MCP relevantes e compatibilidade de integração;
- URLs e licença de logos, screenshots, ícones e material visual.
Persistir fonte, status de validação e timestamp em cada atributo. 'Desconhecido' é valor válido.
Comparação deve distinguir popularity de qualidade e compatibilidade, sem score opaco ou inventado.

## ETAPA 4 — ARQUITETURA DE DADOS E SKIP
1. Observar o schema real e o modelo de autenticação antes de propor migrações no Supabase.
2. Determinar como o catálogo Git SSOT alimenta o banco de consulta sem criação de autoridade paralela.
3. Manter módulos existentes do projeto Skip: explorar, seleção, descoberta, fontes e planejador.
4. Integrar API de leitura atualizada e mutações de captura somente com identidade/permissão verificadas.
5. Preservar filtros, comparação, exportação JSON, estados vazios, acessibilidade e responsividade.
6. Referenciar imagens externas com proveniência; não importar marca/código de terceiros sem direito verificado.
7. Integrar GitHub/Coolify via APIs documentadas e teste de permissões; nunca simular 'implantado' sem readback.

## ETAPA 5 — PLANO DE INSTALAÇÃO POR PROJETO
Gerar um `implementation_plan.json` por projeto e destino, com:
- project_id, source_id, repo_url, ref/tag/commit fixado;
- target (dev/github/coolify), preflight do ambiente, dependências e compatibilidade;
- comandos exatos só quando OS/shell/paths reais estiverem confirmados;
- placeholders `{{VAR}}` quando variável/destino não existir na auditoria;
- variáveis requeridas por nome sem valores; decisões de nomes/domínios/volumes;
- riscos de licença, recurso, compatibilidade, migração de dados e integrações;
- testes de build, saúde, E2E, rollback, critérios de sucesso e evidências;
- `execution_authorized=false` até autorização específica da etapa de mutação.
Separar auditoria de clonagem, e clonagem de deploy.

## ETAPA 6 — EXECUÇÃO AUTORIZADA
Executar somente o escopo mutável que tiver autorização suficiente. Preservar WIP, realizar alterações modulares, validar antes de commit/push e registrar readbacks reais. Nunca converter preview funcional em autorização de produção. Em caso de falha, parar a etapa afetada, preservar logs e fornecer rollback aplicável. Não alterar configuração de segurança fora do escopo.

## RESULTADO OBRIGATÓRIO
Retornar Markdown curto com `CONTEXTO`, `DADOS_CONFIRMADOS`, `LACUNAS`, `ANALISE`, `PLANO`, `VALIDACAO`, `PROXIMA_ACAO`.
Acompanhar JSON de máquina com o contrato:

```json
{
  "phase": "AUDIT|INGEST|ENRICH|PLAN|EXECUTE|VALIDATE",
  "status": "COMPLETE|PARTIAL|BLOCKED|FAILED",
  "environment": {"device": null, "os": null, "shell": null, "repo_head": null},
  "sources_checked": [],
  "projects_checked": [],
  "evidence": [],
  "changes_made": [],
  "pending_items": [],
  "planned_commands": [],
  "validation": {"checks": [], "failures": [], "warnings": []},
  "rollback": [],
  "next_action": null
}
```

Não declarar sucesso sem readback. Não imprimir segredos. Não inventar licenças, métricas, caminhos, IDs, capacidades de APIs ou preços.
