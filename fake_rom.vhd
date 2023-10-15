library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fake_rom is
	port(
		address	: in std_logic_vector(15 downto 0);
		Q			: out std_logic_vector(7 downto 0)
	);
end entity fake_rom;

architecture a_fake_rom of fake_rom is
	type memory is array (64 downto 0) of std_logic_vector(7 downto 0);
	signal fake_memory : memory;
begin
	fake_memory(0) <= "00100110";
	fake_memory(1) <= "00000001";
	fake_memory(2) <= "00000011";
	fake_memory(3) <= "00100110";
	fake_memory(4) <= "00000010";
	fake_memory(5) <= "00000110";
	fake_memory(6) <= "00010001";
	fake_memory(7) <= "00000000";
	fake_memory(8) <= "00000000";
	fake_memory(9) <= "00100001";
	fake_memory(10) <= "00000001";
	fake_memory(11) <= "00000011";
	
	Q <= fake_memory(to_integer(unsigned(address)));
end architecture a_fake_rom;