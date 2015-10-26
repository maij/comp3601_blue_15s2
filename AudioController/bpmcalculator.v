`timescale 1ns / 1ps

// Measures the time between beats, spits out a 8-bit BPM (30-255)
// Keeps a moving average over the last four beat intervals.  
// Why four? Because it makes the division simple (right shift by 2) when calculating the average, 
// and eight wouldn't be responsive enough. 
// Four is a good compromise between smoothness and responsiveness. 
// If no beats are measured for some time (slower than 30BPM), the default BPM will start to feed into the buffer. 
// After four timeouts, the BPM will become the default BPM. 
// Beats are edge-sensitive and debounced - any consecutive beat edges faster than 255 BPM will be ignored. 

module bpmcalculator(
	 input wire clk,  		 	 	 //100 kHz clock (same as I2C clock) 
    input wire beat, 				 //Beat signal from I2C module. 
	 input wire [7:0] default_bpm, //Default BPM to use if no beats are detected
    output wire [7:0] bpm_out  	 //Output BPM (20-200) 	 
    );
		
	//Any intervals shorter than this (255 BPM) will be ignored. 
	// (255 BPM = 0.23529s interval = 23529 clocks at 100 kHz) 
	parameter SMALLEST_ALLOWABLE_INTERVAL = 32'd23529;
	
	//If the counter is longer than this (30 BPM), we revert to the default BPM 
	// (30BPM = 2s interval = 200 000 clocks at 100 kHz)
	parameter LONGEST_ALLOWABLE_INTERVAL = 32'd200000;
	
	//Some sensible BPM of 80BPM to initially fill the buffer 
	parameter STARTING_BPM = 8'd80; 
	
	//Records the time intervals between beats 
	reg [31:0] counter; 
	
	//The last-counted interval converted to BPM 
	wire [7:0] counted_bpm; 
	
	//Holds the previous 4 BPMs. 
	reg [7:0] buffer[0:3]; 
	
	//The buffer is circular - keep track of the oldest value (the one to be evicted next) 
	reg [1:0] oldest_index; 
	
	//Sum of the past 4 BPMs. 
	//To calculate the new sum, subtract the oldest BPM and add the newest. 
	reg [9:0] bpm_sum; 
	
	//Used for beat positive edge detection 
	reg prev_beat; 
	
	//The output is just the sum of the buffer divided by 4, ie. the top 8 bits 
	assign bpm_out = bpm_sum[9:2]; 
	
	bpm_from_interval bfi (
    .counter(counter), 
    .default_bpm(default_bpm), 
    .counted_bpm(counted_bpm)
    );
	
	initial begin 
		//Something sensible for the beginning values of the buffer 
		bpm_sum = STARTING_BPM*4; 
		buffer[0] = STARTING_BPM; 
		buffer[1] = STARTING_BPM; 
		buffer[2] = STARTING_BPM; 
		buffer[3] = STARTING_BPM; 
		counter = 0; 
		oldest_index = 0; 
		prev_beat = 0; 
	end 
	
	always @(posedge clk) begin 
		if ((counter > LONGEST_ALLOWABLE_INTERVAL) ||   //timer has timed out
			 (beat && ~prev_beat && (counter >= SMALLEST_ALLOWABLE_INTERVAL)))  //a beat was detected
		begin 
			//A beat has been detected within reasonable bounds. 
			//Adjust the moving average with the newly-calculated BPM 
			bpm_sum = bpm_sum + (counted_bpm - buffer[oldest_index]); 
			buffer[oldest_index] = counted_bpm; 
			oldest_index = (oldest_index == 3) ? 0 : oldest_index+1; 
			prev_beat = 1; 
			counter = 0; 
		end else begin 
			//Nothing has happened, just counting... 
			counter = counter + 1; 
			prev_beat = beat; 
		end 
	end
	
	

endmodule
