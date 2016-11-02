--!----------------------------------------------
--!  
--! 	Hamming encoder decoder in Vhdl
--! 	Based on the work by Sandro Bonacini
--! 
--!		@author Cairo Caplan, CBPF
--!
--!-------------------------------------------------------------------------------------

-- Original Comments:
-- // missing: tx_ena_old_o <=#1 tx_ena_old_i;
--
--Problems:
--
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAC_tx is
	generic(
		ADDR_WIDTH			:	integer := 5;
		THRESHOLD			:	integer := 6;
		HEADER_FIELD		:	integer	:= 1
	);
	

	port (
		clk					:	in	std_logic;
		resetb				:	in	std_logic;
		---backend side:
		tx_dat				:	in	std_logic_vector(15 downto 0);
		tx_ena				:	in	std_logic;
		tx_dav				:	out	std_logic;
		tx_adr				:	in	std_logic_vector(7 downto 0);
		tx_nr				:	in	std_logic_vector(2 downto 0);
		tx_ns				:	out	std_logic_vector(2 downto 0);
		tx_cmd_srej			:	in	std_logic_vector(6 downto 0);
		tx_cmd_reset		:	in	std_logic;
		tx_cmd_test			:	in	std_logic;
		--phy side:
		--phy_bytesel			:	out	std_logic;
		phy_dvalid			:	out	std_logic;
		phy_tx_data			:	out	std_logic_vector(7 downto 0);
		phy_dstrobe			:	in	std_logic;
		-------------------------------------
		crc					:	in	std_logic_vector(15 downto 0);
		crc_strobe			:	out	std_logic;
		tx_cmd_sabm			:	in	std_logic;
		tx_cmd_ua			:	in	std_logic;
		cmd_busy			:	out	std_logic;
		rx_cmd_reset		:	in	std_logic
	);
end entity MAC_tx;



architecture RTL of MAC_tx is
	

	constant IDLE		:	integer	:= 0;
	constant START		:	integer	:= 1;
	constant DATA		:	integer	:= 2;
	constant END_state	:	integer	:= 3;
	
	signal resetb_rx_cmd_resetb	:std_logic;
	
	signal fifo_nItems			:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	
	signal tx_ena_old		:	std_logic_vector(1 downto 0);
	signal tx_dat_old		:	std_logic_vector(15 downto 0);
	signal overflow			:	std_logic;	
	signal fifo_addr_w_last_int	:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal state_int			:	std_logic_vector(1 downto 0);
	signal issue_cmd_int		:	std_logic_vector(11 downto 0);
	signal cmd_in_progress_int	:	std_logic;
	
	signal fifo_addr_w_int		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal fifo_addr_r_int		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
	
	signal tx_ns_int			:	std_logic_vector(2 downto 0);
	signal phy_dvalid_int		:	std_logic;
	signal phy_bytesel_int		:	std_logic;
	
	
	
	signal fifo_data_w			:	std_logic_vector(16 downto 0);
	signal fifo_data_r			:	std_logic_vector(16 downto 0);
	signal fifo_addr_w_o		:	std_logic_vector(ADDR_WIDTH-1 downto 0);		
	signal fifo_addr_r_o		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
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
	
	cmd_busy <=  issue_cmd_int(0);
	resetb_rx_cmd_resetb <= resetb and ( not rx_cmd_reset);
	--Get the number of free positions available in the fifo
	fifo_nItems <= std_logic_vector(unsigned(fifo_addr_w_int) - unsigned(fifo_addr_r_int));
	
	
	
	synchronous_process : process (clk, resetb_rx_cmd_resetb) is
		
		variable fifo_addr_w_var			:	std_logic_vector(ADDR_WIDTH-1 downto 0);
		variable tx_ena_old_var			:	std_logic_vector(1 downto 0);
		variable tx_dat_old_var			:	std_logic_vector(15 downto 0);	
		variable tx_ns_var				:	std_logic_vector(2 downto 0);
		variable overflow_var				:	std_logic;
		--variable fifo_addr_w_last_o_int		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
		

	begin
		
		--If resetting
		if resetb_rx_cmd_resetb = '0' then
			fifo_addr_w_var := (others=>'0');
			tx_ena_old_var := (others=>'0');
			tx_dat_old_var := (others=>'0');
			tx_ns_var := (others=>'0');
			overflow_var := '0';
		elsif rising_edge(clk) then
			tx_ns_var := tx_ns_int;
			tx_dat_old_var := tx_dat_old;
			fifo_addr_w_var := fifo_addr_w_int;
			overflow_var := overflow;
			tx_ena_old_var := tx_ena_old(0) & tx_ena;
			
			--If tx_ena stands high and
			if ( ((tx_ena='1') or (tx_ena_old(0)='1' )) and (HEADER_FIELD/=0)) or ((tx_ena='1') and (HEADER_FIELD=0)) then
				tx_dat_old_var := tx_dat;
				if ((fifo_nItems /= (fifo_nItems'range=>'1')) and (overflow='0')) then 
					fifo_addr_w_var := std_logic_vector(unsigned(fifo_addr_w_int) + 1);
				else
					overflow_var := '1';
					fifo_addr_w_var := fifo_addr_w_last_int;
				end if;
			end if;

			-- if tx_ena is being activated
			if ((tx_ena='0') and (tx_ena_old(0)='1')) then
				tx_ns_var := std_logic_vector(unsigned(tx_ns_int) + 1);
			end if;
			if (tx_cmd_reset = '1' or tx_cmd_sabm = '1') then 
				tx_ns_var := (others=>'0');
			end if;

			if (tx_ena_old(0)='0') then
				fifo_addr_w_last_int <= fifo_addr_w_int;
			end if;


			if ((tx_ena='0') and (fifo_nItems /= (fifo_nItems'range=>'1'))) then
				overflow_var := '0';
			end if;

		end if;
			
		fifo_addr_w_o <= fifo_addr_w_var;
		fifo_addr_w_int <= fifo_addr_w_var;
		--
		tx_ena_old <= tx_ena_old_var;
		tx_dat_old <= tx_dat_old_var;
		--
		tx_ns <= tx_ns_var;
		tx_ns_int <= tx_ns_var;
		--
		overflow <= overflow_var;
		--fifo_addr_w_last_int <= fifo_addr_w_last_o_int;
		
	end process synchronous_process;
	
	
	
	
	tx_dav <= '0' when ((to_integer(unsigned(fifo_nItems)) >= THRESHOLD) or (tx_ena='1') or (tx_ena_old(0)='1')
			or (tx_ena_old(1)='1' and (HEADER_FIELD/=0)))
			else '1'; 
	
	
	
	state_process : process (clk, resetb_rx_cmd_resetb) is
		variable fifo_addr_r_var		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
		variable phy_bytesel_var		:	std_logic;
		variable phy_dvalid_var			:	std_logic;
		variable state_var				:	std_logic_vector(1 downto 0);
		variable issue_cmd_var			:	std_logic_vector(11 downto 0);
		variable cmd_in_progress_var	:	std_logic;
	begin
		if resetb_rx_cmd_resetb = '0' then
			fifo_addr_r_var := (others=>'0');
			phy_bytesel_var := '0';
			phy_dvalid_var := '0';
			state_var := (others=>'0');
			issue_cmd_var	:= (others=>'0');
		elsif rising_edge(clk) then
			state_var := state_int;
			phy_dvalid_var := phy_dvalid_int;
			phy_bytesel_var := phy_bytesel_int;
			fifo_addr_r_var := fifo_addr_r_int;
			issue_cmd_var := issue_cmd_int;
			cmd_in_progress_var := cmd_in_progress_int;
			
			if (issue_cmd_int = (issue_cmd_int'range=>'0') ) then
				if (tx_cmd_ua = '1' and HEADER_FIELD /= 0) then 
					issue_cmd_var := x"063"; end if;
				if ((tx_cmd_srej /= (tx_cmd_srej'range=>'0')) and HEADER_FIELD /= 0) then 
					issue_cmd_var := tx_cmd_srej & '0' & x"d"; end if;
				if (tx_cmd_sabm = '1' and HEADER_FIELD /= 0) then 
					issue_cmd_var := x"02f"; end if;
				if (tx_cmd_test = '1' and HEADER_FIELD /= 0) then
					issue_cmd_var :=  x"0e3"; end if;
				if (tx_cmd_reset = '1' and HEADER_FIELD /= 0) then
					issue_cmd_var := x"08f"; end if;
			end if;
		
		
			if ((phy_dstrobe ='1') and (phy_dvalid_int='1')) then
				if (phy_bytesel_int = '1') then
					phy_bytesel_var := '0';
				else
					phy_bytesel_var := '1';
				end if;
			end if;
			--if on IDLE state
			case to_integer(unsigned(state_int)) is 
				when IDLE =>
					phy_dvalid_var := '0';
					if (phy_dvalid_int='0') and 
					((fifo_nItems /= (fifo_nItems'range => '0')) or (issue_cmd_int /= (issue_cmd_int'range =>'0'))) then
						cmd_in_progress_var := issue_cmd_int(0);
						phy_dvalid_var := '1';
						state_var := std_logic_vector( to_unsigned( START, state_var'length ));
					end if;
				when START=>
					phy_dvalid_var := '1';
					if (phy_dstrobe='1') then
						if (phy_bytesel_int='1') then
							state_var :=  std_logic_vector( to_unsigned( DATA, state_var'length )); 
							if (cmd_in_progress_int='0') then
								fifo_addr_r_var := std_logic_vector(unsigned(fifo_addr_r_int) + 1);
							else
								if (issue_cmd_int(11 downto 8)="0000") then
									state_var := std_logic_vector( to_unsigned( END_state, state_var'length )); 
								end if;
							end	if;						
						end if;
					end if;
				when DATA=>
					phy_dvalid_var := '1';
					if (phy_dstrobe='1') then
						if (phy_bytesel_int='1') then
							if (cmd_in_progress_int='0') then
								fifo_addr_r_var := std_logic_vector(unsigned(fifo_addr_r_int) + 1);
							else 
								state_var :=  std_logic_vector( to_unsigned(END_state, state_var'length ));
							end if;
						end if;
					end if;

					if ((cmd_in_progress_int='0') and ((fifo_data_r(16)='1') or (fifo_nItems=(fifo_nItems'range=>'0')))) then
						state_var := std_logic_vector( to_unsigned(END_state, state_var'length ));
					end	if;
				when END_state =>
					if (phy_dstrobe='1') then
						if (phy_bytesel_int='1') then
							state_var := std_logic_vector( to_unsigned(IDLE, state_var'length ));
							if (cmd_in_progress_int='1') then
								cmd_in_progress_var := '0';
								issue_cmd_var := (others=>'0');
							end if;
						end if;
					end if;
				when others=>
					null;
			end case;
		end if;
		
		fifo_addr_r_o <= fifo_addr_r_var; 
		fifo_addr_r_int <= fifo_addr_r_var;
		--
		--phy_bytesel <= phy_bytesel_var;
		phy_bytesel_int <= phy_bytesel_var;
		--
		phy_dvalid <= phy_dvalid_var;
		phy_dvalid_int <= phy_dvalid_var;
		--
		state_int	<= state_var;
		--
		issue_cmd_int <= issue_cmd_var;
		
		--
		cmd_in_progress_int <= cmd_in_progress_var;
		
	end process state_process;
	
	
	
	
	combinational_logic : process (cmd_in_progress_int, crc,
		fifo_data_r, 
		issue_cmd_int,
		 phy_bytesel_int, phy_dstrobe, phy_dvalid_int, state_int, tx_adr,
		  tx_dat, tx_dat_old, tx_ena, tx_ena_old(0), tx_nr, tx_ns_int
	) is
		variable phy_tx_data16	:	std_logic_vector(15 downto 0);
		variable fifo_w_int		:	std_logic;
		variable fifo_data_w_int	:	std_logic_vector(16 downto 0);
	begin
		case to_integer(unsigned(state_int)) is
		when START =>
			if HEADER_FIELD/=0 then
				phy_tx_data16 := tx_nr & '0' & fifo_data_r(11 downto 9) & '0' & fifo_data_r(7 downto 0);
				if cmd_in_progress_int='1' then
					phy_tx_data16 :=  issue_cmd_int(7 downto 0) & x"ff";
				end if;
			else
				phy_tx_data16 := fifo_data_r(15 downto 0);
			end if;
		when DATA => 
			phy_tx_data16 :=  fifo_data_r(15 downto 0);
			if (cmd_in_progress_int='1') then 
				phy_tx_data16(15 downto 8) := (others=>'0');
				phy_tx_data16(7 downto 0) := issue_cmd_int(10 downto 8) & '1' & issue_cmd_int(7 downto 5) & '1';
			end if;
		when END_state =>
			phy_tx_data16 := crc;
		when others =>
			phy_tx_data16 := fifo_data_r(15 downto 0);
		end case;
		
		if phy_bytesel_int= '1' then
			phy_tx_data <= phy_tx_data16(15 downto 8);
		else
			phy_tx_data <= phy_tx_data16(7 downto 0);
		end if;
		
		if to_integer(unsigned(state_int)) /=END_state then
			crc_strobe <=  phy_dstrobe and phy_dvalid_int and '1';
		else
			crc_strobe <=  phy_dstrobe and phy_dvalid_int and '0';
		end if;
		
		fifo_w_int :='0';
		fifo_data_w_int := '0' & tx_dat_old; -- fifo_data_w = tx_dat_old_i;
		if (HEADER_FIELD/=0) then
			if tx_ena='1' and ( tx_ena_old(0)='0') then
			  fifo_data_w_int(7 downto 0) := tx_adr;
			  fifo_data_w_int(8) := '0';
			  fifo_data_w_int(11 downto 9) := tx_ns_int;
			  fifo_data_w_int(16 downto 12) := "10000";
				--fifo_data_w_int := '1' & "0000" & tx_ns_int & '0' & tx_adr;
				fifo_w_int := '1';
			end if;
			if tx_ena_old(0)='1' then
				fifo_w_int :='1';
			end if;
		else
			if tx_ena='1' then
				fifo_data_w_int := (not tx_ena_old(0)) & tx_dat;
				fifo_w_int := '1';
			end if;
		end if;
		
		 fifo_w <= fifo_w_int;
		 --
		 fifo_data_w <= fifo_data_w_int;
		
		
	end process combinational_logic;
	
	
	
	fifo_mem_inst : component fifo_mem
		generic map(DATA_WIDTH => 17,
			        ADDR_WIDTH => ADDR_WIDTH)
		port map(addr_w   => fifo_addr_w_o,
			     addr_r   => fifo_addr_r_o,
			     data_r   => fifo_data_r,
			     data_w   => fifo_data_w,
			     w_enable => fifo_w,
			     clk_w    => clk);
	

end architecture RTL;

