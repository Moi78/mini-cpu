library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_pipeline is
	port(
		clk		: in std_logic;
		en			: in std_logic;
		op			: in std_logic_vector(3 downto 0);
		
		opDataL	: in std_logic_vector(7 downto 0);
		opDataH	: in std_logic_vector(7 downto 0);
		
		i_regA	: in std_logic_vector(7 downto 0);
		i_regB	: in std_logic_vector(7 downto 0);
		i_regC	: in std_logic_vector(7 downto 0);
		
		output	: out std_logic_vector(7 downto 0);
		updtBus	: out std_logic_vector(1 downto 0) := "00";
		
		fetchE	: out std_logic := '0'
	);
end entity memory_pipeline;

architecture a_memory_pline of memory_pipeline is
	type etat is (Idle, Exec, Update);
	signal currentState : etat := Idle;
	signal iOutput		  : std_logic_vector(7 downto 0);
	signal iSelector	  : std_logic_vector(1 downto 0);
begin
	process
	begin
		wait until rising_edge(clk);
			if en = '1' then
				case currentState is
					when Idle =>
						currentState <= Exec;
					when Exec =>
						currentState <= Update;
					when Update =>
						currentState <= Idle;
				end case;
			end if;
	end process;
	
	process (currentState)
	begin
		case currentState is 
			when Idle =>
				fetchE <= '0';
				updtBus <= (others => '0');
				iOutput <= (others => '0');
			when Exec =>
				fetchE <= '1';
				
				if op = "0001" then -- Mov REG to REG
					-- Source select
					case iSelector is
						when "01" => iOutput <= i_regA;
						when "10" => iOutput <= i_regB;
						when "11" => iOutput <= i_regC;
						when others => iOutput <= "00000000";
					end case;
				
				elsif op = "0110" then -- Load ctant in register
					iOutput <= opDataH;
				end if;
			when Update =>
				fetchE <= '0';
				-- Update  bus
				if op = "0001" or op = "0110" then -- Mov REG to REG or Load ctant
					updtBus <= opDataL(1 downto 0);
				end if;
		end case;
	end process;
	
	output <= iOutput;
	iSelector <= opDataH(1 downto 0);
end architecture a_memory_pline;
