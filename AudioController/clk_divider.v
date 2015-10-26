`timescale 1ns / 1ps

//Divide 100MHz clock to get 100KHz clock. 

module clk_divider(
    input clkin,
    output reg clkout
    );

	reg [15:0] counter = 0; 
	
	initial clkout = 0; 

	always @(posedge clkin) begin 
		if (counter >= 500) begin 
			counter <= 0; 
			clkout  <= ~clkout; 
		end else begin 
			counter <= counter + 1; 
		end
	end

endmodule
