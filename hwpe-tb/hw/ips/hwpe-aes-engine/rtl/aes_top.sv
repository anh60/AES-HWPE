/*
 * aes_top.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import aes_package::*;
import hwpe_ctrl_package::*;

module aes_top
#(
  parameter int unsigned N_CORES = 2,
  parameter int unsigned N_EVT   = 2,
  parameter int unsigned MP      = 2,
  parameter int unsigned ID      = 10
)
(
  // global signals
  input  logic                                  clk_i,
  input  logic                                  rst_ni,
  input  logic                                  test_mode_i,

  // events
  output logic [N_CORES-1:0][N_EVT-1:0] evt_o,

  // tcdm master ports
  hwpe_stream_intf_tcdm.master                  tcdm[MP-1:0],

  // periph slave port
  hwpe_ctrl_intf_periph.slave                   periph
);

  logic enable, clear;
  ctrl_streamer_t  streamer_ctrl;
  flags_streamer_t streamer_flags;
  ctrl_engine_t    engine_ctrl;
  flags_engine_t   engine_flags;

  
  hwpe_stream_intf_stream #(
    .DATA_WIDTH(32)
  ) aes_input (
    .clk ( clk_i )
  );

  hwpe_stream_intf_stream #(
    .DATA_WIDTH(32)
  ) aes_output (
    .clk ( clk_i )
  );

  aes_engine i_engine (
    .clk_i            ( clk_i          		),
    .rst_ni           ( rst_ni         		),
    .test_mode_i      ( test_mode_i    		),
    .aes_input        ( aes_input.sink		),
    .aes_output       ( aes_output.source       ),
    .ctrl_i           ( engine_ctrl    		),
    .flags_o          ( engine_flags   		)
  );

  aes_streamer #(
    .MP ( MP )
  ) i_streamer (
    .clk_i            ( clk_i          		),
    .rst_ni           ( rst_ni         		),
    .test_mode_i      ( test_mode_i    		),
    .enable_i         ( enable         		),
    .clear_i          ( clear          		),
    .aes_input        ( aes_input.source       	),
    .aes_output       ( aes_output.sink         ),
    .tcdm             ( tcdm           		),
    .ctrl_i           ( streamer_ctrl  		),
    .flags_o          ( streamer_flags 		)
  );

  aes_ctrl #(
    .N_CORES   ( 2  ),
    .N_CONTEXT ( 2  ),
    .N_EVT     (N_EVT),
    .N_IO_REGS ( 16 ),
    .ID ( ID )
  ) i_ctrl (
    .clk_i            ( clk_i          ),
    .rst_ni           ( rst_ni         ),
    .test_mode_i      ( test_mode_i    ),
    .evt_o            ( evt_o          ),
    .clear_o          ( clear          ),
    .ctrl_streamer_o  ( streamer_ctrl  ),
    .flags_streamer_i ( streamer_flags ),
    .ctrl_engine_o    ( engine_ctrl    ),
    .flags_engine_i   ( engine_flags   ),
    .periph           ( periph         )
  );

  assign enable = 1'b1;

endmodule
