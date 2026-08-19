---
status: accepted
date: 2026-08-19
decision-makers: irwinschmitt
---

# Sem shell scripts customizados

## Context and Problem Statement

Projetos frequentemente criam scripts de setup (`setup.sh`, `install.sh`, `validate.sh`). Estes scripts tendem a ficar obsoletos quando as ferramentas mudam seus métodos de instalação. Como garantir que as instruções de setup permaneçam corretas a longo prazo?

## Decision Drivers

* Manutenibilidade a longo prazo (o projeto deve funcionar anos sem manutenção de scripts)
* Ferramentas mudam métodos de instalação frequentemente
* Documentar comandos individuais é mais transparente e auditável
* Se um comando muda, atualizar 1 linha no README é trivial; atualizar lógica de script é mais complexo

## Considered Options

* **Shell scripts de setup** — Automatizar tudo em um `setup.sh`
* **Makefile** — Targets para install, validate, etc.
* **Comandos documentados no README** — Cada passo é um comando individual que o usuário executa
* **Docker** — Containerizar todo o ambiente

## Decision Outcome

Chosen option: **Comandos documentados no README**, porque:
- Cada ferramenta é instalada pelo seu método oficial recomendado
- Se uma ferramenta muda (ex: Typst adiciona novo instalador), atualiza-se 1 linha no README
- O usuário vê exatamente o que está sendo executado (transparência)
- Não há lógica condicional que pode falhar silenciosamente
- Funciona em qualquer ambiente Ubuntu 22+ sem adaptação

### Consequences

* Good: Zero manutenção de scripts — README é a single source of truth
* Good: Transparente — usuário entende cada passo
* Good: Cada comando é testável individualmente
* Bad: Setup manual é mais passos para o usuário (7 passos vs 1 `./setup.sh`)
* Neutral: Se no futuro algo for muito complexo, um script temporário pode ser criado e removido após uso

### Confirmation

O projeto não tem diretório `scripts/`. Instalação funciona seguindo os passos do README. Seção "Verificação" no README permite confirmar cada componente independentemente.
