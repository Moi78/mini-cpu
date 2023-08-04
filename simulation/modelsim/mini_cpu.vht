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

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "08/04/2023 20:14:09"
                                                            
-- Vhdl Test Bench template for design  :  mini_cpu
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY mini_cpu_vhd_tst IS
END mini_cpu_vhd_tst;
ARCHITECTURE mini_cpu_arch OF mini_cpu_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL a : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL b : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL clk : STD_LOGIC;
SIGNAL op : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL pline : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL rom_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL updt : STD_LOGIC;
COMPONENT mini_cpu
	PORT (
	a : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	b : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	clk : IN STD_LOGIC;
	op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	pline : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	rom_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	updt : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : mini_cpu
	PORT MAP (
-- list connections between master ports and signals
	a => a,
	b => b,
	clk => clk,
	op => op,
	pline => pline,
	rom_data => rom_data,
	updt => updt
	);
process
begin
	clk <= '0';
	rom_data <= "10100101";

	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';

	rom_data <= "00001111";

	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';

	rom_data <= "11110000";

	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';

	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';

	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';

	assert false report "FIN" severity failure;
end process;
END mini_cpu_arch;
