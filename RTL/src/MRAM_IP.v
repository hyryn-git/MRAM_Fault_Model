module MRAM_IP(
  //bist port
  input BIST_EN,
  input BIST_CLK,
  input BIST_RST,
  input BIST_HOLD_L,
  input DEBUG_Z,
  input TEST_MODE,

  output BIST_DONE,
  output BIST_FAIL,
  output SCAN_OUT_FAIL,

  //memory port
  input CLK,
  input PROb,
  input [16:0] A,
  input [1:0]  NVR,
  input WEb,
  input CEb,
  input ECCBYPS,
  input [3:0] BEN,
  input [31:0] DIN,
  input VREF,
  input [1:0] DELAY_TRIM,
  
  output [31:0] DOUT,
  output [3:0]  UE,
  output [3:0]  ERRF,
  output WRC 
);

  wire bp_clk = 1'b0;
  wire test_mode = TEST_MODE;

  mbistctrl_1_con ucon(BIST_DONE,
                       BIST_FAIL,
                       BIST_HOLD_L,
                       DEBUG_Z,
                       SCAN_OUT_FAIL,
                       BIST_EN,
                       BIST_CLK,
                       BIST_RST,
                       DOUT,
                       A,
                       DIN,
                       WEb,
                       CEb,
                       CLK,
                       PROb,
                       ECCBYPS,
                       NVR,
                       BEN,
                       DELAY_TRIM,
                       UE,
                       ERRF,
                       WRC,
                       VREF,
                       bp_clk,
                       test_mode
                     );
endmodule
