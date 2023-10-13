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
-- CREATED		"Fri Oct 13 22:00:29 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY mini_cpu IS 
	PORT
	(
		CLOCK :  IN  STD_LOGIC;
		DATA_IN :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
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
		 updtBus : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
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

COMPONENT decoder
GENERIC (addr_size : INTEGER
			);
	PORT(addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	dataA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	dataB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	regC :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	selector :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	updtSelector :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC_VECTOR(1 DOWNTO 0);


BEGIN 



b2v_A_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => updtSelector(0),
		 data_in => SYNTHESIZED_WIRE_20,
		 data_out => SYNTHESIZED_WIRE_22);


b2v_B_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => updtSelector(1),
		 data_in => SYNTHESIZED_WIRE_20,
		 data_out => SYNTHESIZED_WIRE_16);


b2v_C_Register : reg
GENERIC MAP(size => 8
			)
PORT MAP(en => updtSelector(2),
		 data_in => SYNTHESIZED_WIRE_20,
		 data_out => regC);


SYNTHESIZED_WIRE_13 <= SYNTHESIZED_WIRE_21 AND selector(1);


b2v_inst1 : memory_pipeline
PORT MAP(clk => CLOCK,
		 en => SYNTHESIZED_WIRE_4,
		 i_regA => SYNTHESIZED_WIRE_22,
		 i_regB => SYNTHESIZED_WIRE_22,
		 i_regC => regC,
		 op => SYNTHESIZED_WIRE_23,
		 opDataH => dataB,
		 opDataL => dataA,
		 fetchE => SYNTHESIZED_WIRE_9,
		 output => SYNTHESIZED_WIRE_11,
		 updtBus => SYNTHESIZED_WIRE_19);


SYNTHESIZED_WIRE_4 <= SYNTHESIZED_WIRE_21 AND selector(2);


SYNTHESIZED_WIRE_17 <= SYNTHESIZED_WIRE_9 OR SYNTHESIZED_WIRE_10;


SYNTHESIZED_WIRE_20 <= SYNTHESIZED_WIRE_11 OR SYNTHESIZED_WIRE_12;


b2v_math_pline : math_pipeline
PORT MAP(clk => CLOCK,
		 en => SYNTHESIZED_WIRE_13,
		 op => SYNTHESIZED_WIRE_23,
		 regA => SYNTHESIZED_WIRE_22,
		 regB => SYNTHESIZED_WIRE_16,
		 readR => READSIG,
		 writeR => updtSelector(2),
		 fetchE => SYNTHESIZED_WIRE_10,
		 carry => CARRY,
		 regC => SYNTHESIZED_WIRE_12);


b2v_op_fetcher : fetcher
PORT MAP(clk => CLOCK,
		 fetch_en => SYNTHESIZED_WIRE_17,
		 data_in => DATA_IN,
		 pline_en => SYNTHESIZED_WIRE_21,
		 op => SYNTHESIZED_WIRE_23,
		 operand_a => dataA,
		 operand_b => dataB,
		 pline_sel => SYNTHESIZED_WIRE_18);


b2v_PipelineSelector : decoder
GENERIC MAP(addr_size => 4
			)
PORT MAP(addr => SYNTHESIZED_WIRE_18,
		 Q => selector);


b2v_reg_update_decode : decoder
GENERIC MAP(addr_size => 2
			)
PORT MAP(addr => SYNTHESIZED_WIRE_19,
		 Q => updtSelector);


END bdf_type;