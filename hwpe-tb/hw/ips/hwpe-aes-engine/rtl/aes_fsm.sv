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
  output ctrl_engine_t        ctrl_engine_o,
  input  flags_engine_t       flags_engine_i,
  output ctrl_slave_t         slave_ctrl_o,
  input  flags_slave_t        slave_flags_i,
  input  ctrl_regfile_t       reg_file_i
);

  aes_state_t current_state, next_state;

  ctrl_streamer_t streamer_ctrl_cfg;
  logic unsigned [2:0]  cycle_counter;  // Counter to keep track of cycles in WORKING state

  // AES FSM: sequential process.
  always_ff @(posedge clk or negedge reset_n)
  begin : fsm_seq
    if (~reset_n)
      current_state <= AES_IDLE;
    else if (clear)
      current_state <= AES_IDLE;
    else 
      current_state <= next_state;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin : fsm_seq_cycle
    if(current_state == AES_WORKING) 
      cycle_counter <= cycle_counter + 1; 
    else  
      cycle_counter <= 0; 
  end 



  always_comb
  begin : fsm_comb_next_state
    next_state = current_state;

    case(current_state)
      //IDLE -> STARTING
      AES_IDLE: begin
        if (slave_flags_i.start) begin
          next_state = AES_STARTING;
        end
      end
      
      //STARTING -> WORKING
      AES_STARTING: begin
        if (streamer_flags_i.plaintext_source_flags.ready_start
            & streamer_flags_i.chipertext_sink_flags.ready_start) begin 
          next_state = AES_WORKING;
        end 
      end 
      
      //WORKING -> FINISHED
      AES_WORKING: begin
        if (streamer_flags_i.plaintext_source_flags.ready_start
            & streamer_flags_i.chipertext_sink_flags.ready_start) begin 
          next_state = AES_FINISHED;
        end
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
  begin : fsm_comb_out
    // engine
    ctrl_engine_o.clear   = '0;
    ctrl_engine_o.start   = '0;
    ctrl_engine_o.enable  = '0;


    //Streamer
    streamer_ctrl_o = streamer_ctrl_cfg;
    streamer_ctrl_o.plaintext_source_ctrl.req_start = '0;
    streamer_ctrl_o.chipertext_sink_ctrl.req_start  = '0;
    
    //Slave peripheral? 
    slave_ctrl_o = '0;

    case(current_state) 

      AES_IDLE: begin 
        ctrl_engine_o.clear  = 1'b1;
      end 

      AES_STARTING: begin 
        //Engine start
        ctrl_engine_o.start  = 1'b1;
        //Streamer request
        //Should check if streamer is ready, and if not, should wait until ready...
        streamer_ctrl_o.plaintext_source_ctrl.req_start = 1'b1;
        streamer_ctrl_o.chipertext_sink_ctrl.req_start = 1'b1;
      end 

      AES_WORKING: begin 
      end

      AES_FINISHED: begin 
        ctrl_engine_o.enable  = '1;
        slave_ctrl_o.done = 1'b1;
      end 
    endcase

  end


always_comb
  begin: fsm_comb_reg
    //Change the number four to actually represent the size of the register
    //Plaintext stream
    streamer_ctrl_cfg = '0;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.trans_size  = 1;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.line_stride = '0;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.line_length = 1;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.feat_stride = '0;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.feat_length = 1;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.base_addr   = reg_file_i.hwpe_params[0];
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.feat_roll   = '0;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.loop_outer  = '0;
    streamer_ctrl_cfg.plaintext_source_ctrl.addressgen_ctrl.realign_type = '0;
    // Chipertext stream 
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.trans_size  = 1;
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.line_stride = '0;
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.line_length = 1;
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.feat_stride = '0;
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.feat_length = 1;
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.base_addr   = reg_file_i.hwpe_params[3];
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.feat_roll   = '0;
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.loop_outer  = '0;
    streamer_ctrl_cfg.chipertext_sink_ctrl.addressgen_ctrl.realign_type = '0;

  end





endmodule