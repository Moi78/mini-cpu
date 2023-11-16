library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bus_mux2 is
	generic(
		busSize : integer := 15
	);

	port(
		busA	: in std_logic_vector(busSize - 1 downto 0);
		busB	: in std_logic_vector(busSize - 1 downto 0);
		sel 	: in std_logic := '0';
		Q		: out std_logic_vector(busSize - 1 downto 0)
	);
end entity bus_mux2;

architecture a_bus_mux2 of bus_mux2 is
begin
	Q <= busA when sel = '0' else busB;
end architecture a_bus_mux2;
