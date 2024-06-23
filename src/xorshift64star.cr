require "./xorshift64"

# Star variant of `XorShift64` by George Marsaglia with an invertible
# multiplication of the result.
#
# See <https://www.jstatsoft.org/article/view/v008i14>
#
# NOTE: not suitable for cryptography or secure purposes.
class Random::XorShift64Star < Random::XorShift64
  include Random::DoublePrecisionFloat

  # Returns the next 64-bit integer.
  def next_u : UInt64
    (@state = xorshift(@state, 17, 25, 27)) &* 0x2545f4914f6cdd1d_u64
  end
end
