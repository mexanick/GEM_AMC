--!----------------------------------------------
--!  
--! 	regbank in Vhdl
--! 	Based on the verilog regbank by Sandro Bonacini
--! 
--!		@author Cairo Caplan, CBPF
--!-
--!-------------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;


entity regbank is
   generic (
      WIDTH  : integer := 8
   );
   port (
      d      : in	std_logic_vector(WIDTH - 1 downto 0);
      rn     : in	std_logic;
      q      : out	std_logic_vector(WIDTH - 1 downto 0);
      clk    : in	std_logic
   );
end regbank;

architecture arc of regbank is
begin
   
   process (clk, rn)
   begin
		if rn = '0' then
			q <= (others => '0');
   	elsif rising_edge(clk) then
   		q <= d;
   	end if;  
   end process;
   
   
end arc;

