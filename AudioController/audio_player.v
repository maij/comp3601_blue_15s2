module audio_player(CLK, PB_PLY, VOL, PB_RST, LEDS, SEGA, SEGD, P,
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
	reg [7:0] BPM;
	reg LATCH_PB_PLY;
	
	initial begin
		BPM  <= 8'd80;
		PLAY <= 0;
		LATCH_PB_PLY <= 0;
	end
	
	always @(posedge CLK) begin
		// Toggle only on rising edge/ falling edge
		if (PB_PLY && ~LATCH_PB_PLY)
			PLAY <= ~PLAY;
		
		LATCH_PB_PLY <= PB_PLY;
	end
	
	// Update BPM with the falling edge of DONE to allow for all the bits to be loaded from RAM
	always @ (negedge DONE) begin
		if (PLAY && (DATA[15:14] == BPM_COMM))
			BPM <= DATA[7:0];
	// else, update from motion_sensor
	end
	// Grabbing everything out of the DATA register
	assign MODE 	 = (DATA[15:14] == BPM_COMM) ? NORMAL :  DATA[15:14];
	assign NOTE 	 = (DATA[15:14] == BPM_COMM) ? 4'b0	 :  DATA[3:0];
	assign TONE 	 = DATA[13:8];
	assign END_SONG = PLAY && (DATA[15:14] == BPM_COMM) && (DATA[7:0] == 0);
	
	// assign LEDS = DATA[15:8];  //High Bytes (BPM Command/ Tone)
	assign LEDS = DATA[7:0]; //Low Bytes (BPM/ Duration)
	memory_controller memory_ctrl_blk (.clk(CLK), .EppAstb(EppAstb), .EppDstb(EppDstb), .EppWr(EppWr), .FlashStSts(FlashStSts), 
				     .RamWait(RamWait), .EppWait(EppWait), .FlashCS(FlashCS), .FlashRp(FlashRp), .MemAdr(ADDR), .MemOe(MemOe),
					  .MemWr(MemWr), .RamAdv(RamAdv), .RamClk(RamClk), .RamCre(RamCre), .RamCS(RamCS), .RamLB(RamLB), .RamUB(RamUB), 
					  .MemDB(MemDB), .EppDB(EppDB), .BTN(DONE & PLAY), .dataOut(DATA), .Reset(PB_RST || END_SONG));
	timing_controller timing_ctrl_blk (CLK, BPM, MODE, NOTE, PLAY, EN, DONE);
	display  disp_blk (CLK, BPM, PLAY, SEGA, SEGD);
	// VOL * PLAY disables audio output when paused
	tone     tone_blk (CLK, TONE, EN & PLAY ,VOL, P);
	
endmodule
