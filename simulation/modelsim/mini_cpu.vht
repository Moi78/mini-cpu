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
-- Generated on "08/26/2023 16:55:15"
                                                            
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
SIGNAL A : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL B : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL C : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL CARRY : STD_LOGIC;
SIGNAL CLOCK : STD_LOGIC;
SIGNAL EN : STD_LOGIC;
SIGNAL FETCHEN : STD_LOGIC;
SIGNAL OPCODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL READSIG : STD_LOGIC;
SIGNAL WRITESIG : STD_LOGIC;
COMPONENT mini_cpu
	PORT (
	A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	C : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	CARRY : OUT STD_LOGIC;
	CLOCK : IN STD_LOGIC;
	EN : IN STD_LOGIC;
	FETCHEN : OUT STD_LOGIC;
	OPCODE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	READSIG : OUT STD_LOGIC;
	WRITESIG : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : mini_cpu
	PORT MAP (
-- list connections between master ports and signals
	A => A,
	B => B,
	C => C,
	CARRY => CARRY,
	CLOCK => CLOCK,
	EN => EN,
	FETCHEN => FETCHEN,
	OPCODE => OPCODE,
	READSIG => READSIG,
	WRITESIG => WRITESIG
	);
process begin
	EN <= '0';
	OPCODE <= "0001";
	A <= "00000101";
	B <= "00001010";
	EN <= '1';

	WAIT FOR 100 us;
	ASSERT FALSE REPORT "FIN" SEVERITY FAILURE;
end process;

process begin
	CLOCK <= '1';
	WAIT FOR 10 ns;
	CLOCK <= '0';
	WAIT FOR 10 ns;
end process;                                        
END mini_cpu_arch;
