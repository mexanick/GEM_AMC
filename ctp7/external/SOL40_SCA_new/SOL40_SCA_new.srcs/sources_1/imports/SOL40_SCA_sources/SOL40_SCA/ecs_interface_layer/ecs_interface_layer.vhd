library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Constant_Declaration.all;
use work.SCA_Package.all;

entity ecs_interface_layer is
	generic(
		BASE_ADDRESS			: in std_logic_vector(ECS_address_size-1 downto 0)
	);
	port (
		ECS_ADDRESS_i			: in	std_logic_vector(ECS_address_size-1 downto 0);
	    READ_ECS_RESPONSE_i		: in	std_logic;
	    ECS_RESPONSE_o			: out	std_logic_vector (ECS_data_size-1 downto 0);
	    ECS_RESPONSE_VALID_o	: out	std_logic;
	    ECS_COMMAND_i			: in	std_logic_vector (ECS_data_size-1 downto 0);
	    WRITE_ECS_COMMAND_i		: in	std_logic;
	    --
	    ecs_clk					: in	std_logic;
	    SRES_i					: in	std_logic;
	    --
		ecs_cmd_int_ena_o   	: out	std_logic;
		ecs_cmd_int_av_i    	: in	std_logic;
	 	ecs_cmd_int_data_o		: out 	ecs_packet_t;
		--
		ecs_rpy_int_isRead_o  	: out	std_logic;
		ecs_rpy_int_addr_o 		: out 	ecs_addr_packet_t;
		ecs_rpy_int_data_i 		: in	ecs_packet_t;
		new_rpy_i				: in	std_logic;
		
		sol40_sca_rst_o			:	out std_logic;
		sca_link_state_array	:	in	SCA_link_state_array_t
    );
end entity ecs_interface_layer;

architecture RTL of ecs_interface_layer is
	
	signal address_reg			:	ecs_addr_packet_t;
	signal ecs_cmd_int_data		: ecs_packet_t;
	
	signal ecs_rpy_int_ena_buf	:	std_logic;
	
	signal ecs_rpy_int_data_buf	:	ecs_packet_t;
	
	signal sol40_sca_rst		:	std_logic := '0';
	
	signal curr_SCA_link_state	: SCA_link_state_t;
	
begin
	
	assert ECS_data_size=32 report "Avalon/ECS_data_size is not 32, I'm not prepared for this" severity failure;
	assert false report "ECS_address_size or address_MM_slave_ECS are not used anyway" severity NOTE;
	
	
	interface : process(ecs_clk, SRES_i) is
		variable ecs_cmd_int_ena_var	:	std_logic;
		variable ecs_rpy_int_isRead_var	:	std_logic;
		variable sol40_sca_rst_var		:	std_logic;
		variable sca_link_state			:	std_logic_vector(2 downto 0);
		--variable sca_ch_state_
	begin
		ecs_cmd_int_ena_var := '0';
		
		if SRES_i='1' then

			ecs_rpy_int_isRead_o <= '0';
			address_reg <= ((others=>'0'),(others=>'0'),(others=>'0'));
			ECS_RESPONSE_o <= (others=>'1');
			ECS_RESPONSE_VALID_o <= '0';
			ecs_rpy_int_isRead_o <= '0';
			ecs_cmd_int_ena_o <= '0';
			sol40_sca_rst <= '0';
		elsif rising_edge(ecs_clk) then
			ecs_rpy_int_isRead_var	:= '0';
			ecs_cmd_int_ena_var := '0';
			sol40_sca_rst_var := '0';
			if BASE_ADDRESS(ECS_address_size-1 downto 8) = ECS_ADDRESS_i(ECS_address_size-1 downto 8)
				and BASE_ADDRESS(7 downto 0)=x"00" 
				and  ECS_ADDRESS_i(7 downto 0) >= x"00"
				and  ECS_ADDRESS_i(7 downto 0) <= x"3f"
				then
				
				if WRITE_ECS_COMMAND_i='1' then
					case ECS_ADDRESS_i(7 downto 0) is
						
					--! Bit 0 - Go Write, Bit 1 - Go Read, Bit 2 - Reply Available, Bit 3 - Reset, Bit 4--
					when x"00"=>
						if (ECS_COMMAND_i(3)='1') then
							sol40_sca_rst_var:='1';
						else
							if (ECS_COMMAND_i(0)='1') then -- GO WRITE
								ecs_cmd_int_ena_var := '1';
							end if;
							
							if (ECS_COMMAND_i(1)='1') then -- GO READ
								ecs_rpy_int_isRead_var := '1';
								ecs_rpy_int_data_buf <= ecs_rpy_int_data_i;
							end if;
						end if;
							
						when x"04"=>
							address_reg.gbt_nr <= ECS_COMMAND_i(31 downto 31-7);
							address_reg.sca_nr <= ECS_COMMAND_i(31-8 downto 31-15);
							address_reg.sca_ch <= ECS_COMMAND_i(31-16 downto 31-23);
						when x"08"=>
							ecs_cmd_int_data.gbt_nr <= ECS_COMMAND_i(31 downto 31-7);
							ecs_cmd_int_data.sca_nr <= ECS_COMMAND_i(31-8 downto 31-15);
							ecs_cmd_int_data.sca_ch <= ECS_COMMAND_i(31-16 downto 31-23);
							ecs_cmd_int_data.ecs_cmd <= ECS_COMMAND_i(31-24 downto 31-31);
						when x"0C"=>
							ecs_cmd_int_data.len <= ECS_COMMAND_i(23 downto 16);
							ecs_cmd_int_data.protocol_specific <= ECS_COMMAND_i(15 downto 0);
						when x"10"=>
							ecs_cmd_int_data.data(31 downto 0) <= ECS_COMMAND_i;
						when x"14"=>
							ecs_cmd_int_data.data(63 downto 32) <= ECS_COMMAND_i;
						when x"18"=>
							ecs_cmd_int_data.data(95 downto 64) <= ECS_COMMAND_i;
						when x"1C"=>
							ecs_cmd_int_data.data(127 downto 96) <= ECS_COMMAND_i;																																																																									
						when others=>
							null;
					end case;
					ECS_RESPONSE_o <= (others=>'1');
					ECS_RESPONSE_VALID_o <= '0';
				elsif  READ_ECS_RESPONSE_i='1' then
					ECS_RESPONSE_VALID_o <= '1';
					case ECS_ADDRESS_i(7 downto 0) is
                        when x"00"=>
                            case curr_SCA_link_state is 
                                when RESET =>
                                    sca_link_state := "000";
                                when IDLE =>
                                    sca_link_state := "001";
                                when TESTING =>
                                    sca_link_state := "010";
                                when CONNECTING =>
                                    sca_link_state := "011";
                                when READY =>
                                    sca_link_state := "100";
                                when FAILED =>
                                    sca_link_state := "101";
                            end case;
						
                            ECS_RESPONSE_o(2) <= new_rpy_i; -- Reply available at the req address
                            ECS_RESPONSE_o(6 downto 4) <= sca_link_state;
                            ECS_RESPONSE_o(1 downto 0) <= (others=>'0');
                            ECS_RESPONSE_o(3) <= '0';
                            ECS_RESPONSE_o(31 downto 7) <= (others=>'0');
						
						when x"04"=>
							ECS_RESPONSE_o(31 downto 31-7) <= address_reg.gbt_nr;
							ECS_RESPONSE_o(31-8 downto 31-15) <= address_reg.sca_nr;
							ECS_RESPONSE_o(31-16 downto 31-23) <= address_reg.sca_ch;
						when x"08"=>
							ECS_RESPONSE_o(31 downto 31-7) <= ecs_cmd_int_data.gbt_nr;
							ECS_RESPONSE_o(31-8 downto 31-15) <= ecs_cmd_int_data.sca_nr;
							ECS_RESPONSE_o(31-16 downto 31-23) <= ecs_cmd_int_data.sca_ch;
							ECS_RESPONSE_o(31-24 downto 31-31) <= ecs_cmd_int_data.ecs_cmd;
						when x"0C"=>
							ECS_RESPONSE_o(31 downto 24) <= (others=>'0');
							ECS_RESPONSE_o(23 downto 16) <= ecs_cmd_int_data.len;
							ECS_RESPONSE_o(15 downto 0) <= ecs_cmd_int_data.protocol_specific;
						when x"10"=>
							ECS_RESPONSE_o <= ecs_cmd_int_data.data(31 downto 0);
						when x"14"=>
							ECS_RESPONSE_o <= ecs_cmd_int_data.data(63 downto 32);
						when x"18"=>
							ECS_RESPONSE_o <= ecs_cmd_int_data.data(95 downto 64);
						when x"1C"=>
							ECS_RESPONSE_o <= ecs_cmd_int_data.data(127 downto 96);
						when x"20"=>
							ECS_RESPONSE_o(31 downto 31-7) <= ecs_rpy_int_data_buf.gbt_nr;
							ECS_RESPONSE_o(31-8 downto 31-15) <= ecs_rpy_int_data_buf.sca_nr;
							ECS_RESPONSE_o(31-16 downto 31-23) <= ecs_rpy_int_data_buf.sca_ch;
							ECS_RESPONSE_o(31-24 downto 31-31) <= ecs_rpy_int_data_buf.ecs_cmd;
						when x"24"=>
							ECS_RESPONSE_o(31 downto 24) <=  ecs_rpy_int_data_buf.err;
							ECS_RESPONSE_o(23 downto 16) <= ecs_rpy_int_data_buf.len(7 downto 0);
							ECS_RESPONSE_o(15 downto 0) <= ecs_rpy_int_data_buf.protocol_specific;
						when x"28"=>
							ECS_RESPONSE_o <= ecs_rpy_int_data_buf.data(31 downto 0);
						when x"2C"=>
							ECS_RESPONSE_o <= ecs_rpy_int_data_buf.data(63 downto 32);
						when x"30"=>
							ECS_RESPONSE_o <= ecs_rpy_int_data_buf.data(95 downto 64);
						when x"34"=>
							ECS_RESPONSE_o <= ecs_rpy_int_data_buf.data(127 downto 96);
						when others=>
							ECS_RESPONSE_o <= (others=>'1');																																																						
					end case;
				else
					ECS_RESPONSE_VALID_o <= '0';
					ECS_RESPONSE_o <= (others=>'0');
				end if;
			else
				ECS_RESPONSE_o <= (others=>'1');
				--------------------------------------------
				--INVALID ADDRESS AREA
				ECS_RESPONSE_VALID_o <= '0';
				--------------------------------------------
			end if;
			sol40_sca_rst <= sol40_sca_rst_var;
			ecs_rpy_int_addr_o <= address_reg;
			ecs_rpy_int_isRead_o <= ecs_rpy_int_isRead_var;
			ecs_cmd_int_ena_o <= ecs_cmd_int_ena_var;
		end if;
		
		
		sol40_sca_rst_o <= sol40_sca_rst_var;
		
	end process interface;
	
	name : process (ecs_clk) is
		variable i		:	natural range 0 to GBT_COUNT-1 := 0;
		variable j		:	natural range 0 to SCA_BY_GBT_COUNT-1:=0;
	begin
		if rising_edge(ecs_clk) then
			if to_integer(unsigned(address_reg.gbt_nr)) < GBT_COUNT then
				i := to_integer(unsigned(address_reg.gbt_nr));
			end if;
			
			if to_integer(unsigned(address_reg.sca_nr)) < SCA_BY_GBT_COUNT then
				j:= to_integer(unsigned(address_reg.sca_nr));
			end if;
			curr_SCA_link_state <= sca_link_state_array(i,j);
		end if;
	end process name;
	
	
	
	ecs_cmd_int_data_o <= ecs_cmd_int_data;
	
end architecture RTL;
