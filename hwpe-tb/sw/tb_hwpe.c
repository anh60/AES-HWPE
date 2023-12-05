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
#include "archi_hwpe.h"
#include "hal_hwpe.h"
#include "tinyprintf.h"

#include "inc/hwpe_stimuli_chipertext.h"
#include "inc/hwpe_stimuli_plaintext.h"

int main()
{

  uint8_t *chipertext = stim_chipertext;
  uint8_t *plaintext = stim_plaintext;

  volatile int errors = 0;

  int offload_id_tmp, offload_id;

  /* convolution-accumulation - HW */

  // enable hwpe
  hwpe_cg_enable();

  while ((offload_id_tmp = hwpe_acquire_job()) < 0)
    ;

  // job-dependent registers
  hwpe_plaintext_addr_set((unsigned int)plaintext);
  hwpe_d_addr_set((unsigned int)chipertext);

  // start hwpe operation
  hwpe_trigger_job();

  // wait for end of computation
  // Sleeps until the HWPE interrupts with a hwpe.done flag.
  asm volatile("wfi" ::: "memory");

  // disable hwpe
  hwpe_cg_disable();

  // check
  if (((uint32_t *)chipertext)[0] != 0x7f228fd6)
    errors++;
  if (((uint32_t *)chipertext)[1] != 0x23a7d5c2)
    errors++;
  if (((uint32_t *)chipertext)[2] != 0x7f281848)
    errors++;
  if (((uint32_t *)chipertext)[3] != 0x6127d834)
    errors++;

  // return errors
  *(int *)0x80000000 = errors;

  return errors;
}
