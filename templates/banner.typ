// templates/banner.typ — Vertical banner template for scientific conferences
// Uses only built-in Typst primitives. No external packages.

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
  // --- Load and parse style tokens ---
  let style = yaml(style-path)

  let colors = (
    primary: rgb(style.colors.primary),
    secondary: rgb(style.colors.secondary),
    accent: rgb(style.colors.accent),
    background: rgb(style.colors.background),
    surface: rgb(style.colors.surface),
    text: rgb(style.colors.text),
    text-light: rgb(style.colors.at("text-light")),
  )

  let fonts = (
    title: style.fonts.at("title", default: "Liberation Sans"),
    body: style.fonts.at("body", default: "Liberation Sans"),
  )

  let sizes = (
    title: eval(style.sizes.title),
    subtitle: eval(style.sizes.subtitle),
    heading: eval(style.sizes.heading),
    body: eval(style.sizes.body),
    caption: eval(style.sizes.caption),
  )

  let spacing = (
    margin-x: eval(style.spacing.at("margin-x", default: "3cm")),
    margin-y: eval(style.spacing.at("margin-y", default: "3cm")),
    section-gap: eval(style.spacing.at("section-gap", default: "2cm")),
    paragraph-gap: eval(style.spacing.at("paragraph-gap", default: "0.8cm")),
  )

  // --- Page setup ---
  set page(
    width: width,
    height: height,
    margin: (x: spacing.margin-x, y: spacing.margin-y),
    fill: colors.background,
  )

  // --- Global text defaults ---
  set text(
    font: fonts.body,
    size: sizes.body,
    fill: colors.text,
  )

  set par(
    justify: true,
    leading: 0.8em,
  )

  // --- Header ---
  block(
    width: 100%,
    inset: (x: 2cm, y: 1.5cm),
    fill: colors.primary,
    radius: (bottom: 0.5cm),
  )[
    #set text(fill: white)

    #if logo != none {
      grid(
        columns: (auto, 1fr),
        column-gutter: 2cm,
        align: (horizon, left),
        image(logo, height: 6cm),
        [
          #text(size: sizes.title, weight: "bold", font: fonts.title)[#title]
          #v(0.8cm)
          #text(size: sizes.subtitle)[
            #authors.join(" • ")
          ]
          #if institution != "" {
            v(0.4cm)
            text(size: sizes.heading, style: "italic")[#institution]
          }
        ],
      )
    } else {
      align(center)[
        #text(size: sizes.title, weight: "bold", font: fonts.title)[#title]
        #v(0.8cm)
        #text(size: sizes.subtitle)[
          #authors.join(" • ")
        ]
        #if institution != "" {
          v(0.4cm)
          text(size: sizes.heading, style: "italic")[#institution]
        }
      ]
    }
  ]

  v(spacing.section-gap)

  // --- Sections ---
  for section in sections {
    block(
      width: 100%,
      inset: (x: 1cm, y: 0.8cm),
      below: spacing.section-gap,
    )[
      // Section heading with accent underline
      #text(
        size: sizes.heading,
        weight: "bold",
        fill: colors.secondary,
        font: fonts.title,
      )[#section.heading]

      #v(0.3cm)
      #line(length: 6cm, stroke: 2pt + colors.accent)
      #v(0.6cm)

      // Section content
      #set text(size: sizes.body, fill: colors.text)
      #set par(justify: true, leading: 0.8em)
      #section.content
    ]
  }

  // --- Body content (if any) ---
  body

  // --- Footer ---
  v(1fr)
  block(
    width: 100%,
    inset: (x: 2cm, y: 1cm),
    fill: colors.secondary,
    radius: (top: 0.5cm),
  )[
    #set text(fill: white, size: sizes.caption)
    #align(center)[
      #if institution != "" {
        text(weight: "bold")[#institution]
      }
      #if authors.len() > 0 and institution != "" {
        h(1cm)
        text[•]
        h(1cm)
      }
      #if authors.len() > 0 {
        text[#authors.join(", ")]
      }
    ]
  ]
}
