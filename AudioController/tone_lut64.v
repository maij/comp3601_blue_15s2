module tone_lut64 (input [5:0] tone, output [13:0] sixty_fourth_period);
	
	//these constants define the number of 100Mhz cycles needed to emulate each note frequency, divided by 64 to get
	//a 64th of  the waveform, to use PWM accurately
	parameter
				REST= 14'd1000,	// give a small delay between look-up table advances
				C3  = 14'd11945,
				C3S = 14'd11275,
				D3  = 14'd10642,
				D3S = 14'd10045,
				E3  = 14'd9481,
				F3  = 14'd8949,
				F3S = 14'd8446,
				G3  = 14'd7972,
				G3S = 14'd7525,
				A3  = 14'd7103,
				A3S = 14'd6704,
				B3  = 14'd6328,
				
				C4  = 14'd5973,
				C4S = 14'd5638,
				D4  = 14'd5321,
				D4S = 14'd5022,
				E4  = 14'd4741,
				F4  = 14'd4475,
				F4S = 14'd4223,
				G4  = 14'd3986,
				G4S = 14'd3763,
				A4  = 14'd3552,
				A4S = 14'd3352,
				B4  = 14'd3164,
				
				C5  = 14'd2987,
				C5S = 14'd2819,
				D5  = 14'd2661,
				D5S = 14'd2511,
				E5  = 14'd2370,
				F5  = 14'd2237,
				F5S = 14'd2112,
				G5  = 14'd1993,
				G5S = 14'd1882,
				A5  = 14'd1776,
				A5S = 14'd1676,
				B5  = 14'd1582,
				
				C6  = 14'd1493,
				C6S = 14'd1410,
				D6  = 14'd1331,
				D6S = 14'd1256,
				E6  = 14'd1185,
				F6  = 14'd1119,
				F6S = 14'd1056,
				G6  = 14'd997,
				G6S = 14'd941,
				A6  = 14'd888,
				A6S = 14'd838,
				B6  = 14'd791;
				
	assign sixty_fourth_period =
										(tone == 6'd0)  ? REST:
									   (tone == 6'd1)  ? C3  :
									   (tone == 6'd2)  ? C3S :
									   (tone == 6'd3)  ? D3  :
										(tone == 6'd4)  ? D3S :
										(tone == 6'd5)  ? E3  :
										(tone == 6'd6)  ? F3  :
										(tone == 6'd7)  ? F3S :
										(tone == 6'd8)  ? G3  :
										(tone == 6'd9)  ? G3S :
										(tone == 6'd10)  ? A3  :
										(tone == 6'd11) ? A3S :
										(tone == 6'd12) ? B3  :
									
										(tone == 6'd13) ? C4  :
										(tone == 6'd14) ? C4S :
										(tone == 6'd15) ? D4  :
										(tone == 6'd16) ? D4S :
										(tone == 6'd17) ? E4  :
										(tone == 6'd18) ? F4  :
										(tone == 6'd19) ? F4S :
										(tone == 6'd20) ? G4  :
										(tone == 6'd21) ? G4S :
										(tone == 6'd22) ? A4  :
										(tone == 6'd23) ? A4S :
										(tone == 6'd24) ? B4  :
									
										(tone == 6'd25) ? C5  :
										(tone == 6'd26) ? C5S :
										(tone == 6'd27) ? D5  :
										(tone == 6'd28) ? D5S :
										(tone == 6'd29) ? E5  :
										(tone == 6'd30) ? F5  :
										(tone == 6'd31) ? F5S :
										(tone == 6'd32) ? G5  :
										(tone == 6'd33) ? G5S :
										(tone == 6'd34) ? A5  :
										(tone == 6'd35) ? A5S :
										(tone == 6'd36) ? B5  :
									 
										(tone == 6'd37) ? C6  :
										(tone == 6'd38) ? C6S :
										(tone == 6'd39) ? D6  :
										(tone == 6'd40) ? D6S :
										(tone == 6'd41) ? E6  :
										(tone == 6'd42) ? F6  :
										(tone == 6'd43) ? F6S :
										(tone == 6'd44) ? G6  :
										(tone == 6'd45) ? G6S :
										(tone == 6'd46) ? A6  :
										(tone == 6'd47) ? A6S :
										(tone == 6'd48) ? B6  :
										/*tone undefined*/  0 ;

endmodule
