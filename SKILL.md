# SKILL.md — typst-toolkit AI Agent Reference

## 1. Project Overview

typst-toolkit is a self-contained toolkit for generating scientific conference banners and posters using Typst. It provides a parameterized template (`templates/banner.typ`), a YAML-based style system (`styles/default.yml`), bundled fonts, and an MCP server for syntax validation and image rendering. An AI agent uses this toolkit to produce publication-ready vertical banners from natural-language user requests.

## 2. Directory Map

```
typst-toolkit/
├── templates/
│   └── banner.typ          # Main banner template (vertical poster layout)
├── styles/
│   └── default.yml         # Default design tokens (colors, fonts, sizes, spacing)
├── fonts/
│   ├── LiberationSans-Regular.ttf
│   ├── LiberationSans-Bold.ttf
│   ├── LiberationSans-Italic.ttf
│   └── LiberationSans-BoldItalic.ttf
├── examples/
│   └── banner-example.typ  # Working example using the banner template
├── .mcp-server/
│   └── typst-mcp/          # MCP server for syntax checking and rendering
├── mcp.json                # MCP server configuration
├── SKILL.md                # This file — AI agent reference
└── README.md               # Project documentation
```

## 3. Quick Start: Generate a Banner

1. Create a `.typ` file (e.g., `output/my-banner.typ`) importing the banner template:
   ```typst
   #import "../templates/banner.typ": banner
   ```

2. Fill in template parameters using `#show: banner.with(...)`:
   ```typst
   #show: banner.with(
     title: "Your Title Here",
     authors: ("Author One", "Author Two"),
     institution: "University Name",
     sections: (
       (heading: "Introduction", content: [Your content here.]),
       (heading: "Methods", content: [Methodology description.]),
     ),
   )
   ```

3. Compile with Typst (from the project root):
   ```bash
   typst compile --root . --font-path fonts/ output/my-banner.typ output/my-banner.pdf
   ```

4. Validate syntax via typst-mcp's `check_if_snippet_is_valid_typst_syntax` tool before delivering.

5. Render a preview image via typst-mcp's `typst_to_image` tool if the user wants a visual.

## 4. Template API Reference

Template: `templates/banner.typ`

| Parameter     | Type              | Default                    | Description                                      |
|---------------|-------------------|----------------------------|--------------------------------------------------|
| `title`       | `string`          | `"Untitled"`               | Banner title displayed in the header             |
| `authors`     | `array` of strings| `()`                       | List of author names                             |
| `institution` | `string`          | `""`                       | Institutional affiliation                        |
| `sections`    | `array` of dicts  | `()`                       | Content sections; each has `heading` and `content` |
| `logo`        | `path` or `none`  | `none`                     | Path to a logo image (displayed in header)       |
| `width`       | `length`          | `90cm`                     | Banner width                                     |
| `height`      | `length`          | `120cm`                    | Banner height                                    |
| `style-path`  | `string`          | `"../styles/default.yml"`  | Path to the YAML style file                      |

### Section format

Each item in `sections` is a dictionary:
```typst
(heading: "Section Title", content: [Markup content goes here.])
```

## 5. Style System

Styles are defined in YAML files under `styles/`. The default is `styles/default.yml`.

### Full key reference

```yaml
meta:
  name: "Style Name"
  description: "Short description"

colors:
  primary: "#1a365d"      # Header background, primary accents
  secondary: "#2c5282"    # Footer background, section headings
  accent: "#ed8936"       # Underlines, highlights
  background: "#ffffff"   # Page background
  surface: "#f7fafc"      # Card/surface backgrounds
  text: "#1a202c"         # Main body text
  text-light: "#4a5568"   # Secondary/lighter text

fonts:
  title: "Liberation Sans"  # Font for titles and headings
  body: "Liberation Sans"   # Font for body text

sizes:
  title: "48pt"       # Main title
  subtitle: "32pt"    # Author line
  heading: "28pt"     # Section headings
  body: "18pt"        # Body text
  caption: "14pt"     # Footer/caption text

spacing:
  margin-x: "3cm"         # Horizontal page margins
  margin-y: "3cm"         # Vertical page margins
  section-gap: "2cm"      # Gap between sections
  paragraph-gap: "0.8cm"  # Gap between paragraphs
  column-gap: "1.5cm"     # Column gap (for multi-column layouts)
```

### Creating alternative styles

1. Copy `styles/default.yml` to a new file (e.g., `styles/dark.yml`).
2. Modify color and font values as needed.
3. Reference the new style via the `style-path` parameter:
   ```typst
   #show: banner.with(
     title: "My Banner",
     style-path: "../styles/dark.yml",
     ...
   )
   ```

## 6. Rules

Behavioral constraints for the AI agent:

1. **Always validate Typst syntax** via typst-mcp's `check_if_snippet_is_valid_typst_syntax` before delivering code to the user.
2. **Use built-in Typst functions** over external packages when possible. The banner template uses only Typst primitives.
3. **Respect style.yml values** — do not hardcode colors or font sizes. If the user wants customization, create a new style file or override via the template parameter.
4. **If the user doesn't specify style preferences**, use `styles/default.yml` as the default.
5. **Always use `--root . --font-path fonts/`** in compilation commands to ensure fonts are found and relative imports resolve correctly.
6. **Do not restrict creativity** — custom requests that deviate from defaults are valid. The template is a starting point, not a limitation.
7. **Use relative paths** from the project root in all file references.
8. **Render previews** with `typst_to_image` when the user asks to see the result.

## 7. Safe Packages

Vetted Typst packages that can be used alongside the banner template:

| Package            | Import                              | Use case                       |
|--------------------|-------------------------------------|--------------------------------|
| CeTZ               | `@preview/cetz:0.3.4`              | Diagrams and technical drawing |
| Lilaq              | `@preview/lilaq:0.3.0`             | Publication-ready plots        |
| touying            | `@preview/touying:0.6.1`           | Presentations                  |
| peace-of-posters   | `@preview/peace-of-posters:0.7.0`  | Reference only (our template is self-contained) |

Import example:
```typst
#import "@preview/cetz:0.3.4": canvas, draw
```

## 8. Examples

### Example 1: "Gere um banner sobre machine learning com 3 secoes"

```typst
#import "../templates/banner.typ": banner

#show: banner.with(
  title: "Redes Neurais Profundas para Classificacao de Imagens Medicas",
  authors: ("Carlos Mendes", "Juliana Costa", "Pedro Almeida"),
  institution: "Instituto de Computacao — UNICAMP",
  sections: (
    (
      heading: "Introducao",
      content: [
        A classificacao automatica de imagens medicas e um desafio fundamental para o diagnostico assistido por computador. Redes neurais convolucionais (CNNs) demonstraram resultados promissores em tarefas de deteccao de anomalias em radiografias, tomografias e ressonancias magneticas. Neste trabalho, investigamos arquiteturas modernas de deep learning aplicadas a datasets clinicos reais.
      ],
    ),
    (
      heading: "Metodologia",
      content: [
        Utilizamos uma arquitetura ResNet-50 pre-treinada no ImageNet, com fine-tuning em um dataset proprietario de 12.000 radiografias toracicas. O pipeline inclui aumento de dados (rotacao, flip, ajuste de contraste), normalizacao por lote e regularizacao via dropout (p=0.3). O treinamento foi conduzido por 100 epocas com otimizador AdamW e learning rate cosine scheduling.
      ],
    ),
    (
      heading: "Resultados e Conclusoes",
      content: [
        O modelo alcancou acuracia de 96.3% e AUC-ROC de 0.984 no conjunto de teste. A analise de Grad-CAM confirma que as regioes ativadas correspondem as areas de interesse clinico. Comparado com radiologistas juniores, o sistema demonstrou sensibilidade 4.2% superior, indicando potencial como ferramenta de triagem em ambientes hospitalares de alto volume.
      ],
    ),
  ),
)
```

Compile:
```bash
typst compile --root . --font-path fonts/ output/ml-banner.typ output/ml-banner.pdf
```

### Example 2: "Banner com estilo escuro sobre biodiversidade marinha"

First, create `styles/dark.yml`:
```yaml
meta:
  name: "Dark Ocean"
  description: "Dark theme for marine biology presentations"

colors:
  primary: "#0d1b2a"
  secondary: "#1b263b"
  accent: "#00b4d8"
  background: "#0d1b2a"
  surface: "#1b263b"
  text: "#e0e1dd"
  text-light: "#778da9"

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

Then create the banner:
```typst
#import "../templates/banner.typ": banner

#show: banner.with(
  title: "Biodiversidade em Recifes de Coral do Atlantico Sul",
  authors: ("Marina Ferreira", "Lucas Rodrigues"),
  institution: "Laboratorio de Ecologia Marinha — UFSC",
  style-path: "../styles/dark.yml",
  sections: (
    (
      heading: "Contexto",
      content: [
        Os recifes de coral do Atlantico Sul abrigam mais de 350 especies de peixes e 120 especies de corais, muitas endemicas da costa brasileira. O monitoramento continuo dessas comunidades e essencial para avaliar os impactos das mudancas climaticas e da acidificacao dos oceanos sobre esses ecossistemas frageis.
      ],
    ),
    (
      heading: "Metodos",
      content: [
        Realizamos censos visuais subaquaticos em 24 transectos fixos ao longo de 3 anos (2021-2024), cobrindo recifes entre 5m e 30m de profundidade. Complementamos com amostragem de DNA ambiental (eDNA) e fotogrametria 3D para quantificar cobertura coralina e complexidade estrutural.
      ],
    ),
    (
      heading: "Descobertas",
      content: [
        Identificamos um declinio de 18% na cobertura coralina viva e reducao de 23% na riqueza de especies em recifes rasos (< 10m). Em contraste, recifes mesofioticos (20-30m) mantiveram diversidade estavel, sugerindo potencial como refugios climaticos. Tres especies previamente nao registradas na regiao foram detectadas via eDNA.
      ],
    ),
    (
      heading: "Implicacoes para Conservacao",
      content: [
        Os resultados indicam urgencia na protecao de recifes rasos e na investigacao de recifes profundos como reservatorios de biodiversidade. Propomos a criacao de zonas de exclusao em areas criticas e o estabelecimento de um programa de monitoramento integrado com tecnologias de sensoriamento remoto.
      ],
    ),
  ),
)
```

Compile:
```bash
typst compile --root . --font-path fonts/ output/biodiversity-banner.typ output/biodiversity-banner.pdf
```

## 9. Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `error: font "Liberation Sans" not found` | Missing `--font-path` flag | Use `typst compile --root . --font-path fonts/ ...` |
| `error: file not found (../templates/banner.typ)` | Missing `--root .` or wrong working directory | Run from project root with `--root .` |
| `error: failed to parse YAML` | Invalid style YAML (wrong indentation, missing quotes) | Validate YAML syntax; ensure all color values are quoted strings |
| `error: unknown variable: style` | `style-path` points to nonexistent file | Check the path is correct relative to the template file location |
| Blank PDF / empty page | `sections` array is empty and no body content | Add at least one section or body content |
| Colors not applying | Style key name mismatch | Ensure all keys match exactly: `text-light` (hyphenated), not `textLight` |
| Logo not rendering | Path is wrong or image format unsupported | Use PNG, SVG, or JPG; verify path relative to the `.typ` file |
| MCP server not starting | `uv` not installed or wrong directory | Install `uv`, verify `.mcp-server/typst-mcp/` exists, check `mcp.json` |
