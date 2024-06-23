class Random::XoRoShiRo64StarStar
  include Random

  @state : StaticArray(UInt32, 2)

  def self.new
    seed = uninitialized UInt8[8]
    Random::Secure.random_bytes(seed.to_slice)
    new(seed.unsafe_as(StaticArray(UInt32, 2)))
  end

  def self.new(seed : UInt64)
    new(seed.unsafe_as(StaticArray(UInt32, 2)))
  end

  def initialize(@state : StaticArray(UInt32, 2))
  end

  def new_seed : Nil
    seed = uninitialized UInt8[8]
    Random::Secure.random_bytes(seed.to_slice)
    new(seed.unsafe_as(StaticArray(UInt32, 2)))
  end

  @[AlwaysInline]
  private def rotl(x : UInt32, k : Int32)
    (x << k) | (x >> (32 &- k))
  end

  def next_u : UInt32
    s = @state
    result = rotl(s.to_unsafe[0] &* 0x9e3779bb_u32, 5) &* 5

    s.to_unsafe[1] ^= s.to_unsafe[0]
    @state[0] = rotl(s.to_unsafe[0], 26) ^ s.to_unsafe[1] ^ (s.to_unsafe[1] << 9) # a, b
    @state[1] = rotl(s.to_unsafe[1], 13) # c

    result
  end
end
