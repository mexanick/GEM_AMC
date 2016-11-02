library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SCA_Package.all;

entity eport_driver is
	port (
		--!
		tx_clk				:	in	std_logic;
		rst					:	in	std_logic;
		eport_en			:	in	std_logic;
		
		--! \name Signals to the Elink
		--! \{
		
		rx_ena       		: in std_logic;
		rx_dav       		: out  std_logic;
		rx_sop       		: in std_logic;
		rx_eop       		: in std_logic;
		rx_ns        		: in std_logic_vector(2 downto 0);
		rx_adr       		: in std_logic_vector(7 downto 0);
		rx_dat       		: in std_logic_vector(15 downto 0);
		rx_nr        		: in std_logic_vector(2 downto 0);
		rx_cmd_srej  		: in std_logic_vector(6 downto 0);
		rx_err       		: in std_logic;
		tx_ena       		: out  std_logic;
		tx_dav       		: in std_logic;
		tx_ns        		: in std_logic_vector(2 downto 0);
		tx_adr       		: out  std_logic_vector(7 downto 0);
		tx_dat       		: out  std_logic_vector(15 downto 0);
		tx_cset      		: out  std_logic_vector(3 downto 0);
		--! \}
		
		--! \name Interface with Command Queue or Protocol Layer
		--! \{
		 sca_cmd_data_i		: in payload_t;
		 sca_rpy_data_o     : out  payload_t;
		 sca_cmd_ena_i      : in std_logic;
		 sca_cmd_av_o       : out  std_logic;
		 sca_rpy_ena_i    	: in std_logic;
		 sca_rpy_av_o		: out  std_logic
		 
		--! \}
		 
		 );
			 
end entity eport_driver;

architecture RTL of eport_driver is
	
	
	--! Counter that decides which of thew Command FIFOs will be used to send to the Eport
	--signal cmd_arbiter		:	natural range 0 to SCA_CH_COUNT -1;
	
	--! Last TRansaction Number sent by each channel
	--signal TR_sent	:	byte_t;
	
	
	--signal cmd_rdy_to_tx_driver		:	std_logic := '0';
	signal cmd_data_to_tx_driver	:	payload_t;
	signal tx_driver_counter		:	natural range 0 to 3;
	
	--signal rpy_rdy_from_rx_receiver	:	std_logic;
	--signal rpy_data_from_rx_receiver:	payload_t;
	signal rx_receiver_counter		:	natural range 0 to 3;
	
	

	type state_t is (IDLE, BUSY, BLOCKED);
	signal tx_state,rx_state	:	state_t;
			 
	
	
--	type state_t is (resetState, scanState, startState, stopState, 
--		resetSCAState, connectSCAState, waitresetORconnectState, waitForControllerState
--	);		
----
--	signal state	:	state_t;
--	
	signal tx_driver_running	:	std_logic := '0';
	
	
	
begin
	
	-- At least for now:
	tx_cset <= (others=>'0');
	tx_adr <= (others=>'1');
	
	
				
	sca_cmd_av_o <= '1' when (tx_state=IDLE and sca_cmd_ena_i='0') else '0';
	
	--tx_ena <= '1' when tx_driver_running='1' else '0';-- Test SOL40_SCA 06/05/2015
	
	--! Process that manages the sending of commands to the elink_tx_driver,
	--! then the SCA(e-Port)
	elink_tx_driver : process (tx_clk) is
		-- constant data_high	:	natural := cmd_data_to_tx_driver.data'high; -- Test SOL40_SCA 06/05/2015
		variable cmd_len	:	natural range 0 to 255;
	begin
		if rising_edge(tx_clk) then
			tx_ena <= tx_driver_running;-- Test SOL40_SCA 06/05/2015
			if rst = '1' then
				--cmd_arbiter <= sca_ch_enum'pos(sca_controller);
				tx_state <= BLOCKED;
				tx_dat <= (others=>'0');
			else	
				case tx_state is 
				when IDLE =>
					if eport_en='0' then
						tx_state <= BLOCKED;
						
					elsif sca_cmd_ena_i='1' then
							tx_state <= BUSY;
							cmd_data_to_tx_driver <= sca_cmd_data_i;
							tx_driver_counter <= 0;
							tx_driver_running <= '1';
					end if;
					tx_dat <= (others=>'0');
				when BUSY =>
					if eport_en='0' then
						tx_state <= BLOCKED;
						tx_dat <= (others=>'0');
					elsif tx_dav='1' or tx_driver_running='1' then
						case tx_driver_counter is
--						when 0=> tx_dat <= cmd_data_to_tx_driver.tr & cmd_data_to_tx_driver.ch;
--						when 1=> tx_dat <= cmd_data_to_tx_driver.cmd_or_err & cmd_data_to_tx_driver.len;
--						--31 downto 16 = data0
--						when 2=> tx_dat <= cmd_data_to_tx_driver.data(data_high downto data_high-16+1);
--						--15 downto 0 = data1
--						when 3=> tx_dat <= cmd_data_to_tx_driver.data(data_high-16 downto data_high-2*16+1);
--						when others=> tx_dat <= (others=>'0');
							
						--Ken's aid on the byte order: 06/05/2015
						when 0=> tx_dat <= cmd_data_to_tx_driver.ch & cmd_data_to_tx_driver.tr; 
						when 1=> tx_dat <= cmd_data_to_tx_driver.cmd_or_err & cmd_data_to_tx_driver.len;
						--31 downto 16 = data0
						when 2=> tx_dat <= cmd_data_to_tx_driver.data(7 downto 0) & cmd_data_to_tx_driver.data(15 downto 8);
						--15 downto 0 = data1
						when 3=> tx_dat <= cmd_data_to_tx_driver.data(23 downto 16) & cmd_data_to_tx_driver.data(31 downto 24);
						when others=> tx_dat <= (others=>'0');	
							
						end case;
						
						cmd_len := to_integer(unsigned(cmd_data_to_tx_driver.len));
						if ((tx_driver_counter=1 and cmd_len=0) or (tx_driver_counter =2 and  cmd_len<=2) or (tx_driver_counter =3)) then --  and  cmd_len<32  
							--tx_driver_running <= '0';
							tx_driver_counter <= 0;
							tx_state <= IDLE;
							tx_driver_running <= '0';
						else
							tx_driver_running <= '1';
							tx_driver_counter <= tx_driver_counter + 1;
						end if;
					end if;
				when BLOCKED =>
					if eport_en='1' then
						tx_state <= IDLE;
					end if;
					tx_dat <= (others=>'0');
				end case;	
			end if;	
		end if;
	end process elink_tx_driver;

	
--	rx_state <=  BLOCKED when enable='0' else
--				 BUSY when (rx_ena='1') else
--				 IDLE;
	
	
	--! Process that receives the sca replies through the atlantic bus from the Eport
	elink_rx_receiver : process(tx_clk) is
		--constant data_high	:	natural := rpy_data_from_rx_receiver.data'high;
		
		--variable rpy_from_arb_var		:	std_logic;
	begin
		if rising_edge(tx_clk) then
			if rst='1' then
				rx_state <= BLOCKED;			
			else
				case rx_state is 
				when BLOCKED =>
					sca_rpy_av_o <= '0';
					if eport_en='1' then
						rx_state <= IDLE;
						rx_dav <= '1';
					else
						rx_dav <= '0';
					end if;
				when BUSY =>
					if sca_rpy_ena_i = '1' then
						sca_rpy_av_o <= '0';
						if eport_en='1' then
							rx_state <= IDLE;
							rx_dav <= '1';
						else
							rx_state <= BLOCKED;
							rx_dav <= '0';
						end if;
					else
						rx_dav <= '0';
					end if;
				when IDLE =>
					if rx_ena='1' then
						case rx_receiver_counter is
						--Ken's aid on the byte order: 06/05/2015
						when 0=> 
							sca_rpy_data_o.tr <= rx_dat(7 downto 0);
							sca_rpy_data_o.ch <= rx_dat(15 downto 8);
						when 1=> 
							sca_rpy_data_o.cmd_or_err <= rx_dat(7 downto 0);
							sca_rpy_data_o.len <= rx_dat(15 downto 8);
							--31 downto 16 = data0
						when 2=> 
							sca_rpy_data_o.data(7 downto 0) <= rx_dat(15 downto 8);
							sca_rpy_data_o.data(15 downto 8) <= rx_dat(7 downto 0);
						when 3 =>
							--15 downto 0 = data1
							sca_rpy_data_o.data(23 downto 16) <= rx_dat(15 downto 8);
							sca_rpy_data_o.data(31 downto 24) <= rx_dat(7 downto 0);
							
						end case;
						
						if rx_receiver_counter/=3 and rx_eop='0' then
							rx_receiver_counter <= rx_receiver_counter + 1;
						elsif rx_eop = '1' then
							rx_dav <= '0';
							rx_receiver_counter <= 0;
							rx_state <= BUSY;
							sca_rpy_av_o <= '1';
							--sca_rpy_data_o <= rpy_data_from_rx_receiver;
						else -- rx_eop/='1' then 
							report "SCA MAC Layer - eport_driver : Receiving Packet is too long";
						end if;
						
					end if;
				end case;
			end if;
		end if;
			
	end process elink_rx_receiver;
	
	

end architecture RTL;
