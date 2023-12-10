/**
 * Authors:  Andreas Hølleland, Marcus Alexander Tjomsaas
 *
 * HARDWARE ABSTRACTION LAYER for the Advanced Encryption Standard Hardware Processing Engine.
 */

#include <stdint.h>

#ifndef __HAL_AES_HWPE_H__
#define __HAL_AES_HWPE_H__

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
 *    10  |  0x0068  |  31: 0  |  0x0000000f  ||  KEY_MODE
 *    11  |  0x006C  |  31: 0  |  0xffffffff  ||  DATA_BYTE_LENGTH
 *    12  |  0x0070  |  31: 0  |  0x0000000f  ||  ENCRYPT_DECRYPT_MODE
 *  13-47 |          |         |              ||  Unused
 * ================================================================================
 *
 */

/* LOW-LEVEL HAL */
#define HWPE_ADDR_BASE 0x100000

/* HWPE DEFUALT REGISTERS*/
#define HWPE_TRIGGER 0x00
#define HWPE_ACQUIRE 0x04
#define HWPE_FINISHED 0x08
#define HWPE_STATUS 0x0c
#define HWPE_RUNNING_JOB 0x10
#define HWPE_SOFT_CLEAR 0x14
/* HWPE JOB DEPENDTENT REGISTERS*/
#define HWPE_INPUT_ADDR 0x40
#define HWPE_OUTPUT_ADDR 0x44
#define HWPE_KEY_255_224 0x48
#define HWPE_KEY_223_192 0x4C
#define HWPE_KEY_191_160 0x50
#define HWPE_KEY_159_128 0x54
#define HWPE_KEY_127_96 0x58
#define HWPE_KEY_95_64 0x5C
#define HWPE_KEY_63_32 0x60
#define HWPE_KEY_31_0 0x64
#define HWPE_KEY_MODE 0x68
#define HWPE_DATA_BYTE_LENGTH 0x6C
#define HWPE_ENCRYPT_DECRYPT_MODE 0x70
/* HWPE FUNCTIONS*/
#define HWPE_WRITE(value, offset) *(int *)(HWPE_ADDR_BASE + offset) = value
#define HWPE_READ(offset) *(int *)(HWPE_ADDR_BASE + offset)

/**
 * @brief Sends the location (address) to where the HWPE should read data from.
 *
 * @param[in] address location where data is loaded.
 */
static inline void hwpe_input_addr_set(uint32_t *address)
{
  // Send the value of the address, not the pointer
  HWPE_WRITE((uint32_t)address, HWPE_INPUT_ADDR);
}

/**
 * @brief Sends the location (address) to where the HWPE should send data to.
 *
 * @param[in] address location where the data is stored.
 */
static inline void hwpe_output_addr_set(uint32_t *address)
{
  // Send the value of the address, not the pointer
  HWPE_WRITE((uint32_t)address, HWPE_OUTPUT_ADDR);
}

/**
 * @brief Sets the key mode, only supports two modes.
 *
 * @param[in] mode is either 0 (128 bit key) or 1 (256 bit key).
 */
static inline void hwpe_key_mode_set(uint32_t mode)
{
  HWPE_WRITE(mode, HWPE_KEY_MODE);
}

/**
 * @brief Sends how many bytes the HWPE should use for its encryption or decryption.
 *
 * @param[in] byte_length is the size of the data to encrypt / decrypt.
 *
 * @note Decryption only works on increments of 16 bytes (128 bit) while encryption works on any byte size.
 */
static inline void hwpe_data_byte_length_set(uint32_t byte_length)
{
  HWPE_WRITE(byte_length, HWPE_DATA_BYTE_LENGTH);
}

/**
 * @brief Sends the key to the HWPE. Can only send 32 bits at a time.
 *
 * @param[in] key is a pointer to where the key is stored.
 */
static inline void hwpe_key_set(uint32_t *key)
{

  HWPE_WRITE(key[7], HWPE_KEY_255_224);
  HWPE_WRITE(key[6], HWPE_KEY_223_192);
  HWPE_WRITE(key[5], HWPE_KEY_191_160);
  HWPE_WRITE(key[4], HWPE_KEY_159_128);
  HWPE_WRITE(key[3], HWPE_KEY_127_96);
  HWPE_WRITE(key[2], HWPE_KEY_95_64);
  HWPE_WRITE(key[1], HWPE_KEY_63_32);
  HWPE_WRITE(key[0], HWPE_KEY_31_0);
}

/**
 * @brief Sets the HWPE mode to either decrypt or encrypt data.
 *
 * @param[in] mode is either 0 (DECRYPTION) or 1 (ENCRYPTION).
 */
static inline void hwpe_aes_enc_dec_set(uint32_t mode)
{
  HWPE_WRITE(mode, HWPE_ENCRYPT_DECRYPT_MODE);
}

/**
 * @brief Starts the HWPE.
 */
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
  HWPE_WRITE(0, HWPE_SOFT_CLEAR);
}

static inline void hwpe_cg_enable()
{
  // HWPE is always enabled in the RTL.
  //  TODO: Add software enable functionallity.
  return;
}

static inline void hwpe_cg_disable()
{
  // TODO: Add software disable functionallity.
  return;
}

#endif /* __HAL_AES_HWPE_H__ */
