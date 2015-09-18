module sin_lut (input [5:0] lookup, output [7:0] value);
	assign value = (lookup == 6'd0)  ? 128 :
						(lookup == 6'd1)  ? 140 :
						(lookup == 6'd2)  ? 152 :
						(lookup == 6'd3)  ? 165 :
						(lookup == 6'd4)  ? 176 :
						(lookup == 6'd5)  ? 188 :
						(lookup == 6'd6)  ? 198 :
						(lookup == 6'd7)  ? 208 :
						(lookup == 6'd8)  ? 218 :
						(lookup == 6'd9)  ? 226 :
						(lookup == 6'd10) ? 234 :
						(lookup == 6'd11) ? 240 :
						(lookup == 6'd12) ? 245 :
						(lookup == 6'd13) ? 250 :
						(lookup == 6'd14) ? 253 :
						(lookup == 6'd15) ? 254 :
						
						(lookup == 6'd16) ? 255 :
						(lookup == 6'd17) ? 254 :
						(lookup == 6'd18) ? 253 :
						(lookup == 6'd19) ? 250 :
						(lookup == 6'd20) ? 245 :
						(lookup == 6'd21) ? 240 :
						(lookup == 6'd22) ? 234 :
						(lookup == 6'd23) ? 226 :
						(lookup == 6'd24) ? 218 :
						(lookup == 6'd25) ? 208 :
						(lookup == 6'd26) ? 198 :
						(lookup == 6'd27) ? 188 :
						(lookup == 6'd28) ? 176 : 
						(lookup == 6'd29) ? 165 : 
						(lookup == 6'd30) ? 152 :
						(lookup == 6'd31) ? 140 :
					
						(lookup == 6'd32) ? 128 :
						(lookup == 6'd33) ? 115 :
						(lookup == 6'd34) ? 103 :
						(lookup == 6'd35) ? 90  :
						(lookup == 6'd36) ? 79  :
						(lookup == 6'd37) ? 67  :
						(lookup == 6'd38) ? 57  : 
						(lookup == 6'd39) ? 47  :
						(lookup == 6'd40) ? 37  :
						(lookup == 6'd41) ? 29  :
						(lookup == 6'd42) ? 21  :
						(lookup == 6'd43) ? 15  :
						(lookup == 6'd44) ? 10  :
						(lookup == 6'd45) ? 5   :
						(lookup == 6'd46) ? 2   :
						(lookup == 6'd47) ? 1   :
					
						(lookup == 6'd48) ? 0   :
						(lookup == 6'd49) ? 1   :
						(lookup == 6'd50) ? 2   : 
						(lookup == 6'd51) ? 5   :
						(lookup == 6'd52) ? 10  :
						(lookup == 6'd53) ? 15  :
						(lookup == 6'd54) ? 21  :
						(lookup == 6'd55) ? 29  :
						(lookup == 6'd56) ? 37  :
						(lookup == 6'd57) ? 47  :
						(lookup == 6'd58) ? 57  :
						(lookup == 6'd59) ? 67  :
						(lookup == 6'd60) ? 79  : 
						(lookup == 6'd61) ? 90  : 
						(lookup == 6'd62) ? 103 :
						(lookup == 6'd63) ? 115 :
						/*lookup undefined*/ 0  ;
endmodule
