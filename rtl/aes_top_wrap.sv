/*
 * aes_top_wrap.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

import hwpe_stream_interfaces::*;
import hwpe_ctrl_interfaces::*;
import hwpe_ctrl_package::*;

module aes_top_wrap 

    // --- PARAMETERS ---
    #(
        // Number of cores (what is?)
        parameter N_CORES = 1,

        // Number of master ports (TCDM interfaces)
        parameter MP  = 2,

        // Used in Periph protocol and control unit, but for what?
        parameter ID  = 10
    ) 

    // --- PORTS ---
    (
        // Global signals
        input logic clk_i,
        input logic rst_ni,
        input logic test_mode_i,

        // Events (what is? outputs to memory?)
        output logic [N_CORES-1:0][REGFILE_N_EVT-1:0] evt_o,

        // TCDM master ports (HWPE-Mem protocol)
        output logic [MP-1:0]                         tcdm_req,
        input  logic [MP-1:0]                         tcdm_gnt,
        output logic [MP-1:0][31:0]                   tcdm_add,
        output logic [MP-1:0]                         tcdm_wen,
        output logic [MP-1:0][3:0]                    tcdm_be,
        output logic [MP-1:0][31:0]                   tcdm_data,
        input  logic [MP-1:0][31:0]                   tcdm_r_data,
        input  logic [MP-1:0]                         tcdm_r_valid,

        // Periph slave ports (APB, HWPE-Periph protocol)
        input  logic                                  periph_req,
        output logic                                  periph_gnt,
        input  logic         [31:0]                   periph_add,
        input  logic                                  periph_wen,
        input  logic         [3:0]                    periph_be,
        input  logic         [31:0]                   periph_data,
        input  logic       [ID-1:0]                   periph_id,
        output logic         [31:0]                   periph_r_data,
        output logic                                  periph_r_valid,
        output logic       [ID-1:0]                   periph_r_id
    );

    // TCDM interfaces
    hwpe_stream_intf_tcdm tcdm[MP-1:0] 
    (
        .clk ( clk_i )
    );

    // Periph interface
    hwpe_ctrl_intf_periph #(.ID_WIDTH ( ID )) periph 
    (
        .clk ( clk_i )
    );

    // Add signals to tcdm interface?
    generate
        for(genvar ii=0; ii<MP; ii++) begin: tcdm_binding
            assign tcdm_req  [ii] = tcdm[ii].req;
            assign tcdm_add  [ii] = tcdm[ii].add;
            assign tcdm_wen  [ii] = tcdm[ii].wen;
            assign tcdm_be   [ii] = tcdm[ii].be;
            assign tcdm_data [ii] = tcdm[ii].data;
            assign tcdm[ii].gnt     = tcdm_gnt     [ii];
            assign tcdm[ii].r_data  = tcdm_r_data  [ii];
            assign tcdm[ii].r_valid = tcdm_r_valid [ii];
        end
    endgenerate

    // Add signals to periph interface?
    always_comb
    begin
        periph.req  = periph_req;
        periph.add  = periph_add;
        periph.wen  = periph_wen;
        periph.be   = periph_be;
        periph.data = periph_data;
        periph.id   = periph_id;
        periph_gnt     = periph.gnt;
        periph_r_data  = periph.r_data;
        periph_r_valid = periph.r_valid;
        periph_r_id    = periph.r_id;
    end

    // Top module
    aes_top #(
        .N_CORES ( N_CORES ),
        .MP      ( MP      ),
        .ID      ( ID      )
    ) i_aes_top (
        .clk_i       ( clk_i       ),
        .rst_ni      ( rst_ni      ),
        .test_mode_i ( test_mode_i ),
        .evt_o       ( evt_o       ),
        .tcdm        ( tcdm        ),
        .periph      ( periph      )
    );
    
endmodule