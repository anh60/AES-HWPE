/*
 * Copyright (C) 2019-2020 ETH Zurich and University of Bologna
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
 * Authors:  Francesco Conti <f.conti@unibo.it>
 */

#include "pmsis.h"
#include "stdio.h"
#include <stdint.h>
#include "hal_datamover.h"
#include "lfsr32.h"

#define DATA_SIZE    (16*1024)
#define DATAMOVER_BW (256 / 8)

static int ret_value;

static void pe_entry(void *arg) {
  
  printf("Entered cluster on cluster %d core %d\n", pi_cluster_id(), pi_core_id());

  pi_cl_team_barrier();

  int errors = 0;

  if (pi_core_id() == 0) {

    uint8_t volatile *x = (uint8_t volatile *) pi_cl_l1_malloc(NULL, DATA_SIZE);
    uint8_t volatile *y = (uint8_t volatile *) pi_cl_l1_malloc(NULL, DATA_SIZE);
    generate_random_buffer((int) x, (int) x + DATA_SIZE, DEFAULT_SEED);

    // enable clock
    DATAMOVER_CG_ENABLE();

    // setup HCI
    DATAMOVER_SETPRIORITY_DATAMOVER(); // priority to DATAMOVER w.r.t. cores, DMA
    DATAMOVER_RESET_MAXSTALL();   // reset maximum stall
    DATAMOVER_SET_MAXSTALL(8);    // set maximum consecutive stall to 8 cycles for cores, DMA side

    // soft-clear DATAMOVER
    DATAMOVER_WRITE_CMD(DATAMOVER_SOFT_CLEAR, DATAMOVER_SOFT_CLEAR_ALL);
    for(volatile int kk=0; kk<10; kk++);

    // acquire job
    int job_id = -1;
    DATAMOVER_BARRIER_ACQUIRE(job_id);

    // set up datamover
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_PTR,  x);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_PTR, y);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_TOT_LEN,       DATA_SIZE / DATAMOVER_BW);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D0_LEN,     DATA_SIZE / DATAMOVER_BW);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D0_STRIDE,  DATAMOVER_BW);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D1_LEN,     DATA_SIZE / DATAMOVER_BW);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D1_STRIDE,  0);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_IN_D2_STRIDE,  0);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D0_LEN,    DATA_SIZE / DATAMOVER_BW);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D0_STRIDE, DATAMOVER_BW);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D1_LEN,    DATA_SIZE / DATAMOVER_BW);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D1_STRIDE, 0);
    DATAMOVER_WRITE_REG(DATAMOVER_REG_OUT_D2_STRIDE, 0);

    // commit and trigger datamover operation
    DATAMOVER_WRITE_CMD(DATAMOVER_COMMIT_AND_TRIGGER, DATAMOVER_TRIGGER_CMD);
    
    // wait for end of computation
    DATAMOVER_BARRIER();

    // disable clock
    DATAMOVER_CG_DISABLE();

    // set priority to core side
    DATAMOVER_SETPRIORITY_CORE();

    ret_value = check_random_buffer((int) y, (int) y + DATA_SIZE, DEFAULT_SEED);

  }
  pi_cl_team_barrier();
}

static void cluster_entry(void *arg) {
  pi_cl_team_fork(0, pe_entry, 0);
}

void test_kickoff(void *arg)
{
  struct pi_device cluster_dev;
  struct pi_cluster_conf conf;
  struct pi_cluster_task task;
  ret_value = 0;

  pi_cluster_conf_init(&conf);
  conf.id = 0;

  pi_open_from_conf(&cluster_dev, &conf);
    
  pi_cluster_open(&cluster_dev);

  pi_cluster_task(&task, cluster_entry, NULL);

  pi_cluster_send_task_to_cl(&cluster_dev, &task);

  pi_cluster_close(&cluster_dev);

  pmsis_exit(ret_value);
}

int main()
{
  return pmsis_kickoff((void *)test_kickoff);
}
