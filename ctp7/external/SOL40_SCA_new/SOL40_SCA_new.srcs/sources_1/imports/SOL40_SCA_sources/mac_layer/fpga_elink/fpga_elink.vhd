library ieee;
use ieee.std_logic_1164.all;

entity fpga_elink is
	generic(
		--! If 1, port behaves as master, 0 as slave. 
		MASTER				:	integer := 1;
		--! If 1, header field is present in the packet structure. The header field carries address and command information.
	 	HEADER_FIELD		:	integer := 1;
	 	--! Transmit and receive FIFO addressing width.
	 	ADDR_WIDTH			:	integer := 5;
	 	--! Maximum expected packet length
	 	MAX_PACKET_LENGTH	:	integer := 16
	 	
	 	);
	port (
		--! \name Backend signals
		--! Backend signals
		--! \{
		---------------------------------------------------------
		--! Reset signal , active on 1
		reset      	:	in  std_logic;
		--! User clock
		user_clk		:	out	std_logic;
		--! 
		cmd_busy		:	out	std_logic;
		
		--! Transfer Enable (Data Valid)
		rx_ena      	:	out std_logic;
		--! Ready to receive data
		rx_dav      	:	in  std_logic;
		--! Start of Packet
		rx_sop			:	out std_logic;
		--! End of Packet
		rx_eop      	:	out std_logic;
		--! Test command receive flag
		rx_cmd_test		:	out	std_logic;
		--! Reset command receive flag
		rx_cmd_reset	:	out	std_logic;
		--! Unnumbered acknowledge receive flag
		rx_cmd_ua		:	out	std_logic;
		--! Received packet number
		rx_ns			:	out std_logic_vector(2 downto 0);
		--! Address Bus
		rx_adr			:	out	std_logic_vector(7 downto 0);
		--! Data Bus
		rx_dat      	:	out std_logic_vector(15 downto 0);
		--! Last correctly received packet number
		rx_nr			:	out std_logic_vector(2 downto 0);
		--! Received SREJ command word
		rx_cmd_srej		:	out std_logic_vector(6 downto 0);
		--! Rx error, currently always 0 . . .
		rx_err			:	out std_logic;
		--------------------------------------------------------
		--! Transfer Enable (Data Valid)
		tx_ena			:	in	std_logic;
		--! Ready to receive data
		tx_dav     		:	out std_logic;
		--! Send test command flag
		tx_cmd_test		:	in	std_logic;
		--! Send reset command flag
		tx_cmd_reset	:	in  std_logic;
		--! Send connect command flag
		tx_cmd_sabm		:	in	std_logic;
		--! Transmitted packet number
		tx_ns        	:	out std_logic_vector(2 downto 0);
		--! Send Address command flag
		tx_adr			:	in	std_logic_vector(7 downto 0);
		--! Data bus
		tx_dat      	:	in  std_logic_vector(15 downto 0);
		--! Transmitter current level setting (relevant on backend?)
		tx_cset			:	in	std_logic_vector(3 downto 0);
		--! \}
		
		--! \name Elink signals
		--! Elink signals, to be connected to the GBT chip
		--! \{
		--!
		tx_clk			:	in	std_logic;
		tx_sd      		:	out std_logic_vector(1 downto 0);
		rx_clk			:	in	std_logic;
		rx_sd			:	in	std_logic_vector(1 downto 0)
		--! \}
	);
	
	
	
end entity fpga_elink;

architecture RTL of fpga_elink is
	
	--constant THRESHOLD	:	integer:= 2**ADDR_WIDTH -MAX_PACKET_LENGTH-1;
	
	signal rx_sdr, tx_sdr		:	std_logic_vector(1 downto 0);
	
	component HDLC
		generic(MASTER            : integer := 0;
			    HEADER_FIELD      : integer := 1;
			    ADDR_WIDTH        : integer := 5;
			    MAX_PACKET_LENGTH : integer := 16);
		port(tx_dat       : in  std_logic_vector(15 downto 0);
			 rx_dat       : out std_logic_vector(15 downto 0);
			 rx_dav       : in  std_logic;
			 tx_clk       : in  std_logic;
			 rx_clk       : in  std_logic;
			 rx_ena       : out std_logic;
			 rx_eop       : out std_logic;
			 tx_dav       : out std_logic;
			 rx_sop       : out std_logic;
			 rx_err       : out std_logic;
			 resetb       : in  std_logic;
			 tx_ena       : in  std_logic;
			 user_clk     : out std_logic;
			 tx_adr       : in  std_logic_vector(7 downto 0);
			 rx_adr       : out std_logic_vector(7 downto 0);
			 tx_cmd_reset : in  std_logic;
			 tx_cmd_test  : in  std_logic;
			 tx_cmd_sabm  : in  std_logic;
			 rx_cmd_reset : out std_logic;
			 rx_cmd_test  : out std_logic;
			 rx_cmd_ua    : out std_logic;
			 tx_ns        : out std_logic_vector(2 downto 0);
			 rx_nr        : out std_logic_vector(2 downto 0);
			 rx_ns        : out std_logic_vector(2 downto 0);
			 rx_cmd_srej  : out std_logic_vector(6 downto 0);
			 cmd_busy     : out std_logic;
			 tx_sdr       : out std_logic_vector(1 downto 0);
			 rx_sdr       : in  std_logic_vector(1 downto 0));
	end component HDLC;
	
	
	
	--component serdes
	--	port(rx_sd       : in  std_logic;
	--		 rx_clk      : in  std_logic;
	--		 resetb      : in  std_logic;
	--		 tx_sd       : out std_logic;
	--		 clk40       : out std_logic;
	--		 tx_dat      : in  std_logic_vector(7 downto 0);
	--		 rx_dat      : out std_logic_vector(7 downto 0);
	--		 tx_off      : in  std_logic;
	--		 rx_off      : in  std_logic;
	--		 clkdiv_skip : in  std_logic);
	--end component serdes;
	--signal user_clk_pri : std_logic;
	signal resetb : std_logic;
	
	
begin
	resetb <= not reset;

	
--	rx_sdr <= rx_dat_8(1 downto 0);
--	--
--	tx_dat_8(tx_sdr'high downto 0) <=  tx_sdr;
--	tx_dat_8(tx_dat_8'high downto tx_sdr'high +1) <= (others=>'0');
	--
	
	
	HDLC_inst : component HDLC
		generic map(MASTER            => MASTER,
			        HEADER_FIELD      => HEADER_FIELD,
			        ADDR_WIDTH        => ADDR_WIDTH,
			        MAX_PACKET_LENGTH => MAX_PACKET_LENGTH)
		port map(tx_dat       => tx_dat,
			     rx_dat       => rx_dat,
			     rx_dav       => rx_dav,
			     tx_clk 	  => tx_clk,
			     rx_clk		  => rx_clk,
			     rx_ena       => rx_ena,
			     rx_eop       => rx_eop,
			     tx_dav       => tx_dav,
			     rx_sop       => rx_sop,
			     rx_err       => rx_err,
			     resetb       => resetb,
			     tx_ena       => tx_ena,
			     user_clk     => user_clk,
			     tx_adr       => tx_adr,
			     rx_adr       => rx_adr,
			     tx_cmd_reset => tx_cmd_reset,
			     tx_cmd_test  => tx_cmd_test,
			     tx_cmd_sabm  => tx_cmd_sabm,
			     rx_cmd_reset => rx_cmd_reset,
			     rx_cmd_test  => rx_cmd_test,
			     rx_cmd_ua    => rx_cmd_ua,
			     tx_ns        => tx_ns,
			     rx_nr        => rx_nr,
			     rx_ns        => rx_ns,
			     rx_cmd_srej  => rx_cmd_srej,
			     cmd_busy     => cmd_busy,
			     tx_sdr       => tx_sdr,
			     rx_sdr       => rx_sdr
			     --rx_sdr_aux   => rx_sdr_aux,
			     --active_aux   => active_aux
			     );
	
	
--	serdes_pri : component serdes
--		port map(rx_sd       => dummy_rx_sd,
--			     rx_clk      => link_clk,
--			     resetb      => '1',
--			     tx_sd       => dummy_tx_sd,
--			     clk40       => user_clk_pri,
--			     tx_dat      => tx_dat_8,
--			     rx_dat      => rx_dat_8,
--			     tx_off      => tx_off,
--			     rx_off      => '0',
--			     clkdiv_skip => '0');
			     
			     
--		serial_to_pair : process(link_clk,user_clk_pri) is
--	begin
--		--!user_clk_pri = tx_clk
--		if rising_edge(user_clk_pri) then
--			if 
--		end if;
--		
--		
--	end process serial_to_pair;
	
	rx_sdr <= rx_sd;
	tx_sd <= tx_sdr;
	
	--user_clk <= link_clk;
	

end architecture RTL;
