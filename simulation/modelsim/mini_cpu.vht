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
-- Generated on "03/28/2024 10:28:26"
                                                            
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
SIGNAL HEX0 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX2 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX4 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX10 : STD_LOGIC;
SIGNAL HEX11 : STD_LOGIC;
SIGNAL HEX12 : STD_LOGIC;
SIGNAL HEX13 : STD_LOGIC;
SIGNAL HEX14 : STD_LOGIC;
SIGNAL HEX15 : STD_LOGIC;
SIGNAL HEX16 : STD_LOGIC;
SIGNAL HEX30 : STD_LOGIC;
SIGNAL HEX31 : STD_LOGIC;
SIGNAL HEX32 : STD_LOGIC;
SIGNAL HEX33 : STD_LOGIC;
SIGNAL HEX34 : STD_LOGIC;
SIGNAL HEX35 : STD_LOGIC;
SIGNAL HEX36 : STD_LOGIC;
SIGNAL HEX50 : STD_LOGIC;
SIGNAL HEX51 : STD_LOGIC;
SIGNAL HEX52 : STD_LOGIC;
SIGNAL HEX53 : STD_LOGIC;
SIGNAL HEX54 : STD_LOGIC;
SIGNAL HEX55 : STD_LOGIC;
SIGNAL HEX56 : STD_LOGIC;
SIGNAL IOADDRESS : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IOINBUS : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL IOR : STD_LOGIC;
SIGNAL IOW : STD_LOGIC;
SIGNAL KEY : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL SW : STD_LOGIC_VECTOR(1 DOWNTO 0);
COMPONENT mini_cpu
	PORT (
	HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6);
	HEX2 : OUT STD_LOGIC_VECTOR(0 TO 6);
	HEX4 : OUT STD_LOGIC_VECTOR(0 TO 6);
	HEX10 : OUT STD_LOGIC;
	HEX11 : OUT STD_LOGIC;
	HEX12 : OUT STD_LOGIC;
	HEX13 : OUT STD_LOGIC;
	HEX14 : OUT STD_LOGIC;
	HEX15 : OUT STD_LOGIC;
	HEX16 : OUT STD_LOGIC;
	HEX30 : OUT STD_LOGIC;
	HEX31 : OUT STD_LOGIC;
	HEX32 : OUT STD_LOGIC;
	HEX33 : OUT STD_LOGIC;
	HEX34 : OUT STD_LOGIC;
	HEX35 : OUT STD_LOGIC;
	HEX36 : OUT STD_LOGIC;
	HEX50 : OUT STD_LOGIC;
	HEX51 : OUT STD_LOGIC;
	HEX52 : OUT STD_LOGIC;
	HEX53 : OUT STD_LOGIC;
	HEX54 : OUT STD_LOGIC;
	HEX55 : OUT STD_LOGIC;
	HEX56 : OUT STD_LOGIC;
	IOADDRESS : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	IOINBUS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	IOR : OUT STD_LOGIC;
	IOW : OUT STD_LOGIC;
	KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : mini_cpu
	PORT MAP (
-- list connections between master ports and signals
	HEX0 => HEX0,
	HEX2 => HEX2,
	HEX4 => HEX4,
	HEX10 => HEX10,
	HEX11 => HEX11,
	HEX12 => HEX12,
	HEX13 => HEX13,
	HEX14 => HEX14,
	HEX15 => HEX15,
	HEX16 => HEX16,
	HEX30 => HEX30,
	HEX31 => HEX31,
	HEX32 => HEX32,
	HEX33 => HEX33,
	HEX34 => HEX34,
	HEX35 => HEX35,
	HEX36 => HEX36,
	HEX50 => HEX50,
	HEX51 => HEX51,
	HEX52 => HEX52,
	HEX53 => HEX53,
	HEX54 => HEX54,
	HEX55 => HEX55,
	HEX56 => HEX56,
	IOADDRESS => IOADDRESS,
	IOINBUS => IOINBUS,
	IOR => IOR,
	IOW => IOW,
	KEY => KEY,
	SW => SW
	);
PROCESS
BEGIN
	KEY(0) <= '0';
	WAIT FOR 100 ns;
	KEY(0) <= '1';
	WAIT FOR 1600 ns;
	ASSERT FALSE REPORT "FIN" SEVERITY FAILURE;
END PROCESS;

PROCESS
BEGIN
	SW(0) <= '0';
	WAIT FOR 10 ns;
	SW(0) <= '1';
	WAIT FOR 10 ns;
END PROCESS;                                            
END mini_cpu_arch;
