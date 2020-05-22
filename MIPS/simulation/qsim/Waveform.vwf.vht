-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "05/22/2020 12:36:53"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          MIPS
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY MIPS_vhd_vec_tst IS
END MIPS_vhd_vec_tst;
ARCHITECTURE MIPS_arch OF MIPS_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL test_opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL test_out_ULA : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL test_PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL test_pontos_controle : STD_LOGIC_VECTOR(10 DOWNTO 0);
COMPONENT MIPS
	PORT (
	clk : IN STD_LOGIC;
	test_opcode : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	test_out_ULA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	test_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	test_pontos_controle : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : MIPS
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	test_opcode => test_opcode,
	test_out_ULA => test_out_ULA,
	test_PC => test_PC,
	test_pontos_controle => test_pontos_controle
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 50000 ps;
	clk <= '1';
	WAIT FOR 50000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;
END MIPS_arch;
