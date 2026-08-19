# Architecture Decision Records (ADRs)

Este diretório documenta as decisões arquiteturais do projeto `typst-toolkit` usando o formato [MADR](https://adr.github.io/madr/) (Markdown Any Decision Records).

## O que é um ADR?

Um ADR (Architecture Decision Record) registra uma decisão arquitetural importante junto com seu contexto, opções consideradas e consequências. Servem para que qualquer pessoa possa entender **por que** as coisas são como são, sem precisar rastrear conversas antigas.

## Índice

| ADR | Título | Status | Data |
|-----|--------|--------|------|
| [001](001-typst-as-foundation.md) | Typst como fundação do toolkit | Accepted | 2026-08-19 |
| [002](002-agent-agnostic-via-mcp.md) | Arquitetura agent-agnostic via MCP | Accepted | 2026-08-19 |
| [003](003-no-quarto.md) | Não usar Quarto como camada intermediária | Accepted | 2026-08-19 |
| [004](004-package-resilience-strategy.md) | Estratégia de resiliência para packages Typst | Accepted | 2026-08-19 |
| [005](005-style-system-yaml-tokens.md) | Sistema de estilo via design tokens YAML | Accepted | 2026-08-19 |
| [006](006-liberation-sans-default-font.md) | Liberation Sans como fonte padrão | Accepted | 2026-08-19 |
| [007](007-no-custom-scripts.md) | Sem shell scripts customizados | Accepted | 2026-08-19 |
| [008](008-typst-mcp-not-forked.md) | Usar typst-mcp sem fork (por enquanto) | Accepted | 2026-08-19 |
| [009](009-roadmap-phases.md) | Roadmap de implementação em fases | Accepted | 2026-08-19 |

## Convenções

- Novos ADRs recebem o próximo número sequencial
- Status possíveis: `proposed`, `accepted`, `deprecated`, `superseded by ADR-XXX`
- Escrever em português (decisões) ou inglês (termos técnicos sem tradução direta)
- Um ADR nunca é deletado — se superado, marca-se como `superseded`
