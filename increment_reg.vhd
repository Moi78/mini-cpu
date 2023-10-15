library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity increment_reg is
	generic(
		reg_size : integer := 16
	);
	port(
		clock		: in std_logic;
		incr_en	: in std_logic;
		en			: in std_logic;
		inData	: in std_logic_vector(reg_size - 1 downto 0);
		outData	: out std_logic_vector(reg_size - 1 downto 0)
	);
end entity increment_reg;

architecture a_inc_reg of increment_reg is
	signal iData : unsigned(reg_size - 1 downto 0) := (others => '0');
begin
	process (en)
	begin
		if en = '1' then
			--iData <= unsigned(inData);
		end if;
	end process;
	
	process
	begin
		wait until falling_edge(clock);
		
		if incr_en = '1' then
			iData <= iData + 1;
		end if;
	end process;
	
	outData <= std_logic_vector(iData);
end architecture a_inc_reg;
