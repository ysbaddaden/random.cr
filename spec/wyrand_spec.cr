require "spec"
require "../src/wyrand"

describe Random::WyRand do
  vectors = StaticArray[
    0xca71d87c76983989_u64,
    0x7e5ba61552085fc6_u64,
    0xcdf101e3bab88b9f_u64,
    0x0a3825ad73267808_u64,
    0x8ac0adc15d671c29_u64,
    0x74b0aa52525d790d_u64,
    0xe53f8280a3cccdf0_u64,
    0x637233aa01a1ed74_u64,
    0xb87970edbe884e6a_u64,
    0x4052cb14ca8875c9_u64,
    0x361a6a242710e06a_u64,
    0xf7bad3d2ceb0ccc8_u64,
    0xd3dd0701229fcfc9_u64,
    0x8a9ccd864fd3cc4e_u64,
    0xe8aacb57ff888fa4_u64,
  ]

  it "initializes" do
    typeof(Random::WyRand.new)
    typeof(Random::WyRand.new(42))
  end

  it "test vectors" do
    rng = Random::WyRand.new(42)

    vectors.each do |vector|
      rng.next_u.should eq(vector)
    end
  end
end
