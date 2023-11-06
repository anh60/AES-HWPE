/*
 * aes_ctrl.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

module aes_ctrl 

    // --- PARAMETERS ---
    #(  
        parameter int unsigned N_CORES = 1,

        // What is?
        parameter int unsigned N_CONTEXT = 2,

        // What is?
        parameter int unsigned N_IO_REGS = 16,

        // What is?
        parameter int unsigned N_GENERIC_REGS = 8,

        // ID width?
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

    // Bind the output event, which is propagated to the event unit and used
    // to implement HWPE datamover barriers.
    //assign evt_o = slave_flags.evt[7:0];    // Copied from datamover
    assign evt_o = slave_flags.evt;         // Copied from MAC
    
endmodule