library ieee;
use ieee.std_logic_1164.all;

entity jogodavelha is
    port (
        CLOCK   : in    std_logic; -- clock input
        S, b      : in    std_logic; -- control input
        um, dois, tres, quatro, cinco, seis, sete, oito, nove : in    std_logic; -- data inputs
		  RESET	 : in 	std_logic; -- reset 
        wp1, wp2, empate : out   std_logic  -- data output
    );
end jogodavelha;

architecture arch of jogodavelha is
	type st is (aguardar, aguardar1, verificar1, aguardar2, verificar2, WS1, WS2, velha);
	signal estado : st; -- sinal associado ao tipo st
	signal w1,w2: std_logic;
begin
	my_process : process(CLOCK, RESET, b, s)
	
	begin
if(CLOCK'event and CLOCK = '1') then -- borda de subida
			case estado is
				when aguardar =>
					if b = '1' then 
						estado <= aguardar1;
					else 
						estado <= aguardar; 
					end if;
				when aguardar1 =>
						estado <= verificar1;
				when verificar1 =>
				
					if um='0' and dois='0' and tres='0' then w2<='1';
					elsif quatro='0' and cinco='0' and seis='0' then w2<='1';
					elsif sete='0' and oito='0' and nove='0' then w2<='1';
					elsif um='0' and quatro='0' and sete='0' then w2<='1';
					elsif dois='0' and cinco='0' and oito='0' then w2<='1';
					elsif tres='0' and seis='0' and nove='0' then w2<='1';
					elsif um='0' and cinco='0' and nove='0' then w2<='1';
					elsif tres='0' and cinco='0' and sete='0' then w2<='1';
					else w2<='0';
					end if;
					
					if um='1' and dois='1' and tres='1' then w1<='1'; w2<='0';
					elsif quatro='1' and cinco='1' and seis='1' then w1<='1'; w2<='0';
					elsif sete='1' and oito='1' and nove='1' then w1<='1'; w2<='0';
					elsif um='1' and quatro='1' and sete='1' then w1<='1'; w2<='0';
					elsif dois='1' and cinco='1' and oito='1' then w1<='1'; w2<='0';
					elsif tres='1' and seis='1' and nove='1' then w1<='1'; w2<='0';
					elsif um='1' and cinco='1' and nove='1' then w1<='1'; w2<='0';
					elsif tres='1' and cinco='1' and sete='1' then w1<='1'; w2<='0';
					else w1<='0';
					end if;
				
					if w1 = '1' then
						estado <= WS1;
					elsif w2='0' and w1='0' then
						estado <= velha;
					elsif w1='0' then
						estado <= aguardar2;
					elsif b='1' then
						estado <= aguardar;
					end if;
					
				when aguardar2 =>
				 estado <= verificar2;
				when verificar2 =>
				
					if um='0' and dois='0' and tres='0' then w2<='1';
					elsif quatro='0' and cinco='0' and seis='0' then w2<='1';
					elsif sete='0' and oito='0' and nove='0' then w2<='1';
					elsif um='0' and quatro='0' and sete='0' then w2<='1';
					elsif dois='0' and cinco='0' and oito='0' then w2<='1';
					elsif tres='0' and seis='0' and nove='0' then w2<='1';
					elsif um='0' and cinco='0' and nove='0' then w2<='1';
					elsif tres='0' and cinco='0' and sete='0' then w2<='1';
					else w2<='0';
					end if;
					
					if um='1' and dois='1' and tres='1' then w1<='1'; w2<='0';
					elsif quatro='1' and cinco='1' and seis='1' then w1<='1'; w2<='0';
					elsif sete='1' and oito='1' and nove='1' then w1<='1'; w2<='0';
					elsif um='1' and quatro='1' and sete='1' then w1<='1'; w2<='0';
					elsif dois='1' and cinco='1' and oito='1' then w1<='1'; w2<='0';
					elsif tres='1' and seis='1' and nove='1' then w1<='1'; w2<='0';
					elsif um='1' and cinco='1' and nove='1' then w1<='1'; w2<='0';
					elsif tres='1' and cinco='1' and sete='1' then w1<='1'; w2<='0';
					else w1<='0';
					end if;
				
					if w2 = '1' then
						estado <= WS2;
					elsif w1='0' and w2='0' then
						estado <= velha;
					elsif w2='0' then 
						estado <= aguardar1;
					end if;
				when WS1 =>
					estado <= aguardar;
				when WS2 =>
					estado <= aguardar;
				when velha =>
					estado <= aguardar;
			end case;
		end if;
	end process my_process;
	
	wp1<=w1;
	wp2<=w2;
	empate<= not (w1 or w2);
	
end arch;