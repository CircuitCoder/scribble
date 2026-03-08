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

  === Generator view vs. evaluation view

  有两种 (somewhat equivalent) 看待 Reed-Solomon code 的方式。

  SSS 里常见的构造对应 RS code 的 Evaluation view，这也是 Reed & Solomon's original view: 数据在 pre-defined points of evaluation. RS code 目前实现中常见的方法是 Generator view (BCH view): 数据在 polynomial coefficients 上。两者之间的转换就是一次 NFT.

  令 $m$ 为消息长度，$2t$ 为冗余，$n = m + 2t$ 为 Codeword 长度。

  对于 Generator view 的 RS code，预先选定的是一个 Generator polynomial $G(x)$，$deg G(x) = 2t$。Underlying field $FF$ 满足 $|FF| = n+1$，要求 $G(x) divides x^n - 1$。
  #quote(block: true)[Generator polynomial 的常见构造方式是选定一个 $FF$ 的 primitive element $alpha$ 和任意 $r in NN$, $G(x) = product_(i=1)^(2t) (x-alpha^(i + r))$。]

  对于 $m$ 个消息 $r_0, ..., r_(m-1)$，Message polynomial 是 $M(x) = sum_(i=0)^(m-1) r_i x^i$。有两种编码方式得到 Codeword $C(x)$：
  - 简单编码直接让 $C(x) = G(x) dot M(x)$。解码的时候需要做一次多项式除法
  - Systematic encoding 令 $C'(x) = M(x) dot x^2t$，然后 $C(x) = C'(x) - (C'(x) mod G(x))$。Systematic encoding 的好处是前 $m$ 个符号就是消息，解码的时候非常简单

  Sidenote: 因为消息总能做 Padding，尤其是 Systematic encoding 里面消息 Padding 直接对应 Codeword padding，所以都可以不传这部分 Codeword。因此 $n = |FF| - 1$ 的限制事实上限制的是最大 Block length。Evaluation view 也有类似的限制，这个限制来自于 Evaluation point 的个数。但是因为可以选任意 $FF$ 元素当作 evaluation point，所以限制比 Generator view 要大 1. (Related: Extended RS & Doubly-extended RS， 但是我没看懂这些)

  === Generator view decoding

  在 Generator view 构造中，Berlekamp-Welch 无法直接使用。Berlekamp-Massey 是一个求最小 LSFR 的算法，在 RS code 中可以用于在 generator view 的构造中替代 Berlekamp-Welch 做错误定位。

  注意到，两种 encoding 如果理解成 $M(x) |-> C(x)$ 在 $FF[x]_(m+2t-1)$多项式空间里的函数，都是可逆线性的。因为 $M(x)$ 是一个 degree-m 子空间，因此所有无错误 Codeword 也是一个 degree-m 子空间。错误校验是判定一个多项式是否在这个空间内。

  在这个多项式空间上取以下内积结构：系数乘积的和 (i.e. 选取 ${x^i}$ 做基映射到 $FF^n$)。$C(x)$。Codeword 空间的正交补空间 degree 是 $m + 2t - m = 2t$，因此可以通过 $2t$ 个多项式来 span 这个正交补空间。

  定义 *Parity-check polynomial* $H(x) = x^n - 1 / G(x)$。$deg H(x) = n - 2t = m$，所以 $H(x) dot x^0, H(x) dot x, ..., H(x) dot x^(2t-1)$ 都还在 $FF[x]_(m+2t-1)$ 内，并且线性无关。我们知道任何一个 $H(x) dot x^i$ 都不是 $G(x)$ 的倍数（我们知道 $x^n-1$ 没有重根），所以这就是正交补空间的一组基。
  #quote(block: true)[对于使用 Power of primitive root 构造的 $G(x)$，有更简单的办法给一组基。注意到任何 $G(x)$ 的根 $alpha^i$ 都是 $C(x)$ 的根，所以令 $H_i (x) = sum_(j=0)^(2t) a^(i j) x^j$，那么 $chevron.l H_i (x), C(x) chevron.r = C(alpha^i) = 0$，因此 ${H_i (x)}_{i = r+1...r+2t}$ 是一组正交补空间的基。]

  上述构造出的正交补空间的基不一定正交，但是我们还是可以把 $C(x)$ 投影上去，如果正确的编码是 $C_0 (x)$，投影得到的结果是 $E(x) = C(x) - C_0 (x)$ 也就是错误项在选定基下的坐标。这一坐标通常被称为 Syndrome ${S_i}_(i = 1...2t)$。
  #quote(block: true)[在使用 Power of primitive root 构造的 $G(x)$ 的情况下，投影直接就是求值，因此不用存储 $H$ 矩阵。]

  对于一般的 Parity-check matrix 构造，使用 Syndrome 进行错误定位可以利用 Meggitt Decoder: 一个查找表，加上 RS code 在 generator view construction 下是一个 Cyclic code 的特性检查。

  === Berlekamp-Massey

  如果我们使用 Powers of primitive root 构造 $G(x)$ 和 parity-check matrix $H$ (as a Vandermond matrix of $alpha, alpha^2 ... alpha^(2t)$)，有更高效的做法。

  假设 $E(x)$ 里面里面实际有 $nu <= t$ 个错误 ${ e_j }_(j=1...nu)$，位置分别在 $i_1, ..., i_nu$ 次项，也就是：

  $
    E(x) = sum_(j=1)^nu e_(i_j) x^(i_j)
  $

  因此 $S_i = E(alpha^i)$。现在的目标是找到 ${i_j}_(j = 1...nu)$。定义 Error locator polynomial:

  $
    Lambda(x) = product_(j=1)^nu (1 - x alpha^(i_j))
  $

  $Lambda(x)$ 的根为 ${alpha^(-i_j)}_{j=1...nu}$。假设 $Lambda(x)$ 展开为 $1 + Lambda_1 x + Lambda_2 x^2 + ... + Lambda_nu x^nu$，可以证明对于任意给定的正整数 $j <= 2t - nu$ (见 #link("https://en.wikipedia.org/wiki/Reed%E2%80%93Solomon_error_correction#Error_locator_polynomial")[Wikipedia])：

  $
    S_(j+nu) + Lambda_1 S_(j+nu-1) + Lambda_2 S_(j+nu-2) + ... + Lambda_nu S_j = 0
  $

  注意到这等价于一个需要找到一个最短的 $nu$-stage LFSR 生成 $S_1, S_2, ..., S_(2t)$。注意：对于一个 Recurrent sequence，如果我们知道他的 Generating LFSR has degree $<= t$，那么可以通过前 $2t$ 项确定 Generating LFSR。*但是反过来不成立：* 存在 $2t$ 个元素序列无法被一个 degree $<= t$ 的 LFSR 生成。

  BM 算法的直觉是一个一个试，看看目前猜的 LFSR 有没有出错。保存一个上一次出错的时候的 LFSR，以及当时出的错 $b$，如果这次出错 $d$，那么把上次的 LFSR $times b / d$ 减掉就可以用来修这次的错。Pseudocode in Rust format:

  ```rust
  // Input: S: Vec<Field> of length 2t
  let mut lambda = poly!(1); // C in most texts about BM
  let mut last_lambda = poly!(1); // B in most texts about BM
  let mut last_update = 0;
  let mut last_dis_inv = 1;

  for k in 0..2t {
    // Loop invariant:
    // last_lambda when evaluates by S[..last_update
    // will generate discrepancy last_dis_inv^(-1)
    let discrepancy = S.rev().skip(2 * t - k - 1) // Start from S[k]
      .zip(Lambda.coeffs()) // Coeffs from lowest degree to highest
      .map(|(s, l)| s * l)  // Field multiplication
      .sum();               // Field addition
    if discrepancy == 0 { continue; }
    let tmp = lambda.clone();
    let update = (discrepancy * last_dis_inv)
      * last_lambda * poly!(x^(k - last_update));
    // Because of the invariant, the update polynomial
    // will evaluates to exactly discrepancy at S[..k]
    lambda -= update;

    if lambda.degree() > tmp.degree() {
      // Degree updated
      last_lambda = tmp;
      last_update = k;
      last_dis_inv = 1 / discrepancy;
    }

    lambda / lambda.coeffs().first()
    // So that the constant term is always 1
  }
  ```

  Loop invariant -> 算法正确性。找到的 LFSR 肯定是一个成立的。最小性原因是我们在 Degree 上升的时候更新用来修 Discrepancy 的多项式，证明待补充（我还没看懂，乐）

  === Other notes

  现代解读中会把 BM 当成 Padé approximation 的一个特例，在这个解读下它的对面是扩展欧几里得。现代 RS decoder 也有很多通过 EEA 实现的。可能需要继续阅读以下内容：

  - #link("https://en.wikipedia.org/wiki/Forney_algorithm")[Forney algorithm]: Chien search 的替代算法，可以不用爆搜。在其中定义的 Error evaluator 是将 RS decoding 建模为 Padé approximation 问题的基础。
  - [Modified Euclidean Algorithms for Decoding Reed-Solomon Codes](https://arxiv.org/abs/0906.3778)
]