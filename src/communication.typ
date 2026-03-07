#import "../common.typ"

#common.scribble-post("通讯")[
  == Rectangle property

  在 MPC 设定下，如果暂时不考虑 Active malicious adversary 的话，节点的私有状态 $(x_i, r_i)$ i.e. 输入和随机性可以确定性决定 Transcript $T$。将这一映射称为 $Pi$.

  $Pi^(-1)$ 具有 "Rectangle property"，$forall T in cal(T), Pi^(-1)(T)$ 是一个 Rectangle：

  $
  Pi^(-1)(T) = product_(i=1)^n pi_i (Pi^(-1)(T))
  $

  可以理解成，如果有任意两个所有 Party 的私有状态集合 $S_1, S_2$ 满足 $Pi(S_1) = Pi(S_2) = T$，那么可以把 $S_1$ 和 $S_2$ 任意组合（每个 Party 任意在两者中选一个），那么最终 Transcript 依旧是 $T$。

  证明把 T 当成一个消息列，归纳。

  这有两个很直接的后果：
  1. 如果至少有 3 个 Party，那么不存在在*纯广播信道*上的 $t >= 1$ 的计算元素和的协议。原因是如果存在，假设 Party 1 semi-honest，Fix $(x_1, r_1)$，注意到只要 $sum_{i >= 2} x_i$ 不变，那么 Party 1 的 View 也不变。这是纯广播，因此 Transcript 不变。只要有限域大小大于 2, 总能选出来两个不同的元素 $e_0, e_1$，假设他们是 Party 2 和 Party 3 的输入，那么交换他们，Party 1 View 不变，所以把 Party 3 的输入从 $e_1$ 改成 $e_0$，Party 1 View 依旧不变，但是结果变了，矛盾。

  2. 不存在 2-Party 计算 AND 的协议。如果存在，$x_1 = 0, x_2 = 1$ 和 $x_1 = 1, x_2 = 0$ 都会输出 $0$, 所以 Adversary View 相同，只有两个 Party 所以 View 包含整个 Transcript，整个 Transcript 也就相同。所以 $x_1 = x_2 = 1$ 也应该产生一样的 Transcript，但是这会产生不同的输出，矛盾。

  相关历史综述见 #link("https://gemini.google.com/share/c727e58207fa")[Gemini DeepResearch]。AI 幻觉有风险，4.6 Opus 就给我幻觉了几个 Ref。不过 DeepResearch 至少给链接了。

  == Reed-Solomon 纠错

  Reed-Solomon 如果有 $2t$ 冗余可以纠 $t$ 个错 (Also, Shamir Secret Sharing).

  考虑有限域 $"GF"(q)$ 上的 Reed-Solomon 码，共 $n - 2t$ 个数据，$2t$ 个冗余，总共采样点 $n$ 个。现在要找出来其中最多 $t$ 个错的点。如果我们忽略多项式的其他结构，认为这些采样点是任选的，下面陈述的方法是找到这些错误点的标准方法 Berlekamp-Welch algorithm。

  === Berlekamp-Welch

  假设 Underlying polynomial 是 $F(x)$，Claim 存在一个多项式 $E(x)$，满足 $x_i "incorrect" <=> F(x_i) eq.not y_i => E(x_i) = 0$。*如果 $x_i$ 不是错误的点，对 $E(x_i)$ 没有要求*。因为最多 $t$ 个错误，所以我们可以要求 $deg E(x) = t$，并且最高次项系数为 $1$，$E(x)$ 剩下 $t$ 个系数未知。

  $E(x_i) F(x_i) = E(x_i) y_i$ 对所有采样点成立。这给我们提供了 $n$ 个方程，$deg F(x) = n - 2t - 1$，令 $Q(x) = E(x) F(x)$，$deg Q(x) = n - t - 1$，线性系统 $Q(x_i) - E(x_i) y_i$ 一共 $n$ 个方程，$n$ 个未知数，可以解出 $Q(x)$ 和 $E(x)$，之后 $F(x) = Q(x) / E(x)$ 或者 Chien search. 复杂度 $cal(O)(n^3)$

  Alternatively, 这是一个 Rational polynomial interpolation 问题，$Q(x_i) / E(x_i)$ 经过 $n$ 个点。wo/ FFT 复杂度 $cal(O)(n^2)$, w/ FFT 复杂度 $cal(O)(n log^2 n)$。（但我都不会）

  == Generator view vs. evaluation view

  有两种 (somewhat equivalent) 看待 Reed-Solomon code 的方式。

  SSS 里常见的构造对应 RS code 的 Evaluation view，这也是 Reed & Solomon's original view: 数据在 pre-defined points of evaluation. RS code 目前实现中常见的方法是 Generator view (BCH view): 数据在 polynomial coefficients 上。两者之间的转换就是一次 NFT.

  对于 Generator view 的 RS code，预先选定的是一个 Generator polynomial $G(x)$，$deg G(x) = 2t$。Underlying field $F$ 满足 $|F| = n+1$，要求 $G(x) divides x^n - 1$。Generator polynomial 的常见构造方式是选定一个 Underlying field $F$ 的 primitive element $alpha$, $G(x) = sum_(i=0)^(2t) alpha^i x^i$。

  对于 $m$ 个消息 $r_0, ..., r_(m-1)$，Message polynomial 是 $M(x) = sum_(i=0)^(m-1) r_i x^i$。有两种编码方式得到 Codeword $C(x)$：
  - 简单编码直接让 $C(x) = G(x) dot M(x)$。解码的时候需要做一次多项式除法，错误校验是看余多项式。
  - Systematic encoding 令 $C'(x) = M(x) dot x^2t$，然后 $C(x) = C'(x) - (C'(x) mod G(x))$。Systematic encoding 的好处是前 $m$ 个符号就是消息，解码的时候非常简单，但是错误校验还是得做一次除法。

  Sidenote: 因为消息总能做 Padding，尤其是 Systematic encoding 里面消息 Padding 直接对应 Codeword padding，所以都可以不传这部分 Codeword。因此 $n = |F| - 1$ 的限制事实上限制的是最大 Block length。Evaluation view 也有类似的限制，这个限制来自于 Evaluation point 的个数。但是因为可以选任意 $F$ 元素当作 evaluation point，所以限制比 Generator view 要大 1. (Related: Extended RS & Doubly-extended RS， 但是我不懂这些)

  TODO: 看看 Berlekamp-Massey
]