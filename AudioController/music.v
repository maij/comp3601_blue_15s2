module music(CLK, SW_TONE, SW_DURATION, PB_GO, SEGA, SEGD, P);
	input 				CLK; 			// 100MHz clock input
	input 	[3:0] 	SW_TONE; 		// 4-bit tone input from switches
	input 	[3:0] 	SW_DURATION; 	// 4-bit duration input from switches
	input 				PB_GO; 			// Play command input from push-button
	output 	[3:0] 	SEGA; 			// Display-select (common anode) output
	output 	[7:0] 	SEGD; 			// Display-pattern output
	output 			P; 				// Square wave output
	
	wire 	[3:0] 	TONE;
	wire 	[3:0] 	DURATION;
	
	control U1 (CLK, SW_TONE, SW_DURATION, PB_GO, TONE, DURATION);
	display U2 (CLK, TONE, DURATION, SEGA, SEGD);
	tone    U3 (CLK, TONE, P);
	
endmodule
