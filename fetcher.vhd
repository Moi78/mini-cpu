library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetcher is
	port(
		clk		: in std_logic;
		fetch_en	: in std_logic;
		data_in	: in std_logic_vector(7 downto 0);
		
		pline_sel: out std_logic_vector(3 downto 0);
		op			: out std_logic_vector(3 downto 0);
		operand_a: out std_logic_vector(7 downto 0);
		operand_b: out std_logic_vector(7 downto 0);
		
		pline_en : out std_logic;
		pc_en		: out std_logic;
		
		reset    : in std_logic
	);
end entity fetcher;

architecture a_fetcher of fetcher is
	signal fetch_counter : integer range 0 to 4;
	signal iPline_en		: std_logic;
begin
	process
	begin
		wait until rising_edge(clk);
		
		if fetch_en = '0' then
			-- Handling counter
			if fetch_counter = 4 then
				fetch_counter <= 0;
			else
				fetch_counter <= fetch_counter + 1;
			end if;
		end if;
		
		if reset = '0' then
			fetch_counter <= 0;
		end if;
	end process;
		
	op <= data_in(3 downto 0) when fetch_counter = 0;
	pline_sel <= data_in(7 downto 4) when fetch_counter = 0;
	
	operand_a <= data_in when fetch_counter = 1;
	operand_b <= data_in when fetch_counter = 2;
	
	with fetch_counter select iPline_en <=
		'1' when 3 | 4,
		'0' when others;
	
	pline_en <= iPline_en;
	pc_en <= not iPline_en;
end architecture a_fetcher;
