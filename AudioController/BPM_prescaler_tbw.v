`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:53:01 08/27/2015
// Design Name:   BPM_prescaler
// Module Name:   A:/Dropbox/University/Computing/COMP3601/AudioController/BPM_prescaler_tbw.v
// Project Name:  AudioController
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BPM_prescaler
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BPM_prescaler_tbw;

	// Inputs
	reg CLK;
	reg [7:0] BPM;
	integer i;
	// Outputs
	wire slowCLK;
	wire [19:0] scaler;
	wire [19:0] counter;

	// Instantiate the Unit Under Test (UUT)
	BPM_prescaler uut (
		.CLK(CLK), 
		.BPM(BPM), 
		.slowCLK(slowCLK),
		.counter(counter),
		.scaler(scaler)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		BPM = 80;
		i = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever begin
			CLK = ~CLK;
			i = i + 1;
			if (i == 30000) begin
				BPM = BPM + 1;
				i = 0;
			end
			#1;
		end
	end
      
endmodule

