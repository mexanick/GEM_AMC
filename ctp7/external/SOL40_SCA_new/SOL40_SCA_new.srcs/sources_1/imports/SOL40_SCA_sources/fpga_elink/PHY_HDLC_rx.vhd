
--Original comments:
--
--// missing: rx_dstrobe_o <=#1 rx_dstrobe_i;
--
--Problems:
-- signals not used: rx_dstrobe_i
--



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PHY_HDLC_rx is
	port (
			resetb		:	in	std_logic;
			--optical link side:
			rx_clk		:	in	std_logic;
			rx_sdr		:	in	std_logic_vector(1 downto 0);
			--backend side:
			tx_clk		:	in	std_logic;
			rx_data		:	out	std_logic_vector(7 downto 0);
			rx_dvalid	:	out std_logic;
			rx_dstrobe	:	out	std_logic		
	);
end entity PHY_HDLC_rx;

architecture RTL of PHY_HDLC_rx is
	
	signal	rx_dvalid_int	:	std_logic;
	signal	rx_data_int		:	std_logic_vector(7 downto 0);
	signal	rx_reg_int		:	std_logic_vector(8 downto 0);
	signal	ones_count_int	:	std_logic_vector(2 downto 0);
	signal	bit_count_int	:	std_logic_vector(3 downto 0);
	signal	start_int		:	std_logic;
	
	signal rx_sdr_buf1,rx_sdr_buf2,rx_sdr_sync	:std_logic_vector(1 downto 0);
begin
	
	phy_hdlc_rx : process (tx_clk, resetb) is
		variable rx_reg_var		:	std_logic_vector(8 downto 0);
		variable ones_count_var	:	std_logic_vector(2 downto 0);
		variable rx_data_var	:	std_logic_vector(7 downto 0);
		variable bit_count_var	:	std_logic_vector(3 downto 0);
		variable rx_dvalid_var	:	std_logic;
		variable rx_dstrobe_var	:	std_logic;
		variable start_var		:	std_logic;
	begin
		if resetb = '0' then
--			//rx_reg_o_int := 0;
--			//ones_count_o_int := 0;
--			//bit_count_o_int := 0;
--			//rx_dvalid_o_int := 0;
--			//rx_dstrobe_o_int := 0;
--			//start_o_int := 0;
--			//rx_dvalid_o_int := 0;
--			//rx_data_o_int := 0;
		elsif rising_edge(tx_clk) then
			rx_data_var := rx_data_int;
			start_var := start_int;
			rx_dvalid_var := rx_dvalid_int;
			bit_count_var := bit_count_int;
			ones_count_var := ones_count_int;
			rx_reg_var := rx_reg_int;
			rx_dstrobe_var := '0';
			
			if (rx_dvalid_int='1') then
				start_var := '0';
			end if;
			rx_reg_var := rx_sdr_sync(0) & rx_sdr_sync(1) & rx_reg_int(8 downto 2);
			bit_count_var := std_logic_vector(unsigned(bit_count_int) + 2);
			if ((to_integer(unsigned(bit_count_int))=8) and rx_dvalid_int='1') then
				rx_data_var := rx_reg_int(8 downto 1);
				bit_count_var :=  std_logic_vector(to_unsigned( 2 ,bit_count_var'length));
				rx_dstrobe_var := '1';
			end if;
			if ((to_integer(unsigned(bit_count_int))=9) and (rx_dvalid_int='1')) then
				rx_data_var := rx_reg_int(7 downto 0);
				bit_count_var :=  std_logic_vector(to_unsigned( 3 ,bit_count_var'length));
				rx_dstrobe_var := '1';
			end if;


			if ((to_integer(unsigned(ones_count_int))=4) and (rx_sdr_sync(0)='0') and (rx_sdr_sync(1)='1')) then
				rx_reg_var := rx_sdr_sync(1) & rx_reg_int(8 downto 1);
				bit_count_var := std_logic_vector(unsigned(bit_count_int) + 1);
				if (to_integer(unsigned(bit_count_int))=8) then
					bit_count_var := std_logic_vector(to_unsigned( 1 ,bit_count_var'length));
					rx_data_var := rx_reg_int(8 downto 1);
					rx_dstrobe_var := '1';
				end if;
				if (to_integer(unsigned(bit_count_int))=9) then
					bit_count_var := std_logic_vector(to_unsigned( 2 ,bit_count_var'length));
					rx_data_var := rx_reg_int(7 downto 0);
					rx_dstrobe_var := '1';
				end if;
			end if;

			if ((to_integer(unsigned(ones_count_int))=5) and (rx_sdr_sync(1)='0')) then
				rx_reg_var := rx_sdr_sync(0) & rx_reg_int(8 downto 1);
				bit_count_var :=  std_logic_vector(unsigned(bit_count_int) + 1);
				if (to_integer(unsigned(bit_count_int))=8) then
					bit_count_var := std_logic_vector(to_unsigned( 1 ,bit_count_var'length));
					rx_data_var := rx_reg_int(8 downto 1);
					rx_dstrobe_var := '1';
				end if;
				if (to_integer(unsigned(bit_count_int))=9) then
					bit_count_var := std_logic_vector(to_unsigned( 2 ,bit_count_var'length));
					rx_data_var := rx_reg_int(7 downto 0);
					rx_dstrobe_var := '1';
				end if;
			end if;
			
			if (rx_sdr_sync(0)='1' and rx_sdr_sync(1)='1') then
				if (to_integer(unsigned(ones_count_int))<6) then
					ones_count_var := std_logic_vector(unsigned(ones_count_int) + 2);
				end if;
				if (to_integer(unsigned(ones_count_int))=6) then 
					ones_count_var := std_logic_vector(to_unsigned( 7 , ones_count_var'length));
				end if;
			else
				if (start_int='1')then
					rx_dvalid_var := '1';
				end if;
				if (rx_sdr_sync(0)='0') then 
					ones_count_var := std_logic_vector(to_unsigned( 0 , ones_count_var'length));
				else
					ones_count_var := std_logic_vector(to_unsigned( 1 , ones_count_var'length));
				end if;
			end if;
		
			
			
			if (to_integer(unsigned(ones_count_int))=5) and (rx_sdr_sync(0)='0') and (rx_sdr_sync(1)='1') then
				rx_dvalid_var := '0';
				bit_count_var:= std_logic_vector(to_unsigned( 0 ,bit_count_var'length));
				start_var := '1';
			end if;

			if (to_integer(unsigned(ones_count_int))=6) then
				rx_dvalid_var := '0';
				bit_count_var:= std_logic_vector(to_unsigned( 1 ,bit_count_var'length));
				if (rx_sdr_sync(1)='0') then
					start_var := '1';
				else 
					start_var := '0';
				end if;
			end if;

			if (to_integer(unsigned(ones_count_int))=7) then
				rx_dvalid_var := '0';
				bit_count_var:= std_logic_vector(to_unsigned( 0 ,bit_count_var'length));
				start_var:= '0';
			end if;

		end if;
		
		rx_reg_int <= rx_reg_var ;-- after 1 ns;
		--
		ones_count_int <= ones_count_var ;-- after 1 ns;
		--
		rx_data <= rx_data_var ;-- after 1 ns;
		rx_data_int <=  rx_data_var ;-- after 1 ns;
		--
		bit_count_int  <= bit_count_var ;-- after 1 ns;
		--
		rx_dvalid <= rx_dvalid_var ;-- after 1 ns;
		rx_dvalid_int <= rx_dvalid_var ;-- after 1 ns;
		--
		rx_dstrobe <= rx_dstrobe_var ;-- after 1 ns;
	
		--
		start_int <= start_var ;-- after 1 ns;
		
	end process phy_hdlc_rx;
	
	synchronize_sdr_clock_domain : process (rx_clk, tx_clk) is
	begin
		if rising_edge(rx_clk) then
			rx_sdr_buf1 <= rx_sdr;
		end if;
		if rising_edge(tx_clk) then
			rx_sdr_buf2 <= rx_sdr_buf1;
			rx_sdr_sync <= rx_sdr_buf2;
		end if;
	end process synchronize_sdr_clock_domain;
	

end architecture RTL;

