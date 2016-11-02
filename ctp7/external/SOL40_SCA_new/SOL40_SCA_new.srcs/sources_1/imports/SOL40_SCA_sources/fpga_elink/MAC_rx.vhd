library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

--Sandro's comments:
--// missing: rx_ns_o <=#1 rx_ns_i;
--// missing: rx_dat_o <=#1 rx_dat_i;
--// missing: rx_eop_o <=#1 rx_eop_i;
--// missing: rx_ena_o <=#1 rx_ena_i;
--// missing: rx_sop_o <=#1 rx_sop_i;
--// missing: rx_nr_o <=#1 rx_nr_i;
--// missing: header <=#1 header;
--// missing: rx_cmd_ua_o <=#1 rx_cmd_ua_i;
--// missing: rx_cmd_srej_o <=#1 rx_cmd_srej_i;
--// missing: tx_cmd_ua_o <=#1 tx_cmd_ua_i;
--// missing: tx_cmd_srej_o <=#1 tx_cmd_srej_i;
--// missing: rx_cmd_sabm_o <=#1 rx_cmd_sabm_i;
--// missing: rx_cmd_test_o <=#1 rx_cmd_test_i;
--// missing: rx_cmd_reset_o <=#1 rx_cmd_reset_i;
--// missing: phy_dvalid_old_o <=#1 phy_dvalid_old_i;


-- Signals not used:
--rx_dat_i, rx_sop_i, rx_cmd_test_i, cmd_busy, active, rx_cmd_ua_i, rx_cmd_srej_i
--tx_cmd_srej_i, rx_ns_i, tx_cmd_ua_i
--
entity MAC_rx is
	
	generic(
		ADDR_WIDTH	:	integer := 5;
		HEADER_FIELD:	integer	:= 1
	);
	port (
		rx_dat				:	out	std_logic_vector(15 downto 0);
		rx_ena				:	out	std_logic;
		rx_ena_pre			:	out	std_logic;
		rx_eop				:	out	std_logic;
		rx_err				:	out	std_logic;
		rx_vr_o				:	out	std_logic_vector(2 downto 0);
		rx_nr_o				:	out	std_logic_vector(2 downto 0);
		rx_sop				:	out	std_logic;
		rx_adr				:	out	std_logic_vector(7 downto 0);
		clk					:	in	std_logic;
		rx_dav				:	in	std_logic;
		resetb				:	in	std_logic;
		rx_cmd_reset		:	out	std_logic;
		rx_cmd_test			:	out	std_logic;
		phy_data			:	in	std_logic_vector(7 downto 0);
		phy_dvalid			:	in	std_logic;	
		phy_dstrobe			:	in	std_logic;	
		crc_zero			:	in	std_logic;
		rx_cmd_ua			:	out	std_logic;
		rx_cmd_srej			:	out	std_logic_vector(6 downto 0);
		tx_cmd_srej			:	out	std_logic_vector(6 downto 0);
		rx_ns				:	out	std_logic_vector(2 downto 0);
		rx_cmd_sabm			:	out	std_logic;
		
		tx_cmd_ua			:	out	std_logic;
		tx_cmd_reset		:	in	std_logic
	);
end entity MAC_rx;

architecture RTL of MAC_rx is
	
	constant MAX_LENGTH	:	integer := 2**ADDR_WIDTH;
	
	signal fifo_nItems				:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal fifo_nItems_complete		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal fifo_full				:	std_logic;
	signal rx_ns_minus_one			:	std_logic_vector(2 downto 0);
	
	
	signal disconnectb_resetb		:	std_logic;
	
	
	----
	--signal fifo_addr_w_int			: 	std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal fifo_addr_w_int		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	
	signal fifo_addr_r_int 			: 	std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal fifo_addr_w_last 		: 	std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal header 					:	std_logic_vector(7 downto 0);
	signal rx_cmd_reset_int			:	std_logic;
	signal rx_cmd_sabm_int 			:	std_logic;
	signal phy_data_old				:	std_logic_vector(15 downto 0);
	signal phy_bytesel				:	std_logic;
	signal phy_data_lowbyte 		: 	std_logic_vector(7 downto 0);
	signal phy_data_old2 			:	std_logic_vector(15 downto 0);
	
	signal phy_dvalid_old			:	std_logic;
	
	signal packet_length			:	std_logic_vector(15 downto 0); 
	
	signal overflow					:	std_logic;
	
	signal rx_vr_int				:	std_logic_vector(2 downto 0);
	
	signal rx_adr_int				:	std_logic_vector(7 downto 0);
	
	signal rx_ena_pre_int			:	std_logic;
	
	signal rx_eop_int				:	std_logic;
	signal rx_ena_int				:	std_logic;
	
	
	
	
	signal fifo_data_w			:	std_logic_vector(16 downto 0);
	signal fifo_data_r			:	std_logic_vector(16 downto 0);
	signal fifo_addr_w_o		:	std_logic_vector(ADDR_WIDTH-1 downto 0);		
	signal fifo_addr_r		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal fifo_w				:	std_logic;
	
	
	component fifo_mem
		generic(DATA_WIDTH : integer := 4;
			    ADDR_WIDTH : integer := 3);
		port(addr_w, addr_r  : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
			 data_r          : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			 data_w          : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			 w_enable, clk_w : in  std_logic);
	end component fifo_mem;
	
	
	
	
	
	
begin
	
	rx_err <= '0';
	
	fifo_nItems <= std_logic_vector(unsigned(fifo_addr_w_int) - unsigned(fifo_addr_r_int));
	fifo_nItems_complete <= std_logic_vector(unsigned(fifo_addr_w_last) - unsigned(fifo_addr_r_int));
	fifo_full <= '1' when (to_integer(unsigned(fifo_nItems))=MAX_LENGTH-1) else '0';
	
	rx_ns_minus_one <= std_logic_vector(unsigned(header(3 downto 1)) -1 );
	
	
	disconnectb_resetb <= resetb;-- and (not disconnect_i);
	
	sync_process : process (clk, disconnectb_resetb) is
		
		variable rx_cmd_reset_var		:	std_logic;
		variable rx_cmd_sabm_var		:	std_logic;
		variable rx_cmd_ua_var		:	std_logic;
		variable rx_cmd_test_var		:	std_logic;
		variable fifo_addr_w_last_var	:	std_logic_vector(ADDR_WIDTH-1 downto 0);
		variable fifo_addr_w_var	:	std_logic_vector(ADDR_WIDTH-1 downto 0);
		variable rx_vr_var			: 	std_logic_vector(2 downto 0);
		variable tx_cmd_srej_var		:	std_logic_vector(6 downto 0);
		variable rx_cmd_srej_var		:	std_logic_vector(6 downto 0);
		variable packet_length_var	:	std_logic_vector(15 downto 0);
		variable overflow_var			:	std_logic; 
		variable phy_bytesel_var			:	std_logic;
	begin
		if disconnectb_resetb = '0' then
			fifo_addr_w_var := (others=>'0') ;
			phy_dvalid_old <= '0';
			fifo_addr_w_last_var := (others=>'0');
			rx_cmd_reset_var := '0';
			rx_cmd_test_var := '0';
			rx_vr_var := (others=>'0') ;
			rx_cmd_sabm_var := '0';
			tx_cmd_srej_var := (others=>'0');
			tx_cmd_ua <= '0' ;
		elsif rising_edge(clk) then
			if rx_cmd_reset_int = '1' then
				fifo_addr_w_var := (others=>'0') ;
				phy_bytesel_var := '0';
				phy_dvalid_old <= '0' ;
				fifo_addr_w_last_var := (others=>'0');
				phy_data_old <= (others=>'0') ;
				phy_data_lowbyte <= (others=>'0') ;
				phy_data_old2 <= (others=>'0') ;
				overflow_var := '0' ;
				rx_cmd_reset_var := '0';
				rx_cmd_test_var := '0';
				rx_vr_var := (others=>'0');
				rx_cmd_sabm_var := '0';
				tx_cmd_ua <='1' ;
			else
				rx_cmd_reset_var := '0';
				rx_cmd_test_var := '0';
				tx_cmd_srej_var := (others => '0');
				rx_cmd_srej_var :=  (others => '0');
				rx_cmd_sabm_var := '0';
				rx_cmd_ua_var := '0';
				tx_cmd_ua <= rx_cmd_sabm_int ;
				phy_data_old <= phy_data_old  ;
				fifo_addr_w_last_var := fifo_addr_w_last;
				phy_bytesel_var := phy_bytesel;
				fifo_addr_w_var := fifo_addr_w_int ;
				phy_data_lowbyte <= phy_data_lowbyte  ;
				phy_data_old2 <= phy_data_old2  ;
				packet_length_var := packet_length;
				phy_dvalid_old <= phy_dvalid  ;
				overflow_var := overflow;
				rx_vr_var := rx_vr_int;
				
				if (tx_cmd_reset = '1') or (rx_cmd_sabm_int ='1') then 
					rx_vr_var := (others => '0');
				end if;
				
				if (phy_dvalid = '1' ) then
					if (phy_dstrobe = '1') then
						if (phy_bytesel = '1') then 
							if (fifo_full = '1' or  overflow = '1') then
								overflow_var := '1';
							else 
								fifo_addr_w_var := std_logic_vector(unsigned(fifo_addr_w_int) + 1);
								
								-- fifo_addr_w_int <= fifo_addr_w_int + '1' ;
							end if;
							phy_data_old <= phy_data & phy_data_lowbyte ;
							phy_data_old2 <= phy_data_old;
							phy_bytesel_var := '0';
							packet_length_var :=  std_logic_vector(unsigned(packet_length) + 1);
							if (packet_length= (packet_length'range=>'0')) and (HEADER_FIELD /= 0) then -- HEADER
								header <= phy_data ;
							end if;
						else
							phy_data_lowbyte <= phy_data ;
							phy_bytesel_var :='1';
						end if;
					end if;
				else 
				--
					packet_length_var :=(others => '0');
					if (fifo_full='0') then
					 overflow_var := '0';
					end if;
					phy_bytesel_var := '0';
				end if;
				
				
				if ((phy_dvalid='0') and phy_dvalid_old ='1') then 
					if (crc_zero='1') then
						if ((to_integer(unsigned(packet_length)))=2) and (HEADER_FIELD /= 0 ) then
							-- COMMAND FRAME
							fifo_addr_w_var :=fifo_addr_w_last;
							
							
							case phy_data_old2(15 downto 8) is
							when x"8f" =>
								rx_cmd_reset_var :='1';
							when x"2f" =>
								rx_cmd_sabm_var :='1';
							when x"63" =>
								rx_cmd_ua_var :='1';
							when x"e3" =>
								rx_cmd_test_var :='1';
							when others =>
								null;
							end case;
							--if (phy_data_old2_i[15:11] == 5'h0d) rx_cmd_srej_o[2:0] <=#1 phy_data_old2_i[10:8];
						else
							if ((HEADER_FIELD=0) or ((HEADER_FIELD/=0) and (header(0)='0'))) then
								-- INFORMATION FRAME END
								fifo_addr_w_last_var :=  std_logic_vector(unsigned(fifo_addr_w_int)-1);
								fifo_addr_w_var := std_logic_vector(unsigned(fifo_addr_w_int)-1) ;
								-- Receive state variable:
								rx_vr_var := std_logic_vector(unsigned(header(3 downto 1))+1);
								if ( header(3 downto 1) = rx_vr_int) then
									tx_cmd_srej_var :='1' & rx_ns_minus_one & rx_vr_int;
								end if;
	
								rx_nr_o <= header(7 downto 5);
							else -- SREJ FRAME END
								fifo_addr_w_var := fifo_addr_w_last ;
								rx_cmd_srej_var :=  '1' & phy_data_old2(7 downto 5) & phy_data_old2(3 downto 1);
							end if;
						end if;
					else -- CRC FAILED
						fifo_addr_w_var := fifo_addr_w_last ;
					end if;
				end if;
			end if;	
		end if;
		
		
		
		rx_cmd_reset <= rx_cmd_reset_var;
		rx_cmd_reset_int <= rx_cmd_reset_var;
		--
		rx_cmd_sabm <= rx_cmd_sabm_var; 
		rx_cmd_sabm_int <= rx_cmd_sabm_var;
		
		--
		rx_cmd_ua <= rx_cmd_ua_var;
		rx_cmd_test <= rx_cmd_test_var;
		fifo_addr_w_last <= fifo_addr_w_last_var;
		fifo_addr_w_int <= fifo_addr_w_var;
		
		rx_vr_int <= rx_vr_var;
		rx_vr_o <= rx_vr_var;
		
		tx_cmd_srej <= tx_cmd_srej_var;
		rx_cmd_srej <= rx_cmd_srej_var;
		
		packet_length <= packet_length_var;
		overflow <= overflow_var; 
		phy_bytesel <= phy_bytesel_var;
	end process sync_process;
	
	
	combinatorial_logic : process ( fifo_addr_w_last, fifo_full, phy_bytesel, 
		phy_data, phy_data_lowbyte, phy_data_old2, phy_dstrobe, phy_dvalid, 
		phy_dvalid_old, fifo_addr_w_int) is
		variable fifo_w_int			:	std_logic;
		variable fifo_addr_w_var	:	std_logic_vector(ADDR_WIDTH-1 downto 0);
		variable fifo_data_w_var	:	std_logic_vector(16 downto 0);
	begin
		fifo_w_int := '0';
		fifo_addr_w_var := fifo_addr_w_int;
		fifo_data_w_var := '0' & phy_data & phy_data_lowbyte;
		
		if ((phy_dstrobe = '1') and (phy_dvalid = '1') and (fifo_full='0')) then
			if (phy_bytesel = '1') then
				fifo_w_int :='1';
			end if;
		end if;

		if (phy_dvalid='0') and (phy_dvalid_old='1') then
			if not ( (to_integer( unsigned(fifo_addr_w_int)-unsigned(fifo_addr_w_last)) =2) and (HEADER_FIELD/=0)) then
				fifo_addr_w_var := std_logic_vector(unsigned(fifo_addr_w_int)-2);
				fifo_data_w_var := '1' & phy_data_old2;
				fifo_w_int := '1';
			end if;
		end if;
		fifo_w <= fifo_w_int;
		--
		fifo_addr_w_o <= fifo_addr_w_var;
		--
		fifo_data_w <= fifo_data_w_var;
	end process combinatorial_logic;
	
-- FIFO READ INTERFACE	
fifo_read_interface : process (clk, disconnectb_resetb) is
	variable fifo_addr_r_var	:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	variable rx_ena_pre_var	:	std_logic;
	variable rx_sop_var		:	std_logic;
	variable rx_ena_var		:	std_logic;
	variable rx_adr_var		:	std_logic_vector(7 downto 0);
	variable rx_eop_var		:	std_logic;
	variable rx_dat_var		:	std_logic_vector(15 downto 0);
	variable rx_ns_var		:	std_logic_vector(2 downto 0);
begin
	if disconnectb_resetb = '0' then
		fifo_addr_r_var := (others =>'0') ;
		--rx_sop_o <=#1 0;
		--rx_ena_o <=#1 0;
		--rx_adr_o <=#1 0;
		rx_ena_pre_var :='0';
	elsif rising_edge(clk) then
		if rx_cmd_reset_int = '1' then
			fifo_addr_r_var := (others =>'0');
			rx_sop_var := '0';
			rx_ena_var := '0';
			rx_adr_var := (others => '0');
			rx_ena_pre_var := '0';
		else
			rx_adr_var := rx_adr_int;
			rx_ena_var := rx_ena_pre_int;
			fifo_addr_r_var := fifo_addr_r_int;
			rx_ena_pre_var := rx_ena_pre_int;

			rx_sop_var := '0';
			rx_eop_var := fifo_data_r(16) and rx_ena_pre_int;
			
			if (( rx_ena_pre_int='0') and (fifo_nItems_complete /= (fifo_nItems_complete'range => '0')) and (rx_dav = '1')) then
				rx_ena_pre_var := '1';
				rx_dat_var := fifo_data_r(15 downto 0);				
				fifo_addr_r_var := std_logic_vector(unsigned(fifo_addr_r_int) + 1);
				if (HEADER_FIELD /=0) then
					rx_adr_var := fifo_data_r(7 downto 0);
					rx_ns_var := fifo_data_r(11 downto 9);
				else
					rx_sop_var :='1';
					rx_ena_var := '1';
					rx_eop_var := fifo_data_r(16);
				end if;
			end if;
			
			if (rx_eop_int='1' and rx_ena_int='1') then
				rx_ena_var  := '0';
				rx_ena_pre_var :='0';
			end if;
			
			if (rx_ena_pre_int ='1') then
				if (rx_ena_int='0') then
					rx_sop_var := '1';
				end if;
				rx_dat_var := fifo_data_r(15 downto 0);
				if (rx_eop_int='0') then
					fifo_addr_r_var := std_logic_vector(unsigned(fifo_addr_r_int) + 1);
				end if;
			end if;
			
			if (fifo_nItems_complete = (fifo_nItems_complete'range=>'0') ) then
				fifo_addr_r_var :=  fifo_addr_r_int;
				rx_ena_pre_var := '0';
				rx_ena_var := '0';
			end if;
		end if;
	end if;
	
	fifo_addr_r <= fifo_addr_r_var;
	fifo_addr_r_int <=  fifo_addr_r_var;
	--
	rx_ena_pre <= rx_ena_pre_var;
	rx_ena_pre_int	<= rx_ena_pre_var;
	---
	rx_sop <= rx_sop_var;			
	rx_ena <= rx_ena_var;
	--			
	rx_adr <= rx_adr_var;
	rx_adr_int <= rx_adr_var;
	-- 
	rx_eop <= rx_eop_var; 
	rx_eop_int <= rx_eop_var; 
	--
	rx_dat <= rx_dat_var;
	rx_ns <= rx_ns_var;
	--
	rx_ena_int <= rx_ena_var;
	
	
end process fifo_read_interface;

	fifo_mem_inst : component fifo_mem
		generic map(DATA_WIDTH => 17,
			        ADDR_WIDTH => ADDR_WIDTH)
		port map(addr_w   => fifo_addr_w_o,
			     addr_r   => fifo_addr_r,
			     data_r   => fifo_data_r,
			     data_w   => fifo_data_w,
			     w_enable => fifo_w,
			     clk_w    => clk);
	
	
end architecture RTL;


	