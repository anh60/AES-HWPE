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
 *     0  |  0x0040  |  31: 0  |  0xffffffff  ||  PLAINTEXT_ADDR
 *     1  |  0x0044  |  31: 0  |  0xffffffff  ||  CHIPERTEXT_ADDR
 *     2  |  0x0048  |  31: 0  |  0xffffffff  ||  NUM_BLOCKS
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

#define HWPE_PLAINTEXT_ADDR 0x40
#define HWPE_CHIPERTEXT_ADDR 0x44
#define HWPE_NUM_BLOCKS 0x48

#endif
