library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder2 is
	port(
		addr 	: in std_logic_vector(1 downto 0);
		Q		: out std_logic_vector(3 downto 0)
	);
end entity decoder2;

architecture a_decoder of decoder2 is
	signal UAddr : unsigned(1 downto 0) := to_unsigned(0, 2);
	signal iQ	 : unsigned(3 downto 0);
begin
	process (UAddr)
	begin 
		iQ <= to_unsigned(0, 4);
		iQ(to_integer(UAddr)) <= '1';
	end process;
	
	UAddr <= unsigned(addr);
	Q <= std_logic_vector(iQ);
end architecture;