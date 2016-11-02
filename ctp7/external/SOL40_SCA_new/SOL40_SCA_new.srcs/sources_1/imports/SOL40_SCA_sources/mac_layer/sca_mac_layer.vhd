library ieee;
use ieee.std_logic_1164.all;
use work.SCA_Package.all;

entity sca_mac_layer is
	port (
		tx_clk : in std_logic;

		rst : in std_logic;
		-- Interface with the Protocol Layer
		sca_cmd_data_i     		:	in  payload_t;
		sca_cmd_ena_i      		:	in  std_logic;
		sca_cmd_rdy_o      		:	out std_logic;
		--
		sca_rpy_data_o     		:	out payload_t;
		sca_rpy_prot_rdy_i      :	in  std_logic;
		send_sca_rpy_o     		:	out std_logic;
		reconnnect_i			:	in	std_logic;
		-------
		sca_ch_state_o			:	out	ch_state_vector_t;
		
		scA_link_state_o		:	out SCA_link_state_t;
		
		
		
		tx_sd :	out std_logic_vector(1 downto 0);
		rx_clk	:	in	std_logic;
		rx_sd 	:	in	std_logic_vector(1 downto 0)
	);
end entity sca_mac_layer;

architecture RTL of sca_mac_layer is
	
		
	
	signal sca_ch_state	:	ch_state_vector_t;
	
	component eport_driver
		port(tx_clk             : in  std_logic;
			 rst                : in  std_logic;
			 eport_en				: in	std_logic;
			 rx_ena             : in  std_logic;
			 rx_dav             : out std_logic;
			 rx_sop             : in  std_logic;
			 rx_eop             : in  std_logic;
			 rx_ns              : in  std_logic_vector(2 downto 0);
			 rx_adr             : in  std_logic_vector(7 downto 0);
			 rx_dat             : in  std_logic_vector(15 downto 0);
			 rx_nr              : in  std_logic_vector(2 downto 0);
			 rx_cmd_srej        : in  std_logic_vector(6 downto 0);
			 rx_err             : in  std_logic;
			 tx_ena             : out std_logic;
			 tx_dav             : in  std_logic;
			 tx_ns              : in  std_logic_vector(2 downto 0);
			 tx_adr             : out std_logic_vector(7 downto 0);
			 tx_dat             : out std_logic_vector(15 downto 0);
			 tx_cset            : out std_logic_vector(3 downto 0);
			 sca_cmd_data_i     : in  payload_t;
			 sca_rpy_data_o     : out payload_t;
			 sca_cmd_ena_i      : in  std_logic;
			 sca_cmd_av_o      : out std_logic;
			 sca_rpy_ena_i      : in  std_logic;
			 sca_rpy_av_o     : out std_logic);
	end component eport_driver;
	
	
	component fpga_elink
		generic(MASTER            : integer := 1;
			    HEADER_FIELD      : integer := 1;
			    ADDR_WIDTH        : integer := 5;
			    MAX_PACKET_LENGTH : integer := 16);
		port(reset        : in  std_logic;
			 user_clk     : out std_logic;
			 cmd_busy     : out std_logic;
			 rx_ena       : out std_logic;
			 rx_dav       : in  std_logic;
			 rx_sop       : out std_logic;
			 rx_eop       : out std_logic;
			 rx_cmd_test  : out std_logic;
			 rx_cmd_reset : out std_logic;
			 rx_cmd_ua    : out std_logic;
			 rx_ns        : out std_logic_vector(2 downto 0);
			 rx_adr       : out std_logic_vector(7 downto 0);
			 rx_dat       : out std_logic_vector(15 downto 0);
			 rx_nr        : out std_logic_vector(2 downto 0);
			 rx_cmd_srej  : out std_logic_vector(6 downto 0);
			 rx_err       : out std_logic;
			 tx_ena       : in  std_logic;
			 tx_dav       : out std_logic;
			 tx_cmd_test  : in  std_logic;
			 tx_cmd_reset : in  std_logic;
			 tx_cmd_sabm  : in  std_logic;
			 tx_ns        : out std_logic_vector(2 downto 0);
			 tx_adr       : in  std_logic_vector(7 downto 0);
			 tx_dat       : in  std_logic_vector(15 downto 0);
			 tx_cset      : in  std_logic_vector(3 downto 0);
			 tx_clk       : in  std_logic;
			 tx_sd        : out std_logic_vector(1 downto 0);
			 rx_clk       : in  std_logic;
			 rx_sd        : in  std_logic_vector(1 downto 0));
	end component fpga_elink;


	signal cmd_busy : std_logic;
	signal rx_ena : std_logic;
	signal rx_dav : std_logic;
	signal rx_sop : std_logic;
	signal rx_eop : std_logic;
	signal rx_cmd_test : std_logic;
	signal rx_cmd_reset : std_logic;
	signal rx_cmd_ua : std_logic;
	signal rx_ns : std_logic_vector(2 downto 0);
	signal rx_adr : std_logic_vector(7 downto 0);
	signal rx_dat : std_logic_vector(15 downto 0);
	signal rx_nr : std_logic_vector(2 downto 0);
	signal rx_cmd_srej : std_logic_vector(6 downto 0);
	signal rx_err : std_logic;
	signal tx_ena : std_logic;
	signal tx_dav : std_logic;
	signal tx_cmd_test : std_logic;
	signal tx_cmd_reset : std_logic;
	signal tx_cmd_sabm : std_logic;
	signal tx_ns : std_logic_vector(2 downto 0);
	signal tx_adr : std_logic_vector(7 downto 0);
	signal tx_dat : std_logic_vector(15 downto 0);
	signal tx_cset : std_logic_vector(3 downto 0);
	
	signal SCA_link_state	:	SCA_link_state_t;
	
	constant time_out		:	natural := (4000 ns/25 ns );
	signal timer			:	natural range 0 to time_out;
	
	signal sca_cmd_av	:	std_logic;
	signal enable : std_logic;
	
	signal resetb	:std_logic;
	
--component HDLC_ken
--	generic(
--		MASTER					:	integer :=0;
--		HEADER_FIELD			:	integer	:=1;
--		ADDR_WIDTH				:	integer :=5;
--		MAX_PACKET_LENGTH		:	integer	:=16;
--		THRESHOLD				:	integer:= 2**5 -16
--	);
--	port(
--		tx_dat					:	in	std_logic_vector(15 downto 0);
--		rx_dat					:	out	std_logic_vector(15 downto 0);
--		rx_dav					:	in	std_logic;
--		user_clk_aux			:	in	std_logic;
--		rxClock40				:	in	std_logic;
--		txClock40				:	in	std_logic;
--		rx_ena					:	out	std_logic;
--		rx_eop					:	out	std_logic;
--		tx_dav					:	out	std_logic;
--		rx_sop					:	out	std_logic;
--		rx_err					:	out	std_logic;
--		resetb					:	in	std_logic;
--		tx_ena					:	in	std_logic;
--		disable_aux				:	in	std_logic;
--		user_clk				:	out	std_logic;
--		tx_adr					:	in	std_logic_vector(7 downto 0);
--		rx_adr					:	out	std_logic_vector(7 downto 0);
--		tx_cmd_reset			:	in	std_logic;
--		tx_cmd_test				:	in	std_logic;
--		tx_cmd_sabm				:	in	std_logic;
--		rx_cmd_reset			:	out	std_logic;
--		rx_cmd_test				:	out	std_logic;
--		rx_cmd_ua				:	out	std_logic;
--		tx_ns					:	out	std_logic_vector(2 downto 0);
--		rx_nr					:	out	std_logic_vector(2 downto 0);
--		rx_ns					:	out	std_logic_vector(2 downto 0);
--		rx_cmd_srej				:	out	std_logic_vector(6 downto 0);
--		cmd_busy				:	out	std_logic;
--		tx_sdr					:	out	std_logic_vector(1 downto 0);
--		rx_sdr					:	in	std_logic_vector(1 downto 0);
--		rx_sdr_aux				:	in	std_logic_vector(1 downto 0);
--		active_aux				:	out	std_logic
--);
--end component HDLC_ken;
--	
	
begin
	
	fpga_elink_inst : fpga_elink
		generic map(
			MASTER            => 1,
			HEADER_FIELD      => 1,
			ADDR_WIDTH        => 5,
			MAX_PACKET_LENGTH => 16
		)
		port map(
			reset        => rst,
			user_clk     => open,
			cmd_busy     => cmd_busy,
			rx_ena       => rx_ena,
			rx_dav       => rx_dav,
			rx_sop       => rx_sop,
			rx_eop       => rx_eop,
			rx_cmd_test  => rx_cmd_test,
			rx_cmd_reset => rx_cmd_reset,
			rx_cmd_ua    => rx_cmd_ua,
			rx_ns        => rx_ns,
			rx_adr       => rx_adr,
			rx_dat       => rx_dat,
			rx_nr        => rx_nr,
			rx_cmd_srej  => rx_cmd_srej,
			rx_err       => rx_err,
			tx_ena       => tx_ena,
			tx_dav       => tx_dav,
			tx_cmd_test  => tx_cmd_test,
			tx_cmd_reset => tx_cmd_reset,
			tx_cmd_sabm  => tx_cmd_sabm,
			tx_ns        => tx_ns,
			tx_adr       => tx_adr,
			tx_dat       => tx_dat,
			tx_cset      => tx_cset,
			tx_clk       => tx_clk,
			tx_sd        => tx_sd,
			rx_clk       => rx_clk,
			rx_sd        => rx_sd
		);
	
--	sandro_ken_eport : HDLC_ken
--		generic map(
--			MASTER            => 1,
--			HEADER_FIELD      => 1,
--			ADDR_WIDTH        => 5,
--			MAX_PACKET_LENGTH => 16
--		)
--		port map(
--			tx_dat       => tx_dat,
--			rx_dat       => rx_dat,
--			rx_dav       => rx_dav,
--			user_clk_aux => '0',
--			rxClock40    => rx_clk,
--			txClock40    => tx_clk,
--			rx_ena       => rx_ena,
--			rx_eop       => rx_eop,
--			tx_dav       => tx_dav,
--			rx_sop       => rx_sop,
--			rx_err       => rx_err,
--			resetb       => resetb,
--			tx_ena       => tx_ena,
--			disable_aux  => '1',
--			user_clk     => open,
--			tx_adr       => tx_adr,
--			rx_adr       => rx_adr,
--			tx_cmd_reset => tx_cmd_reset,
--			tx_cmd_test  => tx_cmd_test,
--			tx_cmd_sabm  => tx_cmd_sabm,
--			rx_cmd_reset => rx_cmd_reset,
--			rx_cmd_test  => rx_cmd_test,
--			rx_cmd_ua    => rx_cmd_ua,
--			tx_ns        => tx_ns,
--			rx_nr        => rx_nr,
--			rx_ns        => rx_ns,
--			rx_cmd_srej  => rx_cmd_srej,
--			cmd_busy     => cmd_busy,
--			tx_sdr       => tx_sd,
--			rx_sdr       => rx_sd,
--			rx_sdr_aux   => "00",
--			active_aux   => open
--		);
	
	resetb <= not rst;
	
			     
	eport_driver_inst : eport_driver
		port map(tx_clk             => tx_clk,
			     rst                => rst,
			     eport_en				=> enable,
			     rx_ena             => rx_ena,
			     rx_dav             => rx_dav,
			     rx_sop             => rx_sop,
			     rx_eop             => rx_eop,
			     rx_ns              => rx_ns,
			     rx_adr             => rx_adr,
			     rx_dat             => rx_dat,
			     rx_nr              => rx_nr,
			     rx_cmd_srej        => rx_cmd_srej,
			     rx_err             => rx_err,
			     tx_ena             => tx_ena,
			     tx_dav             => tx_dav,
			     tx_ns              => tx_ns,
			     tx_adr             => tx_adr,
			     tx_dat             => tx_dat,
			     tx_cset            => tx_cset,
			     sca_cmd_data_i     => sca_cmd_data_i,
			     sca_rpy_data_o     => sca_rpy_data_o,
			     sca_cmd_ena_i      => sca_cmd_ena_i,
			     sca_cmd_av_o      => sca_cmd_av,
			     sca_rpy_ena_i      => sca_rpy_prot_rdy_i,
			     sca_rpy_av_o     => send_sca_rpy_o);
			     
			     
	control : process (tx_clk) is
	begin
		if rising_edge(tx_clk) then
			if rst = '1' then
				SCA_link_state <= RESET;
				for i in 0 to CH_BY_SCA_COUNT-1 loop
					sca_ch_state(i).busy <= '0';
					sca_ch_state(i).last_tr_sent <= (others=>'0');
				end loop;
				tx_cmd_reset <= '0';
				tx_cmd_sabm <= '0';
				tx_cmd_test <= '0';
				timer <= 0;
			elsif reconnnect_i='1' then
				SCA_link_state <= IDLE;
				for i in 0 to CH_BY_SCA_COUNT-1 loop
					sca_ch_state(i).busy <= '0';
					sca_ch_state(i).last_tr_sent <= (others=>'0');
				end loop;
				tx_cmd_reset <= '0';
				tx_cmd_sabm <= '0';
				tx_cmd_test <= '0';
				timer <= 0;
			else
				case SCA_link_state is 
				when RESET =>
					if cmd_busy = '0' then
						tx_cmd_reset <= '1';
						SCA_link_state <= IDLE;
					end if;
				when IDLE =>
					tx_cmd_reset <= '0';
					if cmd_busy = '0' then
						tx_cmd_test <= '1';
						SCA_link_state <= TESTING;
					end if;
					timer <= 0;
				when CONNECTING =>
					--\TODO instantiate Timer counter and put logic associated her
					-- so the SCA MAC Layer knows when a link is unresponsive and FAILED
					if rx_cmd_ua = '1' then
						SCA_link_state <= READY;
						--tx_cmd_test <= '1';
						timer <= 0;
						tx_cmd_sabm <= '0';
					else
						SCA_link_state <= CONNECTING;
						if timer = time_out and cmd_busy = '0' then
							tx_cmd_sabm <= '1';
							timer <= 0;
						elsif timer < time_out then
							tx_cmd_sabm <= '0';
							timer <= timer +1;
						end if;
					end if;
				when TESTING =>
					
					--\TODO instantiate Timer counter and put logic associated her
					-- so the SCA MAC Layer knows when a link is unresponsive and FAILED
					if rx_cmd_test = '1' then
						SCA_link_state <= CONNECTING;
						timer <= 0;
						tx_cmd_test <= '0';
						tx_cmd_sabm <= '1';
					else
						SCA_link_state <= TESTING;
						if timer = time_out and  cmd_busy = '0' then
							tx_cmd_test <= '1';
							timer <= 0;
						elsif timer < time_out then
							timer <= timer +1;
							tx_cmd_test <= '0';
						end if;
					end if;
				when READY =>
					tx_cmd_reset <= '0';
					tx_cmd_sabm <= '0';
					tx_cmd_test <= tx_test;--'0';
					SCA_link_state <= READY;
				when FAILED =>
					SCA_link_state <= FAILED;
					tx_cmd_reset <= '0';
					tx_cmd_sabm <= '0';
					tx_cmd_test <= '0';
				end case;
				
				
			end if;
		end if;
	end process control;
	
	enable <= '1' when (SCA_link_state=READY) else '0';
	
	sca_cmd_rdy_o <= sca_cmd_av when (SCA_link_state=READY) else '0';
					
	sca_ch_state_o <= sca_ch_state;
	
	scA_link_state_o <= SCA_link_state;

end architecture RTL;
