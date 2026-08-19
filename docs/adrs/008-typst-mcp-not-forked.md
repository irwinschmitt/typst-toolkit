---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Usar typst-mcp sem fork (por enquanto)

## Context and Problem Statement

O typst-mcp (johannesbrandenburger) é um MCP server com 5 ferramentas úteis (docs, validação, conversão, render). Porém tem bus factor=1 e 4 meses sem commits. Devemos forkar e estender, criar nosso próprio, ou usar como está?

## Decision Drivers

* typst-mcp é pequeno (14KB Python) — fácil de substituir se necessário
* Forkar cria responsabilidade de manutenção imediata
* As 5 ferramentas existentes são suficientes para o MVP
* Criar nosso MCP do zero seria equivalente em esforço (código é trivial)
* Não queremos manutenção desnecessária

## Considered Options

* **Usar como está (sem fork)** — Clonar e usar, sem modificar
* **Forkar e estender** — Adicionar tools específicas (generate_poster, apply_abnt, etc.)
* **Criar do zero** — MCP server próprio focado no nosso caso

## Decision Outcome

Chosen option: **Usar como está**, porque:
- As 5 ferramentas existentes (validação, render, docs) são suficientes para validar o pipeline
- O SKILL.md fornece o conhecimento que o MCP não fornece (como fazer um poster, regras ABNT, etc.)
- Forkar agora cria dívida de manutenção sem benefício imediato
- Se no futuro precisarmos de tools custom, podemos forkar OU criar um server complementar

### Consequences

* Good: Zero manutenção de código Python por enquanto
* Good: Se o typst-mcp morrer, substituir é trivial (~14KB para reimplementar)
* Good: Mantemos flexibilidade para decidir no futuro (fork vs novo vs manter)
* Bad: Não temos tools de "criação" no MCP (generate_poster, etc.) — a IA faz isso via SKILL.md
* Neutral: Se o upstream lançar melhorias, `git pull` atualiza automaticamente

### Confirmation

mcp.json aponta para o clone em `.mcp-server/typst-mcp/`. Server importa sem erros. As tools de validação e render funcionam. README documenta como atualizar (`git pull && uv sync`).
