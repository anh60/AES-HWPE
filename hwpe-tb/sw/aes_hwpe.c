#include <stdint.h>

#include "aes_hwpe.h"
#include "archi_hwpe.h"
#include "hal_hwpe.h"

void aes_hwpe_configure(uint8_t *input, uint8_t *output, uint32_t data_byte_length, uint32_t key_byte_length)
{
    // job-dependent registers
    hwpe_input_addr_set((uint32_t)input);
    hwpe_output_addr_set((uint32_t)output);
    hwpe_data_data_byte_length_set(data_byte_length);
    hwpe_key_byte_length_set(key_byte_length);
    return;
}

void aes_hwpe_key_set(uint32_t *key_value)
{
    hwpe_key_set(key_value);
}

void aes_hwpe_start(void)
{

    while (hwpe_acquire_job() < 0)
        ;

    // start hwpe operation
    hwpe_trigger_job();

    return;
}

void aes_hwpe_init(void)
{
    // enable hwpe
    hwpe_cg_enable();

    return;
}

void aes_hwpe_deinit(void)
{
    // enable hwpe
    hwpe_cg_disable();

    return;
}