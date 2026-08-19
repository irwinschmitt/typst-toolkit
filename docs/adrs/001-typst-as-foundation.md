---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Typst como fundação do toolkit

## Context and Problem Statement

Precisamos de um engine de tipografia para gerar banners, posters e figuras científicas programaticamente. O engine deve: compilar rápido (para iteração com IA), produzir PDFs de qualidade profissional, ser simples o suficiente para que IAs gerem código confiável, e ser estável a longo prazo.

## Decision Drivers

* Qualidade tipográfica profissional (nível LaTeX)
* Velocidade de compilação (sub-segundo para iteração com IA)
* Simplicidade da sintaxe (menos erros de IA)
* Estabilidade e manutenção do projeto (55k⭐, 457 contributors)
* Setup mínimo (binário único de 15MB)
* Packages pinados por versão exata (proteção contra breaking changes)

## Considered Options

* **Typst** — Sistema moderno, compila em ms, Knuth-Plass, microtypografia desde v0.14
* **LaTeX** — Padrão acadêmico há décadas, ecossistema imenso, mas setup pesado (GB) e compilação lenta (minutos)
* **HTML/CSS → PDF** — LLMs dominam HTML, mas controle de dimensão para impressão é frágil
* **python-pptx** — Output PPTX editável, mas binário (sem diff), design limitado

## Decision Outcome

Chosen option: **Typst**, porque:
- Usa o mesmo algoritmo de line-breaking do TeX (Knuth-Plass) — qualidade tipográfica equivalente para posters
- Compila em sub-segundo — permite iteração rápida com IA
- Desde v0.14 tem microtypografia (character-level justification)
- Binário único de 15MB, sem dependências
- Packages pinados por versão exata no import — código não quebra quando package atualiza
- 55k⭐, 457 contributors, push diário — projeto extremamente saudável

### Consequences

* Good: Compilação instantânea permite workflow IA → validação → preview em segundos
* Good: Texto puro = versionável com Git, diffável, code-reviewable
* Good: Qualidade visual indistinguível do LaTeX para posters (pesquisa confirmou)
* Bad: LLMs geram Typst com erros menores (menos training data que LaTeX)
* Bad: Ecossistema de packages menor que LaTeX (mas crescendo rápido)
* Neutral: Para posters/banners, as limitações vs LaTeX são irrelevantes (papers densos seriam outro caso)

### Confirmation

Verificado via pesquisa (specs/042-scientific-figures-banners/harness/): múltiplas fontes confirmam "PDFs visually indistinguishable from LaTeX" para o caso de uso de posters. Typst 0.15.1 instalado e funcional no projeto.
