/*
 * mac_package.sv
 * Francesco Conti <fconti@iis.ee.ethz.ch>
 *
 * Copyright (C) 2018 ETH Zurich, University of Bologna
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the "License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

import hwpe_stream_package::*;

package mac_package;

  parameter int unsigned MAC_CNT_LEN = 1024; // maximum length of the vectors for a scalar product

  // registers in register file
  parameter int unsigned MAC_REG_A_ADDR           = 0;
  parameter int unsigned MAC_REG_B_ADDR           = 1;
  parameter int unsigned MAC_REG_C_ADDR           = 2;
  parameter int unsigned MAC_REG_D_ADDR           = 3;
  parameter int unsigned MAC_REG_NB_ITER          = 4;
  parameter int unsigned MAC_REG_LEN_ITER         = 5;
  parameter int unsigned MAC_REG_SHIFT_SIMPLEMUL  = 6;
  parameter int unsigned MAC_REG_SHIFT_VECTSTRIDE = 7;

  // microcode offset indeces -- this should be aligned to the microcode compiler of course!
  parameter int unsigned MAC_UCODE_A_OFFS = 0;
  parameter int unsigned MAC_UCODE_B_OFFS = 1;
  parameter int unsigned MAC_UCODE_C_OFFS = 2;
  parameter int unsigned MAC_UCODE_D_OFFS = 3;

  // microcode mnemonics -- this should be aligned to the microcode compiler of course!
  parameter int unsigned MAC_UCODE_MNEM_NBITER     = 4 - 4;
  parameter int unsigned MAC_UCODE_MNEM_ITERSTRIDE = 5 - 4;
  parameter int unsigned MAC_UCODE_MNEM_ONESTRIDE  = 6 - 4;


endpackage // mac_package
