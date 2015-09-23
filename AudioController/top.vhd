--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : DemoWithMemCfg.vhf
-- /___/   /\     Timestamp : 09/05/2015 14:10:23
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: D:\Xilinx\14.7\ISE_DS\ISE\bin\nt\unwrapped\sch2hdl.exe -intstyle ise -family spartan3 -flat -suppress -vhdl DemoWithMemCfg.vhf -w C:/Comp3601/N/Nexys_BIST/DemoWithMemCfg.sch
--Design Name: DemoWithMemCfg
--Device: spartan3
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity DemoWithMemCfg is
   port ( clk        : in    std_logic; 
          EppAstb    : in    std_logic; 
          EppDstb    : in    std_logic; 
          EppWr      : in    std_logic; 
          FlashStSts : in    std_logic; 
          RamWait    : in    std_logic; 
          EppWait    : out   std_logic; 
          FlashCS    : out   std_logic; 
          FlashRp    : out   std_logic; 
          MemAdr     : out   std_logic_vector (23 downto 1); 
          MemOe      : out   std_logic; 
          MemWr      : out   std_logic; 
          RamAdv     : out   std_logic; 
          RamClk     : out   std_logic; 
          RamCre     : out   std_logic; 
          RamCS      : out   std_logic; 
          RamLB      : out   std_logic; 
          RamUB      : out   std_logic; 
          EppDB      : inout std_logic_vector (7 downto 0); 
          MemDB      : inout std_logic_vector (15 downto 0);
			 
			 BTN			: in 	  std_logic;

			 dataout    : inout   std_logic_vector (15 downto 0)
			 );
end DemoWithMemCfg;

architecture BEHAVIORAL of DemoWithMemCfg is
   attribute BOX_TYPE   : string ;
   signal XLXN_1     : std_logic_vector (7 downto 0);
   signal XLXN_6     : std_logic;
   signal XLXN_7     : std_logic;
   signal XLXN_8     : std_logic;
   signal XLXN_10    : std_logic;
   signal XLXN_38    : std_logic;
   signal XLXN_108   : std_logic_vector (7 downto 0);
   signal XLXN_187   : std_logic_vector (7 downto 0);
   signal XLXN_190   : std_logic;
   signal XLXN_279   : std_logic;
   signal XLXN_280   : std_logic_vector (7 downto 0);
   component EppCtrl
      port ( HandShakeReqIn   : in    std_logic; 
             ctlEppDoneIn     : in    std_logic; 
             busEppIn         : in    std_logic_vector (7 downto 0); 
             ctlEppRdCycleOut : inout std_logic; 
             regEppAdrOut     : inout std_logic_vector (7 downto 0); 
             ctlEppDwrOut     : out   std_logic; 
             ctlEppStartOut   : out   std_logic; 
             busEppOut        : out   std_logic_vector (7 downto 0); 
             clk              : in    std_logic; 
             EppAstb          : in    std_logic; 
             EppDstb          : in    std_logic; 
             EppWr            : in    std_logic; 
             EppRst           : in    std_logic; 
             EppDB            : inout std_logic_vector (7 downto 0); 
             EppWait          : out   std_logic);
   end component;
   
   component CompSel
      port ( regEppAdrIn : in    std_logic_vector (7 downto 0); 
             CS80_9F     : out   std_logic; 
             CS0_7       : out   std_logic; 
             CS8_F       : out   std_logic);
   end component;
   
   component PhoenixOnBoardMemCtrl
      port ( clk             : in    std_logic; 
             ctlMsmStartIn   : in    std_logic; 
             ctlMsmDwrIn     : in    std_logic; 
             ctlEppRdCycleIn : in    std_logic; 
             ComponentSelect : in    std_logic; 
             RamWait         : in    std_logic; 
             FlashStSts      : in    std_logic; 
             EppWrDataIn     : in    std_logic_vector (7 downto 0); 
             regEppAdrIn     : in    std_logic_vector (7 downto 0); 
             MemDB           : inout std_logic_vector (15 downto 0); 
             HandShakeReqOut : out   std_logic; 
             ctlMsmDoneOut   : out   std_logic; 
             FlashByte       : out   std_logic; 
             RamCS           : out   std_logic; 
             FlashCS         : out   std_logic; 
             MemWR           : out   std_logic; 
             MemOE           : out   std_logic; 
             RamUB           : out   std_logic; 
             RamLB           : out   std_logic; 
             RamCre          : out   std_logic; 
             RamAdv          : out   std_logic; 
             RamClk          : out   std_logic; 
             FlashRp         : out   std_logic; 
             MemCtrlEnabled  : out   std_logic; 
             EppRdDataOut    : out   std_logic_vector (7 downto 0); 
             MemAdr          : out   std_logic_vector (23 downto 1);
				 
				 ReadReq: in std_logic;
				ReadAck: out std_logic;
				DataRdy: out std_logic;
				DataOut :out std_logic_vector(15 downto 0);
				DataAck: in std_logic

				 
				 
);
   end component;
   
   component VCC
      port ( P : out   std_logic);
   end component;
   attribute BOX_TYPE of VCC : component is "BLACK_BOX";
   
   
	
		signal data	: std_logic_vector(15 downto 0);	
	
	signal dataHigh	: std_logic_vector(7 downto 0);	
	signal test_count : integer range 0 to 50 := 0; 
	signal stage : integer range 0 to 10 := 0; 	

	
	signal memRead	: std_logic;	
	signal readAck	: std_logic;		
	signal Datardy	: std_logic;	
	signal DataAck	: std_logic;		
	signal lock: std_logic := '0';
	
	
	
begin



	process (BTN, clk) -- Do a double read cycle
			Begin
				if (BTN'event and BTN = '1' and stage = 0) then
					stage <= 1;
					memRead <= '1';
				end if;
				
				if (clk'event and clk = '1' AND stage /= 0) then
					test_count <= test_count + 1;
					if test_count = 50 then
						test_count <= 0;
					end if;
				end if;
				
				if (test_count = 5 ) then
					memRead <= '0';
					stage <= 1;
				elsif (test_count = 45) And stage = 2 then
					memRead <= '0';
					stage <= 0;
				elsif (test_count = 40) and stage = 1 then
					memRead <= '1';
					stage <= 2;
	end if;		
				
	end process;
	process (DataRdy) 
			Begin
				if DataRdy = '1' then
					DataAck <= '1';
				else
					DataAck <= '0';
				end if;
	end process;


	process (Data)
		Begin
			if (stage = 1) then 
				DataHigh <= data(7 downto 0);
			else
				DataOut <= DataHigh & data(7 downto 0);
			end if;
	end process;









   XLXI_1 : EppCtrl
      port map (busEppIn(7 downto 0)=>XLXN_187(7 downto 0),
                clk=>clk,
                ctlEppDoneIn=>XLXN_8,
                EppAstb=>EppAstb,
                EppDstb=>EppDstb,
                EppRst=>XLXN_38,
                EppWr=>EppWr,
                HandShakeReqIn=>XLXN_6,
                busEppOut(7 downto 0)=>XLXN_1(7 downto 0),
                ctlEppDwrOut=>XLXN_279,
                ctlEppStartOut=>XLXN_7,
                EppWait=>EppWait,
                ctlEppRdCycleOut=>XLXN_190,
                EppDB(7 downto 0)=>EppDB(7 downto 0),
                regEppAdrOut(7 downto 0)=>XLXN_280(7 downto 0));
   
   XLXI_4 : CompSel
      port map (regEppAdrIn(7 downto 0)=>XLXN_280(7 downto 0),
                CS0_7=>XLXN_10,
                CS8_F=>open,
                CS80_9F=>open);
   
   XLXI_6 : PhoenixOnBoardMemCtrl
      port map (clk=>clk,
                ComponentSelect=>XLXN_10,
                ctlEppRdCycleIn=>XLXN_190,
                ctlMsmDwrIn=>XLXN_279,
                ctlMsmStartIn=>XLXN_7,
                EppWrDataIn(7 downto 0)=>XLXN_1(7 downto 0),
                FlashStSts=>FlashStSts,
                RamWait=>RamWait,
                regEppAdrIn(7 downto 0)=>XLXN_280(7 downto 0),
                ctlMsmDoneOut=>XLXN_8,
                EppRdDataOut(7 downto 0)=>XLXN_187(7 downto 0),
                FlashByte=>open,
                FlashCS=>FlashCS,
                FlashRp=>FlashRp,
                HandShakeReqOut=>XLXN_6,
                MemAdr(23 downto 1)=>MemAdr(23 downto 1),
                MemCtrlEnabled=>open,
                MemOE=>MemOe,
                MemWR=>MemWr,
                RamAdv=>RamAdv,
                RamClk=>RamClk,
                RamCre=>RamCre,
                RamCS=>RamCS,
                RamLB=>RamLB,
                RamUB=>RamUB,
                MemDB(15 downto 0)=>MemDB(15 downto 0),
					 
					 ReadReq => MemRead,
					ReadAck => ReadAck,
					DataRdy => DataRdy,
					DataOut => data,
					DataAck=> DataAck

					 
					 
					 );
   
   XLXI_7 : VCC
      port map (P=>XLXN_38);

   
end BEHAVIORAL;


