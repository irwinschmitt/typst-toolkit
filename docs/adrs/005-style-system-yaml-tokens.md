---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Sistema de estilo via design tokens YAML

## Context and Problem Statement

Precisamos que o visual dos outputs seja: (1) bonito por padrão, (2) totalmente customizável, (3) fácil de trocar sem mexer em código. Como separar "o que é conteúdo" de "como parece visualmente"?

## Decision Drivers

* Pesquisador deve poder trocar cores/fontes sem saber Typst
* IA deve poder aplicar estilos diferentes sem reescrever templates
* Diferentes eventos/instituições podem ter estilos próprios
* Style deve ser um arquivo separado (não hardcoded no template)

## Considered Options

* **YAML tokens (style.yml)** — Arquivo com variáveis de estilo, template consome
* **Parâmetros diretos no template** — Passar cores/fontes como argumentos
* **CSS-like system** — Definir estilos em formato parecido com CSS
* **Typst theming packages** — Usar catppuccin ou similar

## Decision Outcome

Chosen option: **YAML tokens**, porque:
- Typst tem `yaml()` nativo — carrega YAML sem dependência externa
- YAML é legível por humanos e por IA
- Separação clara: conteúdo no .typ, visual no .yml
- Múltiplos estilos são apenas múltiplos .yml files

O estilo definitivo será derivado de um caso de uso real (rascunho do pesquisador), não do default genérico atual.

### Consequences

* Good: Trocar visual = editar um .yml (não precisa saber Typst)
* Good: IA pode criar estilos novos gerando YAML
* Good: Versionável — cada evento/instituição pode ter seu .yml commitado
* Bad: Valores em string precisam de `eval()` no template (complexidade interna)
* Neutral: O default atual é temporário — será refinado com o caso real

### Confirmation

`styles/default.yml` existe e é consumido por `templates/banner.typ` via `yaml()`. Compilação funciona. Template aceita `style-path` como parâmetro para trocar estilos.
