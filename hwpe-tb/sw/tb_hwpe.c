/*
 * Copyright (C) 2019 ETH Zurich and University of Bologna
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

/*
 * Authors:  Francesco Conti <fconti@iis.ee.ethz.ch>
 */

#include <stdint.h>
// #include "aes_hwpe.h"
#include "inc/hwpe_stimuli_chipertext.h"
#include "inc/hwpe_stimuli_plaintext.h"

#include "aes_hwpe.c"
#include "archi_hwpe.h"
#include "hal_hwpe.h"

#define KEY_BIT_LENGTH 256
uint32_t key[KEY_BIT_LENGTH / 32] = {1, 2, 3, 4, 5, 6, 7, 8};

int main()
{
  volatile int errors = 0;

  uint8_t *input_addr = stim_plaintext;
  uint8_t *output_addr = stim_chipertext;

  aes_hwpe_init();

  // job-dependent registers
  aes_hwpe_configure(input_addr, output_addr, KEY_BIT_LENGTH / 32);

  aes_hwpe_key_set(key);

  // BLOCKING FUNCTION!
  aes_hwpe_start();

  // wait for end of computation
  // Sleeps until the HWPE interrupts with a hwpe.done flag.
  asm volatile("wfi" ::: "memory");

  aes_hwpe_start();

  asm volatile("wfi" ::: "memory");

  aes_hwpe_start();

  asm volatile("wfi" ::: "memory");

  aes_hwpe_deinit();

  // return errors
  *(int *)0x80000000 = errors;

  return errors;
}
