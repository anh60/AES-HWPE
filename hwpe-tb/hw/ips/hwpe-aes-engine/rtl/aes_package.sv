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
  parameter int unsigned HWPE_ENCODE_DECODE_MODE = 12;



  typedef struct packed {
    hwpe_stream_package::ctrl_sourcesink_t aes_input_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t aes_output_sink_ctrl;
  } ctrl_streamer_t;

  typedef struct packed {
    hwpe_stream_package::flags_sourcesink_t aes_input_source_flags;
    hwpe_stream_package::flags_sourcesink_t aes_output_sink_flags;
  } flags_streamer_t;


  typedef struct packed {
    //Defualt
    logic clear;
    logic enable;

    //Core
    logic core_encode_decode;
    logic core_init_key;
    logic core_start;
    logic[255:0] core_key; 
    logic core_key_mode;


    //FSM
    logic data_out_valid;
    logic [1:0] request_counter;
    logic [31:0] data_size;
  } ctrl_engine_t; 

  typedef struct packed {
    logic core_ready;
    logic core_done; 
  } flags_engine_t;

  // AES FSM states with explicit binary values. Helpful when debugging.
  typedef enum { 
      AES_IDLE, 
      AES_START_KEY,
      AES_WAIT_KEY,
      AES_REQUEST_DATA,
      AES_REQUEST_DATA_WAIT,
      AES_START_CORE,
      AES_WAIT_CORE,
      AES_SEND_DATA,
      AES_SEND_DATA_WAIT,
      AES_MEMORY_WRITE_WAIT,
      AES_MEMORY_WRITE_DONE,
      AES_FINISHED
  } aes_state_t;

endpackage