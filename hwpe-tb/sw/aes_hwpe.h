#include <stdint.h>

#ifndef __AES_HWPE_H__
#define __AES_HWPE_H__

#define KEY_MODE_256 1
#define KEY_MODE_128 0

#define ENCRYPT 1
#define DECRYPT 0

typedef struct
{
    uint32_t *input_address;
    uint32_t *output_address;
    uint32_t data_length;
    uint32_t key_mode;
    uint32_t *key;
    uint32_t encryption_decryption_mode;
} aes_config_t;

int aes_hwpe_start(aes_config_t *aes_config);

void aes_hwpe_init(void);

void aes_hwpe_deinit(void);

#endif