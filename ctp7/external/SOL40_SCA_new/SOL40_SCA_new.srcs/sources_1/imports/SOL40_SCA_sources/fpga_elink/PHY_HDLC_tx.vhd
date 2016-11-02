--!----------------------------------------------
--!  
--! 	PHY_HDLC_tx in Vhdl
--! 	Based on the work by Sandro Bonacini
--! 
--!		@author Cairo Caplan, CBPF
--!
--!-------------------------------------------------------------------------------------
--
--
--Original comments:
--// missing: tx_sdr_o <=#1 tx_sdr_i;
--// missing: tx_dstrobe_o <=#1 tx_dstrobe_i;
--
-- signals not used: tx_dstrobe_i

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PHY_HDLC_tx is
	port (
		resetb				:	in	std_logic;
		--link side:
		tx_clk				:	in	std_logic;
		tx_sdr				:	out	std_logic_vector(1 downto 0);
		--mac side:
		tx_data				:	in	std_logic_vector(7 downto 0);
		tx_dvalid			:	in 	std_logic; 
		tx_dstrobe			:	out	std_logic
		
	);
end entity PHY_HDLC_tx;


architecture RTL of PHY_HDLC_tx is
	constant IDLE		:	std_logic_vector(1 downto 0):= "00";
	constant START		:	std_logic_vector(1 downto 0):= "01";
	constant TX			:	std_logic_vector(1 downto 0):= "10";
	constant END_state	:	std_logic_vector(1 downto 0):= "11";
	
	signal state					:	std_logic_vector(1 downto 0);
	signal ones_count_int			:	std_logic_vector(2 downto 0);
	signal bit_count_int			:	std_logic_vector(3 downto 0);
	signal tx_sdr_int				:	std_logic_vector(1 downto 0);
	signal tx_reg_int				:	std_logic_vector(8 downto 0);
	signal tx_dvalid_internal_int	:	std_logic;
	
begin
	
	
	phy_hdlc_tx : process (tx_clk, resetb) is
		variable tx_reg_var				:		std_logic_vector(8 downto 0);
		variable tx_sdr_var				:		std_logic_vector(1 downto 0);
		variable ones_count_var			:		std_logic_vector(2 downto 0);
		variable bit_count_var			:		std_logic_vector(3 downto 0);
		variable state_var				:		std_logic_vector(1 downto 0);
		variable tx_dstrobe_var			:		std_logic; 
		variable tx_dvalid_internal_var	:		std_logic; 
	begin
		--if reset
		if resetb = '0' then
			tx_reg_var :=(others=>'1');
			tx_sdr_var(0) := '1';
			tx_sdr_var(1) := '1';
			--one_count=0 , bit_count=0, state=0, tx_dstrobe_o_int=0
			ones_count_var :=  std_logic_vector(to_unsigned( 0 , ones_count_var'length));
			bit_count_var := std_logic_vector(to_unsigned( 0 , bit_count_var'length));
			state_var :=  std_logic_vector(to_unsigned( 0  , state_var'length));
			tx_dstrobe_var := '0';
		--on rising edge of rx clk
		elsif rising_edge(tx_clk) then
			state_var := state;
			bit_count_var := bit_count_int;
			ones_count_var := ones_count_int;
			tx_sdr_var(1) := tx_sdr_int(1);
			tx_sdr_var(0) := tx_sdr_int(0);
			tx_reg_var := tx_reg_int;
			tx_dvalid_internal_var := tx_dvalid_internal_int;

			tx_dstrobe_var := '0';
		
			if (tx_reg_int(0)='1' and tx_reg_int(1)='1') then
				if (to_integer(unsigned(ones_count_int))<6) then
					ones_count_var := std_logic_vector(unsigned(ones_count_int) + 2);
				elsif (to_integer(unsigned(ones_count_int))=6) then
					ones_count_var := std_logic_vector(to_unsigned( 7 , ones_count_var'length));
				end if;
			else
				if (tx_reg_int(1)='0') then
					ones_count_var := std_logic_vector(to_unsigned( 0 , ones_count_var'length));
				else 
					ones_count_var := std_logic_vector(to_unsigned( 1 , ones_count_var'length));
				end if;
			end if;
			
			if (tx_dvalid='0') then
				tx_dvalid_internal_var:= '0';
			end if;

			case (state) is 
				--IDLE state is default
				when START =>
					bit_count_var := std_logic_vector(unsigned(bit_count_int) - 2);
					tx_reg_var := std_logic_vector(unsigned(tx_reg_int) srl 2);
					tx_sdr_var(0) := tx_reg_int(1);
					tx_sdr_var(1) := tx_reg_int(0);
					if ((to_integer(unsigned(bit_count_int))=2) or (to_integer(unsigned(bit_count_int))=1)) then
						state_var := TX;
						tx_reg_var(7 downto 0) := tx_data;
						tx_dstrobe_var := '1';
						bit_count_var:= std_logic_vector(to_unsigned( 8 , bit_count_var'length));
					end if;
					
					if (tx_dvalid='0') then
						state_var := IDLE;
					end if;
			
				when TX =>		
					tx_reg_var := std_logic_vector(unsigned(tx_reg_int) srl 2);
					tx_sdr_var(0) := tx_reg_int(1);
					tx_sdr_var(1) := tx_reg_int(0);
					bit_count_var := std_logic_vector(unsigned(bit_count_int) - 2);

					if (to_integer(unsigned(ones_count_int))/=5) 
						and ((to_integer(unsigned(ones_count_int))/=4) 
							or (tx_reg_int(0)='0')) then
						if (to_integer(unsigned(bit_count_int))=3) then
							if (tx_dvalid_internal_int = '1' and tx_dvalid='1') then
								tx_dstrobe_var := '1';
								bit_count_var := std_logic_vector(to_unsigned( 9 , bit_count_var'length));
								tx_reg_var(8 downto 1) := tx_data;
							else
								bit_count_var := std_logic_vector(to_unsigned( 1 , bit_count_var'length));
								tx_reg_var(8 downto 1) := x"7e";
							end if;
						end if;
						if (to_integer(unsigned(bit_count_int))=2) then
							bit_count_var := std_logic_vector(to_unsigned( 8 , bit_count_var'length));
							if (tx_dvalid_internal_int ='1'  and tx_dvalid ='1') then
								tx_dstrobe_var := '1';
								tx_reg_var(7 downto 0) := tx_data;
							else
								tx_reg_var(8 downto 0) := "101111110";
								state_var := END_state;
							end if;
						end if;
					end if;

					
					if ((to_integer(unsigned(ones_count_int))=4) and tx_reg_int(0)='1') then
						tx_sdr_var(0) := '0';
						tx_sdr_var(1) := '1';
						tx_reg_var := std_logic_vector(unsigned(tx_reg_int) srl 1);
						ones_count_var := std_logic_vector(to_unsigned( 0 , ones_count_var'length));
						bit_count_var :=  std_logic_vector(unsigned(bit_count_int) - 1);
						if (to_integer(unsigned(bit_count_int))=2) then
							bit_count_var := std_logic_vector(to_unsigned( 9 , bit_count_var'length));
							if (tx_dvalid_internal_int = '1'  and tx_dvalid='1') then
								tx_reg_var(8 downto 1) := tx_data;
								tx_dstrobe_var := '1';
							else
								tx_reg_var(8 downto 1) := x"7e";
								state_var := END_state;
							end if;
						end if;
					end if;
					
					if (to_integer(unsigned(ones_count_int))=5) then
						tx_sdr_var(0) := tx_reg_int(0);
						tx_sdr_var(1) := '0';
						tx_reg_var := std_logic_vector(unsigned(tx_reg_int) srl 1);
						
						ones_count_var := (ones_count_var'range=>'0'); 
						ones_count_var(0) :=  tx_reg_int(0);
						
						bit_count_var := std_logic_vector(unsigned(bit_count_int) - 1);
						if (to_integer(unsigned(bit_count_int))=2) then
							bit_count_var := std_logic_vector(to_unsigned( 9 , bit_count_var'length));
							if (tx_dvalid_internal_int = '1' and tx_dvalid ='1') then
								tx_dstrobe_var := '1';
								tx_reg_var(8 downto 1) := tx_data;
							else
								tx_reg_var(8 downto 1) := x"7e";
								state_var := END_state;
							end if;
						end if;
					end if;
					
					if (to_integer(unsigned(bit_count_int))=1) then
						state_var := END_state;
						bit_count_var := std_logic_vector(to_unsigned( 7 , bit_count_var'length));
					end if;
				when END_state =>
					tx_reg_var := std_logic_vector(unsigned(tx_reg_int) srl 2);
					tx_sdr_var(0) := tx_reg_int(1);
					tx_sdr_var(1) := tx_reg_int(0);
					bit_count_var := std_logic_vector(unsigned(bit_count_int) - 2);
					if ((to_integer(unsigned(bit_count_int))=0) or (to_integer(unsigned(bit_count_int))=1)) then
						state_var := IDLE;
					end if;

					if ((to_integer(unsigned(ones_count_int))=5) and (tx_reg_int(0)='1')) then
						tx_sdr_var(0):= '0';
						if (tx_dvalid='1') then
							tx_dvalid_internal_var:= '1';
							state_var := TX;
							tx_reg_var(7 downto 0) := tx_data;
							tx_dstrobe_var := '1';
							bit_count_var:=  std_logic_vector(to_unsigned( 8 , bit_count_var'length));
						else
							tx_reg_var:= '0' & x"7f";
							state_var := IDLE;
						end if;
					end if;

					if (to_integer(unsigned(ones_count_int))=6) then
						tx_sdr_var(1):= '0';
						if (tx_dvalid='1') then
							tx_dvalid_internal_var:= '1';
							state_var := TX;
							tx_reg_var(6 downto 0) := tx_data(7 downto 1);
							tx_sdr_var(0) := tx_data(0);
							tx_dstrobe_var := '1';
							bit_count_var:=  std_logic_vector(to_unsigned( 7 , bit_count_var'length));
							
							ones_count_var := (others=>'0');--
							ones_count_var(0) := tx_data(0); --ones_count_o <=#1 tx_data[0];
						else
							tx_reg_var := '0' & x"7f";
							tx_sdr_var(0):= '1';
							state_var := IDLE;
						end if;
					end if;
				when others =>
					tx_reg_var := std_logic_vector(unsigned(tx_reg_int) srl 2);
					tx_sdr_var(0) := tx_reg_int(1);
					tx_sdr_var(1) := tx_reg_int(0);
					bit_count_var := std_logic_vector(to_unsigned( 8 , bit_count_var'length));
					tx_dvalid_internal_var := '0';
					if ((tx_reg_int(1)='0') or (tx_reg_int(0)='0'))then
						if (tx_dvalid='1') then
							tx_sdr_var := "11";
							tx_reg_var(7 downto 0) := x"7e";
							bit_count_var :=  std_logic_vector(to_unsigned( 8 , bit_count_var'length));
							state_var := START;
							tx_dvalid_internal_var:= '1';
						else 
							tx_reg_var:= '0' & x"7f";
						end if;
					end if;
				end case;
		end if;
		
		
		tx_reg_int <= tx_reg_var;
		--
		tx_sdr <= tx_sdr_var;
		tx_sdr_int <= tx_sdr_var;
		--	
		ones_count_int <= ones_count_var;
		bit_count_int <= bit_count_var;	
		state <= state_var;
		--	
		tx_dstrobe <= tx_dstrobe_var; 
		--tx_dstrobe_int <= tx_dstrobe_var; 
		--
		tx_dvalid_internal_int <= tx_dvalid_internal_var;
			 
	end process phy_hdlc_tx;
	
	
	

end architecture RTL;
