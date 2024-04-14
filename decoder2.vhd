library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder2 is
	port(
		addr 	: in std_logic_vector(1 downto 0);
		Q		: out std_logic_vector(3 downto 0)
	);
end entity decoder2;

architecture a_decoder2 of decoder2 is
begin
	DEC : entity work.decoder(a_decoder)
	generic map (size => 2)
	port map(
		addr => addr,
		Q => Q
	);
end architecture;