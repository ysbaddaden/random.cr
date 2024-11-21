# Lehmer’s generator.
#
# See:
# <https://lemire.me/blog/2019/03/19/the-fastest-conventional-random-number-generator-that-can-pass-big-crush/>
# <https://en.wikipedia.org/wiki/Lehmer_random_number_generator>
#
# NOTE: not suitable for cryptography or secure purposes.
class Random::Lehmer64
  include Random

  @state : UInt128

  def self.new
    seed = uninitialized UInt8[sizeof(UInt128)]
    Random::Secure.random_bytes(seed.to_slice)
    new seed.unsafe_as(UInt128)
  end

  def initialize(@state : UInt128)
  end

  def next_u : UInt64
    ((@state &*= 0xda942042e4dd58b5_u128) >> 64).to_u64!
  end
end
