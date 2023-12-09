#include <stdint.h>

#include "aes_hwpe.h"
#include "archi_hwpe.h"
#include "hal_hwpe.h"

#define ERROR_NOT_INITIALISED 1
#define ERROR_INVALID_KEY_

uint8_t is_initialised = 0;
uint8_t is_configured = 0;
uint8_t is_key_set = 0;

int aes_hwpe_start(aes_config_t *aes)
{
    if (!is_initialised)
    {
        return -ERROR_NOT_INITIALISED;
    }

    // job-dependent registers
    hwpe_input_addr_set(aes->input_address);
    hwpe_output_addr_set(aes->output_address);
    hwpe_data_byte_length_set(aes->data_length);
    hwpe_aes_enc_dec_set(aes->encryption_decryption_mode);
    hwpe_key_mode_set(aes->key_mode);
    hwpe_key_set(aes->key);

    // BLOCKING!!
    while (hwpe_acquire_job() < 0)
        ;

    // start hwpe operation
    hwpe_trigger_job();

    return 0;
}

void aes_hwpe_init(void)
{
    // enable hwpe
    hwpe_cg_enable();

    is_initialised = 1;
    return;
}

void aes_hwpe_deinit(void)
{
    is_initialised = 0;
    is_key_set = 0;
    is_configured = 0;

    hwpe_cg_disable();

    return;
}