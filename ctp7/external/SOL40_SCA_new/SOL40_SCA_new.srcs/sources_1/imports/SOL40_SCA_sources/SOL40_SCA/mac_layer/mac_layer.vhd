library ieee;
use ieee.std_logic_1164.all;

use work.SCA_Package.all;

entity mac_layer is
	port (
		tx_clk          : in  std_logic;
		rst                	: in  std_logic;
		--
		sca_cmd_data_i     	: in  payload_vector_t(0 to SCA_COUNT - 1);
		sca_cmd_ena_i      	: in  std_logic_vector(0 to SCA_COUNT - 1);
		sca_cmd_rdy_o      	: out std_logic_vector(0 to SCA_COUNT - 1);
		
		sca_rpy_data_o     	: out payload_vector_t(0 to SCA_COUNT - 1);
		sca_rpy_prot_rdy_i 	: in  std_logic_vector(0 to SCA_COUNT - 1);
		send_sca_rpy_o     	: out std_logic_vector(0 to SCA_COUNT - 1);
		reconnnect_i		:	in std_logic_vector(0 to SCA_COUNT - 1);
		
	 	sca_ch_state_o     	: out sca_ch_state_vector_t(0 to SCA_COUNT-1);
	 	sca_link_state_array_o	: out	SCA_link_state_array_t;
	 	
	 	--
	 	tx_sd              	: out elink_ch_array_t(0 to SCA_COUNT-1);
		rx_clk				:in	std_logic;
		rx_sd              	: in elink_ch_array_t(0 to SCA_COUNT-1)
	);
end entity mac_layer;

architecture RTL of mac_layer is
	
	component sca_mac_layer
		port(tx_clk             : in  std_logic;
			 rst                : in  std_logic;
			 sca_cmd_data_i     : in  payload_t;
			 sca_cmd_ena_i      : in  std_logic;
			 sca_cmd_rdy_o      : out std_logic;
			 sca_rpy_data_o     : out payload_t;
			 sca_rpy_prot_rdy_i : in  std_logic;
			 send_sca_rpy_o     : out std_logic;
			 reconnnect_i       : in  std_logic;
			 sca_ch_state_o     : out ch_state_vector_t;
			 scA_link_state_o   : out SCA_link_state_t;
			 tx_sd              : out std_logic_vector(1 downto 0);
			 rx_clk             : in  std_logic;
			 rx_sd              : in  std_logic_vector(1 downto 0));
	end component sca_mac_layer;
	
	
	type payload_by_gbt_and_sca_t is array(0 to GBT_COUNT-1,0 to SCA_BY_GBT_COUNT-1) of payload_t;
	type ch_state_vector_by_gbt_and_sca_t	is array(0 to GBT_COUNT-1,0 to SCA_BY_GBT_COUNT-1) of ch_state_vector_t;
	type std_logic_by_gbt_and_sca is array(0 to GBT_COUNT-1,0 to SCA_BY_GBT_COUNT-1) of std_logic;
	
	
	signal sca_cmd_data_by_gbt_and_sca	:	payload_by_gbt_and_sca_t;
	signal sca_rpy_data_by_gbt_and_sca	:	payload_by_gbt_and_sca_t;
	
	
	signal sca_ch_stater_by_gbt_and_sca	:	ch_state_vector_by_gbt_and_sca_t;
	
	
	signal send_sca_rpy_by_gbt_and_sca	:	std_logic_by_gbt_and_sca;
	signal sca_cmd_ena_by_gbt_and_sca	:	std_logic_by_gbt_and_sca;
	signal sca_cmd_rdy_by_gbt_and_sca	:	std_logic_by_gbt_and_sca;
	signal sca_rpy_prot_rdy_by_gbt_and_sca:	std_logic_by_gbt_and_sca;
	signal tx_sd_by_gbt_and_sca			:	elink_by_gbt_and_sca_t;
	signal rx_sd_by_gbt_and_sca			:	elink_by_gbt_and_sca_t;
	signal reconnnect_by_gbt_and_sca	:	std_logic_by_gbt_and_sca;
	
begin
	
	gen_by_gbt : for i in 0 to GBT_COUNT-1 generate
		gen_by_sca : for j in 0 to SCA_BY_GBT_COUNT-1 generate
			
			sca_mac_layer_inst : component sca_mac_layer
			port map(tx_clk             => tx_clk,
				     rst                => rst,
				     sca_cmd_data_i     => sca_cmd_data_by_gbt_and_sca(i,j),
				     sca_cmd_ena_i      => sca_cmd_ena_by_gbt_and_sca(i,j),
				     sca_cmd_rdy_o      => sca_cmd_rdy_by_gbt_and_sca(i,j),
				     sca_rpy_data_o     => sca_rpy_data_by_gbt_and_sca(i,j),
				     sca_rpy_prot_rdy_i => sca_rpy_prot_rdy_by_gbt_and_sca(i,j),
				     send_sca_rpy_o     => send_sca_rpy_by_gbt_and_sca(i,j),
				     reconnnect_i		=> reconnnect_by_gbt_and_sca(i,j),
				     sca_ch_state_o     => sca_ch_stater_by_gbt_and_sca(i,j),
				     sca_link_state_o	=> sca_link_state_array_o(i,j),
				     tx_sd              => tx_sd_by_gbt_and_sca(i,j),
				     rx_clk             => rx_clk,
				     rx_sd              => rx_sd_by_gbt_and_sca(i,j));
		
			
		end generate gen_by_sca;	
	end generate gen_by_gbt;
	
	
	name : process (rx_sd, sca_ch_stater_by_gbt_and_sca, sca_cmd_data_i, sca_cmd_ena_i, 
		sca_cmd_rdy_by_gbt_and_sca, sca_rpy_data_by_gbt_and_sca, sca_rpy_prot_rdy_i, 
		send_sca_rpy_by_gbt_and_sca, tx_sd_by_gbt_and_sca, reconnnect_i
	) is
		variable i		:	natural range 0 to GBT_COUNT-1;
		variable j		:	natural range 0 to SCA_BY_GBT_COUNT-1;
	begin
		for k in 0 to SCA_Count-1 loop
				i := k/SCA_BY_GBT_COUNT;
				j := k mod SCA_BY_GBT_COUNT;
				
				sca_cmd_data_by_gbt_and_sca(i,j) <= sca_cmd_data_i(k);
				sca_cmd_ena_by_gbt_and_sca(i,j) <= sca_cmd_ena_i(k);
				sca_cmd_rdy_o(k) <= sca_cmd_rdy_by_gbt_and_sca(i,j);
				sca_rpy_data_o(k) <= sca_rpy_data_by_gbt_and_sca(i,j);
				sca_rpy_prot_rdy_by_gbt_and_sca(i,j) <= sca_rpy_prot_rdy_i(k);
				send_sca_rpy_o(k) <= send_sca_rpy_by_gbt_and_sca(i,j);
				sca_ch_state_o(k) <= sca_ch_stater_by_gbt_and_sca(i,j);
				
				tx_sd(k) <= tx_sd_by_gbt_and_sca(i,j);
				rx_sd_by_gbt_and_sca(i,j) <= rx_sd(k);
				reconnnect_by_gbt_and_sca(i,j) <= reconnnect_i(k);
		end loop;
	end process name;
	
	
	
	
	

end architecture RTL;
