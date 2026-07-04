#set document(title: "Helix Cheat Sheet", author: "Lennart Kloock")

#let default_theme = toml("themes/default.toml")

#let theme_path = sys.inputs.at("theme", default: "themes/default.toml")
#let theme_name = theme_path.split("/").last().split(".").first()
#let theme = toml(theme_path)

#let resolve_color(theme, key, subkey) = {
  let key = key.split(".")
  while key.len() > 0 {
    let themed = theme.at(key.join("."), default: none)
    if themed != none {
      if type(themed) == dictionary {
        themed = themed.at(subkey)
      }
      if themed.starts-with("#") {
        return rgb(themed)
      } else {
        return rgb(theme.palette.at(themed))
      }
    }

    key.pop()
  }
  return none
}

#let default_color(key, subkey) = {
  resolve_color(default_theme, key, subkey)
}

#let color(key, subkey) = {
  let themed = resolve_color(theme, key, subkey)
  if themed != none {
    return themed
  }
  return default_color(key, subkey)
}

#set page(
  paper: "a4",
  margin: 2cm,
  fill: color("ui.background", "bg"),
  footer: [Full keymap: #link("https://docs.helix-editor.com/keymap.html")],
)
#let fg_color = color("ui.text", "fg")
#set text(fill: fg_color, lang: "en", font: "Fira Sans", size: 10pt)
#set table(align: horizon, stroke: (x, y) => (top: if y > 0 { fg_color }), inset: (x: 0.25em, y: 0.5em))
#show table.cell.where(x: 0): set par(leading: 0.25em)
#show table.cell.where(x: 1): set par(leading: 0.5em)
#show link: set text(fill: color("markup.link.text", "fg"))
#show raw: c => box(fill: color("ui.selection", "bg"), inset: 3pt, c)

#let mode(key) = {
  let fg = color("ui.statusline." + key, "fg")
  let bg = color("ui.statusline." + key, "bg")
  let short = upper(key.slice(0, 3))
  box(fill: bg, inset: 3pt, text(font: "JetBrains Mono", size: 0.8em, fill: fg, short))
}

#title()

#place(top + right)[
  Theme: #raw(theme_name)
]

== #mode("normal") Normal mode #sym.dash.em `Esc`

#columns(2, gutter: 1em)[
  === Movement

  #table(columns: 2,
    [`h`, #raw(sym.arrow.l)],[Move left],
    [`j`, #raw(sym.arrow.b)],[Move down],
    [`k`, #raw(sym.arrow.t)],[Move up],
    [`l`, #raw(sym.arrow.r)],[Move right],
    [`w`],[Move to next word start],
    [`b`],[Move to previous word start],
    [`e`],[Move to next word end],
    [`f`],[Find next char],
    [`F`],[Find previous char],
    [`t`],[Find till next char],
    [`T`],[Find till previous char],
    [`G`],[Go to line number `<n>`],
    [`Home`],[Move to start of line],
    [`End`],[Move to end of line],
    [`Ctrl-u`],[Move half page up],
    [`Ctrl-d`],[Move half page down],
    [`Ctrl-i`],[Jump forward on the jumplist],
    [`Ctrl-o`],[Jump backward on the jumplist],
  )

  === Selection

  #table(columns: 2,
    [`s`],[Select all regex matches in selection],
    [`_`],[Trim whitespace from selection],
    [`;`],[Collapse onto single cursor],
    [`,`],[Keep only primary selection],
    [`C`],[Add cursor below],
    [`Alt-C`],[Add cursor above],
    [`%`],[Select entire buffer],
    [`x`],[Extend selection to next line],
  )

  #colbreak()

  === Changes

  #table(columns: 2,
    [`r`],[Replace with character],
    [`R`],[Replace with yanked],
    // [`~`],[Switch case],
    [`i`],[Insert before selection],
    [`a`],[Insert after selection],
    [`I`],[Insert at start of line],
    [`A`],[Insert at end of line],
    [`o`],[New line below],
    [`O`],[New line above],
    [`u`],[Undo],
    [`U`],[Redo],
    [`y`],[Yank],
    [`d`],[Delete (and yank)],
    [`Alt-d`],[Delete],
    [`c`],[Delete (and yank) and insert],
    [`Alt-c`],[Delete and insert],
    [`p`],[Paste after selection],
    [`P`],[Paste before selection],
    [`>`],[Indent],
    [`<`],[Unindent],
    [`=`],[Format],
    [`Ctrl-c`],[Toggle comment],
  )

  == #mode("insert") Insert mode #sym.dash.em `i`

  #table(columns: 2,
    [`Ctrl-x`],[Autocomplete],
    [`Ctrl-w`, `Alt-Backspace`],[Delete previous word],
    [`Alt-d`, `Alt-Delete`],[Delete next word],
    [`Ctrl-u`],[Delete to start of line],
    [`Ctrl-k`],[Delete to end of line],
  )
]

Use `v`, `g`, `m`, `z`, `Ctrl-w`, `Space`, `[` and `]` for minor modes
