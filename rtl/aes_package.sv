/*
 * aes_package.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import hwpe_stream_package::*;

package aes_package;

  parameter int unsigned AES_BLOCK_LENGTH  = 256;

  // registers in register file
  parameter int unsigned AES_REG_ENCRYPT_START_ADDR_IN  = 0;
  parameter int unsigned AES_REG_ENCRYPT_START_ADDR_OUT = 1;
  parameter int unsigned AES_REG_ENCRYPT_LENGTH         = 2;


  typedef struct packed {
    hwpe_stream_package::ctrl_sourcesink_t plaintext_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t chipertext_sink_ctrl;
  } ctrl_streamer_t;

  typedef struct packed {
    hwpe_stream_package::flags_sourcesink_t plaintext_source_flags;
    hwpe_stream_package::flags_sourcesink_t chipertext_sink_flags;
    logic tcdm_fifo_empty;
  } flags_streamer_t;


  typedef struct packed {
    logic clear;
    logic enable;
    logic start;
  } ctrl_engine_t; 

    typedef struct packed {
    logic unsigned [$clog2(AES_BLOCK_LENGTH):0] chipertext_32byte_chunck_count; // 1 bit more as cnt starts from 1, not 0
    logic chipertext_valid;
  } flags_engine_t;

  // AES FSM states with explicit binary values. Helpfull when debugging.
  typedef enum logic [1:0] { 
      AES_IDLE      = 2'b00, 
      AES_STARTING  = 2'b01,
      AES_WORKING   = 2'b10, 
      AES_FINISHED  = 2'b11 
  } aes_state_t;

endpackage