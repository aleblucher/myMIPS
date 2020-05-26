library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Baseado no apendice C (Register Files) do COD (Patterson & Hennessy).

entity bancoRegistradores is
    generic
    (
        larguraDados        : natural := 32;
        larguraEndBancoRegs : natural := 5   --Resulta em 2^5=32 posicoes
    );
-- Leitura de 2 registradores e escrita em 1 registrador simultaneamente.
    port
    (
        clk        : in std_logic;
--
        enderecoA       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
        enderecoB       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
        enderecoC       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
--
        dadoEscritaC    : in std_logic_vector((larguraDados-1) downto 0);
--
        escreveC        : in std_logic := '0';
        saidaA          : out std_logic_vector((larguraDados -1) downto 0);
        saidaB          : out std_logic_vector((larguraDados -1) downto 0)
    );
end entity;

architecture comportamento of bancoRegistradores is

    subtype palavra_t is std_logic_vector((larguraDados-1) downto 0);
    type memoria_t is array(2**larguraEndBancoRegs-1 downto 0) of palavra_t;
	
	function initMemory
        return memoria_t is variable tmp : memoria_t:= (others => (others => '0'));
	  begin
		-- Inicializa os endereços:
		
		-- $zero (#0) := 0x00
      -- $t0 (#8)  := 0x00
      -- $t1 (#9)  := 0x0A
      -- $t2 (#10) := 0x0B
      -- $t3 (#11) := 0x0C
      -- $t4 (#12) := 0x0D
      -- $t5 (#13) := 0x0E
		
		tmp(0) := x"00000000";
		tmp(9) := x"0000000A";
		tmp(10) := x"0000000B";
		tmp(11) := x"0000000C";
		tmp(12) := x"0000000D";
		tmp(13) := x"0000000E";
		return tmp;
	end initMemory;
	
    -- Declaracao dos registradores:
    shared variable registrador : memoria_t := initMemory;
	 

begin
    process(clk) is
    begin
        if (rising_edge(clk)) then
            if (escreveC = '1') then
                registrador(to_integer(unsigned(enderecoC))) := dadoEscritaC;
            end if;
        end if;
    end process;

    -- IF endereco = 0 : retorna ZERO
     process(all) is
     begin
         if (unsigned(enderecoA) = 0) then
            saidaA <= (others => '0');
         else
            saidaA <= registrador(to_integer(unsigned(enderecoA)));
         end if;
         if (unsigned(enderecoB) = 0) then
            saidaB <= (others => '0');
         else
            saidaB <= registrador(to_integer(unsigned(enderecoB)));
        end if;
     end process;
	  
end architecture;