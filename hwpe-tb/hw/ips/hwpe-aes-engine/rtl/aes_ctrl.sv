/*
 * aes_ctrl.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import aes_package::*;
import hwpe_ctrl_package::*;

module aes_ctrl
#(
  parameter int unsigned N_CORES         = 1,
  parameter int unsigned N_CONTEXT       = 2,
  parameter int unsigned N_IO_REGS       = 16,
  parameter int unsigned N_GENERIC_REGS  = 8,
  parameter int unsigned ID              = 10
)
(
  // Global signals
  input  logic                                  clk_i,
  input  logic                                  rst_ni,
  input  logic                                  test_mode_i,
  output logic                                  clear_o,

  // Output to event unit (interrupt)
  output logic [N_CORES-1:0][REGFILE_N_EVT-1:0] evt_o,

  // Streamer signals
  output ctrl_streamer_t                        ctrl_streamer_o,
  input  flags_streamer_t                       flags_streamer_i,

  // Engine signals
  output ctrl_engine_t                          ctrl_engine_o,
  input  flags_engine_t                         flags_engine_i,

  // APB ports
  hwpe_ctrl_intf_periph.slave                   periph
);

  // APB slave signals
  ctrl_slave_t   slave_ctrl;
  flags_slave_t  slave_flags;

  // Register file
  ctrl_regfile_t reg_file;

  // APB slave
  hwpe_ctrl_slave #(
    .N_CORES            ( N_CORES               ),
    .N_CONTEXT          ( N_CONTEXT             ),
    .N_IO_REGS          ( N_IO_REGS             ),
    .N_GENERIC_REGS     ( N_GENERIC_REGS        ),
    .ID_WIDTH           ( ID                    )
  ) i_slave (
    .clk_i              ( clk_i                 ),
    .rst_ni             ( rst_ni                ),
    .clear_o            ( clear_o               ),
    .cfg                ( periph                ),
    .ctrl_i             ( slave_ctrl            ),
    .flags_o            ( slave_flags           ),
    .reg_file           ( reg_file              )
  );

  assign evt_o = slave_flags.evt;

  // Finite State Machine
  aes_fsm fsm(
    .clk                ( clk_i                 ),
    .reset_n            ( rst_ni                ),
    .clear              ( clear_o               ),
    .streamer_ctrl_o    ( ctrl_streamer_o       ),
    .streamer_flags_i   ( flags_streamer_i      ),
    .ctrl_engine_o      ( ctrl_engine_o         ),
    .flags_engine_i     ( flags_engine_i        ),
    .slave_ctrl_o       ( slave_ctrl            ),
    .slave_flags_i      ( slave_flags           ), 
    .reg_file_i         ( reg_file              )
  );

endmodule
