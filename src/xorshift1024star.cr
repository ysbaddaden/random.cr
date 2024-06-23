# XorShift variant suggested by Sebastiano Vigna.
#
# You may prefer `XoShiRo256StarStar` instead for a smaller memory footprint and
# better overall quality.
#
# See <http://vigna.di.unimi.it/ftp/papers/xorshift.pdf>
#
# NOTE: not suitable for cryptography or secure purposes.
class Random::XorShift1024Star
  include Random
  include Random::DoublePrecisionFloat

  JUMP_COEFFICIENTS = UInt64.static_array(
    0x84242f96eca9c41d_u64, 0xa3c65b8776f96855_u64, 0x5b34a39f070b5837_u64,
    0x4489affce4f31a1e_u64, 0x2ffeeb0a48316f40_u64, 0xdc2d9891fe68c022_u64,
    0x3659132bb12fea70_u64, 0xaac17d8efa43cab8_u64, 0xc4cb815590989b13_u64,
    0x5ee975283d71c93b_u64, 0x691548c86c1bd540_u64, 0x7910c41d10a1e6a5_u64,
    0x0b5fc64563b3e2a8_u64, 0x047f7684e9fc949d_u64, 0xb99181f2d8f685ca_u64,
    0x284600e3f30e38c3_u64
  )

  @state : StaticArray(UInt64, 16)
  @index : Int32

  def self.new
    seed = uninitialized UInt8[128]
    Random::Secure.random_bytes(seed.to_slice)
    new(seed.unsafe_as(StaticArray(UInt64, 16)))
  end

  def initialize(@state : StaticArray(UInt64, 16))
    @index = 0
  end

  # Returns the next 64-bit integer.
  def next_u : UInt64
    p = @index
    s0 = @state.to_unsafe[p]
    p = (p &+ 1) & 15
    s1 = @state.to_unsafe[p]
    s1 ^= s1 << 31 # a
    t = s1 ^ s0 ^ (s1 >> 11) ^ (s0 >> 30) # b, c
    @state.to_unsafe[p] = t
    @index = p
    t &* 1181783497276652981_u64
  end

  # Equivalent to 2**512 calls to `#next_u`.
  def jump : self
    dup.tap(&.perform_jump)
  end

  protected def perform_jump : Nil
    t = StaticArray(UInt64, 16).new(0_u64)
    p = @index

    JUMP_COEFFICIENTS.each do |coefficient|
      64.times do |b|
        if coefficient.bit(b) == 1
          16.times do |j|
            t.to_unsafe[j] = t.to_unsafe[j] ^ @state.to_unsafe[(j &+ p) & 15]
          end
          next_u
        end
      end
    end

    16.times do |j|
      @state.to_unsafe[(j &+ p) & 15] = t.to_unsafe[j]
    end
  end
end
