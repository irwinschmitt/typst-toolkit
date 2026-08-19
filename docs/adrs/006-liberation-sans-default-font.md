---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Liberation Sans como fonte padrão

## Context and Problem Statement

Precisamos de uma fonte padrão que: seja profissional, funcione em contextos ABNT, não tenha problemas de licença, e esteja disponível em qualquer Linux.

## Decision Drivers

* ABNT frequentemente exige "Arial" — precisamos de compatibilidade
* Arial é proprietária (Microsoft) — não podemos distribuir no repo
* A fonte deve estar disponível em qualquer Ubuntu 22+ ou ser bundlável
* O resultado visual deve ser indistinguível de Arial

## Considered Options

* **Liberation Sans** — Metricamente idêntica à Arial, livre (SIL Open Font License)
* **Arial** — Padrão de facto, mas proprietária
* **Nimbus Sans** — Clone do Helvetica, livre
* **Inter** — Moderna, excelente legibilidade, mas sem compatibilidade métrica com Arial

## Decision Outcome

Chosen option: **Liberation Sans**, porque:
- É **metricamente idêntica** à Arial — cada caractere ocupa exatamente o mesmo espaço
- O resultado visual é literalmente indistinguível de Arial
- É livre (SIL Open Font License) — pode ser distribuída no repositório
- Vem pré-instalada em Ubuntu via `fonts-liberation`
- É aceita em contextos que pedem "Arial" (incluindo ABNT)

### Consequences

* Good: Compatível com ABNT sem usar fonte proprietária
* Good: Bundled no repo (600KB) — funciona sem instalar nada
* Good: `sudo apt install fonts-liberation` como alternativa system-wide
* Neutral: Se o pesquisador preferir outra fonte, pode trocar no style.yml (documentado no README)

### Confirmation

Fontes em `fonts/`. Compilação com `--font-path fonts/` funciona sem warnings. README explica a equivalência com Arial.
