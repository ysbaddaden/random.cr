# Random

A collection of Pseudo Random Number Generators (PRNG) algorithms for the
Crystal language. Each implementation implements the `Random` interface.

Continuation of the [crystal-random](https://github.com/crystal-lang/crystal-random)
shard.

## Installation

Add the shard:

```yaml
dependencies:
  random:
    github: ysbaddaden/random
```

## Usage

You may require `random/all` to include all algorithms, but it is recommended to
specify the chosen algorithms such as `random/xorshift128plus` for example.

## Algorithms

Sorted by increasing state.

|PRNG                         |w     |speed (x86)|speed (arm)|State     |Splittable|Cryptography|TestU01    |Comment|
|-----------------------------|------|-----------|-----------|----------|----------|------------|-----------|-------|
|`Random::XorShift32`         |32-bit|4.01ns     |3.24ns     |2$^{32}   |No        |No          |Fails      |too many TESTU01 failures|
|`Random::ISAAC` (stdlib)     |32-bit|8.02ns     |8.71ns     |2$^{64}   |No        |Yes         |-          ||
|`Random::PCG32` (stdlib)     |32-bit|4.41ns     |3.77ns     |2$^{64}   |No        |No          |Big Crush  ||
|`Random::PCG64`              |64-bit|4.47ns     |7.20ns     |2$^{64}   |No        |No          |?          ||
|`Random::SplitMix64`         |64-bit|3.77ns     |4.13ns     |2$^{64}   |No        |No          |Big Crush  |used to seed `XoShiRo128` and `XoShiRo256`|
|`Random::Splittable`         |64-bit|3.46ns     |3.91ns     |2$^{64}   |Yes       |No          |Big Crush  ||
|`Random::XorShift64`         |64-bit|3.55ns     |2.52ns !   |2$^{64}   |No        |No          |Fails      ||
|`Random::XorShift64Plus`     |32-bit|4.47ns     |3.77ns     |2$^{64}   |No        |No          |Small Crush|for `Float32` numbers|
|`Random::XorShift64Star`     |64-bit|3.51ns     |3.01ns     |2$^{64}   |No        |No          |Fails      |for `Float64` numbers|
|`Random::XoRoShiRo64StarStar`|32-bit|4.75ns     |4.10ns     |2$^{64}   |No        |No          |Big Crush  |all purpose generator|
|`Random::WyRand`             |64-bit|3.15ns !   |5.18ns     |2$^{64}   |No        |No          |Big Crush  ||
|`Random::Lehmer64`           |64-bit|3.15ns !   |5.53ns     |2$^{128}  |No        |No          |Big Crush  |simplest|
|`Random::Splittable128`      |64-bit|4.24ns     |4.70ns     |2$^{128}  |Yes       |No          |Big Crush  ||
|`Random::XorShift128`        |32-bit|5.97ns     |4.89ns     |2$^{128}  |No        |No          |Fails      ||
|`Random::XorShift128Plus`    |64-bit|3.38ns     |2.91ns     |2$^{128}  |No        |No          |?          |for `Float64` numbers|
|`Random::XoShiRo128StarStar` |32-bit|5.23ns     |4.15ns     |2$^{128}  |Yes       |No          |Big Crush  |all purpose generator|
|`Random::XoShiRo128Plus`     |32-bit|5.04ns     |4.28ns     |2$^{128}  |Yes       |No          |?          |for `Float32` numbers|
|`Random::XoShiRo256PlusPlus` |64-bit|4.07ns     |3.60ns     |2$^{256}  |Yes       |No          |Big Crush  |all purpose generator|
|`Random::XoShiRo256StarStar` |64-bit|3.97ns     |3.50ns     |2$^{256}  |Yes       |No          |Big Crush  |all purpose generator|
|`Random::XoShiRo256Plus`     |64-bit|3.90ns     |3.76ns     |2$^{256}  |Yes       |No          |?          |for `Float64` numbers|
|`Random::XorShift1024Star`   |64-bit|3.77ns     |4.00ns     |2$^{1024} |Yes       |No          |Fails      |for massive parallel computations|
|`Random::MT19937`            |32-bit|6.64ns     |5.13ns     |2$^{19937}|No        |No          |Fails      |Mersenne Twister (removed from stdlib)|

The `Plus` and `Star` scrambles for the xorshift family (including xoshiro and
xoroshiro) all fail BigCrush, but are still statistically correct enough to
generate floating-point numbers (either `Float32` or `Float64`) since their
weakest bits are skipped.

The algorithms were benchmarked on an Intel Core i7-4712HQ (Haswell) and an
Neoverse-N1 ARM server.

The TESTU01 results are aggregated from the following pages by Sebastiano Vigna
and Daniel Lemire, as well as different papers.

- <https://prng.di.unimi.it/>
- <https://github.com/lemire/testingRNG>
- <https://arxiv.org/pdf/1402.6246>
- <https://arxiv.org/pdf/1404.0390>

### TODO:

- [ ] `Random::ISAAC64`
- [ ] `Random::ChaCha12`
- [ ] `Random::ChaCha20`

Maybe also:

- [ ] `Random::MWC128`
- [ ] `Random::MWC256`
- [ ] `Random::MWC512`
- [ ] `Random::GMWC128`
- [ ] `Random::GMWC256`
- [ ] `Random::WELL512`
- [ ] `Random::WELL1024`
- [ ] `Random::WELL19937`
- [ ] `Random::WELL44497`
- [ ] `Random::XorWow`
- [ ] `Random::XoRoShiRo64Star`
- [ ] `Random::XoRoShiRo128Plus`
- [ ] `Random::XoRoShiRo128PlusPlus`
- [ ] `Random::XoRoShiRo128StarStar`
- [ ] `Random::XoShiRo512Plus`
- [ ] `Random::XoShiRo512PlusPlus`
- [ ] `Random::XoShiRo512StarStar`
- [ ] `Random::XoRoShiRo1024PlusPlus`
- [ ] `Random::XoRoShiRo1024StarStar`
- [ ] `Random::XoRoShiRo1024Star`

## License

Distributed under the Apache-2.0 license.

## Contributors

- Julien Portalier (@ysbaddaden)
- [crystal-lang](https://github.com/crystal-lang) The Crystal Lang Team - creator, maintainer
