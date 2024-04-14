library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder4 is
	port(
		addr 	: in std_logic_vector(3 downto 0);
		Q		: out std_logic_vector(15 downto 0)
	);
end entity decoder4;

architecture a_decoder4 of decoder4 is
begin
	DEC : entity work.decoder(a_decoder)
	generic map (size => 4)
	port map(
		addr => addr,
		Q => Q
	);
end architecture;