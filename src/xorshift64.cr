require "./xorshift"

# 64-bit variant of the Xorshift RNG by George Marsaglia.
#
# See <https://www.jstatsoft.org/article/view/v008i14>
#
# NOTE: not suitable for cryptography or secure purposes.
class Random::XorShift64 < Random::XorShift
  include Random

  @state : UInt64

  def self.new
    seed = uninitialized UInt8[8]
    Random::Secure.random_bytes(seed.to_slice)
    new(seed.unsafe_as(UInt64))
  end

  def initialize(@state : UInt64)
  end

  # Returns the next 64-bit integer.
  def next_u : UInt64
    @state = xorshift(@state, 13, 7, 17)
  end
end
