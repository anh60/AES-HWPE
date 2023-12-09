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
 *     2  |  0x0048  |  31: 0  |  0xffffffff  ||  KEY_255_224
 *     3  |  0x004C  |  31: 0  |  0xffffffff  ||  KEY_223_192
 *     4  |  0x0050  |  31: 0  |  0xffffffff  ||  KEY_191_160
 *     5  |  0x0054  |  31: 0  |  0xffffffff  ||  KEY_159_128
 *     6  |  0x0058  |  31: 0  |  0xffffffff  ||  KEY_127_96
 *     7  |  0x005C  |  31: 0  |  0xffffffff  ||  KEY_95_64
 *     8  |  0x0060  |  31: 0  |  0xffffffff  ||  KEY_63_32
 *     9  |  0x0064  |  31: 0  |  0xffffffff  ||  KEY_31_0
 *    10  |  0x0068  |  31: 0  |  0xffffffff  ||  KEY_MODE
 *    11  |  0x006C  |  31: 0  |  0xffffffff  ||  DATA_BYTE_LENGTH
 * ================================================================================
 *
 */

/* LOW-LEVEL HAL */
#define HWPE_ADDR_BASE ARCHI_FC_HWPE_ADDR
#define HWPE_ADDR_SPACE 0x00000100

#define ENCRYPT 1
#define DECRYPT 0
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

static inline void hwpe_key_mode_set(unsigned int value)
{
  HWPE_WRITE(value, HWPE_KEY_MODE);
}

static inline void hwpe_data_byte_length_set(unsigned int value)
{
  HWPE_WRITE(value, HWPE_DATA_BYTE_LENGTH);
}

static inline void hwpe_key_set(uint32_t *value)
{

  HWPE_WRITE(value[7], HWPE_KEY_255_224);
  HWPE_WRITE(value[6], HWPE_KEY_223_192);
  HWPE_WRITE(value[5], HWPE_KEY_191_160);
  HWPE_WRITE(value[4], HWPE_KEY_159_128);
  HWPE_WRITE(value[3], HWPE_KEY_127_96);
  HWPE_WRITE(value[2], HWPE_KEY_95_64);
  HWPE_WRITE(value[1], HWPE_KEY_63_32);
  HWPE_WRITE(value[0], HWPE_KEY_31_0);
}

static inline void hwpe_aes_enc_dec_set(unsigned int value)
{
  HWPE_WRITE(value, HWPE_ENCRYPT_DECRYPT_MODE);
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
