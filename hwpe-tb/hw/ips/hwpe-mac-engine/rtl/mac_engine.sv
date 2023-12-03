/*
 * mac_engine.sv
 * Francesco Conti <f.conti@unibo.it>
 *
 * Copyright (C) 2018-2022 ETH Zurich, University of Bologna
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the "License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * The architecture that follows is relatively straightforward; it supports two modes:
 *  - in 'simple_mult' mode, the a_i and b_i streams feed the 32b x 32b multiplier (mult).
 *    The output of the multiplier (64b) is registered in a pipeline stage
 *    (r_mult), which is then shifted by ctrl_i.shift to the right and streamed out as d_o.
 *    There is no control local to the module except for handshakes.
 *  - in 'scalar_prod' mode, the c_i stream is first shifted left by ctrl_i.shift, extended
 *    to 64b and saved in r_acc. Then, the a_i and b_i streams feed the 32b x 32b multiplier
 *    (mult) for ctrl_i.len cycles, controlled by a local counter. The output of mult is 
 *    registered in a pipeline stage (r_mult), whose value is used as input to an accumulator
 *    (r_acc) -- the one which was inited by the shifted value of c_i. At the end of the
 *    ctrl_i.len cycles, the output of r_acc is shifted back to the right by ctrl_i.shift
 *    bits and streamed out as d_o.
 */

import mac_package::*;

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

  logic unsigned [$clog2(MAC_CNT_LEN):0] cnt;
  logic unsigned [$clog2(MAC_CNT_LEN):0] r_cnt;
  logic signed [63:0] c_shifted;
  logic signed [63:0] mult;
  logic signed [63:0] r_mult;
  logic               r_mult_valid;
  logic               r_mult_ready;
  logic signed [64+$clog2(MAC_CNT_LEN)-1:0] r_acc;
  logic                                     r_acc_valid;
  logic                                     r_acc_ready;
  logic signed [64+$clog2(MAC_CNT_LEN)-1:0] d_nonshifted;
  logic                                     d_nonshifted_valid;

  // for this example, the datapath is simply a data FIFO!

  hwpe_stream_fifo #(
    .DATA_WIDTH ( 32 ),
    .FIFO_DEPTH ( 4 )
  ) i_fifo (
    .clk_i   ( clk_i    ),
    .rst_ni  ( rst_ni   ),
    .clear_i ( clear_i  ),
    .flags_o (          ),
    .push_i  ( a_i  ),
    .pop_o   ( d_o )
  );

endmodule // mac_engine