LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


ENTITY I2CMasterTop IS
	GENERIC(
		DEVICE_ADDR : STD_LOGIC_VECTOR(6 DOWNTO 0)	 := "1101000"
	);
	PORT(
		clk			: IN			STD_LOGIC;
		rst			: IN			STD_LOGIC;
		start			: IN			STD_LOGIC;
		rd_wr 		: IN			STD_LOGIC;
		reg_addr		: IN			STD_LOGIC_VECTOR(7 DOWNTO 0);		
		wr_data		: IN			STD_LOGIC_VECTOR(7 DOWNTO 0);
		rd_data		: OUT 		STD_LOGIC_VECTOR(7 DOWNTO 0);
		busy			: BUFFER		STD_LOGIC;		
		scl			: INOUT 		STD_LOGIC;
		sda			: INOUT		STD_LOGIC		
	);
END I2CMasterTop;

ARCHITECTURE logic OF I2CMasterTop IS

	TYPE machine IS(idle, wr_reg_busy, rd_wr_busy, done);
  
	SIGNAL	state     		:  machine;                         	
	SIGNAL	i2c_busy_prev	:	STD_LOGIC;
	SIGNAL	i2c_en			: 	STD_LOGIC;
	SIGNAL	i2c_rw			: 	STD_LOGIC;
	SIGNAL	i2c_wr_data		: 	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL	i2c_busy			: 	STD_LOGIC;
	SIGNAL	i2c_rd_data		: 	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL	i2c_error		: 	STD_LOGIC;
	
	SIGNAL 	rd_wr_i			: STD_LOGIC;
	SIGNAL	wr_data_i		: 	STD_LOGIC_VECTOR(7 DOWNTO 0);
	
BEGIN

	I2C_Master : entity work.i2c_master 
	port map(
		clk 			=> 	clk, 
		reset_n 		=> 	not rst, 
		ena 			=> 	i2c_en, 
		addr 			=> 	DEVICE_ADDR,     
		rw 			=> 	i2c_rw, 
		data_wr 		=> 	i2c_wr_data, 
		busy 			=>		i2c_busy, 
		data_rd 		=>		i2c_rd_data, 
		ack_error 	=>		i2c_error, 
		sda			=>		sda, 
		scl			=> 	scl
	);
	
	--For writing: S,AD+W,RA,WR_DATA,...,P
	--For reading: S,AD+W,RA,`S,AD+R,RD_DATA,....,P

	PROCESS(clk, rst) BEGIN
		
		IF(rst = '1') THEN
			i2c_busy_prev <= '0';
			i2c_en <= '0';
			i2c_rw <= '1';
			i2c_wr_data <= "00000000";
			rd_data <= "00000000";
			wr_data_i <= "00000000";
			busy <= '1';
			state <= idle;
				
		ELSIF(clk'EVENT AND clk = '1') THEN
		
			i2c_busy_prev <= i2c_busy;
		
			CASE state IS
				WHEN idle => 
					IF( i2c_busy = '1' ) THEN
						busy <= '1';
					ELSIF(start = '1') THEN
						busy <= '1';
						rd_wr_i <= rd_wr;
						i2c_wr_data <= reg_addr;						
						i2c_rw <= '0';
						i2c_en <= '1';						
						state <= wr_reg_busy;
					ELSE 
						busy <= '0';
					END IF;
					
				WHEN wr_reg_busy =>				
					--Once busy, can setup I2C for reading or writing
					IF(i2c_busy_prev = '0' AND i2c_busy = '1') THEN						
						i2c_rw <= rd_wr_i; 			
						i2c_wr_data <= wr_data_i;
						state <= rd_wr_busy;	
					END IF;
			
				WHEN rd_wr_busy =>
					--Once busy, can deassert enable
					IF(i2c_busy_prev = '0' AND i2c_busy = '1') THEN
						i2c_en <= '0';
						state <= done;						
					END IF;
					
				
				WHEN done =>
					--Once no longer busy, get read data regardless
					IF(i2c_busy = '0') THEN
						rd_data <= i2c_rd_data;
						busy <= '0';
						state <= idle;
					END IF;
				
				END CASE;
		END IF;		
	END PROCESS;
END logic;





