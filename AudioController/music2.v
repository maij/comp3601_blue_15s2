module music2(CLK, DATA, OE, WE, RP, CE, MTCE, ADDR, PB_GO, SEGA, SEGD, P);
	input 			CLK; 	// 100MHz clock input
	input 	[15:0] 	DATA;	// 16-bit data received from flash memory
	input 			PB_GO; 	// Play command input from push-button
	output 	[3:0] 	SEGA; 	// Display-select (common anode) output
	output 	[7:0] 	SEGD; 	// Display-pattern output
	output 	[23:1] 	ADDR; 	// 23-bit address sent to flash memory
	output 			P; 		// Square wave output
	output 			OE; 	// Flash Output Enable
	output 			WE; 	// Flash Write Enable
	output 			CE; 	// Flash Chip Enable
	output 			RP; 	// Flash Reset/Power-down
	output 			MTCE; 	// RAM Chip Enable
	
	wire 	[3:0] 	TONE;
	wire 	[3:0] 	DURATION;
	
	control2 U1 (CLK, PB_GO, DATA, TONE, DURATION, OE, WE, RP, CE, MTCE, ADDR);
	display  U2 (CLK, TONE, DURATION, SEGA, SEGD);
	tone     U3 (CLK, TONE, P);
	
endmodule