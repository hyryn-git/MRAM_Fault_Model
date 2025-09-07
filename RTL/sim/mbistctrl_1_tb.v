/*
 *  Tue Mar 15 16:54:04 2022
 *  MBISTArchitect  v8.2009_2.10  Fri May 29 04:16:12 GMT 2009
 *  Verilog model:  mbistctrl_1_tb
 *  Verilog model which instantiates and tests the bist block ./output/mbistctrl_1_con.v
 *
 *
 */
`timescale 1 ns /10 ps
/*******************ECC TEST*********************/
`define     ECC_ON
//`define     ECC_OFF

/*******************work mode********************/
//`define     BIST_MODE   
`define     MEM_MODE    

/*******************clock period*****************/
`define     CLK_35
//`define     CLK_20

/*******************trim level*******************/
//`define     TRIM_00
`define     TRIM_01
//`define     TRIM_10
//`define     TRIM_11




module mbistctrl_1_tb;
	wire bist_done;
	wire bist_fail_0;

	reg bist_hold_l_r;
	wire bist_hold_l = bist_hold_l_r;

	reg bist_debugz_r;
	wire bist_debugz = bist_debugz_r;

	wire diag_scan_out_fail;
	wire WRC_0;

	reg [1:0] TRIM_0_r;
	wire [1:0] TRIM_0 = TRIM_0_r;

  reg       VLP_0_r;
  wire      VLP_0 = VLP_0_r;

	reg bist_en_r;
	wire bist_en = bist_en_r;
	
	reg bist_clk;

	reg bist_rst_l_r;
	wire bist_rst_l = bist_rst_l_r;

	wire [31:0] DOUT_0;

	reg [16:0] A1_0_r;
	wire [16:0] A1_0 = A1_0_r;

	reg [31:0] DIN_0_r;
	wire [31:0] DIN_0 = DIN_0_r;

	reg WEB_0_r;
	wire WEB_0 = WEB_0_r;
	
	reg CEB_0_r;
	wire CEB_0 = CEB_0_r;

	reg CLK_0_r;
	wire CLK_0 = CLK_0_r;

	reg RSTB_0_r;
	wire RSTB_0 = RSTB_0_r;

	reg BYPASS_0_r;
	wire BYPASS_0 = BYPASS_0_r;

	reg [1:0] NVR_0_r;
	wire [1:0] NVR_0 = NVR_0_r;

	reg [3:0] BEN_0_r;
	wire [3:0] BEN_0 = BEN_0_r;

	//reg [3:0] UE_0_r;
	wire [3:0] UE_0 ;

  //reg [3:0] ERRF_0_r;
	wire [3:0] ERRF_0 ;

	//reg bp_clk_0_r;
	//wire bp_clk_0 = bp_clk_0_r;

	reg test_mode_0_r;
	wire test_mode_0 = test_mode_0_r;

	reg mbist_bist_start;
	reg mbist_too_early_flag;
	integer mbist_test_time;

	/* parameter for clock period */
  `ifdef CLK_20
	  parameter clk_period = 20.0;
  `endif

  `ifdef CLK_35
	  parameter clk_period = 35.0;
  `endif

  `ifdef CLK_50
	  parameter clk_period = 50.0;
  `endif


	real compensateForDiagScan = 0.0;

	wire mbist_tb_fail_went_active;

	/* integer ofile; */

	/*mbistctrl_1_con
	  E1 (bist_done,bist_fail_0,bist_hold_l,bist_debugz,diag_scan_out_fail,
		bist_en,bist_clk,bist_rst_l,DOUT_0,A1_0,DIN_0,WEB_0,CEB_0,
		CLK_0,RSTB_0,BYPASS_0,NVR_0,BEN_0,TRIM_0,UE_0,ERRF_0,WRC_0,VLP_0,bp_clk_0,test_mode_0);*/

  MRAM_IP E1(bist_en, bist_clk, bist_rst_l, bist_hold_l,bist_debugz, test_mode_0,
             bist_done, bist_fail_0, diag_scan_out_fail,
             CLK_0, RSTB_0, A1_0, NVR_0, WEB_0, CEB_0, BYPASS_0, BEN_0, DIN_0, VLP_0, TRIM_0, 
             DOUT_0, UE_0, ERRF_0, WRC_0          
  );

		
	/* toggle the clock */
	always
	begin
		#(clk_period/2) bist_clk = ~bist_clk;
  end

	always
	begin
		#(clk_period/2) CLK_0_r = ~CLK_0_r;
  end

///////////////////////////////////////////////BIST TEST MODE///////////////////////////////////////////////
`ifdef BIST_MODE
	initial
	begin
	/* initialize signals */
		mbist_bist_start = 1'b0;
		mbist_too_early_flag = 1'b0;
		bist_hold_l_r = 1;
		bist_debugz_r = 1;
		bist_en_r = 0;
		bist_clk = 0;
		bist_rst_l_r = 1;
		A1_0_r = 17'b00000000000000000;
		DIN_0_r = 32'b00000000000000000000000000000000;
		WEB_0_r = 1;
		CEB_0_r = 1;
		CLK_0_r = 1;
		RSTB_0_r = 1;

    `ifdef TRIM_00
		  TRIM_0_r = 2'b00;
    `endif 
    `ifdef TRIM_01
		  TRIM_0_r = 2'b00;
    `endif 
    `ifdef TRIM_10
		  TRIM_0_r = 2'b00;
    `endif 
    `ifdef TRIM_11
		  TRIM_0_r = 2'b00;
    `endif 

    VLP_0_r  = 0;

    `ifdef ECC_OFF
		  BYPASS_0_r = 1;
    `endif
    `ifdef ECC_ON
			BYPASS_0_r = 0;
    `endif

		NVR_0_r = 2'b00;
		BEN_0_r = 4'b0000;
		//UE_0_r = 4'b0000;
		//ERRF_0_r = 4'b0000;
		//bp_clk_0_r = 0;
		//test_mode_0_r = 0;
		#(clk_period);
  /* rst  */
  RSTB_0_r = 0;
  #(clk_period);
  RSTB_0_r = 1;
	/* test system inputs */
		$display($time,, " Testing system inputs. ");
		#(clk_period/2);

         // Place system inputs to their inactive state
         WEB_0_r <= 1'h1;
         CEB_0_r <= 1'h1;
         CLK_0_r <= 1'h1;
         RSTB_0_r <= 1'h1;

    `ifdef ECC_OFF
		  BYPASS_0_r = 1;
    `endif
    `ifdef ECC_ON
			BYPASS_0_r = 0;
    `endif


         NVR_0_r <= 2'h0;
         BEN_0_r <= 4'h0;
         //UE_0_r <= 4'h0;
         //ERRF_0_r <= 4'h0;
         #(clk_period);
         A1_0_r <= 18'h00000;
         #(clk_period);

         // Memory 0, port 0, operation 'w'
         // Cycle 0
         A1_0_r <= 18'h00000;
         DIN_0_r <= 32'h00000000;
         CEB_0_r <= 1'h0;
         WEB_0_r <= 1'h0;
         CLK_0_r <= 1'h0;
         #(clk_period / 2'h2);
         CLK_0_r <= 1'h1;
         #(clk_period / 2'h2);

         // Place system inputs to their inactive state
         WEB_0_r <= 1'h1;
         CEB_0_r <= 1'h1;
         CLK_0_r <= 1'h0;
         #(clk_period / 2'h2);
         CLK_0_r <= 1'h1;
         #(clk_period / 2'h2);
         A1_0_r <= 18'h00000;
         DIN_0_r <= 32'hX;
         CLK_0_r <= 1'h0;
         #(clk_period / 2'h2);
         CLK_0_r <= 1'h1;
         #(clk_period / 2'h2);

         // Memory 0, port 0, operation 'r'
         // Cycle 0
         A1_0_r <= 18'h00000;
         CEB_0_r <= 1'h0;
         CLK_0_r <= 1'h0;
         #(clk_period / 2'h2);
         CLK_0_r <= 1'h1;
         #(clk_period / 2'h2);

         // Cycle 1
         CLK_0_r <= 1'h0;
         #(clk_period / 2'h2);
         CLK_0_r <= 1'h1;
         #(clk_period / 2'h2);

         // Cycle 2
         CEB_0_r <= 1'h1;
         if (!(DOUT_0 === 32'h00000000))
            $display($time,, 
            " Warning, Read of value failed, port 0 of memory 0"
            );
         CLK_0_r <= 1'h0;
         #(clk_period / 2'h2);
         CLK_0_r <= 1'h1;
         #(clk_period / 2'h2);

         // Place system inputs to their inactive state
         WEB_0_r <= 1'h1;
         CEB_0_r <= 1'h1;
         CLK_0_r <= 1'h1;
         RSTB_0_r <= 1'h1;

    `ifdef ECC_OFF
		  BYPASS_0_r = 1;
    `endif
    `ifdef ECC_ON
			BYPASS_0_r = 0;
    `endif



         NVR_0_r <= 2'h0;
         BEN_0_r <= 4'h0;
         //UE_0_r <= 4'h0;
         //ERRF_0_r <= 4'h0;
         CLK_0_r <= 1'h0;
         #(clk_period / 2'h2);
         CLK_0_r <= 1'h1;
         #(clk_period / 2'h2);
         A1_0_r <= 18'h00000;
         DIN_0_r <= 32'hX;
         CLK_0_r <= 1'h0;
         #(clk_period / 2'h2);
         CLK_0_r <= 1'h1;
         #(clk_period / 2'h2);
		#(clk_period/2)
		#(clk_period/2)
	/* test bist logic */
		$display($time,, " Testing bist logic.");
		mbist_bist_start = 1'b1;
		bist_rst_l_r = 0;
		#(clk_period);
		bist_en_r = 1;
		#(0.9*clk_period);
		bist_rst_l_r = 1;
		#(0.1*clk_period);
		#(clk_period);
		#(8.50*clk_period);
	end

	/* check for stop time */
	always @(posedge bist_clk) begin
		if (mbist_bist_start === 1'b1) begin
			if ($time >= ((4259830+ 30 + 14.50)*clk_period) + compensateForDiagScan ) begin
				if (bist_done !== 1)
					$display($time,, " Error, bist_done did not go high.");
				$display($time,, " Simulation finished.");
				if ( bist_fail_0 === 1'b1 )
					$display($time,, " Error. bist_fail_0 is high at end of test.");
				else if ( bist_fail_0 === 1'bx )
					$display($time,, " Error. bist_fail_0 is UNKNOWN (X) at end of test.");
				else if (bist_fail_0 === 1'bz)
					$display($time,, " Error. bist_fail_0 is HIGHZ at end of test.");
				$finish;
      end
			else if (($time > (14.50 * clk_period)) &&
			         ($time < (mbist_test_time * clk_period))) begin
				if (bist_done !== 0) begin
					if (mbist_too_early_flag === 1'b0) begin
						$display($time,, " Error, bist_done changed too early.");
						mbist_too_early_flag <= 1'b1;
					end
				end
			end
		end
	end
	/* check fail_h bit. */
	always @(bist_fail_0)
	begin
	if (bist_en === 1'b1)begin
		if (bist_fail_0 === 1'b1)
			$display($time,, " Error, bist_fail_0 went high.");
		else if (bist_fail_0 === 1'bx)
			$display($time,, " Error, bist_fail_0 went unknown.");
		else if (bist_fail_0 === 1'bz)
			$display($time,, " Error, bist_fail_0 went high-z.");
	end
	end


   assign mbist_tb_fail_went_active = bist_fail_0;

	always @(mbist_tb_fail_went_active) 
	begin
		if (mbist_tb_fail_went_active == 1'b1) begin 
			compensateForDiagScan = compensateForDiagScan + 8*clk_period + 59*clk_period;
		end
  end
`endif 


`ifdef MEM_MODE

parameter MAIN_DEPTH        = 17  ;
parameter NVR_DEPTH         = 11  ;
parameter DATA_WIDTH        = 32  ;
parameter ECC_WIDTH         = 20  ;
parameter TOTAL_WIDTH       = DATA_WIDTH+ECC_WIDTH  ;
parameter DATA_BYTE_WIDTH   = 8  ;
parameter BEN_WIDTH         = 4   ;
parameter BANK_DEPTH        = 10  ;
parameter NVR_CEB_DEPTH     = NVR_DEPTH-BANK_DEPTH;
parameter MAIN_NUM          = (1<<(MAIN_DEPTH-BANK_DEPTH));
parameter NVR_NUM           = (1<<(NVR_DEPTH-BANK_DEPTH)) ;
parameter MAIN_WORD_NUM     = (1<<MAIN_DEPTH) ;
parameter NVR_WORD_NUM      = (1<<NVR_DEPTH)  ;

initial
  begin
	bist_hold_l_r = 1;
	bist_debugz_r = 1;
	bist_en_r = 0;
	bist_clk = 0;
	bist_rst_l_r = 1;
	A1_0_r = 17'd0;
	DIN_0_r = 32'd0;
	WEB_0_r = 1;
	CEB_0_r = 1;
	CLK_0_r = 0;
	RSTB_0_r = 0;
	
    `ifdef TRIM_00
		  TRIM_0_r = 2'b00;
    `endif 
    `ifdef TRIM_01
		  TRIM_0_r = 2'b00;
    `endif 
    `ifdef TRIM_10
		  TRIM_0_r = 2'b00;
    `endif 
    `ifdef TRIM_11
		  TRIM_0_r = 2'b00;
    `endif 

    `ifdef ECC_OFF
		  BYPASS_0_r = 1;
    `endif
    `ifdef ECC_ON
			BYPASS_0_r = 0;
    `endif


	NVR_0_r = 2'b00;
	BEN_0_r = 4'b1111;
	//test_mode_0_r = 0;
	//bp_clk_0_r = 0;
  VLP_0_r  = 0;

	#(clk_period*2);

    @(negedge CLK_0_r);
    //#(PERIOD)
	RSTB_0_r = 1;
    A1_0_r = 17'h0_0000;

    //main_write_read
	repeat(MAIN_WORD_NUM) begin
      repeat (1<<BEN_WIDTH) begin
        WEB_0_r = 0;
		CEB_0_r = 0;
		DIN_0_r = ($random) %32'hffff_ffff;
        @(negedge CLK_0_r);
        WEB_0_r = 1;
	    CEB_0_r = 0;
		@(negedge CLK_0_r);
        BEN_0_r = ~((~BEN_0_r) + 1);
      end
      A1_0_r = A1_0_r + 1;
    end

    @(negedge CLK_0_r);
    CEB_0_r = 0;
    A1_0_r = 0;
    NVR_0_r[0]= 0;
    NVR_0_r[1]= 1;
    BEN_0_r   = 4'b1111;

    //nvr_write_read
	repeat(NVR_WORD_NUM) begin
      repeat (1<<BEN_WIDTH) begin
        WEB_0_r = 0;
		CEB_0_r = 0;
		DIN_0_r = ($random) %32'hffff_ffff;
        @(negedge CLK_0_r);
        WEB_0_r = 1;
	    CEB_0_r = 0;
        @(negedge CLK_0_r);
        BEN_0_r = ~((~BEN_0_r) + 1);
      end
      A1_0_r = A1_0_r + 1;
    end
    #60 $finish;
  end

`endif




endmodule
