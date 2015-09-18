`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:57:06 08/27/2015
// Design Name:   byte_to_BCD
// Module Name:   A:/Dropbox/University/Computing/COMP3601/AudioController/byte_to_BCD_tbw.v
// Project Name:  AudioController
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: byte_to_BCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module byte_to_BCD_tbw;

	// Inputs
	reg [7:0] byte;

	// Outputs
	wire [11:0] BCD;

	// Instantiate the Unit Under Test (UUT)
	byte_to_BCD uut (
		.byte(byte), 
		.BCD(BCD)
	);

	initial begin
		// Initialize Inputs
		byte = 0;

		// Wait 100 ns for global reset to finish
		#100;
      forever begin
			byte = byte + 1;
			#10;
		end
		// Add stimulus here

	end
      
endmodule

