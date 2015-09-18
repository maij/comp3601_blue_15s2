module byte_to_BCD(input [7:0] byte, output reg [11:0] BCD);
	// Credit to http://www.deathbylogic.com/2013/12/binary-to-binary-coded-decimal-bcd-converter/
	// I have NOT written this file
	// Internal variable for storing bits
   reg [19:0] shift;
   integer i;
   
   always @(byte)
   begin
      // Clear previous number and store new number in shift register
      shift[19:8] = 0;
      shift[7:0] = byte;
      
      // Loop eight times
      for (i=0; i<8; i=i+1) begin
         if (shift[11:8] >= 5)
            shift[11:8] = shift[11:8] + 3;
            
         if (shift[15:12] >= 5)
            shift[15:12] = shift[15:12] + 3;
            
         if (shift[19:16] >= 5)
            shift[19:16] = shift[19:16] + 3;
         
         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
		BCD[11:0] = shift[19:8];
   end
							 
endmodule
