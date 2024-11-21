module Random::SinglePrecisionFloat
  # The multiplier to convert the least significant 24-bits of an Int32 to a
  # Float32.
  private FLOAT_UNIT = 1_f32 / (1 << 24)

  # Returns the next 32-bit float.
  def next_float : Float32
    # require the least significant 24-bits so shift the higher bits across
    (next_u >> 8) * FLOAT_UNIT
  end
end

module Random::DoublePrecisionFloat
  # The multiplier to convert the least significant 53-bits of a UInt64 to a
  # Float64.
  private DOUBLE_UNIT = 1_f64 / (1_u64 << 53)

  # Returns the next 64-bit float.
  def next_float : Float64
    # require the least significant 53-bits so shift the higher bits across
    (next_u >> 11) * DOUBLE_UNIT
  end
end
