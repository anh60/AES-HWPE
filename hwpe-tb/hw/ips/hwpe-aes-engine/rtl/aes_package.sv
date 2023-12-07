/*
 * aes_package.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import hwpe_stream_package::*;


package aes_package;

  parameter int unsigned HWPE_INPUT_ADDR = 0;
  parameter int unsigned HWPE_OUTPUT_ADDR = 1;
  parameter int unsigned HWPE_KEY_255_224 = 2;
  parameter int unsigned HWPE_KEY_223_192 = 3;
  parameter int unsigned HWPE_KEY_191_160 = 4;
  parameter int unsigned HWPE_KEY_159_128 = 5;
  parameter int unsigned HWPE_KEY_127_96 = 6;
  parameter int unsigned HWPE_KEY_95_64 = 7;
  parameter int unsigned HWPE_KEY_63_32 = 8;
  parameter int unsigned HWPE_KEY_31_0 = 9;
  parameter int unsigned HWPE_KEY_MODE = 10;
  parameter int unsigned HWPE_DATA_BYTE_LENGTH = 11;


  typedef struct packed {
    hwpe_stream_package::ctrl_sourcesink_t aes_input_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t aes_output_sink_ctrl;
  } ctrl_streamer_t;

  typedef struct packed {
    hwpe_stream_package::flags_sourcesink_t aes_input_source_flags;
    hwpe_stream_package::flags_sourcesink_t aes_output_sink_flags;
  } flags_streamer_t;


  typedef struct packed {
    logic clear;
    logic enable;
    logic start;
    logic data_out_valid;
    logic [1:0] request_counter;
    logic [31:0] data_size;
    logic [1:0] key_size;
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