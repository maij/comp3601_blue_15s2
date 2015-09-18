`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:00:04 08/27/2015
// Design Name:   audio_controller
// Module Name:   A:/Dropbox/University/Computing/COMP3601/AudioController/audio_controller_tbw.v
// Project Name:  AudioController
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: audio_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module audio_controller_tbw;

	// Inputs
	reg CLK;
	reg [1:0] MODE;
	reg [3:0] NOTE;
	reg [7:0] BPM;
	
	// Outputs
	wire EN;
	wire [12:0] counter;
	// Instantiate the Unit Under Test (UUT)
	audio_controller uut (
		.CLK(CLK), 
		.BPM(BPM), 
		.MODE(MODE),
		.NOTE(NOTE),
		//.counter(counter),
		.EN(EN)
	);

	initial begin
		// Initialize Inputs
		CLK  = 0;
		BPM  = 8'd80;
		MODE = 2'b01;
		NOTE = 4'd7;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever begin
			CLK = ~CLK;
			#10;
		end
	end
      
endmodule

