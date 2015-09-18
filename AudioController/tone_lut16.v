module tone_lut16 (input [5:0] tone, output [15:0] sixteenth_period);
	
	//these constants define the number of 100Mhz cycles needed to emulate each note frequency, divided by 16 to get
	//a 16th of  the waveform, to use PWM accurately
	parameter 	
				// Need to add C3 to G3, also all sharps and flats
				C3  = 16'd47779,
				C3S = 16'd45097,
				D3  = 16'd42566,
				D3S = 16'd40177,
				E3  = 16'd37922,
				F3  = 16'd35794,
				F3S = 16'd33784,
				G3  = 16'd31888,
				G3S = 16'd30099,
				A3  = 16'd28409,
				A3S = 16'd26815,
				B3  = 16'd25310,
				
				C4  = 16'd23889,
				C4S = 16'd22549,
				D4  = 16'd21283,
				D4S = 16'd20088,
				E4  = 16'd18961,
				F4  = 16'd17897,
				F4S = 16'd16892,
				G4  = 16'd15944,
				G4S = 16'd15049,
				A4  = 16'd14205,
				A4S = 16'd13407,
				B4  = 16'd12655,
				
				C5  = 16'd11945,
				C5S = 16'd11274,
				D5  = 16'd10641,
				D5S = 16'd10044,
				E5  = 16'd9480,
				F5  = 16'd8948,
				F5S = 16'd8446,
				G5  = 16'd7972,
				G5S = 16'd7525,
				A5  = 16'd7102,
				A5S = 16'd6704,
				B5  = 16'd6327,
				
				C6  = 16'd5972,
				C6S = 16'd5637,
				D6  = 16'd5321,
				D6S = 16'd5022,
				E6  = 16'd4740,
				F6  = 16'd4474,
				F6S = 16'd4223,
				G6  = 16'd3986,
				G6S = 16'd3762,
				A6  = 16'd3551,
				A6S = 16'd3352,
				B6  = 16'd3164;
				
	assign sixteenth_period =  (tone == 6'd0)  ? C3  :
									   (tone == 6'd1)  ? C3S :
									   (tone == 6'd2)  ? D3  :
										(tone == 6'd3)  ? D3S :
										(tone == 6'd4)  ? E3  :
										(tone == 6'd5)  ? F3  :
										(tone == 6'd6)  ? F3S :
										(tone == 6'd7)  ? G3  :
										(tone == 6'd8)  ? G3S :
										(tone == 6'd9)  ? A3  :
										(tone == 6'd10) ? A3S :
										(tone == 6'd11) ? B3  :
									 
										(tone == 6'd12) ? C4  :
										(tone == 6'd13) ? C4S :
										(tone == 6'd14) ? D4  :
										(tone == 6'd15) ? D4S :
										(tone == 6'd16) ? E4  :
										(tone == 6'd17) ? F4  :
										(tone == 6'd18) ? F4S :
										(tone == 6'd19) ? G4  :
										(tone == 6'd20) ? G4S :
										(tone == 6'd21) ? A4  :
										(tone == 6'd22) ? A4S :
										(tone == 6'd23) ? B4  :
									 
										(tone == 6'd24) ? C5  :
										(tone == 6'd25) ? C5S :
										(tone == 6'd26) ? D5  :
										(tone == 6'd27) ? D5S :
										(tone == 6'd28) ? E5  :
										(tone == 6'd29) ? F5  :
										(tone == 6'd30) ? F5S :
										(tone == 6'd31) ? G5  :
										(tone == 6'd32) ? G5S :
										(tone == 6'd33) ? A5  :
										(tone == 6'd34) ? A5S :
										(tone == 6'd35) ? B5  :
									 
										(tone == 6'd36) ? C6  :
										(tone == 6'd37) ? C6S :
										(tone == 6'd38) ? D6  :
										(tone == 6'd39) ? D6S :
										(tone == 6'd40) ? E6  :
										(tone == 6'd41) ? F6  :
										(tone == 6'd42) ? F6S :
										(tone == 6'd43) ? G6  :
										(tone == 6'd44) ? G6S :
										(tone == 6'd45) ? A6  :
										(tone == 6'd46) ? A6S :
										(tone == 6'd47) ? B6  :
										/*tone undefined*/  0 ;

endmodule
