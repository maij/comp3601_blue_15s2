module tone(CLK, TONE, VOL, P);
	input 				 CLK;		// 100MHz clock input
	input 		[5:0] TONE; 	// 6-bit tone code
	input			[3:0]  VOL;		// Enable Pin
	output 					P;		// PWM Square Wave
	reg [5:0] lookup_value;		// 6-bit sin-wave lookup value
	wire [13:0] 	 period;			// 14-bit value to count up to
	wire [7:0] 	  duty_cmp;
	reg [13:0] 		counter;			// 14-bit counter
	
	// PWM Output module
	// Note that enable is modified to include TONE not being a rest note
	// This prevents the pesky ticking noise when the tone was 0.
	pwm pwm_block (CLK, duty_cmp, VOL[3:0]*(TONE != 6'd0), P);
	tone_lut64 tone_lut_block (TONE, period);
	sin_lut sin_lut_block (lookup_value, duty_cmp);
	
	parameter counter_max = 14'd11945;
	initial begin
		counter <= 0;
	end
	always @(posedge CLK) begin
		//increment the counter at each clock cycle
		if (VOL) begin
			counter <= counter + 1;
			//makes sure the counter resets if it excedes max value, if switching to a higher tone
			if (counter > counter_max) counter <= 0;
			if (counter >= period) begin
				counter <= 14'd0;
				lookup_value <= lookup_value + 1;
			end	
		end
	end

endmodule
