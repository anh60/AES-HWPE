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
    uint32_t key_mode; // 0 = 128 bit; 1 = 256 bit
    uint32_t *key;
    uint32_t encryption_decryption_mode; // 0 = decrypt; 1 = encrypt
} aes_config_t;

/**
 * @brief Starts the AES accelerator and sends the configuration parameters.
 *
 * @param[in] aes_config the configuration parameters used to setup the AES accelerator.
 *
 * @return 0 if successful, or a negative number on error.
 */
int aes_hwpe_start(aes_config_t *aes_config);

/**
 * @brief Enables the HWPE.
 */
void aes_hwpe_init(void);

/**
 * @brief Disables the HWPE.
 */
void aes_hwpe_deinit(void);

#endif