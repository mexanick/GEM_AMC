------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    03:10 2017-11-04
-- Module Name:    link_oh_fpga_rx
-- Description:    this module handles the OH FPGA packet decoding for register data
------------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.gem_pkg.all;

entity link_oh_fpga_rx is
port(

    reset_i                 : in std_logic;
    ttc_clk_40_i            : in std_logic;   
    
    elink_data_i            : in std_logic_vector(9 downto 0);
    
    reg_data_valid_o        : out std_logic;
    reg_data_o              : out std_logic_vector(31 downto 0);
    error_o                 : out std_logic
        
);
end link_oh_fpga_rx;

architecture link_oh_fpga_rx_arch of link_oh_fpga_rx is    

    constant IDLE_CHAR  : std_logic_vector(9 downto 0) := "00" & x"FC";
    constant START_CHAR : std_logic_vector(9 downto 0) := "00" & x"BC";

    type state_t is (IDLE, DATA);
    
    signal state            : state_t := IDLE;
    signal data_frame_cnt   : integer range 0 to 3 := 0;
    
    signal reg_data_valid   : std_logic;
    signal reg_data         : std_logic_vector(31 downto 0);
    
begin  
    
    reg_data_valid_o <= reg_data_valid;
    reg_data_o <= reg_data;
    
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
                        if (elink_data_i = START_CHAR) then
                            state <= DATA;
                            data_frame_cnt <= 0;
                        else
                            state <= IDLE;
                            data_frame_cnt <= 0;
                        end if;
                    when DATA =>
                        if (data_frame_cnt = 3) then
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
    
    --== Register data latching ==--
    
    process(ttc_clk_40_i)
    begin
        if (rising_edge(ttc_clk_40_i)) then
            if (reset_i = '1') then
                reg_data_valid <= '0';
                reg_data <= (others => '0');
            else
                reg_data_valid <= '0';
                if (state = DATA) then
                    reg_data(((3 - data_frame_cnt) * 8) + 7 downto (3 - data_frame_cnt) * 8) <= elink_data_i(7 downto 0);
                    if (data_frame_cnt = 3) then
                        reg_data_valid <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;   
    
    --== Error checking ==--    
    
    process(ttc_clk_40_i)
    begin
        if (rising_edge(ttc_clk_40_i)) then
            if (reset_i = '1') then
                error_o <= '0';
            else
                if (state = IDLE and elink_data_i /= START_CHAR and elink_data_i /= IDLE_CHAR) or
                   (state = DATA and elink_data_i(9 downto 8) /= std_logic_vector(to_unsigned(data_frame_cnt, 2))) then
                    error_o <= '1';
                else
                    error_o <= '0';
                end if;
            end if;
        end if;
    end process;
        
end link_oh_fpga_rx_arch;
