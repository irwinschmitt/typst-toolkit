---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Arquitetura agent-agnostic via MCP

## Context and Problem Statement

O toolkit será operado principalmente por agentes de IA. Existem muitos agents no mercado (Claude Code, Kiro, OpenCode, Cline, Cursor, VS Code Agent, Aider). Precisamos decidir: acoplar a um agent específico ou ser compatível com todos?

## Decision Drivers

* Não ficar preso a um vendor (se um agent morrer ou mudar de preço, o sistema continua)
* Aproveitar o ecossistema existente de MCP servers
* Manter simplicidade (não criar N integrações para N agents)
* OpenCode é open source com 199k⭐ — alternativa viável a qualquer momento

## Considered Options

* **MCP como protocolo universal** — Um server funciona em todos os agents que suportam MCP
* **SKILL.md + Claude-specific** — Otimizar para Claude Code/Kiro especificamente
* **Custom API / plugin por agent** — Criar integrações separadas para cada tool

## Decision Outcome

Chosen option: **MCP como protocolo universal**, combinado com SKILL.md para conhecimento.

O toolkit exporta 2 interfaces:
1. **MCP Server (typst-mcp)** — funciona em QUALQUER agent com MCP support
2. **SKILL.md** — funciona em qualquer agent que leia arquivos de contexto

Se um agent morrer, troca-se o agent. O toolkit não muda.

### Consequences

* Good: Funciona com Claude Code, Kiro, OpenCode (199k⭐, MIT), Cline, Cursor, Aider
* Good: Se OpenCode (open source) evoluir, podemos migrar sem custo
* Good: MCP é padrão da indústria (Linux Foundation governance, 10k+ servers)
* Bad: Não otimizamos para features específicas de nenhum agent
* Neutral: SKILL.md funciona como fallback — mesmo sem MCP, a IA lê e opera

### Confirmation

mcp.json configurado e funcional. Testado com Kiro. O mesmo server funcionaria em Claude Code, OpenCode, ou qualquer MCP client.
