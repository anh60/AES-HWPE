#include <stdint.h>

#ifndef __AES_HWPE_H__
#define __AES_HWPE_H__

void aes_hwpe_configure(uint8_t *input, uint8_t *output);

void aes_hwpe_start(void);

void aes_hwpe_init(void);

void aes_hwpe_deinit(void);

#endif