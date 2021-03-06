library ieee;
use ieee.std_logic_1164.all;
use work.constantesMIPS.all;

entity UC is
	port
    (
        opcode              	: IN STD_LOGIC_VECTOR(OPCODE_WIDTH-1 DOWNTO 0);
        pontos_controle    	: OUT STD_LOGIC_VECTOR(CONTROLWORD_WIDTH-1 DOWNTO 0)
    );
end entity;


architecture comportamento of UC is
begin	 
		-- Construindo os pontos de controle a partir do tipo do opcode
		pontos_controle <= 	ctrlTipoR 	when (opcode = opCodeTipoR) 	else
			
									ctrlTipoSW 	when (opcode = opCodeSW) 		else
								
									ctrlTipoLW 	when (opcode = opCodeLW)		else
								
									ctrlTipoBEQ when (opcode = opCodeBEQ) 		else
								
									ctrlTipoJ 	when (opcode = opCodeTipoJ) 	else 
								
									ctrlZERO; -- nop

end architecture;