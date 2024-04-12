library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_clock is
	port(
		clk	: in std_logic;
		px_dat: in std_logic_vector(7 downto 0);
		
		px_x  : out std_logic_vector(15 downto 0);
		px_y  : out std_logic_vector(15 downto 0);
		hblank: out std_logic;
		vblank: out std_logic;
		rsig  : out std_logic_vector(3 downto 0);
		gsig  : out std_logic_vector(3 downto 0);
		bsig  : out std_logic_vector(3 downto 0)
	);
end entity vga_clock;

architecture a_vclk of vga_clock is
	signal clk_25m : std_logic;
	
	signal pixel_h: integer range 0 to 800;
	signal line_v: integer range 0 to 525;
begin
	px_x <= std_logic_vector(to_unsigned(pixel_h, 16));
	px_y <= std_logic_vector(to_unsigned(line_v, 16));

	process
	begin
		wait until rising_edge(clk);
		
		if clk_25m = '0' then
			clk_25m <= '1';
		else 
			clk_25m <= '0';
		end if;
		
	end process;
	
	process
	begin
		wait until rising_edge(clk_25m);
	
		pixel_h  <= pixel_h + 1;
		if pixel_h = 799 then
			pixel_h <= 0;
			line_v <= line_v + 1;
			
			if line_v = 524 then
				line_v <= 0;
			end if;
		end if;
		
		if (pixel_h < 96) then
			hblank <= '0';
		else
			hblank <= '1';
		end if;
		
		if (line_v < 2) then
			vblank <= '0';
		else
			vblank <= '1';
		end if;
		
		if (line_v < 35) or (line_v > 515) or (pixel_h < 48) or (pixel_h > 688) then
			rsig <= "0000";
			gsig <= "0000";
			bsig <= "0000";
		else
			rsig <= px_dat(7 downto 6) & "00";
			gsig <= px_dat(5 downto 4) & "00";
			bsig <= px_dat(3 downto 2) & "00";
		end if;
	end process;
end architecture a_vclk;
