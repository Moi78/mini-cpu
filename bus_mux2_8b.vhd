library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bus_mux2_8b is
	port(
		busA : in std_logic_vector(7 downto 0);
		busB : in std_logic_vector(7 downto 0);
		sel  : in std_logic;
		Q	  : out std_logic_vector(7 downto 0)
	);
end entity bus_mux2_8b;

architecture a_bus_mux2_8b of bus_mux2_8b is
begin
	MUX : entity work.bus_mux2(a_bus_mux2)
	generic map(busSize => 8)
	port map(
		busA => busA,
		busB => busB,
		sel  => sel,
		Q    => Q
	);
end architecture a_bus_mux2_8b;