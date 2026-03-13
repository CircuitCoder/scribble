#import "../common.typ"

#common.scribble-post("逻辑")[
  == 模型大小

  一阶逻辑有 Lowenheim-Skolem. 事实上 LS 跟完备性非常相关。Notably，以下两种逻辑因为能够控制模型大小，所以丧失了完备性：

  - SOL 可以描述模型大小，原因是相比于一阶的理论，二阶理论的二阶量词 Quantify over 的是真的模型里的东西，而不只是 definable 的东西。经典例子：$bold("PA"^2)$ 没有非标模型，因为任何 $bold("PA"^2)$ 模型都有 $NN$ 前段，而 $NN$ 这个前段套进二阶归纳里面直接得到所有元素都在 $NN$ 里。

    #quote(block: true)[
      $
        "Ind"^2 := forall P (
          (
            P(overline(0)) and
            (forall n, P(overline(n)) -> P(overline(S)(overline(n))))
          ) -> forall n P(n)
        )
      $
    ]

    这直接导致了二阶逻辑甚至没有一个 sound and complete deduction system。True arithmetic $T(NN)$ 不 RE. 如果 $bold("PA"^2)$ 有完备的 deduction system，可以枚举 proof，那么就可以 SOL 里面在 $bold("PA"^2)$ 里面的 valid sentences。FOL sentences 是 SOL sentences 的一个 decidable fragment (纯语法性质)，所以这样 $T(NN)$ 也 RE 了。

    #quote(block: true)[
      $T(NN)$ 不 RE 的原因：考虑把 $T(NN)$ 作为公理集的理论。这个理论是一个完备的一阶理论 (syntactical completeness)，而且 consistent （它有个模型），根据 Godel's incompleteness theorem，他肯定不能 effectively axiomatizable，因此 $T(NN)$ 不 RE。
    ]

    #quote(block: true)[
      事实上 $bold("PA"^2)$ 可以说明 SOL 不 compact. 符号集加一个常元 $c$，考虑

      $
        Gamma = bold("PA"^2) union { c eq.not S^n (overline(0)) | n in NN }
      $
    ]

  - 如果只考虑 FOL 的有限模型 (finite model theory)， valid FOL sentences is not RE. 与之对比，在任意模型内，根据 Completeness theorem, 枚举 proof 就可以枚举 valid sentences 了。See: #link("https://en.wikipedia.org/wiki/Trakhtenbrot%27s_theorem#Intuitive_proof")[Trakhtenbrot's theorem].

    因此，在 FOL 的这种解读下，FOL 也不存在 sound and complete deduction system。

]