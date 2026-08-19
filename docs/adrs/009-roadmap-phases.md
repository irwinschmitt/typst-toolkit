---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Roadmap de implementação em fases

## Context and Problem Statement

O projeto tem escopo amplo (banners, posters, figuras, ABNT, múltiplos estilos, prompts standalone). Precisamos de um caminho incremental que entregue valor cedo e permita validação a cada passo.

## Decision Drivers

* Entregar valor rápido (algo funcional antes de ser "perfeito")
* Validar com caso de uso real antes de expandir
* Não gastar esforço em features que talvez não sejam usadas
* Cada fase deve ser independente e testável

## Roadmap Definido

### ✅ Fase 0+1+2 — Setup + Template + SKILL.md (COMPLETA)
- Typst CLI instalado
- typst-mcp configurado
- Design tokens (style.yml)
- Template de banner funcional (90cm × 120cm)
- SKILL.md para agentes de IA
- README documentado
- Verificação end-to-end passando

### 🔲 Fase 3 — Caso Real
- Pesquisador fornece rascunho de banner real
- Extrair estilo do rascunho → atualizar style.yml
- Ajustar template para layout do caso real
- Iterar: IA gera → compara com rascunho → ajusta
- **Entregável:** Banner real pronto para impressão, gerado pela IA

### 🔲 Fase 4 — ABNT e Refinamentos
- Regras ABNT relevantes no SKILL.md (NBR 15437 para poster)
- Variante `styles/abnt.yml`
- Modo "ABNT" vs "livre"
- **Nota:** Package abntyp existe (9⭐, 1 contrib) como referência, mas não como dependência

### 🔲 Fase 5 — Expansão
- `templates/poster.typ` (A0, 48x36")
- `templates/graphical-abstract.typ` (formato journal)
- Integração com Lilaq/CeTZ para figuras
- Prompts standalone para ChatGPT/Claude web (sem agent)
- Quarto como opção de input (para quem quer Markdown)

## Decision Outcome

O roadmap é incremental — cada fase pode ser executada independentemente. A validação real acontece na Fase 3 (caso de uso concreto). Fases 4 e 5 só são iniciadas após Fase 3 confirmar que a abordagem funciona na prática.

### Consequences

* Good: Fase 0-2 já completa — sistema funcional hoje
* Good: Fase 3 força validação com caso real (evita over-engineering)
* Good: Fases 4-5 são opcionais até ter feedback do uso real
* Neutral: O roadmap pode ser reordenado conforme necessidade do pesquisador
