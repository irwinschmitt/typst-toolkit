---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Não usar Quarto como camada intermediária

## Context and Problem Statement

Quarto permite escrever em Markdown (.qmd) e renderizar via Typst. Isso simplificaria o input para pesquisadores que não querem aprender Typst. Devemos incluí-lo na stack?

## Decision Drivers

* Simplicidade do setup (menos dependências = menos coisas que quebram)
* A IA é quem gera o código, não o pesquisador diretamente
* Quarto adiciona ~200MB de dependências + Python/mamba
* Controle total do layout (Quarto abstrai coisas que podem atrapalhar)

## Considered Options

* **Typst puro (sem Quarto)** — IA gera .typ diretamente
* **Quarto + Typst** — Markdown como input, Typst como backend
* **Quarto como opção futura** — Não incluir agora, adicionar depois se necessário

## Decision Outcome

Chosen option: **Typst puro (sem Quarto)**, com possibilidade de adicionar Quarto como opção no futuro (Fase 5 do roadmap).

### Consequences

* Good: Setup mínimo — só Typst CLI (15MB) é obrigatório para compilar
* Good: IA trabalha diretamente com Typst (sem camada intermediária que pode falhar)
* Good: Controle total do layout — nada é abstraído ou escondido
* Bad: Se o pesquisador quiser editar sem IA, precisa lidar com Typst markup (mais complexo que Markdown)
* Neutral: Quarto pode ser adicionado depois como "opção de input" sem quebrar nada existente

### Confirmation

O projeto funciona sem Quarto instalado. Compilação usa apenas `typst compile`. Nenhuma dependência em Quarto no workflow atual.
