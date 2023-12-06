#include <stdint.h>

#include "aes_hwpe.h"
#include "archi_hwpe.h"
#include "hal_hwpe.h"

void aes_hwpe_configure(uint8_t *input, uint8_t *output)
{
    // job-dependent registers
    hwpe_input_addr_set((unsigned int)input);
    hwpe_output_addr_set((unsigned int)output);

    return;
}

void aes_hwpe_start(void)
{
    while (hwpe_acquire_job() < 0)
        ;

    // start hwpe operation
    hwpe_trigger_job();

    return;
}

void aes_hwpe_aquire_job()
{
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