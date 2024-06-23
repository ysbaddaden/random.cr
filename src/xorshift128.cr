# Based on "Xorshift RNGs" by George Marsaglia.
#
# See <https://www.jstatsoft.org/article/view/v008i14>
class Random::XorShift128
  include Random

  @state : StaticArray(UInt32, 4)

  def self.new
    seed = uninitialized UInt8[16]
    Random::Secure.random_bytes(seed.to_slice)
    new(seed.unsafe_as(StaticArray(UInt32, 4)))
  end

  def initialize(@state : StaticArray(UInt32, 4))
  end

  # Returns the next 32-bit integer.
  def next_u : UInt32
    t = @state.to_unsafe[3]
    s = @state.to_unsafe[0]

    t ^= t << 11
    t ^= t >> 8
    result = t ^ s ^ (s >> 19)

    @state.to_unsafe[3] = @state.to_unsafe[2]
    @state.to_unsafe[2] = @state.to_unsafe[1]
    @state.to_unsafe[1] = s
    @state.to_unsafe[0] = result

    result
  end
end
