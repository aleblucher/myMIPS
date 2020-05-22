library ieee;
use ieee.std_logic_1164.all;

entity extendeSinalGenerico is
    generic
    (
        larguraDadoEntrada : natural  :=    8;
        larguraDadoSaida   : natural  :=    14
    );
    port
    (
        -- Input ports
        extendeSinal_IN : in  std_logic_vector(larguraDadoEntrada-1 downto 0);
        -- Output ports
        extendeSinal_OUT: out std_logic_vector(larguraDadoSaida-1 downto 0)
    );
end entity;

architecture comportamento of extendeSinalGenerico is
begin
    process (extendeSinal_IN) is
    begin
            if (extendeSinal_IN(larguraDadoEntrada-1) = '1') then
                extendeSinal_OUT <= (larguraDadoSaida-1 downto larguraDadoEntrada => '1') & extendeSinal_IN;
            else
                extendeSinal_OUT <= (larguraDadoSaida-1 downto larguraDadoEntrada => '0') & extendeSinal_IN;
            end if;
    end process;
end architecture;