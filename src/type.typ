#import "../common.typ"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#common.scribble-post("类型体操")[
  == Eliminator
  Rocq 和 Agda 的 Inductive type 的 Elimination 都是 pattern matching as intrinsic, induction principle 是生成出来的。因此有的时候为了写明白 motive 会比较麻烦。

  == Characterizing inductive / coinductive types

  常见的 (Co)inductive type 刻画方式有三种：考虑一个长相是 constructors 的 function / functor $F$
  - $F$ 的最小 / 最大不动点：将所有类型简单解读到 Set-valued semantics 上时的刻画
  - $F-$iteration 的 colimit / limit：这是 Domain theory 里面的刻画，最常见的例子是 Haskell
  - Initial $F$-algebra / Final $F$-coalgebra，这是 General categorical semantics 里面通过 Universal property 的刻画
  每一个都可以看作前一个的泛化。

  首先只讨论递归类型只有严格正出现的情况，也就是最传统意义上的 Inductive / coinductive types。

  === Set-valued semantics

  一个最简单的语义构造方法是把类型解读为“所有可能值构成的集合”。e.g. 考虑一个装配了 Type functor + fixpoint operator 的 STLC，我们可以把所有值解读为 Lambda 项的树形结构，类型解读为这些树的集合。可以把这些集合通过包含关系组成一个偏序，这构成一个 $omega-$带底完备偏序 ($omega-$dCPO)。#common.todo[证明?]

  上述 $F$ 是 $omega-$Scott-continuous 的。 #common.todo[证明?] Kleene's Fixed-point Theorem 可以用于构造 $F$ 的最小不动点：

  $
    mu F eq.def sup_( n in omega ) F^n (emptyset) = lim_( n in omega ) F^n (emptyset)
  $

  如果我们有办法找到一个“全集” $U$（通常来说解读比较正常的话总会有的，毕竟所有计算最多可数，找个大基数然后 Filter 一下就行了），那么我们把 $U$ 扔进模型的 Universe 里面，虽然这个 $U$ 是无法 Internally 定义的，但是可以把它当作顶，#common.todo[$omega-$cocompleteness?] 这允许我们干两件事：

  1. 用 Kleene's Fixed-point Theorem 的对偶构造最大不动点，$F$ 也是 $omega-$co-Scott-continuous 的 #common.todo[证明?]：

  $
    nu F eq.def inf_( n in omega ) F^n (U) = lim_( n in omega ) F^n (U)
  $

  2. 如果我们补充任意 Universe 中集合的并（比如直接把 $U$ 的所有子集加进去），这时 $omega$-dCPO 会升级成一个完备格。Knaster-Tarski 定理可以以非构造的方式给出 $F$ 的最小 / 最大不动点。这里只需要 $F$ 单调。

  $
    mu F = inter.big { x subset.eq U | F(x) subset.eq x } \
    nu F = union.big { x subset.eq U | F(x) supset.eq x }
  $

  === Domain theory

  Set-valued semantics 存在的问题是，想要最大不动点就必须引入一个全集，这个在语言里没有一个很明确的意思。以及接下来会说明 Haskell 的通常 Denotational semantics 解读中可以证明 $mu equiv nu$，但是在 Set-valued semantics 中不是很显然为什么这两个迭代过程会收敛到同一个点上。核心的问题是，Kleene's Fixed-point Theorem 只工作在一个偏序上，而偏序的 Antisymmetry 是一个很强的条件（Somewhat too rigid）。

  首先以 Haskell 为例。

  #let husk = [* $omega-"CPO"_bot$ *]

  Haskell 会将 *每一个类型*都解读为一个 $omega$-dCPO，含义和 Set-valued semantics 完全不同，这里的序是不同的值/表示之间的序，而不是不同类型之间的序。值之间的序来自于 definedness: $x <= y$ 被定义为 $x$ _less-defined than_ y。因为 Haskell 的 Non-strictness，每个类型都包含一个底 $bot$，这样的偏序通常被称为 Domain。如果我们把所有类型收集起来，会构成一个范畴，称之为 #husk。这个范畴中的态射是 $omega-$Scott-continuous 函数。

  注意！此时整个 #husk 范畴上没有全局的对象间的序结构。在每个类型内，依旧还可以做 Kleene's Fixed-point Theorem 迭代构造，但是此时只有底，所以只能构造出类型上自映射的最小不动点 (i.e. `fix`)，是一个值。自映射函数的最大不动点值是一个不良定义的概念。

  在 #husk 范畴上构造类型不动点的方式是通过 Adamek's Theorem。#husk 存在 Initial / terminal object #common.hint[严格来说这是错误的，在这个解读下这不是一个 Initial object: morphism 不唯一。不过我们可以在这里选 $bot |-> bot$ 的态射，这个迭代构造依旧成立]，并且 $F$ 保持 $omega-$limit / colimit。#common.todo[证明?]。Adamek's Theorem 是 Kleene's Fixed-point Theorem 的范畴化：

  #html.frame[
    #v(1em)
    $mu F eq.def "colim"& (
    #diagram(cell-size: 5mm, $
      bold(0)
      edge("r", !, ->) &
      F^1(bold(0))
      edge("r", F^1(!), ->) &
      F^2(bold(0))
      edge("r", F^2(!), ->) &
      F^3(bold(0))
      edge("r", F^3(!), ->) &
      ...
    $)
    ) \
    nu F eq.def "lim" & (
    #diagram(cell-size: 5mm, $
      bold(1)
      edge("r", !, <-) &
      F^1(bold(1))
      edge("r", F^1(!), <-) &
      F^2(bold(1))
      edge("r", F^2(!), <-) &
      F^3(bold(1))
      edge("r", F^3(!), <-) &
      ...
    $)
    )$
    #v(1em)
  ]

  Adamek's Theorem 只说明了这个构造能够得到 Initial $F-$algebra / Final $F-$coalgebra #common.todo[证明?]，因此和最后一个通过 Universal property 的刻画联系起来了。具体为了让它们是不动点，需要：

  *Lambek's Lemma*: Initial $F$-algebra $(A, alpha)$ 中的 Structure map $alpha: F(A) arrow.r A$ 是一个同构。 Dually，Final $F$-coalgebra $(B, beta)$ 中的 $beta: B arrow.r F(B)$ 也是一个同构。#common.todo[证明?]

  注意到，这里有一点区别：Categorical semantics 中只要求这是一个同构，而不要求 $F(A) = A$。如果我们把 Set-valued semantics 中的 $omega-$dCPO 视为一个范畴，偏序范畴中的同构就是相等，Adamek's Theorem 的迭代构造正好是 Kleene's Theorem。

  事实上在 Haskell 里面 `Mu` 和 `Nu` 确实不是 Definitionally 相等的，它们的同构来自于 unfold + fold 是 bijective + invertible 的。

  === About negative occurrences

  负出现会破坏上述通过 Kleene's FP Theorem / Adamek's Theorem 的构造方式：
  - Set-valued semantics 中，$F$ 不再是 monotone 的，所以一定不 Scott-continuous, Kleene's FP Theorem 不再适用。
  - 范畴中，$F$ 的 Variance 变化（变成 Contravariant 或者更糟地，Mixed variance 或者根本不是一个 Functor），所以上述 Diagram 不再是一个链。

  解决这个问题的方式是给 $F^n({bot})$ 迭代中的态射一些额外的结构/关系：Embedding-projection pair。在 #husk 中，反复应用 $F$ 可以视作将一个类型“细化”：原先的值原样包含，新的值来自于原先值中的 $bot$ 被多 Define 一层。因此每迭代一次可以看作将之前的值嵌入到一个更大的类型中。Embedding-projection pair 包含两个态射：

  $
    A arrows.rl^e_p B
  $

  其中 $p circle.tiny e = id, e circle.tiny p <= id$ (ordering on morphisms is defined pointwise)

  在 EP-pair 的帮助下，可以拧转负出现带来的 Variance 变化。e.g.:

  ```haskell
  data T = C1 | C2 T T | C3 (T -> ())
  ```

  #html.frame(
    diagram(
      node((0,0), $bold(0)$),
      node((1,0), $F^1(bold(0))$),
      node((2,0), $F^2(bold(0))$),
      node((3,0), $F^3(bold(0))$),
      node((4,0), "..."),

      edge((0, 0), (1, 0), $e_0$, "->", bend: 45deg),
      edge((0, 0), (1, 0), $p_0$, "<-", bend: -45deg),
      edge((1, 0), (2, 0), $e_1 = F(e_0)$, "->", bend: 45deg),
      edge((1, 0), (2, 0), $p_1 = F(p_0)$, "<-", bend: -45deg),
      edge((2, 0), (3, 0), $e_2 = F(e_1)$, "->", bend: 45deg),
      edge((2, 0), (3, 0), $p_2 = F(p_1)$, "<-", bend: -45deg),
      edge((3, 0), (4, 0), "->", bend: 45deg),
      edge((3, 0), (4, 0), "<-", bend: -45deg),
    )
  )

  - 迭代 0 次：$bold(0) = bot$
  - 迭代 1 次：$F(bold(0)) = bot, "C1", "C2" bot bot, "C3" {bot |-> ()}, "C3" {bot |-> bot}$
  - 迭代 2 次：$
    F^2(bold(0)) = bot, "C1", "C2" bot bot, "C2" "_" "_", \
    "C3" {bot |-> (), "C1" |-> (), "C2" bot bot |-> (), "C3" {bot |-> ()} |-> (), "C3" {bot |-> bot} |-> ()}, ...
  $
  - ...

  第一次迭代的 Embedding-projection pair 可以直接被写出：
  - $e_0 = {bot |-> bot}$ （注意这里 $e$ 不能随便选了）
  - $p_0 = {"_" |-> bot}$

  接下来，$e_n = F(e_(n-1)), p_n = F(p_(n-1))$，具体 Ctor 中每个分量作用在 EP-pair 上的行为取决于 Ctor 的 Variance：
  - C1 不作用： $e_n ("C1") = "C1", p_n ("C1") = "C1"$。
  - $e_n ("C2" x y) = F(e_(n-1))("C2" x y) = "C2" e_(n-1) (x) e_(n-1) (y)$, $p_n ("C2" x y) = F(p_(n-1))("C2" x y) = "C2" p_(n-1) (x) p_(n-1) (y)$
  - 注意到右复合 $p_(n-1)$ 可以将函数作用于提高一次迭代，右复合 $e_(n-1)$ 可以将函数作用于降低一次迭代，因此这里有一次拧转：
    $e_n ("C3" f) = "C3" f circle.tiny p_(n-1)$, $p_n ("C3" g) = "C3" g circle.tiny e_(n-1)$

  可以验证对于所有 $n$, $e_n$ 和 $p_n$ 都构成一组 EP-pair. 这样修过以后的 Functor $F$ 一定是 Covariant 的。在这个基础上可以直接用 Adamek's Theorem。注意到，$F$ 不是在原来的 #husk 范畴上定义的，而是其一个只包含 EP-pair 的子范畴。假设最终得到的 (Co)limit 是 $F_omega$，根据 Lambek's Lemma, $F_omega tilde.eq F(F_omega)$。又因为 $F_omega arrows.lr^(e_omega)_(p_omega) F(F_omega)$，所以 $e_omega$ 和 $p_omega$ 就是这个同构。它们的名字叫 `unfold` 和 `fold`。

  Bonus: ${bot}$ 同时是 Embedding subcategory 的 Initial object 和 Projection subcategory 的 Terminal object。可以在这两个子范畴中分别做 Adamek's Theorem，因此 Haskell 中 `Mu A` 和 `Nu A` 永远同构。

  === About uniqueness

  上述内容中有部分过度简化：

  在 #husk 中，${bot}$ 并不是 Initial object，因为一个 Non-strict 态射可以将 $bot$ 映射到任何值上。事实上，`Mu A` 甚至通常不是 Initial $F-$algebra，对于任意的 Endofunctor $F$，在 #husk 中 Initial $F-$algebra 也无法保证存在。通常来说，我们要求 Initiality 只能是在 #husk 的 strict subcategory 内，也就是只包含 Strict morphisms 的子范畴。

  一个范畴中对于 Endofunctor $F$ 如果 Initial $F-$algebra 和 Final $F-$coalgebra 永远存在且永远一致，那么这个范畴被称为 Algebraically compact，See: https://ncatlab.org/nlab/show/algebraically+compact+category 。如果 $F$ locally continuous + covariant，那么 $F-$algebra 和 $F-$coalgebra 在 Strict subcategory 内是良定义的。`Mu F` 和 `Nu F` 同构，并且在 Strict subcategory 内分别是 Initial $F-$algebra 和 Final $F-$coalgebra，因此 Strict subcategory 对于这一类 Endofunctor 是 Algebraically compact 的。

  === About strictness

  上述范畴内的构造可以被推广到 Strict language 内，例如 OCaml。此时类型可以没有底（普通 ($omega-$)-cpo，称为 predomain），可以通过手动引入一个 Thunk 来编码 Non-strictness:

  ```ocaml
  type strict_nat = O | S of strict_nat
  type lazy_nat = LO | LS of (unit -> lazy_nat)
  ```

  此时，Initial object 变成了 $emptyset$，Terminal object 是 ${1}$。

  在类型中添加一个底 $bot$ 的操作称为 Lifting monad，Thunking 可以认为直接对应 Lift。

  在 Predomain 中同样可以通过 EP-pair 构造任意 Recursive type。区别是因为 Initial / terminal object 不同，Category of predomains 不一定是 Algebraically compact 的。

  See:
  - Call-by-push-value: https://pblevy.github.io/papers/hosc05.pdf 在 CBPV 中，明确拆分了 Thunking 和 Lifting 操作，成为了一对 Adjoint functor，因为它明确拆分了 Value category 和 Computation category。在传统的 Domain theory 中，Thunking 和 Lifting 是混在一起的，成为了一个 monad。
  - Lecture Note on Monad-Based Programming \@ FAU: https://www8.cs.fau.de/ext/teaching/sose2023/mbprog/mbprog-skript.pdf
]
