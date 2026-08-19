# Requirements Document

## Introduction

Este documento captura os requisitos para o setup inicial do repositório `typst-toolkit` — um toolkit para geração de banners, posters e figuras científicas usando Typst, assistido por IA.

**Contexto do projeto:**

O `typst-toolkit` é um sistema para pesquisadores gerarem material científico visual (banners, posters, figuras) de forma simples, usando Typst como engine de tipografia e IA como facilitadora. A arquitetura é agent-agnostic — funciona com qualquer agent que suporte MCP (Kiro, Claude Code, OpenCode, Cline, Cursor, etc).

**Constraint atualizada:** Este projeto NÃO usa shell scripts customizados (`setup.sh`, `validate.sh`, etc.). Todas as ferramentas são instaladas via seus métodos oficiais recomendados, e os passos são documentados como comandos individuais no README. Isso garante manutenibilidade a longo prazo — scripts customizados ficam obsoletos quando ferramentas mudam seus métodos de instalação.

**Decisões arquiteturais já tomadas:**

1. **Fundação: Typst CLI** — Sistema de tipografia moderno (55k⭐, 457 contributors, Apache-2.0). Binário único de ~15MB, sem dependências. Compila em sub-segundo. Versão pinada por design nos imports (`@preview/pkg:version`). Instalado via método oficial: `cargo install typst-cli`.

2. **Camada IA: MCP (Model Context Protocol)** — Protocolo universal suportado por todos os agents principais. Usamos o `typst-mcp` (johannesbrandenburger) como MCP server — 173⭐, MIT, Python, 14KB. Fornece: docs Typst, validação de sintaxe, conversão LaTeX→Typst, render para PNG.

3. **Conhecimento: SKILL.md** — Arquivo que ensina à IA como gerar material científico em Typst. Contém defaults, regras, exemplos.

4. **Estilo: design tokens em YAML** — Arquivo `style.yml` define cores, fontes, espaçamentos. Templates consomem esse YAML. 100% substituível.

5. **Font padrão: Liberation Sans** — Equivalente livre do Arial (metricamente idêntica). Substituível por qualquer .ttf/.otf. Instalada via `sudo apt install fonts-liberation` ou commitada em `fonts/`.

6. **Sem Quarto** — Typst puro, sem camada intermediária. IA trabalha diretamente com .typ.

7. **Prova de conceito: banner** — O primeiro output funcional é um banner científico vertical (90cm × 120cm).

8. **Sem scripts customizados** — Cada ferramenta é instalada via seu método oficial. Passos documentados como comandos no README. Nenhum `scripts/setup.sh` ou similar.

9. **Target: Ubuntu 22+** — Qualquer sistema Linux baseado em Ubuntu 22 ou mais recente. Não restrito a WSL2.

**Packages Typst confiáveis (pesquisa de saúde realizada Ago 2026):**
- CeTZ (1824⭐, 54 contrib) — diagramas/desenho
- Lilaq (827⭐, 18 contrib) — gráficos/plots publication-ready
- touying (2293⭐, 42 contrib) — slides/apresentações
- peace-of-posters (121⭐, código fino) — posters (plano B trivial se morrer)

**Packages com risco (usar com cautela, plano B documentado):**
- abntyp (9⭐, 1 contrib) — ABNT (extrair regras se morrer)
- splash (61⭐, parado) — paletas de cores (definir no style.yml)

**Estrutura de pastas alvo:**
```
typst-toolkit/
├── templates/          # Templates .typ (banner, poster, etc)
├── styles/             # Design tokens YAML (style.yml, abnt.yml)
├── examples/           # Exemplos de uso
├── fonts/              # Liberation Sans .ttf (commitado)
├── SKILL.md            # Instruções para IA
├── mcp.json            # Config do typst-mcp
└── README.md           # Documentação do projeto
```

**Output Location:** Repositório `git@github.com:irwinschmitt/typst-toolkit.git` em `/home/irwinschmitt/Projects/typst-toolkit`.

## Glossary

- **Typst**: Sistema de tipografia moderno, alternativa ao LaTeX. Binário único, compila em ms, sintaxe markup simples. Usa algoritmo Knuth-Plass para line-breaking (mesmo do TeX). Desde v0.14 suporta microtypografia.
- **MCP (Model Context Protocol)**: Protocolo padrão para conectar agentes de IA a ferramentas externas. Suportado por Claude Code, Kiro, OpenCode, Cline, Cursor, VS Code Agent Mode.
- **typst-mcp**: MCP server open source (MIT, Python) que expõe ferramentas Typst para agentes de IA: docs, validação, conversão LaTeX→Typst, render PNG.
- **SKILL.md**: Arquivo Markdown que ensina capabilities específicas a um agente de IA. O agente lê o SKILL.md e segue as instruções para operar no repo.
- **Design_Tokens**: Variáveis de estilo (cores, fontes, espaçamentos) definidas em YAML, consumidas por templates Typst. Permitem separar conteúdo de apresentação visual.
- **Liberation_Sans**: Fonte livre metricamente compatível com Arial. Distribuída com Linux. Aceita em contextos acadêmicos ABNT.
- **Typst_Universe**: Registro oficial de packages e templates Typst. Packages são pinados por versão exata no import.
- **Tinymist**: Language service para Typst (LSP + preview). Funciona em VS Code, Kate, Neovim. Fornece live preview, autocomplete, cross-jump código↔PDF.
- **peace-of-posters**: Package Typst para criar posters científicos com API minimalista (~5 funções). Código fino, fácil de internalizar se necessário.
- **CeTZ**: Biblioteca de desenho do Typst (inspirada em TikZ + Processing). Base para packages de diagramas (fletcher, chronos, circuiteria).
- **Lilaq**: Biblioteca de plotting publication-ready para Typst. Real-time preview, integração seamless.
- **uv**: Gerenciador de pacotes Python ultra-rápido da Astral. Substitui pip+venv com melhor performance e resolução de dependências.
- **Rustup**: Instalador e gerenciador de toolchain oficial do Rust. Instala cargo, rustc, e gerencia versões.

## Requirements

### Requirement 1: Instalação e Verificação do Typst CLI

**User Story:** As a developer setting up the toolkit, I want Typst CLI installed and verified, so that I can compile .typ files into PDF locally.

#### Acceptance Criteria

1. THE README SHALL document the official Typst CLI installation method: `cargo install typst-cli` (via rustup), with prerequisite commands for installing Rust if not present.
2. WHEN Typst is installed, THE developer SHALL be able to verify it works by running `typst --version` and seeing a version >= 0.14.
3. THE README SHALL document an alternative installation path for users who already have Typst installed via another method (package manager, binary download) — any `typst` on PATH with version >= 0.14 is sufficient.
4. THE README SHALL document how to update Typst: `cargo install typst-cli` (re-running installs the latest version).
5. THE installed Typst version SHALL support microtypography features (v0.14+), verifiable by compiling a test file that uses `#set par(justify: true)`.

### Requirement 2: Instalação e Configuração do typst-mcp Server

**User Story:** As a developer, I want the typst-mcp MCP server installed and configured, so that any AI agent (Kiro, Claude Code, OpenCode) can validate Typst code, render previews, and access documentation.

#### Acceptance Criteria

1. THE README SHALL document step-by-step commands to install the typst-mcp server: install uv (official installer), clone the repo into `.mcp-server/typst-mcp`, create venv, install dependencies.
2. WHEN the MCP server is installed, THE project SHALL include a `mcp.json` configuration file at the project root that any MCP-compatible agent can use to connect to the server.
3. THE MCP server SHALL respond correctly to all 5 tools: `list_docs_chapters`, `get_docs_chapter`, `latex_snippet_to_typst`, `check_if_snippet_is_valid_typst_syntax`, and `typst_to_image`.
4. THE README SHALL document how to verify the MCP server works: importing the server module successfully, and checking the mcp.json is valid JSON.
5. THE `mcp.json` SHALL use a local Python command via uv as the server execution method.
6. THE README SHALL document how to update typst-mcp: `cd .mcp-server/typst-mcp && git pull && uv pip install -r requirements.txt`.

### Requirement 3: Estrutura de Diretórios do Projeto

**User Story:** As a developer, I want a clear project structure with designated locations for templates, styles, examples, and AI instructions, so that both humans and AI agents can navigate the project predictably.

#### Acceptance Criteria

1. THE project SHALL have the following directory structure:
   - `templates/` — Typst template files (.typ)
   - `styles/` — Design token files (.yml)
   - `examples/` — Example usage files
   - `fonts/` — Font files (committed to repo)
   - Root files: `SKILL.md`, `mcp.json`, `README.md`, `.gitignore`
2. THE project SHALL NOT have a `scripts/` directory. All setup and validation steps are documented as commands in the README.
3. THE `README.md` SHALL document: project purpose, architecture decisions (with justifications), installation instructions (individual commands), directory structure, usage, verification, and troubleshooting.
4. THE project structure SHALL NOT depend on any external tool besides Typst CLI and the MCP server — no Quarto, no Node.js, no build system required for basic operation.
5. THE README SHALL be accessible to non-technical users, explaining what Typst, MCP, and AI agents are in plain language.

### Requirement 4: Font Padrão Instalada e Verificada

**User Story:** As a developer, I want the default font (Liberation Sans) available to Typst, so that templates render correctly without requiring proprietary fonts.

#### Acceptance Criteria

1. THE README SHALL document two approaches for font provisioning:
   - **System-wide (recommended):** `sudo apt install -y fonts-liberation`
   - **Project-local (for portability):** Use the font files committed in the `fonts/` directory with `--font-path fonts/`
2. WHEN Typst compiles a file using `#set text(font: "Liberation Sans")` with `--font-path fonts/`, THE compilation SHALL succeed without "unknown font" warnings.
3. THE `fonts/` directory SHALL contain the Liberation Sans font family (Regular, Bold, Italic, Bold Italic) committed to the repository, ensuring the project works on any machine regardless of system fonts installed.
4. THE README SHALL explain WHY Liberation Sans was chosen: it is metrically identical to Arial (the output looks exactly the same) but is free/libre and included in Linux distributions.
5. THE README SHALL document how to substitute a different font: drop .ttf/.otf files into `fonts/`, update `styles/default.yml`, and recompile.

### Requirement 5: Design Tokens Base (style.yml)

**User Story:** As a developer, I want a default style configuration file that templates can consume, so that all outputs have a consistent, professional appearance out-of-the-box while remaining fully customizable.

#### Acceptance Criteria

1. THE project SHALL include `styles/default.yml` containing at minimum: color palette (primary, secondary, accent, background, text), font families (title, body), font sizes (title, subtitle, body, caption), and spacing values (margins, padding, gap).
2. THE `styles/default.yml` SHALL use colors and fonts that produce professional-looking output suitable for academic conferences.
3. WHEN a template reads `styles/default.yml`, THE template SHALL be able to parse all values using Typst's native YAML loading (`yaml("styles/default.yml")`).
4. THE style system SHALL allow creating alternative style files (e.g., `styles/abnt.yml`, `styles/dark.yml`) that override the defaults without modifying the template code.
5. THE default style SHALL use Liberation Sans as the font family, with clearly documented instructions for substituting other fonts.

### Requirement 6: Template de Banner Mínimo Funcional

**User Story:** As a developer, I want a minimal banner template that compiles successfully using the default style, so that I can verify the entire pipeline works end-to-end (Typst + style.yml + template → PDF).

#### Acceptance Criteria

1. THE project SHALL include `templates/banner.typ` — a minimal but functional banner template that reads from `styles/default.yml`.
2. WHEN `typst compile --font-path fonts/ examples/banner-example.typ` is run, THE output SHALL be a valid PDF with correct dimensions (vertical, 90cm × 120cm), the default font, and placeholder content.
3. THE banner template SHALL accept parameters: title, authors, institution, sections (list of heading+content), optional logo path, and optional dimensions (defaulting to 90cm × 120cm vertical).
4. THE `examples/banner-example.typ` SHALL demonstrate usage of the banner template with sample academic content, serving as both a test and documentation.
5. THE banner template SHALL NOT depend on any external Typst package — it SHALL use only Typst built-in functions and the style.yml, ensuring zero risk of package abandonment.

### Requirement 7: SKILL.md Inicial

**User Story:** As a developer, I want a SKILL.md file that teaches AI agents how to use the toolkit, so that any MCP-compatible agent can generate banners from natural language descriptions.

#### Acceptance Criteria

1. THE project SHALL include a `SKILL.md` at the project root containing: project overview, directory structure, how to generate a banner (step-by-step), style.yml reference, template parameters reference, and at least 2 examples of input→output.
2. WHEN an AI agent reads the SKILL.md and receives a request like "gere um banner sobre machine learning com 3 seções", THE agent SHALL have enough information to produce a valid .typ file that compiles to PDF.
3. THE SKILL.md SHALL document the default style and explicitly state "if the user doesn't specify style preferences, use styles/default.yml".
4. THE SKILL.md SHALL include a "Rules" section stating: (a) always validate with typst-mcp before delivering, (b) use built-in Typst functions over external packages when possible, (c) respect the style.yml values, (d) any custom request that deviates from defaults is valid — do not restrict creativity.
5. THE SKILL.md SHALL document which packages are safe to use (CeTZ, Lilaq, touying) and which to avoid depending on heavily, with brief justification.

### Requirement 8: Validação End-to-End

**User Story:** As a developer, I want to verify that the entire pipeline works — from AI receiving a request, through template generation, to PDF output — so that I know the setup is complete and functional.

#### Acceptance Criteria

1. THE README SHALL include a "Verification" section with individual commands to verify each component: Typst CLI version, font availability, style file validity, template compilation, MCP server presence, and SKILL.md completeness.
2. WHEN all verification commands pass, THE developer SHALL be able to ask an AI agent (via SKILL.md + typst-mcp) to "generate a banner about X" and receive a compilable .typ file.
3. THE verification SHALL confirm that `typst compile --font-path fonts/ examples/banner-example.typ` produces a valid PDF.
4. THE README SHALL provide a Troubleshooting section with common error messages and their resolutions (at least 4 scenarios).
5. THE setup SHALL be considered complete ONLY when: (a) `typst compile` works, (b) typst-mcp is installed and mcp.json is valid, (c) Liberation Sans is available (in `fonts/` or system-wide), (d) `examples/banner-example.typ` compiles to a correct PDF, (e) SKILL.md is present and references all project components correctly.
