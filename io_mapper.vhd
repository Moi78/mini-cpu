library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity io_mapper is
	port(
		clk	   : in std_logic;
		addr	   : in std_logic_vector(15 downto 0);
		rd			: in std_logic;
		wr			: in std_logic;
		
		sw_in    : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0);
		
		en_periph: out std_logic_vector(15 downto 0)
	);
end entity;

architecture a_map of io_mapper is
	signal i_addr : unsigned(15 downto 0);
begin
	process
	begin
		wait until rising_edge(clk);
		
		if rd = '1' then
			if i_addr = to_unsigned(0, 16) then -- 0x0000 mapped to SW
				data_out <= sw_in;
			end if;
		
		elsif wr = '1' then
			if i_addr > "0111111111111111" then -- 0x8XXX mapped to VRAM
				en_periph <= "0000000000000001"; -- Device 0
			elsif i_addr = to_unsigned(1, 16) then -- 0x0001 mapped to HEX display
				en_periph <= "0000000000000010"; -- Device 1
			end if;
		else
				data_out <= (others => '0');
				en_periph <= (others => '0');
		end if;
	end process;
	
	i_addr <= unsigned(addr);
end architecture a_map;
