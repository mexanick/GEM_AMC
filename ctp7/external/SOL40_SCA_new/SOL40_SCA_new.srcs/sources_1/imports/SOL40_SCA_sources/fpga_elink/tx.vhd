library ieee;
use ieee.std_logic_1164.all;

entity tx is
	generic(
		HEADER_FIELD:	integer := 1;
		ADDR_WIDTH	:	integer := 5;
		THRESHOLD	:	integer := 3072
	);
	port (
		tx_dat				:	in	std_logic_vector(15 downto 0);
		clk					:	in	std_logic;
		tx_ena				:	in	std_logic;
		tx_adr				:	in	std_logic_vector(7 downto 0);
		resetb				:	in	std_logic;
		tx_cmd_reset		:	in	std_logic;
		tx_cmd_test			:	in	std_logic;
		rx_cmd_reset		:	in	std_logic;
		tx_dav				:	out	std_logic;
		tx_sdr				:	out	std_logic_vector(1 downto 0);
		tx_ns				:	out	std_logic_vector(2 downto 0);
		tx_nr				:	in	std_logic_vector(2 downto 0);
		tx_cmd_srej			:	in	std_logic_vector(6 downto 0);
		tx_cmd_sabm			:	in	std_logic;
		tx_cmd_ua			:	in	std_logic;
		cmd_busy			:	out std_logic
	);
end entity tx;

architecture RTL of tx is
	
	
	
	component MAC_tx
		generic(ADDR_WIDTH   : integer := 12;
			    THRESHOLD    : integer := 3072;
			    HEADER_FIELD : integer := 1);
		port(tx_dat        : in  std_logic_vector(15 downto 0);
			 tx_ena        : in  std_logic;
			 tx_dav        : out std_logic;
			 tx_adr        : in  std_logic_vector(7 downto 0);
			 clk           : in  std_logic;
			 tx_nr         : in  std_logic_vector(2 downto 0);
			 tx_ns       : out std_logic_vector(2 downto 0);
			 tx_cmd_srej   : in  std_logic_vector(6 downto 0);
			 resetb        : in  std_logic;
			 tx_cmd_reset  : in  std_logic;
			 tx_cmd_test   : in  std_logic;
			 --phy_bytesel : out std_logic;
			 phy_dvalid  : out std_logic;
			 phy_tx_data   : out std_logic_vector(7 downto 0);
			 phy_dstrobe   : in  std_logic;
			 crc           : in  std_logic_vector(15 downto 0);
			 crc_strobe    : out std_logic;
			 tx_cmd_sabm   : in  std_logic;
			 tx_cmd_ua     : in  std_logic;
			 cmd_busy      : out std_logic;
			 rx_cmd_reset  : in  std_logic);
	end component MAC_tx;
	
	component crc
		generic(CRC_WIDTH  : natural                              := 16;
			    DATA_WIDTH : natural                              := 16;
			    INIT_VAL   : std_logic_vector(2 * 8 - 1 downto 0) := x"ffff";
			    POLY       : std_logic_vector(2 * 8 - 1 downto 0) := x"8408");
		port(d       : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 init    : in  std_logic;
			 d_valid : in  std_logic;
			 clk     : in  std_logic;
			 reset_b : in  std_logic;
			 crc_o   : out std_logic_vector(CRC_WIDTH - 1 downto 0));
	end component crc;
	
	
	component PHY_HDLC_tx
		port(resetb     : in  std_logic;
			 tx_clk     : in  std_logic;
			 tx_sdr     : out std_logic_vector(1 downto 0);
			 tx_data    : in  std_logic_vector(7 downto 0);
			 tx_dvalid  : in  std_logic;
			 tx_dstrobe : out std_logic);
	end component PHY_HDLC_tx;
	
	component regbank
		generic(WIDTH : integer := 8);
		port(d   : in  std_logic_vector(WIDTH - 1 downto 0);
			 rn  : in  std_logic;
			 q   : out std_logic_vector(WIDTH - 1 downto 0);
			 clk : in  std_logic);
	end component regbank;
	
	--signal	phy_bytesel			:	std_logic;
	signal  phy_tx_data 		: std_logic_vector(7 downto 0);
	signal  phy_dvalid 			: std_logic;
	signal  phy_dstrobe 		: std_logic;
	signal	phy_resetb 			: std_logic;
	
	signal crc_strobe 			: std_logic;
	
	--signal clkb 				: std_logic;
	signal crc_o				: std_logic_vector(15 downto 0);

	signal phy_tx_data_delayed	: std_logic_vector(7 downto 0);
	
	
	signal phy_dvalidb : std_logic;
	
	
begin
	
	
	
	MAC_tx_inst : component MAC_tx
		generic map(ADDR_WIDTH   => ADDR_WIDTH,
			        THRESHOLD    => THRESHOLD,
			        HEADER_FIELD => HEADER_FIELD)
		port map(tx_dat        => tx_dat,
			     tx_ena        => tx_ena,
			     tx_dav        => tx_dav,
			     tx_adr        => tx_adr,
			     clk           => clk,
			     tx_nr         => tx_nr,
			     tx_ns       => tx_ns,
			     tx_cmd_srej   => tx_cmd_srej,
			     resetb        => resetb,
			     tx_cmd_reset  => tx_cmd_reset,
			     tx_cmd_test   => tx_cmd_test,
--			     phy_bytesel => phy_bytesel,
			     phy_dvalid  => phy_dvalid,
			     phy_tx_data   => phy_tx_data,
			     phy_dstrobe   => phy_dstrobe,
			     crc           => crc_o,
			     crc_strobe    => crc_strobe,
			     tx_cmd_sabm   => tx_cmd_sabm,
			     tx_cmd_ua     => tx_cmd_ua,
			     cmd_busy      => cmd_busy,
			     rx_cmd_reset  => rx_cmd_reset);
			     
			     
			     
	regbank_inst : component regbank
		generic map(WIDTH => phy_tx_data'length)
		port map(d   => phy_tx_data,
			     rn  => '1',
			     q   => phy_tx_data_delayed,
			     clk => clk);
			     
	crc_inst : component crc
		generic map(
			        DATA_WIDTH => 8)
		port map(d       => phy_tx_data_delayed,
			     init    => phy_dvalidb,
			     d_valid => crc_strobe,
			     clk     => clk,
			     reset_b => resetb,
			     crc_o   => crc_o);
			
	PHY_HDLC_tx_inst : component PHY_HDLC_tx
		port map(tx_data      => phy_tx_data,
			     tx_dvalid    => phy_dvalid,
			     tx_dstrobe => phy_dstrobe,
			     tx_sdr     => tx_sdr,
			     tx_clk       => clk,
			     resetb       => phy_resetb);     
			     
	--
	--clkb <= not clk;
	
	phy_dvalidb <= not phy_dvalid;
	
	phy_resetb <= resetb and (not rx_cmd_reset);
	
	
	
end architecture RTL;
