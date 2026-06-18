#show math.equation.where(block: false): it => {
  [
    #html.elem("span", attrs: (role: "math", "data-mathml": "hide"), box(html.frame(it)))
    #html.elem("span", attrs: (role: "math", "data-mathml": "show"), it)
  ]
}
#show math.equation.where(block: true): it => {
  [
    #html.elem("figure", attrs: (role: "math", "data-mathml": "hide"), html.frame(it))
    #html.elem("figure", attrs: (role: "math", "data-mathml": "show"), it)
  ]
}

#html.elem("html")[
  #html.elem("head")[
    #html.elem("meta", attrs: (charset: "UTF-8"))
    #html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1.0"))
    #html.title[猫咪涂鸦]
    #html.elem("meta", attrs: (property: "og:title", content: "猫咪涂鸦"))
    #html.elem("meta", attrs: (property: "og:description", content: "喵喵的胡思乱想笔记本"))
    #html.elem("meta", attrs: (property: "og:type", content: "website"))
    #html.link(rel: "stylesheet", href: "style.css")
  ]
  #html.elem("body", attrs: ("data-mathml-mode": "off"))[
    #html.nav[
      #link("#post-hello-world")[> 关于]
      #link("https://github.com/CircuitCoder/scribble")[> Repo]
      #link("https://layered.meow.plus")[> 博客]
      #html.elem("a", attrs: (
        "data-mathml": "hide",
        href: "javascript:document.body.setAttribute('data-mathml-mode', 'on')")
      )[> MathML 公式]
      #html.elem("a", attrs: (
        "data-mathml": "show",
        href: "javascript:document.body.setAttribute('data-mathml-mode', 'off')")
      )[> SVG 公式]
    ]
    #html.main[
      #include "posts.typ"
    ]
  ]
]
