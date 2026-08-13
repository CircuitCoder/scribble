#import "../common.typ"

#common.scribble-post("逻辑")[
  == Lawvere's Fixed-point Theorem

  *Lawvere's Fixed-point Theorem*: 令 $C$ 是一个 Cartesian closed category，$A, B in "ob"(C)$，如果存在 $f : A -> B^A$ _weakly point-surjective_，那么 $B$ 上的任何自态射都有不动点。

  *Weakly point-surjective*: CCC 中 $f: X -> Z^Y$ weakly point-surjective iff. 对于任意 $g: Y -> Z$，存在 $x: bold(1) -> X$ 使得 $f compose x$ 和 $g$ Pointwise 相等，即对任意 $y : bold(1) -> Y$，都有 $g compose y = "eval" (f compose x, y)$

  *不动点*: $g : B -> B$ 上有不动点指存在一个 $b : bold(1) -> B$，使得 $b = g compose b$

  #quote(block: true)[
    *Proof*:

    对于任意 $g : B -> B$，定义 $h: A -> B eq.def g compose "eval" compose (f, id) $ #common.hint[$h(x) = g(f(x, x))$]

    因为 $f$ Weakly point-surjective，存在 $a : bold(1) -> A$ "represents" $h$，那么令 $b = "eval" compose (f compose a, a)$ #common.hint[$b = f(a, a)$]：

    $
      g compose b = g compose "eval" compose (f compose a, a) = h compose a = "eval" (f compose a, a) = b
    $
  ]

  Lawvere's Fixed-point Theorem 通常被认为是数个对角化方法的统一。常见使用的路径有两个：
  1. 选择一个显然没有不动点的自态射 （比如 $not : Omega -> Omega$），然后构造 Weakly point-surjectivity，产生矛盾。
  2. 通过 Weakly point-surjective 态射证明存在不动点。

  比较常见的三个例子。可以看到，其实很多时候直接上 Lawvere's Fixed-point Theorem 其实不是很好用...

  === Cantor's proof of $cal(P)(A) > A$

  $bold("Set")$ 里面的 Subobject classifier $Omega$ 就是布尔值 $bold(2)$, $not : bold(2) -> bold(2)$ 没有不动点。$cal(P)(A) tilde.eq bold(2)^A$。如果 $cal(P)(A) <= A$，即存在 $f : A -> bold(2)^A$ 是 Weakly point-surjective 的，立刻得到矛盾。

  === Turing's Halting problem

  范畴选择为：
  - 对象是所有 $NN$ 上的 partial equivalence relation (PER)
  - 态射是等价类之间的 *Total* computable 函数。强调这里需要是 Total 的，因为 Partial halting recognizer 显然存在（就是 UTM）。一个额外的限制是，因为我们的对象是 PER，需要这里要求每个态射在同一个等价类内的输入上的输出都等价。#common.hint[最严格的说法：态射是商集 Field(R)/R -> Field(S)/S 之间、由在 Field(R) 上全定义的部分可计算函数跟踪的函数。]

  CCC 结构：
  - Terminal object 是 ${0}$
  - Product 是 Tuple 在图灵机输入上的编码
  - Exponential object 是图灵机的编码, quotient by 函数外延性（在所有输入上输出都等价的图灵机被 Quotient 到一起）, `eval` 是 UTM。因为我们商掉的关系是函数外延性，所以这里 `eval` 是一个良定义的态射。

  这里需要 Argue 一下 `eval` 也是 Total 的。注意到因为 Exponential object 里只包含 Total Turing machine 的编码，所以 `eval` externally 可以看到一定是停机的。

  接下来 Abuse 两个记号：$bold(2) = ({0, 1}, =)$ 是布尔值, $(NN, =)$ 直接写作 $NN$。

  使用 $bold(2)$ 表示是否停机。假设存在 Total halting decider $h : NN -> bold(2)^NN$（或者 $NN times NN -> bold(2)$, 注意到图灵机可以 Curry，这两个东西就是一样的），其中：
  1. 如果 $x$ 不是一个合法的图灵机编码，$h(x)$ 是一个恒为 0 的函数。编码检查是可判定的。
  2. 如果 $x$ 是一个合法的图灵机编码，*不一定 Total*，$h(x)(y)$ 输出 0 当且仅当 $x$ 对应的图灵机在输入 $y$ 时停机。

  $h$ 是 Weakly point-surjective 的。对于任意 $g : NN -> bold(2)$，$g$ 对应 $NN$ 的可判定子集，所以一定存在一个图灵机，当且仅当在这个可判定子集上停机。这个图灵机的编码 weakly represents $g$。注意，这个图灵机的编码是在 $NN$ 里，不是在 $2^NN$ 里，所以它可以本身是 Partial 的。

  最后，$bold(2)$ 上存在 Total computable 函数 $not = { 0 |-> 1, 1 |-> 0 }$ 没有不动点。所以这样的 $h$ 一定不存在。

  Remark: 考虑如下映射：如果输入在 $bold(2)^NN$ 内， 那么不变，否则映射到某个特定的输出常数 0 的图灵机。这个映射是 Weakly point-surjective 的，所以也肯定不存在。所以在上述范畴的定义下，一个 Total computable function 可以检查图灵机的编码，但是无法判断一个编码是不是在 $bold(2)^NN$ 内。这是 Totality problem.

  ==== Caveats & further remarks

  为什么要商一个 PER？

  如果不商 PER 的话，问题来自于态射集 $X -> Y$ 如果定义成 Total computable 函数，那么这是外延的：任意两个行为一样的函数是同一个态射。但是 Exponential object 如果定义成图灵机编码，那么可能有多个不同编码。这违反了 CCC 要求的 Universal property。

  如果我们把态射集也定义成内涵的，最大的问题来自于 $id compose (-)$ 在态射集上会把一个态射映射成另一个不一样的态射。

  最后，最简单的办法其实是避开 CCC：根本不用 Exponential object，直接在 $A times A -> B$ 上定义 Weakly point-surjectivity。事实上，在下面 Diagonal lemma 的证明中，我们甚至要把 Weakly point-surjectivity 都去掉。

  Also see: Effective Topos.

  === Gödel's diagonal lemma
  Diagonal lemma 用的是第二条路径，构造不动点。

  首先，我们要简化一下 Lawvere's theorem 的证明。注意到如果我们把上面的证明打开，有两个可以简化的地方：
  1. 首先，其实根本不用 CCC。直接去表示 $A times A -> B$ 中的一个分量就行了。
  2. 其实我们也不需要任意自映射都被 represent：上面选到的那几个特定函数能够被表示就行。下面如果我们要构造特定自映射的不动点，只需要找到这个映射本身对应的 $h$ 的 representative 即可。

  *Local Lawvere's Lemma*: 给定 $g : B -> B$。如果存在 $f : A times A -> B, a : bold(1) -> A$ 满足对于任意 $x: bold(1) -> A$，都有 $g compose f compose (x, x) = f compose (x, a)$，那么 $f compose (a, a) = g compose f compose (a, a)$ 是 $g$ 的不动点。

  #let godel(n) = $corner.t.l #n corner.t.r$
  #let ungodel(n) = $corner.b.l #n corner.b.r$

  这样做的好处是我们在定义范畴的时候可以放松非常多，并不需要把态射想方设法限制到能表示的那些上了。比如允许我们选用 $bold("Set")$ 作为范畴。同时，注意到 $f$ 甚至可以依赖 $g$ 选择。

  选择经典的场景：理论选用 *Q*，$overline((-))$ 表示某个整数在语言内对应的表示，$godel(-)$ 表示编码。对于任意语句 $S$，$[S]$ 表示 $S$ 在 *Q* 内的可证等价语句类。令 $L$ 表示所有这样的等价类构成的集合。

  令 $B = L times NN$，其中我们关心的元素是某个语句的可证等价类及其编码构成的 Tuple。

  对于任意给定的一元谓词 $psi(x)$，可以对应一个 $B$ 上的自映射 $g_psi : (c, n) |-> ([psi(overline(n))], n)$。这个自映射是把第一个分量里的语句等价类改成了 Tuple 第二个分量带有的自然数包上一次 $psi$。 接下来需要找到对应的矩阵 $f$ 可以满足要求的表示条件：$g_psi$ 作用在矩阵的对角线上被某一列表示。

  定义 $d : NN -> NN$:

  $
    d : (godel(alpha(x))) |-> godel(alpha(overline(godel(alpha(x)))))
  $

  ... 其中 $alpha(x)$ 不是一个语句，x 是自由变元。我们将其原样做 Gödel coding。对于不是一元谓词编码的输入，输出 0。根据 Gödel coding 可以在 *Q* 内被表示，存在一个可定义的一元谓词 $gamma (x)$ 满足对于任意 $n in NN$,

  $
    bold(Q) tack.r gamma (overline(n)) <-> psi (overline(d(n)))
  $

  #quote(block: true)[
    直觉：$d$ 表示一次 self-application，$gamma$ 表示一次 self-application 之后落到 $psi$ 里
  ]

  令 $A$ 表示所有一元谓词集#common.hint[可以多加一点限制，比如变元名称是 x]。考虑如下 $f : A times A -> B$：

  $
    f(alpha, beta) = ([beta(overline(godel(alpha(x))))], d(godel(alpha(x))))
  $

  注意到，在对角线上，$f(alpha, alpha) = ([alpha(overline(godel(alpha(x))))], godel(alpha(overline(godel(alpha(x))))))$ 记录的元素正好是一些语句及其可证等价类。所以只需找到 $g_psi$ 在对角线上的不动点即可。

  #quote(block: true)[
    直觉：
    - $alpha$-行："$alpha$ 被该列描述"，以及 $alpha$ self-application
    - $beta$-列："该行由 $beta$ 描述"，及被描述谓词的 self-application
    - $(alpha, beta)$："$beta$ 描述 $alpha$"，以及 $alpha$ self-application
    - $(alpha, alpha)$:  "$alpha$ 描述 $alpha$"，并且此时第二个分量正好变成前面这句话的 Gödel number
  ]

  那么：

  $
    f(alpha, gamma) &= ([gamma(overline(godel(alpha(x))))], d(godel(alpha(x)))) \
            &= ([psi(overline(d(godel(alpha(x)))))], d(godel(alpha(x)))) \
            &= g_psi ([alpha(overline(godel(alpha(x))))], d(godel(alpha(x)))) \
            &= g_psi (f (alpha, alpha))
  $

  这个等式成立的原因是 $g_psi$ 本身不改变第二个分量，$f$ 产生的第二个分量不依赖第二个参数，然后我们手动构造 $gamma$ 让其产生一个 $psi(overline(d(-)))$ 对应 $g_psi$ 的输出形状。

  因此 $f(gamma, gamma)$ 是 $g_psi$ 的不动点。注意第一个分量：$[gamma(overline(godel(gamma(x))))] = [psi(overline(godel(gamma(overline(godel(gamma(x)))))))]$，即 $phi = gamma(overline(godel(gamma(x))))$，并且 $bold(Q) tack.r phi <-> psi(overline(godel(phi)))$

  ==== Remarks

  以下 Remark 的理论 *T* 以 *Q* 或者 *PA* 为例，结构是指这个理论的结构。

  *Gödel's first incompleteness theorem* (original): 定义二元谓词 $"Prov"(y, x)$ 为 "y 是某一语句的证明的编码，这一语句的编码是 x"。令 $psi (x) eq.def forall y (not "Prov"(y, x))$。不动点 $phi <-> forall y (not "Prov" (y, godel(phi)))$ 等价于自身的不可证性。

  - Consistency 给出 $bold(T) tack.r.not phi$。
  - 如果 $bold(T) tack.r not phi$，也就是 $exists y ("Prov"(y, godel(phi)))$，在 Non-$omega$-consistent 的理论中，这可能被一个非标自然数验证。对于 $omega$-consistency 理论，同时有 $bold(T) tack.r.not not phi$。

  *Gödel-Rosser's incompleteness theorem*: 令 $"Neg"$ 表示 Gödel number 上添加一个逻辑取反的符号：$"Neg"(godel(alpha)) eq.def godel(not alpha)$。令

  $
    psi (x) eq.def forall y ("Prov"(y, x) -> exists z (z < y and "Prov"(z, "Neg"(x))))
  $

  即对于任意 $x$ 的证明 $y$，都存在一个比 $y$ 更小的，not $x$ 的证明。将其不动点称为 $phi$。
  - 如果 $T tack.r phi$，那么存在一个 $n in NN$，$T tack.r "Prov"(overline(n), overline(godel(phi)))$，因此存在一个更小的逻辑取反的证明，只有有限个可能，可以在 *PA* / *Q* 内枚举验证，矛盾。
  - 如果 $T tack.r not phi$，即 $T tack.r exists y ("Prov"(y, overline(godel(phi))) and forall z ("Prov"(z, "Neg"(overline(godel(phi)))) -> z >= y))$。注意到存在一个 $n in NN$ 验证了 $"Prov"(overline(n), "Neg"(overline(godel(phi))))$，因此 $exists y <= overline(n) ("Prov"(y, overline(godel(phi))))$，这只有有限个可能，可以在 *PA* / *Q* 内枚举验证，矛盾。
  所以 Rosser's trick 去掉了对于 $omega$-consistency 的要求。

  *Gödel's second incompleteness theorem*: 找一个明显有矛盾的语句，例如在等值逻辑+*Q* 上，令 $bot eq.def overline(0) = overline(1)$。一个理论是 Consistent 的 iff. 它不能证明 $bot$，所以定义 $"Con"(bold(T)) eq.def not exists x ("Prov"(x, overline(godel(bot))))$。
  令 $phi$ 表示我们在原先 First incompleteness theorem 中构造的在 *T* 中可证和自身不可证明性等价的语句。注意到我们可以把整个 First incompleteness theorem 的证明也在 *T* 内部编码，所以 $bold(T) tack.r "Con"(T) -> not exists x ("Prov"(x, overline(godel(phi))))$，也就是 $bold(T) tack.r "Con"(T) -> phi$。

  因此，如果有 $bold(T) tack.r "Con"(T)$，那么 $bold(T) tack.r phi$，与 First incompleteness theorem 矛盾。

  *Tarski's undefinability theorem*: 如果存在一个可定义谓词 $T(n)$ 描述 $ungodel(n)$ 在某个特定结构 $M$ 中的真实性，那么定义 $psi (n) eq.def not T (n)$，不动点 $phi <-> not T (godel(phi))$ 是 $T$ 上述性质的反例。

  References:
  - A Universal Approach to Self-Referential Paradoxes, Incompleteness and Fixed Points (Yanofsky) (2003) 比较经典的 Text，使用集合的方法描述的对角线方法，但是对于 Diagonal lemma 的处理有些不良定义的地方。
  - Diagonalization as computation: Gödel sentence construction and a type-disciplined blueprint (Vestrucci) (2026) 上了 Type 之后修正之后的 Text


  ==== Caveats

  事实上这里有很多很多坑：

  如果尝试直接定义 $NN$ 子集范畴，态射是所有语言的 total computable 函数（都可以在 *Q* 里面定义），然后找一个 $F$ 是所有语句的 Gödel 编码集合，看上去 $f : NN -> F^NN$ 直接就工作了。但是这里有个问题：这个 $f$ 的值域是受限的，所以不能直接定义成 `id`，而是必须得有一个方法检查一个整数是不是一个 $NN -> F$ 的编码，也就是要判断任意函数的值域是不是一个语句的 Gödel 编码。In general，这应该是 Undecidable 的。

  Gödel numbering does not factor through Lindenbaum classes，对于 $psi <-> phi$，可能存在谓词 $gamma$ 使得 $gamma (overline(godel(psi)))$ 和 $gamma (overline(godel(phi)))$ 真值不同，所以一定有 $bold(Q) tack.r.not gamma(overline(godel(psi))) <-> gamma(overline(godel(phi)))$。这是 Yanofsky 的构造中的漏洞。

  === Remarks

  很多 Diagonal lemma 的用途在于 Computability theory，所以一般范畴中的态射可以不只是可定义函数，而是变成可计算函数，然后额外引入一个假设是所有可计算函数在我们关心的语言内都可以定义。*Q* 和 *PA* 都满足这一点。

  == 模型大小

  一阶逻辑有 Löwenheim-Skolem. 事实上 LS 跟完备性非常相关。Notably，以下两种逻辑因为能够控制模型大小，所以丧失了完备性：

  - SOL 可以描述模型大小，原因是相比于一阶的理论，二阶理论的二阶量词 Quantify over 的是真的模型里的东西，而不只是 definable 的东西。经典例子：$bold("PA"^2)$ 没有非标模型，因为任何 $bold("PA"^2)$ 模型都有 $NN$ 前段，而 $NN$ 这个前段套进二阶归纳里面直接得到所有元素都在 $NN$ 里。

    #quote(block: true)[
      $
        "Ind"^2 := forall P (
          (
            P(overline(0)) and
            (forall n, P(n) -> P(overline(S)(n)))
          ) -> forall n P(n)
        )
      $
    ]

    这直接导致了二阶逻辑甚至没有一个 sound and complete deduction system。True arithmetic $T(NN)$ 不 RE. 如果 $bold("PA"^2)$ 有完备的 deduction system，可以枚举 proof，那么就可以枚举在 $bold("PA"^2)$ 里面的语义后承。FOL sentences 是 SOL sentences 的一个 decidable fragment (纯语法性质)，所以这样 $T(NN)$ 也 RE 了。

    #quote(block: true)[
      $T(NN)$ 不 RE 的原因：考虑把 $T(NN)$ 作为公理集的理论。这个理论是一个完备的一阶理论 (syntactical completeness)，而且 consistent（它有个模型），根据 Gödel's incompleteness theorem，它肯定不是 effectively axiomatizable，因此 $T(NN)$ 不 RE。
    ]

    #quote(block: true)[
      事实上 $bold("PA"^2)$ 可以说明 SOL 不 compact. 符号集加一个常元 $c$，考虑

      $
        Gamma = bold("PA"^2) union { c eq.not S^n (overline(0)) | n in NN }
      $
    ]

  - 如果只考虑 FOL 的有限模型 (finite model theory)， valid FOL sentences are not RE. 与之对比，在任意模型内，根据 Completeness theorem, 枚举 proof 就可以枚举 valid sentences 了。See: #link("https://en.wikipedia.org/wiki/Trakhtenbrot%27s_theorem#Intuitive_proof")[Trakhtenbrot's theorem].

    因此，在 FOL 的这种解读下，General FOL 也不存在 sound and complete deduction system。

]
