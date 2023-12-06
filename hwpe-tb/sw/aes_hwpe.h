#include <stdint.h>

#ifndef __AES_HWPE_H__
#define __AES_HWPE_H__

void aes_hwpe_configure(uint8_t *input, uint8_t *output, uint8_t key_length);

void aes_hwpe_key_set(uint32_t *key_value);

void aes_hwpe_start(void);

void aes_hwpe_init(void);

void aes_hwpe_deinit(void);

#endif