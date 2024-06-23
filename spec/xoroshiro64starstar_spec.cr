require "./spec_helper"

describe Random::XoRoShiRo64StarStar do
  seed = UInt32.static_array(
    0x012de1ba_u32, 0xa5a818b8_u32,
  )

  it "#new" do
    Random::XoRoShiRo64StarStar.new # preferred
    Random::XoRoShiRo64StarStar.new(0xdeadbeef_u64)
    Random::XoRoShiRo64StarStar.new(seed)
  end

  it "#next_u" do
    sequence = UInt32.static_array(
      0x7ac00b42_u32, 0x1f638399_u32, 0x09e4aea4_u32, 0x05cbbd64_u32,
      0x1c967b7b_u32, 0x1cf852fd_u32, 0xc666f4e8_u32, 0xeea9f1ae_u32,
      0xca0fa6bc_u32, 0xa65d0905_u32, 0xa69afc95_u32, 0x34965e62_u32,
      0xdd4f04a9_u32, 0xff1c9342_u32, 0x638ff769_u32, 0x03419ca0_u32,
      0xb46e6dfd_u32, 0xf7555b22_u32, 0x8cab4e68_u32, 0x5a44b6ee_u32,
      0x4e5e1eed_u32, 0xd03c5963_u32, 0x782d05ed_u32, 0x41bda3e3_u32,
      0xd1d65005_u32, 0x88f43a8a_u32, 0xfffe02ea_u32, 0xb326624a_u32,
      0x1ec0034c_u32, 0xb903d8df_u32, 0x78454bd7_u32, 0xaec630f8_u32,
      0x2a0c9a3a_u32, 0xc2594988_u32, 0xe71e767e_u32, 0x4e0e1ddc_u32,
      0xae945004_u32, 0xf178c293_u32, 0xa04081d6_u32, 0xdd9c062f_u32,
    )
    rng = Random::XoRoShiRo64StarStar.new(seed)

    sequence.each { |expected| rng.next_u.should eq(expected) }
  end
end
