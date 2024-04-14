library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity io_pipeline is
	port(
		clk		: in std_logic;
		en			: in std_logic;
		fetchE	: out std_logic;
		
		iRegA		: in std_logic_vector(7 downto 0);
		iData		: in std_logic_vector(7 downto 0);
		
		op			: in std_logic_vector(3 downto 0);
		opHigh	: in std_logic_vector(7 downto 0);
		opLow		: in std_logic_vector(7 downto 0);
		
		oRegA		: out std_logic_vector(7 downto 0);
		oData		: out std_logic_vector(7 downto 0);
		oAddress	: out std_logic_vector(15 downto 0);
		io_write	: out std_logic;
		io_read	: out std_logic;
		regA_updt: out std_logic;
		
		reset    : in std_logic
	);
end entity io_pipeline;

architecture a_io_pipeline of io_pipeline is
	type etat is (Idle, Query, Output, Update, Update2);
	signal state : etat := Idle;
begin
	process
	begin
		wait until rising_edge(clk);
		
		if en = '1' then
			case state is
				when Idle => state <= Query;
				when Query => state <= Output;
				when Output => state <= Update;
				when Update => state <= Update2;
				when Update2 => state <= Idle;
			end case;
		else
			state <= Idle;
		end if;
		
		if reset = '0' then
			state <= Idle;
		end if;
	end process;
	
	process
	begin
		wait until falling_edge(clk);
		if state = Idle then
			io_write <= '0';
			io_read <= '0';
			
			fetchE <= '0';
			
			oAddress <= (others => '0');
			oData <= (others => '0');
			oRegA <= (others => '0');

			regA_updt <= '0';
			
		elsif state = Query then
			fetchE <= '1';
		
			oAddress(15 downto 8) <= opHigh;
			oAddress(7 downto 0) <= opLow;
			
			if op = "0001" then -- INB
				io_read <= '1';
				io_write <= '0';
			elsif op = "0010" then -- OUTB
				oData <= iRegA;
				
				io_read <= '0';
				io_write <= '1';
			end if;
		
		elsif state = Output then
			if op = "0001" then -- INB
				oRegA <= iData;
				regA_updt <= '1';
			end if;
		elsif state = Update then
			regA_updt <= '0';
			io_write <= '0';
		elsif state = Update2 then
			fetchE <= '0';
			io_read <= '0';
		end if;
	end process;
end architecture a_io_pipeline;
