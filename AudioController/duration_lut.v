module  duration_lut (input [3:0] lookup, output [15:0] duration);
	// NOTE: Slowest frequency from prescaler is 100Hz, which corresponds to 1 BPM
	// 1 BPM is actually 1/60 Hz, so to accurately time a note requires 6,000 cycles of the prescaler
	// NOTE: A BPM command will be accompanied by an UNDEF lookup, so it should last 0.18 beats
	// before accessing the first note.
	parameter
		BREVE     			= 16'd48000,		// 8    beats
		SEMIBREVE			= 16'd24000,		// 4 	  beats
		DOTTED_MINIM		= 16'd18000,		// 3 	  beats
		MINIM					= 16'd12000,		// 2 	  beats
		DOTTED_CROTCHET	= 16'd9000,			// 1.5  beats
		CROTCHET 			= 16'd6000,			// 1    beat
		DOTTED_QUAVER 		= 16'd4500,			// 0.75 beats
		QUAVER  				= 16'd3000,			// 0.5  beats
		TUPLET				= 16'd2000,			// 0.33 beats
		SEMIQUAVER			= 16'd1500,			// 0.25 beats
		UNDEF					= 16'd1000;			// 0.18 beats
		
	assign duration = (lookup == 4'd1)  ? SEMIQUAVER 	   :
						   (lookup == 4'd2)  ? TUPLET			   :
							(lookup == 4'd3)  ? QUAVER			   :
							(lookup == 4'd4)  ? DOTTED_QUAVER   :
							(lookup == 4'd5)  ? CROTCHET		   :
							(lookup == 4'd6)  ? DOTTED_CROTCHET :
							(lookup == 4'd7)  ? MINIM			   :
							(lookup == 4'd8)  ? DOTTED_MINIM	   :
							(lookup == 4'd9)  ? SEMIBREVE		   :
							(lookup == 4'd10) ? BREVE			   :
							/* lookup undef*/   UNDEF			   ;
		
endmodule
