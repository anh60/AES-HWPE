#include "aes_hwpe.h"
#include "hal_hwpe.h"
#include "archi_hwpe.h"

void aes_hwpe_configure(unsigned int *input, unsigned int *output)
{
    // job-dependent registers
    hwpe_input_addr_set(input);
    hwpe_output_addr_set(output);

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