require "./splitmix64"

abstract class Random::XoShiRo256
  include Random
  include Random::DoublePrecisionFloat

  private JUMP_COEFFICIENTS = UInt64.static_array(
    0x180ec6d33cfd0aba_u64,
    0xd5a61266f0c9392c_u64,
    0xa9582618e03fc9aa_u64,
    0x39abdc4529b1661c_u64,
  )

  private LONG_JUMP_COEFFICIENTS = UInt64.static_array(
    0x76e15d3efefdcbbf_u64,
    0xc5004e441c522fb3_u64,
    0x77710069854ee241_u64,
    0x39109bb02acbe635_u64,
  )

  @state : StaticArray(UInt64, 4)

  # Initializes the internal state using `SplitMix64` and a secure random seed.
  def self.new
    r = SplitMix64.new
    new(StaticArray(UInt64, 4).new { r.next_u })
  end

  # Initializes the internal state using `SplitMix64` and the given seed. This
  # approach makes 'warmup' unnecessary, and makes the probability of starting
  # from a state with a large fraction of bits set to zero astronomically small.
  def self.new(seed : UInt64)
    r = SplitMix64.new(seed)
    new(StaticArray(UInt64, 4).new { r.next_u })
  end

  def initialize(@state : StaticArray(UInt64, 4))
  end

  # Reinitializes the internal state using `SplitMix64` initialized with a
  # secure random seed.
  def new_seed : Nil
    r = SplitMix64.new
    @state = StaticArray(UInt64, 4).new { r.next_u }
  end

  @[AlwaysInline]
  private def rotl(x : UInt64, k : Int32)
    (x << k) | (x >> (64 &- k))
  end

  # Returns the next 64-bit integer.
  def next_u : UInt64
    s = @state
    result = yield s

    t = s[1] << 17

    s.to_unsafe[2] ^= s.to_unsafe[0]
    s.to_unsafe[3] ^= s.to_unsafe[1]
    s.to_unsafe[1] ^= s.to_unsafe[2]
    s.to_unsafe[0] ^= s.to_unsafe[3]

    s.to_unsafe[2] ^= t

    s.to_unsafe[3] = rotl(s.to_unsafe[3], 45)

    @state = s
    result
  end

  # Simulates 2^128 calls to `next_u`; it can be used to generate 2^128
  # non-overlapping subsequences for parallel computations.
  def jump : self
    copy = dup
    copy.perform_jump(JUMP_COEFFICIENTS)
    copy
  end

  # Simulates 2^192 calls to `next_u`; it can be used to generate 2^64 starting
  # points, from each of which `jump` will generate 2^64 non-overlapping
  # subsequences for parallel distributed computations.
  def long_jump : self
    copy = dup
    copy.perform_jump(LONG_JUMP_COEFFICIENTS)
    copy
  end

  protected def perform_jump(table) : Nil
    s0 = 0_u64
    s1 = 0_u64
    s2 = 0_u64
    s3 = 0_u64

    table.each do |x|
      64.times do |b|
        if (x & 1_u64 << b) != 0
          s0 ^= @state.to_unsafe[0]
          s1 ^= @state.to_unsafe[1]
          s2 ^= @state.to_unsafe[2]
          s3 ^= @state.to_unsafe[3]
        end
        next_u
      end
    end

    @state.to_unsafe[0] = s0
    @state.to_unsafe[1] = s1
    @state.to_unsafe[2] = s2
    @state.to_unsafe[3] = s3
  end

  # Returns a new instance that shares no mutable state with this instance. The
  # sequence generated by the new instance depends deterministically from the
  # state of this instance, but the probability that the sequence generated by
  # this instance and by the new instance overlap is negligible.
  def split
    self.class.new(@state.map { |s| murmurhash3(s) })
  end

  @[AlwaysInline]
  private def murmurhash3(x : UInt64) : UInt64
    x ^= x >> 33
    x &*= 0xff51afd7ed558ccd_u64
    x ^= x >> 33
    x &*= 0xc4ceb9fe1a85ec53_u64
    x ^= x >> 33
  end
end
