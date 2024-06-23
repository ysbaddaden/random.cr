# Splittable Random Number Generator (128-bit state)
#
# Based on the original implementation of SplittableRandom found in the "Fast
# Splittable Pseudorandom Number Generators" paper by Guy L. Steel, Doug Lea and
# Christine Flood. See:
# <https://www.researchgate.net/publication/273188325_Fast_Splittable_Pseudorandom_Number_Generators>.
class Random::Splittable128
  include Random
  include Random::DoublePrecisionFloat

  GAMMA_PRIME = (1_u64 << 57) &- 13 # "Ginny"
  GAMMA_GAMMA = 0x00281e2dba6606f3_u64

  @seed_hi : UInt64
  @seed_lo : UInt64
  @gamma_hi : UInt64
  @gamma_lo : UInt64
  @next_split : UInt64

  def self.new(seed_lo : UInt64)
    new(0_u64, seed_lo, 0_u64)
  end

  def self.new(seed_hi : UInt64, seed_lo : UInt64)
    new(seed_hi, seed_lo, 0_u64)
  end

  def initialize(@seed_hi = next_default_seed, @seed_lo = 0_u64, s : UInt64 = GAMMA_GAMMA)
    # we require 0 <= s <= Ginny
    s &+= GAMMA_GAMMA
    s &-= GAMMA_PRIME if s >= GAMMA_PRIME
    b = mix57(s)
    @gamma_hi = b >> 3
    extra_bits = (b << 61) >> 4
    s &+= GAMMA_GAMMA
    s &-= GAMMA_PRIME if s >= GAMMA_PRIME
    @gamma_lo = extra_bits | mix57(s) &+ 51
    @next_split = s
  end

  def split : self
    next_raw64
    Splittable128.new(@seed_hi, @seed_lo, @next_split)
  end

  def next_u : UInt64
    mix64(next_raw64)
  end

  def next_int : Int32
    (next_u >> 32).to_i32!
  end

  private def update(s : UInt64, g : UInt64) : UInt64
    # add g to s modulo George.
    p = s &+ g
    if p >= s
      p
    elsif p >= 0x800000000000000d_u64
      p &- 13
    else
      (p &- 13) &+ g
    end
  end

  private def mix64(z : UInt64) : UInt64
    z = (z ^ (z >> 33)) &* 0xff51afd7ed558ccd_u64
    z = (z ^ (z >> 33)) &* 0xc4ceb9fe1a85ec53_u64
    z ^ (z >> 33)
  end

  private def mix57(z : UInt64) : UInt64
    z = ((z ^ (z >> 33)) &* 0xff51afd7ed558ccd_u64) & 0x01ffffffffffffff_u64
    z = ((z ^ (z >> 33)) &* 0xc4ceb9fe1a85ec53_u64) & 0x01ffffffffffffff_u64
    z ^ (z >> 33)
  end

  private def next_raw64 : UInt64
    s, h, gh = @seed_lo, @seed_hi, @gamma_hi
    @seed_lo = s &+ @gamma_lo
    gh &+= 1 if @seed_lo < h # rare
    @seed_hi = h &+ gh
    seed_fixup if @seed_hi < h # very rare
    @seed_hi ^ @seed_lo
  end

  private def seed_fixup : Nil
    if @seed_lo >= (0x8000000000000000_u64 &+ 51)
      @seed_hi &-= 1
      @seed_lo &-= 51
    else
      s = @seed_lo &- 51_u64
      @seed_lo = s &+ @gamma_lo
      @seed_hi &+= 1 if @seed_lo < s
      @seed_hi &+= @gamma_hi &- 1
    end
  end

  private def next_default_seed : UInt64
    loop do
      p = default_gen.get
      q = p &+ GAMMA_GAMMA
      q &-= GAMMA_PRIME if q >= GAMMA_PRIME
      _, success = default_gen.compare_and_set(p, q)
      return mix57(q) if success
    end
  end

  private def default_gen
    @@default_gen ||= Atomic(UInt64).new(initial_seed)
  end

  private def initial_seed : UInt64
    bytes = uninitialized UInt8[sizeof(UInt64)]
    Random::Secure.random_bytes(bytes.to_slice)
    bytes.to_unsafe.as(UInt64*).value
  end
end
