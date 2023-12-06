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
-- Generated on "12/06/2023 11:06:22"
                                                            
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
SIGNAL CLOCK : STD_LOGIC;
COMPONENT mini_cpu
	PORT (
	CLOCK : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : mini_cpu
	PORT MAP (
-- list connections between master ports and signals
	CLOCK => CLOCK
	);
PROCESS
BEGIN
	WAIT FOR 1600 ns;
	ASSERT FALSE REPORT "FIN" SEVERITY FAILURE;
END PROCESS;

PROCESS
BEGIN
	CLOCK <= '0';
	WAIT FOR 10 ns;
	CLOCK <= '1';
	WAIT FOR 10 ns;
END PROCESS;                                          
END mini_cpu_arch;
