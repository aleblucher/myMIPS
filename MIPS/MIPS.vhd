library ieee;
use ieee.std_logic_1164.all;
use work.constantesMIPS.all;

entity MIPS is
	port
    (
        clk			            : IN  STD_LOGIC;
		  test_out_ULA 			: OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		  test_opcode 				: OUT STD_LOGIC_VECTOR(OPCODE_WIDTH-1 DOWNTO 0);
		  test_pontos_controle 	: OUT STD_LOGIC_VECTOR(CONTROLWORD_WIDTH-1 DOWNTO 0);
		  test_PC 					: OUT STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0)
    );
end entity;

architecture comportamento of MIPS is

    signal pontos_controle   		: STD_LOGIC_VECTOR(CONTROLWORD_WIDTH-1 DOWNTO 0);
    signal opcode         		   : STD_LOGIC_VECTOR(OPCODE_WIDTH-1 DOWNTO 0);
	 signal out_ula					: STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	 signal out_pc						: STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);


begin

    FD : entity work.fluxo_dados 
			port map
			(
				  clk	                    => clk,		  
				  pontos_controle	        => pontos_controle,
				  out_opcode				  => opcode,
				  saidaUla					  => out_ula,
				  saidaPC					  => out_pc
			 );

			 
    UC : entity work.UC 
			port map
			(
				  opcode              	=> opcode,
				  pontos_controle    	=> pontos_controle
			 );

		test_out_ULA <= out_ula;
		test_opcode <= opcode;
		test_pontos_controle <= pontos_controle;
		test_PC<= out_pc;
end architecture;