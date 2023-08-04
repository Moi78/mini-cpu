library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	generic(
		size : integer := 8
	);
	port(
		en			: in std_logic;
		data_in	: in std_logic_vector((size - 1) downto 0);
		data_out : out std_logic_vector((size - 1) downto 0)
	);
end entity;

architecture a_reg of reg is
	signal i_dout : std_logic_vector((size - 1) downto 0) := "00000000";
begin
	data_out <= i_dout;

	process (en)
	begin
		if en = '1' then
			i_dout <= data_in;
		end if;
	end process;
end architecture a_reg;
