# Tasks

## Task 1: Project Scaffolding [REQ-3]

- [x] 1.1: Create directories: `templates/`, `styles/`, `examples/`, `fonts/`
- [x] 1.2: Create `.gitignore` with rules for `.mcp-server/`, `*.pdf`, `output/`, `.DS_Store`, `Thumbs.db`, `.vscode/`, `.idea/`, `.typst/`
- [x] 1.3: Create skeleton `README.md` with placeholder sections (Project Overview, Architecture, Prerequisites, Installation, Directory Structure, Usage, Verification, Troubleshooting, Updating, Font Substitution)

## Task 2: Typst CLI Installation [REQ-1] [depends:1]

- [x] 2.1: Install Rustup if not present: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source "$HOME/.cargo/env"`
- [x] 2.2: Install Typst CLI: `cargo install typst-cli`
- [x] 2.3: Verify installation: `typst --version` must show >= 0.14

## Task 3: Font Provisioning [REQ-4] [depends:1]

- [x] 3.1: Install Liberation Sans system-wide: `sudo apt install -y fonts-liberation`
- [x] 3.2: Copy Liberation Sans .ttf files (Regular, Bold, Italic, BoldItalic) from `/usr/share/fonts/truetype/liberation/` to `fonts/` directory
- [x] 3.3: Verify font works: compile a test .typ file using `#set text(font: "Liberation Sans")` with `--font-path fonts/`

## Task 4: Design Tokens [REQ-5] [depends:1]

- [x] 4.1: Create `styles/default.yml` with design tokens (colors, fonts, sizes, spacing) as defined in design.md
- [x] 4.2: Verify YAML is valid and loadable by Typst's `yaml()` function

## Task 5: Banner Template [REQ-6] [depends:4]

- [x] 5.1: Create `templates/banner.typ` with `banner` function accepting: title, authors, institution, sections, logo, width (90cm), height (120cm), style-path
- [x] 5.2: Implement layout using only Typst built-in primitives (block, grid, stack, rect, place) — no external packages
- [x] 5.3: Load and apply style from YAML using `rgb()` for colors and `eval()` for sizes

## Task 6: Banner Example [REQ-6] [depends:2,3,5]

- [x] 6.1: Create `examples/banner-example.typ` importing the banner template with sample academic content (title, 3 authors, 3 sections)
- [x] 6.2: Verify compilation: `typst compile --font-path fonts/ examples/banner-example.typ /tmp/banner-test.pdf` succeeds
- [x] 6.3: Verify output PDF is valid and has correct dimensions (90cm × 120cm)

## Task 7: typst-mcp Server Setup [REQ-2] [depends:2]

- [x] 7.1: Install uv if not present: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- [x] 7.2: Clone typst-mcp: `git clone https://github.com/johannesbrandenburger/typst-mcp.git .mcp-server/typst-mcp`
- [x] 7.3: Create venv and install dependencies: `cd .mcp-server/typst-mcp && uv venv && uv pip install -r requirements.txt`
- [x] 7.4: Install Pandoc: `sudo apt install -y pandoc`
- [x] 7.5: Verify server module is importable: `cd .mcp-server/typst-mcp && uv run python -c "import server; print('OK')"`

## Task 8: MCP Configuration [REQ-2] [depends:7]

- [x] 8.1: Create `mcp.json` at project root with typst-mcp server config using `uv run` command
- [x] 8.2: Verify mcp.json is valid JSON

## Task 9: SKILL.md [REQ-7] [depends:5,6,8]

- [x] 9.1: Create `SKILL.md` with all 9 sections: Project Overview, Directory Map, Quick Start, Template API Reference, Style System, Rules, Safe Packages, Examples, Troubleshooting
- [x] 9.2: Include at least 2 complete .typ code examples (input→output)
- [x] 9.3: Verify SKILL.md is under 500 lines and references banner.typ, styles/default.yml, --font-path fonts/, mcp.json

## Task 10: README Completion [REQ-3,REQ-8] [depends:9]

- [x] 10.1: Write complete README.md with all 10 sections (Project Overview, Architecture with WHY justifications, Prerequisites, Installation commands, Directory Structure, Usage, Verification commands, Troubleshooting with 4+ scenarios, Updating, Font Substitution)
- [x] 10.2: Ensure README is accessible to non-technical users (explains Typst, MCP, AI agents in plain language, explains why Liberation Sans instead of Arial)
- [x] 10.3: Verify all commands in Installation and Verification sections are accurate and runnable

## Task 11: End-to-End Verification [REQ-8] [depends:10]

- [x] 11.1: Run all verification commands from README and confirm they pass
- [x] 11.2: Verify `typst compile --font-path fonts/ examples/banner-example.typ` produces valid PDF (90cm × 120cm)
- [x] 11.3: Verify mcp.json is valid and .mcp-server/typst-mcp exists
- [x] 11.4: Verify all cross-references between files are consistent (SKILL.md paths match real files, README commands work)
