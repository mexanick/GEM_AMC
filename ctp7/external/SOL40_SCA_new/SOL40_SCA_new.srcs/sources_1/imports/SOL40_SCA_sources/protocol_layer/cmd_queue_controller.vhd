library ieee;
use ieee.std_logic_1164.all;

use work.SCA_Package.all;


--! This block contain all the command queues to be sent to their respectives gbt-sca channels
entity cmd_queue_controller is
	port (
		clk 						: 	in std_logic;
		rst 						: 	in std_logic;
		--Interface with the ECS Packets Buffer Layer
		ecs_cmd_prot_ena_o			:	out	std_logic;
		ecs_cmd_prot_av_i			:	in	std_logic;
		
		ecs_rpy_int_av_i			:	in	std_logic;
		ecs_rpy_int_ena_o			:	out	std_logic;
		--Interface with the Protocol Drivers
		sca_cmd_batch_i      		: 	in	prot_cmd_t;
		sca_rpy_batch_o				: 	out  prot_cmd_t;	
		--
		--Interface with the MAC Layer
		
		sca_cmd_data_o     		:	out payload_vector_t(0 to SCA_COUNT - 1);
		sca_cmd_ena_o      		:	out std_logic_vector(0 to SCA_COUNT -1);
		sca_cmd_rdy_i      		:	in 	std_logic_vector(0 to SCA_COUNT -1);
		--
		sca_rpy_data_i     		:	in	payload_vector_t(0 to SCA_COUNT - 1);
		sca_rpy_prot_rdy_o      :	out std_logic_vector(0 to SCA_COUNT -1);
		send_sca_rpy_i     		:	in 	std_logic_vector(0 to SCA_COUNT - 1);
		
		reconnnect_o			:	out	std_logic_vector(0 to SCA_COUNT -1)
		
		
	);
end entity cmd_queue_controller;

architecture RTL of cmd_queue_controller is
	
	
	signal command_queue	:	command_queue_t;
	
	component sca_roundtrip_timer
		port(clk    : in  std_logic;
			 en     : in  std_logic;
			 rst    : in  std_logic;
			 time_o : out sca_time_t);
	end component sca_roundtrip_timer;
	
	signal sca_time : sca_time_t;
	

begin
	
	sca_roundtrip_timer_inst : sca_roundtrip_timer
		port map(
			clk    => clk,
			en     => '1',
			rst    => rst,
			time_o => sca_time
		);
	

controller_state_machine : process (clk) is
	variable curr_state	:	prot_state_t;
	
	variable ecs_cmd_taken	:	std_logic;
	variable ecs_rpy_sent	:	std_logic;	
	variable links_taken		:	std_logic_vector(0 to SCA_COUNT-1) := (others=>'0');	
	variable sca_cmd_ena_var	:	std_logic_vector(0 to SCA_COUNT -1);
	
	variable curr_sca_index		:	natural range 0 to SCA_COUNT-1;
	
	variable reconnnect_var	:	std_logic_vector(0 to SCA_COUNT -1);
begin
	
	reconnnect_var := (others=>('0'));
		
	if rising_edge(clk) then
		for i in 0 to command_queue.prot_cmd'high loop
				curr_state := command_queue.prot_state(i);
				curr_sca_index := command_queue.prot_cmd(i).gbt*SCA_BY_GBT_COUNT + command_queue.prot_cmd(i).sca; --! <= this can result in headache during synthesis
				
			if rst = '1' then
				for i in 0 to command_queue.prot_cmd'high loop
						command_queue.prot_cmd(i).gbt <= 0;
						command_queue.prot_cmd(i).sca <= 0;
						command_queue.prot_cmd(i).ch <= (others=>'0');
						command_queue.prot_cmd(i).cmd_count <= 0;
						command_queue.prot_cmd(i).ecs_cmd <= (others=>'0');
						for j in 0 to command_queue.prot_cmd(i).sca_cmds'high loop
							command_queue.prot_cmd(i).sca_cmds(j) <= (others=>'0');
							command_queue.prot_cmd(i).sca_cmds_data(j).data <= (others=>'0');
							command_queue.prot_cmd(i).sca_cmds_data(j).len <= (others=>'0');
						end loop;
						command_queue.counter(i) <= 0;
						command_queue.prot_cmd(i).err <= (others=>'0');
						command_queue.prot_state(i) <= IDLE;
						command_queue.prot_cmd(i).tr <= x"01";
				end loop;
				sca_cmd_ena_var := (others=>'0');
				sca_rpy_prot_rdy_o <= (others=>'0');
			else
				ecs_cmd_taken :='0';
				ecs_rpy_sent := '0';
				links_taken := (others=>'0');	
				
				
					case curr_state is 
						when IDLE =>
							
							if ecs_cmd_prot_av_i = '1' and ecs_cmd_taken ='0' then
								ecs_cmd_taken := '1';
								curr_state := FETCH_SCA_CMD;
							end if;
						when FETCH_SCA_CMD =>
							curr_state := SEND_SCA_CMD;
							command_queue.prot_cmd(i) <= sca_cmd_batch_i;	
							
						when SEND_SCA_CMD =>
							
							if  sca_cmd_rdy_i(curr_sca_index)='1' and links_taken(curr_sca_index)='0' then
								links_taken(curr_sca_index):='1';
								sca_cmd_ena_var(curr_sca_index) := '1';
								curr_state := WAIT_SCA_RPY;
								-- Set Expiration Time Value
								if sca_time=0 then
									command_queue.expiration_time(i) <= sca_time_t'high;
								else
									command_queue.expiration_time(i) <= sca_time - 1;
								end if;
									
								
							end if;
						when WAIT_SCA_RPY =>
							sca_cmd_ena_var(curr_sca_index) := '0';
							if send_sca_rpy_i(curr_sca_index)='1' 
							and (sca_rpy_data_i(curr_sca_index).ch = command_queue.prot_cmd(i).ch ) then
								
								command_queue.prot_cmd(i).sca_rpys_data(command_queue.counter(i)).data <=  sca_rpy_data_i(curr_sca_index).data;
								command_queue.prot_cmd(i).sca_rpys_data(command_queue.counter(i)).len <=  sca_rpy_data_i(curr_sca_index).len;
								if sca_rpy_data_i(curr_sca_index).cmd_or_err /= (sca_rpy_data_i(curr_sca_index).cmd_or_err'range=>'0') then
									command_queue.prot_cmd(i).err <= sca_rpy_data_i(curr_sca_index).cmd_or_err;
									curr_state := ECS_RPY_RDY;
								elsif (sca_rpy_data_i(curr_sca_index).tr /= command_queue.prot_cmd(i).tr) or (sca_rpy_data_i(curr_sca_index).ch /=  command_queue.prot_cmd(i).ch) then
									command_queue.prot_cmd(i).err <= x"01";
									curr_state := ECS_RPY_RDY;
								elsif (command_queue.counter(i))= command_queue.prot_cmd(i).cmd_count - 1 then
									curr_state := ECS_RPY_RDY;
								else
									if (command_queue.counter(i) < command_queue.prot_cmd(i).cmd_count) then
										command_queue.counter(i) <= command_queue.counter(i) + 1;
										curr_state := SEND_SCA_CMD;
									else
										curr_state := ECS_RPY_RDY;
										sca_rpy_prot_rdy_o(curr_sca_index) <= '1';
									end if;
								end if;
								sca_rpy_prot_rdy_o(curr_sca_index) <= '1';
							else
								--If SCA didn`t respond, end the packet queue transmission and assert Error 01h on the ECS Reply
								if sca_time = command_queue.expiration_time(i) then
									command_queue.prot_cmd(i).err <= x"01";
									curr_state := ECS_RPY_RDY;
									sca_rpy_prot_rdy_o(curr_sca_index) <= '1';
									reconnnect_var(curr_sca_index) := '1';
								end if;
							end if;
						when ECS_RPY_RDY =>
							if ecs_rpy_sent='0' and ecs_rpy_int_av_i='1' then
								curr_state := IDLE;
								ecs_rpy_sent := '1';
								command_queue.prot_cmd(i).ecs_cmd <= x"FF"; 
							else
								curr_state := ECS_RPY_RDY;
							end if;
							command_queue.counter(i) <= 0;
					end case;
					command_queue.prot_state(i) <= curr_state; 
						
			end if;
			
			--03/06/2015 trial to turn code into a block rams
			sca_rpy_batch_o <= command_queue.prot_cmd(i);
			
			sca_cmd_data_o(curr_sca_index).ch <= command_queue.prot_cmd(i).ch;
			sca_cmd_data_o(curr_sca_index).cmd_or_err <= command_queue.prot_cmd(i).sca_cmds(command_queue.counter(i));
			sca_cmd_data_o(curr_sca_index).data <= command_queue.prot_cmd(i).sca_cmds_data(command_queue.counter(i)).data;
			sca_cmd_data_o(curr_sca_index).len <= command_queue.prot_cmd(i).sca_cmds_data(command_queue.counter(i)).len;
			sca_cmd_data_o(curr_sca_index).tr <= command_queue.prot_cmd(i).tr;
		
		end loop;
		
		sca_cmd_ena_o <= sca_cmd_ena_var;
		
		ecs_cmd_prot_ena_o <= ecs_cmd_taken;
		ecs_rpy_int_ena_o <= ecs_rpy_sent;
		
		reconnnect_o <= reconnnect_var; 
	end if;

end process controller_state_machine;
	

end architecture RTL;
