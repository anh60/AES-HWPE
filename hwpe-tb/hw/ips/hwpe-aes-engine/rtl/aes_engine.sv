import aes_package::*;

module mac_engine
(
  // global signals
  input  logic                   clk_i,
  input  logic                   rst_ni,
  input  logic                   test_mode_i,
  // input a stream
  hwpe_stream_intf_stream.sink   a_i,
  // input b stream
  hwpe_stream_intf_stream.sink   b_i,
  // input c stream
  hwpe_stream_intf_stream.sink   c_i,
  // output d stream
  hwpe_stream_intf_stream.source d_o,
  // control channel
  input  ctrl_engine_t           ctrl_i,
  output flags_engine_t          flags_o
);

  logic unsigned [127:0]  data_reg = '0;

 
  always_ff @(posedge clk_i or negedge rst_ni)
  begin : data_mover
    if(a_i.valid)
      if(ctrl_i.request_counter == 0)
        data_reg[31:0] <= a_i.data;
      else if(ctrl_i.request_counter == 1)
        data_reg[63:32] <= a_i.data;
      else if(ctrl_i.request_counter == 2)
        data_reg[95:64] <= a_i.data;
      else if(ctrl_i.request_counter == 3)
        data_reg[127:96] <= a_i.data;
  end 


  always_comb
  begin
    if(ctrl_i.request_counter == 0)
      d_o.data = data_reg[31:0];
    else if(ctrl_i.request_counter == 1)
      d_o.data = data_reg[63:32];
    else if(ctrl_i.request_counter == 2)
      d_o.data = data_reg[95:64];
    else if(ctrl_i.request_counter == 3)
      d_o.data = data_reg[127:96];

    d_o.valid = ctrl_i.data_out_valid;
    d_o.strb  = '1; // strb is always '1 --> all bytes are considered valid
  end 

assign a_i.ready = a_i.valid;


endmodule // mac_engine
