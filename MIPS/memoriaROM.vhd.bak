library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 8;
          addrWidth: natural := 14;
			 oPcode_Width: natural := 4
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

-- Formato das instrucoes:
--alias enderecoRAM: std_logic_vector(addrWidth-1 DOWNTO 0) is Instrucao(addrWidth-1 downto 0);
--alias imediatoDado: std_logic_vector (dataWidth-1 DOWNTO 0) is Instrucao(dataWidth-1 downto 0);
--alias imediatoEndereco: std_logic_vector (addrWidth-1 DOWNTO 0) is Instrucao(addrWidth-1 downto 0);
--
--alias habLeituraBarramento: std_logic is Instrucao(dataROMWidth-1);
--alias habEscritaBarramento: std_logic is Instrucao(dataROMWidth-2);
--alias habAcumulador: std_logic is Instrucao(dataROMWidth-3);
--alias sel_Imediato_RAM: std_logic is Instrucao(dataROMWidth-4);
--alias operacaoULA: std_logic is Instrucao(dataROMWidth-5);
--alias sel_MUX_Jump: std_logic is Instrucao(dataROMWidth-6);

--Bit Instrucao---->        14                   13               12              11          10,9           8         7~0
--Instrução       |habLeituraBarramento|habEscritaBarramento|habAcumulador|sel_Imediato_RAM|operacaoULA|sel_MUX_Jump|Imediato| 
--Soma RAM        |          1         |         0          |      1      |       0        |    00     |     0      |Endereco|
--Soma Imediato   |          1         |         0          |      1      |       1        |    00     |     0      | Valor  |
--Subtrai RAM     |          1         |         0          |      1      |       0        |    01     |     0      |Endereco|
--Subtrai Imediato|          1         |         0          |      1      |       1        |    00     |     0      | Valor  |
--LW              |          1         |         0          |      1      |       0        |    1X     |     0      |Endereco|
--SW              |          0         |         1          |      0      |       X        |     X     |     0      |Endereco|
--J               |          0         |         0          |      0      |       X        |     X     |     1      |Endereco|

--Soma RAM:     1010000_EnderecoRAM
--Subtrai RAM:  1010010_EnderecoRAM
--Soma Imed:    1011000_Imediato
--Subtrai Imed: 1011010_EnderecoRAM
--LW:           1010100_EnderecoRAM
--SW:           0100100_EnderecoRAM
--Jump:         0000001_EnderecoROM

-- "0000";	-- add
-- "0001";	-- sub
-- "0110";	-- and
-- "0111";	-- or
-- "1001";	-- xor
-- "1000";	-- not
-- "0010";	-- jump
-- "0100";	-- load
-- "0101";	-- store
-- "0011";	-- beq



subtype opCode_t is std_logic_vector(oPcode_Width-1 downto 0);
constant add    	  : opCode_t := "0000";
constant sub		  : opCode_t := "0001";
constant jump	     : opCode_t := "0010";
constant beq		  : opCode_t := "0011";
constant LW         : opCode_t := "0100";
constant SW         : opCode_t := "0101";
constant inst_and     : opCode_t := "0110";
constant inst_or      : opCode_t := "0111";
constant inst_not     : opCode_t := "1000";
constant inst_xor     : opCode_t := "1001";
constant addi	  	  : opCode_t := "1010";


constant op_add    	  : std_logic_vector(7 downto 0) := "00000001";
constant op_sub		  : std_logic_vector(7 downto 0) := "00000010";
constant op_mult		  : std_logic_vector(7 downto 0) := "00000100";
constant op_div		  : std_logic_vector(7 downto 0) := "00001000";
constant op_or			  : std_logic_vector(7 downto 0) := "00010000";
constant op_xor		  : std_logic_vector(7 downto 0) := "00100000";
constant op_and		  : std_logic_vector(7 downto 0) := "01000000";
constant op_not		  : std_logic_vector(7 downto 0) := "10000000";


constant R0				  : std_logic_vector(2 downto 0) := "000";
constant R1				  : std_logic_vector(2 downto 0) := "001";
constant R2				  : std_logic_vector(2 downto 0) := "010";
constant R3				  : std_logic_vector(2 downto 0) := "011";
constant R4				  : std_logic_vector(2 downto 0) := "100";
constant R5				  : std_logic_vector(2 downto 0) := "101";
constant R6				  : std_logic_vector(2 downto 0) := "110";
constant R7				  : std_logic_vector(2 downto 0) := "111";

-- Enderecos (8 bits)
constant botao				: std_logic_vector(7 downto 0) := "10000111"; 
--constant led_red_low		: std_logic_vector(7 downto 0) := ""; 
--constant led_red_high	: std_logic_vector(7 downto 0) := ""; 
constant sw_17				: std_logic_vector(7 downto 0) := "10000100"; -- 132
constant sw_16				: std_logic_vector(7 downto 0) := "10000101"; -- 133
constant sw_high			: std_logic_vector(7 downto 0) := "10000011"; -- 131
constant sw_low			: std_logic_vector(7 downto 0) := "10000010"; -- 130
constant hex_0_1			: std_logic_vector(7 downto 0) := "11001101"; -- 205
constant hex_2_3			: std_logic_vector(7 downto 0) := "11001110"; -- 206
constant hex_4_5			: std_logic_vector(7 downto 0) := "11001111"; -- 207
constant hex_6_7			: std_logic_vector(7 downto 0) := "11010000"; -- 208


constant inicio_tipo_I				: std_logic_vector(7 downto 0) := "00000000";
constant inicio_tipo_J				: std_logic_vector(13 downto 0) := "00000000000000";

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
  -- Inst I:
  --		Opcode (4 bits) + Reg3 (3 bits) + Reg1 (3 bits) + Imediato (8 bits)
  
  
 -- CUIDADO COM beq: O endereco passado para ele deve ser relativo a posicao atual do PC.
  
        
		  tmp(0) := LW & R3 & R0 & sw_17; 					-- carrega o SW de operacao
		  
		  tmp(1) := beq & R3 & R0 & "11111110"; 			-- checa se o SW de operacao e diferente de 0 se nao volta pro inicio
		  
		  tmp(2) := LW & R4 & R0 & sw_16;					-- carrega o valor do botao de confirmar
		  
		  tmp(3) := beq & R4 & R0 & "11111100"; 			-- checa se o botao ainda nao foi 												pressionado e continua lendo os SWs ate ser
		  tmp(4) := LW & R1 & R0 & sw_high;					-- carrega a primeria metada do input
		  
		  tmp(5) := LW & R2 & R0 & sw_low;					-- carrega a segunda metada do input
		  
		  tmp(6) := beq & R1 & R0 & "00000101";			-- para o tmp 10
		  
		  tmp(7) := add & R6 & R2 & R2 & "00000";
		  
		  tmp(8) := SW & R6 & R0 & hex_0_1;
		  
		  tmp(10) := addi & R1 & "11111111111"; --"00100000"; -- R2 & 00000
		  
		  tmp(11) := SW & R1 & R0 & hex_2_3;
		  
		  tmp(12) := jump & "00000000000110" ; -- para o tmp 6
		  
		  tmp(13) := SW & R2 & R0 & hex_0_1;
		  
		  tmp(14) := jump & inicio_tipo_J;
		  
		  
--		  tmp(0) := LW & R3 & R0 & sw_super_high;
--		  tmp(1) := add & "001" & "001" & "001" & "00000";
--        tmp(2) := SW & "001" & "000" & "11001000";  --Endereco 200 Escreve LEDs
---- 	  tmp(3) := beq & "001" & "001" & "00000010";  -- Soma 1
--		  tmp(4) := SW & "001" & "000" & "11001101";  --Endereco 200 Escreve LEDs
----        tmp(4) := SW & "01000000";  --Endereco 64  Salva RAM
----		  tmp(5) := SomaImed & "00000001";   -- Soma 1
----        tmp(6) := SW & "01000001";  --Endereco 65
----		  tmp(7) := LW & "01000000";  --Endereco 64  Le RAM
----		  tmp(8) := LW & "01000001";  --Endereco 65  Le RAM
----		  tmp(9) := SW & "11000000";  --Endereco 192 Escreve LEDs

--	Fim:
--        tmp(5) := Jump & ;
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;
