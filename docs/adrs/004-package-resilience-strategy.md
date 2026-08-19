---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Estratégia de resiliência para packages Typst

## Context and Problem Statement

Queremos usar packages Typst (para posters, diagramas, plots) mas sem ficar vulnerável a packages que morram ou parem de ser mantidos. Como balancear conveniência (usar packages prontos) com resiliência (não depender de algo que pode morrer)?

## Decision Drivers

* Não queremos manter todo o código — packages mantidos por outros são valiosos
* Não queremos que o sistema quebre se um package morrer
* Typst pina versão exata no import — código antigo funciona forever
* Packages "finos" (poucas linhas, funções simples) são fáceis de substituir

## Considered Options

* **Vendorizar tudo** — Copiar código de packages para dentro do repo
* **Depender livremente** — Usar qualquer package sem preocupação
* **Camadas de confiança** — Confiar em packages saudáveis, ter plano B para arriscados

## Decision Outcome

Chosen option: **Camadas de confiança**, baseada em pesquisa de saúde (Ago 2026):

**Confiáveis (bus factor >1, ativos em 2026):**
| Package | Stars | Contributors | Último push |
|---------|-------|-------------|-------------|
| CeTZ | 1824 | 54 | Jul 2026 |
| Lilaq | 827 | 18 | Ago 2026 |
| touying | 2293 | 42 | Ago 2026 |

**Aceitáveis (código fino, fácil de internalizar):**
| Package | Stars | Risco | Plano B |
|---------|-------|-------|---------|
| peace-of-posters | 121 | Bus factor=1 | ~5 funções, trivial de copiar |
| catppuccin | 71 | Org multi-plataforma | Definir cores no style.yml |

**Arriscados (evitar dependência pesada):**
| Package | Stars | Problema | Alternativa |
|---------|-------|----------|-------------|
| postercise | 10 | 1 contrib, inativo 1 ano | Usar peace-of-posters ou puro |
| abntyp | 9 | 1 contrib, projeto acadêmico | Extrair regras ABNT para nosso template |
| splash | 61 | Parado 16 meses | Paletas no style.yml |

### Consequences

* Good: Packages saudáveis (CeTZ, Lilaq, touying) oferecem funcionalidade testada sem custo de manutenção
* Good: Versão pinada = se package morrer, código continua funcionando na versão congelada
* Good: Templates base (banner.typ) não dependem de NENHUM package externo — Typst puro
* Bad: Para packages arriscados, eventualmente podemos precisar internalizar (~50 linhas cada)
* Neutral: Pesquisa de saúde deve ser refeita periodicamente (ex: anualmente)

### Confirmation

`templates/banner.typ` não importa nenhum package externo (`@preview/...`). Verificado via grep. SKILL.md documenta quais packages são seguros para uso.
