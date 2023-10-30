/*
 * Copyright 2019-2020 Francesco Conti <f.conti@unibo.it>
 *
 * Adapted from https://github.com/russm/lfsr64
 * This is a simple 32-bit linear feedback shift register, printing
 * pseudo-random bytes to stdout.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define DEFAULT_SEED 0xdeadbeef
#define USE_BYTE_FEEDBACK

int generate_random_buffer(int addr_first, int addr_last, uint32_t seed);
int check_random_buffer(int addr_first, int addr_last, uint32_t seed);
