/*
 * aes_top.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import hwpe_ctrl_package::*;
import hwpe_stream_interfaces::*;

module aes_top 
    
    // --- PARAMETERS ---
    #(
        // Number of cores (what is?)
        parameter int unsigned N_CORES = 1,

        // Number of master ports (TCDM interfaces)
        parameter int unsigned MP  = 2,

        // Identifier (used in control unit)
        parameter int unsigned ID = 10
    )
    
    // --- PORTS ---
    (   
        // Global signals
        input logic clk_i,
        input logic rst_ni,
        input logic test_mode_i,

        // Events (what is? outputs to memory?)
        output logic [N_CORES-1:0][REGFILE_N_EVT-1:0] evt_o,

        // TCDM master ports (HWPE-Mem)
        hwpe_stream_intf_tcdm.master tcdm,

        // Periph slave ports (APB / peripheral bus)
        hwpe_ctrl_intf_periph.slave periph
    );

    // Streamer signals
    logic enable, clear;
    ctrl_streamer_t  streamer_ctrl;
    flags_streamer_t streamer_flags;

    // Engine signals
    ctrl_engine_t    engine_ctrl;
    flags_engine_t   engine_flags;

    // Internal input stream interface
    hwpe_stream_intf_stream #(.DATA_WIDTH(32)) a 
    (
        .clk ( clk_i )
    );

    // Internal output stream interface
    hwpe_stream_intf_stream #(.DATA_WIDTH(32)) b 
    (
        .clk ( clk_i )
    );

    // Streamer module
    aes_streamer #(.MP ( MP )) i_streamer
    (
        .clk_i            ( clk_i          ),
        .rst_ni           ( rst_ni         ),
        .test_mode_i      ( test_mode_i    ),
        .enable_i         ( enable         ),
        .clear_i          ( clear          ),
        .a_o              ( a.source       ),
        .b_i              ( b.sink         ),
        .tcdm             ( tcdm           ),
        .ctrl_i           ( streamer_ctrl  ),
        .flags_o          ( streamer_flags )
    );

    // Engine module
    aes_engine i_engine
    (
        .clk_i            ( clk_i          ),
        .rst_ni           ( rst_ni         ),
        .test_mode_i      ( test_mode_i    ),
        .a_i              ( a.sink         ),
        .b_o              ( b.source       ),
        .ctrl_i           ( engine_ctrl    ),
        .flags_o          ( engine_flags   )
    );

    // Control
        // Insert control module here

    // Constantly drive streamer enable to logic high
    assign enable = 1'b1;

endmodule