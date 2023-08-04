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
-- CREATED		"Fri Aug  4 20:14:01 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY mini_cpu IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		rom_data :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		updt :  OUT  STD_LOGIC;
		a :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		b :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		op :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		pline :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END mini_cpu;

ARCHITECTURE bdf_type OF mini_cpu IS 

COMPONENT fetcher
	PORT(clk : IN STD_LOGIC;
		 fetch_en : IN STD_LOGIC;
		 data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 reg_updt : OUT STD_LOGIC;
		 pc_en : OUT STD_LOGIC;
		 op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 operand_a : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 operand_b : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pline_sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_0 <= '1';



b2v_inst : fetcher
PORT MAP(clk => clk,
		 fetch_en => SYNTHESIZED_WIRE_0,
		 data_in => rom_data,
		 reg_updt => updt,
		 op => op,
		 operand_a => a,
		 operand_b => b,
		 pline_sel => pline);



END bdf_type;