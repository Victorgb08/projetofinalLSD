library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_jogodavelha is
end tb_jogodavelha;

architecture teste of tb_jogodavelha is

component jogodavelha is
port (
        CLOCK   : in    std_logic; -- clock input
        S, b      : in    std_logic; -- control input
        um, dois, tres, quatro, cinco, seis, sete, oito, nove : in    std_logic; -- data inputs
		  RESET	 : in 	std_logic; -- reset 
        wp1, wp2, empate : out   std_logic  -- data output
    );
end component;

signal um, dois, tres, quatro, cinco, seis, sete, oito, nove          : std_logic;
signal clock, s, b, reset : std_logic;
signal wp1, wp2, empate: std_logic;
signal data_in : std_logic_vector (8 downto 0);
signal data_output      : std_logic;
constant max_value      : natural := 11;
constant mim_value		: natural := 1;

signal read_data_in    : std_logic:='0';
signal flag_write      : std_logic:='0';   


file   inputs_data_in  : text open read_mode  is "data_in.txt";
file   outputs         : text open write_mode is "saida.txt";

-- Clock period definitions
constant PERIOD     : time := 10 ns;
constant DUTY_CYCLE : real := 0.5;
constant OFFSET     : time := 5 ns;

begin
-- Instantiate the Unit Under Test (UUT) or Design Under Test (DUT)
UUT: jogodavelha port map
	(
		um => um, dois => dois, tres => tres, quatro => quatro, cinco => cinco, seis => seis, sete  => sete, oito => oito, nove => nove,
		clock => clock, wp1 => wp1, wp2 => wp2, empate => empate, reset  => reset, b => b, s => s
	);
	
	
	     PROCESS    -- clock process for clock
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                clock <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                clock <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;


------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo data_in.txt
------------------------------------------------------------------------------------
read_inputs_data_in:process
		variable linea : line;
		variable input : std_logic_vector (8  downto 0);
	begin
		while not endfile(inputs_data_in) loop
		      if read_data_in = '1' then
			     readline(inputs_data_in,linea);
						read(linea,input);
						data_in <= input;
				end if;
				wait for PERIOD;
		end loop;
		um <= data_in(0);
		dois <= data_in(1);
		tres <= data_in(2);
		quatro <= data_in(3);
		cinco <= data_in(4);
		seis <= data_in(5);
		sete <= data_in(6);
		oito <= data_in(7);
		nove <= data_in(8);
		reset <= '0';
		b<='1';
		wait;
	end process read_inputs_data_in;

	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
	
   tb_stimulus : PROCESS
   BEGIN
        WAIT FOR (OFFSET + 3*PERIOD);
            read_data_in <= '1';		
			for i in mim_value to max_value loop
		        wait for PERIOD;
		    end loop;
            read_data_in <= '0';		
		WAIT;
   END PROCESS tb_stimulus;	

------------------------------------------------------------------------------------
------ processo para gerar os estimulos de escrita do arquivo de saida
------------------------------------------------------------------------------------   
   
   escreve_outputs : PROCESS
   BEGIN
        WAIT FOR (4*PERIOD);
            flag_write <= '1';
			for i in mim_value to max_value loop
		        wait for PERIOD;
		    end loop;
            flag_write <= '0';			
		WAIT;
   END PROCESS escreve_outputs;   
 

-- ------------------------------------------------------------------------------------
-- ------ processo para escrever os dados de saida no arquivo saida.txt
-- ------------------------------------------------------------------------------------ 

	write_outputs: process
		variable linea  : line;
		constant p1_ganha : string := "O Jogador 1 ganhou :) ";
		constant p2_ganha : string := "O jogador 2 ganhou :) ";
		constant velha : string := "Velha :/";
	
begin
		while true loop
			if (flag_write ='1')then
				writeline(outputs,linea);
				if (wp1 = '1') then
					write(linea, p1_ganha);
				elsif (wp2 = '1') then
					write(linea, p2_ganha);
				elsif ( empate = '1') then
					write(linea, velha);
				end if;
			end if;
			wait for PERIOD;
		end loop; 
	end process write_outputs; 
	
end teste;

