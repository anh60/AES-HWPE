#include <stdint.h>

#ifndef __AES_HWPE_H__
#define __AES_HWPE_H__

void aes_hwpe_configure(uint8_t *input, uint8_t *output, uint32_t data_byte_length, uint32_t key_bit_length, uint32_t encrypt_decrypt_mode);

void aes_hwpe_key_set(uint8_t *key_value);

void aes_hwpe_start(void);

void aes_hwpe_init(void);

void aes_hwpe_deinit(void);

#endif