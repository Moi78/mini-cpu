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
		i_mem		: in std_logic_vector(7 downto 0);
		
		output	: out std_logic_vector(7 downto 0);
		outputPC	: out std_logic_vector(15 downto 0);
		updtBus	: out std_logic_vector(2 downto 0);
		
		fetchE	: out std_logic;
		outAddr	: out std_logic_vector(15 downto 0);
		fetchMem : out std_logic;
		
		reset    : in std_logic;
		i_flags  : in std_logic_vector(7 downto 0)
	);
end entity memory_pipeline;

architecture a_memory_pline of memory_pipeline is
	type etat is (Idle, Exec, LongUpdt, Update);
	signal currentState : etat := Idle;
	signal iOutput		  : std_logic_vector(7 downto 0);
	signal iJump		  : std_logic_vector(15 downto 0);
	signal iSelector	  : std_logic_vector(2 downto 0);
begin
	process
	begin
		wait until rising_edge(clk);
			if en = '1' then
				case currentState is
					when Idle =>
						currentState <= Exec;
					when Exec =>
						if op = "0010" or op = "0011" or op = "0100" or op = "0101" or op = "1000" or op = "0111" then
							currentState <= LongUpdt;
						else
							currentState <= Update;
						end if;
					when LongUpdt =>
						currentState <= Update;
					when Update =>
						currentState <= Idle;
				end case;
			else
				currentState <= Idle;
			end if;
			
			if reset = '0' then
				currentState <= Idle;
			end if;
	end process;
	
	process
	begin
		wait until falling_edge(clk);
		case currentState is 
			when Idle =>
				fetchE <= '0';
				updtBus <= (others => '0');
				iOutput <= (others => '0');
				fetchMem <= '0';
			when Exec =>
				fetchE <= '1';
				
				if op = "0001" then -- Mov REG to REG
					-- Source select
					case iSelector is
						when "001" => iOutput <= i_regA;
						when "010" => iOutput <= i_regB;
						when "011" => iOutput <= i_regC;
						when others => iOutput <= "00000000";
					end case;
				elsif op = "0010" or op = "0100" then -- Mem to Reg A OR Mem to Reg B
					outAddr(15 downto 8) <= opDataH;
					outAddr(7 downto 0) <= opDataL;
					
					fetchMem <= '1';
				elsif op = "0011" then -- Reg A to Mem
					outAddr(15 downto 8) <= opDataH;
					outAddr(7 downto 0) <= opDataL;
					
					iOutput <= i_regA;
					fetchMem <= '1';
				elsif op = "0101" then -- Reg B to Mem
					outAddr(15 downto 8) <= opDataH;
					outAddr(7 downto 0) <= opDataL;
					
					iOutput <= i_regB;
					fetchMem <= '1';
				elsif op = "0110" then -- Load ctant in register
					iOutput <= opDataH;
					
				elsif op = "0111" or op = "1000" then -- Jump to ctant address / Jump if equal
					iJump(15 downto 8) <= opDataH;
					iJump(7 downto 0) <= opDataL;
				end if;
			when LongUpdt =>
				if op = "0011" then -- Mov RegA to Mem
					iOutput <= i_regA;
					updtBus <= "101";
				elsif op = "0101" then -- Mov Reg B to Mem
					iOutput <= i_regB;
					updtBus <= "101";
				elsif op = "1000" then -- JE
					if i_flags(1) = '1' then -- Flag[1] => Flag Equal
						updtBus <= "100";
					end if;
				elsif op = "0111" then -- JMP
					updtBus <= "100";
				end if;
			when Update =>
				fetchE <= '0';
				fetchMem <= '0';
				-- Update  bus
				if op = "0001" or op = "0110" then -- Mov REG to REG or Load ctant
					updtBus <= opDataL(2 downto 0);
				elsif op = "0010" then -- Mov Mem to RegA
					iOutput <= i_mem;
					updtBus <= "001";
				elsif op = "0011" or op = "0101" then
					updtBus <= "000";
				elsif op = "0100" then -- Mov Mem to RegB
					iOutput <= i_mem;
					updtBus <= "010";
				end if;
		end case;
	end process;
	
	output <= iOutput;
	outputPC <= iJump;
	iSelector <= opDataH(2 downto 0);
end architecture a_memory_pline;
