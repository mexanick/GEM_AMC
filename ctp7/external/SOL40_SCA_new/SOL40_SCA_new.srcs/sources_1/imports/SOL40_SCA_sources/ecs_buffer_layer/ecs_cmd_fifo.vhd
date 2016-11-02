library ieee;
use ieee.std_logic_1164.all;

use work.sca_package.all;


entity ecs_cmd_fifo is
	generic(
		FIFO_LENGTH	:	natural:=2
	);
	port (
		clk 						: in std_logic;
		rst							: in std_logic;
		
		--ECS Interface Layer
		ecs_cmd_int_av_o			:	out	std_logic;
		ecs_cmd_int_data_i			:	in	ecs_packet_t;
		ecs_cmd_int_ena_i			:	in	std_logic;
		
		--ECS Protocol Layer
		ecs_cmd_prot_ena_i			:	in	std_logic;
		ecs_cmd_prot_av_o			:	out	std_logic;
		ecs_cmd_prot_data_o			:	out	ecs_packet_t
		
	);
end entity ecs_cmd_fifo;

architecture RTL of ecs_cmd_fifo is
	
	constant Length		:	natural:=FIFO_LENGTH;
	signal w_ptr,r_ptr	:	natural range 0 to Length - 1;
	signal cmd_fifo 	:	ecs_packet_array_t(0 to Length - 1);
	signal full,empty	:	std_logic;
	
begin
	
	empty	<= '1' when (w_ptr=r_ptr) else '0'; 
	full	<= '1' when ((w_ptr=r_ptr-1 and r_ptr/=0) or (w_ptr=Length-1 and r_ptr=0)) else '0';
	
	fifo_control : process (clk) is
	begin
		if rising_edge(clk) then
			if rst = '1' then
				w_ptr <= 0;
				r_ptr <= 0;
			else
				if ecs_cmd_int_ena_i='1' and full='0' then
					--cmd_fifo(w_ptr) <= ecs_cmd_int_data_i;
					
					if w_ptr = Length-1 then
						w_ptr <= 0;
					else
						w_ptr <= w_ptr + 1;
					end if;
				end if;
				--ecs_cmd_prot_data_o <= cmd_fifo(r_ptr);
				if ecs_cmd_prot_ena_i='1' and empty='0' then
					--ecs_cmd_prot_data_o <= cmd_fifo(r_ptr);
					if r_ptr = Length-1 then
						r_ptr <= 0;
					else
						r_ptr <= r_ptr + 1;
					end if;
				end if;
			end if;
		end if;
	end process fifo_control;
	
	ecs_cmd_int_av_o <= not full;
	
	ecs_cmd_prot_av_o <= not empty and not ecs_cmd_prot_ena_i;
	
	
	
	fifo_data : process (clk) is
	begin
		if rising_edge(clk) then
			if ecs_cmd_int_ena_i='1' and full='0' then
				cmd_fifo(w_ptr) <= ecs_cmd_int_data_i;
			end if;
			ecs_cmd_prot_data_o <= cmd_fifo(r_ptr);
		end if;
	end process fifo_data;
	
	
	
	

end architecture RTL;
