library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

use work.Constant_Declaration.all;


package SCA_Package is

	------------------------------ ECS -------------------------------------------------------------------------------------------
	-- From Cons at amc40firmware\mini_daq\mini_daq\packages\
	-- BAR0 addresses width
	--constant ECS_address_size       : integer := 21;--19
	
	-- BAR0 data width
	--constant ECS_data_size          : integer := 32;
	
	

	-----------------------------------------------------------------------------------------------------------------------------

	shared variable tx_test	:	std_logic := '0';


	--! \name Common used general types
	--! \{
	subtype byte_t is  std_logic_vector(7 downto 0);
	type byte_vector_t is array(integer range <>) of byte_t;
	type std_logic_2d_vector is array(integer range <>, integer range <>) of std_logic;
	
	type natural_vector_t is array(integer range <>) of natural;
	type natural_2d_array_t is array(integer range <>, integer range <>) of natural;
	
	type eport_data_array_t	is array(natural range<>) of std_logic_vector(15 downto 0);
	

	--! \}

	--! \name STFC-SCA Constants
	--! \{
	constant CMD_FIFO_ADDR_WIDTH	:	integer := 0;--1;
	constant GBT_COUNT				: integer := 1;
	constant SCA_BY_GBT_COUNT		:	integer := 1;
	constant Q_COUNT	:	natural := 4;--:= 16;
	
	--! DON'T CHANGE, GBT-SCA SPECIFIC (CONSTANT)
	constant CH_BY_SCA_COUNT			:	natural := 22;
	
--	constant SCA_COUNT		:	integer := GBT_COUNT*SCA_BY_GBT_COUNT;
	constant SCA_COUNT		:	integer := 1;
	
	
	--! Number of replies that could be contained on the reply buffer = rpy_list
	constant RPY_PACK_COUNT 		:	integer := 5;--50;
	constant RPY_BUF_ADDR_WIDTH 	:	integer := integer(ceil(log2(real(RPY_PACK_COUNT))));
	
	constant PAYLOAD_DATA_MAX_LEN	:	natural	:= 256/8; -- 256 bits in bytes
	
	--! TR numbers associated to interrupts, can not to be used by a command
	constant interrupts_tr : byte_vector_t(0 to 1):= (x"00",x"ff");
	--------------
	
	--! Is the acknowledge field in the reply packet. In case of an error 
	--! has encountered it contains the correspondent error code otherwise 
	--! returns 0x00. In particular:
	type ERR_mask_enum is(
		nothing,	 						--bit 0
		invalid_channel_request, 			--bit 1
		invalid_command_request,			--bit 2
		invalid_transaction_number_request,	--bit 3
		invalid_request_length,				--bit 4
		channel_disabled,					--bit 5
		channel_busy,						--bit 6
		command_en_treatment);				--bit 7
	
	--! \}

	
	--! \name STFC-SCA Types
	--! \{
	
	
	--! GBT-SCA Payload Type 
	type payload_t is 
	record
		tr					:	byte_t;
		ch					:	byte_t;
		cmd_or_err			:	byte_t;
		len					:	byte_t;
		data				: 	std_logic_vector(31 downto 0);
	end record;
	
	type payload_vector_t is array(integer range <>) of payload_t;
	--type payload_2d_vector_t is array(integer range <>, integer range <>) of payload_t;
	
	type payload_2d_vector_t is array(integer range <>, integer range <>) of payload_t;
	
	type payload_ch_array_t		is array(natural range<>) of payload_vector_t(0 to CH_BY_SCA_COUNT - 1);
	type std_logic_ch_array_t	is array(natural range<>) of std_logic_vector(0 to CH_BY_SCA_COUNT - 1);
	type elink_ch_array_t	is array(natural range<>) of std_logic_vector(1 downto 0);
	
	type ch_state_t is record
			busy			:	std_logic;
			last_tr_sent	:	byte_t;
	end record ch_state_t;
	
	type ch_state_vector_t	is array(0 to CH_BY_SCA_COUNT-1) of ch_state_t;
	type sca_ch_state_vector_t	is array(natural range <>) of ch_state_vector_t;
	
	
	type payload_by_gbt_and_sca_t is array(0 to GBT_COUNT-1,0 to SCA_BY_GBT_COUNT-1) of payload_t;
	type ch_state_vector_by_gbt_and_sca_t	is array(0 to GBT_COUNT-1,0 to SCA_BY_GBT_COUNT-1) of ch_state_vector_t;
	type std_logic_by_gbt_and_sca is array(0 to GBT_COUNT-1,0 to SCA_BY_GBT_COUNT-1) of std_logic;
	
	
	
	type payload_prot_t is 
	record
		--cmd_or_err			:	byte_t;
		len					:	byte_t;
		data				: 	std_logic_vector(31 downto 0);
	end record;
	
	
	type payload_prot_vector_t is array(integer range <>) of payload_prot_t;
	
	type prot_state_t is (IDLE, FETCH_SCA_CMD, SEND_SCA_CMD, WAIT_SCA_RPY, ECS_RPY_RDY);
	
	type prot_state_vector_t is array(natural range<>) of prot_state_t;
	
	
	--0 to 65535
	subtype sca_time_t is natural range 0 to 2**(16)-1;
	type sca_time_array_t is array (natural range<>) of sca_time_t;
	
	
	-- Types used by the protocol drivers on the protocol layer
	
	
	type prot_cmd_t is record
		gbt				:	natural range 0 to GBT_COUNT-1;
		sca				:	natural range 0 to SCA_BY_GBT_COUNT-1;
		tr				:	byte_t;
		ch				:	byte_t;
		ecs_cmd			:	byte_t;
		ecs_len			:	byte_t;
		sca_cmds		:	byte_vector_t(0 to 7);
		sca_cmds_data	:	payload_prot_vector_t(0 to 7);
		sca_rpys_data	:	payload_prot_vector_t(0 to 7);
		--rpy_batch		:	payload_prot_vector_t(0 to 7);
		cmd_count		:	natural range 0 to 7;
		err				:	byte_t;
		--err_pkt_nr		:	natural range 0 to 7;
	end record prot_cmd_t;
	type prot_cmd_vector_t is array(natural range<>) of prot_cmd_t;
	
	
	
	type cmd_count_vector_t is array(natural range<>) of natural range 0 to 7;
	
	type command_queue_t is record
		prot_cmd		:	prot_cmd_vector_t(0 to Q_COUNT-1);
		prot_state		:	prot_state_vector_t(0 to Q_COUNT-1);
		counter			:	cmd_count_vector_t(0 to  Q_COUNT-1);
		expiration_time	:	sca_time_array_t(0 to  Q_COUNT-1);
	end record command_queue_t;
	
--	type payload_len_t is 
--	record
--		cmd	:	std_logic_vector(4 downto 0);
--		rpy	:	std_logic_vector(4 downto 0);
--		tr	:	byte_t;
--	end record;
	
	--! SCA Channel table
	type sca_ch_enum is(
		sca_controller,
		master_spi, 
		master_gpio,
		master_i2c_0,
		master_i2c_1,
		master_i2c_2,
		master_i2c_3,
		master_i2c_4,
		master_i2c_5,
		master_i2c_6,
		master_i2c_7,
		master_i2c_8,
		master_i2c_9,
		master_i2c_10,
		master_i2c_11,
		master_i2c_12,
		master_i2c_13,
		master_i2c_14,
		master_i2c_15,
		master_jtag,
		adc,
		dac);
		
	type sca_ch_table_t is array(sca_ch_enum'left to sca_ch_enum'right) of byte_t;
	constant sca_ch_table : sca_ch_table_t := (
		sca_controller	=>	std_logic_vector( to_unsigned(0, 8) ),
		master_spi	  	=>	std_logic_vector( to_unsigned(1, 8) ),
		master_gpio		=>	std_logic_vector( to_unsigned(2, 8) ),
		master_i2c_0 	=>	std_logic_vector( to_unsigned(3, 8) ),
		master_i2c_1 	=>	std_logic_vector( to_unsigned(4, 8) ),
		master_i2c_2 	=>	std_logic_vector( to_unsigned(5, 8) ),
		master_i2c_3 	=>	std_logic_vector( to_unsigned(6, 8) ),
		master_i2c_4 	=>	std_logic_vector( to_unsigned(7, 8) ),
		master_i2c_5 	=>	std_logic_vector( to_unsigned(8, 8) ),
		master_i2c_6 	=>	std_logic_vector( to_unsigned(9, 8) ),
		master_i2c_7 	=>	std_logic_vector( to_unsigned(10,8) ),
		master_i2c_8 	=>	std_logic_vector( to_unsigned(11,8) ),
		master_i2c_9 	=>	std_logic_vector( to_unsigned(12,8) ),
		master_i2c_10	=>	std_logic_vector( to_unsigned(13,8) ),
		master_i2c_11	=>	std_logic_vector( to_unsigned(14,8) ),
		master_i2c_12	=>	std_logic_vector( to_unsigned(15,8) ),
		master_i2c_13	=>	std_logic_vector( to_unsigned(16,8) ),
		master_i2c_14	=>	std_logic_vector( to_unsigned(17,8) ),
		master_i2c_15	=>	std_logic_vector( to_unsigned(18,8) ),
		master_jtag		=>	std_logic_vector( to_unsigned(19,8) ),
		adc			=>		std_logic_vector( to_unsigned(20,8) ),
		dac			=> 		std_logic_vector( to_unsigned(21,8) )
	);
		
		
	
	
	type activated_channels_t is array(0 to SCA_BY_GBT_COUNT-1) of std_logic_vector(CH_BY_SCA_COUNT-1 downto 0);
	 
		
--	attribute ENUM_ENCODING: STRING;
--	attribute ENUM_ENCODING of
--	sca_ch_t: type is "000 001 010 011 100";
	
	
	
	type packet_word_t is 
	record
		sca		:	std_logic_vector(4 downto 0);
		payload	:	payload_t;
	end record;
	

	
	--! \}
	
	--------------------------------------------------------------------------------------
	
	

--	
	

	
	
	
		
--	attribute ENUM_ENCODING: STRING;
--	
--	type COLOR is (RED, GREEN, YELLOW, BLUE, VIOLET);
--	attribute ENUM_ENCODING of
--	 COLOR: type is "010 000 011 100 001";
	 
	 -- Attribute declaration
--	type channels_table_t is array(channels_enum'left to channels_enum'right) of byte_t;
--	constant channels_table : channels_table_t := (
--		network_controller_ch	=> x"00",
--		master_spi_ch	  		=> x"02",
--		master_i2c_vector_ch_0 	=> x"10",
--		master_i2c_vector_ch_1 	=> x"11",
--		master_i2c_vector_ch_2 	=> x"12",
--		master_i2c_vector_ch_3 	=> x"13",
--		master_i2c_vector_ch_4 	=> x"14",
--		master_i2c_vector_ch_5 	=> x"15",
--		master_i2c_vector_ch_6 	=> x"16",
--		master_i2c_vector_ch_7 	=> x"17",
--		master_i2c_vector_ch_8 	=> x"18",
--		master_i2c_vector_ch_9 	=> x"19",
--		master_i2c_vector_ch_10	=> x"1A",
--		master_i2c_vector_ch_11	=> x"1B",
--		master_i2c_vector_ch_12	=> x"1C",
--		master_i2c_vector_ch_13	=> x"1D",
--		master_i2c_vector_ch_14	=> x"1E",
--		master_i2c_vector_ch_15	=> x"1F",
--		master_pia_ch_0			=> x"30",
--		master_pia_ch_1			=> x"31",
--		master_pia_ch_2			=> x"32",
--		master_pia_ch_3			=> x"33",
--		master_mem_ch			=> x"40",
--		master_jtag_ch			=> x"60",
--		adc_input_ch			=> x"70",
--		sca_reset_ch			=> x"AA"
--	);
		
		
	-------------------------------------------------------------------------------------------
	type ecs_packet_t is
	record
		gbt_nr				:	byte_t;
		sca_nr				:	byte_t;
		sca_ch				:	byte_t;-- range channels_enum'left to channels_enum'right;
		ecs_cmd				:	byte_t;
		err					:	byte_t;
		len					:	byte_t;
		protocol_specific	:	std_logic_vector(15 downto 0);
		data				:	std_logic_vector((32*4)-1 downto 0);
	end record;
	
--	type ecs_packet_t is
--	record
--		gbt_nr				:	natural range 0 to GBT_COUNT-1;
--		sca_nr				:	natural range 0 to SCA_COUNT-1;
--		sca_ch				:	byte_t;-- range channels_enum'left to channels_enum'right;
--		ecs_cmd				:	byte_t;
--		len					:	byte_t;
--		protocol_specific	:	std_logic_vector(15 downto 0);
--		data				:	std_logic_vector(32*4-1 downto 0);
--	end record;
	
	
	type ecs_addr_packet_t is
	record
		gbt_nr				:	byte_t;
		sca_nr				:	byte_t;
		sca_ch				:	byte_t;
	end record;
	
	type ecs_packet_array_t is array(natural range<>) of ecs_packet_t;
	
	type payload_stream_t is
	record
		--! CH + TR + CMD + DATA (Max 256 bits)
		bit_stream		:	std_logic_vector(6*8 + 256 -1  downto 0);
		-- mininum of 3 byte and a maximum of 32 + 3
		effective_len	:	natural range 3 to 35; 
	
	end record;
	
	type payload_stream_array_t is array(natural range <>) of payload_stream_t;
	
	----------------------------------------------------------------
	--! SCA controller commands dictionary
	
	type sca_cmd_enum	is (
		CRA_wrt, --! Write the SLVS transmit current level setting
		CRA_rea, --! Read the SLVS transmit current level setting
		CRB_wrt, --! Write bits 0 to 7 of the CH_EN register
		CRB_rea, --! Read bits 0 to 7 of the CH_EN register
		CRC_wrt, --! Write bits 8 to 15 of the CH_EN register
		CRC_rea, --! Read bits 8 to 15 of the CH_EN register
		CRD_wrt, --! Write bits 16 to 21 of the CH_EN register
		CRD_rea	 --! Read bits 16 to 21 of the CH_EN register
	);
	
	

	
	type sca_cmd_table_t is array(sca_cmd_enum'left to sca_cmd_enum'right) of byte_t;
	
	constant sca_cmd_table : sca_cmd_table_t :=
		(	
		CRA_wrt => x"00",
		CRA_rea => x"01",
		CRB_wrt => x"02",
		CRB_rea => x"03",
		CRC_wrt => x"04",
		CRC_rea => x"05",
		CRD_wrt => x"06",
		CRD_rea => x"07"
	);

	type ecs_sca_cmd_enum is(
		ECS_CRA_wrt, --! Write the SLVS transmit current level setting
		ECS_CRA_rea, --! Read the SLVS transmit current level setting
		ECS_CRB_wrt, --! Write bits 0 to 7 of the CH_EN register
		ECS_CRB_rea, --! Read bits 0 to 7 of the CH_EN register
		ECS_CRC_wrt, --! Write bits 8 to 15 of the CH_EN register
		ECS_CRC_rea, --! Read bits 8 to 15 of the CH_EN register
		ECS_CRD_wrt, --! Write bits 16 to 21 of the CH_EN register
		ECS_CRD_rea, --! Read bits 16 to 21 of the CH_EN register
		ECS_CRA_wrt_rea, --! Write AND READ the SLVS transmit current level setting
		ECS_CRB_wrt_rea, --! Write AND READ bits 0 to 7 of the CH_EN register
		ECS_CRC_wrt_rea, --! Write AND READ bits 8 to 15 of the CH_EN register
		ECS_CRD_wrt_rea, --! Write AND READ bits 16 to 21 of the CH_EN register
		INVALID
	);
	
	type ecs_sca_cmd_table_t is array(ecs_sca_cmd_enum'left to ecs_sca_cmd_enum'right) of byte_t;
	
	constant ecs_sca_cmd_table : ecs_sca_cmd_table_t :=
		(	
		ECS_CRA_wrt => x"00",
		ECS_CRA_rea => x"01",
		ECS_CRB_wrt => x"02",
		ECS_CRB_rea => x"03",
		ECS_CRC_wrt => x"04",
		ECS_CRC_rea => x"05",
		ECS_CRD_wrt => x"06",
		ECS_CRD_rea => x"07",
		ECS_CRA_wrt_rea => x"08",
		ECS_CRB_wrt_rea => x"09", 
		ECS_CRC_wrt_rea => x"0a",
		ECS_CRD_wrt_rea => x"0b",
		INVALID => x"FF"
	);
	

	
	
	
----------------------------------------------------------------
--! I2C commands dictionary

	type i2c_cmd_enum	is (
		--! Start single byte write transmission 7 bit addr.
		I2C_S_7B_W,--0x82
		--! Start single byte read transmission 7-bit addr.
		I2C_S_7B_R,--0x86
		--! Start single byte write transmission 10-bit addr.
		I2C_S_10B_W,--0x8A
		--! Start single byte read transmission 10-bit addr.
		I2C_S_10B_R,--0x8E
		--! Start multi byte write transmission 7-bit addr.
		I2C_M_7B_W,--0xDA
		--! Start multi byte read transmission 7-bit addr.
		I2C_M_7B_R,--0xDE
		--! Start multi byte write transmission 10-bit addr.
		I2C_M_10B_W,--0x82
		--! Start multi byte read transmission 10-bit addr.
		I2C_M_10B_R,--0xE6
		--! Read � modify � write (AND with MASK reg.)
		I2C_RMW_AND,--0xC2
		--! Read � modify � write (OR with MASK reg.)
		I2C_RMW_OR,--0xC6
		--! Read � modify � write (XOR with MASK reg.)
		I2C_RMW_XOR,--0xCA
		
		----Data register access 
		--!Write the DATA TRANSMIT register bits 0 to 31
		I2C_W_DATA0,
		--!Read the DATA TRANSMIT register bits 0 to 31
		I2C_R_DATA0,
		--!Write the DATA TRANSMIT register bits 32 to 63 
		I2C_W_DATA1,
		--!Read the DATA TRANSMIT register bits 32 to 63 
		I2C_R_DATA1,
		--!Write the DATA TRANSMIT register bits 64 to 95
		I2C_W_DATA2,
		--!Read the DATA TRANSMIT register bits 64 to 95
		I2C_R_DATA2,
		--!Write the DATA TRANSMIT register bits 96 to 127
		I2C_W_DATA3,
		--!Read the DATA TRANSMIT register bits 96 to 127
		I2C_R_DATA3,
		
		--Control registers:
		--!Write the CONTROL register
		I2C_W_CTRL,
		--!Read the CONTROL register
		I2C_R_CTRL,
		--!Write the MASK register
		I2C_W_MSK,
		--!Read the MASK register
		I2C_R_MSK,
		--!Read the STATUS register
		I2C_R_STR
		
		
	);
	
	type i2c_cmd_table_t is array(i2c_cmd_enum'left to i2c_cmd_enum'right) of byte_t;
	
	constant i2c_cmd_table : i2c_cmd_table_t :=(
		--! Start single byte write transmission 7 bit addr.
		I2C_S_7B_W=>x"82",
		--! Start single byte read transmission 7-bit addr.
		I2C_S_7B_R=>x"86",
		--! Start single byte write transmission 10-bit addr.
		I2C_S_10B_W=>x"8A",
		--! Start single byte read transmission 10-bit addr.
		I2C_S_10B_R=>x"8E",
		--! Start multi byte write transmission 7-bit addr.
		I2C_M_7B_W=>x"DA",
		--! Start multi byte read transmission 7-bit addr.
		I2C_M_7B_R=>x"DE",
		--! Start multi byte write transmission 10-bit addr.
		I2C_M_10B_W=>x"E2",
		--! Start multi byte read transmission 10-bit addr.
		I2C_M_10B_R=>x"E6",
		--! Read � modify � write (AND with MASK reg.)
		I2C_RMW_AND=>x"C2",
		--! Read � modify � write (OR with MASK reg.)
		I2C_RMW_OR=>x"C6",
		--! Read � modify � write (XOR with MASK reg.)
		I2C_RMW_XOR=>x"CA",
		
		----Data register access 
		--!Write the DATA TRANSMIT register bits 0 to 31
		I2C_W_DATA0 => x"40",
		--!Read the DATA TRANSMIT register bits 0 to 31
		I2C_R_DATA0 => x"71",
		--!Write the DATA TRANSMIT register bits 32 to 63 
		I2C_W_DATA1 => x"50",
		--!Read the DATA TRANSMIT register bits 32 to 63 
		I2C_R_DATA1 => x"61",
		--!Write the DATA TRANSMIT register bits 64 to 95
		I2C_W_DATA2 => x"60",
		--!Read the DATA TRANSMIT register bits 64 to 95
		I2C_R_DATA2 => x"51",
		--!Write the DATA TRANSMIT register bits 96 to 127
		I2C_W_DATA3 => x"70",
		--!Read the DATA TRANSMIT register bits 96 to 127
		I2C_R_DATA3 => x"41",
		
		--Control registers:
		--!Write the CONTROL register
		I2C_W_CTRL => x"30",
		--!Read the CONTROL register
		I2C_R_CTRL => x"31",
		--!Write the MASK register
		I2C_W_MSK => x"20",
		--!Read the MASK register
		I2C_R_MSK => x"21",
		--!Read the STATUS register
		I2C_R_STR => x"11"
		
	);
	
	type ecs_i2c_cmd_enum is (
		--! Start single byte write transmission 7 bit addr.
		ECS_I2C_S_7B_W,--0x82
		--! Start single byte read transmission 7-bit addr.
		ECS_I2C_S_7B_R,--0x86
		--! Start single byte write transmission 10-bit addr.
		ECS_I2C_S_10B_W,--0x8A
		--! Start single byte read transmission 10-bit addr.
		ECS_I2C_S_10B_R,--0x8E
		--! Start multi byte write transmission 7-bit addr.
		ECS_I2C_M_7B_W,--0xDA
		--! Start multi byte read transmission 7-bit addr.
		ECS_I2C_M_7B_R,--0xDE
		--! Start multi byte write transmission 10-bit addr.
		ECS_I2C_M_10B_W,--0x82
		--! Start multi byte read transmission 10-bit addr.
		ECS_I2C_M_10B_R,--0xE6
		
		--! Read and modify and write (AND with MASK reg.)
		ECS_I2C_RMW_AND,
		--! Read and modify and write (OR with MASK reg.)
		ECS_I2C_RMW_OR,
		--! Read and modify and write (XOR with MASK reg.)
		ECS_I2C_RMW_XOR,
		
		--Data register access 
		--!Write the DATA TRANSMIT register bits 0 to 31
		ECS_I2C_W_DATA0,
		--!Read the DATA TRANSMIT register bits 0 to 31
		ECS_I2C_R_DATA0,
		--!Write the DATA TRANSMIT register bits 32 to 63 
		ECS_I2C_W_DATA1,
		--!Read the DATA TRANSMIT register bits 32 to 63 
		ECS_I2C_R_DATA1,
		--!Write the DATA TRANSMIT register bits 64 to 95
		ECS_I2C_W_DATA2,
		--!Read the DATA TRANSMIT register bits 64 to 95
		ECS_I2C_R_DATA2,
		--!Write the DATA TRANSMIT register bits 96 to 127
		ECS_I2C_W_DATA3,
		--!Read the DATA TRANSMIT register bits 96 to 127
		ECS_I2C_R_DATA3,
		
		
		--Control registers:
		--!Write the CONTROL register
		ECS_I2C_W_CTRL,
		--!Read the CONTROL register
		ECS_I2C_R_CTRL,
		--!Write the MASK register
		ECS_I2C_W_MSK,
		--!Read the MASK register
		ECS_I2C_R_MSK,
		--!Read the STATUS register
		ECS_I2C_R_STR,
		
		--! Start write transmission 7 bit addr.
		ECS_I2C_WRITE,
		--! Start read transmission 7-bit addr.
		ECS_I2C_READ,
		--! Start write transmission 10-bit addr.
		ECS_I2C_WRITE_EXT,
		--! Start read transmission 10-bit addr.
		ECS_I2C_READ_EXT,
		
		--Data register _write_and_read_ commands 
		--!Write the DATA TRANSMIT register bits 0 to 31
		ECS_I2C_W_R_DATA0,
		--!Write the DATA TRANSMIT register bits 32 to 63 
		ECS_I2C_W_R_DATA1,
		--!Write the DATA TRANSMIT register bits 64 to 95
		ECS_I2C_W_R_DATA2,
		--!Write the DATA TRANSMIT register bits 96 to 127
		ECS_I2C_W_R_DATA3,

		--!Write AND READ the CONTROL register
		ECS_I2C_W_R_CTRL,
		--!Write AND READ the MASK register
		ECS_I2C_W_R_MSK,
		INVALID
	);
	
	type ecs_i2c_table_t is array(ecs_i2c_cmd_enum'left to ecs_i2c_cmd_enum'right) of byte_t;
	
	constant ecs_i2c_table : ecs_i2c_table_t :=(
		
		--! Start single byte write transmission 7 bit addr.
		ECS_I2C_S_7B_W=>x"82",
		--! Start single byte read transmission 7-bit addr.
		ECS_I2C_S_7B_R=>x"86",
		--! Start single byte write transmission 10-bit addr.
		ECS_I2C_S_10B_W=>x"8A",
		--! Start single byte read transmission 10-bit addr.
		ECS_I2C_S_10B_R=>x"8E",
		--! Start multi byte write transmission 7-bit addr.
		ECS_I2C_M_7B_W=>x"DA",
		--! Start multi byte read transmission 7-bit addr.
		ECS_I2C_M_7B_R=>x"DE",
		--! Start multi byte write transmission 10-bit addr.
		ECS_I2C_M_10B_W=>x"E2",
		--! Start multi byte read transmission 10-bit addr.
		ECS_I2C_M_10B_R=>x"E6",
		--! Read � modify � write (AND with MASK reg.)
		ECS_I2C_RMW_AND=>x"C2",
		--! Read � modify � write (OR with MASK reg.)
		ECS_I2C_RMW_OR=>x"C6",
		--! Read � modify � write (XOR with MASK reg.)
		ECS_I2C_RMW_XOR=>x"CA",
		
		----Data register access 
		--!Write the DATA TRANSMIT register bits 0 to 31
		ECS_I2C_W_DATA0 => x"40",
		--!Read the DATA TRANSMIT register bits 0 to 31
		ECS_I2C_R_DATA0 => x"41",
		--!Write the DATA TRANSMIT register bits 32 to 63 
		ECS_I2C_W_DATA1 => x"50",
		--!Read the DATA TRANSMIT register bits 32 to 63 
		ECS_I2C_R_DATA1 => x"51",
		--!Write the DATA TRANSMIT register bits 64 to 95
		ECS_I2C_W_DATA2 => x"60",
		--!Read the DATA TRANSMIT register bits 64 to 95
		ECS_I2C_R_DATA2 => x"61",
		--!Write the DATA TRANSMIT register bits 96 to 127
		ECS_I2C_W_DATA3 => x"70",
		--!Read the DATA TRANSMIT register bits 96 to 127
		ECS_I2C_R_DATA3 => x"71",
		
		--Control registers:
		--!Write the CONTROL register
		ECS_I2C_W_CTRL => x"30",
		--!Read the CONTROL register
		ECS_I2C_R_CTRL => x"31",
		--!Write the MASK register
		ECS_I2C_W_MSK => x"20",
		--!Read the MASK register
		ECS_I2C_R_MSK => x"21",
		--!Read the STATUS register
		ECS_I2C_R_STR => x"11",
		
		
		--! Start write transmission 7 bit addr.
		ECS_I2C_WRITE => x"90",
		--! Start read transmission 7-bit addr.
		ECS_I2C_READ=>x"91",
		--! Start write transmission 10-bit addr.
		ECS_I2C_WRITE_EXT=>x"92",
		--! Start read transmission 10-bit addr.
		ECS_I2C_READ_EXT=>x"93",
		
		--Data register _write_and_read_ commands 
		--!Write the DATA TRANSMIT register bits 0 to 31
		ECS_I2C_W_R_DATA0=>x"94",
		--!Write the DATA TRANSMIT register bits 32 to 63 
		ECS_I2C_W_R_DATA1=>x"95",
		--!Write the DATA TRANSMIT register bits 64 to 95
		ECS_I2C_W_R_DATA2=>x"96",
		--!Write the DATA TRANSMIT register bits 96 to 127
		ECS_I2C_W_R_DATA3=>x"97",

		--!Write AND READ the CONTROL register
		ECS_I2C_W_R_CTRL=>x"98",
		--!Write AND READ the MASK register
		ECS_I2C_W_R_MSK=>x"99",
		
		INVALID => x"FF"
		
	);
	----------------------------------------------------------------
	--! ADC commands dictionary

	type adc_cmd_enum	is (
		ADC_GO,
		ADC_set_InputLine,
		ADC_rea_InputLine,
		ADC_set_CurrentSource,
		ADC_rea_CurrentSource,
		--
		ADC_rea_DATA_Ofs_Ga,
		ADC_rea_DATA_Ofs,
		ADC_rea_DATA,
		ADC_rea_OFFSET,
		ADC_wrt_CTRL,
		ADC_rea_CTRL,
		ADC_GO_SingleSlope,
		ADC_wrt_GainCalibrReg,
		ADC_rea_GainCalibrReg,
		ADC_wrt_ID,
		ADC_rea_ID
	);

	type adc_cmd_table_t is array(adc_cmd_enum'left to adc_cmd_enum'right) of byte_t;
	
	constant adc_cmd_table : adc_cmd_table_t :=
							(	
		ADC_GO=>x"B2",
		ADC_set_InputLine=>x"30",
		ADC_rea_InputLine=>x"31",
		ADC_set_CurrentSource=>x"40",
		ADC_rea_CurrentSource=>x"41",
		--
		ADC_rea_DATA_Ofs_Ga=>x"21",
		ADC_rea_DATA_Ofs=>x"A1",
		ADC_rea_DATA=>x"51",
		ADC_rea_OFFSET=>x"61",
		ADC_wrt_CTRL=>x"10",
		ADC_rea_CTRL=>x"11",
		ADC_GO_SingleSlope=>x"02",
		ADC_wrt_GainCalibrReg=>x"70",
		ADC_rea_GainCalibrReg=>x"71",
		ADC_wrt_ID=>x"90",
		ADC_rea_ID=>x"91"	
	);
	
	
	type ecs_adc_cmd_enum	is (
		ECS_ADC_GO,
		ECS_ADC_set_InputLine,
		ECS_ADC_rea_InputLine,
		ECS_ADC_set_CurrentSource,
		ECS_ADC_rea_CurrentSource,
		--
		ECS_ADC_rea_DATA_Ofs_Ga,
		ECS_ADC_rea_DATA_Ofs,
		ECS_ADC_rea_DATA,
		ECS_ADC_rea_OFFSET,
		ECS_ADC_wrt_CTRL,
		ECS_ADC_rea_CTRL,
		ECS_ADC_GO_SingleSlope,
		ECS_ADC_wrt_GainCalibrReg,
		ECS_ADC_rea_GainCalibrReg,
		ECS_ADC_wrt_ID,
		ECS_ADC_rea_ID,
		INVALID
	);
	
	type ecs_adc_cmd_table_t is array(ecs_adc_cmd_enum'left to ecs_adc_cmd_enum'right) of byte_t;


	constant ecs_adc_cmd_table : ecs_adc_cmd_table_t :=
							(	
		ECS_ADC_GO=>x"B2",
		ECS_ADC_set_InputLine=>x"30",
		ECS_ADC_rea_InputLine=>x"31",
		ECS_ADC_set_CurrentSource=>x"40",
		ECS_ADC_rea_CurrentSource=>x"41",
		--
		ECS_ADC_rea_DATA_Ofs_Ga=>x"21",
		ECS_ADC_rea_DATA_Ofs=>x"A1",
		ECS_ADC_rea_DATA=>x"51",
		ECS_ADC_rea_OFFSET=>x"61",
		ECS_ADC_wrt_CTRL=>x"10",
		ECS_ADC_rea_CTRL=>x"11",
		ECS_ADC_GO_SingleSlope=>x"02",
		ECS_ADC_wrt_GainCalibrReg=>x"70",
		ECS_ADC_rea_GainCalibrReg=>x"71",
		ECS_ADC_wrt_ID=>x"90",
		ECS_ADC_rea_ID=>x"91",	
		INVALID=>x"FF"
	);

	--! DAC commands dictionary
	
	type dac_cmd_enum	is (
		DAC_A_wrt, 
		DAC_A_read,
		DAC_B_wrt,
		DAC_B_read,
		DAC_C_wrt,
		DAC_C_read,
		DAC_D_wrt,
		DAC_D_read				
	);
	
	
	type dac_cmd_table_t is array(dac_cmd_enum'left to dac_cmd_enum'right) of byte_t;
	
	constant dac_cmd_table : dac_cmd_table_t :=
		(	
		DAC_A_wrt=>x"10", 
		DAC_A_read=>x"11",
		DAC_B_wrt=>x"20",
		DAC_B_read=>x"21",
		DAC_C_wrt=>x"30",
		DAC_C_read=>x"31",
		DAC_D_wrt=>x"40",
		DAC_D_read=>x"41" 					
	);


	type ecs_dac_cmd_enum is(
		ECS_DAC_A_wrt, 
		ECS_DAC_A_read,
		ECS_DAC_B_wrt,
		ECS_DAC_B_read,
		ECS_DAC_C_wrt,
		ECS_DAC_C_read,
		ECS_DAC_D_wrt,
		ECS_DAC_D_read,
		INVALID 	
	);
	
	type ecs_dac_cmd_table_t is array(ecs_dac_cmd_enum'left to ecs_dac_cmd_enum'right) of byte_t;
	
	constant ecs_dac_cmd_table : ecs_dac_cmd_table_t :=
		(	
		ECS_DAC_A_wrt=>x"10", 
		ECS_DAC_A_read=>x"11",
		ECS_DAC_B_wrt=>x"20",
		ECS_DAC_B_read=>x"21",
		ECS_DAC_C_wrt=>x"30",
		ECS_DAC_C_read=>x"31",
		ECS_DAC_D_wrt=>x"40",
		ECS_DAC_D_read=>x"41",	
		INVALID => x"FF"				
	);


	--! SPI commands dictionary------------------------------------------------
	type spi_cmd_enum is (		
		SPI_GO,
		SPI_wrt_CTRL,
		SPI_rea_CTRL,
		SPI_wrt_SS,
		SPI_rea_SS,
		SPI_wrt_DIV,SPI_rea_DIV,
		SPI_MOSI_wrt_Tx0,
		SPI_MOSI_rea_Tx0,
		SPI_MOSI_wrt_Tx1,
		SPI_MOSI_rea_Tx1,
		SPI_MOSI_wrt_Tx2,
		SPI_MOSI_rea_Tx2,
		SPI_MOSI_wrt_Tx3,
		SPI_MOSI_rea_Tx3,
		SPI_MISO_rea_Rx0,
		SPI_MISO_rea_Rx1,
		SPI_MISO_rea_Rx2,
		SPI_MISO_rea_Rx3
	);
	
		
	type spi_cmd_table_t is array(spi_cmd_enum'left to spi_cmd_enum'right) of byte_t;
	
	constant spi_cmd_table	:	spi_cmd_table_t:=(
		SPI_GO=>x"72",
		SPI_wrt_CTRL=>x"40",
		SPI_rea_CTRL=>x"41",
		SPI_wrt_SS=>x"60",
		SPI_rea_SS=>x"61",
		SPI_wrt_DIV=>x"50",
		SPI_rea_DIV=>x"51",
		--
		SPI_MOSI_wrt_Tx0=>x"00",
		SPI_MOSI_rea_Tx0=>x"01",
		SPI_MOSI_wrt_Tx1=>x"10",
		SPI_MOSI_rea_Tx1=>x"11",
		SPI_MOSI_wrt_Tx2=>x"20",
		SPI_MOSI_rea_Tx2=>x"21",
		SPI_MOSI_wrt_Tx3=>x"30",
		SPI_MOSI_rea_Tx3=>x"31",
		--
		SPI_MISO_rea_Rx0=>x"01",
		SPI_MISO_rea_Rx1=>x"11",
		SPI_MISO_rea_Rx2=>x"21",
		SPI_MISO_rea_Rx3=>x"31"
	);
	
	
	type ecs_spi_cmd_enum is(
		ECS_SPI_GO,
		ECS_SPI_W_CTRL,
		ECS_SPI_R_CTRL,
		ECS_SPI_W_SS,
		ECS_SPI_R_SS,
		ECS_SPI_W_FREQ,
		ECS_SPI_R_FREQ,
		ECS_SPI_MOSI_wrt_Tx0,
		ECS_SPI_MOSI_rea_Tx0,
		ECS_SPI_MOSI_wrt_Tx1,
		ECS_SPI_MOSI_rea_Tx1,
		ECS_SPI_MOSI_wrt_Tx2,
		ECS_SPI_MOSI_rea_Tx2,
		ECS_SPI_MOSI_wrt_Tx3,
		ECS_SPI_MOSI_rea_Tx3,
		ECS_SPI_MISO_rea_Rx0,
		ECS_SPI_MISO_rea_Rx1,
		ECS_SPI_MISO_rea_Rx2,
		ECS_SPI_MISO_rea_Rx3,
		--
		ECS_SPI_WRITE_TX_REG,
		ECS_SPI_READ_RX_REG,
		INVALID 
	);
	
	type ecs_spi_cmd_table_t is array(ecs_spi_cmd_enum'left to ecs_spi_cmd_enum'right) of byte_t;
	constant ecs_spi_cmd_table : ecs_spi_cmd_table_t :=(
		--ECS_SPI_GO => x"40",
		ECS_SPI_GO=>x"72",
		ECS_SPI_W_CTRL=>x"40",
		ECS_SPI_R_CTRL=>x"41",
		ECS_SPI_W_SS=>x"60",
		ECS_SPI_R_SS=>x"61",
		ECS_SPI_W_FREQ=>x"50",
		ECS_SPI_R_FREQ=>x"51",
		--
		ECS_SPI_MOSI_wrt_Tx0=>x"00",
		ECS_SPI_MOSI_rea_Tx0=>x"01",
		ECS_SPI_MOSI_wrt_Tx1=>x"10",
		ECS_SPI_MOSI_rea_Tx1=>x"11",
		ECS_SPI_MOSI_wrt_Tx2=>x"20",
		ECS_SPI_MOSI_rea_Tx2=>x"21",
		ECS_SPI_MOSI_wrt_Tx3=>x"30",
		ECS_SPI_MOSI_rea_Tx3=>x"31",
		--
		ECS_SPI_MISO_rea_Rx0=>x"01",
		ECS_SPI_MISO_rea_Rx1=>x"11",
		ECS_SPI_MISO_rea_Rx2=>x"21",
		ECS_SPI_MISO_rea_Rx3=>x"31",
		--
		ECS_SPI_WRITE_TX_REG => x"48",
		ECS_SPI_READ_RX_REG => x"49",
		INVALID  => x"FF"
	);
	
		
	
	
	--! JTAG commands dictionary------------------------------------------------
	type jtag_cmd_enum is (
	--Configuration registers:
		JTAG_GO,JTAG_wrt_CTRL,JTAG_rea_CTRL,JTAG_wrt_DIV,JTAG_rea_DIV,
		--TMS buffer registers:
		JTAG_TMS_wrt_Tx0,JTAG_TMS_rea_Tx0,JTAG_TMS_wrt_Tx1,JTAG_TMS_rea_Tx1,JTAG_TMS_wrt_Tx2,
		JTAG_TMS_rea_Tx2,JTAG_TMS_wrt_Tx3,JTAG_TMS_rea_Tx3,
		--TDO buffer registers:
		JTAG_TDO_wrt_Tx0,JTAG_TDO_rea_Tx0,JTAG_TDO_wrt_Tx1,JTAG_TDO_rea_Tx1,
		JTAG_TDO_wrt_Tx2,JTAG_TDO_rea_Tx2,JTAG_TDO_wrt_Tx3,JTAG_TDO_rea_Tx3,
		--TDI buffer registers:
		JTAG_TDI_rea_Rx0, JTAG_TDI_rea_Rx1, JTAG_TDI_rea_Rx2, JTAG_TDI_rea_Rx3
	);
	
	type jtag_cmd_table_t is array(jtag_cmd_enum'left to jtag_cmd_enum'right) of byte_t;
	
	constant jtag_cmd_table : jtag_cmd_table_t := (	
		JTAG_GO=>x"A2",
		JTAG_wrt_CTRL=>x"80",
		JTAG_rea_CTRL=>x"81",
		JTAG_wrt_DIV=>x"90",
		JTAG_rea_DIV=>x"91",
		--
		JTAG_TMS_wrt_Tx0=>x"40",
		JTAG_TMS_rea_Tx0=>x"41",
		JTAG_TMS_wrt_Tx1=>x"50",
		JTAG_TMS_rea_Tx1=>x"51",
		JTAG_TMS_wrt_Tx2=>x"60",
		JTAG_TMS_rea_Tx2=>x"61",
		JTAG_TMS_wrt_Tx3=>x"70",
		JTAG_TMS_rea_Tx3=>x"71",
		--
		JTAG_TDO_wrt_Tx0=>x"00",
		JTAG_TDO_rea_Tx0=>x"01",
		JTAG_TDO_wrt_Tx1=>x"10",
		JTAG_TDO_rea_Tx1=>x"11",
		JTAG_TDO_wrt_Tx2=>x"20",
		JTAG_TDO_rea_Tx2=>x"21",
		JTAG_TDO_wrt_Tx3=>x"30",
		JTAG_TDO_rea_Tx3=>x"31",
		--
		JTAG_TDI_rea_Rx0=>x"01",
		JTAG_TDI_rea_Rx1=>x"11",
		JTAG_TDI_rea_Rx2=>x"21",
		JTAG_TDI_rea_Rx3=>x"31"
							
	);		
	
	
	type ecs_jtag_cmd_enum is(
		ECS_JTAG_GO,ECS_JTAG_wrt_CTRL,ECS_JTAG_rea_CTRL,ECS_JTAG_wrt_DIV,ECS_JTAG_rea_DIV,
		--TMS buffer registers:
		ECS_JTAG_TMS_wrt_Tx0,ECS_JTAG_TMS_rea_Tx0,ECS_JTAG_TMS_wrt_Tx1,ECS_JTAG_TMS_rea_Tx1,ECS_JTAG_TMS_wrt_Tx2,
		ECS_JTAG_TMS_rea_Tx2,ECS_JTAG_TMS_wrt_Tx3,ECS_JTAG_TMS_rea_Tx3,
		--TDO buffer registers:
		ECS_JTAG_TDO_wrt_Tx0,ECS_JTAG_TDO_rea_Tx0,ECS_JTAG_TDO_wrt_Tx1,ECS_JTAG_TDO_rea_Tx1,
		ECS_JTAG_TDO_wrt_Tx2,ECS_JTAG_TDO_rea_Tx2,ECS_JTAG_TDO_wrt_Tx3,ECS_JTAG_TDO_rea_Tx3,
		--TDI buffer registers:
		ECS_JTAG_TDI_rea_Rx0, ECS_JTAG_TDI_rea_Rx1, ECS_JTAG_TDI_rea_Rx2, ECS_JTAG_TDI_rea_Rx3,

		--
		ECS_JTAG_WRITE_TMS,
		ECS_JTAG_READ_TMS,
		ECS_JTAG_WRITE_TDO,
		ECS_JTAG_READ_TDO,
		INVALID 
	);

	
	type ecs_jtag_cmd_table_t is array(ecs_jtag_cmd_enum'left to ecs_jtag_cmd_enum'right) of byte_t;
	constant ecs_jtag_cmd_table : ecs_jtag_cmd_table_t :=(
		ECS_JTAG_GO=>x"A2",
		ECS_JTAG_wrt_CTRL=>x"80",
		ECS_JTAG_rea_CTRL=>x"81",
		ECS_JTAG_wrt_DIV=>x"90",
		ECS_JTAG_rea_DIV=>x"91",
		--
		ECS_JTAG_TMS_wrt_Tx0=>x"40",
		ECS_JTAG_TMS_rea_Tx0=>x"41",
		ECS_JTAG_TMS_wrt_Tx1=>x"50",
		ECS_JTAG_TMS_rea_Tx1=>x"51",
		ECS_JTAG_TMS_wrt_Tx2=>x"60",
		ECS_JTAG_TMS_rea_Tx2=>x"61",
		ECS_JTAG_TMS_wrt_Tx3=>x"70",
		ECS_JTAG_TMS_rea_Tx3=>x"71",
		--
		ECS_JTAG_TDO_wrt_Tx0=>x"00",
		ECS_JTAG_TDO_rea_Tx0=>x"01",
		ECS_JTAG_TDO_wrt_Tx1=>x"10",
		ECS_JTAG_TDO_rea_Tx1=>x"11",
		ECS_JTAG_TDO_wrt_Tx2=>x"20",
		ECS_JTAG_TDO_rea_Tx2=>x"21",
		ECS_JTAG_TDO_wrt_Tx3=>x"30",
		ECS_JTAG_TDO_rea_Tx3=>x"31",
		--
		ECS_JTAG_TDI_rea_Rx0=>x"01",
		ECS_JTAG_TDI_rea_Rx1=>x"11",
		ECS_JTAG_TDI_rea_Rx2=>x"21",
		ECS_JTAG_TDI_rea_Rx3=>x"31",
		--
		ECS_JTAG_WRITE_TMS => x"52",
		ECS_JTAG_READ_TMS => x"53",
		ECS_JTAG_WRITE_TDO => x"54",
		ECS_JTAG_READ_TDO => x"55",
		INVALID => x"FF"
		
	);
	
	
	--! GPIO commands dictionary ----------------------------------------------
	
	type gpio_cmd_enum is(
		--Read the DATA_IN register
		GPIO_REA_IN_DATA,
		--Read/Write DATA_OUT register
		GPIO_SET_OUT_DATA, GPIO_REA_OUT_DATA,
		--Read/Write IO_DIRECTION register
		GPIO_SET_IO_DIR, GPIO_REA_IO_DIR,
		--Read/Write INTERRUPT_ENABLE register
		GPIO_SET_INTEN, GPIO_REA_INTEN,
		--Read/Write INTERRUPT_ENABLE register
		GPIO_SET_TRIG, GPIO_REA_TRIG,
		--Read/Write GLOBAL INTERRUPT ENABLE register
		GPIO_SET_GIE, GPIO_REA_GIE,
		--Read/Write INTERRUPT register
		GPIO_SET_INT, GPIO_REA_INT,
		--Read/Write CLK_SEL register
		GPIO_SET_CLK_SEL, GPIO_REA_CLK_SEL,
		--Read/Write CLK_EDGE register
		GPIO_SET_EDG, GPIO_REA_EDG
	);
	
	type gpio_cmd_table_t is array(gpio_cmd_enum'left to gpio_cmd_enum'right) of byte_t;
	constant gpio_cmd_table : gpio_cmd_table_t :=(
		GPIO_REA_IN_DATA=>x"01",
		GPIO_SET_OUT_DATA=>x"10",
		GPIO_REA_OUT_DATA=>x"11",
		GPIO_SET_IO_DIR=>x"20",
		GPIO_REA_IO_DIR=>x"21",
		GPIO_SET_INTEN=>x"20",
		GPIO_REA_INTEN=>x"21",
		GPIO_SET_TRIG=>x"30",
		GPIO_REA_TRIG=>x"31",
		GPIO_SET_GIE=>x"60",
		GPIO_REA_GIE=>x"61",
		GPIO_SET_INT=>x"70",
		GPIO_REA_INT=>x"71",
		GPIO_SET_CLK_SEL=>x"80",
		GPIO_REA_CLK_SEL=>x"81",
		GPIO_SET_EDG=>x"90",
		GPIO_REA_EDG=>x"91"
	);
	
	
	type ecs_gpio_cmd_enum is(
		--Read the DATA_IN register
		ECS_GPIO_REA_IN_DATA,
		--Read/Write DATA_OUT register
		ECS_GPIO_SET_OUT_DATA, ECS_GPIO_REA_OUT_DATA,
		--Read/Write IO_DIRECTION register
		ECS_GPIO_SET_IO_DIR, ECS_GPIO_REA_IO_DIR,
		--Read/Write INTERRUPT_ENABLE register
		ECS_GPIO_SET_INTEN, ECS_GPIO_REA_INTEN,
		--Read/Write INTERRUPT_ENABLE register
		ECS_GPIO_SET_TRIG, ECS_GPIO_REA_TRIG,
		--Read/Write GLOBAL INTERRUPT ENABLE register
		ECS_GPIO_SET_GIE, ECS_GPIO_REA_GIE,
		--Read/Write INTERRUPT register
		ECS_GPIO_SET_INT, ECS_GPIO_REA_INT,
		--Read/Write CLK_SEL register
		ECS_GPIO_SET_CLK_SEL, ECS_GPIO_REA_CLK_SEL,
		--Read/Write CLK_EDGE register
		ECS_GPIO_SET_EDG, ECS_GPIO_REA_EDG,
		INVALID 
	);
	
	type ecs_gpio_cmd_table_t is array(ecs_gpio_cmd_enum'left to ecs_gpio_cmd_enum'right) of byte_t;
	constant ecs_gpio_cmd_table : ecs_gpio_cmd_table_t :=(
		ECS_GPIO_REA_IN_DATA=>x"01",
		ECS_GPIO_SET_OUT_DATA=>x"10",
		ECS_GPIO_REA_OUT_DATA=>x"11",
		ECS_GPIO_SET_IO_DIR=>x"20",
		ECS_GPIO_REA_IO_DIR=>x"21",
		ECS_GPIO_SET_INTEN=>x"20",
		ECS_GPIO_REA_INTEN=>x"21",
		ECS_GPIO_SET_TRIG=>x"30",
		ECS_GPIO_REA_TRIG=>x"31",
		ECS_GPIO_SET_GIE=>x"60",
		ECS_GPIO_REA_GIE=>x"61",
		ECS_GPIO_SET_INT=>x"70",
		ECS_GPIO_REA_INT=>x"71",
		ECS_GPIO_SET_CLK_SEL=>x"80",
		ECS_GPIO_REA_CLK_SEL=>x"81",
		ECS_GPIO_SET_EDG=>x"90",
		ECS_GPIO_REA_EDG=>x"91",
		INVALID 	=>x"FF"
	);
	
	
	
	
	---------------------------------------------------------------------------
	--type decoding_state_t is (decoding_sof,decoding_ch,decoding_tr,decoding_ack,decoding_protocol,decoding_eof);
	
	
	
	constant CMD_MEM_ADDR_WIDTH		:	integer := 12; 
	constant RPY_MEM_ADDR_WIDTH		:	integer := 12;
	constant MEM_DATA_WIDTH			:	integer := 32; 
	
	procedure i2c_rpy_builder(
		cmd 				: 	byte_t;
		signal rpy_p_len	:	out	natural range 0 to 31;
		signal is_var_len	:	out	std_logic
	);
	
	
	
	
	

	
	
	
	type PROT_DRIVER_ENUM_t is (SCA_CTL, GPIO, SPI, I2C, JTAG, ADC, DAC);
	type sca_num_prot_t	is array (PROT_DRIVER_ENUM_t'left to PROT_DRIVER_ENUM_t'right) of natural range 0 to SCA_BY_GBT_COUNT -1;
	
		
	type prot_cmd_vector_by_prot_t is array(PROT_DRIVER_ENUM_t'left to PROT_DRIVER_ENUM_t'right) of prot_cmd_t;
	
	type elink_by_gbt_and_sca_t	is array(0 to GBT_COUNT-1,0 to SCA_BY_GBT_COUNT-1) of std_logic_vector(1 downto 0);
	
	constant ECS_DATA_WIDTH	:	natural	:=	8+5*32;
	
	constant ECS_MEM_COUNT	:	natural := GBT_COUNT*SCA_BY_GBT_COUNT*CH_BY_SCA_COUNT;
	
	
--	constant ECS_DATA_WIDTH	:	natural	:=	ecs_packet_t.ecs_cmd'length 
--										+ ecs_packet_t.protocol_specific'length
--										+ ecs_packet_t.len'length
--										+ ecs_packet_t.data'length;
										
	constant ECS_ADDR_WIDTH	:	natural	:=	 byte_t'length
										+  byte_t'length;

--	function ecs_packet_to_ecs_data_bus(ecs_packet	:	ecs_packet_t)
--		return std_logic_vector;
--	function ecs_packet_to_ecs_address_bus(ecs_packet	:	ecs_packet_t)
--		return std_logic_vector;
		
	function sol40_data_to_ecs_packet (
	ecs_addr : std_logic_vector(ECS_ADDR_WIDTH-1 downto 0);
	ecs_data : std_logic_vector(ECS_DATA_WIDTH-1 downto 0)
	)
	return ecs_packet_t;
	
	
	type SCA_link_state_t is (RESET, IDLE, TESTING, CONNECTING, READY, FAILED);
	type SCA_link_state_array_t is array(0 to GBT_COUNT-1,0 to SCA_BY_GBT_COUNT-1) of SCA_link_state_t;
end SCA_Package;



--
	 
	
package body SCA_Package is

	




procedure i2c_cmd_builder(
	cmd 				: 	byte_t;
	signal cmd_p_len	:	out	natural range 0 to 31;
	signal has_len		:	out	std_logic;
	signal cmd_var_len	:	out	std_logic;
	signal rpy_var_len	:	out	std_logic
) is
	
begin

	case cmd is
		when x"00"|x"03"|x"83"|x"84"|x"85"|x"89" =>
			--C: CH# + TR# + CMD + A[7:0] + DW
			--or C: CH# + TR# + CMD + A[9:8] + A[7:0]
			cmd_p_len <= 5;
			cmd_var_len <= '0';
			rpy_var_len <= '0';
			if cmd = x"89" then
				has_len <= '0';
			else
				has_len <= '1';
			end if;
		when x"02"|x"87"|x"88" =>
			-- C: CH# + TR# + CMD + A[9:8] + A[7:0] + DW
			cmd_p_len <= 6;
			cmd_var_len <= '0';
			rpy_var_len <= '0';
			if cmd = x"87" then
				has_len <= '1';
			end if;
		when x"01"|x"80"|x"81"|x"82"|x"f0" =>
			-- C: CH# + TR# + CMD + A[7:0]
			-- R: CH# + TR# + ACK + DR
			cmd_p_len <= 4;
			cmd_var_len <= '0';
		when x"86" =>
			-- C: CH# + TR# + CMD + LEN + A[9:8] + A[7:0] + DW
			cmd_p_len <= 7;
			cmd_var_len <= '0';
			-- C: CH# + TR# + CMD + LEN + A[7:0] + DW
			-- C: CH# + TR# + CMD + LEN + A[7:0]
			-- R: CH# + TR# + ACK + DR (LEN -1 bytes)
			

		when x"f1"|x"f2"|x"f3"|x"f7"|x"ff" =>
			-- C: CH# + TR# + CMD
			cmd_p_len <= 3;
			cmd_var_len <= '0';
		when others =>
			cmd_p_len <= 0;
			cmd_var_len <= '0';
	end case;
end procedure i2c_cmd_builder;


procedure i2c_rpy_builder(
	cmd 				: 	byte_t;
	signal rpy_p_len	:	out	natural range 0 to 31;
	signal is_var_len	:	out	std_logic
) is
	--variable rpy_p_len	:	integer;	
	
begin

	case cmd is
		when x"00"|x"01"|x"02"|x"03"|x"81"|x"82"|x"83"|x"84"|x"85"|x"86"|x"88"|x"f0"|x"f1" =>
			rpy_p_len <= 4;
			is_var_len <= '0';
		when x"f2" =>
			rpy_p_len <= 3;
			is_var_len <= '0';
		when x"87"|x"89" =>
			rpy_p_len <= 3;
			is_var_len <= '1';
		when others =>
			rpy_p_len <= 0;
			is_var_len <= '0';	
	end case;
end procedure i2c_rpy_builder;




--function ecs_packet_to_ecs_data_bus(ecs_packet	:	ecs_packet_t)
--		return std_logic_vector is
--		variable ret :	std_logic_vector(ECS_DATA_WIDTH-1 downto 0);
--	begin
--		ret := ecs_packet.ecs_cmd 
--			 & ecs_packet.protocol_specific & ecs_packet.len & ecs_packet.data;
--		
--		return ret;
--	end function ecs_packet_to_ecs_data_bus;
--	
	
--function ecs_packet_to_ecs_address_bus(ecs_packet	:	ecs_packet_t)
--		return std_logic_vector is
--		variable ret :	std_logic_vector(ECS_ADDR_WIDTH-1 downto 0);
--		variable sca_nr_in_bits	:	byte_t;
--	begin
--		if SCA_COUNT > 2**(sca_nr_in_bits'length) then
--			report "SCA Number field of the ECS Interface is not big enough" severity ERROR;
--		end if;
--		sca_nr_in_bits := std_logic_vector(to_unsigned( ecs_packet.sca_nr , sca_nr_in_bits'length));
--		
--		ret := sca_nr_in_bits & ecs_packet.sca_ch;
--		
--		return ret;
--	end function ecs_packet_to_ecs_address_bus;
	
function sol40_data_to_ecs_packet (
	ecs_addr : std_logic_vector(ECS_ADDR_WIDTH-1 downto 0);
	ecs_data : std_logic_vector(ECS_DATA_WIDTH-1 downto 0)
)
	return ecs_packet_t is
	variable ret :	ecs_packet_t;
begin
	
	ret.sca_nr := ecs_addr (15 downto 8);
	ret.sca_ch := ecs_addr (7 downto 0);
	
	
	ret.ecs_cmd := ecs_data( ecs_data'high 
			downto ecs_data'high - ret.ecs_cmd'length + 1);
	ret.protocol_specific := ecs_data( ecs_data'high - ret.ecs_cmd'length 
			downto ecs_data'high - ret.ecs_cmd'length - ret.protocol_specific'length + 1);
	ret.len :=  ecs_data(ecs_data'high - ret.ecs_cmd'length - ret.protocol_specific'length
			downto ecs_data'high - ret.ecs_cmd'length - ret.protocol_specific'length - ret.len'length + 1);
	ret.data :=  ecs_data(ecs_data'high - ret.ecs_cmd'length - ret.protocol_specific'length - ret.len'length
			downto ecs_data'high - ret.ecs_cmd'length - ret.protocol_specific'length - ret.len'length - ret.data'length + 1);
	return ret;
end function sol40_data_to_ecs_packet;




	
		--subtype wrd_t is  std_logic_vector(255 downto 0);
	--type shared_mem_t is  array(integer range <>) of byte_t;


----! Function that returns specified lengths of commands and replies for each kind of command
--function protocol_builder (ecs_ch : std_logic_vector(4 downto 0) ; cmd : byte_t; tr : byte_t)
--	return payload_t is
--	variable payload			:	payload_t;
--	variable payload_len		:	payload_len_t;
--	variable sca_ch				:	byte_t;
--	variable cmd_p_len			:	integer;
--
--begin
--	--translate the compressed 5 bits ecs channel information into the byte CH# GBT-SCA field 
--	sca_ch := channels_table(to_integer(unsigned(ecs_ch)));
--	payload.ch := sca_ch;
--	payload.tr := tr;
--	payload.cmd_or_ack := cmd;
--	
--	
--	for i in 0 to master_i2c_vector_ch'high loop
--		if master_i2c_vector_ch(i) = sca_ch then	
--			
--			
--			
--			
--			
--		end if;
--	end loop;
--	
--	for i in 0 to master_pia_ch'high loop
--	
--		if master_pia_ch(i) = sca_ch then
--		
--		end if;
--	end loop;
--	
--	for i in 0 to interrupt_channels'high loop
--	
--		if interrupt_channels(i) = sca_ch then
--		
--		end if;
--	end loop;
--	
--	
--	if network_controller_ch = sca_ch then
--	
--	elsif master_spi_ch = sca_ch then
--	
--	elsif master_mem_ch = sca_ch then
--	
--	elsif master_jtag_ch  = sca_ch then
--	elsif adc_input_ch  = sca_ch then
--	elsif sca_reset_ch  = sca_ch then
--	
--	end if;
--	
--	
--	return payload;
--end function protocol_builder;



--function protocol_decoder (sca_ch : byte_t ; cmd : byte_t; tr : byte_t)
--	return payload_len_t is
--	variable payload_len		:	payload_len_t;
--	variable i					:	integer;
--	variable cmd_p_len,rpy_p_len:	integer;
--
--begin
--
--
--end function protocol_decoder;



end package body;
	



