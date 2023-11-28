/*
 * aes_ctrl.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import aes_package::*;
import hwpe_ctrl_package::*;
module aes_ctrl 

    // --- PARAMETERS ---
    #(  
        // Max number of processor cores supported.
        parameter int unsigned N_CORES = 1, 

        // Max number of different execution contexts or threads per core that the register file can handle.
        parameter int unsigned N_CONTEXT = 2, 

        // Max number of registers dedicated to Input/Output operations. These are accessible from the processor. 
        // The reg_file.hwpe_params registers (input) can be mapped to the streamer_ctrl_cfg registers (output), 
        // meaning the processor can dynamically update the streamer controller for data transfers based on specific hardware parameters.
        parameter int unsigned N_IO_REGS = 16, 

        // Max number of generic registers. General purpose registers used by the processor to influence the control behavior.
        // An example would be to store start and stop addresses for the targeted encrypted AES data used by AES control.
        parameter int unsigned N_GENERIC_REGS = 8, 

        // ID bus width used by the master and the slave to validate a handshake.
        parameter int unsigned ID = 10 
    )
    
    // --- PORTS ---
    (
        // Global signals
        input logic clk_i,
        input logic rst_ni,
        input logic test_mode_i,
        output logic clear_o,

        // Events
        output logic [N_CORES-1:0][REGFILE_N_EVT-1:0] evt_o,

        // Control / flags (streamer and engine)
        output ctrl_streamer_t  ctrl_streamer_o,
        input  flags_streamer_t flags_streamer_i,
        output ctrl_engine_t    ctrl_engine_o,
        input  flags_engine_t   flags_engine_i,

        // Periph slave ports (APB / peripheral bus)
        hwpe_ctrl_intf_periph.slave periph
    );

    // What is?
    ctrl_slave_t slave_ctrl;
    flags_slave_t slave_flags;
    ctrl_regfile_t reg_file;

    // Peripheral slave
    hwpe_ctrl_slave #(
        .N_CORES        ( N_CORES               ),
        .N_CONTEXT      ( N_CONTEXT             ),
        .N_IO_REGS      ( N_IO_REGS             ),
        .N_GENERIC_REGS ( N_GENERIC_REGS        ),
        .ID_WIDTH       ( ID                    )
    ) i_slave (
        .clk_i    ( clk_i       ),
        .rst_ni   ( rst_ni      ),
        .clear_o  ( clear_o     ),
        .cfg      ( periph      ),
        .ctrl_i   ( slave_ctrl  ),
        .flags_o  ( slave_flags ),
        .reg_file ( reg_file    )
    );

    // --- Put logic here? ---
    aes_fsm fsm(
        .clk               (clk_i            ),
        .reset_n           (rst_ni           ),
        .clear             (clear_i          ),
        .streamer_ctrl_o   (ctrl_streamer_o  ),
        .streamer_flags_i  (flags_streamer_i ),
        //.ctrl_engine_o   (ctrl_engine_o    ),
        //.flags_engine_i  (flags_engine_i   ),
        .slave_ctrl_o      (ctrl_slave_o     ),
        .slave_flags_i     (flags_slave_i    )
    );

    // Bind the output event, which is propagated to the event unit and used
    // to implement HWPE datamover barriers.
    //assign evt_o = slave_flags.evt[7:0];    // Copied from datamover
    assign evt_o = slave_flags.evt;         // Copied from MAC
    
endmodule
