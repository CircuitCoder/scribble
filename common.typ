#import "@preview/suboutline:0.3.0": suboutline

#let scribble-hash = state("commit-hash")
#let scribble-id = state("post-id")
#let scribble-created = state("post-created-at")
#let scribble-updated = state("post-updated-at")

#let scribble-post(title, body) = context {
  let id = scribble-id.get()
  html.elem("article", attrs: (id: "post-" + id))[
    = #title
    #html.elem("div", attrs: (class: "post-meta"))[
      #html.elem("a", attrs: (class: "post-link", href: "#post-" + id))[\##id]
      @
      #html.elem("a", attrs: (class: "post-link", href: "/" + scribble-hash.get() + "/#post-" + id))[#scribble-updated.get()]
    ]
    #html.elem("div", attrs: (class: "post-toc"))[
      #suboutline(depth: 3, title: none)
    ]
    #body
  ]
}

#let todo(content) = context {
  html.elem("sup", attrs: (class: "todo"))[[#content]]
}

#let hint(content) = context {
  html.elem("sub", attrs: (class: "hint"))[[#content]]
}
