#import "../common.typ"

#common.scribble-post("初等代数")[
  代数课没有好好听，注定度过失败的一生了。

  == Montgomery 模乘

  在真实计算机中，不同带余除法的代价不同：比如除以 power of 2 非常便宜。Naive 的模乘实现需要用模数作为被除数，代价不好控制。Montgomery 模乘可以将计算过程中的除法替换为另一个被除数。

  $a, b in ZZ_q$，需要计算 $a dot b in ZZ_q$，如果 $ZZ_q$ 中的元素都使用最小非负代表元表示，这就是要计算 $(a dot b) mod q$。假设有另一个常数 $R in NN$ 满足 $R > q$ 而且两者互素。假设除以 $R$ 的代价较小。

  称 $x in ZZ_q$ 的 Montgomery 形式 $tilde(x) = x dot R in ZZ_q$。因为 $R$ 的带余除法代价小，计算 $mod R$ 的代价很小。需要注意的是 $dot$ 和 $mod q$ 的代价较大。只要能够避免这两个操作，就能得到更快的模乘实现。

  $R^*$ 是 $R$ 在 $ZZ_q$ 里面的逆元，$q^*$ 是 $q$ 在 $ZZ_R$ 里面的逆元。

  $
    tilde(a dot b) &= tilde(a) tilde(b) R^* mod q \
      &= (tilde(a) tilde(b) - (tilde(a) tilde(b) q^* mod R) q) R^* mod q
  $

  注意到 $forall x in ZZ$：

  $
    (x - (x q^* mod R) q) mod R &= (x - (x q^* q)) mod R = 0
  $

  所以 $(tilde(a) tilde(b) - (tilde(a) tilde(b) q^* mod R) q)$ 一定是 $R$ 的倍数，在 $ZZ$ 中计算 $(-) dot R^* mod q$ 相当于计算 $(-) / R mod q$：

  $
    tilde(a dot b) &= tilde(a) tilde(b) R^* mod q \
      &= (tilde(a) tilde(b) - (tilde(a) tilde(b) q^* mod R) q) R^* mod q \
      &= (tilde(a) tilde(b) - (tilde(a) tilde(b) q^* mod R) q) / R mod q
  $

  最后我们可以通过 Bound $(tilde(a) tilde(b) - (tilde(a) tilde(b) q^* mod R) q) slash R$ 来消除最外面的 $mod q$：注意到因为 $R > q$，这个值一定在 $(-q, q)$ 之间。所以我们只需要比较这个值是否是负数，如果是就加上 $q$ 就好了。

  实现中的一些细节：
  - 一般来说参数选择是 $R$ 是比 $q$ 大的最小支持高效计算的机器字。比如对于 Dilithium prime $q = 8380417< 2^23$，可以选择 $R = 2^32$。
  - 所有除了除以 $R$ 以外的计算都可以在 $ZZ_(R^2)$ 内进行。如果 $R = 2^32$，只需要有高效的 64 位加、减、乘法。
  - 真实实现中一般不用 $q^*$，而是用 $-q$ 在 $ZZ_R$ 内的逆元，因为 $ZZ_2R$ 中的加法一般比减法好处理。如果本身就有高效的 $ZZ_2R$ 减法，同时比较正负比比较常数要快，那么应该是用 $q^*$。

  Gemini 给出的伪代码：

  ```cpp
  #include <stdint.h>

  // 4236238847 is -q^(-1) mod 2^32
  #define QINV_NEG 4236238847u 
  #define Q 8380417u

  uint32_t montgomery_mul(uint32_t a_mont, uint32_t b_mont) {
    uint64_t prod = (uint64_t)a_mont * b_mont;
    
    // Calculate the multiple of Q needed to clear the lower 32 bits
    uint32_t t = (uint32_t)prod * QINV_NEG;
    
    // Add the multiple of Q and shift out the lower 32 bits (which are now guaranteed to be 0)
    uint64_t u = prod + (uint64_t)t * Q;
    uint32_t res = u >> 32;
    
    if (res >= Q) {
        res -= Q;
    }
    
    return res;
  }
  ```

  /*
  == Splitting field

  一些关于 Splitting field 的引理：

  - $R$ 交换环，理想 $I$ 是极大的当且仅当 $R / I$ 是域。
  - $f(x)$ 不可约 + $FF[x]$ 是一个 PID $=> f(x)$ 极大 $=> FF[x] / (f(x))$ 是域。
  */
]