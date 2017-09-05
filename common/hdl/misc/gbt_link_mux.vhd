------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    20:38:00 2016-08-30
-- Module Name:    GBT_LINK_MUX
-- Description:    This module is used to direct the GBT links either to the OH modules (standard operation) or to the GEM_TESTS module 
------------------------------------------------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gem_pkg.all;

entity gbt_link_mux is
    generic(
        g_NUM_OF_OHs                : integer
    );
    port(
        -- links
        gbt_rx_data_arr_i           : in  t_gbt_frame_array(g_NUM_OF_OHs * 3 - 1 downto 0);
        gbt_tx_data_arr_o           : out t_gbt_frame_array(g_NUM_OF_OHs * 3 - 1 downto 0);
        gbt_link_status_arr_i       : in  t_gbt_link_status_arr(g_NUM_OF_OHs * 3 - 1 downto 0);
        
        -- configure
        link_test_mode_i            : in  std_logic;
        use_oh_vfat3_connectors_i   : in  std_logic; -- if set high, then the OH VFAT3 connectors will be used istead of GEB VFAT3 positions #0 and #1
        
        -- real elinks
        sca_tx_data_arr_i           : in  t_std2_array(g_NUM_OF_OHs - 1 downto 0);
        sca_rx_data_arr_o           : out t_std2_array(g_NUM_OF_OHs - 1 downto 0);
        
        gbt_ic_tx_data_arr_i        : in  t_std2_array(g_NUM_OF_OHs * 3 - 1 downto 0);
        gbt_ic_rx_data_arr_o        : out t_std2_array(g_NUM_OF_OHs * 3 - 1 downto 0);
        
        promless_tx_data_arr_i      : in  t_std16_array(g_NUM_OF_OHs - 1 downto 0);
        
        oh_fpga_tx_data_arr_i       : in  t_std10_array(g_NUM_OF_OHs - 1 downto 0);
        oh_fpga_rx_data_arr_o       : out t_std14_array(g_NUM_OF_OHs - 1 downto 0);
        
        vfat3_tx_data_arr_i         : in  t_vfat3_elinks_arr(g_NUM_OF_OHs - 1 downto 0);
        vfat3_rx_data_arr_o         : out t_vfat3_elinks_arr(g_NUM_OF_OHs - 1 downto 0);
        
        gbt_ready_arr_o             : out std_logic_vector(g_NUM_OF_OHs * 3 - 1 downto 0);
        
        -- to tests module
        tst_gbt_rx_data_arr_o       : out t_gbt_frame_array((g_NUM_OF_OHs * 3) - 1 downto 0);
        tst_gbt_tx_data_arr_i       : in  t_gbt_frame_array((g_NUM_OF_OHs * 3) - 1 downto 0);
        tst_gbt_ready_arr_o         : out std_logic_vector((g_NUM_OF_OHs * 3) - 1 downto 0)
    );
end gbt_link_mux;

architecture Behavioral of gbt_link_mux is

    signal real_gbt_tx_data         : t_gbt_frame_array(g_NUM_OF_OHs * 3 - 1 downto 0);
    signal real_gbt_rx_data         : t_gbt_frame_array(g_NUM_OF_OHs * 3 - 1 downto 0);
    signal gbt_rx_ready_arr         : std_logic_vector((g_NUM_OF_OHs * 3) - 1 downto 0);

begin

    gbt_tx_data_arr_o <= real_gbt_tx_data when link_test_mode_i = '0' else tst_gbt_tx_data_arr_i;
    real_gbt_rx_data <= gbt_rx_data_arr_i when link_test_mode_i = '0' else (others => (others => '0'));
    gbt_ready_arr_o <= gbt_rx_ready_arr when link_test_mode_i = '0' else (others => '0');
    
    tst_gbt_rx_data_arr_o <= gbt_rx_data_arr_i when link_test_mode_i = '1' else (others => (others => '0'));
    tst_gbt_ready_arr_o <= gbt_rx_ready_arr when link_test_mode_i = '1' else (others => '0');

    g_ohs : for i in 0 to g_NUM_OF_OHs - 1 generate
    
        --------- RX ---------
        sca_rx_data_arr_o(i) <= real_gbt_rx_data(i * 3 + 0)(81 downto 80);
        
        gbt_ic_rx_data_arr_o(i * 3 + 0) <= real_gbt_rx_data(i * 3 + 0)(83 downto 82);
        gbt_ic_rx_data_arr_o(i * 3 + 1) <= real_gbt_rx_data(i * 3 + 1)(83 downto 82);
        gbt_ic_rx_data_arr_o(i * 3 + 2) <= real_gbt_rx_data(i * 3 + 2)(83 downto 82);

        gbt_rx_ready_arr(i * 3 + 0) <= gbt_link_status_arr_i(i * 3 + 0).gbt_rx_ready;
        gbt_rx_ready_arr(i * 3 + 1) <= gbt_link_status_arr_i(i * 3 + 1).gbt_rx_ready;
        gbt_rx_ready_arr(i * 3 + 2) <= gbt_link_status_arr_i(i * 3 + 2).gbt_rx_ready;
        
        oh_fpga_rx_data_arr_o(i) <= real_gbt_rx_data(i * 3 + 0)(79 downto 72) & real_gbt_rx_data(i * 3)(57 downto 56) & real_gbt_rx_data(i * 3)(49 downto 48) & real_gbt_rx_data(i * 3)(33 downto 32);
        
        vfat3_rx_data_arr_o(i)(0)  <= real_gbt_rx_data(i * 3 + 0)(71 downto 64) when use_oh_vfat3_connectors_i = '0' else real_gbt_rx_data(i * 3 + 1)(7 downto 0);
        vfat3_rx_data_arr_o(i)(1)  <= real_gbt_rx_data(i * 3 + 2)(79 downto 72) when use_oh_vfat3_connectors_i = '0' else real_gbt_rx_data(i * 3 + 2)(7 downto 0);
        vfat3_rx_data_arr_o(i)(2)  <= real_gbt_rx_data(i * 3 + 2)(31 downto 24);
        vfat3_rx_data_arr_o(i)(3)  <= real_gbt_rx_data(i * 3 + 2)(23 downto 16);
        vfat3_rx_data_arr_o(i)(4)  <= real_gbt_rx_data(i * 3 + 2)(63 downto 56);
        vfat3_rx_data_arr_o(i)(5)  <= real_gbt_rx_data(i * 3 + 2)(55 downto 48);
        vfat3_rx_data_arr_o(i)(6)  <= real_gbt_rx_data(i * 3 + 2)(71 downto 64);
        vfat3_rx_data_arr_o(i)(7)  <= real_gbt_rx_data(i * 3 + 1)(63 downto 56);
        vfat3_rx_data_arr_o(i)(8)  <= real_gbt_rx_data(i * 3 + 0)(7 downto 0);
        vfat3_rx_data_arr_o(i)(9)  <= real_gbt_rx_data(i * 3 + 0)(15 downto 8);
        vfat3_rx_data_arr_o(i)(10) <= real_gbt_rx_data(i * 3 + 0)(23 downto 16);
        vfat3_rx_data_arr_o(i)(11) <= real_gbt_rx_data(i * 3 + 0)(31 downto 24);
        vfat3_rx_data_arr_o(i)(12) <= real_gbt_rx_data(i * 3 + 2)(39 downto 32);
        vfat3_rx_data_arr_o(i)(13) <= real_gbt_rx_data(i * 3 + 2)(47 downto 40);
        vfat3_rx_data_arr_o(i)(14) <= real_gbt_rx_data(i * 3 + 2)(15 downto 8);
        vfat3_rx_data_arr_o(i)(15) <= real_gbt_rx_data(i * 3 + 1)(39 downto 32);
        vfat3_rx_data_arr_o(i)(16) <= real_gbt_rx_data(i * 3 + 0)(47 downto 40);
        vfat3_rx_data_arr_o(i)(17) <= real_gbt_rx_data(i * 3 + 1)(55 downto 48);
        vfat3_rx_data_arr_o(i)(18) <= real_gbt_rx_data(i * 3 + 1)(71 downto 64);
        vfat3_rx_data_arr_o(i)(19) <= real_gbt_rx_data(i * 3 + 1)(15 downto 8);
        vfat3_rx_data_arr_o(i)(20) <= real_gbt_rx_data(i * 3 + 1)(31 downto 24);
        vfat3_rx_data_arr_o(i)(21) <= real_gbt_rx_data(i * 3 + 1)(23 downto 16);
        vfat3_rx_data_arr_o(i)(22) <= real_gbt_rx_data(i * 3 + 1)(79 downto 72);
        vfat3_rx_data_arr_o(i)(23) <= real_gbt_rx_data(i * 3 + 1)(47 downto 40);

        --------- TX ---------
        real_gbt_tx_data(i * 3 + 0)(81 downto 80) <= sca_tx_data_arr_i(i);
        real_gbt_tx_data(i * 3 + 1)(81 downto 80) <= (others => '0');
        real_gbt_tx_data(i * 3 + 2)(81 downto 80) <= (others => '0');
        
        real_gbt_tx_data(i * 3 + 0)(83 downto 82) <= gbt_ic_tx_data_arr_i(i * 3 + 0);
        real_gbt_tx_data(i * 3 + 1)(83 downto 82) <= gbt_ic_tx_data_arr_i(i * 3 + 1);
        real_gbt_tx_data(i * 3 + 2)(83 downto 82) <= gbt_ic_tx_data_arr_i(i * 3 + 2);

        real_gbt_tx_data(i * 3 + 0)(79 downto 72) <= oh_fpga_tx_data_arr_i(i)(9 downto 2);
        real_gbt_tx_data(i * 3 + 0)(57 downto 56) <= oh_fpga_tx_data_arr_i(i)(1 downto 0);
        real_gbt_tx_data(i * 3 + 0)(63 downto 58) <= (others => '0');

        real_gbt_tx_data(i * 3 + 0)(55 downto 48) <= promless_tx_data_arr_i(i)(15 downto 8);
        real_gbt_tx_data(i * 3 + 0)(39 downto 32) <= promless_tx_data_arr_i(i)(7 downto 0);
        
        real_gbt_tx_data(i * 3 + 1)(7 downto 0)   <= vfat3_tx_data_arr_i(i)(0) when use_oh_vfat3_connectors_i = '1' else (others => '0'); -- test VFAT3 slot 1 on the OH
        real_gbt_tx_data(i * 3 + 2)(7 downto 0)   <= vfat3_tx_data_arr_i(i)(1) when use_oh_vfat3_connectors_i = '1' else (others => '0'); -- test VFAT3 slot 2 on the OH
        real_gbt_tx_data(i * 3 + 0)(71 downto 64) <= vfat3_tx_data_arr_i(i)(0) when use_oh_vfat3_connectors_i = '0' else (others => '0'); -- real slot 0 on the GEB 
        real_gbt_tx_data(i * 3 + 2)(79 downto 72) <= vfat3_tx_data_arr_i(i)(1) when use_oh_vfat3_connectors_i = '0' else (others => '0'); -- real slot 1 on the GEB
        real_gbt_tx_data(i * 3 + 2)(31 downto 24) <= vfat3_tx_data_arr_i(i)(2);
        real_gbt_tx_data(i * 3 + 2)(23 downto 16) <= vfat3_tx_data_arr_i(i)(3); 
        real_gbt_tx_data(i * 3 + 2)(63 downto 56) <= vfat3_tx_data_arr_i(i)(4);
        real_gbt_tx_data(i * 3 + 2)(55 downto 48) <= vfat3_tx_data_arr_i(i)(5);
        real_gbt_tx_data(i * 3 + 2)(71 downto 64) <= vfat3_tx_data_arr_i(i)(6); 
        real_gbt_tx_data(i * 3 + 1)(63 downto 56) <= vfat3_tx_data_arr_i(i)(7); 
        real_gbt_tx_data(i * 3 + 0)(7 downto 0)   <= vfat3_tx_data_arr_i(i)(8);
        real_gbt_tx_data(i * 3 + 0)(15 downto 8)  <= vfat3_tx_data_arr_i(i)(9);
        real_gbt_tx_data(i * 3 + 0)(23 downto 16) <= vfat3_tx_data_arr_i(i)(10);
        real_gbt_tx_data(i * 3 + 0)(31 downto 24) <= vfat3_tx_data_arr_i(i)(11);
        real_gbt_tx_data(i * 3 + 2)(39 downto 32) <= vfat3_tx_data_arr_i(i)(12);
        real_gbt_tx_data(i * 3 + 2)(47 downto 40) <= vfat3_tx_data_arr_i(i)(13);
        real_gbt_tx_data(i * 3 + 2)(15 downto 8)  <= vfat3_tx_data_arr_i(i)(14);
        real_gbt_tx_data(i * 3 + 1)(39 downto 32) <= vfat3_tx_data_arr_i(i)(15);
        real_gbt_tx_data(i * 3 + 0)(47 downto 40) <= vfat3_tx_data_arr_i(i)(16); -- problematic because it sits on the same group as the promless elinks, so can run only at 80MHz
        real_gbt_tx_data(i * 3 + 1)(55 downto 48) <= vfat3_tx_data_arr_i(i)(17);
        real_gbt_tx_data(i * 3 + 1)(71 downto 64) <= vfat3_tx_data_arr_i(i)(18);
        real_gbt_tx_data(i * 3 + 1)(15 downto 8)  <= vfat3_tx_data_arr_i(i)(19);
        real_gbt_tx_data(i * 3 + 1)(31 downto 24) <= vfat3_tx_data_arr_i(i)(20);
        real_gbt_tx_data(i * 3 + 1)(23 downto 16) <= vfat3_tx_data_arr_i(i)(21);
        real_gbt_tx_data(i * 3 + 1)(79 downto 72) <= vfat3_tx_data_arr_i(i)(22);
        real_gbt_tx_data(i * 3 + 1)(47 downto 40) <= vfat3_tx_data_arr_i(i)(23);
        
    end generate;

    
end Behavioral;
