# Based on "Xorshift RNGs" by George Marsaglia.
#
# See <https://www.jstatsoft.org/article/view/v008i14>
#
# NOTE: not suitable for cryptography or secure purposes.
abstract class Random::XorShift
  include Random

  @[AlwaysInline]
  private def xorshift(x, a, b, c)
    x ^= x << a
    x ^= x >> b
    x ^= x << c
  end
end
