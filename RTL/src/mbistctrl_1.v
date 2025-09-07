/*
 *  Tue Mar 15 16:54:04 2022
 *  MBISTArchitect  v8.2009_2.10  Fri May 29 04:16:12 GMT 2009
 *  Verilog model:  mbistctrl_1
 *  Ram Pattern Generator State Machine
 *  with Comparator
 *  Test Types: march2
 *  Data Width = 32
 */

`timescale 1 ns /10 ps
module mbistctrl_1(
    Test_A1_0,
    Test_DIN_0,
    Test_WEB_0,
    Test_CEB_0,
    bist_done,
    bist_fail_0,
    Test_DOUT_0,
    bist_hold_l,
    bist_debugz,
    diag_scan_out_fail,
    bist_en,
    bist_clk,
    bist_rst_l);

output [17:0] Test_A1_0;
output [31:0] Test_DIN_0;
output  Test_WEB_0;
output  Test_CEB_0;
output  bist_done;
output  bist_fail_0;
input [31:0] Test_DOUT_0;
input  bist_hold_l;
input  bist_debugz;
output  diag_scan_out_fail;
input  bist_en;
input  bist_clk;
input  bist_rst_l;

specify
    specparam mgc_dft_cell_type$mbistctrl_1 = "mbist_controller";
    specparam mgc_dft_bist_cycles$mbistctrl_1 = "4259810";
    specparam mgc_dft_diag_cycles$mbistctrl_1 = "60";
    specparam mgc_dft_connect$Test_A1_0 =
        "mbistctrl_1_MRAM_4MB_block/0/test_A1";
    specparam mgc_dft_connect$Test_DIN_0 =
        "mbistctrl_1_MRAM_4MB_block/0/test_DIN";
    specparam mgc_dft_connect$Test_WEB_0 =
        "mbistctrl_1_MRAM_4MB_block/0/test_WEB";
    specparam mgc_dft_connect$Test_CEB_0 =
        "mbistctrl_1_MRAM_4MB_block/0/test_CEB";
    specparam mgc_dft_pin_type$bist_done =
        "tst_done";
    specparam mgc_dft_pin_type$bist_fail_0 =
        "fail_h";
    specparam mgc_dft_connect$Test_DOUT_0 =
        "mbistctrl_1_MRAM_4MB_block/0/test_DOUT";
    specparam mgc_dft_pin_type$bist_hold_l =
        "hold_l";
    specparam mgc_dft_pin_type$bist_debugz =
        "debugz";
    specparam mgc_dft_pin_type$diag_scan_out_fail =
        "diag_scan_out";
    specparam mgc_dft_pin_type$bist_en =
        "test_h";
    specparam mgc_dft_pin_type$bist_clk =
        "bist_clk";
    specparam mgc_dft_pin_type$bist_rst_l =
        "rst_l";
endspecify


 parameter
    start_state = 3'd0,
    s_march2_march2_wBackgroundUp_0 = 3'd1,
    s_march2_march2_rwrInvBackgroundUp_0 = 3'd3,
    s_march2_march2_rwrBackgroundUp_0 = 3'd2,
    s_march2_march2_rwrInvBackgroundDown_0 = 3'd6,
    s_march2_march2_rwrBackgroundDown_0 = 3'd7,
    s_march2_march2_rBackgroundDown_0 = 3'd5,
    complete_state = 3'd4,
    md_none = 2'd0,
    md_r = 2'd1,
    md_rwr = 2'd2,
    md_w = 2'd3,
    p_background1 = 32'b00000000000000000000000000000000,
    AddrNoOp = 2'b00,
    AddrOp_Unary_0_133118_up_18_133118 = 2'b01,
    AddrOp_Unary_133118_0_down_18_133118 = 2'b10;


/*   Internal Registers and Variables       */

  reg  tst_done_var;
  reg  tst_done_reg;
  reg  [1:0]  mode_var;
  reg  [1:0]  next_mode_var;
  reg  [2:0]  rw_state;
  reg  [2:0]  tstate;
  reg  [2:0]  new_tstate;
  reg  [31:0]  mbist_active_background;
  reg  [17:0]  tmp_A1_0;
  reg  [31:0]  tmp_DIN_0;
  reg  Test_tmp_WEB_0;
  reg  Test_tmp_CEB_0;
  reg  [17:0]  addr_reg;
  reg  [17:0]  addr_reg_start_var;
  reg  [31:0]  expect_DOUT_0;
  reg  compare_DOUT_0;
  reg  wen_state;
  reg  cen_state;
  reg  [1:0]  addr_op_var;
  reg  pat_var;
  reg  rslt_reg;
  reg  new_rslt_reg;
  wire  [31:0]  DOUT_0;
  reg  bist_en_1;
  reg  bist_en_2;
  reg  fail_mon_tmp;
  reg  fail_mon;
  wire  int_hold;
  wire  hold_update;
  reg  hold_update_reg;
  wire  [52:0]  int_monitor;
  wire  int_debugz;
  wire  is_compare_cycle;
  wire  int_failure;
  wire  int_hold_flag;
  wire  int_recovery;
  wire  [31:0]  background1;
  reg  bist_done;
  reg  bist_fail_0;

   assign hold_update = bist_hold_l & ~int_hold;

/*      Diagnostic Block Instance       */
   mbistctrl_1_diag
      mbistctrl_1_diag_inst(
         .drst_l(bist_rst_l), 
         .failure(int_failure), 
         .monitor(int_monitor), 
         .enable(int_debugz), 
         .hold_flag_port(int_hold_flag), 
         .recovery_port(int_recovery), 
         .hold(int_hold), 
         .dout(diag_scan_out_fail), 
         .ctrl_clk(bist_clk), 
         .diag_clk(bist_clk));

   assign int_monitor = {DOUT_0, addr_reg, tstate};
   assign int_debugz = bist_debugz;
   assign is_compare_cycle = ((((rw_state == 3'h1) & 
   (mode_var == md_r)) | ((rw_state == 3'h1) & (mode_var == 
   md_rwr))) | ((rw_state == 3'h5) & (mode_var == md_rwr))) 
   ? 1'h1 : 1'h0;
   assign int_failure = (is_compare_cycle & fail_mon_tmp);


   assign background1 = p_background1;



/*      Merge Inputs        */

   assign DOUT_0 = Test_DOUT_0;



/*      Assign from Active Background       */
   always @(mbist_active_background)
   begin : ActiveBackground
      tmp_DIN_0 = mbist_active_background;
   end 


/*      AssignOutputs       */

   always @(addr_reg)
   begin : AssignAddressOutputs
      tmp_A1_0 = addr_reg;
   end 

   always @(background1 or pat_var)
   begin : AssignDataOutputs
      case (pat_var) // synopsys parallel_case
         1'h0:
            mbist_active_background = background1;
         1'h1:
            mbist_active_background = ~background1;
         default
            mbist_active_background = 32'h00000000;
      endcase
   end 

   always @(cen_state or wen_state)
   begin : AssignControlOutputs
      Test_tmp_WEB_0 = ~wen_state;
      Test_tmp_CEB_0 = ~cen_state;
   end 

   always @(bist_debugz or fail_mon or rslt_reg or 
      tst_done_reg)
   begin : AssignFailHTestDoneOutput
      bist_done = tst_done_reg;
      if (bist_debugz == 1'h1 & tst_done_reg == 1'h0)
         bist_fail_0 = fail_mon;
      else if (bist_debugz == 1'h1)
         bist_fail_0 = 1'h0;
      else
         bist_fail_0 = rslt_reg;
   end 


    assign Test_A1_0 = tmp_A1_0;
    assign Test_DIN_0 = tmp_DIN_0;
    assign Test_WEB_0 = Test_tmp_WEB_0;
    assign Test_CEB_0 = Test_tmp_CEB_0;


/*      Comparator      */
   always @(background1 or bist_en_2 or mode_var or pat_var 
      or rw_state)
   begin : mbist_expect_process
      if (bist_en_2 == 1'h1)
         case (pat_var) // synopsys parallel_case
            1'h0:
               case (mode_var) // synopsys parallel_case
                  md_none:
                     expect_DOUT_0 = 32'h00000000;
                  md_r:
                     expect_DOUT_0 = background1;
                  md_rwr:
                     if (rw_state <= 3'h2)
                        expect_DOUT_0 = ~background1;
                     else if (rw_state > 3'h2)
                        expect_DOUT_0 = background1;
                     else
                        expect_DOUT_0 = 32'h00000000;
                  md_w:
                     expect_DOUT_0 = 32'h00000000;
                  default
                     expect_DOUT_0 = 32'h00000000;
               endcase
            1'h1:
               case (mode_var) // synopsys parallel_case
                  md_none:
                     expect_DOUT_0 = 32'h00000000;
                  md_r:
                     expect_DOUT_0 = ~background1;
                  md_rwr:
                     if (rw_state <= 3'h2)
                        expect_DOUT_0 = background1;
                     else if (rw_state > 3'h2)
                        expect_DOUT_0 = ~background1;
                     else
                        expect_DOUT_0 = 32'h00000000;
                  md_w:
                     expect_DOUT_0 = 32'h00000000;
                  default
                     expect_DOUT_0 = 32'h00000000;
               endcase
            default
               expect_DOUT_0 = 32'h00000000;
         endcase
      else
         expect_DOUT_0 = 32'h00000000;
   end 
   always @(DOUT_0 or bist_en_2 or expect_DOUT_0)
   begin : mbist_compare_process
      if (bist_en_2 == 1'h1)
         if (DOUT_0 == expect_DOUT_0)
            compare_DOUT_0 = 1'h1;
         else
            compare_DOUT_0 = 1'h0;
      else
         compare_DOUT_0 = 1'h1;
   end 
   always @(bist_en_2 or compare_DOUT_0 or rslt_reg or 
      tstate)
   begin : mbist_collate_process
      if (bist_en_2 == 1'h1)
         case (tstate) // synopsys parallel_case
            start_state:
               begin
                  new_rslt_reg = 1'h0;
                  fail_mon_tmp = 1'h0;
               end
            s_march2_march2_wBackgroundUp_0:
               begin
                  new_rslt_reg = rslt_reg;
                  fail_mon_tmp = 1'h0;
               end
            s_march2_march2_rwrInvBackgroundUp_0:
               if ((compare_DOUT_0 == 1'h1))
                  begin
                     new_rslt_reg = rslt_reg;
                     fail_mon_tmp = 1'h0;
                  end
               else
                  begin
                     new_rslt_reg = 1'h1;
                     fail_mon_tmp = 1'h1;
                  end
            s_march2_march2_rwrBackgroundUp_0:
               if ((compare_DOUT_0 == 1'h1))
                  begin
                     new_rslt_reg = rslt_reg;
                     fail_mon_tmp = 1'h0;
                  end
               else
                  begin
                     new_rslt_reg = 1'h1;
                     fail_mon_tmp = 1'h1;
                  end
            s_march2_march2_rwrInvBackgroundDown_0:
               if ((compare_DOUT_0 == 1'h1))
                  begin
                     new_rslt_reg = rslt_reg;
                     fail_mon_tmp = 1'h0;
                  end
               else
                  begin
                     new_rslt_reg = 1'h1;
                     fail_mon_tmp = 1'h1;
                  end
            s_march2_march2_rwrBackgroundDown_0:
               if ((compare_DOUT_0 == 1'h1))
                  begin
                     new_rslt_reg = rslt_reg;
                     fail_mon_tmp = 1'h0;
                  end
               else
                  begin
                     new_rslt_reg = 1'h1;
                     fail_mon_tmp = 1'h1;
                  end
            s_march2_march2_rBackgroundDown_0:
               if ((compare_DOUT_0 == 1'h1))
                  begin
                     new_rslt_reg = rslt_reg;
                     fail_mon_tmp = 1'h0;
                  end
               else
                  begin
                     new_rslt_reg = 1'h1;
                     fail_mon_tmp = 1'h1;
                  end
            complete_state:
               begin
                  new_rslt_reg = rslt_reg;
                  fail_mon_tmp = 1'h0;
               end
            default
               begin
                  new_rslt_reg = rslt_reg;
                  fail_mon_tmp = 1'h0;
               end
         endcase
      else
         begin
            new_rslt_reg = rslt_reg;
            fail_mon_tmp = 1'h0;
         end
   end 


/*      Next State      */
   always @(tstate)
   begin : next_state
      case (tstate) // synopsys parallel_case
         start_state:
            begin
               addr_op_var = AddrNoOp;
               addr_reg_start_var = 18'h00000;
               mode_var = md_none;
               new_tstate = s_march2_march2_wBackgroundUp_0;
               next_mode_var = md_w;
               pat_var = 1'h0;
               tst_done_var = 1'h0;
            end
         s_march2_march2_wBackgroundUp_0:
            begin
               addr_op_var = 
                  AddrOp_Unary_0_133118_up_18_133118;
               addr_reg_start_var = 18'h00000;
               mode_var = md_w;
               new_tstate = 
                  s_march2_march2_rwrInvBackgroundUp_0;
               next_mode_var = md_rwr;
               pat_var = 1'h0;
               tst_done_var = 1'h0;
            end
         s_march2_march2_rwrInvBackgroundUp_0:
            begin
               addr_op_var = 
                  AddrOp_Unary_0_133118_up_18_133118;
               addr_reg_start_var = 18'h00000;
               mode_var = md_rwr;
               new_tstate = 
                  s_march2_march2_rwrBackgroundUp_0;
               next_mode_var = md_rwr;
               pat_var = 1'h1;
               tst_done_var = 1'h0;
            end
         s_march2_march2_rwrBackgroundUp_0:
            begin
               addr_op_var = 
                  AddrOp_Unary_0_133118_up_18_133118;
               addr_reg_start_var = 18'h207ff;
               mode_var = md_rwr;
               new_tstate = 
                  s_march2_march2_rwrInvBackgroundDown_0;
               next_mode_var = md_rwr;
               pat_var = 1'h0;
               tst_done_var = 1'h0;
            end
         s_march2_march2_rwrInvBackgroundDown_0:
            begin
               addr_op_var = 
                  AddrOp_Unary_133118_0_down_18_133118;
               addr_reg_start_var = 18'h207ff;
               mode_var = md_rwr;
               new_tstate = 
                  s_march2_march2_rwrBackgroundDown_0;
               next_mode_var = md_rwr;
               pat_var = 1'h1;
               tst_done_var = 1'h0;
            end
         s_march2_march2_rwrBackgroundDown_0:
            begin
               addr_op_var = 
                  AddrOp_Unary_133118_0_down_18_133118;
               addr_reg_start_var = 18'h207ff;
               mode_var = md_rwr;
               new_tstate = 
                  s_march2_march2_rBackgroundDown_0;
               next_mode_var = md_r;
               pat_var = 1'h0;
               tst_done_var = 1'h0;
            end
         s_march2_march2_rBackgroundDown_0:
            begin
               addr_op_var = 
                  AddrOp_Unary_133118_0_down_18_133118;
               addr_reg_start_var = 18'h00000;
               mode_var = md_r;
               new_tstate = complete_state;
               next_mode_var = md_none;
               pat_var = 1'h0;
               tst_done_var = 1'h0;
            end
         complete_state:
            begin
               addr_op_var = AddrNoOp;
               addr_reg_start_var = 18'h00000;
               mode_var = md_none;
               new_tstate = complete_state;
               next_mode_var = md_none;
               pat_var = 1'h0;
               tst_done_var = 1'h1;
            end
         default
            begin
               addr_op_var = AddrNoOp;
               addr_reg_start_var = 18'h00000;
               mode_var = md_none;
               new_tstate = complete_state;
               next_mode_var = md_none;
               pat_var = 1'h0;
               tst_done_var = 1'h0;
            end
      endcase
   end 


/*      Synchronized Signals Block      */
   always @(posedge bist_clk or negedge bist_rst_l)
      begin : SynchSignals
         if (bist_rst_l == 1'h0)
            begin
               bist_en_1 <= 1'h0;
               bist_en_2 <= 1'h0;
            end
         else
            begin
               bist_en_2 <= bist_en_1;
               bist_en_1 <= bist_en;
            end
      end 

/*      Update the registers        */

  always @(posedge bist_clk or negedge bist_rst_l)
  begin  : update
    if (bist_rst_l == 1'h0) begin
       tstate <= 3'h0;
       addr_reg <= 18'h207ff;
       rw_state <= 3'h0;
       wen_state <= 1'h0;
       cen_state <= 1'h0;
       tst_done_reg <= 1'h0;
       rslt_reg <= 1'h0;
       fail_mon <= 1'h0;
       hold_update_reg <= 1'h0;
    end
    else begin
       tst_done_reg <= tst_done_var & ~(int_hold_flag);
       hold_update_reg <= hold_update;

       if (((bist_en_2 == 1'h1) && (tstate != complete_state)) && (hold_update == 1'h1)) begin
          if (rw_state == 3'h6) begin
             rw_state <= 3'h0;
          end
          else
          if ((mode_var == md_r) && (rw_state == 3'h2)) begin
             rw_state <= 3'h0;
          end
          else
          if ((mode_var == md_w) && (rw_state == 3'h0)) begin
             rw_state <= 3'h0;
          end
          else
          if ((mode_var == md_none) && (rw_state == 3'h0)) begin
             rw_state <= 3'h0;
          end
          else begin
             rw_state <= rw_state + 3'h1;
          end
          if (((((rw_state == 3'h0) && (mode_var == md_w)) && ~(((addr_op_var == AddrNoOp) || 
             ((addr_op_var == AddrOp_Unary_0_133118_up_18_133118) && 
             (addr_reg == 18'h207ff))) || ((addr_op_var == AddrOp_Unary_133118_0_down_18_133118) && 
             (addr_reg == 18'h0)))) || (((next_mode_var == md_w) && 
             (((((mode_var == md_none) && (rw_state == 3'h0)) || 
             ((rw_state == 3'h2) && (mode_var == md_r))) || ((rw_state == 3'h6) && 
             (mode_var == md_rwr))) || ((rw_state == 3'h0) && 
             (mode_var == md_w)))) && (((addr_op_var == AddrNoOp) || 
             ((addr_op_var == AddrOp_Unary_0_133118_up_18_133118) && 
             (addr_reg == 18'h207ff))) || ((addr_op_var == AddrOp_Unary_133118_0_down_18_133118) && 
             (addr_reg == 18'h0))))) || ((rw_state == 3'h2) && 
             (mode_var == md_rwr))) begin
             wen_state <= 1'h1;
          end
          else begin
             wen_state <= 1'h0;
          end
          if ((((((((((rw_state == 3'h2) && (mode_var == md_r)) || ((rw_state == 3'h6) && 
             (mode_var == md_rwr))) || ((rw_state == 3'h0) && 
             (mode_var == md_w))) && ~(((addr_op_var == AddrNoOp) || 
             ((addr_op_var == AddrOp_Unary_0_133118_up_18_133118) && 
             (addr_reg == 18'h207ff))) || ((addr_op_var == AddrOp_Unary_133118_0_down_18_133118) && 
             (addr_reg == 18'h0)))) || (((((next_mode_var == md_r) || 
             (next_mode_var == md_rwr)) || (next_mode_var == md_w)) && 
             (((((mode_var == md_none) && (rw_state == 3'h0)) || 
             ((rw_state == 3'h2) && (mode_var == md_r))) || ((rw_state == 3'h6) && 
             (mode_var == md_rwr))) || ((rw_state == 3'h0) && 
             (mode_var == md_w)))) && (((addr_op_var == AddrNoOp) || 
             ((addr_op_var == AddrOp_Unary_0_133118_up_18_133118) && 
             (addr_reg == 18'h207ff))) || ((addr_op_var == AddrOp_Unary_133118_0_down_18_133118) && 
             (addr_reg == 18'h0))))) || ((rw_state == 3'h0) && 
             ((mode_var == md_r) || (mode_var == md_rwr)))) || 
             ((rw_state == 3'h2) && (mode_var == md_rwr))) || 
             ((rw_state == 3'h3) && (mode_var == md_rwr))) || 
             ((rw_state == 3'h4) && (mode_var == md_rwr))) begin
             cen_state <= 1'h1;
          end
          else begin
             cen_state <= 1'h1;
          end
          if (((((mode_var == md_r) && (rw_state == 3'h2)) || ((mode_var == md_rwr) && 
             (rw_state == 3'h6))) || ((mode_var == md_w) && (rw_state == 3'h0))) || 
             ((mode_var == md_none) && (rw_state == 3'h0))) begin
                 case (addr_op_var) // synopsys parallel_case
                    AddrOp_Unary_0_133118_up_18_133118:
                       if (addr_reg == 18'h207ff)
                          begin
                             addr_reg <= addr_reg_start_var;
                             tstate <= new_tstate;
                          end
                       else
                          addr_reg <= addr_reg + 18'h00001;
                    AddrOp_Unary_133118_0_down_18_133118:
                       if (addr_reg == 18'h00000)
                          begin
                             addr_reg <= addr_reg_start_var;
                             tstate <= new_tstate;
                          end
                       else
                          addr_reg <= addr_reg - 18'h00001;
                    AddrNoOp:
                       begin
                          addr_reg <= addr_reg_start_var;
                          tstate <= new_tstate;
                       end
                    default
                       begin
                          addr_reg <= addr_reg_start_var;
                          tstate <= new_tstate;
                       end
                 endcase

          end
       end
       if (((bist_en_2 == 1'h1) && (tstate != complete_state)) && (hold_update_reg == 1'h1)) begin
          if (((((rw_state == 3'h1) && (mode_var == md_r)) || ((rw_state == 3'h1) && 
             (mode_var == md_rwr))) || ((rw_state == 3'h5) && 
             (mode_var == md_rwr))) || (mode_var == md_w)) begin
             rslt_reg <= new_rslt_reg;

             if (int_hold_flag == 1'h0) begin
                if (int_recovery == 1'h0) begin
                   fail_mon <= fail_mon_tmp;
                end
                else begin
                   fail_mon <= 1'h0;
                end
             end
          end
       end
       else
       if (int_hold_flag == 1'h0) begin
          if (int_recovery == 1'h1) begin
             fail_mon <= 1'h0;
          end
       end
    end
  end
endmodule


/*      Diagnostic Block        */
module mbistctrl_1_diag (
      drst_l, 
      failure, 
      monitor, 
      enable, 
      diag_clk, 
      ctrl_clk, 
      hold_flag_port, 
      recovery_port, 
      dout, 
      hold);
   input  drst_l;
   input  failure;
   input [52 : 0] monitor;
   input  enable;
   input  diag_clk;
   input  ctrl_clk;
   output  hold_flag_port;
   output  recovery_port;
   output  dout;
   output  hold;

   parameter cs_cidle = 3'd0;
   parameter cs_failflag2 = 3'd3;
   parameter cs_hold_keep_flag = 3'd5;
   parameter cs_hold_recovery_1 = 3'd6;
   parameter cs_hold_scan = 3'd2;
   parameter cs_keep_flag = 3'd4;
   parameter cs_recovery_1 = 3'd7;
   parameter cs_scan = 3'd1;
   parameter ds_end1 = 3'd3;
   parameter ds_end2 = 3'd4;
   parameter ds_final = 3'd1;
   parameter ds_idle = 3'd0;
   parameter ds_shift_data = 3'd2;
   parameter ds_start2 = 3'd5;
   parameter shift_max = 6'd53;

   reg [2 : 0] cont_state;
   reg  diag_done;
   reg  diag_done_1;
   reg  diag_done_2;
   reg [2 : 0] diag_state;
   reg  dout_tmp;
   reg  hold_flag;
   reg  int_hold;
   reg  recovery;
   reg [shift_max - 1 : 0] scan_sig;
   reg [5 : 0] shift_count;
   reg  start_diag;
   reg  start_diag_1;
   reg  start_diag_2;

   always @(cont_state)
   begin : FlagProcess
      case (cont_state) // synopsys parallel_case
         cs_cidle:
            begin
               recovery = 1'h0;
               hold_flag = 1'h0;
            end
         cs_scan:
            begin
               recovery = 1'h0;
               hold_flag = 1'h1;
            end
         cs_hold_scan:
            begin
               recovery = 1'h0;
               hold_flag = 1'h1;
            end
         cs_failflag2:
            begin
               recovery = 1'h0;
               hold_flag = 1'h0;
            end
         cs_keep_flag:
            begin
               recovery = 1'h0;
               hold_flag = 1'h1;
            end
         cs_hold_keep_flag:
            begin
               recovery = 1'h0;
               hold_flag = 1'h1;
            end
         default
            begin
               recovery = 1'h1;
               hold_flag = 1'h0;
            end
      endcase
   end 

   always @(cont_state or enable or failure)
   begin : HoldProcess
      if (enable == 1'h1)
         case (cont_state) // synopsys parallel_case
            cs_cidle:
               int_hold = 1'h0;
            cs_scan:
               int_hold = 1'h1;
            cs_keep_flag:
               int_hold = 1'h1;
            cs_recovery_1:
               int_hold = 1'h1;
            cs_hold_scan:
               int_hold = 1'h1;
            cs_hold_keep_flag:
               int_hold = 1'h1;
            cs_hold_recovery_1:
               int_hold = 1'h1;
            cs_failflag2:
               int_hold = 1'h0;
            default
               int_hold = failure;
         endcase
      else
         int_hold = 1'h0;
   end 

   always @(posedge ctrl_clk or negedge drst_l)
      begin : DiagCtrl
         if (drst_l == 1'h0)
            begin
               start_diag <= 1'h0;
               diag_done_1 <= 1'h0;
               diag_done_2 <= 1'h0;
               scan_sig <= 53'h00000000000000;
               cont_state <= cs_cidle;
            end
         else
            begin
               diag_done_1 <= diag_done;
               diag_done_2 <= diag_done_1;
               if (enable == 1'h1)
                  case (cont_state) // synopsys parallel_case
                     cs_cidle:
                        if (failure == 1'h1)
                           begin
                              start_diag <= 1'h1;
                              scan_sig <= monitor;
                              cont_state <= cs_scan;
                           end
                     cs_scan:
                        if (failure == 1'h1)
                           cont_state <= cs_hold_scan;
                        else if (diag_done_2 == 1'h1)
                           begin
                              start_diag <= 1'h0;
                              cont_state <= cs_keep_flag;
                           end
                     cs_keep_flag:
                        if (failure == 1'h1)
                           if (diag_done_2 == 1'h0)
                              cont_state <= 
                                 cs_hold_recovery_1;
                           else
                              cont_state <= 
                                 cs_hold_keep_flag;
                        else if (diag_done_2 == 1'h0)
                           cont_state <= cs_recovery_1;
                     cs_hold_scan:
                        if (diag_done_2 == 1'h1)
                           begin
                              start_diag <= 1'h0;
                              cont_state <= 
                                 cs_hold_keep_flag;
                           end
                     cs_hold_keep_flag:
                        if (diag_done_2 == 1'h0)
                           cont_state <= cs_hold_recovery_1;
                     cs_hold_recovery_1:
                        if (diag_done_2 == 1'h0)
                           begin
                              scan_sig <= monitor;
                              cont_state <= cs_failflag2;
                           end
                     cs_failflag2:
                        if (diag_done_2 == 1'h0)
                           begin
                              start_diag <= 1'h0;
                              cont_state <= cs_cidle;
                           end
                     cs_recovery_1:
                        if (failure == 1'h1)
                           begin
                              scan_sig <= monitor;
                              cont_state <= cs_failflag2;
                           end
                        else if (diag_done_2 == 1'h0)
                           cont_state <= cs_cidle;
                     default
                        begin
                           start_diag <= 1'h0;
                           cont_state <= cs_cidle;
                        end
                  endcase
               else
                  start_diag <= 1'h0;
            end
      end 

   always @(posedge diag_clk or negedge drst_l)
      begin : DiagScan
         if (drst_l == 1'h0)
            begin
               shift_count <= shift_max - 1'h1;
               diag_done <= 1'h0;
               start_diag_1 <= 1'h0;
               start_diag_2 <= 1'h0;
               diag_state <= ds_idle;
               dout_tmp <= 1'h0;
            end
         else
            begin
               start_diag_1 <= start_diag;
               start_diag_2 <= start_diag_1;
               if (enable == 1'h1)
                  case (diag_state) // synopsys parallel_case
                     ds_idle:
                        begin
                           diag_done <= 1'h0;
                           dout_tmp <= start_diag_2;
                           if (start_diag_2 == 1'h1)
                              diag_state <= ds_start2;
                           else
                              diag_state <= ds_idle;
                        end
                     ds_start2:
                        begin
                           diag_state <= ds_shift_data;
                           dout_tmp <= 1'h1;
                        end
                     ds_shift_data:
                        begin
                           dout_tmp <= scan_sig[shift_count];

                           if (shift_count == 6'h00)
                              begin
                                 diag_state <= ds_end1;
                                 diag_done <= 1'h1;
                                 shift_count <= shift_max - 
                                    1'h1;
                              end
                           else
                              begin
                                 diag_state <= ds_shift_data;

                                 shift_count <= shift_count -
                                     1'h1;
                              end
                        end
                     ds_end1:
                        begin
                           diag_state <= ds_end2;
                           dout_tmp <= 1'h1;
                        end
                     ds_end2:
                        begin
                           diag_state <= ds_final;
                           diag_done <= 1'h1;
                           dout_tmp <= 1'h1;
                        end
                     ds_final:
                        begin
                           dout_tmp <= 1'h0;
                           if (start_diag_2 == 1'h0)
                              begin
                                 diag_state <= ds_idle;
                                 diag_done <= 1'h0;
                              end
                        end
                     default
                        begin
                           shift_count <= shift_max - 1'h1;
                           diag_done <= 1'h0;
                           diag_state <= ds_idle;
                           dout_tmp <= 1'h0;
                        end
                  endcase
               else
                  diag_done <= 1'h0;
            end
      end 

   assign dout = dout_tmp;
   assign hold = int_hold;
   assign recovery_port = recovery;
   assign hold_flag_port = hold_flag;
endmodule


/* Bypass Block for: MRAM_4MB_bypass_0 */
module MRAM_4MB_bypass_0 (
      bp_clk, 
      bist_rst_l, 
      test_mode, 
      bpo_DOUT, 
      bpi_DOUT, 
      in_A1, 
      in_DIN, 
      in_WEB, 
      in_CEB);
   input  bp_clk;
   input  bist_rst_l;
   input  test_mode;
   output [31 : 0] bpo_DOUT;
   input [31 : 0] bpi_DOUT;
   input [17 : 0] in_A1;
   input [31 : 0] in_DIN;
   input  in_WEB;
   input  in_CEB;


   reg [31 : 0] bpReg;
   reg [31 : 0] bpo_DOUT;
   reg [31 : 0] nextBpReg;

   always @(bpReg or bpi_DOUT or test_mode)
   begin : BypassAssignOutputs
      if (test_mode == 1'h1)
         begin
            bpo_DOUT[0] = bpReg[0];
            bpo_DOUT[1] = bpReg[1];
            bpo_DOUT[2] = bpReg[2];
            bpo_DOUT[3] = bpReg[3];
            bpo_DOUT[4] = bpReg[4];
            bpo_DOUT[5] = bpReg[5];
            bpo_DOUT[6] = bpReg[6];
            bpo_DOUT[7] = bpReg[7];
            bpo_DOUT[8] = bpReg[8];
            bpo_DOUT[9] = bpReg[9];
            bpo_DOUT[10] = bpReg[10];
            bpo_DOUT[11] = bpReg[11];
            bpo_DOUT[12] = bpReg[12];
            bpo_DOUT[13] = bpReg[13];
            bpo_DOUT[14] = bpReg[14];
            bpo_DOUT[15] = bpReg[15];
            bpo_DOUT[16] = bpReg[16];
            bpo_DOUT[17] = bpReg[17];
            bpo_DOUT[18] = bpReg[18];
            bpo_DOUT[19] = bpReg[19];
            bpo_DOUT[20] = bpReg[20];
            bpo_DOUT[21] = bpReg[21];
            bpo_DOUT[22] = bpReg[22];
            bpo_DOUT[23] = bpReg[23];
            bpo_DOUT[24] = bpReg[24];
            bpo_DOUT[25] = bpReg[25];
            bpo_DOUT[26] = bpReg[26];
            bpo_DOUT[27] = bpReg[27];
            bpo_DOUT[28] = bpReg[28];
            bpo_DOUT[29] = bpReg[29];
            bpo_DOUT[30] = bpReg[30];
            bpo_DOUT[31] = bpReg[31];
         end
      else
         bpo_DOUT = bpi_DOUT;
   end 

   always @(in_A1 or in_CEB or in_DIN or in_WEB)
   begin : BypassNextState
      nextBpReg[0] = in_A1[0];
      nextBpReg[1] = in_A1[1];
      nextBpReg[2] = in_A1[2];
      nextBpReg[3] = in_A1[3];
      nextBpReg[4] = in_A1[4] ^ in_A1[5];
      nextBpReg[5] = in_A1[6] ^ in_A1[7];
      nextBpReg[6] = in_A1[8] ^ in_A1[9];
      nextBpReg[7] = in_A1[10] ^ in_A1[11];
      nextBpReg[8] = in_A1[12] ^ in_A1[13];
      nextBpReg[9] = in_A1[14] ^ in_A1[15];
      nextBpReg[10] = in_A1[16] ^ in_A1[17];
      nextBpReg[11] = in_DIN[0];
      nextBpReg[12] = in_DIN[1];
      nextBpReg[13] = in_DIN[2];
      nextBpReg[14] = in_DIN[3];
      nextBpReg[15] = in_DIN[4];
      nextBpReg[16] = in_DIN[5];
      nextBpReg[17] = in_DIN[6];
      nextBpReg[18] = in_DIN[7];
      nextBpReg[19] = in_DIN[8] ^ in_DIN[9];
      nextBpReg[20] = in_DIN[10] ^ in_DIN[11];
      nextBpReg[21] = in_DIN[12] ^ in_DIN[13];
      nextBpReg[22] = in_DIN[14] ^ in_DIN[15];
      nextBpReg[23] = in_DIN[16] ^ in_DIN[17];
      nextBpReg[24] = in_DIN[18] ^ in_DIN[19];
      nextBpReg[25] = in_DIN[20] ^ in_DIN[21];
      nextBpReg[26] = in_DIN[22] ^ in_DIN[23];
      nextBpReg[27] = in_DIN[24] ^ in_DIN[25];
      nextBpReg[28] = in_DIN[26] ^ in_DIN[27];
      nextBpReg[29] = in_DIN[28] ^ in_DIN[29];
      nextBpReg[30] = in_DIN[30] ^ in_DIN[31];
      nextBpReg[31] = in_WEB ^ in_CEB;
   end 

   always @(posedge bp_clk or negedge bist_rst_l)
      begin : BypassUpdateRegister
         if (bist_rst_l == 1'h0)
            bpReg <= 32'h00000000;
         else
            bpReg <= nextBpReg;
      end 

endmodule


/* Memory Collar Block for: mbistctrl_1_MRAM_4MB_block */
module mbistctrl_1_MRAM_4MB_block (
      DOUT, 
      test_DOUT, 
      bist_en, 
      A1, 
      test_A1, 
      DIN, 
      test_DIN, 
      WEB, 
      test_WEB, 
      CEB, 
      test_CEB, 
      CLK, 
      test_CLK, 
      RSTB, 
      BYPASS, 
      NVR, 
      BEN, 
      TRIM,
      UE, 
      ERRF, 
      WRC,
      VLP,
      bp_clk, 
      test_mode, 
      bist_rst_l);
   output [31 : 0] DOUT;
   output [31 : 0] test_DOUT;
   input  bist_en;
   input [16 : 0] A1;
   input [17 : 0] test_A1;
   input [31 : 0] DIN;
   input [31 : 0] test_DIN;
   input  WEB;
   input  test_WEB;
   input  CEB;
   input  test_CEB;
   input  CLK;
   input  test_CLK;
   input  RSTB;
   input  BYPASS;
   input [1 : 0] NVR;
   input [3 : 0] BEN;
   input [1 : 0] TRIM;
   output [3 : 0] UE;
   output [3 : 0] ERRF;
   output WRC;
   input  VLP;
   input  bp_clk;
   input  test_mode;
   input  bist_rst_l;


   specify
      specparam mgc_dft_cell_type$mbistctrl_1_MRAM_4MB_block = 
         "mbist_memory:mbistctrl_1";
      specparam mgc_dft_connect$DOUT = 
         "DOUT";
      specparam mgc_dft_connect$bist_en = 
         "bist_en";
      specparam mgc_dft_pin_type$bist_en = 
         "test_h";
      specparam mgc_dft_connect$A1 = 
         "A1";
      specparam mgc_dft_connect$DIN = 
         "DIN";
      specparam mgc_dft_connect$WEB = 
         "WEB";
      specparam mgc_dft_connect$CEB = 
         "CEB";
      specparam mgc_dft_connect$CLK = 
         "CLK";
      specparam mgc_dft_connect$test_CLK = 
         "test_CLK";
      specparam mgc_dft_pin_type$test_CLK = 
         "bist_clk";
      specparam mgc_dft_connect$RSTB = 
         "RSTB";
      specparam mgc_dft_pin_type$RSTB = 
         "RSTB";
      specparam mgc_dft_connect$BYPASS = 
         "BYPASS";
      specparam mgc_dft_pin_type$BYPASS = 
         "BYPASS";
      specparam mgc_dft_connect$NVR = 
         "NVR";
      specparam mgc_dft_pin_type$NVR = 
         "NVR";
      specparam mgc_dft_connect$BEN = 
         "BEN";
      specparam mgc_dft_pin_type$BEN = 
         "BEN";
      specparam mgc_dft_connect$UE = 
         "UE";
      specparam mgc_dft_pin_type$UE = 
         "UE";
      specparam mgc_dft_connect$ERRF = 
         "ERRF";
      specparam mgc_dft_pin_type$ERRF = 
         "ERRF";
      specparam mgc_dft_connect$bp_clk = 
         "bp_clk";
      specparam mgc_dft_pin_type$bp_clk = 
         "bypass_clk";
      specparam mgc_dft_connect$test_mode = 
         "test_mode";
      specparam mgc_dft_pin_type$test_mode = 
         "bypass_control";
      specparam mgc_dft_connect$bist_rst_l = 
         "bist_rst_l";
      specparam mgc_dft_pin_type$bist_rst_l = 
         "rst_l";
   endspecify

   wire [31 : 0] wire_0;
   wire [31 : 0] wire_1;
   wire  wire_10;
   wire  wire_11;
   wire  wire_12;
   wire  wire_13;
   wire  wire_14;
   wire  wire_15;
   wire  wire_16;
   wire  wire_17;
   wire  wire_18;
   wire [1 : 0] wire_19;
   wire [16 : 0] wire_2;
   wire [3 : 0] wire_20;
   wire [3 : 0] wire_21;
   wire [3 : 0] wire_22;
   wire wire_23;
   wire [1 : 0] wire_24;
   wire         wire_25;
   wire [16 : 0] wire_3;
   wire [16 : 0] wire_4;
   wire [31 : 0] wire_5;
   wire [31 : 0] wire_6;
   wire [31 : 0] wire_7;
   wire  wire_8;
   wire  wire_9;

   wire wire_nvr1_sel;
   wire wire_nvr0_sel;
   wire wire_nvr0;
   wire wire_nvr1;
   wire wire_nvr1_test;
   wire wire_nvr0_test;



   MRAM_4MB
      MRAM_4MB_instance_0(
         .DOUT(wire_0), 
         .A1(wire_2), 
         .DIN(wire_5), 
         .WEB(wire_8), 
         .CEB(wire_11), 
         .CLK(wire_14), 
         .RSTB(wire_17), 
         .BYPASS(wire_18), 
         .NVR({wire_nvr1_sel,wire_nvr0_sel}), 
         .BEN(wire_20), 
         .UE(wire_21), 
         .ERRF(wire_22),
         .TRIM(wire_24),
         .WRC(wire_23),
         .VLP(wire_25));

   MRAM_4MB_bypass_0
      MRAM_4MB_bypass_0_instance_0(
         .bp_clk(bp_clk), 
         .bist_rst_l(bist_rst_l), 
         .test_mode(test_mode), 
         .in_A1({1'b0,wire_2}), 
         .in_DIN(wire_5), 
         .in_CEB(wire_11), 
         .in_WEB(wire_8), 
         .bpi_DOUT(wire_0), 
         .bpo_DOUT(wire_1));

   assign DOUT = wire_1;
   assign test_DOUT = wire_1;
   assign wire_4 = A1[16:0];
   assign wire_2 = (bist_en == 1'h1) ? wire_3 : wire_4;
   assign wire_3 = test_A1[16:0];
   assign wire_7 = DIN;
   assign wire_5 = (bist_en == 1'h1) ? wire_6 : wire_7;
   assign wire_6 = test_DIN;
   assign wire_10 = WEB;
   assign wire_8 = (bist_en == 1'h1) ? wire_9 : wire_10;
   assign wire_9 = test_WEB;
   assign wire_13 = CEB;
   assign wire_11 = (bist_en == 1'h1) ? wire_12 : wire_13;
   assign wire_12 = test_CEB;
   assign wire_15 = CLK;
   assign wire_14 = (bist_en == 1'h1) ? wire_16 : wire_15;
   /*MX2_X2B_A12TR40 u_dont_touch_clkmx(
     .Y(wire14),
     .A(wire15),
     .B(wire16),
     .S0(bist_en)
   );*/
   assign wire_16 = test_CLK;
   assign wire_17 = RSTB;
   assign wire_18 = BYPASS;
   //assign wire_19 = NVR;
   assign wire_20 = BEN;
   assign UE = wire_21;
   assign ERRF = wire_22;
   assign WRC = wire_23;
   assign wire_24 = TRIM;
   assign wire_25 = VLP;

   //added
   assign wire_nvr0_test  = test_A1[10];
   assign wire_nvr0       = NVR[0];
   assign wire_nvr0_sel   = (bist_en == 1'h1) ? wire_nvr0_test : wire_nvr0;

   assign wire_nvr1_test  = test_A1[17];
   assign wire_nvr1       = NVR[1];
   assign wire_nvr1_sel   = (bist_en == 1'h1) ? wire_nvr1_test : wire_nvr1;
endmodule
