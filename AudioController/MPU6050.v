`timescale 1ns / 1ps

`include "./MPU6050_defines.v"

module MPU6050
(
		input 						clk,
		input 						rst,
		inout							scl,
		inout							sda,
		output	reg [15:0] 		accel_z,
		output 	reg 				valid,
		output	reg 				error		
);

	integer i;
	
	localparam [4:0] INIT_REG_STATE = 0;
	localparam [4:0] READ_ACCEL_Z_STATE = 4;	
	localparam [4:0] IDLE_STATE = 5;	
	localparam [4:0] ERROR_STATE = 6;	
	
	reg [4:0] state = 0;
	
	localparam [4:0] REG_RAM_LEN = 16;
	reg [7:0] REG_ADDR_RAM [0:REG_RAM_LEN-1];
	reg [7:0] REG_VALUE_RAM [0:REG_RAM_LEN-1];		
	
	reg [4:0] counter = 0;
		
	localparam [27:0] IDLE_COUNT = 28'd100000;
	reg [27:0] idle_counter = 0;

	reg mpu_start = 0;
	reg mpu_rd_wr = 0;
	reg [7:0] mpu_wr_data = 0;
	wire mpu_busy;
	reg mpu_prev_busy;
	reg [7:0] mpu_reg_addr;
	wire [7:0] mpu_rd_data; 

	
	I2CMasterTop #(	.DEVICE_ADDR( 7'b1101000 ))
				mpu (		.clk( clk ), 
							.rst( rst ), 
							.start( mpu_start ), 
							.rd_wr( mpu_rd_wr ), 
							.reg_addr( mpu_reg_addr ), 
							.wr_data( mpu_wr_data ), 
							.rd_data( mpu_rd_data ), 
							.busy( mpu_busy ), 
							.scl( scl ), 
							.sda( sda ));


	initial begin	
		//Disabling sleep mode
		for(i = 0; i < REG_RAM_LEN-1; i=i+1) begin
			REG_ADDR_RAM[i] <= `MPU6050_RA_PWR_MGMT_1;
			REG_VALUE_RAM[i] <= 8'h00;
		end
		
		//Set the scale to +-8G
		REG_ADDR_RAM[REG_RAM_LEN-1] <= `MPU6050_RA_ACCEL_CONFIG;
		REG_VALUE_RAM[REG_RAM_LEN-1] <= 8'b00011000;
	end

	always @ (posedge clk) begin

		mpu_prev_busy <= mpu_busy;

		if( rst ) begin
		
			accel_z <= 0;
			valid <= 0;
			error <= 0;
						
			mpu_start <= 0;
			mpu_rd_wr <= 0;
			mpu_reg_addr <= 0;
			mpu_wr_data <= 0;
			
			counter <= 0;
			idle_counter <= 0;
			state <= INIT_REG_STATE;
		
		end else begin
		
			case( state )
			
				//Do nothing more for now; Later could restart
				ERROR_STATE : begin 
				
					state <= READ_ACCEL_Z_STATE;
				end
			
				INIT_REG_STATE : begin
					
					//If MPU is busy, then wait until available
					if(mpu_busy) begin
						mpu_start <= 0;
						
					//If just started or MPU just became available, send next register data  
					end else if( (counter == 0) | (mpu_prev_busy & ~mpu_busy) ) begin
						if ( counter == REG_RAM_LEN ) begin
							counter <= 0;
							state <= READ_ACCEL_Z_STATE;
						end else begin
							mpu_start <= 1;
							mpu_rd_wr <= 0;
							mpu_reg_addr <= REG_ADDR_RAM[counter];
							mpu_wr_data <= REG_VALUE_RAM[counter];
							counter <= counter + 1;
						end
					end
				end	
				
				READ_ACCEL_Z_STATE : begin
					//If MPU is busy, then wait until available
					if(mpu_busy) begin
						mpu_start <= 0;
						
					//If just started or MPU just became available, send next register data  
					end else if( (counter == 0) | (mpu_prev_busy & ~mpu_busy) ) begin
						
						case( counter ) 
							0 : 
							begin
								mpu_start <= 1;
								mpu_rd_wr <= 1;
								mpu_reg_addr <= `MPU6050_RA_ACCEL_ZOUT_H;
								counter <= counter + 1;
							end
							1 : 
							begin
								mpu_start <= 1;
								mpu_rd_wr <= 1;
								mpu_reg_addr <= `MPU6050_RA_ACCEL_ZOUT_L;
								counter <= counter + 1;
								accel_z <= {8'b00000000, mpu_rd_data};
							end
							2 : 
							begin
								mpu_start <= 0;
								counter <= 0;
								accel_z <= {accel_z[7:0], mpu_rd_data};
								state <= IDLE_STATE;
								valid <= 1;
							end
						endcase
					end
				end
				
				IDLE_STATE : begin
					if(idle_counter >= IDLE_COUNT) begin
						valid <= 0;
						idle_counter <= 0;
						state <= READ_ACCEL_Z_STATE;
					end else begin
						idle_counter <= idle_counter + 1;
					end		
				end
			endcase
		end
	end


endmodule







