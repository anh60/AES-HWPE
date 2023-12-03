# This script was generated automatically by bender.
set ROOT "/import/lab/users/holleland/AES-HWPE/hwpe-tb/hw"

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/common_verification/src/clk_rst_gen.sv" \
    "$ROOT/ips/common_verification/src/rand_id_queue.sv" \
    "$ROOT/ips/common_verification/src/rand_stream_mst.sv" \
    "$ROOT/ips/common_verification/src/rand_synch_holdable_driver.sv" \
    "$ROOT/ips/common_verification/src/rand_verif_pkg.sv" \
    "$ROOT/ips/common_verification/src/signal_highlighter.sv" \
    "$ROOT/ips/common_verification/src/sim_timeout.sv" \
    "$ROOT/ips/common_verification/src/stream_watchdog.sv" \
    "$ROOT/ips/common_verification/src/rand_synch_driver.sv" \
    "$ROOT/ips/common_verification/src/rand_stream_slv.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/common_verification/test/tb_clk_rst_gen.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/tech_cells_generic/src/rtl/tc_sram.sv" \
    "$ROOT/ips/tech_cells_generic/src/rtl/tc_sram_impl.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/tech_cells_generic/src/rtl/tc_clk.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/tech_cells_generic/src/deprecated/cluster_pwr_cells.sv" \
    "$ROOT/ips/tech_cells_generic/src/deprecated/generic_memory.sv" \
    "$ROOT/ips/tech_cells_generic/src/deprecated/generic_rom.sv" \
    "$ROOT/ips/tech_cells_generic/src/deprecated/pad_functional.sv" \
    "$ROOT/ips/tech_cells_generic/src/deprecated/pulp_buffer.sv" \
    "$ROOT/ips/tech_cells_generic/src/deprecated/pulp_pwr_cells.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/tech_cells_generic/src/tc_pwr.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/tech_cells_generic/test/tb_tc_sram.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/tech_cells_generic/src/deprecated/pulp_clock_gating_async.sv" \
    "$ROOT/ips/tech_cells_generic/src/deprecated/cluster_clk_cells.sv" \
    "$ROOT/ips/tech_cells_generic/src/deprecated/pulp_clk_cells.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/ips/hwpe-ctrl/rtl" \
    "$ROOT/ips/hwpe-ctrl/rtl/hwpe_ctrl_interfaces.sv" \
    "$ROOT/ips/hwpe-ctrl/rtl/hwpe_ctrl_package.sv" \
    "$ROOT/ips/hwpe-ctrl/rtl/hwpe_ctrl_regfile_latch.sv" \
    "$ROOT/ips/hwpe-ctrl/rtl/hwpe_ctrl_seq_mult.sv" \
    "$ROOT/ips/hwpe-ctrl/rtl/hwpe_ctrl_uloop.sv" \
    "$ROOT/ips/hwpe-ctrl/rtl/hwpe_ctrl_regfile_latch_test_wrap.sv" \
    "$ROOT/ips/hwpe-ctrl/rtl/hwpe_ctrl_regfile.sv" \
    "$ROOT/ips/hwpe-ctrl/rtl/hwpe_ctrl_slave.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/ips/hwpe-stream/rtl" \
    "$ROOT/ips/hwpe-stream/rtl/hwpe_stream_interfaces.sv" \
    "$ROOT/ips/hwpe-stream/rtl/hwpe_stream_package.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_assign.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_buffer.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_demux_static.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_deserialize.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_fence.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_merge.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_mux_static.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_serialize.sv" \
    "$ROOT/ips/hwpe-stream/rtl/basic/hwpe_stream_split.sv" \
    "$ROOT/ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo_ctrl.sv" \
    "$ROOT/ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo_scm.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_addressgen.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_addressgen_v2.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_addressgen_v3.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_sink_realign.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_source_realign.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_strbgen.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_streamer_queue.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_assign.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_mux.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_mux_static.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_reorder.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_reorder_static.sv" \
    "$ROOT/ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo_earlystall.sv" \
    "$ROOT/ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo_earlystall_sidech.sv" \
    "$ROOT/ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo_scm_test_wrap.sv" \
    "$ROOT/ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo_sidech.sv" \
    "$ROOT/ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_fifo_load_sidech.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_source.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_fifo.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_fifo_load.sv" \
    "$ROOT/ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_fifo_store.sv" \
    "$ROOT/ips/hwpe-stream/rtl/streamer/hwpe_stream_sink.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/ips/hwpe-mac-engine/rtl" \
    "$ROOT/ips/hwpe-mac-engine/rtl/mac_package.sv" \
    "$ROOT/ips/hwpe-mac-engine/rtl/mac_engine.sv" \
    "$ROOT/ips/hwpe-mac-engine/rtl/mac_fsm.sv" \
    "$ROOT/ips/hwpe-mac-engine/rtl/mac_streamer.sv" \
    "$ROOT/ips/hwpe-mac-engine/rtl/mac_ctrl.sv" \
    "$ROOT/ips/hwpe-mac-engine/rtl/mac_top.sv" \
    "$ROOT/ips/hwpe-mac-engine/wrap/mac_top_wrap.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/ips/scm/latch_scm/register_file_1r_1w_test_wrap.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1w_64b_multi_port_read_32b_1row.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1w_multi_port_read_1row.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1r_1w_all.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1r_1w_all_test_wrap.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1r_1w_be.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1r_1w.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1r_1w_1row.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1w_128b_multi_port_read_32b.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1w_64b_multi_port_read_32b.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1w_64b_1r_32b.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1w_multi_port_read_be.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_1w_multi_port_read.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_2r_1w_asymm.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_2r_1w_asymm_test_wrap.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_2r_2w.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_3r_2w.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_3r_2w_be.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_multi_way_1w_64b_multi_port_read_32b.sv" \
    "$ROOT/ips/scm/latch_scm/register_file_multi_way_1w_multi_port_read.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/ips/zeroriscy/include" \
    "$ROOT/ips/zeroriscy/include/zeroriscy_defines.sv" \
    "$ROOT/ips/zeroriscy/include/zeroriscy_tracer_defines.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_alu.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_compressed_decoder.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_controller.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_cs_registers.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_debug_unit.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_decoder.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_int_controller.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_ex_block.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_register_file_ff.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_id_stage.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_if_stage.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_load_store_unit.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_multdiv_slow.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_multdiv_fast.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_prefetch_buffer.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_fetch_fifo.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_tracer.sv" \
    "$ROOT/ips/zeroriscy/zeroriscy_core.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress 2583 -suppress 13314 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "$ROOT/rtl/tb_dummy_memory.sv" \
    "$ROOT/rtl/tb_hwpe.sv"
}]} {return 1}
