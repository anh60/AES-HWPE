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
    0x4C, 0x48, 0xDC, 0xCC, 0x20, 0xA7, 0x14, 0x0E,
    0x94, 0x5B, 0x58, 0x3D, 0x09, 0x9B, 0x71, 0x2C,
    0x1E, 0x18, 0xFA, 0x7A, 0x27, 0xF0, 0x2E, 0x74,
    0xD9, 0x41, 0x56, 0x94, 0x57, 0x24, 0xCA, 0x72};

uint8_t data_to_encrypt[] = {0x24, 0xff, 0xab, 0x45, 0x23, 0x56, 0x12, 0x32, 0xff, 0xab, 0x45, 0x23, 0x56, 0x12, 0x32, 0xff, 0xab, 0x45, 0x23, 0x56, 0x12, 0x32, 0xff, 0xab, 0x45, 0x23, 0x56, 0x12, 0x32, 0xff, 0xab, 0x45, 0x23, 0x56, 0x12, 0x32};
uint8_t encryption_memory[50];
uint8_t decryption_memory[50];

int main()
{
  volatile int errors = 0;

  aes_hwpe_init();

  // Configuring the AES HWPE with the input location, output location, data size and key length.
  aes_hwpe_configure(&data_to_encrypt[0], &encryption_memory[0], sizeof(data_to_encrypt), KEY_BIT_LENGTH);

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
