/*
 * aes_fsm.sv
 * Andreas Holleland, Marcus Alexander Tjomsaas
 *
 */

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
  logic request_count_enable = '0;
  logic [31:0] data_size = '0;
  logic [15:0] block_counter = '0;
  logic block_counter_enable = '0;

  // AES FSM: sequential process.
  always_ff @(posedge clk or negedge reset_n)
  begin : fsm_seq_state
    if (~reset_n) 
      current_state <= AES_IDLE;
    else if (clear)  
      current_state <= AES_IDLE;
    else 
      current_state <= next_state;
  end

  always_ff @(posedge clk or negedge reset_n)
  begin : fsm_seq_request_counter
    if (~reset_n) 
      ctrl_engine_o.request_counter <= 0;
    else if(current_state == AES_WORKING || current_state == AES_STARTING)
      ctrl_engine_o.request_counter <= 0;
    else if(request_count_enable) 
      ctrl_engine_o.request_counter <= ctrl_engine_o.request_counter + 1;       
  end 

  always_ff @(posedge clk or negedge reset_n)
  begin : fsm_seq_block_counter
    if (~reset_n) 
      block_counter <= 0;
    else if(clear)
      block_counter <= 0;
    else if(block_counter_enable) 
      block_counter <= block_counter + 1;       
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
          next_state = AES_REQUEST_DATA;
      end 
      
      AES_REQUEST_DATA: begin
        if (streamer_flags_i.aes_input_source_flags.ready_start)
          next_state = AES_REQUEST_DATA_WAIT;
          
      end 


      //WORKING -> FINISHED
      AES_REQUEST_DATA_WAIT: begin
         if (streamer_flags_i.aes_input_source_flags.done) begin
            next_state = AES_REQUEST_DATA;

            if(data_size == 0 || data_size[31] == 1) // If data_size[31] = 1, overflow..
              next_state = AES_WORKING;
            
            if(ctrl_engine_o.request_counter == 3)
              next_state = AES_WORKING;
            
         end
      end

      AES_WORKING: begin
        //Wait for AES encryption here...
        next_state = AES_SEND_DATA;
      end 


      AES_SEND_DATA: begin
        if (streamer_flags_i.aes_output_sink_flags.ready_start)
          next_state = AES_SEND_DATA_WAIT;
          
      end 


      //WORKING -> FINISHED
      AES_SEND_DATA_WAIT: begin
        next_state = AES_MEMORY_WRITE_WAIT;
            
      end 

      AES_MEMORY_WRITE_WAIT: begin
          next_state = AES_SEND_DATA;
          if(ctrl_engine_o.request_counter == 3)
            next_state = AES_MEMORY_WRITE_DONE;
      end 

      AES_MEMORY_WRITE_DONE: begin
        next_state = AES_REQUEST_DATA;
        if(data_size == 0)
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
  begin : fsm_comb_out

    //fsm 
    request_count_enable = '0;
    block_counter_enable = '0;

    // engine
    ctrl_engine_o.clear   = '0;
    ctrl_engine_o.start   = '0;
    ctrl_engine_o.enable  = '0;
    ctrl_engine_o.data_out_valid  = '0;



    //Streamer
    streamer_ctrl_o = streamer_ctrl_cfg;
    streamer_ctrl_o.aes_input_source_ctrl.req_start = '0;
    streamer_ctrl_o.aes_output_sink_ctrl.req_start  = '0;
    
    //Slave peripheral? 
    slave_ctrl_o = '0;

    case(current_state) 

      AES_IDLE: begin 
        ctrl_engine_o.clear  = 1'b1;
      end 

      AES_STARTING: begin 
        //Engine start
        ctrl_engine_o.start  = 1'b1;
        data_size = ctrl_engine_o.data_size;
        //Streamer request
      end 

      AES_REQUEST_DATA: begin 
          streamer_ctrl_o.aes_input_source_ctrl.req_start = 1'b1;
      end 

      AES_REQUEST_DATA_WAIT: begin 
        if (streamer_flags_i.aes_input_source_flags.done) begin
            request_count_enable = '1;
            data_size = data_size - 4;
        end
      end

      AES_WORKING: begin
        //Do AES encryption....
      end

      AES_SEND_DATA: begin 
        streamer_ctrl_o.aes_output_sink_ctrl.req_start = 1'b1;
      end 

      AES_SEND_DATA_WAIT: begin 
        ctrl_engine_o.data_out_valid = '1;
      end 

      AES_MEMORY_WRITE_WAIT: begin 
        request_count_enable = '1; 
      end 

      AES_MEMORY_WRITE_DONE: begin
        ctrl_engine_o.clear = '1;
        block_counter_enable = '1;
      end

      AES_FINISHED: begin 
        slave_ctrl_o.done = 1'b1;
      end 
    endcase

  end


always_comb
  begin: fsm_comb_reg
    ctrl_engine_o.data_size = reg_file_i.hwpe_params[HWPE_DATA_BYTE_LENGTH];
    //Change the number four to actually represent the size of the register
    //aes_input stream
    streamer_ctrl_cfg = '0;
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.trans_size  = 1;
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.line_stride = '0;
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.line_length = 1;
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.feat_stride = '0;
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.feat_length = 1;
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.base_addr   = reg_file_i.hwpe_params[HWPE_INPUT_ADDR] + ($unsigned(ctrl_engine_o.request_counter) * 4) + ($unsigned(block_counter) * 16);
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.feat_roll   = '0;
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.loop_outer  = '0;
    streamer_ctrl_cfg.aes_input_source_ctrl.addressgen_ctrl.realign_type = '0;
    // aes_output stream 
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.trans_size  = 1;
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.line_stride = '0;
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.line_length = 1;
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.feat_stride = '0;
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.feat_length = 1;
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.base_addr   = reg_file_i.hwpe_params[HWPE_OUTPUT_ADDR] + ($unsigned(ctrl_engine_o.request_counter) * 4) + ($unsigned(block_counter) * 16);
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.feat_roll   = '0;
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.loop_outer  = '0;
    streamer_ctrl_cfg.aes_output_sink_ctrl.addressgen_ctrl.realign_type = '0;

  end





endmodule