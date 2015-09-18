module pwm (input CLK, input [7:0] duty, input [3:0] VOL, output P);
	reg [11:0] counter;
	//sin_lut U1 (lookup_value, duty);
	// EN == 0, Duty = 0%
	reg [7:0] latched_comp;
	assign P = (counter[11:0] < latched_comp[7:0]*VOL) ? 1 : 0;
	// Increment counter for duty comparison
	initial begin
		counter <= 0;
		latched_comp <= 0;
	end
	
	always @ (posedge CLK) begin
		counter <= counter + 1;
		if (counter == 12'hFFF) begin
			latched_comp <= duty;
		end
	end	
endmodule
