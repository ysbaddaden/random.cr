# Wang Yi's PRNG from wyhash.
#
# Defaults are from WyHash final v4.2
#
# See <https://github.com/wangyi-fudan/wyhash/>
#
# NOTE: not suitable for cryptography or secure purposes.
class Random::WyRand
  include Random

  @state : UInt64

  def self.new
    seed = uninitialized UInt8[sizeof(UInt64)]
    Random::Secure.random_bytes(seed.to_slice)
    new seed.unsafe_as(UInt64)
  end

  def initialize(@state : UInt64)
  end

  def next_u : UInt64
    a = @state &+= 0x2d358dccaa6c78a5_u64
    b = a ^ 0x8bb84b93962eacc9_u64

    # mum (mul128)
    r = a.to_u128! &* b.to_u128!
    low, high = r.to_u64!, (r >> 64).to_u64!

    # mix
    low ^ high
  end

  def next_u64 : UInt64
    a = @state &+= 0x2d358dccaa6c78a5_u64
    b = a ^ 0x8bb84b93962eacc9_u64

    # mum (mul128)
    r = a.to_u128! &* b.to_u128!
    low, high = r.to_u64!, (r >> 64).to_u64!

    # mix
    low ^ high
  end
end
