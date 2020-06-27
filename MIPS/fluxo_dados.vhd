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


-- PipeLines
	 signal saidaP1 : std_logic_vector(63 downto 0)  := (others=> '0'); -- 64
	 signal entradaP2, saidaP2 : std_logic_vector(146 downto 0) := (others=> '0');
	 signal entradaP3, saidaP3 : std_logic_vector(106 downto 0) := (others=> '0');
	 signal entradaP4, saidaP4 : std_logic_vector(70 downto 0)  := (others=> '0');
	 
-- instruction alias:
	-- (REG_IF_ID)

-- RS
alias addr_reg_1: 		std_logic_vector is saidaP1(25 downto 21); --RS
-- RT
alias addr_reg_2: 		std_logic_vector is saidaP1(20 downto 16); --RT
-- RD
alias addr_reg_3: 		std_logic_vector is saidaP1(15 downto 11); --RD
-- Imediato J
alias imediato_J:			std_logic_vector is saidaP1(25 downto 0);
-- Imediato I
alias imediato_I:			std_logic_vector is saidaP1(15 downto 0);
-- Opcode
alias opcode:				std_logic_vector is saidaP1(31 downto 26);
-- Funct
alias funct: 				std_logic_vector is saidaP1(5 downto 0);





begin

-- PIPELINES

---------------------------REGISTRADOR 1 ------------------------------
		 REG_IF_ID : entity work.registradorGenerico
			  generic map(
					larguraDados => 64
			  )
			  port map(				
					CLK 		=> clk, 
					DIN 		=> out_adder_1 & out_rom,
					DOUT 		=> saidaP1,
					ENABLE 	=> '1', 
					RST 		=> '0'
			  );
		  
	
---------------------------REGISTRADOR 2 ------------------------------
		  
		 --ID/EX: 
			entradaP2(4 downto 0)		<= saidaP1(20 downto 16); --pipeline1: RT_addr
			entradaP2(9 downto 5)		<= saidaP1(15 downto 11); --pipeline1: RD_addr
			entradaP2(41 downto 10)		<= out_estende;
			entradaP2(73 downto 42)		<= out_bank_1; 			
			entradaP2(105 downto 74)	<= out_bank_2; 
			entradaP2(137 downto 106)	<= saidaP1(63 downto 32);  --pipeline1: PC_mais_4
			entradaP2(138)					<= sel_mux_banco_ula;
			entradaP2(140 downto 139)	<= ULAop;
			entradaP2(141)					<= sel_mux_rd_rt;
			entradaP2(142)					<= escreve_RAM;
			entradaP2(143)					<= leitura_RAM;
			entradaP2(144)					<= sel_beq;
			entradaP2(145)					<= sel_mux_ula_mem;
			entradaP2(146)					<= escreve_RC;
			
			
			
			REG_ID_EX : entity work.registradorGenerico
        generic map(
            larguraDados => 147
        )
        port map(
				CLK 		=> clk, 
				DIN 		=> entradaP2,
				DOUT 		=> saidaP2,
				ENABLE 	=> '1', 
				RST 		=> '0'
        );
		  
		  
---------------------------REGISTRADOR 3 ------------------------------

			-- Pipeline Registrador EX/MEM:
			entradaP3(4 downto 0)		<= out_mux_1;
			entradaP3(36 downto 5)		<= saidaP2(105 downto 74);
			entradaP3(68 downto 37)		<= out_ULA;
			entradaP3(69)					<= out_Z;
			entradaP3(101 downto 70)	<= out_adder_2;
			entradaP3(102)					<= saidaP2(142);
			entradaP3(103)					<= saidaP2(143);
			entradaP3(104)					<= saidaP2(144);
			entradaP3(105)					<= saidaP2(145);
			entradaP3(106)					<= saidaP2(146);


		REG_EX_MEM : entity work.registradorGenerico
        generic map(
            larguraDados => 107
        )
        port map(
				CLK 		=> clk, 
				DIN 		=> entradaP3,
				DOUT 		=> saidaP3,
				ENABLE 	=> '1', 
				RST 		=> '0'
        );
---------------------------REGISTRADOR 4 ------------------------------

		-- Pipeline Registrador MEM/WB:
			entradaP4(4 downto 0) 	<= saidaP3(4 downto 0);
			entradaP4(36 downto 5) 	<= saidaP3(68 downto 37);
			entradaP4(68 downto 37) <= out_ram_read;
			entradaP4(69)				<= saidaP3(105);
			entradaP4(70)				<= saidaP3(106);

		REG_MEM_WB : entity work.registradorGenerico
        generic map(
            larguraDados => 71
        )
        port map(
				CLK 		=> clk, 
				DIN 		=> entradaP4,
				DOUT 		=> saidaP4,
				ENABLE 	=> '1', 
				RST 		=> '0'
        );

-----------------------------------------------------------------------
	out_opcode <= opcode;
------------------------------------------------------------------------
-- check pipeline: ok!
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
-- check pipeline: ok!	
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
-- check pipeline: ok!				
-- Mux RD/RT
	Mux1: entity work.muxGenerico2x1
				generic map(
					larguraDados => REGBANK_ADDR_WIDTH  -- 5
				)
				port map(
					entradaA_MUX 	=> saidaP2(4 downto 0), --addr_reg_2
					entradaB_MUX 	=> saidaP2(9 downto 5), --addr_reg_3
					seletor_MUX 	=> saidaP2(141),			--sel_mux_rd_rt
					saida_MUX	 	=> out_mux_1
				);
				
------------------------------------------------------------------------
-- check pipeline: ok!
	Banco_Regs: entity work.bancoRegistradores
				generic map(
					larguraDados        => DATA_WIDTH,			-- 32
					larguraEndBancoRegs => REGBANK_ADDR_WIDTH	-- 5
				)
				port map(
					clk          	=> clk,
					enderecoA 		=> saidaP1(25 downto 21),
					enderecoB 		=> saidaP1(20 downto 16),
					enderecoC 		=> saidaP4(4 downto 0),
					dadoEscritaC 	=> out_mux_3,
					escreveC     	=> saidaP4(70),	
					saidaA       	=> out_bank_1,
					saidaB       	=> out_bank_2
				);	
		
------------------------------------------------------------------------
-- Mux Banco/Ula
-- check pipeline: ok!
	Mux2: entity work.muxGenerico2x1
				generic map(
					larguraDados => DATA_WIDTH -- 32
				)
				port map(
					entradaA_MUX 	=> saidaP2(105 downto 74), --out_bank_2
					entradaB_MUX 	=> saidaP2(41 downto 10), 	--out_estende
					seletor_MUX 	=> saidaP2(138), 				--sel_mux_banco_ula
					saida_MUX	 	=> out_mux_2
				);	
				
------------------------------------------------------------------------
-- check pipeline: ok!	
	Extensor: entity work.extendeSinalGenerico 
				generic map (
					larguraDadoEntrada => 16,			-- 16
					larguraDadoSaida   => ADDR_WIDTH -- 32
				)
				port map (
					extendeSinal_IN  => saidaP1(15 downto 0),
					extendeSinal_OUT => out_estende
				);
				
------------------------------------------------------------------------
-- check pipeline: ok!		
     ULA: entity work.ULA
        generic map (
            NUM_BITS => DATA_WIDTH	-- 32
        )
		port map (
            A   => entradaP2(73 downto 42),	-- out_bank_1
            B   => out_mux_2,
            ctr => ULActr,
            C   => out_ULA,
            Z   => out_Z
        );
	saidaUla <= out_ULA;
	
------------------------------------------------------------------------
-- check pipeline: ok!	
	 UC_ULA : entity work.UC_ULA 
        port map
        (
            funct  => saidaP2(15 downto 10),    
            ALUop  => saidaP2(140 downto 139),
            ALUctr => ULActr
        );

------------------------------------------------------------------------
-- check pipeline: ok!	
	 RAM: entity work.memoriaRAM 
        generic map (
            dataWidth => DATA_WIDTH, -- 32
            addrWidth => ADDR_WIDTH  -- 32
        )
			port map (
            endereco    => saidaP3(68 downto 37), 
				we          => saidaP3(102)	,
            re          => saidaP3(103)	,
            clk         => clk,
            dado_write  => saidaP3(36 downto 5),
            dado_read   => out_ram_read
        ); 
		  
------------------------------------------------------------------------
-- Mux Ula/Memoria
-- check pipeline: ok!	
	Mux3: entity work.muxGenerico2x1
				generic map(
					larguraDados => DATA_WIDTH -- 32
				)
				port map(
					entradaA_MUX 	=> saidaP4(36 downto 5),
					entradaB_MUX 	=> saidaP4(68 downto 37), --out_ram_read
					seletor_MUX		=> saidaP4(69), 				--sel_mux_ula_mem
					saida_MUX	 	=> out_mux_3
				);	
				
------------------------------------------------------------------------
-- Mux 4
-- check pipeline: ok!	
	sel_mux_4 <= saidaP3(104) and saidaP3(69); --sel_beq and out_Z;
	Mux4: entity work.muxGenerico2x1
				generic map(
					larguraDados => DATA_WIDTH -- 32
				)
				port map(
					entradaA_MUX	=> out_adder_1,
					entradaB_MUX 	=> saidaP3(101 downto 70), --out_adder_2 
					seletor_MUX 	=> sel_mux_4,
					saida_MUX	 	=> out_mux_4
				);	
	
------------------------------------------------------------------------
-- check pipeline: ok!	
     shift_1: entity work.shift2 
			  generic map (
					larguraDado => 26 --26
			  )
				port map (
					shift_IN  => imediato_J, -- alias saidaP1(25 downto 0)
					shift_OUT => out_shift_1
			  );
    	
------------------------------------------------------------------------	
-- check pipeline: ok!			
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
-- check pipeline: ok!			
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
-- check pipeline: ok!
	shift_2: entity work.shift2_imediato 
			  generic map (
					larguraDado => DATA_WIDTH		-- 32
			  )
				port map (
						shift_IN  => saidaP2(41 downto 10),
						shift_OUT => out_shift_2
				  );
    
------------------------------------------------------------------------	
-- check pipeline: ok!
	Somador: entity work.somador
				generic map (
					larguraDados => DATA_WIDTH		-- 32
				)
				port map(
					entradaA => saidaP2(137 downto 106),
					entradaB => out_shift_2,
					saida 	=> out_adder_2
				);
------------------------------------------------------------------------

end architecture;
				
				