------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    03:10 2017-11-04
-- Module Name:    link_oh_fpga_tx
-- Description:    this module handles the OH FPGA packet encoding for register access and ttc commands
------------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.gem_pkg.all;
use work.ttc_pkg.all;

entity link_oh_fpga_tx is
port(

    reset_i                 : in  std_logic;
    ttc_clk_40_i            : in  std_logic;
    ttc_cmds_i              : in  t_ttc_cmds;
    
    elink_data_o            : out std_logic_vector(9 downto 0);
    
    request_valid_i         : in  std_logic;
    request_write_i         : in  std_logic;
    request_addr_i          : in  std_logic_vector(15 downto 0);
    request_data_i          : in  std_logic_vector(31 downto 0);
    
    busy_o                  : out std_logic
        
);
end link_oh_fpga_tx;

architecture link_oh_fpga_tx_arch of link_oh_fpga_tx is    

    constant IDLE_CHAR  : std_logic_vector(5 downto 0) := "01" & x"C";
    constant START_CHAR : std_logic_vector(5 downto 0) := "10" & x"A";

    type state_t is (IDLE, START, HEADER, DATA);
    
    signal state            : state_t := IDLE;
    signal data_frame_cnt   : integer range 0 to 7 := 0;
    
    signal reg_data         : std_logic_vector(47 downto 0);
    
begin  
    
    busy_o <= '0' when state = IDLE else '1';
    reg_data <= request_addr_i & request_data_i;
    
    --== State FSM ==--

    process(ttc_clk_40_i)
    begin
        if (rising_edge(ttc_clk_40_i)) then
            if (reset_i = '1') then
                state <= IDLE;
                data_frame_cnt <= 0;
            else
                case state is
                    when IDLE =>
                        if (request_valid_i = '1') then
                            state <= START;
                            data_frame_cnt <= 0;
                        else
                            state <= IDLE;
                            data_frame_cnt <= 0;
                        end if;
                    when START =>
                        state <= HEADER;
                        data_frame_cnt <= 0;
                    when HEADER =>
                        state <= DATA;
                        data_frame_cnt <= 0;
                    when DATA =>
                        if (data_frame_cnt = 7) then
                            state <= IDLE;
                        else
                            data_frame_cnt <= data_frame_cnt + 1;
                        end if;
                    when others => 
                        state <= IDLE;
                        data_frame_cnt <= 0;
                end case;
            end if;
        end if;
    end process;
    
    --== Data transmission ==--
    
    process(ttc_clk_40_i)
    begin
        if (rising_edge(ttc_clk_40_i)) then
            if (reset_i = '1') then
                elink_data_o <= (others => '0');
            else
                
                elink_data_o(9 downto 6) <= ttc_cmds_i.l1a & ttc_cmds_i.hard_reset & ttc_cmds_i.resync & ttc_cmds_i.bc0; 
                
                case state is
                    when IDLE =>
                        elink_data_o(5 downto 0) <= IDLE_CHAR;
                    when START =>
                        elink_data_o(5 downto 0) <= START_CHAR;
                    when HEADER =>
                        elink_data_o(5 downto 0) <= "1" & request_write_i & x"b";
                    when DATA =>
                        elink_data_o(5 downto 0) <= reg_data(((7 - data_frame_cnt) * 6) + 5 downto (7 - data_frame_cnt) * 6);
                    when others =>
                        elink_data_o(5 downto 0) <= (others => '0');                 
                end case;
            end if;
        end if;
    end process;   
        
end link_oh_fpga_tx_arch;
