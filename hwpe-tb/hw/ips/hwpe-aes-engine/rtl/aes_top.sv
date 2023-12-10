/*
 * aes_top.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import aes_package::*;
import hwpe_ctrl_package::*;

module aes_top
#(
  parameter int unsigned N_CORES          = 1,
  parameter int unsigned N_CONTEXT        = 2,
  parameter int unsigned N_IO_REGS        = 16,
  parameter int unsigned N_GENERIC_REGS   = 8,
  parameter int unsigned MP               = 2,
  parameter int unsigned ID               = 10
)
(
  // Global signals
  input  logic                                  clk_i,
  input  logic                                  rst_ni,
  input  logic                                  test_mode_i,

  // Output to event unit (interrupt)
  output logic [N_CORES-1:0][REGFILE_N_EVT-1:0] evt_o,

  // TCDM ports
  hwpe_stream_intf_tcdm.master                  tcdm[MP-1:0],

  // APB ports
  hwpe_ctrl_intf_periph.slave                   periph
);

  // Streamer signals
  logic enable, clear;
  ctrl_streamer_t  streamer_ctrl;
  flags_streamer_t streamer_flags;

  // Engine signals
  ctrl_engine_t    engine_ctrl;
  flags_engine_t   engine_flags;

  // Input stream interface
  hwpe_stream_intf_stream #(
    .DATA_WIDTH(32)
  ) aes_input (
    .clk ( clk_i )
  );

  // Output stream interface
  hwpe_stream_intf_stream #(
    .DATA_WIDTH(32)
  ) aes_output (
    .clk ( clk_i )
  );

  // AES Control module
  aes_ctrl #(
    .N_CORES          ( N_CORES           ),
    .N_CONTEXT        ( N_CONTEXT         ),
    .N_IO_REGS        ( N_IO_REGS         ),
    .N_GENERIC_REGS   ( N_GENERIC_REGS    ),
    .ID               ( ID                )
  ) i_ctrl (
    .clk_i            ( clk_i             ),
    .rst_ni           ( rst_ni            ),
    .test_mode_i      ( test_mode_i       ),
    .evt_o            ( evt_o             ),
    .clear_o          ( clear             ),
    .ctrl_streamer_o  ( streamer_ctrl     ),
    .flags_streamer_i ( streamer_flags    ),
    .ctrl_engine_o    ( engine_ctrl       ),
    .flags_engine_i   ( engine_flags      ),
    .periph           ( periph            )
  );

  // AES streamer module
  aes_streamer #(
    .MP               ( MP                ),
    .FD               ( 2                 )
  ) i_streamer (
    .clk_i            ( clk_i          		),
    .rst_ni           ( rst_ni         		),
    .test_mode_i      ( test_mode_i    		),
    .enable_i         ( enable         		),
    .clear_i          ( clear          		),
    .aes_input        ( aes_input.source  ),
    .aes_output       ( aes_output.sink   ),
    .tcdm             ( tcdm           		),
    .ctrl_i           ( streamer_ctrl  		),
    .flags_o          ( streamer_flags 		)
  );

  // AES engine module
  aes_engine i_engine (
    .clk_i            ( clk_i          		),
    .rst_ni           ( rst_ni         		),
    .test_mode_i      ( test_mode_i    		),
    .aes_input        ( aes_input.sink		),
    .aes_output       ( aes_output.source ),
    .ctrl_i           ( engine_ctrl    		),
    .flags_o          ( engine_flags   		)
  );

  // Constantly drive streamer enable to logic high
  assign enable = 1'b1;

endmodule
