/*
 * aes_engine.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import hwpe_stream_interfaces::*;
import hwpe_stream_package::*;

module aes_engine 
    (
        // Global signals
        input logic clk_i,
        input logic rst_ni,
        input logic test_mode_i,

        // Input stream
        hwpe_stream_intf_stream.sink a_i,

        // Output stream
        hwpe_stream_intf_stream.source b_o,

        // Control channel
        input  ctrl_engine_t  ctrl_i,
        output flags_engine_t flags_o
    );

    // --- DATAPATH ---


    
endmodule