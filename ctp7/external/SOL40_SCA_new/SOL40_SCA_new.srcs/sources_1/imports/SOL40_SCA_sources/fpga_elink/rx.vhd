library ieee;
use ieee.std_logic_1164.all;

entity rx is
	generic(
		HEADER_FIELD	:	integer := 1;
	 	ADDR_WIDTH		:	integer	:= 8
	);
	port (
		rx_dat		: out std_logic_vector(15 downto 0);
		rx_ena		: out std_logic;
		rx_eop		: out std_logic;
		rx_sop		: out std_logic;
		rx_err		: out std_logic;
		rx_adr		: out std_logic_vector(7 downto 0);
		rx_cmd_reset: out std_logic;
		rx_cmd_test	: out std_logic;
		rx_cmd_ua	: out std_logic;
		tx_cmd_ua	: out std_logic;
		rx_cmd_srej	: out std_logic_vector(6 downto 0);
		tx_cmd_srej	: out std_logic_vector(6 downto 0);
		rx_vr		: out std_logic_vector(2 downto 0);
		rx_nr		: out std_logic_vector(2 downto 0);
		rx_ns		: out std_logic_vector(2 downto 0);
		clk			: in  std_logic;
		rx_clk		: in  std_logic;
		rx_dav		: in  std_logic;
		rx_sdr_pri	: in  std_logic_vector(1 downto 0);
		resetb		: in std_logic;
		tx_cmd_reset: in std_logic
	);
end entity rx;

architecture RTL of rx is
	--signal active_aux_int	:	std_logic;
	
	component MAC_rx
		generic(ADDR_WIDTH   : integer := 5;
			    HEADER_FIELD : integer := 1);
		port(rx_dat       : out std_logic_vector(15 downto 0);
			 rx_ena       : out std_logic;
			 rx_ena_pre   : out std_logic;
			 rx_eop       : out std_logic;
			 rx_err       : out std_logic;
			 rx_vr_o      : out std_logic_vector(2 downto 0);
			 rx_nr_o      : out std_logic_vector(2 downto 0);
			 rx_sop       : out std_logic;
			 rx_adr       : out std_logic_vector(7 downto 0);
			 clk          : in  std_logic;
			 rx_dav       : in  std_logic;
			 resetb       : in  std_logic;
			 rx_cmd_reset : out std_logic;
			 rx_cmd_test  : out std_logic;
			 phy_data     : in  std_logic_vector(7 downto 0);
			 phy_dvalid   : in  std_logic;
			 phy_dstrobe  : in  std_logic;
			 crc_zero     : in  std_logic;
			 rx_cmd_ua    : out std_logic;
			 rx_cmd_srej  : out std_logic_vector(6 downto 0);
			 tx_cmd_srej  : out std_logic_vector(6 downto 0);
			 rx_ns        : out std_logic_vector(2 downto 0);
			 rx_cmd_sabm  : out std_logic;
			 tx_cmd_ua    : out std_logic;
			 tx_cmd_reset : in  std_logic);
	end component MAC_rx;
	
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
	
	component PHY_HDLC_rx
		port(resetb     : in  std_logic;
			 rx_clk     : in  std_logic;
			 rx_sdr     : in  std_logic_vector(1 downto 0);
			 tx_clk     : in  std_logic;
			 rx_data    : out std_logic_vector(7 downto 0);
			 rx_dvalid  : out std_logic;
			 rx_dstrobe : out std_logic);
	end component PHY_HDLC_rx;
	
	
	component monostable
		port(clk : in  std_logic;
			 A   : in  std_logic;
			 Z   : out std_logic);
	end component monostable;
	
	
	--component DELAY_6C
	--	generic(number : integer := 1);
	--	port(a : in  std_logic;
	--		 z : out std_logic);
	--end component DELAY_6C;
	
	
	signal phy_data_pri		: std_logic_vector(7 downto 0);
	signal rx_cmd_srej_pri	: std_logic_vector(6 downto 0);
	signal tx_cmd_srej_pri	: std_logic_vector(6 downto 0); 
	signal rx_vr_pri		: std_logic_vector(2 downto 0);
	signal rx_nr_pri		: std_logic_vector(2 downto 0);
	signal rx_ns_pri		: std_logic_vector(2 downto 0);
	signal rx_dat_pri		: std_logic_vector(15 downto 0);
	signal rx_adr_pri		: std_logic_vector(7 downto 0);
	signal crc_pri			: std_logic_vector(15 downto 0);

	

	--signal clk_activeb		: std_logic;
	signal phy_dvalid_pri	: std_logic;
	signal phy_dvalid_prib	: std_logic;

	signal rx_cmd_sabm_pri	: std_logic;
	signal rx_cmd_reset_pri	: std_logic;
	
	signal rx_ena_pri			: std_logic;
	
	signal rx_eop_pri			: std_logic;
	
	signal rx_sop_pri			: std_logic;
	
	signal rx_err_pri			: std_logic;
	signal rx_cmd_test_pri		: std_logic;
	signal rx_cmd_ua_pri		: std_logic;
	signal tx_cmd_ua_pri		: std_logic;
	signal crc_zero_pri 		: std_logic;
	
	signal phy_dstrobe_pri		: std_logic;
	signal rx_ena_pre_pri 		: std_logic;
	signal rx_cmd_reset_pri_monos : std_logic;
		
begin
	
	
	--clk_activeb <= not clk_active;
	
	phy_dvalid_prib <= not phy_dvalid_pri;
	
	
	rx_dat <=  rx_dat_pri;
	
	rx_ena <= rx_ena_pri;
	
	rx_eop <= rx_eop_pri;
	
	rx_sop <=   rx_sop_pri;
	
	rx_err <=  rx_err_pri;
	
	rx_adr <=  rx_adr_pri;
	
	rx_cmd_reset <=  rx_cmd_reset_pri_monos;
	
	rx_cmd_test <=  rx_cmd_test_pri;
	
	rx_cmd_ua <=   rx_cmd_ua_pri;
	
	tx_cmd_ua <=   tx_cmd_ua_pri;
	
	rx_cmd_srej <=  rx_cmd_srej_pri;
	
	tx_cmd_srej <=  tx_cmd_srej_pri;
	
	rx_vr <=   rx_vr_pri;
	
	rx_nr <=  rx_nr_pri;
	
	rx_ns <=   rx_ns_pri;
	
	crc_zero_pri <= '1' when crc_pri= (crc_pri'range=>'0') else '0';
	
	
	
	
	
	MAC_rx_pri : component MAC_rx
		generic map(ADDR_WIDTH   => ADDR_WIDTH,
			        HEADER_FIELD => HEADER_FIELD)
		port map(rx_dat       => rx_dat_pri,
			     rx_ena       => rx_ena_pri,
			     rx_ena_pre   => rx_ena_pre_pri,
			     rx_eop       => rx_eop_pri,
			     rx_err         => rx_err_pri,
			     rx_vr_o        => rx_vr_pri,
			     rx_nr_o        => rx_nr_pri,
			     rx_sop       => rx_sop_pri,
			     rx_adr       => rx_adr_pri,
			     clk            => clk,
			     rx_dav         => rx_dav,
			     resetb         => resetb,
			     rx_cmd_reset => rx_cmd_reset_pri,
			     rx_cmd_test  => rx_cmd_test_pri,
			     phy_data       => phy_data_pri,
			     phy_dvalid     => phy_dvalid_pri,
			     phy_dstrobe    => phy_dstrobe_pri,
			     crc_zero       => crc_zero_pri,
			     rx_cmd_ua    => rx_cmd_ua_pri,
			     rx_cmd_srej  => rx_cmd_srej_pri,
			     tx_cmd_srej  => tx_cmd_srej_pri,
			     rx_ns        => rx_ns_pri,
			     rx_cmd_sabm  => rx_cmd_sabm_pri,
			     tx_cmd_ua    => tx_cmd_ua_pri,
			     tx_cmd_reset   => tx_cmd_reset);
			     

			     
	crc_pri_inst : component crc
		generic map(
			        DATA_WIDTH => 8)
		port map(d       => phy_data_pri,
			     init    => phy_dvalid_prib,
			     d_valid => phy_dstrobe_pri,
			     clk     => clk,
			     reset_b => resetb,
			     crc_o   => crc_pri);
			     
	PHY_HDLC_rx_pri : component PHY_HDLC_rx
		port map(rx_data    => phy_data_pri,
				 rx_clk		=> rx_clk,
			     rx_sdr       => rx_sdr_pri,
			     tx_clk       => clk,
			     rx_dvalid  => phy_dvalid_pri,
			     rx_dstrobe => phy_dstrobe_pri,
			     resetb       => resetb);

			     
	monostable_rx_cmd_reset_pri : component monostable
		port map(
			clk => clk,
			A => rx_cmd_reset_pri,
			Z => rx_cmd_reset_pri_monos);
end architecture RTL;
