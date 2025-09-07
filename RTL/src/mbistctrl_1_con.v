/*
 *  Tue Mar 15 16:54:04 2022
 *  MBISTArchitect  v8.2009_2.10  Fri May 29 04:16:12 GMT 2009
 *  Verilog model:  mbistctrl_1_con
 *  Verilog model which connects a bist block to memories for ./output/mbistctrl_1.v
 *
 *
 */

`timescale 1 ns /10 ps

/* Connection Block: mbistctrl_1_con */
module mbistctrl_1_con (
      bist_done, 
      bist_fail_0, 
      bist_hold_l, 
      bist_debugz, 
      diag_scan_out_fail, 
      bist_en, 
      bist_clk, 
      bist_rst_l, 
      DOUT_0, 
      A1_0, 
      DIN_0, 
      WEB_0, 
      CEB_0, 
      CLK_0, 
      RSTB_0, 
      BYPASS_0, 
      NVR_0, 
      BEN_0, 
      TRIM_0,
      UE_0, 
      ERRF_0,
      WRC_0, 
      VLP_0,
      bp_clk_0, 
      test_mode_0);
   output  bist_done;
   output  bist_fail_0;
   input  bist_hold_l;
   input  bist_debugz;
   output  diag_scan_out_fail;
   input  bist_en;
   input  bist_clk;
   input  bist_rst_l;
   output [31 : 0] DOUT_0;
   input [16 : 0] A1_0;
   input [31 : 0] DIN_0;
   input  WEB_0;
   input  CEB_0;
   input  CLK_0;
   input  RSTB_0;
   input  BYPASS_0;
   input [1 : 0] NVR_0;
   input [3 : 0] BEN_0;
   input [1 : 0] TRIM_0;
   output [3 : 0] UE_0;
   output [3 : 0] ERRF_0;
   output WRC_0;
   input  VLP_0;
   input  bp_clk_0;
   input  test_mode_0;


   wire [16 : 0] wire_A1_0;
   wire [3 : 0] wire_BEN_0;
   wire [31 : 0] wire_DIN_0;
   wire [31 : 0] wire_DOUT_0;
   wire [3 : 0] wire_ERRF_0;
   wire [1 : 0] wire_NVR_0;
   wire [17 : 0] wire_Test_A1_0;
   wire  wire_Test_CEB_0;
   wire [31 : 0] wire_Test_DIN_0;
   wire [31 : 0] wire_Test_DOUT_0;
   wire  wire_Test_WEB_0;
   wire [1 : 0] wire_TRIM_0;
   wire         wire_VLP_0;
   wire [3 : 0] wire_UE_0;
   wire  wire_WRC_0;
   wire  wire_bist_clk;
   wire  wire_bist_debugz;
   wire  wire_bist_done;
   wire  wire_bist_en;
   wire  wire_bist_fail_0;
   wire  wire_bist_hold_l;
   wire  wire_bist_rst_l;
   wire  wire_diag_scan_out_fail;

   mbistctrl_1
      U_mbistctrl_1(
         .Test_A1_0(wire_Test_A1_0), 
         .Test_DIN_0(wire_Test_DIN_0), 
         .Test_WEB_0(wire_Test_WEB_0), 
         .Test_CEB_0(wire_Test_CEB_0), 
         .bist_done(wire_bist_done), 
         .bist_fail_0(wire_bist_fail_0), 
         .Test_DOUT_0(wire_Test_DOUT_0), 
         .bist_hold_l(wire_bist_hold_l), 
         .bist_debugz(wire_bist_debugz), 
         .diag_scan_out_fail(wire_diag_scan_out_fail), 
         .bist_en(wire_bist_en), 
         .bist_clk(wire_bist_clk), 
         .bist_rst_l(wire_bist_rst_l));

   mbistctrl_1_MRAM_4MB_block
      mbistctrl_1_MRAM_4MB_block_instance_0(
         .DOUT(wire_DOUT_0), 
         .test_DOUT(wire_Test_DOUT_0), 
         .bist_en(wire_bist_en), 
         .A1(wire_A1_0), 
         .test_A1(wire_Test_A1_0), 
         .DIN(wire_DIN_0), 
         .test_DIN(wire_Test_DIN_0), 
         .WEB(WEB_0), 
         .test_WEB(wire_Test_WEB_0), 
         .CEB(CEB_0), 
         .test_CEB(wire_Test_CEB_0), 
         .CLK(CLK_0), 
         .test_CLK(wire_bist_clk), 
         .RSTB(RSTB_0), 
         .BYPASS(BYPASS_0), 
         .NVR(wire_NVR_0), 
         .BEN(wire_BEN_0), 
         .TRIM(wire_TRIM_0),
         .UE(wire_UE_0), 
         .ERRF(wire_ERRF_0), 
         .WRC(wire_WRC_0),
         .VLP(wire_VLP_0),
         .bp_clk(bp_clk_0), 
         .test_mode(test_mode_0), 
         .bist_rst_l(wire_bist_rst_l));

   assign bist_done = wire_bist_done;
   assign bist_fail_0 = wire_bist_fail_0;
   assign wire_bist_hold_l = bist_hold_l;
   assign wire_bist_debugz = bist_debugz;
   assign diag_scan_out_fail = wire_diag_scan_out_fail;
   assign wire_bist_en = bist_en;
   assign wire_bist_clk = bist_clk;
   assign wire_bist_rst_l = bist_rst_l;
   assign DOUT_0 = wire_DOUT_0;
   assign wire_A1_0 = A1_0;
   assign wire_DIN_0 = DIN_0;
   assign wire_NVR_0 = NVR_0;
   assign wire_BEN_0 = BEN_0;
   assign UE_0 = wire_UE_0;
   assign ERRF_0 = wire_ERRF_0;
   assign WRC_0  = wire_WRC_0;
   assign wire_TRIM_0 = TRIM_0;
   assign wire_VLP_0  = VLP_0;

endmodule
