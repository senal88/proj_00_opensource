# Fontes de Descoberta de Projetos Open Source

- **Origem do material:** documento `buscador_opensource.docx` criado no Google Drive, promovido em 2026-11-23
- **Natureza:** curadoria de fontes de descoberta (canais, diretórios e feeds). Não é documento de vídeo.
- **Papel no projeto:** insumo para `channels.txt` e para a fila `urls.txt`. A lista canônica executada
  continua sendo [`channels.txt`](../channels.txt); este documento amplia as opções.

## 1. Open source, self-hosted e curadoria GitHub

### Global (inglês — infra, Docker e deploy)

| Canal | Foco |
| :--- | :--- |
| Awesome Open Source | Reviews práticos e tutoriais de instalação (Docker/VPS) de ferramentas self-hosted |
| Techno Tim | Homelab, infraestrutura self-hosted, Docker, Kubernetes e monitoramento |
| Christian Lempa | Arquitetura de servidores, automação e open source em produção |
| DB Tech | Containers Docker e alternativas open source a SaaS |
| Fireship | Radar rápido de repositórios, frameworks e tendências |

### Brasil (português — listas GitHub e IA)

| Canal | Foco |
| :--- | :--- |
| Diolinux | Linux, ecossistema open source e produtividade |
| André Lug \| Autoridade com IA | Curadoria de repositórios GitHub de IA, Claude Code e produtividade |
| NOVA ONDA / Tecnativo / Eddwan Hallen | Rankings periódicos de repositórios em alta e alternativas gratuitas a SaaS |

## 2. Engenharia reversa e análise de baixo nível

### Global (inglês)

| Canal | Foco |
| :--- | :--- |
| LiveOverflow | Engenharia reversa, exploração de binários, CTFs e segurança ofensiva |
| LaurieWired | Análise de malware, RE de Android (APK/ARM) e uso prático do Ghidra |
| Low Level (antigo Low Level Learning) | Programação de sistemas, C/Assembly, vulnerabilidades e internos de compiladores/SO |
| Stacksmashing | RE de hardware, firmware, embarcados e protocolos proprietários |
| OALabs | Análise de malware, desempacotamento e uso avançado de IDA Pro / x64dbg |
| Guided Hacking | RE de memória, manipulação de processos e análise de binários Windows |

### Brasil (português)

| Canal | Foco |
| :--- | :--- |
| Papo Binário (Mente Binária) | RE, Assembly e análise de binários (ELF/PE) e malware; conduzido por Fernando Mercês |

## 3. Fontes primárias (antes de virarem vídeo)

Monitorar via RSS ou CLI capta projetos no dia do lançamento, sem depender do algoritmo:

| Fonte | Acesso |
| :--- | :--- |
| GitHub Trending | https://github.com/trending (filtro diário/semanal por linguagem) |
| selfh.st | Diretório e newsletter semanal de lançamentos self-hosted |
| Awesome Selfhosted | `awesome-selfhosted/awesome-selfhosted` |
| Awesome Reverse Engineering | `tylerha97/awesome-reversing` |
| Hacker News (Show HN) | https://news.ycombinator.com/show |

## 4. Operação

O formato canônico de `channels.txt` é `<dominio> <url_do_canal>/videos`. O sufixo
`/videos` evita misturar Shorts e Lives na contagem dos últimos N vídeos.

O monitoramento é feito por [`scripts/check_channels.sh`](../scripts/check_channels.sh),
que consulta apenas metadados (`--flat-playlist --playlist-end`) e deduplica pelo
ID do vídeo contra `urls.txt`.

> Ao ampliar `channels.txt`, a fila cresce no próximo `make channels`. Os vídeos
> novos precisam aparecer na seção de pendentes do [`INDEX.md`](../INDEX.md), ou a
> validação falha — por decisão, o fluxo de atualização automática do `INDEX.md`
> ainda não existe (ver [`HANDOFF.md`](../HANDOFF.md)).
