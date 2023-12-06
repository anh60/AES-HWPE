/*
 * Authors:  Andreas Hølleland, Marcus Alexander Tjomsaas
 */

#ifndef __HAL_HWPE_H__
#define __HAL_HWPE_H__

/*
 * Control and generic configuration register layout
 * ================================================================================
 *  # reg |  offset  |  bits   |   bitmask    ||  content
 * -------+----------+---------+--------------++-----------------------------------
 *     0  |  0x0000  |  31: 0  |  0xffffffff  ||  TRIGGER
 *     1  |  0x0004  |  31: 0  |  0xffffffff  ||  ACQUIRE
 *     2  |  0x0008  |  31: 0  |  0xffffffff  ||  EVT_ENABLE
 *     3  |  0x000c  |  31: 0  |  0xffffffff  ||  STATUS
 *     4  |  0x0010  |  31: 0  |  0xffffffff  ||  RUNNING_JOB
 *     5  |  0x0014  |  31: 0  |  0xffffffff  ||  SOFT_CLEAR
 *   6-15 |          |         |              ||  Reserved
 * ================================================================================
 *
 * Job-dependent registers layout
 * ================================================================================
 *  # reg |  offset  |  bits   |   bitmask    ||  content
 * -------+----------+---------+--------------++-----------------------------------
 *     0  |  0x0040  |  31: 0  |  0xffffffff  ||  INPUT_ADDR
 *     1  |  0x0044  |  31: 0  |  0xffffffff  ||  OUTPUT_ADDR
 *     2  |  0x0048  |  31: 0  |  0xffffffff  ||  NUM_BLOCKS
 * ================================================================================
 *
 */

/* LOW-LEVEL HAL */
#define HWPE_ADDR_BASE ARCHI_FC_HWPE_ADDR
#define HWPE_ADDR_SPACE 0x00000100

// For all the following functions we use __builtin_pulp_OffsetedWrite and __builtin_pulp_OffsetedRead
// instead of classic load/store because otherwise the compiler is not able to correctly factorize
// the HWPE base in case several accesses are done, ending up with twice more code

#define HWPE_WRITE(value, offset) *(int *)(ARCHI_HWPE_ADDR_BASE + offset) = value
#define HWPE_READ(offset) *(int *)(ARCHI_HWPE_ADDR_BASE + offset)

static inline void hwpe_input_addr_set(unsigned int value)
{
  HWPE_WRITE(value, HWPE_INPUT_ADDR);
}

static inline void hwpe_output_addr_set(unsigned int value)
{
  HWPE_WRITE(value, HWPE_OUTPUT_ADDR);
}

static inline void hwpe_num_blocks_set(unsigned int value)
{
  HWPE_WRITE(value, HWPE_NUM_BLOCKS);
}

static inline void hwpe_trigger_job()
{
  HWPE_WRITE(0, HWPE_TRIGGER);
}

static inline int hwpe_acquire_job()
{
  return HWPE_READ(HWPE_ACQUIRE);
}

static inline unsigned int hwpe_get_status()
{
  return HWPE_READ(HWPE_STATUS);
}

static inline void hwpe_soft_clear()
{
  volatile int i;
  HWPE_WRITE(0, HWPE_SOFT_CLEAR);
}

static inline void hwpe_cg_enable()
{
  return;
}

static inline void hwpe_cg_disable()
{
  return;
}

#endif /* __HAL_HWPE_H__ */
