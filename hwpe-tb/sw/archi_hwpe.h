/*
 * Authors:  Andreas Hølleland, Marcus Alexander Tjomsaas
 */

#ifndef __ARCHI_HWPE_H__
#define __ARCHI_HWPE_H__

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
 *    10  |  0x0068  |  31: 0  |  0x00000fff  ||  KEY_MODE
 *    11  |  0x006C  |  31: 0  |  0xffffffff  ||  DATA_BYTE_LENGTH
 * ================================================================================
 *
 */

#define ARCHI_CL_EVT_ACC0 0
#define ARCHI_CL_EVT_ACC1 1
#define ARCHI_HWPE_ADDR_BASE 0x100000

#define HWPE_TRIGGER 0x00
#define HWPE_ACQUIRE 0x04
#define HWPE_FINISHED 0x08
#define HWPE_STATUS 0x0c
#define HWPE_RUNNING_JOB 0x10
#define HWPE_SOFT_CLEAR 0x14

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
#define HWPE_ENCRYPT_DECRYPT_MODE 0x70;

#endif
