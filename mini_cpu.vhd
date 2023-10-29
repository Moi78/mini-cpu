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
-- CREATED		"Sun Oct 29 14:50:48 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY mini_cpu IS 
	PORT
	(
		CLOCK :  IN  STD_LOGIC;
		READSIG :  OUT  STD_LOGIC;
		CARRY :  OUT  STD_LOGIC
	);
END mini_cpu;

ARCHITECTURE bdf_type OF mini_cpu IS 

COMPONENT reg
GENERIC (size : INTEGER
			);
	PORT(en : IN STD_LOGIC;
		 data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT decoder
	PORT(addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT decoder2
	PORT(addr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT math_pipeline
	PORT(clk : IN STD_LOGIC;
		 en : IN STD_LOGIC;
		 op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 regA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 regB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 readR : OUT STD_LOGIC;
		 writeR : OUT STD_LOGIC;
		 fetchE : OUT STD_LOGIC;
		 carry : OUT STD_LOGIC;
		 regC : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT memory_pipeline
	PORT(clk : IN STD_LOGIC;
		 en : IN STD_LOGIC;
		 i_regA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 i_regB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 i_regC : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 opDataH : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 opDataL : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 fetchE : OUT STD_LOGIC;
		 output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 outputPC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 updtBus : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fetcher
	PORT(clk : IN STD_LOGIC;
		 fetch_en : IN STD_LOGIC;
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
		 en : IN STD_LOGIC;
		 inData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 outData : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rom
	PORT(clock : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	dataA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	dataB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	PC :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	PC_IN :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	regC :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ROM_DATA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	selector :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	updtSelector :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_23 <= '0';



b2v_A_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => updtSelector(1),
		 data_in => SYNTHESIZED_WIRE_24,
		 data_out => SYNTHESIZED_WIRE_27);


b2v_B_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => updtSelector(2),
		 data_in => SYNTHESIZED_WIRE_24,
		 data_out => SYNTHESIZED_WIRE_28);


b2v_C_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => SYNTHESIZED_WIRE_2,
		 data_in => SYNTHESIZED_WIRE_24,
		 data_out => regC);


b2v_decode_pline_selector : decoder
PORT MAP(addr => SYNTHESIZED_WIRE_4,
		 Q => selector);


b2v_decode_reg_updt : decoder2
PORT MAP(addr => SYNTHESIZED_WIRE_5,
		 Q => updtSelector);


SYNTHESIZED_WIRE_13 <= SYNTHESIZED_WIRE_25 AND selector(1);


SYNTHESIZED_WIRE_17 <= SYNTHESIZED_WIRE_25 AND selector(2);



SYNTHESIZED_WIRE_21 <= SYNTHESIZED_WIRE_8 OR SYNTHESIZED_WIRE_9;


SYNTHESIZED_WIRE_24 <= SYNTHESIZED_WIRE_10 OR SYNTHESIZED_WIRE_11;


SYNTHESIZED_WIRE_2 <= updtSelector(3) OR SYNTHESIZED_WIRE_12;


b2v_math_pline : math_pipeline
PORT MAP(clk => CLOCK,
		 en => SYNTHESIZED_WIRE_13,
		 op => SYNTHESIZED_WIRE_26,
		 regA => SYNTHESIZED_WIRE_27,
		 regB => SYNTHESIZED_WIRE_28,
		 readR => READSIG,
		 writeR => SYNTHESIZED_WIRE_12,
		 fetchE => SYNTHESIZED_WIRE_9,
		 carry => CARRY,
		 regC => SYNTHESIZED_WIRE_11);


b2v_memory_pline : memory_pipeline
PORT MAP(clk => CLOCK,
		 en => SYNTHESIZED_WIRE_17,
		 i_regA => SYNTHESIZED_WIRE_27,
		 i_regB => SYNTHESIZED_WIRE_28,
		 i_regC => regC,
		 op => SYNTHESIZED_WIRE_26,
		 opDataH => dataB,
		 opDataL => dataA,
		 fetchE => SYNTHESIZED_WIRE_8,
		 output => SYNTHESIZED_WIRE_10,
		 outputPC => PC_IN,
		 updtBus => SYNTHESIZED_WIRE_5);


b2v_op_fetcher : fetcher
PORT MAP(clk => CLOCK,
		 fetch_en => SYNTHESIZED_WIRE_21,
		 data_in => ROM_DATA,
		 pline_en => SYNTHESIZED_WIRE_25,
		 pc_en => SYNTHESIZED_WIRE_22,
		 op => SYNTHESIZED_WIRE_26,
		 operand_a => dataA,
		 operand_b => dataB,
		 pline_sel => SYNTHESIZED_WIRE_4);


b2v_program_counter : increment_reg
GENERIC MAP(reg_size => 16
			)
PORT MAP(clock => CLOCK,
		 incr_en => SYNTHESIZED_WIRE_22,
		 en => SYNTHESIZED_WIRE_23,
		 inData => PC_IN,
		 outData => PC);


b2v_rom_block : rom
PORT MAP(clock => CLOCK,
		 address => PC,
		 q => ROM_DATA);


END bdf_type;