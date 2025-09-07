//=====================================================================
//
// Designer   : Yaoru Hou
//
// Description: The module is a 256x412 MRAM BANK
//
// Content    : 1. MRAM_MAIN_BANK
//              2. LAT_DELAY
//
// Date       : 2022/4/5 
// ====================================================================


// MRAM bank: 256x256 64k 
// A1       : address
// CEB      : chip enable (Active low)
// BEN      : byte enable (Active low)
`timescale 1ns/1ps

`define     INJ_FAULT        //Note this line when no fault is injected

`define     SA0_ADDR    0
`define     SA0_BEN     0
`define     SA0_BIT     0

`define     SA1_ADDR    1
`define     SA1_BEN     1
`define     SA1_BIT     3

`define     TF01_ADDR   2
`define     TF01_BEN    3
`define     TF01_BIT    4

`define     TF10_ADDR   3
`define     TF10_BEN    2
`define     TF10_BIT    5

`define     INV_U_ADDR  4
`define     INV_U_BEN   3
`define     INV_U_BIT   4

`define     INV_D_ADDR  5
`define     INV_D_BEN   0
`define     INV_D_BIT   7

`define     INV_L_ADDR  6
`define     INV_L_BEN   2
`define     INV_L_BIT   2

`define     INV_R_ADDR  7
`define     INV_R_BEN   3
`define     INV_R_BIT   1


module MRAM_BANK #(
  parameter BANK_DEPTH        = 10,
  parameter DATA_WIDTH        = 32,
  parameter ECC_WIDTH         = 20,
  parameter TOTAL_WIDTH       = DATA_WIDTH + ECC_WIDTH,
  parameter BEN_WIDTH         = 4,
  parameter DATA_BYTE_WIDTH  = DATA_WIDTH >> 2,
  parameter ECC_BYTE_WIDTH   = ECC_WIDTH >> 2,
  parameter TOTAL_BYTE_WIDTH = DATA_BYTE_WIDTH + ECC_BYTE_WIDTH
)(
  input [1:0]             A     ,
  input [7:0]             X     ,
  //input                   RSTB  ,
  input                   CEB   ,
  //input                   CTRL  ,
  //input                   READ  ,
  //input                   WRITE ,
  input                   WEB   ,
  input                   Vclamp,
  input [BEN_WIDTH-1:0]   BEN   ,
  input                   CLK   ,
  input [TOTAL_WIDTH-1:0] Din   ,
  input [1:0]             DELAY_TRIM  ,

  output reg  [TOTAL_WIDTH-1:0] OUT ,  
  output reg                    WRC  ,
  output reg                    LAT 
);
  localparam  mem_depth = (1 << BANK_DEPTH) - 1;

  reg [TOTAL_BYTE_WIDTH-1:0] main_mem [BEN_WIDTH-1:0][mem_depth:0];

  wire READ  = WEB;
  wire WRITE = ~WEB;
  wire [TOTAL_WIDTH-1:0] DIN = Din;
  wire [9:0] A1 = {X,A};
  wire [1:0] TRIM  = DELAY_TRIM;

  //read
  always@(*) begin
    if(~CEB && READ && BEN[0]) begin
      {OUT[DATA_WIDTH+ECC_BYTE_WIDTH-1:DATA_WIDTH],OUT[DATA_BYTE_WIDTH-1:0]} = 52'bx;
      {OUT[DATA_WIDTH+ECC_BYTE_WIDTH-1:DATA_WIDTH],OUT[DATA_BYTE_WIDTH-1:0]} = #12 main_mem[0][A1];
    end
  end
    
  always@(*) begin
    if(~CEB && READ && BEN[1])  begin
      {OUT[2*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+ECC_BYTE_WIDTH],OUT[2*DATA_BYTE_WIDTH-1:DATA_BYTE_WIDTH]} = 52'bx;
      {OUT[2*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+ECC_BYTE_WIDTH],OUT[2*DATA_BYTE_WIDTH-1:DATA_BYTE_WIDTH]} =  #12 main_mem[1][A1];
    end
  end
   
  always@(*) begin
    if(~CEB && READ && BEN[2])  begin
      {OUT[3*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+2*ECC_BYTE_WIDTH],OUT[3*DATA_BYTE_WIDTH-1:2*DATA_BYTE_WIDTH]} = 52'bx;
      {OUT[3*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+2*ECC_BYTE_WIDTH],OUT[3*DATA_BYTE_WIDTH-1:2*DATA_BYTE_WIDTH]} = #12 main_mem[2][A1];
    end
  end
   
  always@(*) begin
    if(~CEB && READ && BEN[3] )  begin
      {OUT[4*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+3*ECC_BYTE_WIDTH],OUT[4*DATA_BYTE_WIDTH-1:3*DATA_BYTE_WIDTH]} = 52'bx;
      {OUT[4*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+3*ECC_BYTE_WIDTH],OUT[4*DATA_BYTE_WIDTH-1:3*DATA_BYTE_WIDTH]} = #12 main_mem[3][A1];  
    end
  end

  `ifdef  INJ_FAULT
    reg [TOTAL_WIDTH-1:0] din_r ;
    always @(*) begin
      din_r = DIN;
      if (A1 == `SA0_ADDR) din_r[`SA0_BEN*DATA_BYTE_WIDTH+`SA0_BIT] = 1'b0;
      else                 din_r[`SA0_BEN*DATA_BYTE_WIDTH+`SA0_BIT] = DIN[`SA0_BEN*DATA_BYTE_WIDTH+`SA0_BIT];
      if (A1 == `SA1_ADDR) din_r[`SA1_BEN*DATA_BYTE_WIDTH+`SA1_BIT] = 1'b1;
      else                 din_r[`SA1_BEN*DATA_BYTE_WIDTH+`SA1_BIT] = DIN[`SA1_BEN*DATA_BYTE_WIDTH+`SA1_BIT];
      if (A1 == `TF01_ADDR && main_mem[`TF01_BEN][A1][`TF01_BIT] == 1'b0 && DIN[`TF01_BEN*DATA_BYTE_WIDTH+`TF01_BIT] ==1'b1) 
        din_r[`TF01_BEN*DATA_BYTE_WIDTH+`TF01_BIT] = 0;
      else din_r[`TF01_BEN*DATA_BYTE_WIDTH+`TF01_BIT] = DIN[`TF01_BEN*DATA_BYTE_WIDTH+`TF01_BIT];
      if (A1 == `TF10_ADDR && main_mem[`TF10_BEN][A1][`TF10_BIT] == 1'b1 && DIN[`TF10_BEN*DATA_BYTE_WIDTH+`TF10_BIT] ==1'b0)
        din_r[`TF10_BEN*DATA_BYTE_WIDTH+`TF10_BIT] = 1;
      else din_r[`TF10_BEN*DATA_BYTE_WIDTH+`TF10_BIT] = DIN[`TF10_BEN*DATA_BYTE_WIDTH+`TF10_BIT];
    end
    /*
    assign din_w = DIN;
    assign din_w[`SA0_BEN*TOTAL_BYTE_WIDTH+`SA0_BIT]   = (A1 == `SA0_ADDR) ? 0 :  DIN[`SA0_BEN*TOTAL_BYTE_WIDTH+`SA0_BIT];
    assign din_w[`SA1_BEN*TOTAL_BYTE_WIDTH+`SA1_BIT]   = (A1 == `SA1_ADDR) ? 1 :  DIN[`SA1_BEN*TOTAL_BYTE_WIDTH+`SA1_BIT];
    assign din_w[`TF01_BEN*TOTAL_BYTE_WIDTH+`TF01_BIT] = (A1 == `TF01_ADDR && main_mem[`TF01_BEN][A1][`TF01_BIT] == 1'b0 && DIN[`TF01_BEN*TOTAL_BYTE_WIDTH+`TF01_BIT] ==1'b1) ? 0 : 1;
    assign din_w[`TF10_BEN*TOTAL_BYTE_WIDTH+`TF10_BIT] = (A1 == `TF10_ADDR && main_mem[`TF10_BEN][A1][`TF10_BIT] == 1'b1 && DIN[`TF10_BEN*TOTAL_BYTE_WIDTH+`TF10_BIT] ==1'b0) ? 1 : 0;
    */
  `endif

  `ifdef  INJ_FAULT
    always@( negedge CLK) begin
      if (~CEB && WRITE) begin
        if (A1 == `INV_U_ADDR && main_mem[`INV_U_BEN][`INV_U_ADDR][`INV_U_BIT] == 1'b1 && DIN[`INV_U_BEN*DATA_BYTE_WIDTH+`INV_U_BIT] == 0) begin
          main_mem[`INV_U_BEN][`INV_U_ADDR-4][`INV_U_BIT] <= ~main_mem[`INV_U_BEN][`INV_U_ADDR-4][`INV_U_BIT];
        end
        if (A1 == `INV_D_ADDR && main_mem[`INV_D_BEN][`INV_D_ADDR][`INV_D_BIT] == 1'b1 && DIN[`INV_D_BEN*DATA_BYTE_WIDTH+`INV_D_BIT] == 0) begin
          main_mem[`INV_D_BEN][`INV_D_ADDR+4][`INV_D_BIT] <= ~main_mem[`INV_D_BEN][`INV_D_ADDR+4][`INV_D_BIT];
        end
        if (A1 == `INV_L_ADDR && main_mem[`INV_L_BEN][`INV_L_ADDR][`INV_L_BIT] == 1'b1 && DIN[`INV_L_BEN*DATA_BYTE_WIDTH+`INV_L_BIT] == 0) begin
          main_mem[`INV_L_BEN][`INV_L_ADDR-1][`INV_L_BIT] <= ~main_mem[`INV_L_BEN][`INV_L_ADDR-1][`INV_L_BIT];
        end
        if (A1 == `INV_R_ADDR && main_mem[`INV_R_BEN][`INV_R_ADDR][`INV_R_BIT] == 1'b1 && DIN[`INV_R_BEN*DATA_BYTE_WIDTH+`INV_R_BIT] == 0) begin
          main_mem[`INV_R_BEN][`INV_R_ADDR+1][`INV_R_BIT] <= ~main_mem[`INV_R_BEN][`INV_R_ADDR+1][`INV_R_BIT];
        end
      end
    end
  `endif

  //write
  always@(*) begin
  
    #15

    if(~CEB && WRITE && BEN[0]) begin
      `ifdef INJ_FAULT
        main_mem[0][A1] <= {din_r[DATA_WIDTH+ECC_BYTE_WIDTH-1:DATA_WIDTH],din_r[DATA_BYTE_WIDTH-1:0]};
      `else
        main_mem[0][A1] <= {DIN[DATA_WIDTH+ECC_BYTE_WIDTH-1:DATA_WIDTH],DIN[DATA_BYTE_WIDTH-1:0]};  
      `endif 
    end

    if(~CEB && WRITE && BEN[1]) begin
      `ifdef INJ_FAULT
        main_mem[1][A1] <= {din_r[2*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+ECC_BYTE_WIDTH],din_r[2*DATA_BYTE_WIDTH-1:DATA_BYTE_WIDTH]};
      `else
        main_mem[1][A1] <= {DIN[2*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+ECC_BYTE_WIDTH],DIN[2*DATA_BYTE_WIDTH-1:DATA_BYTE_WIDTH]};
      `endif
    end

    if(~CEB && WRITE && BEN[2]) begin
      `ifdef INJ_FAULT
        main_mem[2][A1] <= {din_r[3*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+2*ECC_BYTE_WIDTH],din_r[3*DATA_BYTE_WIDTH-1:2*DATA_BYTE_WIDTH]};
      `else
        main_mem[2][A1] <= {DIN[3*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+2*ECC_BYTE_WIDTH],DIN[3*DATA_BYTE_WIDTH-1:2*DATA_BYTE_WIDTH]};
      `endif
    end

    if(~CEB && WRITE && BEN[3]) begin
      `ifdef INJ_FAULT
        main_mem[3][A1] <= {din_r[4*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+3*ECC_BYTE_WIDTH],din_r[4*DATA_BYTE_WIDTH-1:3*DATA_BYTE_WIDTH]};
      `else
        main_mem[3][A1] <= {DIN[4*ECC_BYTE_WIDTH+DATA_WIDTH-1:DATA_WIDTH+3*ECC_BYTE_WIDTH],DIN[4*DATA_BYTE_WIDTH-1:3*DATA_BYTE_WIDTH]};
      `endif
    end
  end

  //LAT_DELAY dly_u0(.CLK(CLK),.WEB(READ),.CEB(CEB),.LAT(LAT),.RSTB(RSTB));
  //LAT generate
  always@(*) begin
    if(CLK && ~CEB && READ) begin
      LAT = 1'b0;
      @ (negedge CLK);
      if(READ) 
        #5 LAT = 1'b1;
    end
  end
    

  

  //test WRC
  always @(posedge CLK or negedge CLK) begin
    if (CLK) begin
      WRC = 1'b1;
      #20
      if (TRIM == 2'b00) WRC = #3 1'b0;
      if (TRIM == 2'b01) WRC = #4 1'b0;
      if (TRIM == 2'b10) WRC = #5 1'b0;
      if (TRIM == 2'b11) WRC = #6 1'b0;
    end
    /*
    else if (!CLK && TRIM == 2'b00) WRC <= 1'b0;
    else if (!CLK && TRIM == 2'b01) WRC <= #5 1'b0;
    else if (!CLK && TRIM == 2'b10) WRC <= #7 1'b0;
    else if (!CLK && TRIM == 2'b11) WRC <= #9 1'b0;
    */
  end
endmodule


module LAT_DELAY #(
  parameter D1  = 15
)(
  input       CLK,
  input       CEB,
  input       WEB,
  input       RSTB,
  output      LAT
);
  reg   dly_r;
  wire  dly_w;

  //assign gclk_w = (~CEB && WEB) ? CLK : 0;
  always@( posedge CLK or negedge RSTB) begin
    if(!RSTB) dly_r = 0;
    //else if(~CEB && WEB) dly_r = !dly_r;
    else dly_r = !dly_r;
  end

  assign #D1 dly_w = dly_r; 
 
  assign LAT = !(dly_r ^ dly_w);
endmodule


