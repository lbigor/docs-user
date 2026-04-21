// Template Typst determinístico para PDF da skill docs-user
// Produz o mesmo output byte-a-byte (exceto metadata de timestamp) em qualquer Mac/Linux/Windows
// que tenha pandoc >= 3.1 + typst >= 0.12 instalados.

#let conf(
  title: none,
  subtitle: none,
  author: "Igor Lima",
  date: datetime.today().display(),
  version: "1.0.0",
  doc,
) = {
  set document(
    title: title,
    author: author,
  )

  set page(
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2.2cm, right: 2.2cm),
    header: context {
      if counter(page).get().first() > 1 [
        #set text(size: 8pt, fill: gray)
        #title #h(1fr) docs-user · MIT
      ]
    },
    footer: context [
      #set text(size: 8pt, fill: gray)
      MIT · 2026 · Igor Lima · v#version
      #h(1fr)
      Página #counter(page).display() / #counter(page).final().first()
    ],
  )

  set text(
    font: ("Helvetica Neue", "Helvetica", "Arial"),
    size: 10pt,
    lang: "pt",
    region: "br",
  )

  set par(justify: true, leading: 0.65em)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    set text(size: 18pt, weight: "bold")
    block(above: 0pt, below: 0.8em, it)
  }

  show heading.where(level: 2): it => {
    set text(size: 14pt, weight: "bold", fill: rgb("#1a365d"))
    block(above: 1.2em, below: 0.5em, it)
  }

  show heading.where(level: 3): it => {
    set text(size: 11pt, weight: "bold")
    block(above: 0.8em, below: 0.3em, it)
  }

  // Código em monoespaçada consistente
  show raw: it => {
    set text(font: ("Menlo", "Consolas", "DejaVu Sans Mono"), size: 9pt)
    it
  }

  show raw.where(block: true): it => {
    block(
      fill: rgb("#f7f7f9"),
      inset: 10pt,
      radius: 3pt,
      width: 100%,
      it,
    )
  }

  // Tabelas
  show table: set text(size: 9pt)

  // Capa
  align(center)[
    #v(4cm)
    #text(size: 24pt, weight: "bold")[#title]

    #if subtitle != none [
      #v(0.5cm)
      #text(size: 13pt, fill: gray)[#subtitle]
    ]

    #v(2cm)
    #text(size: 11pt)[
      #author \
      #date \
      Versão #version
    ]

    #v(1fr)
    #text(size: 8pt, fill: gray)[
      MIT · 2026 · Igor Lima — github.com/lbigor/docs-user \
      Consultoria opcional: lbigor\@icloud.com · (27) 99850-1498 (WhatsApp)
    ]
  ]

  pagebreak()

  // Corpo
  doc
}

#show: doc => conf(
  title: [TITLE_PLACEHOLDER],
  subtitle: [SUBTITLE_PLACEHOLDER],
  version: "VERSION_PLACEHOLDER",
  date: "DATE_PLACEHOLDER",
  doc,
)
