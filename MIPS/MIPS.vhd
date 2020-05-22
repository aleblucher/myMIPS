library ieee;
use ieee.std_logic_1164.all;
use work.constantesMIPS.all;

entity MIPS is
	port
    (
        clk			            : IN  STD_LOGIC
    );
end entity;

architecture comportamento of MIPS is

    signal pontos_controle     : STD_LOGIC_VECTOR(CONTROLWORD_WIDTH-1 DOWNTO 0);
    signal opcode            : STD_LOGIC_VECTOR(OPCODE_WIDTH-1 DOWNTO 0);

begin

    FD : entity work.fluxo_dados 
			port map
			(
				  clk	                    => clk,		  
				  pontos_controle	        => pontos_controle,
				  out_opcode				  => opcode
			 );

			 
    UC : entity work.UC 
			port map
			(
				  opcode              	=> opcode,
				  pontos_controle    	=> pontos_controle
			 );

end architecture;