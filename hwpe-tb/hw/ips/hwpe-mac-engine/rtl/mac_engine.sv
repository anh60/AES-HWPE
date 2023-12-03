
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

 
  always_comb
  begin
    if (ctrl_i.enable) begin
    d_o.data = a_i.data;
    d_o.valid = ctrl_i.enable;
    d_o.strb  = '1; // strb is always '1 --> all bytes are considered valid
    end 
  end 


 

endmodule // mac_engine
