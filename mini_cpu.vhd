-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 22.1std.1 Build 917 02/14/2023 SC Lite Edition"
-- CREATED		"Thu Apr  4 12:09:20 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY mini_cpu IS 
	PORT
	(
		DBG_MODE :  IN  STD_LOGIC;
		CLOCK :  IN  STD_LOGIC;
		RESET :  IN  STD_LOGIC;
		IOINBUS :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		IOW :  OUT  STD_LOGIC;
		IOR :  OUT  STD_LOGIC;
		DBG0 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		DBG1 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		DBG2 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		DBG3 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		DBG4 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		DBG5 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		IOADDRESS :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		IODATA :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END mini_cpu;

ARCHITECTURE bdf_type OF mini_cpu IS 

COMPONENT reg
GENERIC (size : INTEGER
			);
	PORT(en : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bus_mux2
GENERIC (busSize : INTEGER
			);
	PORT(sel : IN STD_LOGIC;
		 busA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 busB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bus_mux2_8b
	PORT(sel : IN STD_LOGIC;
		 busA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 busB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT decoder
	PORT(addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bcd_to_hex
	PORT(bcd_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 hex_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT io_pipeline
	PORT(clk : IN STD_LOGIC;
		 en : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 iData : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 iRegA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 opHigh : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 opLow : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 fetchE : OUT STD_LOGIC;
		 io_write : OUT STD_LOGIC;
		 io_read : OUT STD_LOGIC;
		 regA_updt : OUT STD_LOGIC;
		 oAddress : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 oData : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 oRegA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT math_pipeline
	PORT(clk : IN STD_LOGIC;
		 en : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flags : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 regA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 regB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 writeR : OUT STD_LOGIC;
		 fetchE : OUT STD_LOGIC;
		 flgUpd : OUT STD_LOGIC;
		 outFlg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 regC : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT memory_pipeline
	PORT(clk : IN STD_LOGIC;
		 en : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 i_flags : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 i_mem : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 i_regA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 i_regB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 i_regC : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 opDataH : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 opDataL : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 fetchE : OUT STD_LOGIC;
		 fetchMem : OUT STD_LOGIC;
		 outAddr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 outputPC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 updtBus : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;

COMPONENT decoder3
	PORT(addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fetcher
	PORT(clk : IN STD_LOGIC;
		 fetch_en : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pline_en : OUT STD_LOGIC;
		 pc_en : OUT STD_LOGIC;
		 op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 operand_a : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 operand_b : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pline_sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT increment_reg
GENERIC (reg_size : INTEGER
			);
	PORT(clock : IN STD_LOGIC;
		 incr_en : IN STD_LOGIC;
		 update : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 inData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 outData : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram
	PORT(wren : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rom
	PORT(clock : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	addrBus :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	AUpdate :  STD_LOGIC;
SIGNAL	clk_line :  STD_LOGIC;
SIGNAL	common_bus :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	DATA_OUT :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	dataA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	dataB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ena :  STD_LOGIC;
SIGNAL	enc :  STD_LOGIC;
SIGNAL	FLAG_OUT :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	FLAG_UP :  STD_LOGIC;
SIGNAL	fm :  STD_LOGIC;
SIGNAL	HEX_12 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_34 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_56 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	io_regA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	outAddr :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	outMemPline :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	PC :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	PC_IN :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	RAM_DATA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	regA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	regB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	regC :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	regFlags :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ROM_DATA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	rst :  STD_LOGIC;
SIGNAL	selector :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	updtSelector :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC;


BEGIN 



b2v_A_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => ena,
		 reset => rst,
		 clk => clk_line,
		 data_in => SYNTHESIZED_WIRE_0,
		 data_out => regA);


b2v_addrMux : bus_mux2
GENERIC MAP(busSize => 16
			)
PORT MAP(sel => fm,
		 busA => PC,
		 busB => outAddr,
		 Q => addrBus);


b2v_B_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => updtSelector(2),
		 reset => rst,
		 clk => clk_line,
		 data_in => common_bus,
		 data_out => regB);


b2v_C_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => enc,
		 reset => rst,
		 clk => clk_line,
		 data_in => common_bus,
		 data_out => regC);


b2v_dataMux : bus_mux2_8b
PORT MAP(sel => SYNTHESIZED_WIRE_1,
		 busA => RAM_DATA,
		 busB => ROM_DATA,
		 Q => DATA_OUT);


b2v_dbg_muxA : bus_mux2_8b
PORT MAP(sel => DBG_MODE,
		 busA => PC(7 DOWNTO 0),
		 busB => regA,
		 Q => HEX_12);


b2v_dbg_muxB : bus_mux2_8b
PORT MAP(sel => DBG_MODE,
		 busA => PC(15 DOWNTO 8),
		 busB => regB,
		 Q => HEX_34);


b2v_dbg_muxC : bus_mux2_8b
PORT MAP(sel => DBG_MODE,
		 busA => DATA_OUT,
		 busB => regC,
		 Q => HEX_56);


b2v_decode_pline_selector : decoder
PORT MAP(addr => SYNTHESIZED_WIRE_2,
		 Q => selector);


SYNTHESIZED_WIRE_18 <= SYNTHESIZED_WIRE_3 OR SYNTHESIZED_WIRE_4 OR SYNTHESIZED_WIRE_5;


b2v_FLAGS : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => FLAG_UP,
		 reset => rst,
		 clk => clk_line,
		 data_in => FLAG_OUT,
		 data_out => regFlags);


b2v_hexA : bcd_to_hex
PORT MAP(bcd_in => HEX_12(3 DOWNTO 0),
		 hex_out => DBG0);


b2v_hexB : bcd_to_hex
PORT MAP(bcd_in => HEX_12(7 DOWNTO 4),
		 hex_out => DBG1);


b2v_hexC : bcd_to_hex
PORT MAP(bcd_in => HEX_34(3 DOWNTO 0),
		 hex_out => DBG2);


b2v_hexD : bcd_to_hex
PORT MAP(bcd_in => HEX_34(7 DOWNTO 4),
		 hex_out => DBG3);


b2v_hexE : bcd_to_hex
PORT MAP(bcd_in => HEX_56(3 DOWNTO 0),
		 hex_out => DBG4);


b2v_hexF : bcd_to_hex
PORT MAP(bcd_in => HEX_56(7 DOWNTO 4),
		 hex_out => DBG5);


SYNTHESIZED_WIRE_13 <= SYNTHESIZED_WIRE_20 AND selector(1);


SYNTHESIZED_WIRE_1 <= NOT(addrBus(15));



SYNTHESIZED_WIRE_15 <= SYNTHESIZED_WIRE_20 AND selector(2);


common_bus <= outMemPline OR SYNTHESIZED_WIRE_8;


SYNTHESIZED_WIRE_11 <= SYNTHESIZED_WIRE_20 AND selector(3);


enc <= updtSelector(3) OR SYNTHESIZED_WIRE_10;


ena <= AUpdate OR updtSelector(1);


SYNTHESIZED_WIRE_0 <= io_regA OR common_bus;


b2v_io_pline : io_pipeline
PORT MAP(clk => clk_line,
		 en => SYNTHESIZED_WIRE_11,
		 reset => rst,
		 iData => IOINBUS,
		 iRegA => regA,
		 op => SYNTHESIZED_WIRE_21,
		 opHigh => dataB,
		 opLow => dataA,
		 fetchE => SYNTHESIZED_WIRE_4,
		 io_write => IOW,
		 io_read => IOR,
		 regA_updt => AUpdate,
		 oAddress => IOADDRESS,
		 oData => IODATA,
		 oRegA => io_regA);


b2v_math_pline : math_pipeline
PORT MAP(clk => clk_line,
		 en => SYNTHESIZED_WIRE_13,
		 reset => rst,
		 flags => regFlags,
		 op => SYNTHESIZED_WIRE_21,
		 regA => regA,
		 regB => regB,
		 writeR => SYNTHESIZED_WIRE_10,
		 fetchE => SYNTHESIZED_WIRE_5,
		 flgUpd => FLAG_UP,
		 outFlg => FLAG_OUT,
		 regC => SYNTHESIZED_WIRE_8);


b2v_mem_pline : memory_pipeline
PORT MAP(clk => clk_line,
		 en => SYNTHESIZED_WIRE_15,
		 reset => rst,
		 i_flags => regFlags,
		 i_mem => DATA_OUT,
		 i_regA => regA,
		 i_regB => regB,
		 i_regC => regC,
		 op => SYNTHESIZED_WIRE_21,
		 opDataH => dataB,
		 opDataL => dataA,
		 fetchE => SYNTHESIZED_WIRE_3,
		 fetchMem => fm,
		 outAddr => outAddr,
		 output => outMemPline,
		 outputPC => PC_IN,
		 updtBus => SYNTHESIZED_WIRE_17);


b2v_memdecode : decoder3
PORT MAP(addr => SYNTHESIZED_WIRE_17,
		 Q => updtSelector);


b2v_op_fetcher : fetcher
PORT MAP(clk => clk_line,
		 fetch_en => SYNTHESIZED_WIRE_18,
		 reset => rst,
		 data_in => DATA_OUT,
		 pline_en => SYNTHESIZED_WIRE_20,
		 pc_en => SYNTHESIZED_WIRE_19,
		 op => SYNTHESIZED_WIRE_21,
		 operand_a => dataA,
		 operand_b => dataB,
		 pline_sel => SYNTHESIZED_WIRE_2);


b2v_program_counter : increment_reg
GENERIC MAP(reg_size => 16
			)
PORT MAP(clock => clk_line,
		 incr_en => SYNTHESIZED_WIRE_19,
		 update => updtSelector(4),
		 reset => rst,
		 inData => PC_IN,
		 outData => PC);


b2v_ram_block : ram
PORT MAP(wren => updtSelector(5),
		 clock => clk_line,
		 address => addrBus,
		 data => outMemPline,
		 q => RAM_DATA);


b2v_rom_block : rom
PORT MAP(clock => clk_line,
		 address => addrBus,
		 q => ROM_DATA);

clk_line <= CLOCK;
rst <= RESET;

END bdf_type;