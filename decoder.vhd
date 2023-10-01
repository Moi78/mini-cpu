library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
	generic(
		addr_size : integer := 4
	);
	
	port(
		addr 	: in std_logic_vector(addr_size - 1 downto 0);
		Q		: out std_logic_vector((2 ** addr_size) - 1 downto 0)
	);
end entity decoder;

architecture a_decoder of decoder is
	signal UAddr : unsigned(addr_size - 1 downto 0) := to_unsigned(0, addr_size);
	signal iQ	 : unsigned((2 ** addr_size) - 1 downto 0);
begin
	process (UAddr)
	begin 
		iQ <= to_unsigned(0, 2 ** addr_size);
		iQ(to_integer(UAddr)) <= '1';
	end process;
	
	UAddr <= unsigned(addr);
	Q <= std_logic_vector(iQ);
end architecture;