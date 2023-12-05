/*
 * aes_package.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import hwpe_stream_package::*;


package aes_package;

  // Define the length of an AES encryption/decryption block in bits.
  parameter int unsigned AES_BLOCK_BIT_LENGTH = 256;

  // AES Register Definitions
  // These parameters are used to define the start addresses and operational details 
  // for plaintext and ciphertext in the AES encryption/decryption process.

  // AES_REG_PLAINTEXT_ADDR: Start address in the register file for the plaintext data.
  // For encryption, data is read from this address.
  // For decryption, data is written to this address.
  parameter int unsigned AES_REG_PLAINTEXT_ADDR = 0;

  // AES_REG_CIPHERTEXT_ADDR: Start address in the register file for the ciphertext data.
  // For encryption, data is written to this address.
  // For decryption, data is from to this address.
  parameter int unsigned AES_REG_CIPHERTEXT_ADDR = 1;

  // AES_REG_NUM_BLOCKS: Specifies the number of blocks to be encrypted or decrypted.
  // Used together wtih AES_REG_PLAINTEXT_ADDR and AES_REG_CIPHERTEXT_ADDR to calculate read/write length.
  parameter int unsigned AES_REG_NUM_BLOCKS = 2;


  typedef struct packed {
    hwpe_stream_package::ctrl_sourcesink_t plaintext_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t chipertext_sink_ctrl;
  } ctrl_streamer_t;

  typedef struct packed {
    hwpe_stream_package::flags_sourcesink_t plaintext_source_flags;
    hwpe_stream_package::flags_sourcesink_t chipertext_sink_flags;
  } flags_streamer_t;


  typedef struct packed {
    logic clear;
    logic enable;
    logic start;
    logic data_out_valid;
    logic [1:0] request_counter;
  } ctrl_engine_t; 

    typedef struct packed {
    logic unsigned [$clog2(AES_BLOCK_BIT_LENGTH):0] chipertext_32byte_chunck_count; // 1 bit more as cnt starts from 1, not 0
    logic chipertext_valid;
  } flags_engine_t;

  // AES FSM states with explicit binary values. Helpfull when debugging.
  typedef enum { 
      AES_IDLE, 
      AES_STARTING,
      AES_REQUEST_DATA,
      AES_REQUEST_DATA_WAIT,
      AES_WORKING,
      AES_SEND_DATA,
      AES_SEND_DATA_WAIT,
      AES_MEMORY_WRITE_WAIT,
      AES_FINISHED
  } aes_state_t;

endpackage