module control (CLK, SW_TONE, SW_DURATION, PB_GO, TONE, DURATION);
	input 				CLK; 			// 100MHz clock input
	input 	[3:0] 	SW_TONE; 		// 4-bit tone input from switches
	input 	[3:0] 	SW_DURATION; 	// 4-bit duration input from switches
	input 				PB_GO; 			// Play command input from push-button
	output reg 	[3:0] 	TONE; 		// 4-bit tone code output to tone generator and display
	output reg 	[3:0] 	DURATION; 	// 4-bit duration code output to display
	
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
				
	reg [27:0] counter;
	reg control;
	//initialising all variables to 0
	initial begin
		counter = 28'b0;
		control = 1'b0;
		TONE = 4'h0;
		DURATION = 4'h0;
	end
	
	always @(posedge CLK) begin
		if (PB_GO) begin
			DURATION = SW_DURATION;
			TONE = SW_TONE;
			counter = 28'b0;
			//start counting
			control = 1'b1;
		end
		//controls whether the count increases or not, to prevent overflow
		if (control) counter = counter + 1;
		
		case(DURATION)
			4'h0: if(counter >= PERIOD_0)    begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h1: if(counter >= PERIOD_1_8)  begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h2: if(counter >= PERIOD_1_4)  begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h3: if(counter >= PERIOD_3_8)  begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h4: if(counter >= PERIOD_1_2)  begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h5: if(counter >= PERIOD_3_4)  begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h6: if(counter >= PERIOD_4_4)  begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h7: if(counter >= PERIOD_8_4)  begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h8: if(counter >= PERIOD_1_32) begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'h9: if(counter >= PERIOD_1_8A) begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'hA: if(counter >= PERIOD_1_4A) begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'hB: if(counter >= PERIOD_3_8A) begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'hC: if(counter >= PERIOD_1_2A) begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'hD: if(counter >= PERIOD_3_4A) begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'hE: if(counter >= PERIOD_4_4A) begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			4'hF: if(counter >= PERIOD_8_4A) begin TONE = 4'h0; DURATION = 4'h0; control = 1'b0; end
			endcase
	end
endmodule
