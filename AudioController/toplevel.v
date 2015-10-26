`timescale 1ns / 1ps

module toplevel(

	//i2c stuff 
	input clk,         //100Mhz
	input rst,         //i2c reset
	inout scl,			 //serial clock line
	inout sda,         //serial data line
	output vcc,        //constant 1
	output gnd,        //constant 0 
	output wire beat,  //beat detection
	output [7:0] LED,  //motion tracking 
	
	//playback stuff 
	input PB_RST,      //playback reset
	input PB_PLY, 	    // Play command input from push-button
	input [3:0]  VOL,	 // 4-bit volume
	output P,		    // Square wave output
	output [3:0] SEGA, //BPM display
	output [7:0] SEGD, //BPM display
	
	//RAM stuff 
	inout    [15:0]  MemDB,
	output   [23:1] 	ADDR, 	// 23-bit address sent to flash memory
	input  EppAstb,
	input  EppDstb,    
	input  EppWr,     
	input  FlashStSts,
	input  RamWait,  
	output EppWait, 
	output FlashCS, 
	output FlashRp,
	output MemOe,  
	output MemWr,  
	output RamAdv, 
	output RamClk, 
	output RamCre, 
	output RamCS,  
	output RamLB,  
	output RamUB,
	inout [7:0] EppDB
	);
	
	parameter
		NORMAL   = 2'b00,
		STACCATO = 2'b01,
		SLURRED  = 2'b10,
		BPM_COMM = 2'b11;

	//durr
	assign gnd = 0; 
	assign vcc = 1; 

	//i2c stuff 
	wire signed [15:0] accel_z; //Raw data coming out of the i2c bus (not always valid)
	reg [15:0] accel_out;       //Captured data from accel_z when the valid bit goes high. Should always be valid
	wire valid; 					 //After a successful read from the z-register this will be high 
	
	//BPM calculation stuff 
	wire [7:0] BPM;			    //Current BPM of playback
	wire clk_slow;					 //100kHz clock for BPM calculation and stuff
	
	//Music playback stuff 
	wire  [1:0] MODE;   // normal / staccato / slurred
	wire  [3:0] NOTE;	  // length of the tone
	wire  [5:0] TONE;	  // frequency of the tone
	wire [15:0] DATA;	  // raw music data being read from the music file
	wire        DONE;   
	wire 	  END_SONG;
	wire 			  EN;
	reg PLAY;
	reg [7:0] DEFAULT_BPM; //BPM stated in the music file
	reg LATCH_PB_PLY;      
	
	initial begin
		DEFAULT_BPM  <= 8'd80;
		PLAY <= 0;
		LATCH_PB_PLY <= 0;
	end
	
	always @(posedge clk) begin
		// Toggle only on rising edge/ falling edge
		if (PB_PLY && ~LATCH_PB_PLY)
			PLAY <= ~PLAY;
		LATCH_PB_PLY <= PB_PLY;
	end
	
	//Capture the i2c z-accveleration output when it's valid
	always @ (posedge valid) begin
		accel_out <= accel_z; 
	end
			
	// TODO
	// Update the default BPM with the falling edge of DONE to allow for all the bits to be loaded from RAM
	// This always reads the wrong byte for me (ie. 192 instead of 100). Why?? -Hugh 
	/*bv
	always @ (negedge DONE) begin
		if (PLAY && (DATA[15:8] == 8'd192))
			DEFAULT_BPM <= DATA[7:0];
	end
	*/
	
	// Grabbing everything out of the DATA register
	assign MODE 	 = (DATA[15:14] == BPM_COMM) ? NORMAL :  DATA[15:14];
	assign NOTE 	 = (DATA[15:14] == BPM_COMM) ? 4'b0	 :  DATA[3:0];
	assign TONE 	 = DATA[13:8];
	assign END_SONG = PLAY && (DATA[15:14] == BPM_COMM) && (DATA[7:0] == 0);
	
	// Using LEDs for motion tracking / beat signal at the moment
	// assign LED = DATA[15:8];  //High Bytes (BPM Command/ Tone)
	// assign LED = DATA[7:0]; //Low Bytes (BPM/ Duration)

	MPU6050 mpu (
		.clk(clk), 
		.rst(rst), 
		.scl(scl), 
		.sda(sda), 
		.accel_z(accel_z), 
		.valid(valid), 
		.error(error)
		);

	double_thermometer LED_display (
		.accel(accel_out), 
		.out(LED)
		);

	beatmaker bm (
		 .clk(clk), 
		 .accel(accel_out), 
		 .beat(beat)
		 );
		 
	clk_divider clkdiv (
		 .clkin(clk), 
		 .clkout(clk_slow)
		 );
		 
	bpmcalculator bpmcalc (
		.clk(clk_slow), 
		.beat(beat), 
		.default_bpm(DEFAULT_BPM),
		.bpm_out(BPM)
	);

	memory_controller memory_ctrl_blk (.clk(clk), .EppAstb(EppAstb), .EppDstb(EppDstb), .EppWr(EppWr), .FlashStSts(FlashStSts), 
				     .RamWait(RamWait), .EppWait(EppWait), .FlashCS(FlashCS), .FlashRp(FlashRp), .MemAdr(ADDR), .MemOe(MemOe),
					  .MemWr(MemWr), .RamAdv(RamAdv), .RamClk(RamClk), .RamCre(RamCre), .RamCS(RamCS), .RamLB(RamLB), .RamUB(RamUB), 
					  .MemDB(MemDB), .EppDB(EppDB), .BTN(DONE & PLAY), .dataOut(DATA), .Reset(PB_RST || END_SONG));
					  
	timing_controller timing_ctrl_blk (clk, BPM, MODE, NOTE, PLAY, EN, DONE);
	
	display  disp_blk (clk, BPM, PLAY, SEGA, SEGD);
	
	tone     tone_blk (clk, TONE, EN & PLAY ,VOL, P);
	
endmodule
