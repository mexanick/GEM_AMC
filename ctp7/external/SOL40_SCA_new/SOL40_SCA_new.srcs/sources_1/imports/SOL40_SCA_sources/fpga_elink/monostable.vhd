library ieee;
use ieee.std_logic_1164.all;

entity monostable is
	port (
		clk	:	in	std_logic;
		A 	:	in	std_logic;
		Z	:	out std_logic
	);
end entity monostable;


--! Pulse generator with one clock period width, extracted
--! from "Use Synchronous Pulse Generators" in:
--! http://www.altera.com/literature/hb/qts/qts_qii51006.pdf
architecture RTL of monostable is
	
	
	component regbank
		generic(WIDTH : integer := 8);
		port(d   : in  std_logic_vector(WIDTH - 1 downto 0);
			 rn  : in  std_logic;
			 q   : out std_logic_vector(WIDTH - 1 downto 0);
			 clk : in  std_logic);
	end component regbank;
	
	--signal reset_delb	: std_logic:='0';
	--signal Z_aux		: std_logic_vector(0 downto 0);
	signal t1, t2 : std_logic;
begin
	
	sync_delay : process (clk) is
	begin
		if rising_edge(clk) then
			t1<= A;
			t2 <= t1;
		end if;
	end process sync_delay;
	
	Z <= t1 and (not t2);
	
--	regbank_inst : regbank
--		generic map(WIDTH => 1)
--		port map(d   => (others=>'1'),
--			     rn  =>  reset_delb,
--			     q   => Z_aux,
--			     clk => A);		   
--	Z <= Z_aux(0);
--	reset_delb <= (not Z_aux(0)) after 1 ns;
	

end architecture RTL;
