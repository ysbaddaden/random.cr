# Splittable Random Number Generator (64-bit state)
#
# Based on the original implementation of SplittableRandom found in the "Fast
# Splittable Pseudorandom Number Generators" paper by Guy L. Steel, Doug Lea and
# Christine Flood. See:
# <https://www.researchgate.net/publication/273188325_Fast_Splittable_Pseudorandom_Number_Generators>.
#
# The original implementation was modified to match the SplittableRandom
# generator found in Java 8 SDK, as well as Lemire's C port (based on Vigna's).
# See <https://github.com/lemire/testingRNG/blob/master/source/splitmix64.h>
class Random::Splittable
  include Random
  include Random::DoublePrecisionFloat

  private GOLDEN_GAMMA = 0x9e3779b97f4a7c15_u64 # odd

  @seed : UInt64
  @gamma : UInt64

  def initialize
    s = default_gen.add(2_u64 &* GOLDEN_GAMMA)
    @seed = mix64(s)
    @gamma = mix_gamma(s &+ GOLDEN_GAMMA)
  end

  def initialize(@seed : UInt64)
    @gamma = GOLDEN_GAMMA
  end

  def initialize(@seed : UInt64, @gamma : UInt64)
  end

  def next_u : UInt64
    mix64(next_seed)
  end

  def next_int : Int32
    mix32(next_seed)
  end

  def split : self
    self.class.new(next_u, mix_gamma(next_seed))
  end

  private def next_seed : UInt64
    @seed &+= @gamma
  end

  private def mix64(z)
    z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9_u64
    z = (z ^ (z >> 27)) &* 0x94d049bb133111eb_u64
    z ^ (z >> 31)
  end

  private def mix32(z)
    z = (z ^ (z >> 33)) &* 0x62a9d9ed799705f5_u64
    (((z ^ (z >> 28)) &* 0xcb24d0a5c88c35b3_u64) >> 32).to_i32!
  end

  private def mix_gamma(z)
    z = (z ^ (z >> 33)) &* 0xff51afd7ed558ccd_u64
    z = (z ^ (z >> 33)) &* 0xc4ceb9fe1a85ec53_u64
    z = (z ^ (z >> 33)) | 1_u64
    n = (z ^ (z >> 1)).popcount
    (n < 24) ? z ^ 0xaaaaaaaaaaaaaaaa_u64 : z
  end

  private def default_gen
    @@default_gen ||= Atomic(UInt64).new(initial_seed)
  end

  private def initial_seed : UInt64
    bytes = uninitialized UInt8[sizeof(UInt64)]
    Random::Secure.random_bytes(bytes.to_slice)
    bytes.unsafe_as(UInt64)
  end
end
