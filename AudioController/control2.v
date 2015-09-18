module control2 (CLK, PB_GO, DATA, TONE, DURATION, OE, WE, RP, CE, MTCE, ADDR);
	input 			CLK; 		// 100MHz clock input
	input 			PB_GO; 		// Play command input from push-button
	input 	[15:0] 	DATA; 		// 16-bit data received from flash memory
	output reg	[3:0] 	TONE; 		// 4-bit tone code output to tone generator and display
	output reg	[3:0] 	DURATION; 	// 4-bit duration code output to display
	output reg 	[23:1] 	ADDR; 		// 23-bit address sent to flash memory
	output 			OE; 		// Flash Output Enable
	output 			WE; 		// Flash Write Enable
	output 			CE; 		// Flash Chip Enable
	output 			RP; 		// Flash Reset/Power-down
	output 			MTCE; 		// RAM Chip Enable
	
	
	parameter 		
				PERIOD_0  = 28'b0,
				PERIOD_1_8  = 28'd12500000,
				PERIOD_1_4  = 28'd25000000,
				PERIOD_3_8  = 28'd37500000,
				PERIOD_1_2  = 28'd50000000,
				PERIOD_3_4  = 28'd75000000,
				PERIOD_4_4  = 28'd100000000,
				PERIOD_8_4  = 28'd200000000,
				PERIOD_1_32 = 28'd3125000,
				PERIOD_1_8A = 28'd9375000,
				PERIOD_1_4A = 28'd21875000,
				PERIOD_3_8A = 28'd34375000,
				PERIOD_1_2A = 28'd46875000,
				PERIOD_3_4A = 28'd71875000,
				PERIOD_4_4A = 28'd96875000,
				PERIOD_8_4A = 28'd196875000;
				
	
	assign WE = 1'b1;
	assign OE = 1'b0;
	assign CE = 1'b0;
	assign RP = 1'b1;
	assign MTCE = 1'b1;

	// Your code goes here.
	reg [23:1] counter;
	reg [27:0] period;
	reg start;
	reg control;
	
	initial begin
		counter = 23'b0;
		start = 1'b0;
		control = 1'b0;
		period = 28'b0;
	end
	
	always @(posedge CLK) begin
		
		if (PB_GO) begin
			start = 1'b1;
			//starting from the first address
			counter = 23'b0;
		end
		
		if (start) begin
			//load the address of counter
			ADDR = counter;
			//reset so this only triggers once per note
			start = 1'b0;
			//get data at that address
			TONE = DATA[7:4];
			DURATION = DATA[3:0];
			//address counter is incremented for next time
			counter = counter + 1;
			//start counting the duration out of the note
			control = 1'b1;
			//each note should be played from the start
			period = 28'b0;
		end
		
		//need to wait for DURATION to then play the next tone
		if (control) begin
			period = period + 1;
		end
		//taken from control.v and altered for new registers
		//if the period counter exceeds the parameter, then stop counting, reset the counter and start listening for the next data
		//NOTE: Should I stop listening?
		//EDIT: I think when period = 4'h0 I should stop (EOF reached) -# Subtlety below  #-
		case(DURATION)
			4'h0: if(period >= PERIOD_0)    begin control = 1'b0; period = 28'b0; start = 1'b0; end
			4'h1: if(period >= PERIOD_1_8)  begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'h2: if(period >= PERIOD_1_4)  begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'h3: if(period >= PERIOD_3_8)  begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'h4: if(period >= PERIOD_1_2)  begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'h5: if(period >= PERIOD_3_4)  begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'h6: if(period >= PERIOD_4_4)  begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'h7: if(period >= PERIOD_8_4)  begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'h8: if(period >= PERIOD_1_32) begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'h9: if(period >= PERIOD_1_8A) begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'hA: if(period >= PERIOD_1_4A) begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'hB: if(period >= PERIOD_3_8A) begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'hC: if(period >= PERIOD_1_2A) begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'hD: if(period >= PERIOD_3_4A) begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'hE: if(period >= PERIOD_4_4A) begin control = 1'b0; period = 28'b0; start = 1'b1; end
			4'hF: if(period >= PERIOD_8_4A) begin control = 1'b0; period = 28'b0; start = 1'b1; end
		endcase
		
		
	end

endmodule
