`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:54:12 08/27/2015
// Design Name:   display
// Module Name:   A:/Dropbox/University/Computing/COMP3601/AudioController/display_tbw.v
// Project Name:  AudioController
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: display
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module display_tbw;

	// Inputs
	reg CLK;
	reg [7:0] BPM;

	// Outputs
	wire [3:0] SEGA;
	wire [7:0] SEGD;

	// Instantiate the Unit Under Test (UUT)
	display uut (
		.CLK(CLK), 
		.BPM(BPM), 
		.SEGA(SEGA), 
		.SEGD(SEGD)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		BPM = 12'h123;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever begin
			CLK = ~CLK;
			BPM = BPM + 1;
			#1;
		end
	end
      
endmodule

