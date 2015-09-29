module display(CLK, BPM, PLAY, SEGA, SEGD);
	input 			CLK;		// 100MHz clock input
	input [7:0]		BPM;		// 8-bit BPM value
	//input 	[5:0] 	TONE; 		// 6-bit tone code
	//input 	[3:0] 	DURATION; 	// 4-bit duration code
	input 		  PLAY;		// Play/Pause Input
	output reg [3:0] 	SEGA; 		// Display-select (common anode) output
	output [7:0] 	SEGD; 		   // Display-pattern output
	
	wire [11:0] BCD;
	
	reg [3:0]			CURRENT_DIG;// Which BCD digit is currently displaying
	
	//assign BCD = 12'h123;
	byte_to_BCD btb_blk (BPM, BCD);
	bcdtoseg seg_disp_blk (1'b1, 1'b1, CURRENT_DIG[3], CURRENT_DIG[2], CURRENT_DIG[1], CURRENT_DIG[0], 1'b1, /*unconnected*/
				, SEGD[7], SEGD[6], SEGD[5], SEGD[4], SEGD[3], SEGD[2], SEGD[1]);
	// Turn decimal point off
	assign SEGD[0] = 1;
	
	reg [16:0] waveCount;

	parameter
		KHZ_WAVE = 17'd100000, // The full period of a 1kHz wave with 100MHz clock
		
		DISP_D0  = ~4'b0001,
		DISP_D1  = ~4'b0010,
		DISP_D2  = ~4'b0100,
		DISP_D3  = ~4'b1000,
		DISP_OFF = ~4'b0000;
		
	initial begin
		waveCount = 0;
		// OFF
		SEGA = ~4'h0;
		CURRENT_DIG[3:0] = 4'h0;
	end

	always @(posedge CLK) begin
		
		//increment waveCount to use as 1KHz wave
		waveCount = waveCount + 1;
		//increment the counter to count up to duration
		//active contains state of whether you've finished the note or not
		
		//selecting the digit to display
		// TODO: Display state on the first digit, e.g. P for paused
	if (waveCount < KHZ_WAVE/4) begin
			if (~PLAY)  begin
				SEGA = DISP_D0;
				CURRENT_DIG = 4'hF;
			end else begin
				SEGA = DISP_OFF;
				CURRENT_DIG = 4'd0;
			end
		end else if (waveCount < KHZ_WAVE/2) begin
			SEGA = DISP_D1;
			CURRENT_DIG = BCD[11:8];
		end else if (waveCount < KHZ_WAVE*3/4) begin
			SEGA = DISP_D2;
			CURRENT_DIG = BCD[7:4];
		end else if (waveCount < KHZ_WAVE)begin
			SEGA = DISP_D3;
			CURRENT_DIG = BCD[3:0];		
		end else 
			waveCount = 0;
	end
	
endmodule
