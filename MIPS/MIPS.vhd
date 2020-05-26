library ieee;
use ieee.std_logic_1164.all;
use work.constantesMIPS.all;

entity MIPS is
	port
    (
        CLOCK_50			      : IN  STD_LOGIC;
		  KEY	      				: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		  HEX0, HEX1, HEX2, HEX3, HEX6, HEX7: OUT STD_LOGIC_VECTOR(6 downto 0); -- 7-segments Display
		  
		  -- realizacao de testes
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
	 signal btn_clock 				: STD_LOGIC := '0';

begin
------------------------------------------------------------------------
	 BTN_CLK : entity work.edgeDetector port map 
	 (
			clk 		=> CLOCK_50, 
			entrada 	=> not KEY(0), 
			saida 	=> btn_clock
	);
	
------------------------------------------------------------------------
--- Display ULA ---
	 DISPLAY0 : entity work.conversorHex7seg port map (saida7seg => HEX0, dadoHex => out_ula(3 DOWNTO 0));
	 DISPLAY1 : entity work.conversorHex7seg port map (saida7seg => HEX1, dadoHex => out_ula(7 DOWNTO 4));
	 
--- Display Vazio ---
	 DISPLAY2 : entity work.conversorHex7seg port map (saida7seg => HEX2, dadoHex => "0000");	 
	 DISPLAY3 : entity work.conversorHex7seg port map (saida7seg => HEX3, dadoHex => "0000");	 
	 
--- Display PC ---
	 DISPLAY6 : entity work.conversorHex7seg port map (saida7seg => HEX6, dadoHex => out_pc(3 DOWNTO 0));
	 DISPLAY7 : entity work.conversorHex7seg port map (saida7seg => HEX7, dadoHex => out_pc(7 DOWNTO 4));

------------------------------------------------------------------------
    FD : entity work.fluxo_dados 
			port map
			(
				  clk	                    => btn_clock,		  
				  pontos_controle	        => pontos_controle,
				  out_opcode				  => opcode,
				  saidaUla					  => out_ula,
				  saidaPC					  => out_pc
			 );

------------------------------------------------------------------------			 
    UC : entity work.UC 
			port map
			(
				  opcode              	=> opcode,
				  pontos_controle    	=> pontos_controle
			 );
			 
------------------------------------------------------------------------
		test_out_ULA 			<= out_ula;
		test_opcode 			<= opcode;
		test_pontos_controle <= pontos_controle;
		test_PC					<= out_pc;
------------------------------------------------------------------------
		
end architecture;