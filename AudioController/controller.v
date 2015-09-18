module audio_player(CLK, BPM_UP, BPM_DOWN, PB_GO, /*TONE,MODE*/, RST, LEDS, SEGA, SEGD, P,
						  DATA, MemOe, MemWr, FlashRp, FlashCS, RamCS, ADDR,
						  EppAstb, EppDstb, EppWr, FlashStSts, RamWait, EppWait,
						  RamAdv, RamClk, RamCre, RamCS, RamLB, RamUB, EppDB,
						  );
	input 			CLK; 	// 100MHz clock input
	// I/O
	// Push buttons
	input 			 BPM_UP;
	input 		  BPM_DOWN;
	input 				 RST;
	input 			  PB_GO; 	// Play command input from push-button
	// 7-Seg Display
	output 	[3:0] 	SEGA; 	// Display-select (common anode) output
	output 	[7:0] 	SEGD; 	// Display-pattern output
	// LEDs
	output   [7:0]		LEDS;		// LEDs to display what is being retrieved from memory.
	output 					P;		// Square wave output
	 
	// Ram Access
	inout    [15:0] 	DATA;		// 16-bit data received from flash memory	
	output reg 	[23:1] 	ADDR; 	// 23-bit address sent to flash memory
	
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
								  
	wire [1:0] MODE;
	wire  [3:0] NOTE;
	wire [5:0] TONE;
	wire  [3:0] VOL;
	wire DONE;
	parameter
		NORMAL   = 2'b00,
		STACCATO = 2'b01,
		SLURRED  = 2'b10,
		BPM_COMM = 2'b11;
	
	reg START;
	reg [7:0] BPM;
	
	initial begin
		BPM   <= 8'd80;
		START <= 0;
	end
	
	always @(posedge PB_GO) begin
		START <= 1;
	end
	
	// Update BPM
	always @ (CLK) begin
		if (START && (DATA[7:6] == 2'b11))
			BPM <= DATA[7:0];
		// else, update from motion_sensor
	end
	// Grabbing everything out of the DATA register
	// TESTING IF THE 16 bits are coming out in a different order
	assign MODE = (DATA[7:6] == BPM_COMM) ? NORMAL : DATA[7:6];
	assign NOTE = (DATA[7:6] == BPM_COMM) ? 4'b0   : DATA[12:8];
	assign TONE = DATA[5:0];
	//assign MODE = (DATA[15:14] == BPM_COMM) ? NORMAL :  DATA[15:14];
	//assign NOTE = (DATA[15:14] == BPM_COMM) ? 4'b0	 :  DATA[4:0];
	//assign TONE = DATA[13:8];
	//assign MODE = (DATA[14:15] == BPM_COMM) ? NORMAL :  DATA[14:15];
	//assign NOTE = (DATA[14:15] == BPM_COMM) ? 4'b0	 :  DATA[0:4];
	//assign TONE = DATA[8:13];
	
	DemoWithMemCfg memory_ctrl_blk (.clk(CLK), .EppAstb(EppAstb), .EppDstb(EppDstb), .EppWr(EppWr), .FlashStSts(FlashStSts), 
				     .RamWait(RamWait), .EppWait(EppWait), .FlashCS(FlashCS), .FlashRp(FlashRp), .MemAdr(ADDR), .MemOe(MemOe),
					  .MemWr(MemWr), .RamAdv(RamAdv), .RamClk(RamClk), .RamCre(RamCre), .RamCS(RamCS), .RamLB(RamLB), .RamUB(RamUB), 
					  .MemDB(DATA), .EppDB(EppDB), .BTN(DONE), .led(LEDS));
	timing_controller timing_ctrl_blk (CLK, BPM, MODE, NOTE, START, VOL, DONE);
	display  disp_blk (CLK, BPM, SEGA, SEGD);
	tone     tone_blk (CLK, TONE, VOL, P);
	
	//always @ (posedge RST or posedge BPM_UP or posedge BPM_DOWN) begin
	//	if (RST) 
	//		BPM <= 80;
	//	else if (BPM_UP)
	//		BPM <= BPM + 10;
	//	else if (BPM_DOWN) 
	//		BPM <= BPM - 10;
	//end

endmodule
