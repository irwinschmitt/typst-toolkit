# Design Document

## Overview

This document specifies the implementation plan for the initial setup of `typst-toolkit` — a Typst-based toolkit for AI-assisted generation of scientific visual material (banners, posters, figures). The setup establishes the foundation: Typst CLI, the typst-mcp server, project structure, fonts, design tokens, a proof-of-concept banner template, the SKILL.md for AI agents, and verification documentation.

The target environment is Ubuntu 22+ (any Linux distribution based on Ubuntu 22 or newer). The design prioritizes long-term maintainability: every tool is installed via its official recommended method, there are no custom shell scripts that could become obsolete, and all steps are documented as individual commands in the README.

**Core principle:** Use standard, official installation methods. Avoid workarounds, clever hacks, or custom scripts. If a tool recommends `cargo install`, use that. If another recommends `apt install`, use that. The goal is a setup that remains correct and maintainable for years.

---

## 1. Typst CLI Installation

### Approach: Official Method — Rustup + Cargo

Typst's official documentation recommends `cargo install typst-cli` as the primary installation method. Since cargo is acceptable in this project, we use the standard Rust toolchain path:

1. Install Rustup (Rust's official toolchain manager):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
   source "$HOME/.cargo/env"
   ```

2. Install Typst CLI via cargo:
   ```bash
   cargo install typst-cli
   ```

3. Verify:
   ```bash
   typst --version
   ```
   Must be >= 0.14 for microtypography support.

**Why this approach:**
- It's what Typst officially recommends.
- Cargo handles updates cleanly: `cargo install typst-cli` always installs the latest version.
- No custom version-detection logic or GitHub API calls needed.
- Works identically on any Linux distribution.

**Alternative (documented in README):** For users who already have Typst installed via another method (package manager, binary download), any working `typst` on PATH with version >= 0.14 is sufficient. The README documents this as "If you already have Typst >= 0.14, skip this step."

**Update path:** Run `cargo install typst-cli` again — cargo replaces the existing binary with the latest version.

---

## 2. typst-mcp Server Setup

### Approach: Local Clone + uv Virtual Environment

The typst-mcp server is a Python project. We use `uv` (Astral's fast Python package manager) to create an isolated virtualenv and install dependencies. No Docker required.

**Installation steps (documented in README):**

1. Install uv (if not present):
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

2. Clone typst-mcp into the project's `.mcp-server/` directory:
   ```bash
   git clone https://github.com/johannesbrandenburger/typst-mcp.git .mcp-server/typst-mcp
   ```

3. Create venv and install dependencies:
   ```bash
   cd .mcp-server/typst-mcp
   uv venv
   uv pip install -r requirements.txt
   ```

4. Install Pandoc (required for LaTeX-to-Typst conversion):
   ```bash
   sudo apt install -y pandoc
   ```

5. Handle Typst docs JSON: Check if `typst-mcp` ships `typst_docs.json` in its repo. If not, document the limitation (some tools may not work without it) and provide instructions to generate it if the user has the full Typst source.

**mcp.json configuration:**

```json
{
  "mcpServers": {
    "typst-mcp": {
      "command": "uv",
      "args": [
        "run",
        "--directory", ".mcp-server/typst-mcp",
        "python", "server.py"
      ],
      "env": {
        "TYPST_PATH": "typst"
      }
    }
  }
}
```

This file lives at the project root. Any MCP-compatible agent (Kiro, Claude Code, OpenCode) reads it to discover available tools.

**Error scenarios (documented in README):**
- If `uv` is not found: install via the official installer shown above.
- If clone fails (network): retry or check internet connection.
- If Python dependencies fail: ensure Python 3.10+ is available (`python3 --version`).
- If Pandoc is missing: `latex_snippet_to_typst` won't work, but other tools (syntax validation, rendering) will.

**Verification:**
```bash
cd .mcp-server/typst-mcp && uv run python -c "import server; print('OK')"
```

---

## 3. Project Structure

The following files and directories compose the project:

```
typst-toolkit/
├── .gitignore              # Ignores .mcp-server/, *.pdf, output/
├── .mcp-server/            # typst-mcp clone + venv (gitignored)
├── fonts/                  # Liberation Sans .ttf files (committed)
│   └── LiberationSans-*.ttf
├── templates/              # Typst template files
│   └── banner.typ
├── styles/                 # Design tokens YAML
│   └── default.yml
├── examples/               # Usage examples
│   └── banner-example.typ
├── SKILL.md                # AI agent instructions
├── mcp.json                # MCP server configuration
└── README.md               # Project documentation
```

**Design decisions:**
- **No `scripts/` directory.** All installation and validation steps are documented as individual commands in the README. Custom shell scripts become obsolete as tools update their installation methods. Individual documented commands are easier to maintain and understand.
- `.mcp-server/` is gitignored because it contains a full git clone + venv (~100MB+). Each developer follows the README steps to populate it.
- `fonts/` is committed to the repo (4 files, ~600KB total). This ensures the project works on any machine without system font dependencies. Users can alternatively install system-wide via apt.
- No `output/` directory committed — PDFs are generated on demand and gitignored.

---

## 4. Font Provisioning

### Approach: Two Options (Both Documented in README)

**Option A — System-wide installation (simplest, recommended):**

```bash
sudo apt install -y fonts-liberation
```

This installs Liberation Sans (and other Liberation fonts) system-wide. Typst automatically finds system fonts. No `--font-path` flag needed when compiling.

**Why this is the simplest:** One command, done forever. Works for all projects on the system. Typst's font discovery finds system fonts automatically.

**Option B — Project-local fonts (for portability):**

The `fonts/` directory in the repo contains the 4 Liberation Sans variants committed directly:
- `LiberationSans-Regular.ttf`
- `LiberationSans-Bold.ttf`
- `LiberationSans-Italic.ttf`
- `LiberationSans-BoldItalic.ttf`

These are sourced from `/usr/share/fonts/truetype/liberation/` (after apt install) or downloaded from the Liberation Fonts GitHub releases.

When using project-local fonts, compile with:
```bash
typst compile --font-path fonts/ <input.typ>
```

**Compilation command standard:**

The project documents both approaches:
- With system fonts: `typst compile <input.typ>`
- With project fonts: `typst compile --font-path fonts/ <input.typ>`

SKILL.md and examples use `--font-path fonts/` to be explicit and portable. This works regardless of whether system fonts are installed.

**Font substitution:** To use a different font, the user drops .ttf/.otf files into `fonts/`, updates `styles/default.yml` to reference the new font name, and recompiles. Documented in README.

---

## 5. Design Tokens (styles/default.yml)

### YAML Schema

```yaml
# styles/default.yml — Default design tokens for typst-toolkit

meta:
  name: "Default Academic"
  description: "Clean academic style suitable for conferences and institutions"

colors:
  primary: "#1a365d"       # Deep navy — headers, titles
  secondary: "#2c5282"     # Medium blue — subtitles, accents
  accent: "#ed8936"        # Orange — highlights, callouts
  background: "#ffffff"    # White — main background
  surface: "#f7fafc"       # Light gray — section backgrounds
  text: "#1a202c"          # Near-black — body text
  text-light: "#4a5568"    # Gray — captions, metadata

fonts:
  title: "Liberation Sans"
  body: "Liberation Sans"

sizes:
  title: "48pt"
  subtitle: "32pt"
  heading: "28pt"
  body: "18pt"
  caption: "14pt"

spacing:
  margin-x: "3cm"
  margin-y: "3cm"
  section-gap: "2cm"
  paragraph-gap: "0.8cm"
  column-gap: "1.5cm"
```

**Design decisions:**
- All values are strings — Typst's `yaml()` returns strings, and the template converts them to the appropriate Typst types using `eval()` or direct parsing (e.g., `rgb(data.colors.primary)` for colors, `eval(data.sizes.title)` for lengths).
- The `meta` section is informational only — not consumed by templates.
- Colors use hex notation (Typst's `rgb("#1a365d")` parses this natively).
- Font sizes include the unit (`pt`) so templates can use `eval()` directly.
- Spacing values include units (`cm`) for the same reason.

**Loading in Typst:**

```typ
#let style = yaml("styles/default.yml")
#let primary = rgb(style.colors.primary)
#let title-size = eval(style.sizes.title)
```

**Alternative styles:** Creating `styles/dark.yml` or `styles/abnt.yml` requires only changing values — no template code changes. The example file shows how to point to a different style:

```typ
#import "templates/banner.typ": banner
#show: banner.with(style-path: "styles/dark.yml")
```

**Validation:** The template function validates that required keys exist in the YAML and panics with a clear message if a key is missing (e.g., `"styles/default.yml is missing 'colors.primary'"`).

---

## 6. Banner Template Architecture

### File: `templates/banner.typ`

The template exposes a single `banner` function used via `#show: banner.with(...)`. This follows Typst's standard template pattern.

**Function signature:**

```typ
#let banner(
  title: "Untitled",
  authors: (),
  institution: "",
  sections: (),
  logo: none,
  width: 90cm,
  height: 120cm,
  style-path: "../styles/default.yml",
  body,
) = {
  // Implementation
}
```

**Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `str` | `"Untitled"` | Banner title |
| `authors` | `array` of `str` | `()` | Author names |
| `institution` | `str` | `""` | Institution name |
| `sections` | `array` of `dictionary` | `()` | Each dict has `heading` and `content` keys |
| `logo` | `str` or `none` | `none` | Path to logo image file |
| `width` | `length` | `90cm` | Banner width |
| `height` | `length` | `120cm` | Banner height |
| `style-path` | `str` | `"../styles/default.yml"` | Path to style YAML relative to the calling file |

**Layout strategy (no external packages):**

The banner uses Typst's built-in layout primitives:
1. `#set page(width: width, height: height)` — sets the canvas size.
2. A `block` with full width for the header (title, authors, institution, optional logo).
3. A vertical `stack` or sequence of `block` elements for sections.
4. `grid` for multi-column section layouts if needed in the future.
5. `line` or `rect` for visual dividers between sections.
6. `place` for absolute positioning of decorative elements (e.g., colored sidebar).

**Layout structure (vertical banner, top-to-bottom):**

```
┌──────────────────────────────────────┐
│  [Logo]   TITLE                      │  ← Header block (primary bg)
│           Authors • Institution      │
├──────────────────────────────────────┤
│                                      │
│  Section 1 Heading                   │  ← Sections flow vertically
│  Section 1 Content                   │
│                                      │
│  Section 2 Heading                   │
│  Section 2 Content                   │
│                                      │
│  Section 3 Heading                   │
│  Section 3 Content                   │
│                                      │
├──────────────────────────────────────┤
│  Footer / Institution repeat         │  ← Footer block
└──────────────────────────────────────┘
```

**Style consumption:**

```typ
#let style = yaml(style-path)
#let colors = (
  primary: rgb(style.colors.primary),
  secondary: rgb(style.colors.secondary),
  accent: rgb(style.colors.accent),
  background: rgb(style.colors.background),
  surface: rgb(style.colors.surface),
  text: rgb(style.colors.text),
  text-light: rgb(style.colors.at("text-light")),
)
#let sizes = (
  title: eval(style.sizes.title),
  subtitle: eval(style.sizes.subtitle),
  heading: eval(style.sizes.heading),
  body: eval(style.sizes.body),
  caption: eval(style.sizes.caption),
)
```

**Error handling:**
- If `style-path` file doesn't exist: Typst's `yaml()` panics with "file not found" — this is acceptable as a fatal error since the template cannot function without styles.
- If a required YAML key is missing: the template uses `.at("key", default: fallback)` for optional keys and panics with a descriptive message for required keys.
- If `logo` path is invalid: `image()` call panics — acceptable as user error. Documented in SKILL.md.

### File: `examples/banner-example.typ`

```typ
#import "../templates/banner.typ": banner

#show: banner.with(
  title: "Deep Learning Approaches for Scientific Document Analysis",
  authors: ("Maria Silva", "João Santos", "Ana Oliveira"),
  institution: "Universidade Federal de Exemplo",
  sections: (
    (
      heading: "Introduction",
      content: [
        Scientific document analysis has become increasingly important...
        // Placeholder academic content
      ],
    ),
    (
      heading: "Methodology",
      content: [
        We propose a novel architecture combining transformer models...
      ],
    ),
    (
      heading: "Results",
      content: [
        Our approach achieves state-of-the-art performance...
      ],
    ),
  ),
)
```

The example file uses relative paths. Compilation command:

```bash
typst compile --font-path fonts/ examples/banner-example.typ examples/banner-example.pdf
```

**Testability:** The template can be verified by compiling the example and checking for a valid PDF output (file size > 0, starts with `%PDF`).

---

## 7. SKILL.md Structure

The SKILL.md follows a structured format optimized for AI agent consumption:

### Sections:

1. **Project Overview** — What typst-toolkit is, what it produces, architecture summary (3-4 sentences).

2. **Directory Map** — Tree view of the project with one-line descriptions per file/folder.

3. **Quick Start: Generate a Banner** — Step-by-step numbered instructions:
   1. Create a .typ file importing the banner template
   2. Fill in parameters (title, authors, sections)
   3. Compile with `typst compile --font-path fonts/ <file>.typ`
   4. Validate with typst-mcp's `check_if_snippet_is_valid_typst_syntax`
   5. Render preview with `typst_to_image`

4. **Template API Reference** — Full parameter table for `banner.typ` with types, defaults, and descriptions.

5. **Style System** — How `styles/default.yml` works, full key reference, how to create alternative styles.

6. **Rules** — Behavioral constraints for the AI:
   - Always validate Typst syntax via typst-mcp before delivering to user.
   - Use built-in Typst functions over external packages when possible.
   - Respect style.yml values — do not hardcode colors or sizes.
   - If the user doesn't specify style preferences, use `styles/default.yml`.
   - Custom requests that deviate from defaults are valid — do not restrict creativity.
   - Always use `--font-path fonts/` in compilation commands.

7. **Safe Packages** — List of vetted Typst packages with import syntax:
   - CeTZ (`@preview/cetz:0.3.4`) — diagrams and drawing
   - Lilaq (`@preview/lilaq:0.3.0`) — publication-ready plots
   - touying (`@preview/touying:0.6.1`) — presentations
   - peace-of-posters (`@preview/peace-of-posters:0.7.0`) — posters (use as reference only, our template is self-contained)

8. **Examples** — Two complete input→output examples:
   - Example 1: "Gere um banner sobre machine learning com 3 seções" → complete .typ file
   - Example 2: "Banner com estilo escuro sobre biodiversidade" → .typ file using a custom style

9. **Troubleshooting** — Common errors and fixes (font not found, YAML parse error, etc.)

**Design decisions:**
- SKILL.md is kept under 500 lines to fit comfortably in an AI agent's context window.
- Uses markdown headers and code blocks for parseability.
- Package versions are pinned in the examples — the AI should use exactly these versions.
- The file references relative paths from the project root.

---

## 8. Validation Approach

### Approach: Documented Verification Commands in README

Instead of a custom validation script (which would become obsolete as tools change), the README includes a "Verification" section with individual commands the user can run to confirm each component works.

**Verification commands:**

```markdown
## Verification

Run these commands from the project root to confirm everything is working.

### 1. Typst CLI
typst --version
# Expected: typst 0.14.0 or higher

### 2. Fonts
ls fonts/LiberationSans-*.ttf
# Expected: 4 files (Regular, Bold, Italic, BoldItalic)

### 3. Style file
python3 -c "import yaml; yaml.safe_load(open('styles/default.yml')); print('OK')"
# Expected: OK

### 4. Template compilation
typst compile --font-path fonts/ examples/banner-example.typ /tmp/banner-test.pdf
file /tmp/banner-test.pdf
# Expected: PDF document

### 5. MCP server
test -d .mcp-server/typst-mcp && echo "OK" || echo "Not installed"
python3 -c "import json; json.load(open('mcp.json')); print('OK')"
# Expected: OK for both

### 6. SKILL.md
test -f SKILL.md && grep -q "banner.typ" SKILL.md && echo "OK"
# Expected: OK
```

**Design decisions:**
- Each verification is a single command that produces clear pass/fail output.
- No custom tooling to maintain.
- Users can run individual checks or all of them sequentially.
- The commands use only standard utilities available on any Ubuntu 22+ system.
- If a check fails, the Troubleshooting section in the README explains how to fix it.

---

## 9. .gitignore

```gitignore
# MCP server (local clone + venv)
.mcp-server/

# Compiled output
*.pdf
output/

# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
.idea/

# Typst cache
.typst/
```

**Note:** `fonts/` and `styles/` are NOT gitignored — they are committed to ensure reproducibility.

---

## Technology Stack (Locked)

| Component | Technology | Version | Installation Method |
|-----------|-----------|---------|---------------------|
| Typography engine | Typst CLI | >= 0.14 (latest stable) | `cargo install typst-cli` (via rustup) |
| Rust toolchain | Rustup + Cargo | Latest stable | Official rustup installer |
| AI integration | typst-mcp | Latest from main branch | git clone + uv |
| Python runtime | Python | 3.10+ (system has 3.12) | System (pre-installed on Ubuntu 22+) |
| Python package manager | uv | Latest | Official installer script |
| LaTeX→Typst conversion | Pandoc | System version | `sudo apt install pandoc` |
| Default font | Liberation Sans | System version | `sudo apt install fonts-liberation` or committed in `fonts/` |
| Style format | YAML | Typst-native `yaml()` | Built-in |
| MCP protocol | JSON-RPC over stdio | As per MCP spec | Via typst-mcp |

No custom shell scripts. No Docker (by default). No Node.js. No build system. Every tool installed via its official recommended method.

---

## Testability Summary

| What | How | Verification Command |
|------|-----|---------------------|
| Typst CLI works | Version check | `typst --version` |
| Font available | Compile file with Liberation Sans | `typst compile --font-path fonts/ examples/banner-example.typ /tmp/test.pdf` |
| style.yml parseable | Python YAML load | `python3 -c "import yaml; yaml.safe_load(open('styles/default.yml'))"` |
| Banner template compiles | `typst compile` on example | `typst compile --font-path fonts/ examples/banner-example.typ /tmp/test.pdf` |
| MCP server directory exists | Check directory | `test -d .mcp-server/typst-mcp` |
| mcp.json valid | JSON parse | `python3 -c "import json; json.load(open('mcp.json'))"` |
| SKILL.md complete | Grep for key references | `grep -q "banner.typ" SKILL.md` |

All verifications are individual commands documented in the README. No test framework or custom scripts needed.
