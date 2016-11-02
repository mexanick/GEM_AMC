library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SCA_Package.all;

entity protocol_layer is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		
		--ECS Protocol Layer
		ecs_cmd_prot_ena_o			:	out	std_logic;
		ecs_cmd_prot_av_i			:	in	std_logic;
		ecs_cmd_prot_data_i			:	in	ecs_packet_t;
		
		ecs_rpy_prot_av_i			:	in	std_logic;
		ecs_rpy_prot_ena_o			:	out	std_logic;
		ecs_rpy_prot_data_o			:	out	ecs_packet_t;
		
		--
		--Interface with the MAC Layer
		
		sca_cmd_data_o     		:	out payload_vector_t(0 to SCA_COUNT - 1);
		sca_cmd_ena_o      		:	out std_logic_vector(0 to SCA_COUNT -1);
		sca_cmd_rdy_i      	:	in 	std_logic_vector(0 to SCA_COUNT -1);
		--
		sca_rpy_data_i     		:	in	payload_vector_t(0 to SCA_COUNT - 1);
		sca_rpy_prot_rdy_o      :	out std_logic_vector(0 to SCA_COUNT -1);
		send_sca_rpy_i     		:	in 	std_logic_vector(0 to SCA_COUNT -1);
		reconnnect_o			:	out	std_logic_vector(0 to SCA_COUNT -1)
		
		--
	);
end entity protocol_layer;

-- mac_cmd_data_from_prot_l    => cmd_data_from_protocol_layer,
--			     mac_rpy_data_to_prot_l      => rpy_data_to_protocol_layer,
--			     mac_cmd_rcv_ready_prot_l => cmd_fifo_ready_to_rcv_from_prot,
--			     mac_rcv_cmd_from_prot_l               => rcv_cmd_from_prot,
--			     mac_rdy_to_rpy_to_prot_l         => rdy_to_send_rpy_to_prot,
--			     req_to_rpy_to_prot_l         => req_to_send_rpy_to_prot);


--! Each 
architecture RTL of protocol_layer is
	
	component sca_controller_protocol_driver
		port(clk					: in	std_logic;
			 rst					: in	std_logic;
			 prot_cmd_en_i			: in	std_logic;
			 ecs_cmd_packet			: in	ecs_packet_t;
			 prot_rpy_en_i			: in	std_logic;
			 ecs_rpy_packet			: out	ecs_packet_t;
			 sca_cmd_batch_o		: out	prot_cmd_t;
			 sca_rpy_batch_i		: in	prot_cmd_t;
		 	 tr_cmd_i				: in	byte_t;
			 activated_channels_o	: out	activated_channels_t);
	end component sca_controller_protocol_driver;
	
	component spi_protocol_driver
		port(prot_cmd_en_i   : in  std_logic;
			 ecs_cmd_packet  : in  ecs_packet_t;
			 prot_rpy_en_i   : in  std_logic;
			 ecs_rpy_packet  : out ecs_packet_t;
			 sca_cmd_batch_o : out prot_cmd_t;
			 sca_rpy_batch_i : in  prot_cmd_t;
			 tr_cmd_i        : in  byte_t);
	end component spi_protocol_driver;
	
	component gpio_protocol_driver
		port(prot_cmd_en_i   : in  std_logic;
			 ecs_cmd_packet  : in  ecs_packet_t;
			 prot_rpy_en_i   : in  std_logic;
			 ecs_rpy_packet  : out ecs_packet_t;
			 sca_cmd_batch_o : out prot_cmd_t;
			 sca_rpy_batch_i : in  prot_cmd_t;
			 tr_cmd_i        : in  byte_t);
	end component gpio_protocol_driver;
	
	component i2c_protocol_driver
		port(prot_cmd_en_i			: in	std_logic;
			 ecs_cmd_packet			: in	ecs_packet_t;
			 prot_rpy_en_i			: in	std_logic;
			 ecs_rpy_packet			: out	ecs_packet_t;
		 	sca_cmd_batch_o			: out	prot_cmd_t;
			 sca_rpy_batch_i		: in	prot_cmd_t;
			 tr_cmd_i				: in	byte_t	);
	end component i2c_protocol_driver;
	
	component jtag_protocol_driver
		port(prot_cmd_en_i   : in  std_logic;
			 ecs_cmd_packet  : in  ecs_packet_t;
			 prot_rpy_en_i   : in  std_logic;
			 ecs_rpy_packet  : out ecs_packet_t;
			 sca_cmd_batch_o : out prot_cmd_t;
			 sca_rpy_batch_i : in  prot_cmd_t;
			 tr_cmd_i        : in  byte_t);
	end component jtag_protocol_driver;
	
	component adc_protocol_driver
		port(prot_cmd_en_i   : in  std_logic;
			 ecs_cmd_packet  : in  ecs_packet_t;
			 prot_rpy_en_i   : in  std_logic;
			 ecs_rpy_packet  : out ecs_packet_t;
			 sca_cmd_batch_o : out prot_cmd_t;
			 sca_rpy_batch_i : in  prot_cmd_t;
			 tr_cmd_i        : in  byte_t);
	end component adc_protocol_driver;
	
	component dac_protocol_driver
		port(prot_cmd_en_i   : in  std_logic;
			 ecs_cmd_packet  : in  ecs_packet_t;
			 prot_rpy_en_i   : in  std_logic;
			 ecs_rpy_packet  : out ecs_packet_t;
			 sca_cmd_batch_o : out prot_cmd_t;
			 sca_rpy_batch_i : in  prot_cmd_t;
			 tr_cmd_i        : in  byte_t);
	end component dac_protocol_driver;
	
	component cmd_queue_controller
		port(clk                : in  std_logic;
			 rst                : in  std_logic;
			 ecs_cmd_prot_ena_o : out std_logic;
			 ecs_cmd_prot_av_i  : in  std_logic;
			 ecs_rpy_int_av_i   : in  std_logic;
			 ecs_rpy_int_ena_o  : out std_logic;
			 sca_cmd_batch_i    : in  prot_cmd_t;
			 sca_rpy_batch_o    : out prot_cmd_t;
			 sca_cmd_data_o     : out payload_vector_t(0 to SCA_COUNT - 1);
			 sca_cmd_ena_o      : out std_logic_vector(0 to SCA_COUNT - 1);
			 sca_cmd_rdy_i      : in  std_logic_vector(0 to SCA_COUNT - 1);
			 sca_rpy_data_i     : in  payload_vector_t(0 to SCA_COUNT - 1);
			 sca_rpy_prot_rdy_o : out std_logic_vector(0 to SCA_COUNT - 1);
			 send_sca_rpy_i     : in  std_logic_vector(0 to SCA_COUNT - 1);
			 reconnnect_o       : out std_logic_vector(0 to SCA_COUNT - 1));
	end component cmd_queue_controller;
	
	
	
	
	type activate_protocol_t is array(PROT_DRIVER_ENUM_t'left to PROT_DRIVER_ENUM_t'right) of std_logic;	
	 
	signal prot_cmd_en_by_prot : activate_protocol_t;
	
	
	type ecs_packet_by_prot_t is array(PROT_DRIVER_ENUM_t'left to PROT_DRIVER_ENUM_t'right) of ecs_packet_t;
	
	signal tr : byte_t;
	

	signal ecs_rpy_packet_by_prot : ecs_packet_by_prot_t;

	signal activated_channels : activated_channels_t := (others=>(others=>'1'));
--	
	signal tr_sca_array	:	byte_vector_t(0 to SCA_BY_GBT_COUNT -1) := (others=>(x"01"));
--	--

	
	
	signal sca_cmd_batch : prot_cmd_t;
	signal sca_rpy_batch : prot_cmd_t;
	


	signal ecs_cmd_prot_ena		:	std_logic;
	
	signal prot_rpy_en_by_prot		:	activate_protocol_t;
	signal ecs_rpy_int_ena : std_logic;
	signal sca_cmd_batch_by_prot : prot_cmd_vector_by_prot_t;
	
	

begin
	
	
	cmd_queue_controller_inst : component cmd_queue_controller
		port map(clk                => clk,
			     rst                => rst,
			     ecs_cmd_prot_ena_o => ecs_cmd_prot_ena,
			     ecs_cmd_prot_av_i  => ecs_cmd_prot_av_i,
			     ecs_rpy_int_av_i   => ecs_rpy_prot_av_i,
			     ecs_rpy_int_ena_o  => ecs_rpy_int_ena,
			     sca_cmd_batch_i    => sca_cmd_batch,
			     sca_rpy_batch_o    => sca_rpy_batch,
			     sca_cmd_data_o     => sca_cmd_data_o,
			     sca_cmd_ena_o      => sca_cmd_ena_o,
			     sca_cmd_rdy_i  => sca_cmd_rdy_i,
			     sca_rpy_data_i     => sca_rpy_data_i,
			     sca_rpy_prot_rdy_o => sca_rpy_prot_rdy_o,
			     send_sca_rpy_i     => send_sca_rpy_i,
			     reconnnect_o		=> reconnnect_o);
			     
	ecs_rpy_prot_ena_o <= ecs_rpy_int_ena;
	ecs_cmd_prot_ena_o <= ecs_cmd_prot_ena;
	
	sca_controller_protocol_driver_inst : component sca_controller_protocol_driver
		port map(clk                  => clk,
			     rst                  => rst,
			     prot_cmd_en_i        => prot_cmd_en_by_prot(SCA_CTL),
			     ecs_cmd_packet       => ecs_cmd_prot_data_i,
			     prot_rpy_en_i        => prot_rpy_en_by_prot(SCA_CTL),
			     ecs_rpy_packet       => ecs_rpy_packet_by_prot(SCA_CTL),
			     sca_cmd_batch_o      => sca_cmd_batch_by_prot(SCA_CTL),
			     sca_rpy_batch_i      => sca_rpy_batch,
			     tr_cmd_i			  => tr,
			     activated_channels_o => activated_channels);
			     
	     
	spi_protocol_driver_inst : component spi_protocol_driver
		port map(prot_cmd_en_i   => prot_cmd_en_by_prot(SPI),
			     ecs_cmd_packet  => ecs_cmd_prot_data_i,
			     prot_rpy_en_i   => prot_rpy_en_by_prot(SPI),
			     ecs_rpy_packet  => ecs_rpy_packet_by_prot(SPI),
			     sca_cmd_batch_o => sca_cmd_batch_by_prot(SPI),
			     sca_rpy_batch_i => sca_rpy_batch,
			     tr_cmd_i        => tr);
			     
	gpio_protocol_driver_inst : component gpio_protocol_driver
	port map(prot_cmd_en_i	=> prot_cmd_en_by_prot(GPIO),
		     ecs_cmd_packet  => ecs_cmd_prot_data_i,
		     prot_rpy_en_i   => prot_rpy_en_by_prot(GPIO),
		     ecs_rpy_packet  => ecs_rpy_packet_by_prot(GPIO),
		     sca_cmd_batch_o => sca_cmd_batch_by_prot(GPIO),
		     sca_rpy_batch_i => sca_rpy_batch,
		     tr_cmd_i        => tr);
			
			  
	i2c_protocol_driver_inst : component i2c_protocol_driver
		port map(prot_cmd_en_i   => prot_cmd_en_by_prot(I2C),
			     ecs_cmd_packet  => ecs_cmd_prot_data_i,
			     prot_rpy_en_i   => prot_rpy_en_by_prot(I2C),
			     ecs_rpy_packet  => ecs_rpy_packet_by_prot(I2C),
			     sca_cmd_batch_o => sca_cmd_batch_by_prot(I2C),
			     sca_rpy_batch_i => sca_rpy_batch,
			     tr_cmd_i        => tr);
			     
	jtag_protocol_driver_inst : component jtag_protocol_driver
		port map(prot_cmd_en_i   => prot_cmd_en_by_prot(JTAG),
			     ecs_cmd_packet  => ecs_cmd_prot_data_i,
			     prot_rpy_en_i   => prot_rpy_en_by_prot(JTAG),
			     ecs_rpy_packet  => ecs_rpy_packet_by_prot(JTAG),
			     sca_cmd_batch_o => sca_cmd_batch_by_prot(JTAG),
			     sca_rpy_batch_i => sca_rpy_batch,
			     tr_cmd_i        => tr);  
			     
	adc_protocol_driver_inst : component adc_protocol_driver
		port map(prot_cmd_en_i   => prot_cmd_en_by_prot(ADC),
			     ecs_cmd_packet  => ecs_cmd_prot_data_i,
			     prot_rpy_en_i   => prot_rpy_en_by_prot(ADC),
			     ecs_rpy_packet  => ecs_rpy_packet_by_prot(ADC),
			     sca_cmd_batch_o => sca_cmd_batch_by_prot(ADC),
			     sca_rpy_batch_i => sca_rpy_batch,
			     tr_cmd_i        => tr);  
			     
	dac_protocol_driver_inst : component dac_protocol_driver
		port map(prot_cmd_en_i   => prot_cmd_en_by_prot(DAC),
			     ecs_cmd_packet  => ecs_cmd_prot_data_i,
			     prot_rpy_en_i   => prot_rpy_en_by_prot(DAC),
			     ecs_rpy_packet  => ecs_rpy_packet_by_prot(DAC),
			     sca_cmd_batch_o => sca_cmd_batch_by_prot(DAC),
			     sca_rpy_batch_i => sca_rpy_batch,
			     tr_cmd_i        => tr);  
			     
			     
	
		     
	--! This process generates the TR field of the Payload packet, it is agnostic to the type of the command.
	--! This value is retrieved on replies from the associated SCA.
	next_tr_generator	:	process(rst, clk)
	begin
		if rst = '1' then
			for i in 0 to SCA_BY_GBT_COUNT - 1 loop
				tr_sca_array(i) <= x"01";
			end loop;	
		elsif rising_edge(clk) then
			if ecs_cmd_prot_av_i = '1' then
				--TR values of 255 are used for interruptions only, which could happen only on replies
				if tr_sca_array(to_integer(unsigned(ecs_cmd_prot_data_i.sca_nr))) >= std_logic_vector(to_unsigned(254,8)) then
					tr_sca_array(to_integer(unsigned(ecs_cmd_prot_data_i.sca_nr))) <= std_logic_vector(to_unsigned(1,8));
				else
					tr_sca_array(to_integer(unsigned(ecs_cmd_prot_data_i.sca_nr))) <= 
						std_logic_vector(unsigned(tr_sca_array(to_integer(unsigned(ecs_cmd_prot_data_i.sca_nr)))) + 1);
				end if;
			end if;
		end if;
	end process next_tr_generator;
	
	tr <= tr_sca_array(to_integer(unsigned(ecs_cmd_prot_data_i.sca_nr)));
	
	rpy_protocol_arbiter : process (ecs_rpy_int_ena, sca_rpy_batch.ch, ecs_rpy_packet_by_prot)
		variable prot_rpy_en_by_prot_var		:	activate_protocol_t;
		variable ecs_rpy_int_data_var			:	ecs_packet_t;
	begin
		prot_rpy_en_by_prot_var:=(others=>'0');
		ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(SCA_CTL);
		if ecs_rpy_int_ena='1' then
			case sca_rpy_batch.ch is 
				when x"00" =>
					prot_rpy_en_by_prot_var(SCA_CTL) := '1';
					ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(SCA_CTL);
				when x"01" => 
					prot_rpy_en_by_prot_var(SPI) := '1';
					ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(SPI);
				when x"02" => 
					prot_rpy_en_by_prot_var(GPIO) := '1';
					ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(GPIO);
				when x"03" | x"04" | x"05" | x"06" | x"07" | x"08" | x"09" | x"0A" 
				| x"0B" | x"0C" | x"0D" | x"0E" | x"0F" | x"10" | x"11" | x"12" =>
					prot_rpy_en_by_prot_var(I2C) := '1';
					ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(I2C);
				when x"13" =>
					prot_rpy_en_by_prot_var(JTAG) := '1';
					ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(JTAG);
				when x"14" =>
					prot_rpy_en_by_prot_var(ADC) := '1';
					ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(ADC);
				when x"15" =>
					prot_rpy_en_by_prot_var(DAC) := '1';
					ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(DAC);
				when others =>
					report "rpy_protocol_arbiter: Invalid Channel, what to do?" severity warning;
					prot_rpy_en_by_prot_var := (others=>'0');
					ecs_rpy_int_data_var := ecs_rpy_packet_by_prot(SCA_CTL);
			end case;
		end if;
		
		ecs_rpy_prot_data_o <= ecs_rpy_int_data_var;
		prot_rpy_en_by_prot	<= prot_rpy_en_by_prot_var;
	end process rpy_protocol_arbiter;
	
	
	
	
	cmd_protocol_arbiter : process (ecs_cmd_prot_data_i.sca_ch, activated_channels, 
	        ecs_cmd_prot_data_i.sca_nr, sca_cmd_batch_by_prot, ecs_cmd_prot_ena
	) is
		variable prot_cmd_en_by_prot_var :	activate_protocol_t;
		variable sca_cmd_batch_var		:	prot_cmd_t;	
	begin
		prot_cmd_en_by_prot_var := (others=>'0');
		sca_cmd_batch_var := sca_cmd_batch_by_prot(SCA_CTL);
		if ecs_cmd_prot_ena = '1' then
			
			if activated_channels(to_integer(unsigned(ecs_cmd_prot_data_i.sca_nr)))(0) = '1' and 
			activated_channels(to_integer(unsigned(ecs_cmd_prot_data_i.sca_nr)))(to_integer(unsigned(ecs_cmd_prot_data_i.sca_ch)))='1' then
				case ecs_cmd_prot_data_i.sca_ch is 
				when x"00" =>
					prot_cmd_en_by_prot_var(SCA_CTL) := '1';
					sca_cmd_batch_var := sca_cmd_batch_by_prot(SCA_CTL);
					
				when x"01" => 
					prot_cmd_en_by_prot_var(SPI) := '1';
					sca_cmd_batch_var := sca_cmd_batch_by_prot(SPI);
				when x"02" => 
					prot_cmd_en_by_prot_var(GPIO) := '1';
					sca_cmd_batch_var := sca_cmd_batch_by_prot(GPIO);
				when x"03" | x"04" | x"05" | x"06" | x"07" | x"08" | x"09" | x"0A" 
				| x"0B" | x"0C" | x"0D" | x"0E" | x"0F" | x"10" | x"11" | x"12" =>
					prot_cmd_en_by_prot_var(I2C) := '1';
					sca_cmd_batch_var := sca_cmd_batch_by_prot(I2C);
				when x"13" =>
					prot_cmd_en_by_prot_var(JTAG) := '1';
					sca_cmd_batch_var := sca_cmd_batch_by_prot(JTAG);
				when x"14" =>
					prot_cmd_en_by_prot_var(ADC) := '1';
					sca_cmd_batch_var := sca_cmd_batch_by_prot(ADC);
				when x"15" =>
					prot_cmd_en_by_prot_var(DAC) := '1';
					sca_cmd_batch_var := sca_cmd_batch_by_prot(DAC);
				when others =>
					report "cmd_protocol_arbiter : Invalid Channel, what to do?" severity warning;
					--ecs_cmd_prot_arbiter <= SCA_CTL;
					prot_cmd_en_by_prot_var := (others=>'0');
					sca_cmd_batch_var := sca_cmd_batch_by_prot(SCA_CTL);
				end case;
			else
				-- \TODO Report/return the ECS when the channel is not activated or invalid
				report "cmd_protocol_arbiter : Channel not activated, what to do?" severity warning;
				prot_cmd_en_by_prot_var := (others=>'0');
				sca_cmd_batch_var := sca_cmd_batch_by_prot(SCA_CTL);
			end if;
		else
			prot_cmd_en_by_prot_var := (others=>'0');
			sca_cmd_batch_var := sca_cmd_batch_by_prot(SCA_CTL);
		end if;
		sca_cmd_batch <= sca_cmd_batch_var;
		prot_cmd_en_by_prot <= prot_cmd_en_by_prot_var;
	end process cmd_protocol_arbiter;
	


end architecture RTL;
