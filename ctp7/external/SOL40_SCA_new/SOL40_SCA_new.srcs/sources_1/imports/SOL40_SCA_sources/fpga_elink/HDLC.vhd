library ieee;
use ieee.std_logic_1164.all;

entity HDLC is
	generic(
		MASTER				:	integer := 0;
	 	HEADER_FIELD		:	integer := 1;
	 	ADDR_WIDTH			:	integer := 5;
	 	MAX_PACKET_LENGTH	:	integer := 16
	 	
	);
	port (
		tx_dat      	:	in  std_logic_vector(15 downto 0);
		rx_dat      	:	out std_logic_vector(15 downto 0);
		rx_dav      	:	in  std_logic;
		tx_clk   		:	in  std_logic;
		rx_clk			:	in	std_logic;
		rx_ena      	:	out std_logic;
		rx_eop      	:	out std_logic;
		tx_dav     		:	out std_logic;
		rx_sop			:	out std_logic;
		rx_err			:	out std_logic;
		resetb      	:	in  std_logic;
		tx_ena			:	in	std_logic;
		user_clk		:	out	std_logic;
		tx_adr			:	in	std_logic_vector(7 downto 0);
		rx_adr			:	out	std_logic_vector(7 downto 0);
		tx_cmd_reset	:	in  std_logic;
		tx_cmd_test		:	in	std_logic;
		tx_cmd_sabm		:	in	std_logic;
		rx_cmd_reset	:	out	std_logic;
		rx_cmd_test		:	out	std_logic;
		rx_cmd_ua		:	out	std_logic;
		tx_ns        	:	out std_logic_vector(2 downto 0);
		rx_nr			:	out std_logic_vector(2 downto 0);
		rx_ns			:	out std_logic_vector(2 downto 0);
		rx_cmd_srej		:	out std_logic_vector(6 downto 0);
		cmd_busy		:	out	std_logic;
		tx_sdr      	:	out std_logic_vector(1 downto 0);
		rx_sdr      	:	in	std_logic_vector(1 downto 0)
	);
end entity HDLC;

architecture RTL of HDLC is
	
	constant THRESHOLD			:	integer := 2**ADDR_WIDTH -MAX_PACKET_LENGTH-1;
	--wire  rx_cmd_reset__1 => signal rx_cmd_reset_int and so on ... 
	signal rx_cmd_reset_int_int	:	std_logic;	
	signal tx_cmd_reset_int :	std_logic;
	
	signal rx_cmd_test_int	:	std_logic;
	
	
	
	signal rx_vr			:	std_logic_vector(2 downto 0);
	
	--wire [6:0]  tx_cmd_srej_1, tx_cmd_srej__1;  => tx_cmd_srej, tx_cmd_srej_int
	signal	tx_cmd_srej		:	std_logic_vector(6 downto 0);
	signal	tx_cmd_srej_int	:	std_logic_vector(6 downto 0);
	
	component tx
		generic(HEADER_FIELD : integer := 1;
			    ADDR_WIDTH   : integer := 12;
			    THRESHOLD    : integer := 3072);
		port(tx_dat       : in  std_logic_vector(15 downto 0);
			 clk          : in  std_logic;
			 tx_ena       : in  std_logic;
			 tx_adr       : in  std_logic_vector(7 downto 0);
			 resetb       : in  std_logic;
			 tx_cmd_reset : in  std_logic;
			 tx_cmd_test  : in  std_logic;
			 rx_cmd_reset : in  std_logic;
			 tx_dav       : out std_logic;
			 tx_sdr       : out std_logic_vector(1 downto 0);
			 tx_ns        : out std_logic_vector(2 downto 0);
			 tx_nr        : in  std_logic_vector(2 downto 0);
			 tx_cmd_srej  : in  std_logic_vector(6 downto 0);
			 tx_cmd_sabm  : in  std_logic;
			 tx_cmd_ua    : in  std_logic;
			 cmd_busy     : out std_logic);
	end component tx;
	
	component rx
		generic(HEADER_FIELD : integer := 1;
			    ADDR_WIDTH   : integer := 8);
		port(rx_dat       : out std_logic_vector(15 downto 0);
			 rx_ena       : out std_logic;
			 rx_eop       : out std_logic;
			 rx_sop       : out std_logic;
			 rx_err       : out std_logic;
			 rx_adr       : out std_logic_vector(7 downto 0);
			 rx_cmd_reset : out std_logic;
			 rx_cmd_test  : out std_logic;
			 rx_cmd_ua    : out std_logic;
			 tx_cmd_ua    : out std_logic;
			 rx_cmd_srej  : out std_logic_vector(6 downto 0);
			 tx_cmd_srej  : out std_logic_vector(6 downto 0);
			 rx_vr        : out std_logic_vector(2 downto 0);
			 rx_nr        : out std_logic_vector(2 downto 0);
			 rx_ns        : out std_logic_vector(2 downto 0);
			 clk          : in  std_logic;
			 rx_clk       : in  std_logic;
			 rx_dav       : in  std_logic;
			 rx_sdr_pri   : in  std_logic_vector(1 downto 0);
			 resetb       : in  std_logic;
			 tx_cmd_reset : in  std_logic);
	end component rx;
	
	signal tx_cmd_sabm_int 	: std_logic;
	signal tx_cmd_ua_int 	: std_logic;
	signal tx_cmd_ua 		: std_logic;
	signal tx_cmd_test_int : std_logic;
	signal user_clk_int 	: std_logic;
	--signal active_aux_int : std_logic;
	signal rx_cmd_reset_int : std_logic;
begin
	
	
	rx_inst : component rx
		generic map(HEADER_FIELD => HEADER_FIELD,
			        ADDR_WIDTH   => ADDR_WIDTH)
		port map(rx_dat       => rx_dat,
			     rx_ena       => rx_ena,
			     rx_eop       => rx_eop,
			     rx_sop       => rx_sop,
			     rx_err       => rx_err,
			     rx_adr       => rx_adr,
			     rx_cmd_reset => rx_cmd_reset_int_int,
			     rx_cmd_test  => rx_cmd_test_int,
			     rx_cmd_ua    => rx_cmd_ua,
			     tx_cmd_ua    => tx_cmd_ua,
			     rx_cmd_srej  => rx_cmd_srej,
			     tx_cmd_srej  => tx_cmd_srej,
			     rx_vr        => rx_vr,
			     rx_nr        => rx_nr,
			     rx_ns        => rx_ns,
			     clk		  => tx_clk,
			     rx_clk		  => rx_clk,
			     rx_dav       => rx_dav,
			     rx_sdr_pri   => rx_sdr,
			     resetb       => resetb,
			     tx_cmd_reset => tx_cmd_reset_int);
			     
	tx_inst : component tx
		generic map(HEADER_FIELD => HEADER_FIELD,
			        ADDR_WIDTH   => ADDR_WIDTH,
			        THRESHOLD    => THRESHOLD)
		port map(tx_dat       => tx_dat,
			     clk          => user_clk_int,
			     tx_ena       => tx_ena,
			     tx_adr       => tx_adr,
			     resetb       => resetb,
			     tx_cmd_reset => tx_cmd_reset,
			     tx_cmd_test  => tx_cmd_test_int,
			     rx_cmd_reset => rx_cmd_reset_int_int,
			     tx_dav       => tx_dav,
			     tx_sdr       => tx_sdr,
			     tx_ns        => tx_ns,
			     tx_nr        => rx_vr,
			     tx_cmd_srej  => tx_cmd_srej_int,
			     tx_cmd_sabm  => tx_cmd_sabm_int,
			     tx_cmd_ua    => tx_cmd_ua_int,
			     cmd_busy     => cmd_busy);
	
	rx_cmd_reset_int <= '0' when MASTER /= 0 else rx_cmd_reset_int_int;
	rx_cmd_reset <= rx_cmd_reset_int;
	
	rx_cmd_test <= rx_cmd_test_int when MASTER /= 0 else '0';
	
	tx_cmd_reset_int <= tx_cmd_reset when MASTER /= 0 else '0';
	
	tx_cmd_test_int <= tx_cmd_test when MASTER /= 0 else rx_cmd_test_int;
	
	tx_cmd_sabm_int <= tx_cmd_sabm when MASTER /= 0 else '0';
	
	tx_cmd_ua_int <= '0' when MASTER /= 0 else tx_cmd_ua;
	
	tx_cmd_srej_int <= (others=>'0') when MASTER /= 0 else tx_cmd_srej;
	
	user_clk_int <= tx_clk;
	--active_aux <= active_aux_int;
	user_clk <= user_clk_int;

end architecture RTL;
