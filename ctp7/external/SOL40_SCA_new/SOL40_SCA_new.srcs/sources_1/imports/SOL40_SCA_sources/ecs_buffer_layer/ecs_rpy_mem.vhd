library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SCA_Package.all;

--! This block is coded to use Block RAM units, so no Reset should be used 
--! and there`s no need for an enable for Read operations
entity ecs_rpy_mem is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		--ECS Interface LAyer
		ecs_rpy_int_isRead_i		:	in	std_logic;
		ecs_rpy_int_addr_i			:	in	ecs_addr_packet_t;
		ecs_rpy_int_av_o			:	out	std_logic;
		ecs_rpy_int_data_o			:	out	ecs_packet_t;
		new_rpy_o					:	out	std_logic;
		
		--ECS Protocol Layer
		ecs_rpy_prot_av_o			:	out	std_logic;
		ecs_rpy_prot_ena_i			:	in	std_logic;
		ecs_rpy_prot_data_i			:	in	ecs_packet_t
	);
end entity ecs_rpy_mem;

architecture RTL of ecs_rpy_mem is
	
	type mem_t is array(natural range <>) of std_logic_vector(ECS_DATA_WIDTH-1 downto 0);
	signal mem :	mem_t(0 to ECS_MEM_COUNT-1 );
	
	
	
	signal new_rpy_by_ch		:	std_logic_vector(0 to ECS_MEM_COUNT-1):=(others=>'0');
	
begin
	
	name : process (clk) is
		variable addr_w,addr_r	:	natural range 0 to ECS_MEM_COUNT-1;
		variable  data_r	:	std_logic_vector(ECS_DATA_WIDTH - 1 downto 0);
	begin
		if rising_edge(clk) then
			addr_r := to_integer(unsigned(ecs_rpy_int_addr_i.gbt_nr))*(SCA_BY_GBT_COUNT*CH_BY_SCA_COUNT)
						+ to_integer(unsigned(ecs_rpy_int_addr_i.sca_nr))*(CH_BY_SCA_COUNT)
						+ to_integer(unsigned(ecs_rpy_int_addr_i.sca_ch));
			data_r := mem(addr_r);
			
			ecs_rpy_int_data_o.gbt_nr <= ecs_rpy_int_addr_i.gbt_nr;
			ecs_rpy_int_data_o.sca_nr <= ecs_rpy_int_addr_i.sca_nr;
			ecs_rpy_int_data_o.sca_ch <= ecs_rpy_int_addr_i.sca_ch;
			
			ecs_rpy_int_data_o.ecs_cmd <= data_r(data_r'high downto data_r'high -7);
			ecs_rpy_int_data_o.err <= data_r(data_r'high - 8 downto data_r'high - 15);
			ecs_rpy_int_data_o.len <= data_r(data_r'high - 16 downto data_r'high - 23);
			ecs_rpy_int_data_o.protocol_specific <= data_r(data_r'high - 24 downto data_r'high - 39);
			ecs_rpy_int_data_o.data <= data_r(data_r'high - 40 downto 0);
			
			--ecs_rpy_prot_av_o <= '1';
			ecs_rpy_int_av_o <= '1';
			
			addr_w := to_integer(unsigned(ecs_rpy_prot_data_i.gbt_nr))*(SCA_BY_GBT_COUNT*CH_BY_SCA_COUNT)
							+ to_integer(unsigned(ecs_rpy_prot_data_i.sca_nr))*(CH_BY_SCA_COUNT)
							+ to_integer(unsigned(ecs_rpy_prot_data_i.sca_ch)); 
			
			if ecs_rpy_prot_ena_i = '1' then
				mem(addr_w) <= ecs_rpy_prot_data_i.ecs_cmd
								& ecs_rpy_prot_data_i.err
								& ecs_rpy_prot_data_i.len
								& ecs_rpy_prot_data_i.protocol_specific
								& ecs_rpy_prot_data_i.data;
			end if;
		end if;
	end process name;
	
	new_rpy_manager : process(clk, new_rpy_by_ch) is
		variable addr_w,addr_r	:	natural range 0 to ECS_MEM_COUNT-1;
	begin
		if rising_edge(clk) then
			addr_w := to_integer(unsigned(ecs_rpy_prot_data_i.gbt_nr))*(SCA_BY_GBT_COUNT*CH_BY_SCA_COUNT)
						+ to_integer(unsigned(ecs_rpy_prot_data_i.sca_nr))*(CH_BY_SCA_COUNT)
						+ to_integer(unsigned(ecs_rpy_prot_data_i.sca_ch)); 
			addr_r := to_integer(unsigned(ecs_rpy_int_addr_i.gbt_nr))*(SCA_BY_GBT_COUNT*CH_BY_SCA_COUNT)
						+ to_integer(unsigned(ecs_rpy_int_addr_i.sca_nr))*(CH_BY_SCA_COUNT)
						+ to_integer(unsigned(ecs_rpy_int_addr_i.sca_ch)); 
							
			if rst='1' then
				new_rpy_by_ch <= (others=>'0');
			else
				if ecs_rpy_int_isRead_i='0' and ecs_rpy_prot_ena_i='1' then
					new_rpy_by_ch(addr_w) <= '1';
				elsif  ecs_rpy_int_isRead_i='1' and ecs_rpy_prot_ena_i='0'  then
					new_rpy_by_ch(addr_r) <= '0';
				elsif ecs_rpy_int_isRead_i='1' and ecs_rpy_prot_ena_i='1' then
					if addr_r /= addr_w then
						new_rpy_by_ch(addr_r) <= '0';
						new_rpy_by_ch(addr_w) <= '1';
					else
						new_rpy_by_ch(addr_w) <= '1';
					end if;
				end if;
			end if;
		end if;					
		new_rpy_o <= new_rpy_by_ch(addr_r);	
	end process new_rpy_manager;
	
	--ecs_rpy_prot_av_o <= not ecs_rpy_int_isRead_i; --11_06_2015
	ecs_rpy_prot_av_o <= not ecs_rpy_int_isRead_i and not ecs_rpy_prot_ena_i;
	
	--ecs_cmd_prot_av_o <= not empty and not ecs_cmd_prot_ena_i;
	

end architecture RTL;
