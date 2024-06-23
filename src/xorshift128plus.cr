# Plus variant of Xorshift by Sebastiano Vigna that adds 2 64-bit xorshift
# sequences.
#
# See <https://vigna.di.unimi.it/ftp/papers/xorshiftplus.pdf>
#
# NOTE: not suitable for cryptography or secure purposes.
class Random::XorShift128Plus
  include Random
  include Random::DoublePrecisionFloat

  @state : StaticArray(UInt64, 2)

  def self.new
    seed = uninitialized UInt8[16]
    Random::Secure.random_bytes(seed.to_slice)
    new(seed.unsafe_as(StaticArray(UInt64, 2)))
  end

  def initialize(@state : StaticArray(UInt64, 2))
  end

  # Returns the next 64-bit integer.
  def next_u : UInt64
    t = @state.to_unsafe[0]
    s = @state.to_unsafe[1]
    t ^= t << 23 # a
    t ^= t >> 18 # b
    t ^= s ^ (s >> 5)
    @state.to_unsafe[0] = s
    @state.to_unsafe[1] = t
    t &+ s
  end
end
