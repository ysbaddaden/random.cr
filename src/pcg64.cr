require "random/secure"

# This is a Crystal conversion of the C PCG implementation
#
#  Original file notice:
#
#  PCG Random Number Generation for C.
#
#  Copyright 2014 Melissa O'Neill <oneill@pcg-random.org>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#  For additional information about the PCG random number generation scheme,
#  including its license and other licensing options, visit
#
#        http://www.pcg-random.org
#

# pcg64_random_r:
#       -  result:      64-bit unsigned int (uint64_t)
#       -  period:      2^128  (* 2^127 streams)
#       -  state type:  pcg64_random_t (32 bytes)
#       -  output func: XSL-RR
class Random::PCG64
  include Random

  PCG_DEFAULT_MULTIPLIER_128 = 47026247687942121848144207491837523525_u128

  @state : UInt128
  @inc : UInt128

  def self.new
    seed = uninitialized UInt8[32]
    Random::Secure.random_bytes(seed.to_slice)
    state, inc = seed.unsafe_as(StaticArray(UInt128, 2))
    new(state, inc)
  end

  def initialize(initstate : Int, initseq : Int = 0)
    @state = 0_u128
    @inc = ((initseq.to_u128! << 1) | 1).to_u128!
    next_u
    @state &+= initstate.to_u128!
    next_u
  end

  def next_u : UInt64
    state = @state = @state &* PCG_DEFAULT_MULTIPLIER_128 &+ @inc;
    value = (state >> 64).to_u64! ^ state.to_u64!
    rot = (state >> 122).to_i32!
    return (value >> rot) | (value << ((-rot) & 63))
  end

  def jump(delta : Int) : Nil
    @state = advance_lcg_128(@state, UInt128.new!(delta), PCG_DEFAULT_MULTIPLIER_128, @inc)
  end

  @[AlwaysInline]
  private def advance_lcg_128(state : UInt128, delta : UInt128, cur_mult : UInt128, cur_plus : UInt128) : UInt128
    acc_mult = 1_u128
    acc_plus = 0_u128

    while delta > 0
      if (delta & 1) == 1
        acc_mult &*= cur_mult
        acc_plus = acc_plus &* cur_mult &+ cur_plus
      end
      cur_plus = (cur_mult &+ 1) &* cur_plus
      cur_mult &*= cur_mult
      delta //= 2
    end

    acc_mult &* state &+ acc_plus
  end
end
