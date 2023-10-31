/*
 * aes_streamer.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import hwpe_stream_interfaces::*;
import hwpe_stream_package::*;

module aes_streamer #(
        // Number of master ports (what is?)
        parameter int unsigned MP = 2,

        // FIFO depth (what value?)
        parameter int unsigned FD = 2
    )(
        // Global signals
        input logic clk_i,
        input logic rst_ni,
        input logic test_mode_i,

        // Local signals
        input logic enable_i,
        input logic clear_i,

        // Input stream
        hwpe_stream_intf_stream.source a_o,

        // Output stream
        hwpe_stream_intf_stream.sink b_i,

        // TCDM ports
        hwpe_stream_intf_tcdm.master tcdm [MP-1:0]

        // Control channel
        input  ctrl_streamer_t  ctrl_i,
        output flags_streamer_t flags_o
    );

    logic a_tcdm_fifo_ready

    // FIFO input stream
    hwpe_stream_intf_stream #(
        .DATA_WIDTH ( 32 )
    ) a_prefifo (
        .clk ( clk_i )
    );

    // FIFO output stream
    hwpe_stream_intf_stream #(
        .DATA_WIDTH ( 32 )
    ) b_postfifo (
        .clk ( clk_i )
    );

    // What are these?
    hwpe_stream_intf_tcdm tcdm_fifo_0 [0:0] (
        .clk ( clk_i )
    );
    hwpe_stream_intf_tcdm tcdm_fifo_1 [0:0] (
        .clk ( clk_i )
    );

    // Source module
    hwpe_stream_source #(
        .DATA_WIDTH ( 32 ),
        .DECOUPLED  ( 1  )
    ) i_a_source (
        .clk_i              ( clk_i                  ),
        .rst_ni             ( rst_ni                 ),
        .test_mode_i        ( test_mode_i            ),
        .clear_i            ( clear_i                ),
        .tcdm               ( tcdm_fifo_0            ),
        .stream             ( a_prefifo.source       ),
        .ctrl_i             ( ctrl_i.a_source_ctrl   ),
        .flags_o            ( flags_o.a_source_flags ),
        .tcdm_fifo_ready_o  ( a_tcdm_fifo_ready      )
    );

    // Sink module
    hwpe_stream_sink #(
        .DATA_WIDTH ( 32 )
    ) i_d_sink (
        .clk_i       ( clk_i                ),
        .rst_ni      ( rst_ni               ),
        .test_mode_i ( test_mode_i          ),
        .clear_i     ( clear_i              ),
        .tcdm        ( tcdm_fifo_1          ),
        .stream      ( b_postfifo.sink      ),
        .ctrl_i      ( ctrl_i.b_sink_ctrl   ),
        .flags_o     ( flags_o.b_sink_flags )
    );

    // TCDM-side FIFOs
    // In
    hwpe_stream_tcdm_fifo_load #(
        .FIFO_DEPTH ( 4 )
    ) i_a_tcdm_fifo_load (
        .clk_i       ( clk_i             ),
        .rst_ni      ( rst_ni            ),
        .clear_i     ( clear_i           ),
        .flags_o     (                   ),
        .ready_i     ( a_tcdm_fifo_ready ),
        .tcdm_slave  ( tcdm_fifo_0[0]    ),
        .tcdm_master ( tcdm      [0]     )
    );

    // Out
    hwpe_stream_tcdm_fifo_store #(
        .FIFO_DEPTH ( 4 )
    ) i_d_tcdm_fifo_store (
        .clk_i       ( clk_i          ),
        .rst_ni      ( rst_ni         ),
        .clear_i     ( clear_i        ),
        .flags_o     (                ),
        .tcdm_slave  ( tcdm_fifo_1[0] ),
        .tcdm_master ( tcdm       [1] )
    );

    // Datapath-side FIFOs
    // In
    hwpe_stream_fifo #(
        .DATA_WIDTH( 32 ),
        .FIFO_DEPTH( 2  ),
        .LATCH_FIFO( 0  )
    ) i_a_fifo (
        .clk_i   ( clk_i          ),
        .rst_ni  ( rst_ni         ),
        .clear_i ( clear_i        ),
        .push_i  ( a_prefifo.sink ),
        .pop_o   ( a_o            ),
        .flags_o (                )
    );

    // Out
    hwpe_stream_fifo #(
        .DATA_WIDTH( 32 ),
        .FIFO_DEPTH( 2  ),
        .LATCH_FIFO( 0  )
    ) i_b_fifo (
        .clk_i   ( clk_i             ),
        .rst_ni  ( rst_ni            ),
        .clear_i ( clear_i           ),
        .push_i  ( b_i               ),
        .pop_o   ( b_postfifo.source ),
        .flags_o (                   )
    );

endmodule