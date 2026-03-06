#show math.equation: html.frame

#html.elem("html")[
  #html.elem("head")[
    #html.elem("meta", attrs: (charset: "UTF-8"))
    #html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1.0"))
    #html.elem("title")[猫咪涂鸦]
    #html.elem("meta", attrs: (property: "og:title", content: "猫咪涂鸦"))
    #html.elem("meta", attrs: (property: "og:description", content: "喵喵的胡思乱想笔记本"))
    #html.elem("meta", attrs: (property: "og:type", content: "website"))
    #html.elem("link", attrs: (rel: "stylesheet", href: "style.css"))
  ]
  #html.elem("body")[
    #html.elem("main")[
      #include "posts.typ"
    ]
  ]
]
