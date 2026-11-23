# OpenSource Forge — Blueprint operacional para Skip

Atualizado: 2026-11-23
Status: pesquisa aplicada + protótipo Skip em desenvolvimento
Projeto Git SSOT: /Users/luiz.sena88/Projects/opensource/proj_00_opensource
Projeto Skip: 81445
Preview: https://opensource-forge-catalogo-implantacao-db9db--preview.goskip.app

## Objetivo
Vitrine de projetos open-source curados por vídeos e fontes independentes, com descoberta, comparação, registro de proveniência e planejamento de clonagem e integração nos ambientes Dev/GitHub/Prod. Implantação real é ação separada do planejamento.

## Fontes de design verificadas
| Produto | Categoria | Referência | Elemento útil |
|---|---|---|---|
| OpenAlternative | Diretório open-source | https://openalternative.co/ | Cards, alternativas pagas, filtros |
| selfh.st/apps | Catálogo self-hosted | https://selfh.st/apps/ | Facetas por caso de uso, alternativa e popularidade |
| Dokploy Templates | Galeria de deploy | https://dokploy.com/templates | Ficha de template, versão, variáveis, Compose |
| Railway Templates | Marketplace PaaS | https://docs.railway.com/templates | Passo a passo de criação do serviço |
| Vercel Templates | Marketplace de starters | https://vercel.com/templates/starter | Categorias e modelos clonáveis |
| n8n Templates | Galeria de automação | https://n8n.io/workflows/ | Busca por integrações e objetivos |
| Coolify Services | Biblioteca de instalação | https://coolify.io/docs/services/overview | Templates e deploy Docker |
| Hugging Face Spaces | Galeria de demos | https://huggingface.co/docs/hub/spaces-overview | Demo + código + duplicação |
| DevHunt | Descoberta de ferramentas | https://devhunt.org/ | Curadoria temporal, categorias |
| GitHub Trending | Radar de repositórios | https://github.com/trending | Língua, linguagem e período |

## Pesquisa visual
Manifesto de screenshots com URLs de origem, atribuição e situação de uso: skip/opensource_forge_image_references.json.
Essas imagens são referências de estudo; não foram copiadas para o produto. Direitos de redistribuição não verificados.
O protótipo utiliza layout e gráficos CSS próprios, sem copiar logotipos de terceiros.

## Inventário de dados
- Fonte histórica de 50 projetos: saas_alternativas/apps_github_assinaturas_nova_onda_bEIJUykSNIs.md
- Fonte de 10 ferramentas: marketing_trafego/ferramentas_trafego_pago_tecnativo_Hi-4c7HDS4M.md
- URLs de YouTube pendentes: urls.txt e INDEX.md
- Sementes GitHub verificadas via conector em 2026-11-23: skip/opensource_forge_catalog.json (31 repos)
- Estrelas, licenças, releases, custos, ram, portas e requisitos não foram validados: permanecer nulos ou 'não testado'

## Arquitetura mínima
1. Ingestão: YouTube/RSS/diretórios → fila de curadoria existente.
2. Normalização: URL canônica, video_id, owner/repo, fonte, data, evidências.
3. Validação: GitHub API (existência, licença, activity, manifestos), revisão manual.
4. Catalogação: catálogo Git versionado como SSOT e, quando autorizado, espelho de consulta no Supabase.
5. Vitrine Skip: cards, facetas, comparação, dossiê, seleção de destino e exportação de plano.
6. Orquestração: n8n agenda coleta, enriquecimento e sincronização; sem deploy automático por padrão.
7. DEV: inspeção do repositório e plano de clonagem; PROD: revisão dos requisitos antes de aplicação pelo Coolify.

## Entidades mínimas para Supabase (proposta, sem aplicação)
- sources(id, type, url, title, author, published_at, collected_at)
- projects(id, repository_url UNIQUE, name, category, summary, default_branch, license_spdx, license_checked_at, metadata_checked_at)
- project_sources(project_id, source_id, timecode_seconds, excerpt_url)
- deployment_profiles(id, project_id, target, manifest_type, manifest_url, requirements_json, verified_at)
- evaluations(id, project_id, criterion, result, evidence_url, evaluated_at)
- implementation_plans(id, project_id, target, settings_json, status, created_at, reviewed_at)
- assets(id, project_id, asset_url, source_url, license, provenance, usage_permission)
As tabelas são contrato proposto, não o estado real do Supabase.

## Jornada e telas
- Explorar: busca, categorias, fontes, cards e filtros por modo de uso
- Detalhe: README, vídeo, repo, licença pendente, compatibilidade não testada
- Comparar: seleção de projetos e matriz de campos comprovados vs ausentes
- Capturar: formulário com URL GitHub, origem e descrição, validação, duplicados
- Implantar: assistente Dev → GitHub → Coolify, pré-visualização de manifesto sem disparar deploy
- Fontes: catálogo de canais, diretórios, status de filas e links
- Exportar: JSON reutilizável por Codex, Claude Code, Gemini CLI e n8n

## Campos para ficha por projeto
id; name; repository_url; category; description; source_type; source_url; source_document; license;
license_verification; branch; mode; repository_verified_at; compatibility;
deploy_requirements (com fontes); assets; notes; evaluation_status;
installation_status; last_checked_at; evidence_links.

## Regras operacionais
- Nunca converter 'repositório encontrado' em 'deploy compatível' sem evidência.
- Licenças e requisitos ficam desconhecidos quando não consultados.
- Não copiar código ou interface sem avaliar licença e autorização aplicável.
- Clonar, criar repositório, provisionar recurso ou deployar exige ação específica do executor.
- A tela de planejamento deve permanecer funcional sem credenciais e não imprimir segredos.
- O Git dev segue SSOT; Google Drive é espelho, não local de edição.
- Nomes e taxonomia de conteúdos permanecem em docs/taxonomia.md.

## Validação/aceite
1. 15 repositórios identificados por URL, com fonte e situação da evidência.
2. Busca, filtros, visualização de detalhes, captura local, comparação e exportação funcionais.
3. Wizard entrega plano JSON, sem executar clone, provisionar ou publicar.
4. Nenhuma licença, custo, estrela ou métrica inventada.
5. Responsividade, campos obrigatórios, estado vazio e tratamento de duplicatas.
6. A implantação de produção permanece bloqueada até validação por projeto.

## Pendências reais
- Conectar Skip ao Supabase self-hosted, validando endpoint, autenticação e política de acesso reais.
- Configurar e testar workflows n8n de descoberta, enriquecimento e deduplicação.
- Obter e validar Dockerfile/Compose, release, branch, licença e imagem de cada repo.
- Processar 6 vídeos pendentes do lote local.
- Mapear capacidade e recursos da VPS e perfis DEV/PROD antes de elaborar implantações executáveis.
- Definir espelhamento app Skip ↔ GitHub sem interferir na SSOT.
