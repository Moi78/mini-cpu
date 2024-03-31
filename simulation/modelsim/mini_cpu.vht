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
-- Generated on "03/28/2024 21:20:43"
                                                            
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
SIGNAL HEX1 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX2 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX3 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX4 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX5 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL IOADDRESS : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IOINBUS : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL IOR : STD_LOGIC;
SIGNAL IOW : STD_LOGIC;
SIGNAL KEY : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL LEDR : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL MAX10_CLK1_50 : STD_LOGIC;
SIGNAL SW : STD_LOGIC_VECTOR(1 DOWNTO 1);
COMPONENT mini_cpu
	PORT (
	HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6);
	HEX1 : OUT STD_LOGIC_VECTOR(0 TO 6);
	HEX2 : OUT STD_LOGIC_VECTOR(0 TO 6);
	HEX3 : OUT STD_LOGIC_VECTOR(0 TO 6);
	HEX4 : OUT STD_LOGIC_VECTOR(0 TO 6);
	HEX5 : OUT STD_LOGIC_VECTOR(0 TO 6);
	IOADDRESS : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	IOINBUS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	IOR : OUT STD_LOGIC;
	IOW : OUT STD_LOGIC;
	KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	LEDR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	MAX10_CLK1_50 : IN STD_LOGIC;
	SW : IN STD_LOGIC_VECTOR(1 DOWNTO 1)
	);
END COMPONENT;
BEGIN
	i1 : mini_cpu
	PORT MAP (
-- list connections between master ports and signals
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	HEX4 => HEX4,
	HEX5 => HEX5,
	IOADDRESS => IOADDRESS,
	IOINBUS => IOINBUS,
	IOR => IOR,
	IOW => IOW,
	KEY => KEY,
	LEDR => LEDR,
	MAX10_CLK1_50 => MAX10_CLK1_50,
	SW => SW
	);
PROCESS
BEGIN
	KEY(0) <= '0';
	WAIT FOR 100 ns;
	KEY(0) <= '1';
	WAIT FOR 5600 ns;
	ASSERT FALSE REPORT "FIN" SEVERITY FAILURE;
END PROCESS;

PROCESS
BEGIN
	MAX10_CLK1_50 <= '0';
	WAIT FOR 10 ns;
	MAX10_CLK1_50 <= '1';
	WAIT FOR 10 ns;
END PROCESS;                                           
END mini_cpu_arch;
