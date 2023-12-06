#include <stdint.h>

#ifndef __AES_HWPE_H__
#define __AES_HWPE_H__

void aes_hwpe_configure(unsigned int *input, unsigned int *output);

void aes_hwpe_start(void);

void aes_hwpe_init(void);

void aes_hwpe_deinit(void);

#endif