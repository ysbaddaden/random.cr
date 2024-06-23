require "./xorshift"

# Based on "Xorshift RNGs" by George Marsaglia.
#
# See <https://www.jstatsoft.org/article/view/v008i14>
#
# NOTE: not suitable for cryptography or secure purposes.
class Random::XorShift32 < Random::XorShift
  @state : UInt32

  def self.new
    seed = uninitialized UInt8[4]
    Random::Secure.random_bytes(seed.to_slice)
    new(seed.unsafe_as(UInt32))
  end

  def initialize(@state : UInt32)
  end

  # Returns the next 32-bit integer.
  def next_u : UInt32
    @state = xorshift(@state, 13, 17, 5)
  end
end
