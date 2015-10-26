`timescale 1ns / 1ps

module double_thermometer(
    input signed [15:0] accel,
    output wire [7:0] out
    );
	 
	 assign out = 	(accel == 16'd0)     ? 8'b00011000 :
						(accel < -16'd24576) ? 8'b10000000 : 
						(accel < -16'd16384) ? 8'b01000000 : 
						(accel < -16'd8192 ) ? 8'b00100000 : 
						(accel <  16'd0    ) ? 8'b00010000 : 
						(accel <  16'd8192 ) ? 8'b00001000 : 
						(accel <  16'd16384) ? 8'b00000100 : 
						(accel <  16'd24576) ? 8'b00000010 : 8'b00000001;

endmodule
