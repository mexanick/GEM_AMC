------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    12:00 2017-08-09
-- Module Name:    VFAT3_RX_LINK
-- Description:    This module decodes the aligned VFAT3 datastream, watches for errors, and separates the DAQ data from the slow control data 
------------------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use work.ttc_pkg.all;
use work.gem_pkg.all;

entity vfat3_rx_link is
    port(
        -- reset
        reset_i             : in  std_logic;
        
        -- clocks
        ttc_clk_i           : in  t_ttc_clks;
        
        -- aligned data link
        data_i              : in  std_logic_vector(7 downto 0);
        sync_ok_i           : in  std_logic;
        
        -- outputs
        ready_o             : out std_logic;
        daq_data_o          : out std_logic_vector(7 downto 0);
        daq_data_en_o       : out std_logic;
        daq_crc_error_o     : out std_logic;
        slow_ctrl_data_o    : out std_logic;
        slow_ctrl_data_en_o : out std_logic 
    );
end vfat3_rx_link;

architecture vfat3_rx_link_arch of vfat3_rx_link is

    constant VFAT3_SC0_WORD : std_logic_vector(7 downto 0) := x"96";
    constant VFAT3_SC1_WORD : std_logic_vector(7 downto 0) := x"99";

begin
    
    ready_o <= sync_ok_i and not reset_i;

    daq_data_o <= (others => '0');
    daq_data_en_o <= '0';
    daq_crc_error_o <= '0';
    slow_ctrl_data_o <= '1' when data_i = VFAT3_SC1_WORD else '0';
    slow_ctrl_data_en_o <= '1' when data_i = VFAT3_SC1_WORD or data_i = VFAT3_SC0_WORD else '0';

end vfat3_rx_link_arch;
