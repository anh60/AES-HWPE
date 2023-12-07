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
  
  // Data (output/result) register
  logic unsigned [127:0]  data_reg = '0;

  // Set data register
  always_ff @(posedge clk_i or negedge rst_ni)
  begin : data_mover
    if(aes_input.valid)
      if(ctrl_i.request_counter == 0)
        data_reg[31:0] <= aes_input.data;

      else if(ctrl_i.request_counter == 1)
        data_reg[63:32] <= aes_input.data;

      else if(ctrl_i.request_counter == 2)
        data_reg[95:64] <= aes_input.data;

      else if(ctrl_i.request_counter == 3)
        data_reg[127:96] <= aes_input.data;
  end 

  // Encryption
  always_comb
  begin
    if(ctrl_i.enable)
      
  end

  // Stream data out
  always_comb
  begin
    if(ctrl_i.request_counter == 0)
      aes_output.data = data_reg[31:0];
    else if(ctrl_i.request_counter == 1)
      aes_output.data = data_reg[63:32];
    else if(ctrl_i.request_counter == 2)
      aes_output.data = data_reg[95:64];
    else if(ctrl_i.request_counter == 3)
      aes_output.data = data_reg[127:96];

    aes_output.valid = ctrl_i.data_out_valid;
    aes_output.strb  = '1; // strb is always '1 --> all bytes are considered valid
  end 

assign aes_input.ready = aes_input.valid;


endmodule