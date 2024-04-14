library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic(
		size: integer := 8;
		max : integer := 4
	);
	
	port(
		clock	: in std_logic;
		en		: in std_logic;
		ZF		: out std_logic; -- Zero flag
		count : out std_logic_vector((size - 1) downto 0)
	);
end entity;

architecture a_counter of counter is
	signal iCount : unsigned((size - 1) downto 0) := to_unsigned(0, size);
begin
	count <= std_logic_vector(iCount);

	process
	begin
		wait until rising_edge(clock);
		if en = '1' then
			if iCount < max then
				iCount <= iCount + 1;
			else
				iCount <= to_unsigned(0, size);
			end if;
			
			if iCount = max then
					ZF <= '1';
			else
					ZF <= '0';
			end if;
		end if;
	end process;
end architecture a_counter;
