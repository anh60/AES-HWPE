/*
 * Authors:  Andreas Hølleland, Marcus Tjomsaas
 */

#include <stdint.h>

#include "aes_hwpe.c"

#define ENCRYPTION_MEMORY 0x1C010100
#define DECRYPTION_MEMORY 0x1C010200

volatile int *encrypt_mem_address = (volatile int *)ENCRYPTION_MEMORY;
volatile int *decrypt_mem_address = (volatile int *)DECRYPTION_MEMORY;

/*// Could also do this!
uint8_t encryption_memory[50];
uint8_t decryption_memory[50];
*/

#define KEY_BIT_LENGTH 256
uint32_t aes_key[KEY_BIT_LENGTH / 32] = {
    0x4C48DCCC, 0x20A7140E, 0x945B583D, 0x099B712C,
    0x1E18FA7A, 0x27F02E74, 0xD9415694, 0x5724CA72};

uint8_t plaintext[] = {
    0x01,
    0x02,
    0x03,
    0x04,
    0x05,
    0x06,
    0x07,
    0x08,
    0x09,
    0x0A,
    0x0B,
    0x0C,
    0x0D,
    0x0E,
    0x0F,
    0x10,
    0x11,
    0x12,
    0x13,
    0x14,
    0x15,
    0x16,
    0x17,
    0x18,
    0x19,
    0x1A,
    0x1B,
    0x1C,
    0x1D,
    0x1E,
    0x1F,
    0x20,
    0x21,
    0x22,
    0x23,
    0x24,
};

int main()
{
  volatile int errors = 0;

  aes_config_t aes = {
      .input_address = plaintext,
      .output_address = encrypt_mem_address,
      .data_length = sizeof(plaintext),
      .key_mode = KEY_MODE_256,
      .key = &aes_key, // This initializes all elements of the key array to 0
      .encryption_decryption_mode = ENCRYPT};

  aes_hwpe_init();

  (void)aes_hwpe_start(&aes);

  // wait for end of computation
  // Sleeps until the HWPE interrupts with a hwpe.done flag.
  asm volatile("wfi" ::: "memory");

  aes_hwpe_deinit();

  // return errors
  *(int *)0x80000000 = errors;

  return errors;
}
