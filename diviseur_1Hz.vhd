library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_1Hz is
	port
	(
		clk_50Mhz : in std_logic;
		clk_out : out std_logic
	);
end entity div_1Hz;

architecture a_div_1Hz of div_1Hz is
	signal cpt1 : integer range 0 to 99;
	signal cpt2 : integer range 0 to 99;
	signal cpt3 : integer range 0 to 99;
	signal cpt4 : integer range 0 to 49;
	
	signal rc1 : std_logic;
	signal rc2 : std_logic;
	signal rc3 : std_logic;
	
	signal i_clk_out : std_logic := '0';
	
begin
	clk_out <= i_clk_out;
	
-- premier diviseur par 100 de la cascade
div_100_1: process
begin
	wait until rising_edge(clk_50Mhz);
	
	if cpt1=99 then
		cpt1 <= 0;
		rc1 <= '1';
	else
		cpt1 <= cpt1+1;
		rc1 <= '0';
	end if;	
end process div_100_1;

-- second diviseur par 100 de la cascade
div_100_2: process
begin
	wait until rising_edge(clk_50Mhz);
	
	if rc1='1' then
		if cpt2=99 then
			cpt2 <= 0;
			rc2 <= '1';
		else
			cpt2 <= cpt2+1;
			rc2 <= '0';
		end if;	
	else
		rc2 <= '0';
	end if;
end process div_100_2;

-- troisieme diviseur par 100 de la cascade
div_100_3: process
begin
	wait until rising_edge(clk_50Mhz);
	
	if rc2='1' then
		if cpt3=99 then
			cpt3 <= 0;
			rc3 <= '1';
		else
			cpt3 <= cpt3+1;
			rc3 <= '0';
		end if;	
	else
		rc3 <= '0';
	end if;
end process div_100_3;

-- diviseur par 50 de la cascade
div_50: process
begin
	wait until rising_edge(clk_50Mhz);
	
	if rc3='1' then
		if cpt4=49 then
			cpt4 <= 0;
			i_clk_out <= '0';
		elsif cpt4= 24 then
			cpt4 <= cpt4+1;
			i_clk_out <= '1';
		else
			cpt4 <= cpt4+1;
		end if;	
	end if;
end process div_50;

end architecture a_div_1Hz;