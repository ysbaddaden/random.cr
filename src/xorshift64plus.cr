# Plus variant of Xorshift by Sebastiano Vigna that adds 2 32-bit xorshift
# sequences.
#
# The {17, 7, 16} triplet was chosen from George Marsaglia paper by Go
# developers.
#
# See:
# - <https://vigna.di.unimi.it/ftp/papers/xorshiftplus.pdf>
# - <https://www.jstatsoft.org/article/view/v008i14>
# - <https://cs.opensource.google/go/go/+/release-branch.go1.22:src/runtime/rand.go;l=191-201>
#
# NOTE: not suitable for cryptography or secure purposes.
class Random::XorShift64Plus
  include Random
  include Random::SinglePrecisionFloat

  @state : StaticArray(UInt32, 2)

  def self.new
    seed = uninitialized UInt8[8]
    Random::Secure.random_bytes(seed.to_slice)
    new(seed.unsafe_as(StaticArray(UInt32, 2)))
  end

  def initialize(@state : StaticArray(UInt32, 2))
  end

  # Returns the next 32-bit integer.
  def next_u : UInt32
    s1 = @state.to_unsafe[0]
    s0 = @state.to_unsafe[1]
    s1 ^= s1 << 17 # a
    s1 = s1 ^ s0 ^ (s1 >> 7) ^ (s0 >> 16) # b, c
    @state.to_unsafe[0] = s0
    @state.to_unsafe[1] = s1
    s0 &+ s1
  end
end
