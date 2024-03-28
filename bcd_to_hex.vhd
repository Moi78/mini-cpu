library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_to_hex is
	port(
		bcd_in : in std_logic_vector(3 downto 0);
		hex_out: out std_logic_vector(6 downto 0)
	);
end entity;

architecture a_bth of bcd_to_hex is
begin
	with bcd_in select
		hex_out <= "0000001" when "0000",
					  "1001111" when "0001",
					  "0010010" when "0010",
					  "0000110" when "0011",
					  "1001100" when "0100",
					  "0100100" when "0101",
					  "0100000" when "0110",
					  "0001111" when "0111",
					  "0000000" when "1000",
					  "0000100" when "1001",
					  "0001000" when "1010",
					  "1100000" when "1011",
					  "0110001" when "1100",
					  "1000010" when "1101",
					  "0110000" when "1110",
					  "0111000" when "1111",
					  "1111110" when others; 
end architecture;
