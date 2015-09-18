// ELEC2141 Demonstration Code for Nexys
//
// This code implements 7447 BCD to 7-Segment Decoder
//
// Date: 20-Dec-2008
// 
// George Lam, george.lam@unswalumni.com.NOSPAM
//

module bcdtoseg(nLT, nRBI, A3, A2, A1, A0, nBI,
				nRBO, nA, nB, nC, nD, nE, nF, nG);

	input  nLT, nRBI, A3, A2, A1, A0, nBI;
	output nRBO, nA, nB, nC, nD, nE, nF, nG;

	// BCD input
	wire  [3:0] SEGIN;
	
	// 7-Segment Output (Active Low)
	reg   [6:0] nSEGOUT;

	// Use Bus notation
	assign   SEGIN[3] = A3;
	assign   SEGIN[2] = A2;
	assign   SEGIN[1] = A1;
	assign   SEGIN[0] = A0;

	assign   nA = nSEGOUT[6];
	assign   nB = nSEGOUT[5];
	assign   nC = nSEGOUT[4];
	assign   nD = nSEGOUT[3];
	assign   nE = nSEGOUT[2];
	assign   nF = nSEGOUT[1];
	assign   nG = nSEGOUT[0];

	// Ripple-blanknig output
	assign nRBO = ~(~nBI || (~nRBI && (SEGIN == 4'd0) && nLT));
	
	// Implement Lookup table
	always @ (nRBO or nLT or SEGIN) begin
		if (~nRBO) begin
			//  Blanking output
			nSEGOUT = ~7'b0000000; 
		end else if (~nLT) begin
			//  Lamp test
			nSEGOUT = ~7'b1111111; 
		end else begin 
			case (SEGIN)
				4'd0:     nSEGOUT = ~7'b1111110; 
				4'd1:     nSEGOUT = ~7'b0110000;
				4'd2:     nSEGOUT = ~7'b1101101;
				4'd3:     nSEGOUT = ~7'b1111001;
				4'd4:     nSEGOUT = ~7'b0110011;
				4'd5:     nSEGOUT = ~7'b1011011;
				4'd6:     nSEGOUT = ~7'b1011111;
				4'd7:     nSEGOUT = ~7'b1110000;
				4'd8:     nSEGOUT = ~7'b1111111;
				4'd9:     nSEGOUT = ~7'b1111011; 
				default:  nSEGOUT = ~7'b0000000;
			endcase
		end
	end

endmodule
