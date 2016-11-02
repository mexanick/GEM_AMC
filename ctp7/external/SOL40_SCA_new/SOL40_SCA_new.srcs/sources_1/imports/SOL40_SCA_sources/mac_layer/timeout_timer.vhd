library ieee;
use ieee.std_logic_1164.all;

use work.SCA_Package.all;

entity sca_roundtrip_timer is
	port (
		clk		:	in	std_logic;
		en		:	in	std_logic;
		rst		:	in	std_logic;
		time_o	:	out	sca_time_t
		
	);
end entity sca_roundtrip_timer;

architecture RTL of sca_roundtrip_timer is
	signal time	:	sca_time_t;
begin
	
	timeout_process : process (clk, rst) is
	begin
		if rst = '1' then
			time <= 0;
		elsif rising_edge(clk) then
			if en ='1' then
				if time = sca_time_t'high then
					time <= 0;
				else
					time <= time + 1;
				end if;
			end if;
		end if;
	end process timeout_process;
	
	time_o <= time;

end architecture RTL;
