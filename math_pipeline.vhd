library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity math_pipeline is
	port(
		clk	: in std_logic;
		en		: in std_logic;
		op		: in std_logic_vector(3 downto 0);
		regA	: in std_logic_vector(7 downto 0);
		regB	: in std_logic_vector(7 downto 0);
		regC	: out std_logic_vector(7 downto 0);
		readR	: out std_logic;
		writeR: out std_logic;
		fetchE: out std_logic;
		carry : out std_logic
	);
end entity math_pipeline;

architecture a_mpline of math_pipeline is
	type etat is (Idle, ReadRegs, Exec, WriteReg);
	signal currentState : etat := Idle;
	signal resultReg 	  : std_logic_vector(17 downto 0) := (others => '0');

begin
	process
	begin
		wait until rising_edge(clk);
		
		if en = '1' then
			case currentState is
				when Idle =>
					currentState <= ReadRegs;
				when ReadRegs =>
					currentState <= Exec;
				when Exec =>
					currentState <= WriteReg;
				when WriteReg =>
					currentState <= Idle;
				when others =>
					currentState <= Idle;
			end case;
		else
			currentState <= Idle;
		end if;
	end process;
	
	process (currentState)
	begin
		case currentState is
			when Idle =>
				readR <= '0';
				writeR <= '0';
				
				resultReg <= (others => '0');
				
				fetchE <= '0';
			when ReadRegs =>
				readR <= '1';
				fetchE <= '1';
			when Exec =>
				readR <= '0';
			
				if op = "0001" then -- Add
					resultReg(8 downto 0) <= std_logic_vector(unsigned('0' & regA) + unsigned('0' & regB));
				elsif op = "0010" then		-- Mul
					resultReg <= std_logic_vector(unsigned('0' & regA) * unsigned('0' & regB));
				elsif op = "0011" then		-- Sub
					resultReg(8 downto 0) <= std_logic_vector(unsigned('0' & regA) - unsigned('0' & regB));
				elsif op = "0100" then 	-- Div
					resultReg(8 downto 0) <= std_logic_vector(unsigned('0' & regA) / unsigned('0' & regB));
				elsif op = "0101" then 	-- And
					resultReg(8 downto 0) <= std_logic_vector(unsigned('0' & regA) and unsigned('0' & regB));
				elsif op = "0110" then 	-- Or
					resultReg(8 downto 0) <= std_logic_vector(unsigned('0' & regA) or unsigned('0' & regB));
				elsif op = "0111" then 	-- Xor
					resultReg(8 downto 0) <= std_logic_vector(unsigned('0' & regA) xor unsigned('0' & regB));
				elsif op = "1000" then 	-- Not
					resultReg(8 downto 0) <= std_logic_vector(not unsigned('0' & regA));
				else
					resultReg(8 downto 0) <= (others => '0');
				end if;
			when WriteReg =>
				writeR <= '1';
				fetchE <= '0';
		end case;
	end process;
	
	regC <= resultReg(7 downto 0);
	carry <= resultReg(8);
	
end architecture a_mpline;