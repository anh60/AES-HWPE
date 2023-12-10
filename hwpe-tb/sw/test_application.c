/*
 * Authors:  Andreas Hølleland, Marcus Tjomsaas
 */

#include <stdint.h>

#include "aes_driver/aes_hwpe.c"

#define ENCRYPTION_MEMORY 0x1C010100
#define DECRYPTION_MEMORY 0x1C010200

uint32_t *encrypt_mem_address = (uint32_t *)ENCRYPTION_MEMORY;
uint32_t *decrypt_mem_address = (uint32_t *)DECRYPTION_MEMORY;

/*// Could also do this!
uint32_t encrypt_mem_address[50];
uint32_t decrypt_mem_address[50];
*/

#define KEY_BIT_LENGTH 256
uint32_t aes_key[KEY_BIT_LENGTH / 32] = {
    0x4C48DCCC,
    0x20A7140E,
    0x945B583D,
    0x099B712C,
    0x1E18FA7A,
    0x27F02E74,
    0xD9415694,
    0x5724CA72,
};

uint32_t plaintext[] = {
    0x01020304,
    0x05060708,
    0x090A0B0C,
    0x0D0E0F10,
    0x11121314,
    0x15161718,
    0x191A1B1C,
    0x1D1E1F20,
    0x21222324,
};

int main()
{
    volatile int errors = 0;

    // AES setup for encryption of "plaintext" and store it in  "encrypt_mem_address".
    aes_config_t aes = {
        .input_address = plaintext,
        .output_address = encrypt_mem_address,
        .data_length = sizeof(plaintext), // Can encrypt any byte size
        .key_mode = KEY_MODE_256,
        .key = aes_key,
        .encryption_decryption_mode = ENCRYPT,
    };

    aes_hwpe_init();
    (void)aes_hwpe_start(&aes);

    // Sleeps until the HWPE interrupts with a hwpe.done flag.
    asm volatile("wfi" ::: "memory");

    // AES setup for decryption of "ecrypt_mem_address" and store it in  "decrypt_mem_address".
    aes.input_address = encrypt_mem_address;
    aes.output_address = decrypt_mem_address;
    aes.data_length = 16 * 3; // Can only decrypt in increments of 16 bytes (128 bit).
    aes.encryption_decryption_mode = DECRYPT;

    (void)aes_hwpe_start(&aes);
    asm volatile("wfi" ::: "memory");

    aes_hwpe_deinit();

    // return errors
    *(int *)0x80000000 = errors;

    return errors;
}
