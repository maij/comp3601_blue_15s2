module BPM_prescaler(CLK, BPM, slowCLK);
	input CLK;
	input [7:0] BPM;
	output reg slowCLK;
	wire [19:0] scaler;
	
	BPM_lut U1 (BPM, scaler);
	reg [19:0] counter; // 20-bit counter for prescaling to at least 60 BPM
	//parameter scale_to_60BPM = 20'd1000000;	// 1 million cycles, i.e. 1000 cycles per beat at 60BPM
	
	initial begin
		counter = 0;
		slowCLK = 0;
	end
	always @ (posedge CLK) begin
		//slowCLK = ~slowCLK;
		counter = counter + 1;
		// Count up to half the period, then toggle
		if (counter >= scaler/2) begin
			counter = 0;
			slowCLK = ~slowCLK;
		end
	end
endmodule
