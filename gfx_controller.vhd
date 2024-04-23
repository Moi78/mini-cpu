library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gfx_controller is
	port(
		clk	   : in std_logic;
		px_clock : in std_logic;
		reset    : in std_logic;
		
		vsync    : in std_logic;
		hsync    : in std_logic;
		pxx		: in std_logic_vector(15 downto 0);
		pxy      : in std_logic_vector(15 downto 0);
		
		vram_in  : in std_logic_vector(7 downto 0);
		vram_addr: out std_logic_vector(15 downto 0);
		vram_rq  : out std_logic;
		
		px_color : out std_logic_vector(7 downto 0)
	);
end entity;

architecture a_gc of gfx_controller is
	type bg_state is (
		idle_bg, 
		fetch_bg_rq, fetch_bg_get, fetch_bg_end,
		fetch_sprite_flags, fetch_sf_get, fetch_sf_end,
		fetch_spos_start, fetch_spos_xlow, fetch_spos_xhigh, fetch_spos_ylow, fetch_spos_yhigh, fetch_spos_end, fetch_spos_end2,
		fetch_bg_free_vram
	);
	type disp_state is (bg_color, sprite_line);
	
	signal i_bg_state      : bg_state;
	signal i_disp_state    :  disp_state;
	
	signal i_px_color      : std_logic_vector(7 downto 0);
	signal i_bg_color      : std_logic_vector(7 downto 0);
	
	signal i_pxy 		     : unsigned(15 downto 0);
	signal i_pxx			  : unsigned(15 downto 0);
	
	signal i_sprx          : unsigned(15 downto 0);
	signal i_spry			  : unsigned(15 downto 0);
	signal i_spr_cpt       : integer range 0 to 32;
	signal i_spr_ylimit    : unsigned(15 downto 0);
	signal i_spr_data_addr : unsigned(15 downto 0);
	
	signal i_sprite_flags  : std_logic_vector(7 downto 0);
	signal i_line_drawn_spr: std_logic_vector(7 downto 0);
	
	signal refreshed_gpu : std_logic;
begin

	process
	begin
		wait until rising_edge(clk);
		
		if reset = '0' then
			i_bg_state <= idle_bg;
			i_disp_state <= bg_color;
			
			i_px_color <= (others => '0');
			
			vram_rq <= '0';
		end if;
		
		-- Update states on VSYNC
		
		-- Update states on HSYNC
		if hsync = '0' then
			i_line_drawn_spr <= (others => '0');
		end if;
		
		-- Data state machine
		if hsync = '0' and i_bg_state = idle_bg and not (refreshed_gpu = '1')then
			i_bg_state <= fetch_bg_rq;
			refreshed_gpu <= '1';
		elsif hsync = '1' then
			refreshed_gpu <= '0';
		else
			case i_bg_state is
				when fetch_bg_rq => i_bg_state <= fetch_bg_get;
				when fetch_bg_get => i_bg_state <= fetch_bg_end;
				when fetch_bg_end => i_bg_state <= fetch_sprite_flags;
				
				when fetch_sprite_flags => i_bg_state <= fetch_sf_get;
				when fetch_sf_get => i_bg_state <= fetch_sf_end;
				when fetch_sf_end => i_bg_state <= fetch_spos_start;
				
				when fetch_spos_start => i_bg_state <= fetch_spos_xlow;
				when fetch_spos_xlow => i_bg_state <= fetch_spos_xhigh;
				when fetch_spos_xhigh => i_bg_state <= fetch_spos_ylow;
				when fetch_spos_ylow => i_bg_state <= fetch_spos_yhigh;
				when fetch_spos_yhigh => i_bg_state <= fetch_spos_end;
				when fetch_spos_end => i_bg_state <= fetch_spos_end2;
				when fetch_spos_end2 => i_bg_state <= fetch_bg_free_vram;
				
				when fetch_bg_free_vram => i_bg_state <= idle_bg;
				when idle_bg => i_bg_state <= idle_bg;
			end case;
		end if;
		
		-- Data management
		if i_bg_state = fetch_bg_rq then
			vram_addr <= (others => '0'); -- Background color address : 0x0000
			vram_rq <= '1';
			
		elsif i_bg_state = fetch_bg_end then
			i_bg_color <= vram_in;
			
		elsif i_bg_state = fetch_sprite_flags then
			vram_addr <= "0000000000000001"; -- Sprite flags address : 0x0001
			
		elsif i_bg_state = fetch_sf_end then
			i_sprite_flags <= vram_in;
			
		-- Sprite pos from memory
		elsif i_bg_state = fetch_spos_start then
			vram_addr <= "0000000000000010"; -- Sprite XLow address : 0x0002 + offset
			
		elsif i_bg_state = fetch_spos_xlow then
			vram_addr <= "0000000000000011"; -- Sprite XHigh address : 0x0003 + offset
			
		elsif i_bg_state = fetch_spos_xhigh then
			vram_addr <= "0000000000000100"; -- Sprite YLow address : 0x0004 + offset
			i_sprx(7 downto 0) <= unsigned(vram_in); -- XLow loaded
			
		elsif i_bg_state = fetch_spos_ylow then
			vram_addr <= "0000000000000101"; -- Sprite YHigh address : 0x0005 + offset
			i_sprx(15 downto 8) <= unsigned(vram_in); -- XHigh loaded
			
		elsif i_bg_state = fetch_spos_yhigh then
			i_spry(7 downto 0) <= unsigned(vram_in); -- YLow loaded
			
		elsif i_bg_state = fetch_spos_end then
			i_spry(15 downto 8) <= unsigned(vram_in); -- YHigh loaded
			
		elsif i_bg_state = fetch_spos_end2 then
			i_spr_ylimit <= i_spry + 32; -- Computing Y limit
			
		elsif i_bg_state = fetch_bg_free_vram then
			vram_rq <= '0';
		end if;
		
		-- Display management
		if (i_pxx > i_sprx) and (i_line_drawn_spr(0) = '0') and (i_pxy > i_spry) and (i_pxy < i_spr_ylimit) then
			i_disp_state <= sprite_line;
			i_line_drawn_spr(0) <= '1';
			
			vram_rq <= '1';
			vram_addr <= std_logic_vector(i_spr_data_addr);
		elsif i_spr_cpt = 31 then
			i_disp_state <= bg_color;
			vram_rq <= '0';
		end if;
		
		-- Output pixel color
		if i_disp_state = bg_color then
			i_px_color <= i_bg_color;
			
		elsif i_disp_state = sprite_line then
			--vram_addr <= std_logic_vector(i_spr_data_addr);
			i_px_color <= vram_in;
			
		end if;
		
	end process;
	
	process
	begin
		wait until rising_edge(px_clock);
		
		if i_disp_state = sprite_line then
			i_spr_cpt <= i_spr_cpt + 1;
			i_spr_data_addr <= i_spr_data_addr + 1;
		else
			i_spr_cpt <= 0;
		end if;
		
		if vsync = '0' then
			i_spr_data_addr <= "0000000000000110";
		end if;
	end process;

	px_color <= i_px_color;
	i_pxy <= unsigned(pxy);
	i_pxx <= unsigned(pxx);
	
	--i_sprx <= to_unsigned(500, 16);
	--i_spry <= to_unsigned(200, 16);
	--i_spr_ylimit <= i_spry + 32;
	
end architecture a_gc;
