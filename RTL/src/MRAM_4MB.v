//=====================================================================
//
// Designer   : Yaoru Hou
//
// Description: The module is a 4Mb MRAM with ECC
//
// Content    : .  EHC_13_8_Code
//              2. EHC_13_8_Decode
//              3. MRAM_4MB
//
// Date       : 2022/4/5 
// ====================================================================
//

`timescale 1ns/1ps

module EHC_13_8_Code(
    input [7:0] DIN,
    input BYPASS,
    output [12:0] DOUT
);
//****Generate parity bits
wire [4:0] ParityBit;
assign ParityBit[1] = BYPASS ? 1'b0 : DIN[0]^DIN[1]^DIN[3]^DIN[4]^DIN[6];
assign ParityBit[2] = BYPASS ? 1'b0 : DIN[0]^DIN[2]^DIN[3]^DIN[5]^DIN[6];
assign ParityBit[3] = BYPASS ? 1'b0 : DIN[1]^DIN[2]^DIN[3]^DIN[7];
assign ParityBit[4] = BYPASS ? 1'b0 : DIN[4]^DIN[5]^DIN[6]^DIN[7];

//DED Bit
assign ParityBit[0] = BYPASS ? 1'b0 : ^{DIN,ParityBit[4:1]};
//****Output Data
assign DOUT = {ParityBit,DIN};
endmodule



module EHC_13_8_Decode(
    input [12:0] DIN,
    input BYPASS,
    output ERRF,
    output UE,
    output reg [7:0] DOUT
);
//****Separate data bits and parity bits
wire [1:0] ERR;
wire [7:0] DinTemp;
assign DinTemp = DIN[7:0];
wire [4:0] ParityTemp;
assign ParityTemp = DIN[12:8];
//****Calculate error bits
wire [3:0] ErrNum;
assign ErrNum = {
  //Bit3
  (~BYPASS)&ParityTemp[4]^DinTemp[4]^DinTemp[5]^DinTemp[6]^DinTemp[7],
  //Bit2
  (~BYPASS)&ParityTemp[3]^DinTemp[1]^DinTemp[2]^DinTemp[3]^DinTemp[7],
  //Bit1
  (~BYPASS)&ParityTemp[2]^DinTemp[0]^DinTemp[2]^DinTemp[3]^DinTemp[5]^DinTemp[6],
  //Bit0
  (~BYPASS)&ParityTemp[1]^DinTemp[0]^DinTemp[1]^DinTemp[3]^DinTemp[4]^DinTemp[6]
};
//****Generate Error Status
localparam NoErr    = 2'b00;
localparam OneErr   = 2'b11;
localparam TwoErr   = 2'b01;
assign ERR[1] = (~BYPASS)&(^DIN);//Double Error Bit
assign ERR[0] = (ErrNum == 1'b0) ? 1'b0 : 1'b1;//Error exist Bit

//flag bit
assign ERRF = (ERR == NoErr) ? 1'b0 : 1'b1;
assign UE = (ERR == TwoErr) ? 1'b1 : 1'b0;

always@(*)
begin
    //DOUT = DinTemp;
    case(ERR)
    NoErr: DOUT = DinTemp;
    OneErr:begin
    if(ErrNum==4'd3) begin
      DOUT  = {DinTemp[7:1], !DinTemp[0]};
    end

    else if(ErrNum==4'd5) begin
      DOUT  = {DinTemp[7:2], !DinTemp[1], DinTemp[0]};
    end

    else if(ErrNum==4'd6) begin
          DOUT  = {DinTemp[7:3], !DinTemp[2], DinTemp[1:0]};
    end

    else if(ErrNum==4'd7) begin
          DOUT  = {DinTemp[7:4], !DinTemp[3], DinTemp[2:0]};
    end

    else if(ErrNum==4'd9) begin
          DOUT  = {DinTemp[7:5], !DinTemp[4], DinTemp[3:0]};
    end

    else if(ErrNum==4'd10) begin
          DOUT  = {DinTemp[7:6], !DinTemp[5], DinTemp[4:0]};
    end

    else if(ErrNum==4'd11) begin
      DOUT  = {DinTemp[7], !DinTemp[6], DinTemp[5:0]};
    end

    else if(ErrNum==4'd12) begin
      DOUT  = {!DinTemp[7], DinTemp[6:0]};
    end
    
    else DOUT = DinTemp;

  end
    //TwoErr:  DOUT = DinTemp;
    default:  DOUT = DinTemp;
    endcase
end

endmodule




module  D_7_128(
  input               ENB,
  input       [6:0]   A,
  output  reg [127:0] Y
);
  always@(*) begin
    if(ENB)  begin
      Y = ~(1 << A); 
    end
    else  Y = {(128){1'b1}};
  end 
endmodule



module  MRAM_4MB #(
  parameter MAIN_DEPTH    = 17,
  parameter NVR_DEPTH     = 11,
  parameter DATA_WIDTH    = 32,
  parameter ECC_WIDTH     = 20,
  parameter TOTAL_WIDTH   = DATA_WIDTH+ECC_WIDTH,
  parameter DATA_BYTE_WIDTH  = DATA_WIDTH >> 2,
  parameter ECC_BYTE_WIDTH   = ECC_WIDTH >> 2,
  parameter TOTAL_BYTE_WIDTH = DATA_BYTE_WIDTH + ECC_BYTE_WIDTH,
  parameter BEN_WIDTH     = 4,
  parameter BANK_DEPTH    = 10,
  parameter NVR_CEB_DEPTH = NVR_DEPTH-BANK_DEPTH,
  parameter MAIN_NUM      = (1<<(MAIN_DEPTH-BANK_DEPTH)),
  parameter NVR_NUM       = (1<<(NVR_DEPTH-BANK_DEPTH)),

  parameter TRIM0         = 0,
  parameter TRIM1         = 1,
  parameter TRIM2         = 2,
  parameter TRIM3         = 3,
  parameter TRIM4         = 4
)(
  input [MAIN_DEPTH-1:0]            A1,
  input [DATA_WIDTH-1:0]            DIN,
  input                             CEB,
  input                             WEB,
  input [NVR_CEB_DEPTH:0]           NVR,
  input                             CLK,
  input                             RSTB,
  input                             BYPASS,
  input [BEN_WIDTH-1:0]             BEN,
  input [1:0]                       TRIM,
  input                             VLP,
  
  output[DATA_WIDTH-1:0]            DOUT,
  output[BEN_WIDTH-1:0]             ERRF,
  output[BEN_WIDTH-1:0]             UE,
  output                            WRC
);
  
/******************latch control and address signal*********************/
  reg                  latch_web;
  reg                  latch_ceb;
  reg                  latch_bypass;
  reg [BEN_WIDTH-1:0]  latch_ben;
  reg [MAIN_DEPTH-1:0] latch_a1 ;
  reg [NVR_CEB_DEPTH:0]latch_nvr;


  always @(posedge CLK or negedge RSTB) begin
    if(!RSTB) begin
      latch_a1     <= 0;
      latch_web    <= 0;
      latch_ceb    <= 0;
      latch_ben    <= 4'b0000;      //change to low actived
      latch_bypass <= 0;
      latch_nvr    <= 0;
    end
    else  begin
      latch_a1     <= A1;
      latch_ben    <= ~BEN;         //change to low actived
      latch_web    <= WEB;
      latch_ceb    <= CEB;
      latch_bypass <= BYPASS;
      latch_nvr    <= NVR;
    end
  end

  //assign ben_wr = latch_web ? 4'b1111 : latch_ben; 

/**********************data is input to ecc encoder*********************/  
  wire [DATA_BYTE_WIDTH-1:0]   wire_ecc_code_din_b0;
  wire [DATA_BYTE_WIDTH-1:0]   wire_ecc_code_din_b1;
  wire [DATA_BYTE_WIDTH-1:0]   wire_ecc_code_din_b2;
  wire [DATA_BYTE_WIDTH-1:0]   wire_ecc_code_din_b3;

  wire [TOTAL_BYTE_WIDTH-1:0]  wire_ecc_code_dout_b0;
  wire [TOTAL_BYTE_WIDTH-1:0]  wire_ecc_code_dout_b1;
  wire [TOTAL_BYTE_WIDTH-1:0]  wire_ecc_code_dout_b2;
  wire [TOTAL_BYTE_WIDTH-1:0]  wire_ecc_code_dout_b3;
  
  EHC_13_8_Code encode_u0(wire_ecc_code_din_b0, BYPASS, wire_ecc_code_dout_b0);
  EHC_13_8_Code encode_u1(wire_ecc_code_din_b1, BYPASS, wire_ecc_code_dout_b1);
  EHC_13_8_Code encode_u2(wire_ecc_code_din_b2, BYPASS, wire_ecc_code_dout_b2);
  EHC_13_8_Code encode_u3(wire_ecc_code_din_b3, BYPASS, wire_ecc_code_dout_b3);

  assign  wire_ecc_code_din_b0 = DIN[DATA_BYTE_WIDTH-1:0];
  assign  wire_ecc_code_din_b1 = DIN[2*DATA_BYTE_WIDTH-1:DATA_BYTE_WIDTH];
  assign  wire_ecc_code_din_b2 = DIN[3*DATA_BYTE_WIDTH-1:2*DATA_BYTE_WIDTH];
  assign  wire_ecc_code_din_b3 = DIN[4*DATA_BYTE_WIDTH-1:3*DATA_BYTE_WIDTH];

/*******************latch ecc encoder output data **********************/
  reg [TOTAL_BYTE_WIDTH-1:0]  latch_din_b0;
  reg [TOTAL_BYTE_WIDTH-1:0]  latch_din_b1;
  reg [TOTAL_BYTE_WIDTH-1:0]  latch_din_b2;
  reg [TOTAL_BYTE_WIDTH-1:0]  latch_din_b3;

  always @(posedge CLK or negedge RSTB) begin
    if(!RSTB) begin
      latch_din_b0 <= 0;
      latch_din_b1 <= 0;
      latch_din_b2 <= 0;
      latch_din_b3 <= 0;
    end
    else  begin
      latch_din_b0 <= wire_ecc_code_dout_b0;
      latch_din_b1 <= wire_ecc_code_dout_b1;
      latch_din_b2 <= wire_ecc_code_dout_b2;
      latch_din_b3 <= wire_ecc_code_dout_b3;
    end
  end

/*****************130 MRAM BANKs*********************/
  wire [MAIN_NUM-1:0]     main_ceb;
  wire [NVR_NUM-1:0]      nvr_ceb;
  wire [TOTAL_WIDTH-1:0]  bank_din;
  wire [TOTAL_WIDTH-1:0]  bank_main_dout [MAIN_NUM-1:0];
  wire [TOTAL_WIDTH-1:0]  bank_nvr_dout [NVR_NUM-1:0];
  wire [MAIN_NUM-1:0]     main_wrc;
  wire [NVR_NUM-1:0]      nvr_wrc;
  wire [MAIN_NUM-1:0]     main_lat;
  wire [NVR_NUM-1:0]      nvr_lat;                                   

  reg  [TOTAL_WIDTH-1:0]  bank_dout;
  
  D_7_128 D1(~latch_ceb && ~latch_nvr[1], latch_a1[MAIN_DEPTH-1:BANK_DEPTH], main_ceb);
  
  assign  nvr_ceb[0] = (latch_ceb == 0 && latch_nvr[1]) ? latch_nvr[NVR_CEB_DEPTH-1] : 1;
  assign  nvr_ceb[1] = (latch_ceb == 0 && latch_nvr[1]) ? ~latch_nvr[NVR_CEB_DEPTH-1]: 1;

  assign  bank_din  =  {latch_din_b3[0],latch_din_b3[TOTAL_BYTE_WIDTH-2:DATA_BYTE_WIDTH],latch_din_b2[TOTAL_BYTE_WIDTH-1:DATA_BYTE_WIDTH],
                        latch_din_b1[TOTAL_BYTE_WIDTH-1:DATA_BYTE_WIDTH],latch_din_b0[TOTAL_BYTE_WIDTH-1:DATA_BYTE_WIDTH],
                        latch_din_b3[DATA_BYTE_WIDTH-1:1],latch_din_b3[TOTAL_BYTE_WIDTH-1],latch_din_b2[DATA_BYTE_WIDTH-1:0],
                        latch_din_b1[DATA_BYTE_WIDTH-1:0],latch_din_b0[DATA_BYTE_WIDTH-1:0]};

  //128 MRAM main bank
  
  genvar i;
  generate
    for(i=0;i<MAIN_NUM;i=i+1) begin:MAIN_BANK
      MRAM_BANK  main_bank_inst(.X(latch_a1[9:2]),.A(latch_a1[1:0]),.CEB(main_ceb[i]),.BEN(latch_ben),.CLK(CLK),.Din(bank_din),.OUT(bank_main_dout[i]),.WRC(main_wrc[i]),.DELAY_TRIM(TRIM),.LAT(main_lat[i]),.Vclamp(VLP),.WEB(latch_web));
    end
  endgenerate
  
  //2 MRAM NVR BANK
  MRAM_BANK nvr_bank_inst0(.X(latch_a1[9:2]),.A(latch_a1[1:0]),.CEB(nvr_ceb[0]),.BEN(latch_ben),.CLK(CLK),.Din(bank_din),.OUT(bank_nvr_dout[0]),.WRC(nvr_wrc[0]),.DELAY_TRIM(TRIM),.LAT(nvr_lat[0]),.Vclamp(VLP),.WEB(latch_web));

  MRAM_BANK nvr_bank_inst1(.X(latch_a1[9:2]),.A(latch_a1[1:0]),.CEB(nvr_ceb[1]),.BEN(latch_ben),.CLK(CLK),.Din(bank_din),.OUT(bank_nvr_dout[1]),.WRC(nvr_wrc[1]),.DELAY_TRIM(TRIM),.LAT(nvr_lat[1]),.Vclamp(VLP),.WEB(latch_web));

/*****************BANK output data selector*********************/


  always@(*) begin
    if((~latch_ceb) && (~latch_nvr[NVR_CEB_DEPTH]) && latch_web) begin
      case (latch_a1[MAIN_DEPTH-1:BANK_DEPTH])
                0:      bank_dout = bank_main_dout[0];
                1:      bank_dout = bank_main_dout[1];
                2:      bank_dout = bank_main_dout[2];
                3:      bank_dout = bank_main_dout[3];
                4:      bank_dout = bank_main_dout[4];
                5:      bank_dout = bank_main_dout[5];
                6:      bank_dout = bank_main_dout[6];
                7:      bank_dout = bank_main_dout[7];
                8:      bank_dout = bank_main_dout[8];
                9:      bank_dout = bank_main_dout[9];
                10:     bank_dout = bank_main_dout[10];
                11:     bank_dout = bank_main_dout[11];
                12:     bank_dout = bank_main_dout[12];
                13:     bank_dout = bank_main_dout[13];
                14:     bank_dout = bank_main_dout[14];
                15:     bank_dout = bank_main_dout[15];
                16:     bank_dout = bank_main_dout[16];
                17:     bank_dout = bank_main_dout[17];
                18:     bank_dout = bank_main_dout[18];
                19:     bank_dout = bank_main_dout[19];
                20:     bank_dout = bank_main_dout[20];
                21:     bank_dout = bank_main_dout[21];
                22:     bank_dout = bank_main_dout[22];
                23:     bank_dout = bank_main_dout[23];
                24:     bank_dout = bank_main_dout[24];
                25:     bank_dout = bank_main_dout[25];
                26:     bank_dout = bank_main_dout[26];
                27:     bank_dout = bank_main_dout[27];
                28:     bank_dout = bank_main_dout[28];
                29:     bank_dout = bank_main_dout[29];
                30:     bank_dout = bank_main_dout[30];
                31:     bank_dout = bank_main_dout[31];
                32:     bank_dout = bank_main_dout[32];
                33:     bank_dout = bank_main_dout[33];
                34:     bank_dout = bank_main_dout[34];
                35:     bank_dout = bank_main_dout[35];
                36:     bank_dout = bank_main_dout[36];
                37:     bank_dout = bank_main_dout[37];
                38:     bank_dout = bank_main_dout[38];
                39:     bank_dout = bank_main_dout[39];
                40:     bank_dout = bank_main_dout[40];
                41:     bank_dout = bank_main_dout[41];
                42:     bank_dout = bank_main_dout[42];
                43:     bank_dout = bank_main_dout[43];
                44:     bank_dout = bank_main_dout[44];
                45:     bank_dout = bank_main_dout[45];
                46:     bank_dout = bank_main_dout[46];
                47:     bank_dout = bank_main_dout[47];
                48:     bank_dout = bank_main_dout[48];
                49:     bank_dout = bank_main_dout[49];
                50:     bank_dout = bank_main_dout[50];
                51:     bank_dout = bank_main_dout[51];
                52:     bank_dout = bank_main_dout[52];
                53:     bank_dout = bank_main_dout[53];
                54:     bank_dout = bank_main_dout[54];
                55:     bank_dout = bank_main_dout[55];
                56:     bank_dout = bank_main_dout[56];
                57:     bank_dout = bank_main_dout[57];
                58:     bank_dout = bank_main_dout[58];
                59:     bank_dout = bank_main_dout[59];
                60:     bank_dout = bank_main_dout[60];
                61:     bank_dout = bank_main_dout[61];
                62:     bank_dout = bank_main_dout[62];
                63:     bank_dout = bank_main_dout[63];
                64:     bank_dout = bank_main_dout[64];
                65:     bank_dout = bank_main_dout[65];
                66:     bank_dout = bank_main_dout[66];
                67:     bank_dout = bank_main_dout[67];
                68:     bank_dout = bank_main_dout[68];
                69:     bank_dout = bank_main_dout[69];
                70:     bank_dout = bank_main_dout[70];
                71:     bank_dout = bank_main_dout[71];
                72:     bank_dout = bank_main_dout[72];
                73:     bank_dout = bank_main_dout[73];
                74:     bank_dout = bank_main_dout[74];
                75:     bank_dout = bank_main_dout[75];
                76:     bank_dout = bank_main_dout[76];
                77:     bank_dout = bank_main_dout[77];
                78:     bank_dout = bank_main_dout[78];
                79:     bank_dout = bank_main_dout[79];
                80:     bank_dout = bank_main_dout[80];
                81:     bank_dout = bank_main_dout[81];
                82:     bank_dout = bank_main_dout[82];
                83:     bank_dout = bank_main_dout[83];
                84:     bank_dout = bank_main_dout[84];
                85:     bank_dout = bank_main_dout[85];
                86:     bank_dout = bank_main_dout[86];
                87:     bank_dout = bank_main_dout[87];
                88:     bank_dout = bank_main_dout[88];
                89:     bank_dout = bank_main_dout[89];
                90:     bank_dout = bank_main_dout[90];
                91:     bank_dout = bank_main_dout[91];
                92:     bank_dout = bank_main_dout[92];
                93:     bank_dout = bank_main_dout[93];
                94:     bank_dout = bank_main_dout[94];
                95:     bank_dout = bank_main_dout[95];
                96:     bank_dout = bank_main_dout[96];
                97:     bank_dout = bank_main_dout[97];
                98:     bank_dout = bank_main_dout[98];
                99:     bank_dout = bank_main_dout[99];
                100:    bank_dout = bank_main_dout[100];
                101:    bank_dout = bank_main_dout[101];
                102:    bank_dout = bank_main_dout[102];
                103:    bank_dout = bank_main_dout[103];
                104:    bank_dout = bank_main_dout[104];
                105:    bank_dout = bank_main_dout[105];
                106:    bank_dout = bank_main_dout[106];
                107:    bank_dout = bank_main_dout[107];
                108:    bank_dout = bank_main_dout[108];
                109:    bank_dout = bank_main_dout[109];
                110:    bank_dout = bank_main_dout[110];
                111:    bank_dout = bank_main_dout[111];
                112:    bank_dout = bank_main_dout[112];
                113:    bank_dout = bank_main_dout[113];
                114:    bank_dout = bank_main_dout[114];
                115:    bank_dout = bank_main_dout[115];
                116:    bank_dout = bank_main_dout[116];
                117:    bank_dout = bank_main_dout[117];
                118:    bank_dout = bank_main_dout[118];
                119:    bank_dout = bank_main_dout[119];
                120:    bank_dout = bank_main_dout[120];
                121:    bank_dout = bank_main_dout[121];
                122:    bank_dout = bank_main_dout[122];
                123:    bank_dout = bank_main_dout[123];
                124:    bank_dout = bank_main_dout[124];
                125:    bank_dout = bank_main_dout[125];
                126:    bank_dout = bank_main_dout[126];
                127:    bank_dout = bank_main_dout[127]; 
      endcase
    end
    else if(latch_nvr[NVR_CEB_DEPTH] && (~latch_ceb) && latch_web) begin
      case(latch_nvr[0])
       0:  bank_dout = bank_nvr_dout[0];
       1:  bank_dout = bank_nvr_dout[1];
      endcase
    end
    else begin
      bank_dout = 44'b0;
    end
  end


/*****************data is output to ecc decoder*********************/
  wire [DATA_BYTE_WIDTH-1:0]   wire_ecc_decode_dout_b0;
  wire [DATA_BYTE_WIDTH-1:0]   wire_ecc_decode_dout_b1;
  wire [DATA_BYTE_WIDTH-1:0]   wire_ecc_decode_dout_b2;
  wire [DATA_BYTE_WIDTH-1:0]   wire_ecc_decode_dout_b3;

  wire [TOTAL_BYTE_WIDTH-1:0]  wire_ecc_decode_din_b0;
  wire [TOTAL_BYTE_WIDTH-1:0]  wire_ecc_decode_din_b1;
  wire [TOTAL_BYTE_WIDTH-1:0]  wire_ecc_decode_din_b2;
  wire [TOTAL_BYTE_WIDTH-1:0]  wire_ecc_decode_din_b3; 

  wire [BEN_WIDTH-1:0]         wire_ecc_decode_errf;
  wire [BEN_WIDTH-1:0]         wire_ecc_decode_ue;

  EHC_13_8_Decode decode_u0(.DIN(wire_ecc_decode_din_b0),
                            .BYPASS(latch_bypass),
                            .ERRF(wire_ecc_decode_errf[0]),
                            .UE(wire_ecc_decode_ue[0]),
                            .DOUT(wire_ecc_decode_dout_b0));
  EHC_13_8_Decode decode_u1(.DIN(wire_ecc_decode_din_b1),
                            .BYPASS(latch_bypass),
                            .ERRF(wire_ecc_decode_errf[1]),
                            .UE(wire_ecc_decode_ue[1]),
                            .DOUT(wire_ecc_decode_dout_b1));
  EHC_13_8_Decode decode_u2(.DIN(wire_ecc_decode_din_b2),
                            .BYPASS(latch_bypass),
                            .ERRF(wire_ecc_decode_errf[2]),
                            .UE(wire_ecc_decode_ue[2]),
                            .DOUT(wire_ecc_decode_dout_b2));
  EHC_13_8_Decode decode_u3(.DIN(wire_ecc_decode_din_b3),
                            .BYPASS(latch_bypass),
                            .ERRF(wire_ecc_decode_errf[3]),
                            .UE(wire_ecc_decode_ue[3]),
                            .DOUT(wire_ecc_decode_dout_b3));
  
  assign wire_ecc_decode_din_b0 = latch_ben[0] ? {bank_dout[DATA_WIDTH+ECC_BYTE_WIDTH-1:DATA_WIDTH],bank_dout[DATA_BYTE_WIDTH-1:0]} : 8'h00;
  assign wire_ecc_decode_din_b1 = latch_ben[1] ? {bank_dout[DATA_WIDTH+2*ECC_BYTE_WIDTH-1:DATA_WIDTH+ECC_BYTE_WIDTH],bank_dout[2*DATA_BYTE_WIDTH-1:DATA_BYTE_WIDTH]} : 8'h00;
  assign wire_ecc_decode_din_b2 = latch_ben[2] ? {bank_dout[DATA_WIDTH+3*ECC_BYTE_WIDTH-1:DATA_WIDTH+2*ECC_BYTE_WIDTH],bank_dout[3*DATA_BYTE_WIDTH-1:2*DATA_BYTE_WIDTH]} : 8'h00;
  assign wire_ecc_decode_din_b3 = latch_ben[3] ? {bank_dout[3*DATA_BYTE_WIDTH],bank_dout[DATA_WIDTH+4*ECC_BYTE_WIDTH-2:DATA_WIDTH+3*ECC_BYTE_WIDTH],bank_dout[4*DATA_BYTE_WIDTH-1:3*DATA_BYTE_WIDTH+1],bank_dout[DATA_WIDTH+4*ECC_BYTE_WIDTH-1]} : 8'h00;

  assign DOUT = {wire_ecc_decode_dout_b3, wire_ecc_decode_dout_b2, wire_ecc_decode_dout_b1, wire_ecc_decode_dout_b0};
  assign UE   = wire_ecc_decode_ue;
  assign ERRF = wire_ecc_decode_errf;
/***************************WRC output**************************/
assign WRC = (main_wrc[TRIM0] && !main_ceb[TRIM0]) 
          || (main_wrc[TRIM1] && !main_ceb[TRIM1]) 
          || (main_wrc[TRIM2] && !main_ceb[TRIM2]) 
          || (main_wrc[TRIM3] && !main_ceb[TRIM3])
          || (main_wrc[TRIM4] && !main_ceb[TRIM4]);


endmodule


