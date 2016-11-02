--!----------------------------------------------
--! 	Based on the SRAM verilog file by Sandro Bonacini, CERN PH/ESE
--! 
--!		@author Cairo Caplan, CBPF
--!-
--!-------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_mem is
	generic(
		DATA_WIDTH	:	integer := 4;
		ADDR_WIDTH	:	integer := 3
		
	);
	port (
		addr_w, addr_r	:	in	std_logic_vector(ADDR_WIDTH-1 downto 0);
		data_r			:	out	std_logic_vector(DATA_WIDTH-1 downto 0);
	 	data_w			:	in	std_logic_vector(DATA_WIDTH-1 downto 0);
		w_enable, clk_w	:	in	std_logic
	);
end entity fifo_mem;

architecture RTL of fifo_mem is
	constant SIZE		:	integer	:= 2**ADDR_WIDTH;
	
	--signal  wl_w_latched	:	 std_logic_vector(SIZE-1 downto 0);
	type mem_t is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem	:	 mem_t(SIZE-1 downto 0);
	
	
begin
	
	
	
	memory_write : process(clk_w, addr_r, mem) is
	begin	
		if rising_edge(clk_w) then
			if w_enable='1' then
				mem(to_integer(unsigned(addr_w))) <= data_w ;-- after 1 ns;
			end if;
		end if;
		--wl_w(j) <= wl_w_latched(j) and clk_w_gated;
		data_r <= mem(to_integer(unsigned( addr_r )));	
	end process memory_write;
	
	
	
	
	

end architecture RTL;
