import aes_package::*;
import hwpe_ctrl_package::*;

module aes_fsm (
  // global signals
  input  logic                clk,
  input  logic                reset_n,
  input  logic                clear,
  // ctrl & flags
  output ctrl_streamer_t      streamer_ctrl_o,
  input  flags_streamer_t     streamer_flags_i,
  //output ctrl_engine_t        ctrl_engine_o,
  //input  flags_engine_t       flags_engine_i,
  output ctrl_slave_t         slave_ctrl_o,
  input  flags_slave_t        slave_flags_i,
  input  ctrl_regfile_t       reg_file_i,
);

  aes_state_t current_state, next_state;

  ctrl_streamer_t streamer_ctrl_cfg;

  // AES FSM: sequential process.
  always_ff @(posedge clk or negedge reset_n)
  begin : fsm_seq
    if(~reset_n)
      current_state <= AES_IDLE;
    else if(clear)
      current_state <= AES_IDLE;
    else
      current_state <= next_state;
  end

  // AES FSM: combinational next-state calculation process.
  always_comb
  begin : fsm_next_state_comb
    next_state = current_state;

    case(current_state)

      //IDLE -> STARTING
      AES_IDLE: begin
        if(slave_flags_i.start)
          next_state = AES_STARTING;
      end
      
      //STARTING -> WORKING
      AES_STARTING: begin
        next_state = AES_WORKING;
      end 
      
      //WORKING -> FINISHED
      AES_WORKING: begin
        if ((streamer_flags_i.chipertext_sink_flags.done | streamer_flags_i.chipertext_sink_flags.ready_start) 
            & (streamer_flags_i.plaintext_source_flags.done | streamer_flags_i.plaintext_source_flags.ready_start)
            & streamer_flags_i.tcdm_fifo_empty
            )
          next_state = AES_FINISHED;
      end

      //FINSIHED -> IDLE
      AES_FINISHED: begin
        next_state = AES_IDLE;
      end

      // Default case to handle unexpected states
      default: begin
        next_state = AES_IDLE;
      end
    endcase

  end

  // AES FSM: combinational output calculation process.
  always_comb
  begin : fsm_out_comb
    slave_ctrl_o = '0;
    streamer_ctrl_o = streamer_ctrl_cfg;

    case(current_state) 
    
      AES_STARTING: begin 
        streamer_ctrl_o.plaintext_source_ctrl.req_start = 1'b1;
        streamer_ctrl_o.chipertext_sink_ctrl.req_start = 1'b1;
      end 

      AES_FINISHED: begin 
        slave_ctrl_o.done = 1'b1;
      end 
    endcase

  end

// Initialization of streamer control configuration
// (Uncomment and complete this section as necessary)

  // Here we bind the register file parameters to the streamer configuration.
  // `streamer_ctrl_cfg` containext_state the "base" configuration, with null `req_start`.
  // The FSM copies this base configuration into `streamer_ctrl` and sets
  // the `req_start` signals when in state DM_STARTING.
 /* always_comb
  begin
    streamer_ctrl_cfg = '0;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.dim_enable_1h = '1;
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.dim_enable_1h  = '1;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.base_addr = reg_file_i.hwpe_params[0];
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.base_addr  = reg_file_i.hwpe_params[1];
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.tot_len   = reg_file_i.hwpe_params[2];
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.tot_len    = reg_file_i.hwpe_params[2];
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.d0_len    = reg_file_i.hwpe_params[3];
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.d0_stride = reg_file_i.hwpe_params[4];
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.d1_len    = reg_file_i.hwpe_params[5];
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.d1_stride = reg_file_i.hwpe_params[6];
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.d2_stride = reg_file_i.hwpe_params[7];
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.d0_len     = reg_file_i.hwpe_params[8];
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.d0_stride  = reg_file_i.hwpe_params[9];
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.d1_len     = reg_file_i.hwpe_params[10];
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.d1_stride  = reg_file_i.hwpe_params[11];
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.d2_stride  = reg_file_i.hwpe_params[12];
  end
*/




endmodule