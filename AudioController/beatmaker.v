`timescale 1ns / 1ps

//Turns the acceleration into a 1-bit beat signal

module beatmaker(
	 input clk,
    input signed [15:0] accel,
    output reg beat
    );
	 
	reg signed [15:0] prev_accel; 
	
	initial begin
		beat <= 0; 
		prev_accel <= 0; 
	end
		 
	always @(posedge clk) begin 
		if ( (accel > 10000 && prev_accel < 10000) || (accel < 10000 && prev_accel > 10000) ) begin
			beat = ~beat;
			prev_accel = accel;
		end else begin
			prev_accel = accel;
		end
	end
	
endmodule
