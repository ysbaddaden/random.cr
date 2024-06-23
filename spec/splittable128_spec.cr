require "./spec_helper"

describe Random::Splittable128 do
  it "#new" do
    Random::Splittable128.new
    Random::Splittable128.new(12345_u64)
    Random::Splittable128.new(123_u64, 456_u64)
    Random::Splittable128.new(123_u64, 456_u64, 0x789_u64)
  end

  it "#next_u" do
    # TODO: use test vectors!
    rng = Random::Splittable128.new(123_u64, 456_u64, 789_u64)
    rng.next_u.should eq(8293869368766803927_u64)
    rng.next_u.should eq(8753062605553298426_u64)
    rng.next_u.should eq(5638245596611466870_u64)
  end

  it "#split" do
    # TODO: use test vectors!
    rng = Random::Splittable128.new(123_u64, 456_u64, 789_u64)

    rng = rng.split
    rng.next_u.should eq(10804321185422215355_u64)

    rng = rng.split
    rng.next_u.should eq(37829550074215675_u64)
  end
end
