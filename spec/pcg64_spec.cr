require "spec"
require "../src/pcg64"

describe Random::PCG64 do
  vectors = {
    0x86b1da1d72062b68_u64, 0x1304aa46c9853d39_u64, 0xa3670e9e0dd50358_u64,
    0xf9090e529a7dae00_u64, 0xc85b9fd837996f2c_u64, 0x606121f8e3919196_u64,
  }

  it "initializes" do
    typeof(Random::PCG64.new)
    typeof(Random::PCG64.new(42))
    typeof(Random::PCG64.new(42, 54))
  end

  it "test vectors" do
    rng = Random::PCG64.new(42, 54)

    # test vectors
    vectors.each do |vector|
      rng.next_u.should eq(vector)
    end

    # jump back
    rng.jump(-6)

    # test vectors again
    vectors.each do |vector|
      rng.next_u.should eq(vector)
    end
  end
end
