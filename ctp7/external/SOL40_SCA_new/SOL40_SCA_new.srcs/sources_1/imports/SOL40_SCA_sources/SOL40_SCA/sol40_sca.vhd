library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library work;
--use work.STFC_configuration.all;
--use work.Detector_Constant_Declaration.all;
use work.Constant_Declaration.all;
use work.SCA_Package.all;

entity sol40_sca is
	generic(
		BASE_ADDRESS			: in std_logic_vector(ECS_address_size-1 downto 0) := (others=>'0')
	);
	port(
		ECS_CLK					: in std_logic;   -- 40 MHz clock
		ECS_ADDRESS_i			: in std_logic_vector(ECS_address_size-1 downto 0);
	    READ_ECS_RESPONSE_i		: in std_logic;
	    ECS_RESPONSE_o			: out std_logic_vector(ECS_data_size-1 downto 0);
	    ECS_RESPONSE_VALID_o	: out std_logic;
	    ECS_COMMAND_i			: in std_logic_vector (ECS_data_size-1 downto 0);
	    WRITE_ECS_COMMAND_i		: in std_logic;
	    --
	    txClock40				: in std_logic;
	    rxClock40				:	in	std_logic;
	    SRES_i          		: in std_logic;
		--
	    tx_sd					: out elink_ch_array_t(0 to SCA_COUNT - 1);
        rx_sd					: in elink_ch_array_t(0 to SCA_COUNT - 1);
        --
        --ecs_cmd_int_data_o_intlay : out  -- DIVIDE ECS PACKET T IN SEVERALL OUTPUTS!! 
        -- Output from interface layer
        ecs_cmd_int_data_o_intlay_gbt_nr    : out std_logic_vector(7 downto 0);
        ecs_cmd_int_data_o_intlay_sca_nr    : out std_logic_vector(7 downto 0);
        ecs_cmd_int_data_o_intlay_sca_ch    : out std_logic_vector(7 downto 0);
        ecs_cmd_int_data_o_intlay_ecs_cmd   : out std_logic_vector(7 downto 0);
        ecs_cmd_int_data_o_intlay_err       : out std_logic_vector(7 downto 0);
        ecs_cmd_int_data_o_intlay_len       : out std_logic_vector(7 downto 0);
        ecs_cmd_int_data_o_intlay_prot_spec : out std_logic_vector(15 downto 0);
        ecs_cmd_int_data_o_intlay_data      : out std_logic_vector(127 downto 0);
        -- Output from buffer layer
        ecs_cmd_prot_data_o_buflay_gbt_nr    : out std_logic_vector(7 downto 0);
        ecs_cmd_prot_data_o_buflay_sca_nr    : out std_logic_vector(7 downto 0);
        ecs_cmd_prot_data_o_buflay_sca_ch    : out std_logic_vector(7 downto 0);
        ecs_cmd_prot_data_o_buflay_ecs_cmd   : out std_logic_vector(7 downto 0);
        ecs_cmd_prot_data_o_buflay_err       : out std_logic_vector(7 downto 0);
        ecs_cmd_prot_data_o_buflay_len       : out std_logic_vector(7 downto 0);
        ecs_cmd_prot_data_o_buflay_prot_spec : out std_logic_vector(15 downto 0);
        ecs_cmd_prot_data_o_buflay_data      : out std_logic_vector(127 downto 0);
        -- Output from protocol layer
        sca_cmd_data_protlay_payload_tr         : out std_logic_vector(7 downto 0);
        sca_cmd_data_protlay_payload_ch         : out std_logic_vector(7 downto 0);
        sca_cmd_data_protlay_payload_cmd_or_err : out std_logic_vector(7 downto 0);
        sca_cmd_data_protlay_payload_len        : out std_logic_vector(7 downto 0);
        sca_cmd_data_protlay_payload_data       : out std_logic_vector(31 downto 0));
end sol40_sca;
 
architecture rtl of sol40_sca is
	
	component ecs_interface_layer
		generic(BASE_ADDRESS : std_logic_vector(ECS_address_size - 1 downto 0));
		port(ECS_ADDRESS_i        : in  std_logic_vector(ECS_address_size - 1 downto 0);
			 READ_ECS_RESPONSE_i  : in  std_logic;
			 ECS_RESPONSE_o       : out std_logic_vector(ECS_data_size - 1 downto 0);
			 ECS_RESPONSE_VALID_o : out std_logic;
			 ECS_COMMAND_i        : in  std_logic_vector(ECS_data_size - 1 downto 0);
			 WRITE_ECS_COMMAND_i  : in  std_logic;
			 ecs_clk              : in  std_logic;
			 SRES_i               : in  std_logic;
			 ecs_cmd_int_ena_o    : out std_logic;
			 ecs_cmd_int_av_i     : in  std_logic;
			 ecs_cmd_int_data_o   : out ecs_packet_t;
			 ecs_rpy_int_isRead_o : out std_logic;
			 ecs_rpy_int_addr_o   : out ecs_addr_packet_t;
			 ecs_rpy_int_data_i   : in  ecs_packet_t;
			 new_rpy_i            : in  std_logic;
			 sol40_sca_rst_o      : out std_logic;
			 sca_link_state_array	:	in	SCA_link_state_array_t);
	end component ecs_interface_layer;
 	
      
 	component ecs_buffer_layer
 		port(clk                  : in  std_logic;
 			 rst                  : in  std_logic;
 			 ecs_cmd_int_av_o    : out std_logic;
 			 ecs_cmd_int_ena_i     : in  std_logic;
 			 ecs_cmd_int_data_i   : in  ecs_packet_t;
 			 ecs_rpy_int_isRead_i : in  std_logic;
 			 ecs_rpy_int_addr_i   : in  ecs_addr_packet_t;
 			 ecs_rpy_int_av_o     : out std_logic;
 			 ecs_rpy_int_data_o   : out ecs_packet_t;
 			 new_rpy_o            : out std_logic;
 			 ecs_rpy_prot_av_o    : out std_logic;
 			 ecs_rpy_prot_ena_i   : in  std_logic;
 			 ecs_rpy_prot_data_i  : in  ecs_packet_t;
 			 ecs_cmd_prot_ena_i   : in  std_logic;
 			 ecs_cmd_prot_av_o    : out std_logic;
 			 ecs_cmd_prot_data_o  : out ecs_packet_t);
 	end component ecs_buffer_layer;
 	
 	component protocol_layer
 		port(clk                 : in  std_logic;
 			 rst                 : in  std_logic;
 			 ecs_cmd_prot_ena_o  : out std_logic;
 			 ecs_cmd_prot_av_i   : in  std_logic;
 			 ecs_cmd_prot_data_i : in  ecs_packet_t;
 			 ecs_rpy_prot_av_i   : in  std_logic;
 			 ecs_rpy_prot_ena_o  : out std_logic;
 			 ecs_rpy_prot_data_o : out ecs_packet_t;
 			 sca_cmd_data_o      : out payload_vector_t(0 to SCA_COUNT - 1);
 			 sca_cmd_ena_o       : out std_logic_vector(0 to SCA_COUNT - 1);
 			 sca_cmd_rdy_i       : in  std_logic_vector(0 to SCA_COUNT - 1);
 			 sca_rpy_data_i      : in  payload_vector_t(0 to SCA_COUNT - 1);
 			 sca_rpy_prot_rdy_o  : out std_logic_vector(0 to SCA_COUNT - 1);
 			 send_sca_rpy_i      : in  std_logic_vector(0 to SCA_COUNT - 1);
 			 reconnnect_o        : out std_logic_vector(0 to SCA_COUNT - 1));
 	end component protocol_layer;
 	
 	component mac_layer
 		port(tx_clk                 : in  std_logic;
 			 rst                    : in  std_logic;
 			 sca_cmd_data_i         : in  payload_vector_t(0 to SCA_COUNT - 1);
 			 sca_cmd_ena_i          : in  std_logic_vector(0 to SCA_COUNT - 1);
 			 sca_cmd_rdy_o          : out std_logic_vector(0 to SCA_COUNT - 1);
 			 sca_rpy_data_o         : out payload_vector_t(0 to SCA_COUNT - 1);
 			 sca_rpy_prot_rdy_i     : in  std_logic_vector(0 to SCA_COUNT - 1);
 			 send_sca_rpy_o         : out std_logic_vector(0 to SCA_COUNT - 1);
 			 reconnnect_i           : in  std_logic_vector(0 to SCA_COUNT - 1);
 			 sca_ch_state_o         : out sca_ch_state_vector_t(0 to SCA_COUNT - 1);
 			 sca_link_state_array_o : out SCA_link_state_array_t;
 			 tx_sd                  : out elink_ch_array_t(0 to SCA_COUNT - 1);
 			 rx_clk                 : in  std_logic;
 			 rx_sd                  : in  elink_ch_array_t(0 to SCA_COUNT - 1));
 	end component mac_layer;
 	
 	
	signal ecs_cmd_prot_ena : std_logic;
	signal ecs_cmd_prot_av : std_logic;
	signal ecs_rpy_prot_ena : std_logic;
	signal ecs_cmd_prot_data : ecs_packet_t;
	signal ecs_rpy_prot_av : std_logic;
	signal ecs_rpy_prot_data : ecs_packet_t;
	signal sca_cmd_data : payload_vector_t(0 to SCA_COUNT - 1);
	signal sca_cmd_ena : std_logic_vector(0 to SCA_COUNT - 1);
	signal sca_cmd_rdy : std_logic_vector(0 to SCA_COUNT - 1);
	signal sca_rpy_data : payload_vector_t(0 to SCA_COUNT - 1);
	signal send_sca_rpy : std_logic_vector(0 to SCA_COUNT - 1);
	signal sca_rpy_prot_rdy : std_logic_vector(0 to SCA_COUNT - 1);
	signal reconnnect       :   std_logic_vector(0 to SCA_COUNT - 1);
	signal sca_link_state_array : SCA_link_state_array_t;
       
 	signal clk,rst	:	std_logic;
 	signal sca_ch_state : sca_ch_state_vector_t(0 to SCA_COUNT-1);
 	signal ecs_cmd_int_ena : std_logic;
 	signal ecs_cmd_int_av : std_logic;
 	signal ecs_cmd_int_data : ecs_packet_t;
 	signal ecs_rpy_int_ena : std_logic;
 	signal ecs_rpy_int_addr : ecs_addr_packet_t;
 	signal ecs_rpy_int_av : std_logic;
 	signal ecs_rpy_int_data : ecs_packet_t;
 	signal ecs_rpy_int_isRead : std_logic;
 	signal new_rpy : std_logic;
 	signal sol40_sca_rst : std_logic;
 	
 	
--     
begin
	
	
	ecs_interface_layer_inst : component ecs_interface_layer
		generic map(
			BASE_ADDRESS => BASE_ADDRESS
		)
		port map(
			ECS_ADDRESS_i         => ECS_ADDRESS_i,
			READ_ECS_RESPONSE_i  => READ_ECS_RESPONSE_i,
			ECS_RESPONSE_o       => ECS_RESPONSE_o,
			ECS_RESPONSE_VALID_o => ECS_RESPONSE_VALID_o,
			ECS_COMMAND_i        => ECS_COMMAND_i,
			WRITE_ECS_COMMAND_i  => WRITE_ECS_COMMAND_i,
			ecs_clk            => ecs_clk,
			SRES_i               => SRES_i,
			ecs_cmd_int_ena_o    => ecs_cmd_int_ena,
			ecs_cmd_int_av_i     => ecs_cmd_int_av,
			ecs_cmd_int_data_o   => ecs_cmd_int_data,
			ecs_rpy_int_isRead_o => ecs_rpy_int_isRead,
			ecs_rpy_int_addr_o   => ecs_rpy_int_addr,
			ecs_rpy_int_data_i   => ecs_rpy_int_data,
			new_rpy_i            => new_rpy,
			--
			sol40_sca_rst_o	 	=> sol40_sca_rst,
			sca_link_state_array	=> sca_link_state_array
		);
	--For debug on ILA	
    ecs_cmd_int_data_o_intlay_gbt_nr    <= ecs_cmd_int_data.gbt_nr;
    ecs_cmd_int_data_o_intlay_sca_nr    <= ecs_cmd_int_data.sca_nr;
    ecs_cmd_int_data_o_intlay_sca_ch    <= ecs_cmd_int_data.sca_ch;
    ecs_cmd_int_data_o_intlay_ecs_cmd   <= ecs_cmd_int_data.ecs_cmd;
    ecs_cmd_int_data_o_intlay_err       <= ecs_cmd_int_data.err;
    ecs_cmd_int_data_o_intlay_len       <= ecs_cmd_int_data.len;
    ecs_cmd_int_data_o_intlay_prot_spec <= ecs_cmd_int_data.protocol_specific;
    ecs_cmd_int_data_o_intlay_data      <= ecs_cmd_int_data.data;

	ecs_buffer_layer_inst : component ecs_buffer_layer
		port map(
			clk                  => ecs_clk,
			rst                  => rst,
			ecs_cmd_int_av_o    => ecs_cmd_int_av,
			ecs_cmd_int_ena_i     => ecs_cmd_int_ena,
			ecs_cmd_int_data_i   => ecs_cmd_int_data,
			ecs_rpy_int_isRead_i => ecs_rpy_int_isRead,
			ecs_rpy_int_addr_i   => ecs_rpy_int_addr,
			ecs_rpy_int_av_o     => ecs_rpy_int_av,
			ecs_rpy_int_data_o   => ecs_rpy_int_data,
			new_rpy_o            => new_rpy,
			ecs_rpy_prot_av_o    => ecs_rpy_prot_av,
			ecs_rpy_prot_ena_i   => ecs_rpy_prot_ena,
			ecs_rpy_prot_data_i  => ecs_rpy_prot_data,
			ecs_cmd_prot_ena_i   => ecs_cmd_prot_ena,
			ecs_cmd_prot_av_o    => ecs_cmd_prot_av,
			ecs_cmd_prot_data_o  => ecs_cmd_prot_data
		);
	-- For debug
	ecs_cmd_prot_data_o_buflay_gbt_nr    <= ecs_cmd_prot_data.gbt_nr; 
    ecs_cmd_prot_data_o_buflay_sca_nr    <= ecs_cmd_prot_data.sca_nr; 
    ecs_cmd_prot_data_o_buflay_sca_ch    <= ecs_cmd_prot_data.sca_ch; 
    ecs_cmd_prot_data_o_buflay_ecs_cmd   <= ecs_cmd_prot_data.ecs_cmd; 
    ecs_cmd_prot_data_o_buflay_err       <= ecs_cmd_prot_data.err; 
    ecs_cmd_prot_data_o_buflay_len       <= ecs_cmd_prot_data.len; 
    ecs_cmd_prot_data_o_buflay_prot_spec <= ecs_cmd_prot_data.protocol_specific; 
    ecs_cmd_prot_data_o_buflay_data      <= ecs_cmd_prot_data.data; 

	--clk <= txClock40;
	rst <= SRES_i or sol40_sca_rst;
	
	protocol_layer_inst : component protocol_layer
		port map(clk                 => txClock40,
			     rst                 => rst,
			     ecs_cmd_prot_ena_o  => ecs_cmd_prot_ena,
			     ecs_cmd_prot_av_i   => ecs_cmd_prot_av,
			     ecs_cmd_prot_data_i => ecs_cmd_prot_data,
			     ecs_rpy_prot_av_i   => ecs_rpy_prot_av,
			     ecs_rpy_prot_ena_o  => ecs_rpy_prot_ena,
			     ecs_rpy_prot_data_o => ecs_rpy_prot_data,
			     sca_cmd_data_o      => sca_cmd_data,
			     sca_cmd_ena_o       => sca_cmd_ena,
			     sca_cmd_rdy_i   => sca_cmd_rdy,
			     sca_rpy_data_i      => sca_rpy_data,
			     sca_rpy_prot_rdy_o  => sca_rpy_prot_rdy,
			     send_sca_rpy_i      => send_sca_rpy,
			     reconnnect_o			 => reconnnect);
     -- For debug
     sca_cmd_data_protlay_payload_tr         <= sca_cmd_data(0).tr;
     sca_cmd_data_protlay_payload_ch         <= sca_cmd_data(0).ch;
     sca_cmd_data_protlay_payload_cmd_or_err <= sca_cmd_data(0).cmd_or_err; 
     sca_cmd_data_protlay_payload_len        <= sca_cmd_data(0).len; 
     sca_cmd_data_protlay_payload_data       <= sca_cmd_data(0).data; 
     
			     
	mac_layer_inst : component mac_layer
		port map(tx_clk             => txClock40,
			     rst                => rst,
			     sca_cmd_data_i     => sca_cmd_data,
			     sca_cmd_ena_i      => sca_cmd_ena,
			     sca_cmd_rdy_o      => sca_cmd_rdy,
			     sca_rpy_data_o     => sca_rpy_data,
			     sca_rpy_prot_rdy_i => sca_rpy_prot_rdy,
			     send_sca_rpy_o     => send_sca_rpy,
			     reconnnect_i		=> reconnnect,
			     sca_ch_state_o     => sca_ch_state,
			     sca_link_state_array_o =>sca_link_state_array,
			     tx_sd              => tx_sd,
			     rx_clk             => rxClock40, --clk,
			     rx_sd              => rx_sd);
			     
 
			     
			     
end architecture rtl;
