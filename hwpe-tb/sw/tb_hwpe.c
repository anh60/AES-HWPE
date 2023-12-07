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

#include "aes_hwpe.c"
#include "archi_hwpe.h"
#include "hal_hwpe.h"

#define KEY_BIT_LENGTH 256
uint8_t key[KEY_BIT_LENGTH / 8] = {
    76, 72, 220, 204, 32, 167, 20, 14,
    148, 91, 88, 61, 9, 155, 113, 44,
    30, 24, 250, 122, 39, 240, 46, 116,
    217, 65, 86, 148, 87, 36, 202, 114};

uint8_t data_to_encrypt[] = {0x12, 0x23, 0x45, 0x56, 0xff, 0x32, 0xab, 0x24, 0x12, 0x23, 0x45, 0x56, 0xff, 0x32, 0xab, 0x24, 0x12, 0x23, 0x45, 0x56, 0xff, 0x32, 0xab, 0x24};
uint8_t encryption_memory[50];
uint8_t decryption_memory[50];

int main()
{
  volatile int errors = 0;

  aes_hwpe_init();

  // Configuring the AES HWPE with the input location, output location, data size and key length.
  aes_hwpe_configure(&data_to_encrypt[0], &encryption_memory[0], sizeof(data_to_encrypt), KEY_BIT_LENGTH);

  aes_hwpe_key_set(key);

  // BLOCKING FUNCTION!
  aes_hwpe_start();

  // wait for end of computation
  // Sleeps until the HWPE interrupts with a hwpe.done flag.
  asm volatile("wfi" ::: "memory");

  aes_hwpe_deinit();

  // return errors
  *(int *)0x80000000 = errors;

  return errors;
}
