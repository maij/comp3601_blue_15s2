module audio_player(CLK, PB_PLY, VOL, PB_RST, LEDS, SEGA, SEGD, P,
						  i2c_rst, i2c_scl, i2c_sda, i2c_vcc, i2c_gnd, i2c_beat,
						  MemOe, MemWr, FlashRp, FlashCS, RamCS, ADDR,
						  EppAstb, EppDstb, EppWr, FlashStSts, RamWait, EppWait,
						  RamAdv, RamClk, RamCre, RamCS, RamLB, RamUB, EppDB, MemDB
						  );
	input 			CLK; 	// 100MHz clock input
	// I/O
	// Switches
	input 		[3:0]  VOL;		// 4-bit volume
	// Push buttons
	input 			 PB_RST;
	input 			 PB_PLY; 	// Play command input from push-button
	
	//i2c stuff 
	input 		i2c_rst;         //i2c reset
	inout 		i2c_scl;			 //serial clock line
	inout 		i2c_sda;         //serial data line
	output 		i2c_vcc;        //constant 1
	output 		i2c_gnd;        //constant 0 
	output wire i2c_beat;  //beat detection
	
	// 7-Seg Display
	output 	[3:0] 	SEGA; 	// Display-select (common anode) output
	output 	[7:0] 	SEGD; 	// Display-pattern output
	// LEDs
	output   [7:0]		LEDS;		// LEDs to display what is being retrieved from memory.
	output 					P;		// Square wave output
	 
	// Ram Access
	inout    [15:0]  MemDB;
	output   [23:1] 	ADDR; 	// 23-bit address sent to flash memory
	
	input  EppAstb;
	input  EppDstb;    
	input  EppWr;     
	input  FlashStSts;
	input  RamWait;  
	output EppWait; 
	output FlashCS; 
	output FlashRp;
	output MemOe;  
	output MemWr;  
	output RamAdv; 
	output RamClk; 
	output RamCre; 
	output RamCS;  
	output RamLB;  
	output RamUB;
	inout [7:0] EppDB;
							
	wire  [1:0] MODE;
	wire  [3:0] NOTE;
	wire  [5:0] TONE;
	wire [15:0] DATA;
	wire        DONE;
	wire 	  END_SONG;
	wire 			  EN;

	parameter
		NORMAL   = 2'b00,
		STACCATO = 2'b01,
		SLURRED  = 2'b10,
		BPM_COMM = 2'b11;
	
	reg PLAY;
	reg [7:0] DEFAULT_BPM;
	reg LATCH_PB_PLY;
	
	// I2C Stuff
	wire signed [15:0] accel_z; //Raw data coming out of the i2c bus (not always valid)
	reg [15:0] accel_out;       //Captured data from accel_z when the valid bit goes high. Should always be valid
	wire valid; 					 //After a successful read from the z-register this will be high 
	
	//BPM calculation stuff 
	wire [7:0] BPM;			    //Current BPM of playback
	wire clk_slow;					 //100kHz clock for BPM calculation and stuff
	
	initial begin
		DEFAULT_BPM  <= 8'd80;
		PLAY <= 0;
		LATCH_PB_PLY <= 0;
	end
	
	
	always @(posedge CLK) begin
		// Toggle only on rising edge/ falling edge
		if (PB_PLY && ~LATCH_PB_PLY)
			PLAY <= ~PLAY;
		
		LATCH_PB_PLY <= PB_PLY;
	end
	
	//Capture the i2c z-accveleration output when it's valid
	always @ (posedge valid) begin
		accel_out <= accel_z; 
	end
	
	// Update BPM with the falling edge of DONE to allow for all the bits to be loaded from RAM
	always @ (negedge DONE) begin
		if (PLAY && (DATA[15:14] == BPM_COMM))
			DEFAULT_BPM <= DATA[7:0];
	end
	// Grabbing everything out of the DATA register
	assign MODE 	 = (DATA[15:14] == BPM_COMM) ? NORMAL :  DATA[15:14];
	assign NOTE 	 = (DATA[15:14] == BPM_COMM) ? 4'b0	 :  DATA[3:0];
	assign TONE 	 = DATA[13:8];
	assign END_SONG = PLAY && (DATA[15:14] == BPM_COMM) && (DATA[7:0] == 0);
	
	// assign LEDS = DATA[15:8];  //High Bytes (BPM Command/ Tone)
	//assign LEDS = DATA[7:0]; //Low Bytes (BPM/ Duration)
	assign LEDS[7:0] = {4'h0, VOL[3:0]};
	// Power for the Gyro
	assign i2c_gnd = 0; 
	assign i2c_vcc = 1; 

	MPU6050 mpu (
		.clk(CLK), 
		.rst(i2c_rst), 
		.scl(i2c_scl), 
		.sda(i2c_sda), 
		.accel_z(accel_z), 
		.valid(valid), 
		.error(error)
		);

	//double_thermometer LED_display (
	//	.accel(accel_out), 
	//	.out(LEDS)
	//	);

	beatmaker bm (
		 .clk(CLK), 
		 .accel(accel_out), 
		 .beat(i2c_beat)
		 );
		 
	clk_divider clkdiv (
		 .clkin(CLK), 
		 .clkout(clk_slow)
		 );
		 
	bpmcalculator bpmcalc (
		.clk(clk_slow), 
		.beat(i2c_beat), 
		.default_bpm(DEFAULT_BPM),
		.bpm_out(BPM)
	);
	memory_controller memory_ctrl_blk (.clk(CLK), .EppAstb(EppAstb), .EppDstb(EppDstb), .EppWr(EppWr), .FlashStSts(FlashStSts), 
				     .RamWait(RamWait), .EppWait(EppWait), .FlashCS(FlashCS), .FlashRp(FlashRp), .MemAdr(ADDR), .MemOe(MemOe),
					  .MemWr(MemWr), .RamAdv(RamAdv), .RamClk(RamClk), .RamCre(RamCre), .RamCS(RamCS), .RamLB(RamLB), .RamUB(RamUB), 
					  .MemDB(MemDB), .EppDB(EppDB), .BTN(DONE & PLAY), .dataOut(DATA), .Reset(PB_RST ));
	timing_controller timing_ctrl_blk (CLK, BPM, MODE, NOTE, PLAY, EN, DONE);
	display  disp_blk (CLK, BPM, PLAY, SEGA, SEGD);
	tone     tone_blk (CLK, TONE, EN & PLAY ,VOL[3:0], P);
	
endmodule
