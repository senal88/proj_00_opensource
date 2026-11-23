# Benchmark de vitrines, galerias e plataformas de deploy — OpenSource Forge

Data da verificação: 2026-11-23
Escopo: pesquisar padrões de UI/UX e capacidades observáveis para a vitrine Skip, não copiar código ou design de terceiros.
Implementação: Skip project 81445; referências documentais em docs/opensource_forge_skip_blueprint.md.

## 1. Plataformas pesquisadas (paid / free)

| Plataforma | Perfil de acesso | O que serve à vitrine | Evidência |
|---|---|---|---|
| OpenAlternative | Diretório com navegação pública; eventual oferta comercial não auditada | Cards de software, alternativa SaaS, filtros e estrelas | https://openalternative.co/ |
| selfh.st/apps | Diretório público; parcerias pagas opcionais em programa próprio | Filtro por categoria, serviço substituído, atividade e tags | https://selfh.st/apps/ ; https://selfh.st/apps-partners/ |
| Dokploy Templates | Templates públicos; custo da infraestrutura de execução é separado | Ficha técnica de template, logos, manifesto e variáveis | https://dokploy.com/templates ; https://github.com/dokploy/templates |
| Railway Templates | Marketplace público; plataforma comercial com trial e uso cobrado | Jornada de deploy, configuração e projeto clonável | https://docs.railway.com/templates ; https://railway.com/pricing |
| Vercel Templates | Marketplace público; plano Hobby gratuito e Pro/Enterprise pagos | Filtros por caso de uso, stack e projeto inicial | https://vercel.com/templates/starter ; https://vercel.com/pricing |
| n8n Workflows | Templates públicos; Community self-hosted sem licença comercial, Cloud pago | Busca por apps, cargos, objetivos, conectores e workflows | https://n8n.io/workflows/ ; https://n8n.io/pricing/ |
| Coolify Services | Serviço self-hosted gratuito; Cloud opcional pago | App/Service, Docker Compose, GitHub, domínio, ambientes | https://coolify.io/docs/services ; https://coolify.io/self-hosted |
| Hugging Face Spaces | Galeria pública; Spaces estáticos gratuitos, Gradio/Docker sob plano elegível | Demo funcional, código, duplicação e recursos de compute | https://huggingface.co/docs/hub/spaces-overview |
| GitHub Trending | Navegação pública | Tendência por idioma, linguagem e janela temporal | https://github.com/trending |
| DevHunt | Diretório e ranking públicos; monetização não auditada | Novidade, tags, lançamento e filtragem | https://devhunt.org/ |
| OpenSourceSwap | Diretório público; monetização não auditada | Alternativas SaaS, comparativos e eventos de preço com fonte | https://opensourceswap.com/ |
| Coolify API / MCP | Depende de implantação e token válidos | Inspeção de projetos, aplicativos e deployments, execução separada | https://coolify.io/docs/api/overview ; https://coolify.io/docs/mcp/capabilities/overview |

A expressão 'público' significa catálogo consultável, não um parecer sobre uso comercial ou redistribuição.
Regras comerciais e limites mudam: consultar a página oficial no momento da implantação.
Importante: n8n Community usa Sustainable Use License; 'Community grátis para self-host' não equivale a 'open source OSI' (https://support.n8n.io/article/can-i-use-your-license-for-my-use-case).
Railway informa teste grátis inicial e cobrança mensal/consumo após o trial; não apresentar 'hospedagem ilimitada grátis'.
Hugging Face atual: Static Spaces gratuitos; criação de Gradio/Docker Spaces exige plano elegível, mesmo quando o hardware CPU Basic não tem tarifa horária.

## 2. Padrões de interface aproveitáveis

| Padrão | Referências | Implementação na vitrine Skip |
|---|---|---|
| Hero + busca universal | OpenAlternative, Railway, n8n | Headline clara, campo de busca e chamada de captura |
| Cards responsivos | OpenAlternative, Railway, Dokploy | Nome, repo, resumo, domínio, modo, proveniência |
| Facetas / filtros | selfh.st/apps, Vercel, n8n | Categoria, formato de uso, busca textual e status |
| Página de detalhe | Dokploy, OpenAlternative | Origem com link, branch, licença, documentação, requisitos |
| Comparação de escolhas | SaaS directories | Seleção pessoal e matriz de campos verificados / ausentes |
| Wizard de integração | Railway, Coolify | Projeto → destino → evidências → contrato JSON |
| Arquivos de setup | Dokploy, Coolify | Dockerfile/Compose, variáveis, portas e volumes (apenas após auditados) |
| Demo funcional | Hugging Face Spaces | Preview da aplicação com rótulo claro de simulação vs integração |
| Ranking temporal | GitHub Trending, DevHunt | Atualizações e tendências com timestamp, nunca números presumidos |
| Proveniência | YouTube + GitHub | URL original, vídeo ID, repositório canônico, data de validação |
| Estado de deploy | Coolify | Não conectado / planejado / autorizado / em execução / validado / falhou |

## 3. Navegação aprovada para o protótipo

1. **Explorar projetos:** cards, busca, filtros, detalhes e exportação
2. **Minha seleção:** comparar repositórios e escolher implantação
3. **Nova descoberta:** capturar GitHub URL + fonte + descrição, deduplicar por owner/repo
4. **Fontes & radar:** links de curadoria verificados, sem prometer monitoramento ativo
5. **Planejar implantação:** gerar contrato JSON dry-run para DEV/GitHub/Coolify

O app criado em Skip tem esses cinco módulos. Persistência de novas capturas é local ao navegador até a integração com backend, explicitamente identificada na UI.

## 4. Modelo de decisão por repositório

- **Proveniência:** qual vídeo/post/referência citou o projeto? URL válida?
- **Identidade:** owner/repo existe no GitHub? renomeou? arquivado?
- **Direitos:** licença e condições de uso comercial confirmadas por LICENSE e docs?
- **Manutenção:** releases, últimos commits, issues, incompatibilidades e atividade
- **Execução:** CLI, desktop, SaaS, biblioteca, MCP, self-hosted, pacote de dados
- **Infraestrutura:** requisitos, Dockerfile, Compose, ARM64 x86_64, memória, banco, storage
- **Integração:** autenticação, APIs, webhooks, MCP, eventos, variáveis de ambiente
- **Implantação:** DEV, Github, Coolify/Prod e procedimento de retorno
- **Evidências:** links, timestamp UTC, versão e tipo de verificação

Nenhum campo não observado deve ser transformado em decisão automática.

## 5. Dados e assets registráveis

| Artefato | Caminho dentro da SSOT | Finalidade |
|---|---|---|
| Benchmark atual | docs/opensource_forge_layout_benchmark.md | Pesquisa e patterns |
| Blueprint principal | docs/opensource_forge_skip_blueprint.md | Requisitos de produto, integração e esquema |
| Sementes de repositórios | skip/opensource_forge_catalog.json | Dados de 31 projetos com fonte |
| Manifesto visual | skip/opensource_forge_image_references.json | URLs de screenshots externas e proveniência |
| Preview desktop | skip/opensource_forge_preview.png | Captura original da versão Skip |
| Preview mobile | skip/opensource_forge_preview_mobile.png | Captura responsiva original |
| Projeto Skip | https://opensource-forge-catalogo-implantacao-db9db--preview.goskip.app | Vitrine de demonstração funcional |

Screenshots externos são referências com licença de reprodução não determinada; não empacotar suas imagens no frontend. O app tem identidade visual e composição próprias.

## 6. Integrações alvo e fluxo real

```text
YouTube/RSS/GitHub/Directories
      -> importação/curadoria (n8n proposto)
      -> validação e extração de evidências
      -> catálogo Git SSOT
      -> consulta estruturada (Supabase quando validado)
      -> Skip (busca, comparação, plano de execução)
      -> Dev local (inspeção/clone autorizado)
      -> GitHub (fork/cópia autorizada + CI)
      -> Coolify (deploy autorizado)
      -> monitoramento, rollback e evidência
```

A API de gerenciamento do Coolify disponibiliza projetos, aplicativos e deployments, mas permissões e APIs reais do Coolify da VPS devem ser testadas antes de prometer ações pelo Skip.
O catálogo mestre do projeto contém 6 vídeos ainda pendentes de processamento. Não declarar a coleta automática ativa até configurar n8n e provar logs, agendamento e persistência.

## 7. Contrato de dados proposto para cada registro

```json
{
  "repo": "{{OWNER}}/{{REPO}}",
  "repository_url": "https://github.com/{{OWNER}}/{{REPO}}",
  "source_type": "{{YOUTUBE|SITE|RSS|MANUAL}}",
  "source_url": "{{SOURCE_URL}}",
  "source_document": "{{CANONICAL_DOCUMENT_OR_NULL}}",
  "category": "{{DOMAIN}}",
  "branch": "{{VERIFIED_BRANCH_OR_NULL}}",
  "license": null,
  "license_verification": "pendente",
  "compatibility": "nao_testada",
  "metadata_checked_at": null,
  "deployment_status": "nao_implantado",
  "evidence_links": []
}
```

## 8. Critérios de aceite de implementação

- Cards funcionam com pelo menos 31 URLs GitHub realmente verificadas e sua origem.
- Captura valida a URL, recusa duplicados e exporta os registros.
- O seletor de destino entrega JSON parseável e usa placeholders para ambiente não identificado.
- Interface clara em desktop e mobile; screenshot está salvo com seus próprios assets.
- README/INDEX/HANDOFF de governança continuam coerentes com docs/taxonomia.md.
- Nenhum deploy automático sem verificação dos requisitos reais de cada projeto.
- O progresso de integrações é demonstrado com logs e readback, não por ícones de sucesso sem dados.

## 9. Pendências de segunda etapa

1. Inspecionar API real e permissões do Supabase, n8n, Coolify, GitHub e Skip antes de integrar.
2. Confirmar política de persistência única entre SSOT Git e banco de consulta.
3. Enriquecer metadados GitHub (LICENSE, README, commits, releases, Docker, recursos).
4. Adicionar imports CSV/JSON/Youtube em lote após validação de schema.
5. Implementar avaliação de arquitetura e instalabilidade por destino com evidência.
6. Automatizar os fluxos n8n e validar idempotência e replay em casos reais.
7. Executar testes E2E de captura, seleção e exportação; o build da prévia Skip não executou suíte de testes.
