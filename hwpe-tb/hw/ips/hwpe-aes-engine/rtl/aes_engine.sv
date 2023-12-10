/*
 * aes_engine.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import aes_package::*;

module aes_engine
(
  // Global signals
  input  logic                   clk_i,
  input  logic                   rst_ni,
  input  logic                   test_mode_i,

  // Input stream
  hwpe_stream_intf_stream.sink   aes_input,

  // Output stream
  hwpe_stream_intf_stream.source aes_output,

  // Control channel
  input  ctrl_engine_t           ctrl_i,
  output flags_engine_t          flags_o
);

  // Input register for streaming in data to be processed
  logic unsigned [127:0]  data_reg_i = '0;

  // Output register for streaming out result
  logic unsigned [127:0]  data_reg_o = '0;

  // Core signals
  logic         core_encdec;
  logic         core_init_key;
  logic         core_start; 
  logic         core_ready;
  logic[255:0]  core_key; 
  logic         core_key_mode; 
  logic[127:0]  core_input; 
  logic[127:0]  core_output; 
  logic         core_output_valid;

  // AES Core module
  aes_core i_aes_core(

    .clk(clk_i),
    .reset_n(rst_ni),

    .encdec(core_encdec),
    .init(core_init_key),
    .next(core_start),
    .ready(core_ready),

    .key(core_key),
    .keylen(core_key_mode),

    .block(core_input),
    .result(core_output),
    .result_valid(core_output_valid)
  );

  // Set input register
  always_ff @(posedge clk_i or negedge rst_ni)
  begin : data_input

    if(aes_input.valid)

      if(ctrl_i.request_counter == 0)
        data_reg_i[31:0] <= aes_input.data;

      else if(ctrl_i.request_counter == 1)
        data_reg_i[63:32] <= aes_input.data;

      else if(ctrl_i.request_counter == 2)
        data_reg_i[95:64] <= aes_input.data;

      else if(ctrl_i.request_counter == 3)
        data_reg_i[127:96] <= aes_input.data;

    core_input <= data_reg_i; 
    
  end 

  // Set output register
  always_ff @(posedge clk_i or negedge rst_ni)
  begin : data_core_valid

    if(core_output_valid)
        data_reg_o <= core_output;

  end

  always_comb
  begin 

    core_encdec = ctrl_i.core_encode_decode;
    core_init_key = ctrl_i.core_init_key;
    core_start =ctrl_i.core_start; 
    core_key = ctrl_i.core_key; 
    core_key_mode = ctrl_i.core_key_mode; 
    flags_o.core_done = core_output_valid;
    flags_o.core_ready = core_ready;

  end 

  // Stream data out
  always_comb
  begin:  data_output

    if(ctrl_i.request_counter == 0)
      aes_output.data = data_reg_o[31:0];

    else if(ctrl_i.request_counter == 1)
      aes_output.data = data_reg_o[63:32];

    else if(ctrl_i.request_counter == 2)
      aes_output.data = data_reg_o[95:64];

    else if(ctrl_i.request_counter == 3)
      aes_output.data = data_reg_o[127:96];

    aes_output.valid = ctrl_i.data_out_valid;

    // strb is always '1 --> all bytes are considered valid
    aes_output.strb  = '1;

  end 

  // Clear data reg
  always_ff @(posedge clk_i or negedge rst_ni)
  begin: data_clear

    if(ctrl_i.clear)
      data_reg_i <= '0;

  end

assign aes_input.ready = aes_input.valid;

endmodule