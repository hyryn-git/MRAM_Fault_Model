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

endmodule
