/*
 * aes_streamer.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import aes_package::*;
import hwpe_stream_package::*;

module aes_streamer
#(
  parameter int unsigned MP = 2, // number of master ports
  parameter int unsigned FD = 2  // FIFO depth
)
(
  // global signals
  input  logic                   clk_i,
  input  logic                   rst_ni,
  input  logic                   test_mode_i,

  // local enable & clear
  input  logic                   enable_i,
  input  logic                   clear_i,

  // input a stream + handshake
  hwpe_stream_intf_stream.source aes_input,

  // output d stream + handshake
  hwpe_stream_intf_stream.sink   aes_output,

  // TCDM ports
  hwpe_stream_intf_tcdm.master tcdm [MP-1:0],

  // control channel
  input  ctrl_streamer_t  ctrl_i,
  output flags_streamer_t flags_o
);

  logic aes_input_tcdm_fifo_ready;

  hwpe_stream_intf_stream #(
    .DATA_WIDTH ( 32 )
  ) aes_input_prefifo (
    .clk ( clk_i )
  );

  hwpe_stream_intf_stream #(
    .DATA_WIDTH ( 32 )
  ) aes_output_postfifo (
    .clk ( clk_i )
  );

  hwpe_stream_intf_tcdm tcdm_fifo [MP-1:0] (
    .clk ( clk_i )
  );

  hwpe_stream_intf_tcdm tcdm_fifo_0 [0:0] (
    .clk ( clk_i )
  );

  hwpe_stream_intf_tcdm tcdm_fifo_1 [0:0] (
    .clk ( clk_i )
  );

  // source and sink modules
  hwpe_stream_source #(
    .DATA_WIDTH ( 32 ),
    .DECOUPLED  ( 1  )
  ) aes_input_source (
    .clk_i              ( clk_i                  		),
    .rst_ni             ( rst_ni                 		),
    .test_mode_i        ( test_mode_i            		),
    .clear_i            ( clear_i                		),
    .tcdm               ( tcdm_fifo_0            		), // this syntax is necessary for Verilator as hwpe_stream_source expects an array of interfaces
    .stream             ( aes_input_prefifo.source       	),
    .ctrl_i             ( ctrl_i.aes_input_source_ctrl   	),
    .flags_o            ( flags_o.aes_input_source_flags	),
    .tcdm_fifo_ready_o  ( aes_input_tcdm_fifo_ready      	)
  );

  hwpe_stream_sink #(
    .DATA_WIDTH ( 32 )
  ) aes_output_sink (
    .clk_i       ( clk_i                		),
    .rst_ni      ( rst_ni               		),
    .test_mode_i ( test_mode_i          		),
    .clear_i     ( clear_i              		),
    .tcdm        ( tcdm_fifo_1          		), // this syntax is necessary for Verilator as hwpe_stream_source expects an array of interfaces
    .stream      ( aes_output_postfifo.sink      	),
    .ctrl_i      ( ctrl_i.aes_output_sink_ctrl   	),
    .flags_o     ( flags_o.aes_output_sink_flags 	)
  );


  // TCDM-side FIFOs
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) aes_input_tcdm_fifo_load (
    .clk_i       ( clk_i             		),
    .rst_ni      ( rst_ni            		),
    .clear_i     ( clear_i           		),
    .flags_o     (                   		),
    .ready_i     ( aes_input_tcdm_fifo_ready 	),
    .tcdm_slave  ( tcdm_fifo_0[0]    		),
    .tcdm_master ( tcdm      [0]     		)
  );

  hwpe_stream_tcdm_fifo_store #(
    .FIFO_DEPTH ( 4 )
  ) aes_output_tcdm_fifo_store (
    .clk_i       ( clk_i          ),
    .rst_ni      ( rst_ni         ),
    .clear_i     ( clear_i        ),
    .flags_o     (                ),
    .tcdm_slave  ( tcdm_fifo_1[0] ),
    .tcdm_master ( tcdm       [1] )
  );

  // datapath-side FIFOs
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) aes_input_fifo (
    .clk_i   ( clk_i          		),
    .rst_ni  ( rst_ni         		),
    .clear_i ( clear_i        		),
    .push_i  ( aes_input_prefifo.sink 	),
    .pop_o   ( aes_input      		),
    .flags_o (                		)
  );

  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) aes_output_fifo (
    .clk_i   ( clk_i             		),
    .rst_ni  ( rst_ni            		),
    .clear_i ( clear_i           		),
    .push_i  ( aes_output        		),
    .pop_o   ( aes_output_postfifo.source 	),
    .flags_o (                   		)
  );

endmodule
