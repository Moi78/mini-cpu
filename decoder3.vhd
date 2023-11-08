library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder3 is
	port(
		addr 	: in std_logic_vector(2 downto 0);
		Q		: out std_logic_vector(7 downto 0)
	);
end entity decoder3;

architecture a_decoder3 of decoder3 is
begin
	DEC : entity work.decoder(a_decoder)
	generic map (size => 3)
	port map(
		addr => addr,
		Q => Q
	);
end architecture;