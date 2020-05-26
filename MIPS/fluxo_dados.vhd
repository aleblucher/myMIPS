library ieee;
use ieee.std_logic_1164.all;
use work.constantesMIPS.all;

entity fluxo_dados is
	port
    (
        clk			          	  : IN STD_LOGIC;
        pontos_controle	        : IN STD_LOGIC_VECTOR(CONTROLWORD_WIDTH-1 DOWNTO 0);
		  out_opcode				  : OUT STD_LOGIC_VECTOR(OPCODE_WIDTH-1 DOWNTO 0);
		  saidaUla 					  : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		  saidaPC					  : OUT STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0)
    );
	 
end entity;

architecture comportamento of fluxo_dados is

signal out_rom, out_pc, out_mux_0, out_mux_4, out_estende, out_ULA, out_adder_1, out_adder_2, in_mux_0, out_shift_2: std_logic_vector(ADDR_WIDTH -1 downto 0);

signal out_mux_3,  out_bank_1, out_bank_2, out_mux_2, out_ram_read: std_logic_vector(DATA_WIDTH -1 downto 0);
signal out_mux_1: std_logic_vector(REGBANK_ADDR_WIDTH - 1 downto 0);
signal ULActr: std_logic_vector(CTRL_ALU_WIDTH-1 downto 0);
signal out_shift_1: std_logic_vector(27 downto 0);
signal out_Z, sel_mux_4: std_logic;

-- pontos_controle alias:
 alias sel_mux_jump      : std_logic is pontos_controle(9);
 alias sel_mux_rd_rt     : std_logic is pontos_controle(8);
 alias escreve_RC        : std_logic is pontos_controle(7);
 alias sel_mux_banco_ula : std_logic is pontos_controle(6);
 alias ULAop             : std_logic_vector(ALU_OP_WIDTH-1 downto 0) is pontos_controle(5 downto 4);
 alias sel_mux_ula_mem   : std_logic is pontos_controle(3);
 alias sel_beq           : std_logic is pontos_controle(2);
 alias leitura_RAM       : std_logic is pontos_controle(1);
 alias escreve_RAM       : std_logic is pontos_controle(0);
 
-- instruction alias:

-- RS
alias addr_reg_1: 		std_logic_vector is out_rom(25 downto 21);
-- RT
alias addr_reg_2: 		std_logic_vector is out_rom(20 downto 16);
-- RD
alias addr_reg_3: 		std_logic_vector is out_rom(15 downto 11);
-- Imediato J
alias imediato_J:			std_logic_vector is out_rom(25 downto 0);
-- Imediato I
alias imediato_I:			std_logic_vector is out_rom(15 downto 0);
-- Opcode
alias opcode:				std_logic_vector is out_rom(31 downto 26);
-- Funct
alias funct: 				std_logic_vector is out_rom(5 downto 0);


begin
	out_opcode <= opcode;
	
------------------------------------------------------------------------
	PC: entity work.registradorGenerico
				generic map (
					larguraDados => ADDR_WIDTH -- 32
				)
            port map (
					CLK 		=> clk, 
					DIN 		=> out_mux_0,
					DOUT 		=> out_PC,
					ENABLE 	=> '1', 
					RST 		=> '0'
				);
	saidaPC <= out_PC;
	
------------------------------------------------------------------------	
	ROM: entity work.memoriaROM
				generic map (
					dataWidth => DATA_WIDTH, -- 32
					addrWidth => ADDR_WIDTH  -- 32
				)
				port map(
					Endereco => out_PC,
					Dado 		=> out_rom
				);
				
------------------------------------------------------------------------				
-- Mux RD/RT
	Mux1: entity work.muxGenerico2x1
				generic map(
					larguraDados => REGBANK_ADDR_WIDTH  -- 5
				)
				port map(
					entradaA_MUX 	=> addr_reg_2,
					entradaB_MUX 	=> addr_reg_3,
					seletor_MUX 	=> sel_mux_rd_rt,
					saida_MUX	 	=> out_mux_1
				);
				
------------------------------------------------------------------------
	Banco_Regs: entity work.bancoRegistradores
				generic map(
					larguraDados        => DATA_WIDTH,			-- 32
					larguraEndBancoRegs => REGBANK_ADDR_WIDTH	-- 5
				)
				port map(
					clk          	=> clk,
					enderecoA 		=> addr_reg_1,
					enderecoB 		=> addr_reg_2,
					enderecoC 		=> out_mux_1,
					dadoEscritaC 	=> out_mux_3,
					escreveC     	=> escreve_RC,	
					saidaA       	=> out_bank_1,
					saidaB       	=> out_bank_2
				);	
		
------------------------------------------------------------------------
-- Mux Banco/Ula
	Mux2: entity work.muxGenerico2x1
				generic map(
					larguraDados => DATA_WIDTH -- 32
				)
				port map(
					entradaA_MUX 	=> out_bank_2,
					entradaB_MUX 	=> out_estende,
					seletor_MUX 	=> sel_mux_banco_ula,
					saida_MUX	 	=> out_mux_2
				);	
				
------------------------------------------------------------------------
	Extensor: entity work.extendeSinalGenerico 
				generic map (
					larguraDadoEntrada => 16,			-- 16
					larguraDadoSaida   => ADDR_WIDTH -- 32
				)
				port map (
					extendeSinal_IN  => imediato_I,
					extendeSinal_OUT => out_estende
				);
				
------------------------------------------------------------------------				
     ULA: entity work.ULA
        generic map (
            NUM_BITS => DATA_WIDTH	-- 32
        )
		port map (
            A   => out_bank_1,
            B   => out_mux_2,
            ctr => ULActr,
            C   => out_ULA,
            Z   => out_Z
        );
	saidaUla <= out_ULA;
	
------------------------------------------------------------------------
	 UC_ULA : entity work.UC_ULA 
        port map
        (
            funct  => funct,    
            ALUop  => ULAop,
            ALUctr => ULActr
        );

------------------------------------------------------------------------
	 RAM: entity work.memoriaRAM 
        generic map (
            dataWidth => DATA_WIDTH, -- 32
            addrWidth => ADDR_WIDTH  -- 32
        )
			port map (
            endereco    => out_ULA, 
				we          => escreve_RAM,
            re          => leitura_RAM,
            clk         => clk,
            dado_write  => out_bank_2,
            dado_read   => out_ram_read
        ); 
		  
------------------------------------------------------------------------
-- Mux Ula/Memoria
	Mux3: entity work.muxGenerico2x1
				generic map(
					larguraDados => DATA_WIDTH -- 32
				)
				port map(
					entradaA_MUX 	=> out_ULA,
					entradaB_MUX 	=> out_ram_read, 
					seletor_MUX		=> sel_mux_ula_mem,
					saida_MUX	 	=> out_mux_3
				);	
				
------------------------------------------------------------------------
-- Mux 4
	sel_mux_4 <= sel_beq and out_Z;
	Mux4: entity work.muxGenerico2x1
				generic map(
					larguraDados => DATA_WIDTH -- 32
				)
				port map(
					entradaA_MUX	=> out_adder_1,
					entradaB_MUX 	=> out_adder_2, 
					seletor_MUX 	=> sel_mux_4,
					saida_MUX	 	=> out_mux_4
				);	
	
------------------------------------------------------------------------
     shift_1: entity work.shift2 
			  generic map (
					larguraDado => 26 --26
			  )
				port map (
					shift_IN  => imediato_J,
					shift_OUT => out_shift_1
			  );
    	
------------------------------------------------------------------------				
-- Mux Jump
	in_mux_0 <= out_adder_1(31 downto 28) & out_shift_1;	
	Mux0: entity work.muxGenerico2x1
				generic map(
					larguraDados => DATA_WIDTH -- 32
				)
				port map(
					entradaA_MUX 	=> out_mux_4,
					entradaB_MUX 	=> in_mux_0, 
					seletor_MUX 	=> sel_mux_jump,
					saida_MUX		=> out_mux_0
				);	

------------------------------------------------------------------------				
	SomadorConstante: entity work.somaConstante
				generic map(
					larguraDados => DATA_WIDTH,  -- 32
					constante => 4					  -- 4
				)
				port map(
					entrada 	=> out_PC,
					saida 	=> out_adder_1
				);
	
------------------------------------------------------------------------	
	shift_2: entity work.shift2_imediato 
			  generic map (
					larguraDado => DATA_WIDTH		-- 32
			  )
				port map (
						shift_IN  => out_estende,
						shift_OUT => out_shift_2
				  );
    
------------------------------------------------------------------------	
	Somador: entity work.somador
				generic map (
					larguraDados => DATA_WIDTH		-- 32
				)
				port map(
					entradaA => out_adder_1,
					entradaB => out_shift_2,
					saida 	=> out_adder_2
				);
------------------------------------------------------------------------

end architecture;
				
				